<script setup lang="ts">
import { z } from 'zod'
import type { FormSubmitEvent } from '#ui/types'
import type { Event } from '@dittodatto/shared-types'
import type { Timestamp } from 'firebase/firestore'

/**
 * EventFormSlideover
 *
 * Create/Edit events for a company. Supports:
 * - Cover image picker (from Media Gallery)
 * - Date/time picker
 * - Location with optional map coordinates
 * - Status and visibility controls
 */

const props = defineProps<{
  event?: Event | null
  open?: boolean
}>()

const emit = defineEmits<{
  (e: 'close'): void
  (e: 'update:open', value: boolean): void
  (e: 'saved'): void
  (e: 'deleted'): void
}>()

const { companyId } = useCompany()
const { stores } = useStores()
const { createEvent, updateEvent, deleteEvent } = useEvents()

const toast = useToast()
const loading = ref(false)
const deleting = ref(false)
const showDeleteConfirm = ref(false)
const form = ref()

/**
 * Parse date from various formats (ISO string, Firestore Timestamp, Date)
 */
function parseDate(date: string | Date | Timestamp): Date | null {
  if (!date) return null
  if (date instanceof Date) return date
  if (typeof date === 'string') {
    const d = new Date(date)
    return isNaN(d.getTime()) ? null : d
  }
  if (typeof date === 'object' && (date.seconds || date.seconds)) {
    return new Date((date.seconds || date.seconds) * 1000)
  }
  return null
}

// Compute whether we're in edit mode
const isEditMode = computed(() => !!props.event?.id)

// Form State
const state = reactive({
  title: '',
  description: '',
  storeId: '' as string | undefined,

  // Date/Time
  startDate: '',
  startTime: '18:00',
  endDate: '',
  endTime: '22:00',
  timezone: 'Europe/Oslo',

  // Location
  locationName: '',
  address: '',
  city: '',
  country: 'NO',

  // Media
  coverImageUrl: '',

  // Status
  status: 'draft' as 'draft' | 'published' | 'cancelled' | 'completed',
  visibility: 'public' as 'public' | 'private',

  // Ticketing
  ticketingEnabled: false,
  totalCapacity: 100,
  maxPerPurchase: 10,
  ticketGroups: [
    { id: 'general', name: 'General Admission', price: 0, capacity: 100 }
  ] as Array<{ id: string, name: string, price: number, capacity: number }>
})

// Sync form state when editing
watch(() => props.event, (e) => {
  if (e) {
    state.title = e.title || ''
    state.description = e.description || ''
    state.storeId = e.storeId || undefined
    state.coverImageUrl = e.coverImageUrl || ''
    state.status = e.status || 'draft'
    state.visibility = e.visibility || 'public'
    state.timezone = e.timezone || 'Europe/Oslo'

    // Location
    state.locationName = e.location?.name || ''
    state.address = e.location?.address || ''
    state.city = e.location?.city || ''
    state.country = e.location?.country || 'NO'

    // Date/Time
    const start = parseDate(e.startDateTime)
    if (start) {
      state.startDate = start.toISOString().split('T')[0] ?? ''
      state.startTime = start.toTimeString().slice(0, 5)
    }

    const end = parseDate(e.endDateTime)
    if (end) {
      state.endDate = end.toISOString().split('T')[0] ?? ''
      state.endTime = end.toTimeString().slice(0, 5)
    }
  } else {
    // Reset form for create mode
    Object.assign(state, {
      title: '',
      description: '',
      storeId: undefined,
      startDate: new Date().toISOString().split('T')[0],
      startTime: '18:00',
      endDate: '',
      endTime: '22:00',
      timezone: 'Europe/Oslo',
      locationName: '',
      address: '',
      city: '',
      country: 'NO',
      coverImageUrl: '',
      status: 'draft',
      visibility: 'public',
      ticketingEnabled: false,
      totalCapacity: 100,
      maxPerPurchase: 10,
      ticketGroups: [
        { id: 'general', name: 'General Admission', price: 0, capacity: 100 }
      ]
    })
  }
}, { immediate: true })

// Auto-sync endDate with startDate (end can't be before start)
watch(() => state.startDate, (newStart) => {
  if (newStart) {
    // If no end date set, default to same day
    if (!state.endDate) {
      state.endDate = newStart
    }

    // If end date is before start date, update it
    else if (state.endDate < newStart) {
      state.endDate = newStart
    }
  }
})

// Schema for form validation
const FormSchema = z.object({
  title: z.string().min(1, 'Title is required'),
  description: z.string().optional(),
  storeId: z.string().optional(),
  startDate: z.string().min(1, 'Start date is required'),
  startTime: z.string().min(1, 'Start time is required'),
  endDate: z.string().optional(),
  endTime: z.string().optional(),
  timezone: z.string().default('Europe/Oslo'),
  locationName: z.string().optional(),
  address: z.string().min(1, 'Address is required'),
  city: z.string().min(1, 'City is required'),
  country: z.string().default('NO'),
  coverImageUrl: z.string().optional(),
  status: z.enum(['draft', 'published', 'cancelled', 'completed']).default('draft'),
  visibility: z.enum(['public', 'private']).default('public')
})

type FormData = z.infer<typeof FormSchema>

// Store options for dropdown
const storeOptions = computed(() => {
  return [
    { label: 'Company-level event', value: '' },
    ...(stores.value?.map(store => ({
      label: store.name,
      value: store.id
    })) ?? [])
  ]
})

// Get selected store for venue auto-fill
const selectedStore = computed(() => {
  if (!state.storeId) return null
  return stores.value?.find(s => s.id === state.storeId) ?? null
})

const selectedStoreName = computed(() => selectedStore.value?.name ?? '')

// Check if using establishment location
const useEstablishmentLocation = computed(() => {
  if (!selectedStore.value) return false
  return state.locationName === selectedStore.value.name
    && state.address === selectedStore.value.address
    && state.city === selectedStore.value.city
})

// Handle toggle for establishment location
function handleUseEstablishmentLocation(checked: boolean | 'indeterminate') {
  if (checked === true && selectedStore.value) {
    state.locationName = selectedStore.value.name ?? ''
    state.address = selectedStore.value.address ?? ''
    state.city = selectedStore.value.city ?? ''
  } else {
    state.locationName = ''
    state.address = ''
    state.city = ''
  }
}

// Status options
const statusOptions = [
  { label: 'Draft', value: 'draft' },
  { label: 'Published', value: 'published' },
  { label: 'Cancelled', value: 'cancelled' },
  { label: 'Completed', value: 'completed' }
]

// Visibility options
const visibilityOptions = [
  { label: 'Public', value: 'public' },
  { label: 'Private', value: 'private' }
]

async function onSubmit(event: FormSubmitEvent<FormData>) {
  loading.value = true
  try {
    // Build datetime objects
    const startDateTime = new Date(`${state.startDate}T${state.startTime}`)
    let endDateTime: Date | undefined
    if (state.endDate && state.endTime) {
      endDateTime = new Date(`${state.endDate}T${state.endTime}`)
    }

    const payload = {
      title: state.title,
      description: state.description || undefined,
      storeId: state.storeId || undefined,
      startDateTime,
      endDateTime,
      timezone: state.timezone,
      location: {
        name: state.locationName || undefined,
        address: state.address,
        city: state.city,
        country: state.country
      },
      coverImageUrl: state.coverImageUrl || undefined,
      status: state.status,
      visibility: state.visibility,
      // Ticketing flags - bundle creation handled separately
      ticketingEnabled: state.ticketingEnabled,
      hasTickets: state.ticketingEnabled
      // TODO: Create TicketBundle in Firestore when ticketingEnabled
      // ticketBundleId will be set after bundle creation
    }

    if (isEditMode.value && props.event?.id) {
      await updateEvent(props.event.id, payload)
      toast.add({ title: 'Event updated', color: 'success' })
    } else {
      await createEvent(payload)
      toast.add({ title: 'Event created', color: 'success' })
    }

    emit('saved')
    handleClose()
  } catch (error: unknown) {
    toast.add({
      title: 'Error',
      description: (error as Error).message || 'Failed to save event',
      color: 'error'
    })
  } finally {
    loading.value = false
  }
}

async function handleDelete() {
  if (!props.event?.id) return

  deleting.value = true
  try {
    await deleteEvent(props.event.id)
    toast.add({ title: 'Event deleted', color: 'success' })
    emit('deleted')
    handleClose()
  } catch (error: unknown) {
    toast.add({
      title: 'Error',
      description: (error as Error).message || 'Failed to delete event',
      color: 'error'
    })
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
    :title="isEditMode ? 'Edit Event' : 'Create Event'"
    :dismiss="false"
    @update:open="(val) => emit('update:open', val)"
  >
    <template #body>
      <UForm
        :schema="FormSchema"
        :state="state"
        class="space-y-4 p-4"
        @submit="onSubmit"
      >
        <!-- Basic Info -->
        <UFormField label="Event Title" name="title" required>
          <UInput v-model="state.title" placeholder="e.g. New Year's Party, Jazz Night" />
        </UFormField>

        <UFormField label="Description" name="description">
          <UTextarea v-model="state.description" placeholder="What's this event about?" :rows="3" />
        </UFormField>

        <UFormField
          label="Linked Establishment"
          name="storeId"
          help="Link to a specific store, or leave empty for a company-level event"
        >
          <USelectMenu
            :model-value="storeOptions.find(o => o.value === state.storeId)"
            :items="storeOptions"
            value-attribute="value"
            option-attribute="label"
            class="w-full"
            placeholder="Select establishment (optional)"
            @update:model-value="(val: any) => state.storeId = val?.value ?? ''"
          />
        </UFormField>

        <USeparator label="Date & Time" />

        <div class="grid grid-cols-2 gap-4">
          <UFormField label="Start Date" name="startDate" required>
            <UInput v-model="state.startDate" type="date" />
          </UFormField>
          <UFormField label="Start Time" name="startTime" required>
            <UInput v-model="state.startTime" type="time" />
          </UFormField>
        </div>

        <div class="grid grid-cols-2 gap-4">
          <UFormField label="End Date" name="endDate">
            <UInput v-model="state.endDate" type="date" />
          </UFormField>
          <UFormField label="End Time" name="endTime">
            <UInput v-model="state.endTime" type="time" />
          </UFormField>
        </div>

        <USeparator label="Location" />

        <UFormField label="Venue Name" name="locationName">
          <div class="space-y-2">
            <!-- Checkbox to use establishment location -->
            <div v-if="state.storeId && selectedStore" class="flex items-center gap-2">
              <UCheckbox
                :model-value="useEstablishmentLocation"
                @update:model-value="handleUseEstablishmentLocation"
              />
              <span class="text-sm text-muted">Use "{{ selectedStoreName }}" location</span>
            </div>
            <UInput
              v-model="state.locationName"
              placeholder="e.g. Saga Kino, Main Hall"
              :disabled="useEstablishmentLocation"
            />
          </div>
        </UFormField>

        <UFormField label="Address" name="address" required>
          <UInput v-model="state.address" placeholder="Street address" :disabled="useEstablishmentLocation" />
        </UFormField>

        <UFormField label="City" name="city" required>
          <UInput v-model="state.city" placeholder="City" :disabled="useEstablishmentLocation" />
        </UFormField>

        <USeparator label="Media" />

        <UFormField label="Cover Image" name="coverImageUrl" hint="Main image shown on the event card">
          <DDMediaPickerButton
            v-model="state.coverImageUrl"
            :company-id="companyId || ''"
            :store-id="state.storeId || undefined"
            :filter-tags="['event', 'cover']"
            label="Choose Cover"
            placeholder="Select from media library"
          />
        </UFormField>

        <USeparator label="Settings" />

        <div class="grid grid-cols-2 gap-4">
          <UFormField label="Status" name="status">
            <USelectMenu
              :model-value="statusOptions.find(o => o.value === state.status)"
              :items="statusOptions"
              value-attribute="value"
              option-attribute="label"
              @update:model-value="(val: any) => state.status = val?.value ?? 'draft'"
            />
          </UFormField>
          <UFormField label="Visibility" name="visibility">
            <USelectMenu
              :model-value="visibilityOptions.find(o => o.value === state.visibility)"
              :items="visibilityOptions"
              value-attribute="value"
              option-attribute="label"
              @update:model-value="(val: any) => state.visibility = val?.value ?? 'public'"
            />
          </UFormField>
        </div>

        <USeparator label="Ticketing" />

        <!-- Enable Ticketing Toggle -->
        <UFormField label="Enable Ticket Sales" name="ticketingEnabled">
          <USwitch v-model="state.ticketingEnabled" />
        </UFormField>

        <!-- Ticketing Configuration (shown when enabled) -->
        <template v-if="state.ticketingEnabled">
          <div class="p-4 bg-purple-50 dark:bg-purple-900/20 rounded-lg space-y-4">
            <div class="flex items-center gap-2 text-purple-700 dark:text-purple-300">
              <UIcon name="i-lucide-ticket" class="size-5" />
              <span class="font-semibold">Ticket Configuration</span>
            </div>

            <div class="grid grid-cols-2 gap-4">
              <UFormField label="Total Capacity" name="totalCapacity">
                <UInput
                  v-model.number="state.totalCapacity"
                  type="number"
                  min="1"
                  max="100000"
                  placeholder="e.g. 3000"
                />
              </UFormField>
              <UFormField label="Max Per Purchase" name="maxPerPurchase">
                <UInput
                  v-model.number="state.maxPerPurchase"
                  type="number"
                  min="1"
                  max="100"
                  placeholder="e.g. 10"
                />
              </UFormField>
            </div>

            <!-- Ticket Groups -->
            <div class="space-y-3">
              <div class="flex items-center justify-between">
                <span class="text-sm font-medium text-purple-700 dark:text-purple-300">
                  Ticket Tiers
                </span>
                <UButton
                  icon="i-lucide-plus"
                  size="xs"
                  color="primary"
                  variant="soft"
                  label="Add Tier"
                  @click="state.ticketGroups.push({ id: Date.now().toString(), name: '', price: 0, capacity: 100 })"
                />
              </div>

              <div
                v-for="(group, index) in state.ticketGroups"
                :key="group.id"
                class="p-3 bg-white dark:bg-gray-800 rounded-lg border border-purple-200 dark:border-purple-700"
              >
                <div class="flex items-start gap-3">
                  <div class="flex-1 grid grid-cols-3 gap-2">
                    <UInput
                      v-model="group.name"
                      placeholder="Tier name"
                      size="sm"
                    />
                    <UInput
                      v-model.number="group.price"
                      type="number"
                      min="0"
                      placeholder="Price (kr)"
                      size="sm"
                    />
                    <UInput
                      v-model.number="group.capacity"
                      type="number"
                      min="1"
                      placeholder="Capacity"
                      size="sm"
                    />
                  </div>
                  <UButton
                    v-if="state.ticketGroups.length > 1"
                    icon="i-lucide-trash-2"
                    size="xs"
                    color="error"
                    variant="ghost"
                    @click="state.ticketGroups.splice(index, 1)"
                  />
                </div>
              </div>
            </div>

            <!-- TODO-PostIt for payment -->
            <div class="text-xs text-purple-600 dark:text-purple-400 flex items-center gap-1">
              <UIcon name="i-lucide-info" class="size-3" />
              Payment integration coming Q1 2026
            </div>
          </div>
        </template>
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
            <span class="text-sm text-error">Delete this event?</span>
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
