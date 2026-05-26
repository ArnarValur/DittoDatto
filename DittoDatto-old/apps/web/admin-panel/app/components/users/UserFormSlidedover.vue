<script setup lang="ts">
import { z } from 'zod'
import type { FormSubmitEvent } from '#ui/types'
import type { User, FirebaseUser } from '@dittodatto/shared-types'
import { UserSchema, UserRoleSchema } from '@dittodatto/shared-types'

const props = defineProps<{
  user?: User | FirebaseUser
  open?: boolean
}>()

const emit = defineEmits<{
  (e: 'close', payload?: User): void
  (e: 'update:open', value: boolean): void
  (e: 'saved'): void
}>()

const toast = useToast()
const form = ref()

// Fetch companies for the business role selector
const { data: companiesData } = await useFetch<{ companies: { id: string; name: string }[] }>('/api/companies/companies')
const companyOptions = computed(() =>
  (companiesData.value?.companies || []).map(c => ({ label: c.name, value: c.id }))
)
const loading = ref(false)

// Helper to get user ID (handles both User and FirebaseUser types)
const getUserId = computed(() => {
  if (!props.user) return undefined
  return 'uid' in props.user ? props.user.uid : props.user.id
})

// Helper to get user name (handles both User.name and FirebaseUser.displayName)
const getUserName = computed(() => {
  if (!props.user) return ''
  // FirebaseUser has displayName, User has name
  if ('displayName' in props.user && props.user.displayName !== undefined) {
    return props.user.displayName
  }
  if ('name' in props.user) {
    return props.user.name ?? ''
  }
  return ''
})

// We need a specific schema for the form that omits system fields
const FormSchema = UserSchema.omit({
  id: true,
  createdAt: true,
  updatedAt: true
}).extend({
  phone: z.string().optional()
})
type Schema = z.input<typeof FormSchema>

// Helper to get user phone (only exists on User type)
const getUserPhone = computed(() => {
  if (!props.user) return ''
  return 'phone' in props.user ? props.user.phone ?? '' : ''
})

const selectedCompanyId = ref('')

const state = reactive<Partial<Schema>>({
  name: getUserName.value,
  email: props.user?.email ?? '',
  role: props.user?.role ?? 'customer',
  phone: getUserPhone.value
})

// Show company selector for new business users
const showCompanySelector = computed(() =>
  !props.user && state.role === 'business'
)

// Unified Close Handler
function handleClose(payload?: User) {
  // 1. Signal v-model to update parent state to false
  emit('update:open', false)
  // 2. Signal useOverlay to resolve the promise
  emit('close', payload)
}

async function onSubmit(event: FormSubmitEvent<Schema>) {
  loading.value = true
  try {
    const isEdit = !!getUserId.value

    // Filter out undefined values and map field names
    const payload: any = {}

    // Always use displayName for API (both POST and PATCH expect it)
    if (event.data.name !== undefined && event.data.name !== '') {
      payload.displayName = event.data.name
    }
    if (event.data.email !== undefined && event.data.email !== '') {
      payload.email = event.data.email
    }
    if (event.data.role !== undefined) {
      payload.role = event.data.role
    }
    if (event.data.phone !== undefined && event.data.phone !== '') {
      payload.phone = event.data.phone
    }
    // Include companyId for new business users
    if (!isEdit && event.data.role === 'business' && selectedCompanyId.value) {
      payload.companyId = selectedCompanyId.value
    }

    // Add uid for PATCH requests
    if (isEdit) {
      payload.uid = getUserId.value
    }

    const endpoint = isEdit ? `/api/users/users` : '/api/users/users'
    const method = isEdit ? 'PATCH' : 'POST'

    const response = await $fetch<User>(endpoint, {
      method,
      body: payload
    })

    toast.add({
      title: isEdit ? 'User updated' : 'User created',
      description: `${response.name || payload.displayName} has been successfully saved.`,
      color: 'success'
    })
    emit('saved')
    // Close with data payload
    handleClose(response)
  } catch (error: any) {
    toast.add({
      title: 'Error',
      description: error.data?.message || 'Something went wrong',
      color: 'error'
    })
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <USlideover
    :open="open ?? true"
    :title="user ? 'Edit User' : 'New User'"
    :description="user ? `Update details for ${getUserName}` : 'Add a new user.'"
    :dismissible="false"
    :close="{ onClick: () => handleClose() }"
    @close="handleClose()"
  >
    <template #body>
      <UForm
        ref="form"
        :schema="FormSchema"
        :state="state"
        class="space-y-6"
        @submit="onSubmit"
      >
        <UFormField
          label="Name"
          name="name"
          required
        >
          <UInput
            v-model="state.name"
            placeholder="Ragnar Lóðbrók"
            class="w-full"
          />
        </UFormField>
        <UFormField
          label="Email"
          name="email"
          required
        >
          <UInput
            v-model="state.email"
            placeholder="ragnar@lodbrok.is"
            class="w-full"
          />
        </UFormField>
        <UFormField
          label="Role"
          name="role"
        >
          <USelect
            v-model="state.role"
            :items="UserRoleSchema.options"
            class="capitalize w-32"
          >
            <template #default>
              <span class="capitalize">{{ state.role }}</span>
            </template>
            <template #item-label="{ item }">
              <span class="capitalize">{{ item }}</span>
            </template>
          </USelect>
        </UFormField>
        <UFormField
          v-if="showCompanySelector"
          label="Company"
          name="companyId"
        >
          <USelect
            v-model="selectedCompanyId"
            :items="companyOptions"
            value-key="value"
            label-key="label"
            placeholder="Select a company"
            class="w-full"
          />
          <p class="text-xs text-muted mt-1">
            Assigns this user as the company owner with full portal access.
          </p>
        </UFormField>
        <UFormField
          label="Phone"
          name="phone"
        >
          <UInput
            v-model="state.phone"
            placeholder="+47-000-000-00"
          />
        </UFormField>
      </UForm>
    </template>

    <template #footer>
      <div class="flex justify-end gap-2 w-full">
        <UButton
          color="neutral"
          variant="ghost"
          @click="handleClose()"
        >
          Cancel
        </UButton>
        <UButton
          type="submit"
          :loading="loading"
          color="primary"
          @click="form?.submit()"
        >
          {{ user ? 'Save Changes' : 'Create User' }}
        </UButton>
      </div>
    </template>
  </USlideover>
</template>
