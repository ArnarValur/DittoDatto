<script setup lang="ts">
import { z } from 'zod'
import type { FormSubmitEvent } from '#ui/types'
import type { ServiceGroup } from '@dittodatto/shared-types'
import { getFunctions, httpsCallable, connectFunctionsEmulator } from 'firebase/functions'
import { getApp } from 'firebase/app'

/**
 * ServiceGroupFormSlideover
 *
 * Create/Edit service groups for a store.
 * Groups allow shared configuration that cascades to child services.
 */

const props = defineProps<{
  group?: Partial<ServiceGroup> & { id?: string }
  storeId: string
  companyId: string
  open?: boolean
}>()

const emit = defineEmits<{
  (e: 'close'): void
  (e: 'update:open', value: boolean): void
  (e: 'saved'): void
  (e: 'deleted'): void
}>()

// Get functions instance with emulator support
const functions = getFunctions(getApp(), 'europe-west1')

// ⚠️ EMULATORS OFF — fully live Firebase for auth testing
// if (import.meta.dev) {
//   try {
//     connectFunctionsEmulator(functions, 'localhost', 5001)
//   } catch {
//     // Already connected
//   }
// }

const toast = useToast()
const loading = ref(false)
const deleting = ref(false)
const showDeleteConfirm = ref(false)
const form = ref()

// Compute whether we're in edit mode
const isEditMode = computed(() => !!props.group?.id)

// Form State
const state = reactive({
  name: '',
  description: '',

  // Inheritable config (all optional - only set what you want to override)
  duration: undefined as number | undefined,
  bufferTime: undefined as number | undefined,
  capacity: undefined as number | undefined,
  bookingMode: undefined as 'standard' | 'tableReservation' | 'ticketSystem' | undefined,

  // Availability
  availabilityStart: undefined as string | undefined,
  availabilityEnd: undefined as string | undefined,

  sortOrder: 0,
  showOnBookingPanel: true,
  multiSelect: false
})

// Sync form state when editing
watch(() => props.group, (g) => {
  if (g) {
    state.name = g.name || ''
    state.description = g.description || ''
    state.duration = g.duration
    state.bufferTime = g.bufferTime
    state.capacity = g.capacity
    state.bookingMode = g.bookingMode
    state.sortOrder = g.sortOrder ?? 0
    state.showOnBookingPanel = g.showOnBookingPanel ?? true
    state.multiSelect = g.multiSelect ?? false
  } else {
    // Reset form for create mode
    Object.assign(state, {
      name: '',
      description: '',
      duration: undefined,
      bufferTime: undefined,
      capacity: undefined,
      bookingMode: undefined,
      availabilityStart: undefined,
      availabilityEnd: undefined,
      sortOrder: 0,
      showOnBookingPanel: true,
      multiSelect: false
    })
  }
}, { immediate: true })

// Schema for form validation
const FormSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  description: z.string().optional(),
  duration: z.number().int().positive().optional(),
  bufferTime: z.number().int().min(0).optional(),
  capacity: z.number().int().min(1).optional(),
  bookingMode: z.enum(['standard', 'tableReservation', 'ticketSystem']).optional(),
  availabilityStart: z.string().optional(),
  availabilityEnd: z.string().optional(),
  sortOrder: z.number().int().default(0),
  showOnBookingPanel: z.boolean().default(true),
  multiSelect: z.boolean().default(false)
})

type FormData = z.infer<typeof FormSchema>

// Duration presets
const durationOptions = [
  { label: 'Use store default', value: undefined },
  { label: '15 min', value: 15 },
  { label: '30 min', value: 30 },
  { label: '45 min', value: 45 },
  { label: '1 hour', value: 60 },
  { label: '1.5 hours', value: 90 },
  { label: '2 hours', value: 120 },
  { label: '3 hours', value: 180 }
]

// Booking mode options
const bookingModeOptions = [
  { label: 'Use store default', value: undefined },
  { label: 'Standard (Appointments)', value: 'standard', icon: 'i-lucide-calendar-check' },
  { label: 'Table/Group Reservation', value: 'tableReservation', icon: 'i-lucide-users' },
  { label: 'Ticketing', value: 'ticketSystem', icon: 'i-lucide-ticket' }
]

async function onSubmit(event: FormSubmitEvent<FormData>) {
  if (!props.storeId || !props.companyId) return

  loading.value = true
  try {
    // Clean undefined values
    const payload = Object.fromEntries(
      Object.entries(event.data).filter(([_, v]) => v !== undefined && v !== '')
    )

    if (isEditMode.value) {
      // Update
      const updateFn = httpsCallable(functions, 'serviceGroups_update')
      await updateFn({
        groupId: props.group!.id,
        storeId: props.storeId,
        companyId: props.companyId,
        ...payload
      })
      toast.add({ title: 'Service group updated', color: 'success' })
    } else {
      // Create
      const createFn = httpsCallable(functions, 'serviceGroups_create')
      await createFn({
        storeId: props.storeId,
        companyId: props.companyId,
        ...payload
      })
      toast.add({ title: 'Service group created', color: 'success' })
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
  if (!props.group?.id || !props.storeId || !props.companyId) return

  deleting.value = true
  try {
    const deleteFn = httpsCallable(functions, 'serviceGroups_delete')
    await deleteFn({
      groupId: props.group.id,
      storeId: props.storeId,
      companyId: props.companyId
    })
    toast.add({ title: 'Service group deleted', color: 'success' })
    emit('deleted')
    handleClose()
  } catch (err: unknown) {
    console.error(err)
    const message = (err as Error)?.message || 'Failed to delete group'
    // Handle specific error for linked services
    if (message.includes('linked services')) {
      toast.add({
        title: 'Cannot delete',
        description: 'Remove all services from this group first',
        color: 'warning'
      })
    } else {
      toast.add({ title: 'Error', description: message, color: 'error' })
    }
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
    :title="isEditMode ? 'Edit Service Group' : 'Create Service Group'"
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
        <UFormField label="Group Name" name="name" required>
          <UInput v-model="state.name" placeholder="e.g. Quick Services, Premium Treatments" />
        </UFormField>

        <UFormField label="Description" name="description">
          <UTextarea v-model="state.description" placeholder="Optional description..." />
        </UFormField>

        <USeparator label="Group Defaults (Optional)" />

        <p class="text-sm text-muted">
          Set defaults for all services in this group. Leave blank to inherit from store settings.
        </p>

        <div class="grid grid-cols-2 gap-4">
          <UFormField label="Default Duration" name="duration">
            <USelectMenu
              v-model="state.duration"
              :items="durationOptions"
              value-key="value"
              placeholder="Inherit from store"
            />
          </UFormField>

          <UFormField label="Booking Mode" name="bookingMode">
            <USelectMenu
              v-model="state.bookingMode"
              :items="bookingModeOptions"
              value-key="value"
              placeholder="Inherit from store"
            >
              <template #item="{ item }">
                <div class="flex items-center gap-2">
                  <UIcon v-if="item.icon" :name="item.icon" class="size-4" />
                  <span>{{ item.label }}</span>
                </div>
              </template>
            </USelectMenu>
          </UFormField>
        </div>

        <div class="grid grid-cols-2 gap-4">
          <UFormField label="Default Capacity" name="capacity">
            <UInput
              v-model.number="state.capacity"
              type="number"
              min="1"
              placeholder="Inherit"
            />
          </UFormField>

          <UFormField label="Buffer Time (min)" name="bufferTime">
            <UInput
              v-model.number="state.bufferTime"
              type="number"
              min="0"
              step="5"
              placeholder="Inherit"
            />
          </UFormField>
        </div>

        <USeparator label="Availability Window" />

        <div class="grid grid-cols-2 gap-4">
          <UFormField label="Available From" name="availabilityStart">
            <UInput
              v-model="state.availabilityStart"
              type="time"
              placeholder="Inherit"
            />
          </UFormField>
          <UFormField label="Available Until" name="availabilityEnd">
            <UInput
              v-model="state.availabilityEnd"
              type="time"
              placeholder="Inherit"
            />
          </UFormField>
        </div>

        <USeparator label="Display" />

        <UFormField label="Show on Booking Panel" name="showOnBookingPanel" help="When enabled, this group and its services appear on the public booking page">
          <USwitch v-model="state.showOnBookingPanel" />
        </UFormField>

        <UFormField label="Allow Multi-Select" name="multiSelect" help="When enabled, customers can select multiple services from this group in one booking">
          <USwitch v-model="state.multiSelect" />
        </UFormField>

        <UFormField label="Sort Order" name="sortOrder" help="Lower numbers appear first">
          <UInput v-model.number="state.sortOrder" type="number" min="0" />
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
            <span class="text-sm text-error">Delete this group?</span>
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
