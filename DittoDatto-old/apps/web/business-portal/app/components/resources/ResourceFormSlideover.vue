<script setup lang="ts">
import { z } from 'zod'
import type { FormSubmitEvent } from '#ui/types'
import type { Resource, ResourceGroup } from '@dittodatto/shared-types'
import { getFunctions, httpsCallable } from 'firebase/functions'
import { getApp } from 'firebase/app'

/**
 * ResourceFormSlideover
 *
 * Create/Edit individual resources (tables, rooms, stations, equipment, add-ons).
 */

const props = defineProps<{
  resource?: Partial<Resource> & { id?: string }
  storeId: string
  companyId: string
  groups: ResourceGroup[]
  open?: boolean
}>()

const emit = defineEmits<{
  (e: 'close'): void
  (e: 'update:open', value: boolean): void
  (e: 'saved'): void
  (e: 'deleted'): void
}>()

const functions = getFunctions(getApp(), 'europe-west1')
const toast = useToast()
const loading = ref(false)
const deleting = ref(false)
const showDeleteConfirm = ref(false)
const form = ref()

const isEditMode = computed(() => !!props.resource?.id)

const state = reactive({
  name: '',
  description: '',
  type: 'table' as 'room' | 'table' | 'station' | 'equipment' | 'addon',
  resourceGroupId: undefined as string | undefined,
  minCapacity: 1,
  maxCapacity: 1,
  price: undefined as number | undefined,
  currency: 'NOK',
  isBookable: true,
  allowOverlapping: false,
  bookingInterval: undefined as number | undefined,
  priority: 'normal' as 'low' | 'normal' | 'high',
  sortOrder: 0
})

watch(() => props.resource, (r) => {
  if (r) {
    state.name = r.name || ''
    state.description = r.description || ''
    state.type = r.type || 'table'
    state.resourceGroupId = r.resourceGroupId || undefined
    state.minCapacity = r.minCapacity ?? 1
    state.maxCapacity = r.maxCapacity ?? 1
    state.price = r.price
    state.currency = r.currency || 'NOK'
    state.isBookable = r.isBookable ?? true
    state.allowOverlapping = r.allowOverlapping ?? false
    state.bookingInterval = r.bookingInterval
    state.priority = r.priority || 'normal'
    state.sortOrder = r.sortOrder ?? 0
  } else {
    Object.assign(state, {
      name: '', description: '', type: 'table',
      resourceGroupId: undefined, minCapacity: 1, maxCapacity: 1,
      price: undefined, currency: 'NOK', isBookable: true,
      allowOverlapping: false, bookingInterval: undefined,
      priority: 'normal', sortOrder: 0
    })
  }
}, { immediate: true })

const FormSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  description: z.string().optional(),
  type: z.enum(['room', 'table', 'station', 'equipment', 'addon']),
  resourceGroupId: z.string().optional(),
  minCapacity: z.number().int().min(1).default(1),
  maxCapacity: z.number().int().min(1).default(1),
  price: z.number().min(0).optional(),
  currency: z.string().length(3).default('NOK'),
  isBookable: z.boolean().default(true),
  allowOverlapping: z.boolean().default(false),
  bookingInterval: z.number().int().min(5).optional(),
  priority: z.enum(['low', 'normal', 'high']).default('normal'),
  sortOrder: z.number().int().default(0)
})

type FormData = z.infer<typeof FormSchema>

const typeOptions = [
  { label: 'Table', value: 'table', icon: 'i-lucide-armchair', description: 'Restaurant tables, bar seating' },
  { label: 'Room', value: 'room', icon: 'i-lucide-door-open', description: 'Treatment rooms, event halls' },
  { label: 'Station', value: 'station', icon: 'i-lucide-scissors', description: 'Hair stations, nail desks' },
  { label: 'Equipment', value: 'equipment', icon: 'i-lucide-monitor', description: 'Projector, sound system' },
  { label: 'Add-on', value: 'addon', icon: 'i-lucide-package-plus', description: 'Beer Keg, Bartender (has price)' },
]

const priorityOptions = [
  { label: 'Low', value: 'low' },
  { label: 'Normal', value: 'normal' },
  { label: 'High', value: 'high' }
]

const groupOptions = computed(() => [
  { label: 'No group (standalone)', value: '__none__' },
  ...props.groups.map(g => ({ label: g.name, value: g.id }))
])

const isAddon = computed(() => state.type === 'addon')
const isTable = computed(() => state.type === 'table')

async function onSubmit(event: FormSubmitEvent<FormData>) {
  if (!props.storeId || !props.companyId) return

  loading.value = true
  try {
    // Clean payload
    const payload: Record<string, unknown> = { ...event.data }
    // Convert sentinel value back to no-group
    if (!payload.resourceGroupId || payload.resourceGroupId === '__none__') delete payload.resourceGroupId
    if (payload.price === undefined || payload.price === null) delete payload.price
    if (payload.bookingInterval === undefined) delete payload.bookingInterval

    if (isEditMode.value) {
      const updateFn = httpsCallable(functions, 'resources_update')
      await updateFn({
        resourceId: props.resource!.id,
        storeId: props.storeId,
        companyId: props.companyId,
        ...payload
      })
      toast.add({ title: 'Resource updated', color: 'success' })
    } else {
      const createFn = httpsCallable(functions, 'resources_create')
      await createFn({
        storeId: props.storeId,
        companyId: props.companyId,
        ...payload
      })
      toast.add({ title: 'Resource created', color: 'success' })
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
  if (!props.resource?.id || !props.storeId || !props.companyId) return

  deleting.value = true
  try {
    const deleteFn = httpsCallable(functions, 'resources_delete')
    await deleteFn({
      resourceId: props.resource.id,
      storeId: props.storeId,
      companyId: props.companyId
    })
    toast.add({ title: 'Resource deleted', color: 'success' })
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
    :dismissible="false"
    :title="isEditMode ? 'Edit Resource' : 'Create Resource'"
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
        <UFormField label="Name" name="name" required>
          <UInput v-model="state.name" placeholder="e.g. Table 5, VIP Suite, Beer Keg" />
        </UFormField>

        <UFormField label="Type" name="type" required>
          <USelectMenu
            v-model="state.type"
            :items="typeOptions"
            value-key="value"
            class="w-full"
          >
            <template #item="{ item }">
              <div class="flex items-center gap-2">
                <UIcon :name="item.icon" class="size-4" />
                <div>
                  <span class="font-medium">{{ item.label }}</span>
                  <span class="text-xs text-muted ml-1">{{ item.description }}</span>
                </div>
              </div>
            </template>
          </USelectMenu>
        </UFormField>

        <UFormField label="Group / Area" name="resourceGroupId">
          <USelectMenu
            v-model="state.resourceGroupId"
            :items="groupOptions"
            value-key="value"
            placeholder="No group"
            class="w-full"
          />
        </UFormField>

        <UFormField label="Description" name="description">
          <UTextarea v-model="state.description" placeholder="Optional description..." />
        </UFormField>

        <!-- Capacity (relevant for tables/rooms) -->
        <USeparator v-if="isTable || state.type === 'room'" label="Capacity" />

        <div v-if="isTable || state.type === 'room'" class="grid grid-cols-2 gap-4">
          <UFormField label="Min Guests" name="minCapacity" hint="Minimum seats">
            <UInput v-model.number="state.minCapacity" type="number" :min="1" class="w-full" />
          </UFormField>
          <UFormField label="Max Guests" name="maxCapacity" hint="Maximum seats">
            <UInput v-model.number="state.maxCapacity" type="number" :min="1" class="w-full" />
          </UFormField>
        </div>

        <!-- Pricing (for add-ons) -->
        <USeparator v-if="isAddon" label="Pricing" />

        <div v-if="isAddon" class="grid grid-cols-2 gap-4">
          <UFormField label="Price" name="price">
            <UInput v-model.number="state.price" type="number" :min="0" placeholder="e.g. 1500" class="w-full" />
          </UFormField>
          <UFormField label="Currency" name="currency">
            <UInput v-model="state.currency" placeholder="NOK" class="w-full" disabled />
          </UFormField>
        </div>

        <!-- Booking Behavior -->
        <USeparator label="Booking Behavior" />

        <UFormField label="Bookable" name="isBookable" help="Temporarily disable to take offline for maintenance">
          <USwitch v-model="state.isBookable" />
        </UFormField>

        <UFormField label="Allow Overlapping" name="allowOverlapping" help="Allow multiple bookings at the same time slot">
          <USwitch v-model="state.allowOverlapping" />
        </UFormField>

        <div class="grid grid-cols-2 gap-4">
          <UFormField label="Priority" name="priority" help="Auto-assignment preference">
            <USelectMenu
              v-model="state.priority"
              :items="priorityOptions"
              value-key="value"
              class="w-full"
            />
          </UFormField>
          <UFormField label="Booking Interval" name="bookingInterval" hint="Override (minutes)">
            <UInput
              v-model.number="state.bookingInterval"
              type="number"
              :min="5"
              :step="5"
              placeholder="Use store default"
              class="w-full"
            />
          </UFormField>
        </div>

        <UFormField label="Sort Order" name="sortOrder" help="Lower numbers appear first">
          <UInput v-model.number="state.sortOrder" type="number" min="0" />
        </UFormField>
      </UForm>
    </template>

    <template #footer>
      <div class="flex items-center justify-between p-4">
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
            <span class="text-sm text-error">Delete this resource?</span>
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
            @click="() => form?.submit()"
          />
        </div>
      </div>
    </template>
  </USlideover>
</template>
