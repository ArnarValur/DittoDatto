<script setup lang="ts">
import { z } from 'zod'
import type { FormSubmitEvent } from '#ui/types'
import type { Company, FirebaseUser } from '@dittodatto/shared-types'
import { CompanySchema } from '@dittodatto/shared-types'
import { getApp } from 'firebase/app'
import { getFunctions, httpsCallable, connectFunctionsEmulator } from 'firebase/functions'

const props = defineProps<{
  company?: Company
  open?: boolean
}>()

const emit = defineEmits<{
  (e: 'close', payload?: Company): void
  (e: 'update:open', value: boolean): void
  (e: 'saved'): void
}>()

const toast = useToast()
const form = ref()
const loading = ref(false)

// --- 1. Async User Lookup ---
// Type for user in dropdown
type OwnerOption = {
  uid: string
  displayName: string
  email: string
  label: string
}

const selectedOwner = ref<OwnerOption | undefined>(undefined)

// Checkbox to use owner's email as company email
const useOwnerEmail = ref(false)

// Fetch and cache all users
const { data: allUsersData } = await useFetch<{
  users: FirebaseUser[]
}>('/api/users/users', {
  immediate: true,
  query: { pageSize: 1000 }
})

// Transform all users for USelectMenu
const users = computed(() => {
  return allUsersData.value?.users?.map(user => ({
    uid: user.uid,
    displayName: user.displayName || 'Unknown',
    email: user.email || '',
    label: `${user.displayName || 'Unknown'} (${user.email})`
  })) ?? []
})

// --- 2. Form State & Schema ---
const state = reactive({
  name: props.company?.name ?? '',
  ownerId: props.company?.ownerId ?? '',
  ownerEmail: props.company?.ownerEmail ?? '',
  onboardingStatus: props.company?.onboardingStatus ?? 'not_started',
  phone: props.company?.phone ?? '',
  email: props.company?.email ?? '',
  country: props.company?.country ?? 'NO',
  tier: props.company?.tier ?? 'free',
  enabledFeatures: {
    tableReservation: props.company?.enabledFeatures?.tableReservation ?? false,
    aiAssistance: props.company?.enabledFeatures?.aiAssistance ?? false,
    ticketSystem: props.company?.enabledFeatures?.ticketSystem ?? false,
    eventSystem: props.company?.enabledFeatures?.eventSystem ?? false
  },
  storePolicy: {
    maxStores: props.company?.storePolicy?.maxStores ?? 1,
    canCreateOwnStores: props.company?.storePolicy?.canCreateOwnStores ?? false
  }
})

// Pre-fill form state when company prop changes (for edit mode)
watch(() => props.company, (newVal) => {
  // Sync all form fields when company changes
  state.name = newVal?.name ?? ''
  state.ownerId = newVal?.ownerId ?? ''
  state.ownerEmail = newVal?.ownerEmail ?? ''
  state.onboardingStatus = newVal?.onboardingStatus ?? 'not_started'
  state.phone = newVal?.phone ?? ''
  state.email = newVal?.email ?? ''
  state.country = newVal?.country ?? 'NO'
  state.tier = newVal?.tier ?? 'free'

  // Sync enabledFeatures
  state.enabledFeatures.tableReservation = newVal?.enabledFeatures?.tableReservation ?? false
  state.enabledFeatures.aiAssistance = newVal?.enabledFeatures?.aiAssistance ?? false
  state.enabledFeatures.ticketSystem = newVal?.enabledFeatures?.ticketSystem ?? false
  state.enabledFeatures.eventSystem = newVal?.enabledFeatures?.eventSystem ?? false

  // Sync storePolicy
  state.storePolicy.maxStores = newVal?.storePolicy?.maxStores ?? 1
  state.storePolicy.canCreateOwnStores = newVal?.storePolicy?.canCreateOwnStores ?? false

  // Pre-fill selectedOwner for the dropdown
  if (newVal?.ownerId && users.value.length > 0) {
    const owner = users.value.find(u => u.uid === newVal.ownerId)
    if (owner) {
      selectedOwner.value = owner
    }
  } else {
    selectedOwner.value = undefined
  }
}, { immediate: true })

// Sync selectedOwner to state.ownerEmail when user selects
watch(() => selectedOwner.value, (owner) => {
  state.ownerEmail = owner?.email ?? ''
  state.ownerId = owner?.uid ?? ''
  // Also update company email if checkbox is checked
  if (useOwnerEmail.value && owner?.email) {
    state.email = owner.email
  }
})

// Watch checkbox to sync email with owner
watch(useOwnerEmail, (checked) => {
  if (checked && selectedOwner.value?.email) {
    state.email = selectedOwner.value.email
  }
})

// Schema (Simplified for UI)
const FormSchema = CompanySchema.omit({
  id: true,
  createdAt: true,
  updatedAt: true,
  logoUrl: true,
  slinks: true
}).extend({
  ownerEmail: z.email().or(z.literal('')).optional()
})

// --- 3. Actions ---
function handleClose() {
  emit('update:open', false)
  emit('close')
}

// Infer form data type from schema
type FormData = z.infer<typeof FormSchema>

async function onSubmit(event: FormSubmitEvent<FormData>) {
  loading.value = true
  try {
    const isEdit = !!props.company?.id
    const endpoint = '/api/companies/companies'

    const payload: Partial<FormData> & { id?: string } = {
      name: event.data.name,
      ownerEmail: event.data.ownerEmail,
      onboardingStatus: event.data.onboardingStatus,
      phone: event.data.phone,
      email: event.data.email,
      country: event.data.country || 'NO',
      tier: event.data.tier,
      enabledFeatures: state.enabledFeatures,
      storePolicy: state.storePolicy
    }

    if (props.company?.id) payload.id = props.company.id

    if (isEdit) {
      // Use existing API for updates
      await $fetch(endpoint, { method: 'PATCH', body: payload })
      toast.add({ title: 'Company updated', color: 'success' })
    } else {
      // Use Cloud Function for creation (Ensures atomic Claims update)
      const functions = getFunctions(getApp(), 'europe-west1')

      // ⚠️ EMULATORS OFF — fully live Firebase for auth testing
      // if (import.meta.dev) {
      //   connectFunctionsEmulator(functions, 'localhost', 5001)
      // }

      const createCompany = httpsCallable(functions, 'admin_createCompany')

      await createCompany(payload)
      toast.add({ title: 'Company created', color: 'success' })
    }

    emit('saved')
    handleClose()
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  } catch (error: any) {
    toast.add({
      title: 'Error',
      description: error.data?.message || error.message,
      color: 'error'
    })
  } finally {
    loading.value = false
  }
}

// // Search function for USelectMenu
// async function searchUsers(query: string) {
//   // Uses your existing users endpoint which now supports ?search=
//   const res = await $fetch<{ users: FirebaseUser[] }>('/api/users/users', {
//     query: { search: query, pageSize: 20 }
//   })
//   console.log("searchUsers res: ", res);
//   return res.users
// }s
</script>

<template>
  <div>
    <USlideover
      :open="open ?? true"
      :title="company ? 'Edit Company' : 'New Company'"
      :description="company ? `Update details for ${company.name}` : `Add a new company`"
      :dismissible="false"
      :ui="{ footer: 'justify-end' }"
      @update:open="(val) => emit('update:open', val)"
    >
      <template #body>
        <UForm
          ref="form"
          :schema="FormSchema"
          :state="state"
          class=""
          @submit="onSubmit"
        >
          <!-- Group 1: Essentials -->
          <div class="space-y-4 p-4 bg-gray-50 dark:bg-gray-800/50 rounded-lg">
            <h3 class="text-sm font-semibold text-gray-900 dark:text-white mb-2">
              Essentials
            </h3>

            <UFormField
              label="Company Name"
              name="name"
              required
            >
              <UInput
                v-model="state.name"
                placeholder="Acme Inc."
                class="w-full"
              />
            </UFormField>

            <UFormField
              label="Company Owner"
              name="ownerEmail"
              required
            >
              <!-- ✅ Async User Lookup with filter-fields for searchable -->
              <USelectMenu
                v-model="selectedOwner"
                required
                :items="users"
                class="w-full"
                :filter-fields="['label', 'displayName', 'email']"
                searchable
                :search-input="{ icon: 'i-lucide-user', placeholder: 'Search by name or email...' }"
                icon="i-lucide-user"
                @update:model-value="(user: OwnerOption) => state.ownerEmail = user?.email || ''"
              >
                <template #item-label="{ item }">
                  <div class="flex flex-col">
                    <span class="font-medium">{{ item.displayName }}</span>
                    <span class="text-sm text-gray-500">{{ item.email }}</span>
                  </div>
                </template>
              </USelectMenu>
            </UFormField>

            <UFormField
              label="Email"
              name="email"
            >
              <div class="flex items-center gap-2">
                <UInput
                  v-model="state.email"
                  placeholder="company@example.com"
                  class="flex-1"
                  :disabled="useOwnerEmail"
                />
                <UCheckbox
                  v-model="useOwnerEmail"
                  label="Use owner email"
                />
              </div>
            </UFormField>

            <div class="grid grid-cols-2 gap-4">
              <UFormField
                label="Phone"
                name="phone"
              >
                <UInput v-model="state.phone" />
              </UFormField>

              <UFormField
                label="Tier"
                name="tier"
              >
                <USelectMenu
                  v-model="state.tier"
                  :items="['free', 'premium']"
                  class="capitalize w-32"
                />
              </UFormField>
            <!-- <UFormField label="Onboarding Status" name="onboardingStatus">
               <USelectMenu :items="['not_started', 'in_progress', 'completed']"v-model="state.onboardingStatus" />
             </UFormField> -->
            </div>
          </div>
          <USeparator class="my-2" />

          <!-- Group 2: Features (Admin-only) -->
          <div class="space-y-4 p-4 bg-indigo-50 dark:bg-indigo-900/20 rounded-lg">
            <h3 class="text-sm font-semibold text-gray-900 dark:text-white mb-2 flex items-center gap-2">
              <UIcon
                name="i-lucide-zap"
                class="w-4 h-4"
              />
              Enabled Features
            </h3>
            <p class="text-xs text-gray-500 dark:text-gray-400 -mt-1">
              Toggle features available to this company's Business Portal
            </p>

            <div class="space-y-3">
              <div class="flex items-center justify-between p-3 bg-white dark:bg-gray-800 rounded-md border border-gray-200 dark:border-gray-700">
                <div class="flex items-center gap-3">
                  <UIcon
                    name="i-lucide-utensils"
                    class="w-5 h-5 text-orange-500"
                  />
                  <div>
                    <p class="font-medium text-sm">
                      Table Reservation
                    </p>
                    <p class="text-xs text-gray-500">
                      Restaurant booking system
                    </p>
                  </div>
                </div>
                <USwitch v-model="state.enabledFeatures.tableReservation" />
              </div>

              <div class="flex items-center justify-between p-3 bg-white dark:bg-gray-800 rounded-md border border-gray-200 dark:border-gray-700">
                <div class="flex items-center gap-3">
                  <UIcon
                    name="i-lucide-ticket"
                    class="w-5 h-5 text-purple-500"
                  />
                  <div>
                    <p class="font-medium text-sm">
                      Ticket System
                    </p>
                    <p class="text-xs text-gray-500">
                      Event ticketing
                    </p>
                  </div>
                </div>
                <USwitch v-model="state.enabledFeatures.ticketSystem" />
              </div>

              <div class="flex items-center justify-between p-3 bg-white dark:bg-gray-800 rounded-md border border-gray-200 dark:border-gray-700">
                <div class="flex items-center gap-3">
                  <UIcon
                    name="i-lucide-calendar-days"
                    class="w-5 h-5 text-pink-500"
                  />
                  <div>
                    <p class="font-medium text-sm">
                      Event System
                    </p>
                    <p class="text-xs text-gray-500">
                      Create and manage events
                    </p>
                  </div>
                </div>
                <USwitch v-model="state.enabledFeatures.eventSystem" />
              </div>

              <div class="flex items-center justify-between p-3 bg-white dark:bg-gray-800 rounded-md border border-gray-200 dark:border-gray-700 opacity-60">
                <div class="flex items-center gap-3">
                  <UIcon
                    name="i-lucide-bot"
                    class="w-5 h-5 text-blue-500"
                  />
                  <div>
                    <p class="font-medium text-sm">
                      AI Assistance (Datto)
                    </p>
                    <p class="text-xs text-gray-500">
                      Coming soon
                    </p>
                  </div>
                </div>
                <USwitch
                  v-model="state.enabledFeatures.aiAssistance"
                  disabled
                />
              </div>
            </div>
          </div>
          <USeparator class="my-2" />

          <!-- Group 3: Store Policy (Admin-only) -->
          <div class="space-y-4 p-4 bg-emerald-50 dark:bg-emerald-900/20 rounded-lg">
            <h3 class="text-sm font-semibold text-gray-900 dark:text-white mb-2 flex items-center gap-2">
              <UIcon
                name="i-lucide-store"
                class="w-4 h-4"
              />
              Store Policy
            </h3>
            <p class="text-xs text-gray-500 dark:text-gray-400 -mt-1">
              Control store creation limits for this company
            </p>

            <div class="space-y-3">
              <div class="flex items-center justify-between p-3 bg-white dark:bg-gray-800 rounded-md border border-gray-200 dark:border-gray-700">
                <div class="flex items-center gap-3">
                  <UIcon
                    name="i-lucide-hash"
                    class="w-5 h-5 text-emerald-500"
                  />
                  <div>
                    <p class="font-medium text-sm">
                      Maximum Stores
                    </p>
                    <p class="text-xs text-gray-500">
                      How many stores this company can have
                    </p>
                  </div>
                </div>
                <UInput
                  v-model.number="state.storePolicy.maxStores"
                  type="number"
                  min="0"
                  class="w-20"
                />
              </div>

              <div class="flex items-center justify-between p-3 bg-white dark:bg-gray-800 rounded-md border border-gray-200 dark:border-gray-700">
                <div class="flex items-center gap-3">
                  <UIcon
                    name="i-lucide-user-plus"
                    class="w-5 h-5 text-emerald-500"
                  />
                  <div>
                    <p class="font-medium text-sm">
                      Allow Self-Creation
                    </p>
                    <p class="text-xs text-gray-500">
                      Company owner can create their own stores
                    </p>
                  </div>
                </div>
                <USwitch v-model="state.storePolicy.canCreateOwnStores" />
              </div>
            </div>
          </div>
        <!-- Group 4: Details -->
        </UForm>
      </template>

      <template #footer>
        <UButton
          label="Cancel"
          color="neutral"
          variant="ghost"
          @click="handleClose"
        />
        <UButton
          type="submit"
          :loading="loading"
          color="primary"
          @click="form?.submit()"
        >
          {{ company ? 'Save Changes' : 'Create Company' }}
        </UButton>
      </template>
    </USlideover>
  </div>
</template>
