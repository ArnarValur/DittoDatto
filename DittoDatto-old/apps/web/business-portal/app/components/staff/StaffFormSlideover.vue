<script setup lang="ts">
import { z } from 'zod'
import type { FormSubmitEvent } from '#ui/types'
import type { StaffMember, StaffCapability, WeeklyShift, DateOverride } from '@dittodatto/shared-types'
import { ALL_STAFF_CAPABILITIES } from '@dittodatto/shared-types'
import { getFunctions, httpsCallable } from 'firebase/functions'

/**
 * StaffFormSlideover
 *
 * Create (invite) or edit a staff member.
 * Follows the same pattern as ServiceFormSlideover.
 */

const props = defineProps<{
  staffMember?: Partial<StaffMember>
  open?: boolean
}>()

const emit = defineEmits<{
  (e: 'close'): void
  (e: 'update:open', value: boolean): void
  (e: 'saved'): void
}>()

const { company, companyId } = useCompany()
const { stores } = useStores()
const { addStaff, updateStaff } = useStaff()
const { currentStaffDoc } = useStaffPermissions()
const currentUser = useCurrentUser()
const toast = useToast()
const { saveWeeklyShifts, saveDateOverrides, defaultWeeklyShifts } = useStaffSchedule()
const loading = ref(false)
const form = ref()
const showRemoveConfirm = ref(false)
const removing = ref(false)
const resending = ref(false)

// ── Suicide Prevention ──
// Is the staff member being edited the company owner?
const isEditingOwner = computed(() => {
  if (!isEditMode.value || !props.staffMember?.userId || !company.value) return false
  return props.staffMember.userId === company.value.ownerId
})

// Is the current user editing their own staff record?
const isEditingSelf = computed(() => {
  if (!isEditMode.value || !props.staffMember?.id || !currentStaffDoc.value) return false
  return props.staffMember.id === currentStaffDoc.value.id
})

const isEditMode = computed(() => !!props.staffMember?.id)

// --- Form State ---
const state = reactive({
  email: '',
  displayName: '',
  position: '',
  avatarUrl: '',
  storeIds: [] as string[],
  defaultCapabilities: [] as StaffCapability[],
  isBookable: false,
  showOnStorefront: false,
  status: 'invited' as 'invited' | 'active' | 'suspended' | 'removed',
})

// Schedule state (managed separately, not part of the form)
const scheduleShifts = ref<WeeklyShift>(defaultWeeklyShifts())
const scheduleOverrides = ref<DateOverride[]>([])
const scheduleSaving = ref(false)

// Sync form state when editing
watch(
  () => props.staffMember,
  (s) => {
    if (s) {
      state.email = s.email || ''
      state.displayName = s.displayName || ''
      state.position = s.position || ''
      state.avatarUrl = s.avatarUrl || ''
      state.storeIds = s.storeIds || []
      state.defaultCapabilities = (s.defaultCapabilities || []) as StaffCapability[]
      state.isBookable = s.isBookable ?? false
      state.showOnStorefront = s.showOnStorefront ?? false
      state.status = s.status || 'invited'
      // Sync schedule
      scheduleShifts.value = s.weeklyShifts ? JSON.parse(JSON.stringify(s.weeklyShifts)) : defaultWeeklyShifts()
      scheduleOverrides.value = s.dateOverrides ? JSON.parse(JSON.stringify(s.dateOverrides)) : []
    } else {
      Object.assign(state, {
        email: '',
        displayName: '',
        position: '',
        avatarUrl: '',
        storeIds: [],
        defaultCapabilities: [],
        isBookable: false,
        showOnStorefront: false,
        status: 'invited',
      })
    }
  },
  { immediate: true }
)

// --- Validation Schema ---
// Schema adapts per mode: name required only when editing
const FormSchema = computed(() => z.object({
  email: z.string().email('Valid email is required'),
  displayName: isEditMode.value
    ? z.string().min(1, 'Name is required')
    : z.string().optional(),
  position: z.string().optional(),
  avatarUrl: z.string().optional(),
  storeIds: z.array(z.string()).default([]),
  defaultCapabilities: z.array(z.string()).default([]),
  isBookable: z.boolean().default(false),
  showOnStorefront: z.boolean().default(false),
}))

interface FormData {
  email: string
  displayName?: string
  position?: string
  avatarUrl?: string
  storeIds: string[]
  defaultCapabilities: string[]
  isBookable: boolean
  showOnStorefront: boolean
}

// --- Options ---
const storeOptions = computed(() =>
  (stores.value ?? []).map((s) => ({
    label: s.name,
    value: s.id,
  }))
)

// Capabilities grouped for display
const capabilityGroups = [
  {
    label: 'Operations',
    capabilities: [
      { value: 'can_manage_bookings', label: 'Manage Bookings', icon: 'i-lucide-calendar-check', hint: 'Create, edit, cancel, reassign' },
      { value: 'can_view_all_bookings', label: 'View All Bookings', icon: 'i-lucide-calendar-search', hint: 'Read-only access to full calendar' },
      { value: 'can_manage_schedule', label: 'Manage Schedule', icon: 'i-lucide-clock' },
      { value: 'can_manage_services', label: 'Manage Services', icon: 'i-lucide-briefcase' },
    ],
  },
  {
    label: 'Content',
    capabilities: [
      { value: 'can_manage_media', label: 'Manage Media', icon: 'i-lucide-image' },
      { value: 'can_manage_events', label: 'Manage Events', icon: 'i-lucide-party-popper' },
    ],
  },
  {
    label: 'Administration',
    capabilities: [
      { value: 'can_manage_staff', label: 'Manage Staff', icon: 'i-lucide-users' },
      { value: 'can_manage_settings', label: 'Manage Settings', icon: 'i-lucide-settings' },
      { value: 'can_view_financials', label: 'View Financials', icon: 'i-lucide-chart-bar' },
    ],
  },
]

function toggleCapability(cap: string) {
  // Suicide prevention: can't edit owner capabilities
  if (isEditingOwner.value) return

  // Suicide prevention: can't remove own can_manage_staff
  if (isEditingSelf.value && cap === 'can_manage_staff') {
    const hasIt = state.defaultCapabilities.includes('can_manage_staff')
    if (hasIt) {
      toast.add({
        title: 'Cannot remove this permission',
        description: 'You cannot remove your own "Manage Staff" capability. Ask the company owner to change your permissions.',
        color: 'warning',
        icon: 'i-lucide-shield-alert',
      })
      return
    }
  }

  const idx = state.defaultCapabilities.indexOf(cap as StaffCapability)
  if (idx === -1) {
    state.defaultCapabilities.push(cap as StaffCapability)
  } else {
    state.defaultCapabilities.splice(idx, 1)
  }
}

function toggleStore(storeId: string) {
  const idx = state.storeIds.indexOf(storeId)
  if (idx === -1) {
    state.storeIds.push(storeId)
  } else {
    state.storeIds.splice(idx, 1)
  }
}

// --- Submit ---
async function onSubmit(event: FormSubmitEvent<FormData>) {
  if (!companyId.value) return

  loading.value = true
  try {
    if (isEditMode.value && props.staffMember?.id) {
      await updateStaff(props.staffMember.id, {
        displayName: state.displayName,
        position: state.position || undefined,
        avatarUrl: state.avatarUrl || undefined,
        storeIds: state.storeIds,
        defaultCapabilities: state.defaultCapabilities,
        isBookable: state.isBookable,
        showOnStorefront: state.isBookable ? state.showOnStorefront : false,
      } as any)

      // Auto-persist default schedule if toggling isBookable ON and no shifts exist yet
      if (state.isBookable && !props.staffMember?.weeklyShifts) {
        await saveWeeklyShifts(props.staffMember.id, scheduleShifts.value)
      }

      toast.add({ title: 'Staff member updated', color: 'success' })
    } else {
      const newStaffId = await addStaff({
        email: state.email,
        displayName: state.displayName,
        position: state.position || undefined,
        avatarUrl: state.avatarUrl || undefined,
        storeIds: state.storeIds,
        defaultCapabilities: state.defaultCapabilities,
        isBookable: state.isBookable,
        showOnStorefront: state.isBookable ? state.showOnStorefront : false,
      } as any)

      // Auto-persist default schedule for new bookable staff
      if (state.isBookable && newStaffId) {
        await saveWeeklyShifts(newStaffId, scheduleShifts.value)
      }

      toast.add({ title: 'Invitation sent', description: `Invited ${state.email}`, color: 'success' })
    }


    emit('saved')
    handleClose()
  } catch (err: unknown) {
    console.error('[StaffFormSlideover]', err)
    toast.add({ title: 'Error', description: (err as Error).message, color: 'error' })
  } finally {
    loading.value = false
  }
}

// --- Remove ---
async function handleRemove() {
  if (!props.staffMember?.id) return
  removing.value = true
  try {
    const { removeStaff } = useStaff()
    await removeStaff(props.staffMember.id)
    toast.add({ title: 'Staff member removed', color: 'success' })
    emit('saved')
    handleClose()
  } catch (err: unknown) {
    toast.add({ title: 'Error', description: (err as Error).message, color: 'error' })
  } finally {
    removing.value = false
    showRemoveConfirm.value = false
  }
}

function handleClose() {
  emit('update:open', false)
  emit('close')
}

// --- Resend Invite ---
async function handleResendInvite() {
  if (!props.staffMember?.id || !companyId.value) return
  resending.value = true
  try {
    const functions = getFunctions(undefined, 'europe-west1')
    const resend = httpsCallable(functions, 'staff_resendInvite')
    await resend({ companyId: companyId.value, staffId: props.staffMember.id })
    toast.add({ title: 'Invitation resent', description: `Email sent to ${state.email}`, color: 'success' })
  } catch (err: unknown) {
    toast.add({ title: 'Failed to resend', description: (err as Error).message, color: 'error' })
  } finally {
    resending.value = false
  }
}

// Status options for edit mode
const statusOptions = [
  { label: 'Active', value: 'active', color: 'success' },
  { label: 'Invited', value: 'invited', color: 'info' },
  { label: 'Suspended', value: 'suspended', color: 'warning' },
]

// --- Schedule Save ---
async function handleSaveSchedule() {
  if (!props.staffMember?.id) return
  scheduleSaving.value = true
  try {
    await saveWeeklyShifts(props.staffMember.id, scheduleShifts.value)
    await saveDateOverrides(props.staffMember.id, scheduleOverrides.value)
  } catch (err: unknown) {
    toast.add({ title: 'Error saving schedule', description: (err as Error).message, color: 'error' })
  } finally {
    scheduleSaving.value = false
  }
}
</script>

<template>
  <USlideover
    :open="open ?? true"
    :title="isEditMode ? 'Edit Staff Member' : 'Invite Staff Member'"
    @update:open="(val) => emit('update:open', val)"
  >
    <template #body>
      <!-- Owner protection banner -->
      <div v-if="isEditingOwner" class="mx-4 mt-4 p-3 rounded-lg bg-primary/10 border border-primary/20 flex items-center gap-3">
        <UIcon name="i-lucide-crown" class="size-5 text-primary shrink-0" />
        <div>
          <p class="text-sm font-medium text-primary">Company Owner</p>
          <p class="text-xs text-muted">Owners have implicit full access. Permissions and status cannot be changed.</p>
        </div>
      </div>

      <UForm
        ref="form"
        :schema="FormSchema"
        :state="state"
        class="space-y-4 p-4"
        @submit="onSubmit"
      >
        <!-- Identity -->
        <UFormField label="Email" name="email" required>
          <UInput
            v-model="state.email"
            type="email"
            placeholder="team@example.com"
            icon="i-lucide-mail"
            :disabled="isEditMode"
          />
        </UFormField>

        <!-- Name: only shown in edit mode. In invite mode, the user provides their own name at registration -->
        <UFormField v-if="isEditMode" label="Name" name="displayName" required>
          <UInput
            v-model="state.displayName"
            placeholder="Full name"
            icon="i-lucide-user"
          />
        </UFormField>
        <div v-else class="p-3 rounded-lg bg-info/5 border border-info/10 text-xs text-muted hidden">
          <UIcon name="i-lucide-info" class="size-3.5 inline mr-1 text-info" />
          The invited person will set their own name when they accept.
        </div>

        <UFormField label="Position" name="position" help="e.g. Barista, Senior Stylist, Manager">
          <UInput
            v-model="state.position"
            placeholder="Job title (optional)"
            icon="i-lucide-badge"
          />
        </UFormField>

        <!-- Avatar -->
        <UFormField label="Avatar" name="avatarUrl" hint="From media library">
          <DDMediaPickerButton
            v-model="state.avatarUrl"
            :company-id="companyId || ''"
            :filter-tags="['staff', 'portrait']"
            label="Choose Avatar"
            placeholder="Select from media library"
          />
        </UFormField>

        <USeparator label="Store Assignment" />

        <!-- Store Multi-Select -->
        <UFormField name="storeIds" help="Which stores does this person work at?">
          <div class="space-y-2">
            <div
              v-for="store in storeOptions"
              :key="store.value"
              class="flex items-center gap-3 p-2 rounded-lg hover:bg-muted/50 cursor-pointer transition-colors"
              @click="toggleStore(store.value)"
            >
              <UCheckbox
                :model-value="state.storeIds.includes(store.value)"
                @click.stop
              />
              <UIcon name="i-lucide-store" class="size-4 text-muted" />
              <span class="text-sm font-medium">{{ store.label }}</span>
            </div>
            <p v-if="storeOptions.length === 0" class="text-sm text-muted italic">
              No stores found for this company.
            </p>
          </div>
        </UFormField>

        <USeparator label="Permissions" />

        <!-- Capability Toggles -->
        <div v-if="isEditingOwner" class="p-3 rounded-lg bg-muted/30">
          <p class="text-sm text-muted italic">Owner has all permissions by default.</p>
        </div>

        <div v-else class="space-y-4">
          <div v-for="group in capabilityGroups" :key="group.label">
            <h4 class="text-xs font-semibold text-muted uppercase tracking-wide mb-2">
              {{ group.label }}
            </h4>
            <div class="space-y-1">
              <div
                v-for="cap in group.capabilities"
                :key="cap.value"
                class="flex items-center gap-3 p-2 rounded-lg transition-colors"
                :class="[
                  isEditingSelf && cap.value === 'can_manage_staff' && state.defaultCapabilities.includes('can_manage_staff' as StaffCapability)
                    ? 'opacity-60 cursor-not-allowed'
                    : 'hover:bg-muted/50 cursor-pointer'
                ]"
                @click="toggleCapability(cap.value)"
              >
                <UCheckbox
                  :model-value="state.defaultCapabilities.includes(cap.value as StaffCapability)"
                  :disabled="isEditingSelf && cap.value === 'can_manage_staff' && state.defaultCapabilities.includes('can_manage_staff' as StaffCapability)"
                  @click.stop
                />
                <UIcon :name="cap.icon" class="size-4 text-muted" />
                <span class="text-sm">{{ cap.label }}</span>
                <UBadge
                  v-if="isEditingSelf && cap.value === 'can_manage_staff' && state.defaultCapabilities.includes('can_manage_staff' as StaffCapability)"
                  label="Locked"
                  color="warning"
                  variant="subtle"
                  size="xs"
                />
              </div>
            </div>
          </div>
        </div>

        <USeparator label="Booking" />

        <!-- Bookable toggle -->
        <div
          class="flex items-center justify-between p-3 rounded-lg bg-muted/30"
        >
          <div>
            <p class="text-sm font-medium">Bookable by customers</p>
            <p class="text-xs text-muted">
              Allow customers to select this person when booking
            </p>
          </div>
          <USwitch v-model="state.isBookable" />
        </div>

        <!-- Storefront visibility toggle (only when bookable) -->
        <div
          v-if="state.isBookable"
          class="flex items-center justify-between p-3 rounded-lg bg-muted/30"
        >
          <div>
            <p class="text-sm font-medium">Show on storefront</p>
            <p class="text-xs text-muted">
              Display this team member on your public page
            </p>
          </div>
          <USwitch v-model="state.showOnStorefront" />
        </div>

        <!-- Schedule now managed on the Staff Detail page (/staff/:id) -->

        <!-- Status (edit mode only, not for owner) -->
        <template v-if="isEditMode && !isEditingOwner">
          <USeparator label="Status" />
          <UFormField name="status">
            <USelectMenu
              :model-value="statusOptions.find((o) => o.value === state.status)"
              :items="statusOptions"
              value-attribute="value"
              option-attribute="label"
              @update:model-value="(val: any) => (state.status = val?.value ?? 'invited')"
            />
          </UFormField>
        </template>
      </UForm>
    </template>

    <template #footer>
      <div class="flex items-center justify-between p-4">
        <!-- Left side actions -->
        <div class="flex items-center gap-2">
          <!-- Resend invite (only for invited staff) -->
          <UButton
            v-if="isEditMode && state.status === 'invited' && !showRemoveConfirm"
            label="Resend Invite"
            icon="i-lucide-mail"
            color="info"
            variant="soft"
            size="sm"
            :loading="resending"
            @click="handleResendInvite"
          />

          <!-- Remove button (edit mode only, never for owner) -->
          <UButton
            v-if="isEditMode && !isEditingOwner && !showRemoveConfirm"
            label="Remove"
            color="error"
            variant="ghost"
            icon="i-lucide-user-minus"
            @click="showRemoveConfirm = true"
          />
          <div v-if="showRemoveConfirm" class="flex flex-col gap-2">
            <p class="text-xs text-muted max-w-60">
              Remove from company? They'll lose portal access but can still use DittoDatto as a customer.
            </p>
            <div class="flex items-center gap-2">
              <UButton
                label="Remove from company"
                color="error"
                size="xs"
                :loading="removing"
                @click="handleRemove"
              />
              <UButton
                label="Cancel"
                color="neutral"
                variant="ghost"
                size="xs"
                @click="showRemoveConfirm = false"
              />
            </div>
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
            v-if="!isEditingOwner"
            :label="isEditMode ? 'Update' : 'Send Invite'"
            :icon="isEditMode ? undefined : 'i-lucide-send'"
            color="primary"
            :loading="loading"
            @click="form?.submit()"
          />
        </div>
      </div>
    </template>
  </USlideover>
</template>
