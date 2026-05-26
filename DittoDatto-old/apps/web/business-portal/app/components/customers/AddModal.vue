<script setup lang="ts">
import * as z from 'zod'
import type { FormSubmitEvent } from '@nuxt/ui'
import { collection, addDoc, serverTimestamp } from 'firebase/firestore'
import { useFirestore } from 'vuefire'

const schema = z.object({
  name: z.string().min(2, 'Too short'),
  email: z.string().email('Invalid email').or(z.literal('')).optional(),
  phone: z.string().optional(),
  notes: z.string().optional(),
})

const open = ref(false)
const saving = ref(false)

type Schema = z.output<typeof schema>

const state = reactive<Partial<Schema>>({
  name: undefined,
  email: undefined,
  phone: undefined,
  notes: undefined,
})

const toast = useToast()
const db = useFirestore()
const { companyId } = useCompany()
const { stores } = useStores()

// Default to first store
const selectedStoreId = ref<string | null>(null)
watch(stores, (val) => {
  if (val?.length && !selectedStoreId.value) {
    selectedStoreId.value = val[0].id
  }
}, { immediate: true })

const storeOptions = computed(() =>
  (stores.value ?? []).map(s => ({ label: s.name, value: s.id }))
)

function resetForm() {
  state.name = undefined
  state.email = undefined
  state.phone = undefined
  state.notes = undefined
}

async function onSubmit(event: FormSubmitEvent<Schema>) {
  if (!companyId.value) return

  saving.value = true
  try {
    const now = new Date().toISOString()
    const nameParts = (event.data.name || '').trim().split(/\s+/)
    const firstName = nameParts[0] || ''
    const lastName = nameParts.slice(1).join(' ') || ''

    await addDoc(collection(db, 'companies', companyId.value, 'customers'), {
      companyId: companyId.value,
      storeIds: selectedStoreId.value ? [selectedStoreId.value] : [],
      name: event.data.name,
      firstName,
      lastName,
      email: event.data.email || '',
      phone: event.data.phone || '',
      notes: event.data.notes || '',
      status: 'new',
      channel: 'portal',
      totalVisits: 0,
      totalSpent: 0,
      staffIds: [],
      createdAt: now,
      updatedAt: now,
    })

    toast.add({
      title: 'Customer created',
      description: `${event.data.name} has been added`,
      color: 'success',
    })
    resetForm()
    open.value = false
  } catch (err: any) {
    console.error('Failed to create customer:', err)
    toast.add({
      title: 'Error',
      description: err.message || 'Failed to create customer',
      color: 'error',
    })
  } finally {
    saving.value = false
  }
}
</script>

<template>
  <UModal v-model:open="open" title="New customer" description="Add a new customer to your CRM">
    <UButton label="New customer" icon="i-lucide-plus" />

    <template #body>
      <UForm
        :schema="schema"
        :state="state"
        class="space-y-4"
        @submit="onSubmit"
      >
        <UFormField label="Name" name="name" required>
          <UInput v-model="state.name" placeholder="John Doe" class="w-full" />
        </UFormField>

        <UFormField label="Email" name="email">
          <UInput v-model="state.email" type="email" placeholder="john@example.com" class="w-full" />
        </UFormField>

        <UFormField label="Phone" name="phone">
          <UInput v-model="state.phone" placeholder="+47 123 45 678" class="w-full" />
        </UFormField>

        <UFormField v-if="storeOptions.length > 1" label="Establishment">
          <USelect
            v-model="selectedStoreId"
            :items="storeOptions"
            value-attribute="value"
            option-attribute="label"
            class="w-full"
          />
        </UFormField>

        <UFormField label="Notes" name="notes">
          <UTextarea v-model="state.notes" placeholder="Optional notes about this customer..." :rows="2" class="w-full" />
        </UFormField>

        <div class="flex justify-end gap-2">
          <UButton
            label="Cancel"
            color="neutral"
            variant="subtle"
            @click="open = false"
          />
          <UButton
            label="Create"
            color="primary"
            variant="solid"
            type="submit"
            :loading="saving"
          />
        </div>
      </UForm>
    </template>
  </UModal>
</template>
