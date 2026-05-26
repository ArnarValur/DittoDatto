<script setup lang="ts">
import { z } from 'zod'
import type { FormSubmitEvent } from '#ui/types'
import type { Service } from '@dittodatto/shared-types'
import { collection, addDoc, doc, updateDoc, deleteDoc } from 'firebase/firestore'

/**
 * ServiceFormSlideover
 *
 * Create/Edit services for a store. Supports:
 * - Cover image picker (from Media Gallery)
 * - Gallery images (multiple)
 * - Time range (availability window)
 * - Staff attachment (TODO: wire when staff management ready)
 * - Delete functionality
 */

const props = defineProps<{
  service?: Partial<Service>
  open?: boolean
}>()

const emit = defineEmits<{
  (e: 'close'): void
  (e: 'update:open', value: boolean): void
  (e: 'saved'): void
  (e: 'deleted'): void
}>()

const { companyId, company } = useCompany()
const { stores } = useStores()
const { staff: staffMembers } = useStaff()
const { allResourceGroups, groupsByStore } = useResourceGroups()
const db = useFirestore()
const toast = useToast()
const loading = ref(false)
const deleting = ref(false)
const showDeleteConfirm = ref(false)
const form = ref()

// Compute whether we're in edit mode
const isEditMode = computed(() => !!props.service?.id)

// Form State
const state = reactive({
  title: '',
  description: '',
  storeId: '',
  groupId: '__none__' as string,

  // Booking Mode
  bookingMode: 'standard' as 'standard' | 'tableReservation' | 'ticketSystem',

  // Media
  coverImage: '',
  gallery: [] as string[],

  // Time & Pricing
  duration: 60,
  price: 0,
  currency: 'NOK',
  bufferTime: 0,

  // Staff assignment
  assignedStaffIds: [] as string[],

  // Required resources (tables, rooms, etc.)
  requiredResourceGroupIds: [] as string[],
})

// Get service groups for the selected store
const selectedStoreId = computed(() => state.storeId)
const selectedGroupId = computed(() => state.groupId)
const { groups: serviceGroups } = useServiceGroups(selectedStoreId)

// Auto-select store if only one exists
const autoStoreId = computed(() =>
  stores.value?.length === 1 ? stores.value[0].id : ''
)

// Sync form state when editing
watch(() => props.service, (s) => {
  if (s) {
    state.title = s.title || ''
    state.description = s.description || ''
    state.storeId = s.storeId || ''
    state.groupId = (s as Service).groupId || '__none__'
    state.bookingMode = s.bookingMode || 'standard'
    state.coverImage = s.coverImage || ''
    state.gallery = s.gallery || []
    state.duration = s.duration || 60
    state.price = s.price || 0
    state.currency = s.currency || 'NOK'
    state.bufferTime = s.bufferTime || 0
    state.assignedStaffIds = (s as any).assignedStaffIds || []
    state.requiredResourceGroupIds = (s as any).requiredResourceGroupIds || []
  } else {
    // Reset form for create mode
    Object.assign(state, {
      title: '',
      description: '',
      storeId: autoStoreId.value,
      groupId: '__none__',
      bookingMode: 'standard',
      coverImage: '',
      gallery: [],
      duration: 60,
      price: 0,
      currency: 'NOK',
      bufferTime: 0,
      assignedStaffIds: [],
      requiredResourceGroupIds: [],
    })
  }
}, { immediate: true })

// Schema for form validation
const FormSchema = z.object({
  title: z.string().min(1, 'Title is required'),
  description: z.string().optional(),
  storeId: z.string().min(1, 'Store is required'),
  groupId: z.string().optional(),
  bookingMode: z.enum(['standard', 'tableReservation', 'ticketSystem']).default('standard'),
  coverImage: z.string().optional(),
  gallery: z.array(z.string()).default([]),
  duration: z.number().int().positive('Duration must be positive'),
  price: z.number().min(0, 'Price must be 0 or more'),
  currency: z.string().default('NOK'),
  bufferTime: z.number().int().min(0).default(0),
  assignedStaffIds: z.array(z.string()).default([]),
  requiredResourceGroupIds: z.array(z.string()).default([]),
})

type FormData = z.infer<typeof FormSchema>

// Service group options for dropdown
const groupOptions = computed(() => {
  const options = [{ label: 'No Group (use store defaults)', value: '__none__' }]
  for (const group of serviceGroups.value) {
    options.push({ label: group.name, value: group.id })
  }
  return options
})

// Establishment options
const establishmentOptions = computed(() => {
  return stores.value?.map(store => ({
    label: store.name,
    value: store.id,
    icon: 'i-lucide-store'
  })) ?? []
})

// Staff options for multi-select — prioritize active establishment's staff pool
const staffOptions = computed(() => {
  const all = staffMembers.value ?? []
  const currentStoreId = state.storeId

  // Partition: this store's staff first, then others
  const thisStore: typeof all = []
  const otherStores: typeof all = []

  for (const s of all) {
    if (s.status === 'removed') continue
    if (currentStoreId && s.storeIds?.includes(currentStoreId)) {
      thisStore.push(s)
    } else {
      otherStores.push(s)
    }
  }

  const items: Array<{ label: string; value: string; avatar?: string; disabled?: boolean }> = []

  // This store's staff (always shown first)
  for (const s of thisStore) {
    items.push({
      label: s.displayName || s.email,
      value: s.id,
      avatar: s.avatarUrl,
    })
  }

  // Divider + other locations (still selectable for cross-store assignment)
  if (otherStores.length > 0 && thisStore.length > 0) {
    items.push({ label: '── Other locations ──', value: '__divider__', disabled: true })
  }
  for (const s of otherStores) {
    items.push({
      label: s.displayName || s.email,
      value: s.id,
      avatar: s.avatarUrl,
    })
  }

  return items
})

// Booking mode options - based on company enabled features
// Always show 'standard', others depend on feature flags
const bookingModeOptions = computed(() => {
  const options = [
    { label: 'Standard (Appointments)', value: 'standard', icon: 'i-lucide-calendar-check', description: '1:1 time-based bookings' }
  ]

  if (company.value?.enabledFeatures?.tableReservation) {
    options.push({
      label: 'Table/Group Reservation',
      value: 'tableReservation',
      icon: 'i-lucide-users',
      description: 'Capacity-based group bookings'
    })
  }

  if (company.value?.enabledFeatures?.ticketSystem) {
    options.push({
      label: 'Ticketing',
      value: 'ticketSystem',
      icon: 'i-lucide-ticket',
      description: 'Event tickets / inventory-based'
    })
  }

  return options
})

// Duration presets
const durationOptions = [
  { label: '15 min', value: 15 },
  { label: '30 min', value: 30 },
  { label: '45 min', value: 45 },
  { label: '1 hour', value: 60 },
  { label: '1.5 hours', value: 90 },
  { label: '2 hours', value: 120 },
  { label: '3 hours', value: 180 }
]


// Resource group options for the selected store
const resourceGroupOptions = computed(() => {
  if (!state.storeId) return []
  const groups = groupsByStore(state.storeId)
  return groups.map(g => ({
    label: g.name,
    value: g.id
  }))
})

async function onSubmit(event: FormSubmitEvent<FormData>) {
  if (!companyId.value || !state.storeId) return

  loading.value = true
  try {
    // Helper to remove undefined values (Firestore doesn't accept them)
    const scrubUndefined = <T extends object>(obj: T): Partial<T> =>
      Object.fromEntries(Object.entries(obj).filter(([_, v]) => v !== undefined)) as Partial<T>

    const payload = scrubUndefined({
      ...event.data,
      groupId: event.data.groupId === '__none__' ? undefined : event.data.groupId,
      assignedStaffIds: event.data.assignedStaffIds || [],
      requiredResourceGroupIds: event.data.requiredResourceGroupIds || [],
      keywords: [],
      isActive: true,
      updatedAt: new Date()
    })

    if (isEditMode.value) {
      // Update
      await updateDoc(
        doc(db, 'companies', companyId.value, 'stores', state.storeId, 'services', props.service!.id!),
        payload
      )
      toast.add({ title: 'Service updated', color: 'success' })
    } else {
      // Create
      await addDoc(
        collection(db, 'companies', companyId.value, 'stores', state.storeId, 'services'),
        { ...payload, createdAt: new Date() }
      )
      toast.add({ title: 'Service created', color: 'success' })
    }

    emit('saved')
    handleClose()
  } catch (err: unknown) {
    console.error(err)
    toast.add({ title: 'Error', description: (err as Error).message, color: 'error' })
  } finally {
    loading.value = false
  }
}

async function handleDelete() {
  if (!companyId.value || !state.storeId || !props.service?.id) return

  deleting.value = true
  try {
    await deleteDoc(
      doc(db, 'companies', companyId.value, 'stores', state.storeId, 'services', props.service.id)
    )
    toast.add({ title: 'Service deleted', color: 'success' })
    emit('deleted')
    handleClose()
  } catch (err: unknown) {
    console.error(err)
    toast.add({ title: 'Error', description: (err as Error).message, color: 'error' })
  } finally {
    deleting.value = false
    showDeleteConfirm.value = false
  }
}

function handleClose() {
  emit('update:open', false)
  emit('close')
}
</script>

<template>
  <USlideover
    :open="open ?? true"
    :title="isEditMode ? 'Edit Service Item' : 'Add Service Item'"
    @update:open="(val) => emit('update:open', val)"
  >
    <template #body>
      <UForm
        ref="form"
        :schema="FormSchema"
        :state="state"
        class="space-y-4 p-4"
        @submit="onSubmit"
      >
        <!-- Basic Info -->
        <UFormField label="Service Title" name="title" required>
          <UInput v-model="state.title" placeholder="e.g. Dinner, Lunch, Haircut" />
        </UFormField>

        <UFormField label="Description" name="description">
          <UTextarea v-model="state.description" placeholder="Brief description of the service..." />
        </UFormField>

        <UFormField
          v-if="establishmentOptions.length > 1"
          label="Establishment"
          name="storeId"
          required
          help="Which establishment offers this service?"
        >
          <USelectMenu
            v-model="state.storeId"
            :items="establishmentOptions"
            value-key="value"
            placeholder="Select an establishment"
            :disabled="isEditMode"
          >
            <template #item="{ item }">
              <div class="flex items-center gap-2">
                <UIcon :name="item.icon" class="size-4" />
                <span>{{ item.label }}</span>
              </div>
            </template>
          </USelectMenu>
        </UFormField>

        <UFormField
          v-if="state.storeId && groupOptions.length > 1"
          label="Service Group"
          name="groupId"
          help="Optional - inherit settings from a group"
        >
          <USelectMenu
            v-model="state.groupId"
            :items="groupOptions"
            value-key="value"
            placeholder="Select a group (optional)"
            class="w-48"
          >
            <template #item="{ item }">
              <div class="flex items-center gap-2">
                <UIcon :name="item.value ? 'i-lucide-folder' : 'i-lucide-layers'" class="size-4" />
                <span>{{ item.label }}</span>
              </div>
            </template>
          </USelectMenu>
        </UFormField>

        <UFormField
          label="Booking Mode"
          name="bookingMode"
          help="How do customers book this service?"
        >
          <USelectMenu
            v-model="state.bookingMode"
            :items="bookingModeOptions"
            value-key="value"
            class="w-64"
          >
            <template #item="{ item }">
              <div class="flex items-center gap-2">
                <UIcon :name="item.icon" class="size-4" />
                <div class="flex flex-col">
                  <span>{{ item.label }}</span>
                  <span class="text-xs text-muted">{{ item.description }}</span>
                </div>
              </div>
            </template>
          </USelectMenu>
        </UFormField>

        <USeparator label="Media" />

        <!-- Cover Image -->
        <UFormField label="Cover Image" name="coverImage" hint="Main image shown on the service card">
          <DDMediaPickerButton
            v-model="state.coverImage"
            :company-id="companyId || ''"
            :store-id="state.storeId || undefined"
            :filter-tags="['service', 'cover']"
            label="Choose Cover"
            placeholder="Select from media library"
          />
        </UFormField>

        <!-- Gallery -->
        <UFormField label="Gallery Images" name="gallery" hint="Additional images for detail modal" class="hidden">
          <div class="space-y-3">
            <div v-if="state.gallery.length > 0" class="grid grid-cols-4 gap-2">
              <div
                v-for="(img, index) in state.gallery"
                :key="index"
                class="relative aspect-square rounded-lg overflow-hidden group"
              >
                <NuxtImg :src="img" :alt="`Gallery ${index + 1}`" class="w-full h-full object-cover" loading="lazy" sizes="100px" />
                <button
                  type="button"
                  class="absolute top-1 right-1 size-5 bg-red-500 text-white rounded-full opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center"
                  @click="state.gallery.splice(index, 1)"
                >
                  <UIcon name="i-lucide-x" class="size-3" />
                </button>
              </div>
            </div>
            <DDMediaPickerButton
              :model-value="''"
              :company-id="companyId || ''"
            :store-id="state.storeId || undefined"
              :filter-tags="['service', 'gallery']"
              label="Add to Gallery"
              placeholder="Select images"
              @update:model-value="(url: string) => url && state.gallery.push(url)"
            />
          </div>
        </UFormField>

        <USeparator label="Timing & Pricing" />

        <!-- Duration + Price -->
        <div class="grid grid-cols-2 gap-4">
          <UFormField label="Duration" name="duration" required>
            <USelectMenu
              v-model="state.duration"
              :items="durationOptions"
              value-key="value"
            />
          </UFormField>

          <UFormField label="Price (NOK)" name="price" required>
            <UInput
              v-model.number="state.price"
              type="number"
              min="0"
              step="10"
            />
          </UFormField>
        </div>

        <!-- Buffer Time -->
        <UFormField label="Buffer Time" name="bufferTime" help="Minutes gap between bookings">
          <UInput
            v-model.number="state.bufferTime"
            type="number"
            min="0"
            step="5"
          />
        </UFormField>

        <USeparator label="Staff" />

        <UFormField
          label="Assigned Staff"
          name="assignedStaffIds"
          help="Which team members can perform this service?"
        >
          <USelectMenu
            v-model="state.assignedStaffIds"
            :items="staffOptions"
            value-key="value"
            multiple
            placeholder="Select staff members"
            class="w-full"
          >
            <template #label>
              <span v-if="state.assignedStaffIds.length === 0" class="text-muted">All staff (default)</span>
              <span v-else>{{ state.assignedStaffIds.length }} staff assigned</span>
            </template>
            <template #item="{ item }">
              <div class="flex items-center gap-2">
                <UAvatar :src="item.avatar" :alt="item.label" size="2xs" />
                <span>{{ item.label }}</span>
              </div>
            </template>
          </USelectMenu>
        </UFormField>

        <!-- Required Resources -->
        <USeparator v-if="resourceGroupOptions.length > 0" label="Required Resources" />

        <UFormField
          v-if="resourceGroupOptions.length > 0"
          label="Required Resource Groups"
          name="requiredResourceGroupIds"
          help="Which resource groups are needed for this service? Leave empty if none."
        >
          <USelectMenu
            v-model="state.requiredResourceGroupIds"
            :items="resourceGroupOptions"
            value-key="value"
            multiple
            placeholder="Select resource groups"
            class="w-full"
          >
            <template #label>
              <span v-if="state.requiredResourceGroupIds.length === 0" class="text-muted">No resources required</span>
              <span v-else>{{ state.requiredResourceGroupIds.length }} group(s) required</span>
            </template>
            <template #item="{ item }">
              <div class="flex items-center gap-2">
                <UIcon name="i-lucide-boxes" class="size-4 text-amber-400" />
                <span>{{ item.label }}</span>
              </div>
            </template>
          </USelectMenu>
        </UFormField>
      </UForm>
    </template>

    <template #footer>
      <div class="flex items-center justify-between p-4">
        <!-- Delete button (edit mode only) -->
        <div>
          <UButton
            v-if="isEditMode && !showDeleteConfirm"
            label="Delete"
            color="error"
            variant="ghost"
            icon="i-lucide-trash-2"
            @click="showDeleteConfirm = true"
          />
          <div v-if="showDeleteConfirm" class="flex items-center gap-2">
            <span class="text-sm text-error">Delete this service?</span>
            <UButton
              label="Yes"
              color="error"
              size="xs"
              :loading="deleting"
              @click="handleDelete"
            />
            <UButton
              label="No"
              color="neutral"
              variant="ghost"
              size="xs"
              @click="showDeleteConfirm = false"
            />
          </div>
        </div>

        <div class="flex gap-2">
          <UButton
            label="Cancel"
            color="neutral"
            variant="ghost"
            @click="handleClose"
          />
          <UButton
            :label="isEditMode ? 'Update' : 'Create'"
            color="primary"
            :loading="loading"
            @click="form?.submit()"
          />
        </div>
      </div>
    </template>
  </USlideover>
</template>
