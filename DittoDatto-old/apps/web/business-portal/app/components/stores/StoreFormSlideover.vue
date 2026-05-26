<script setup lang="ts">
import { z } from 'zod'
import { collection, addDoc, doc, updateDoc } from 'firebase/firestore'
import type { FormSubmitEvent } from '#ui/types'
import type { Store } from '@dittodatto/shared-types'

const props = defineProps<{
  store?: Partial<Store> & { id?: string }
  open?: boolean
}>()

const emit = defineEmits<{
  (e: 'close'): void
  (e: 'update:open', value: boolean): void
  (e: 'saved'): void
}>()

const { company } = useCompany()
const db = useFirestore()
const toast = useToast()
const loading = ref(false)
const form = ref()

// Business type options
const storeTypeOptions = [
  { label: 'Store', value: 'store', icon: 'i-lucide-store', description: 'Retail, salon, spa, etc.' },
  { label: 'Restaurant', value: 'restaurant', icon: 'i-lucide-utensils', description: 'Dining, café, bar' },
  { label: 'Venue', value: 'venue', icon: 'i-lucide-building-2', description: 'Event space, club, theater' }
]

// Form State
const state = reactive({
  name: props.store?.name ?? '',
  address: props.store?.address ?? '',
  city: props.store?.city ?? '',
  zip: props.store?.zip ?? '',
  storeType: props.store?.storeType ?? 'store'
})

// Watch for prop changes (edit mode)
watch(() => props.store, (s) => {
  if (s) {
    state.name = s.name ?? ''
    state.address = s.address ?? ''
    state.city = s.city ?? ''
    state.zip = s.zip ?? ''
    state.storeType = s.storeType ?? 'store'
  }
}, { immediate: true })

// Schema
const FormSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  address: z.string().min(1, 'Address is required'),
  city: z.string().min(1, 'City is required'),
  zip: z.string().min(1, 'Zip is required'),
  storeType: z.enum(['store', 'restaurant', 'venue']).default('store')
})

type FormData = z.infer<typeof FormSchema>

async function onSubmit(event: FormSubmitEvent<FormData>) {
  if (!company.value?.id) return

  loading.value = true
  try {
    const payload = {
      ...event.data,
      companyId: company.value.id,
      // Default fields
      isActive: true,
      isPublished: false,
      currency: 'NOK',
      slug: event.data.name.toLowerCase().replace(/\s+/g, '-'), // Simple slugify
      createdAt: new Date(),
      updatedAt: new Date()
    }

    if (props.store?.id) {
      // Update
      await updateDoc(doc(db, 'companies', company.value.id, 'stores', props.store.id), {
        ...payload,
        updatedAt: new Date()
      })
      toast.add({ title: 'Store updated', color: 'success' })
    } else {
      // Create
      await addDoc(collection(db, 'companies', company.value.id, 'stores'), payload)
      toast.add({ title: 'Store created', color: 'success' })
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

function handleClose() {
  emit('update:open', false)
  emit('close')
}
</script>

<template>
  <USlideover
    :open="open ?? true"
    :title="store ? 'Edit Establishment' : 'Add Establishment'"
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
        <UFormField label="Business Type" name="storeType" required>
          <USelectMenu
            v-model="state.storeType"
            :items="storeTypeOptions"
            value-key="value"
            class="w-full"
          >
            <template #item="{ item }">
              <div class="flex items-center gap-3">
                <UIcon :name="item.icon" class="size-4 text-muted" />
                <div>
                  <p class="font-medium">
                    {{ item.label }}
                  </p>
                  <p class="text-xs text-muted">
                    {{ item.description }}
                  </p>
                </div>
              </div>
            </template>
          </USelectMenu>
        </UFormField>

        <UFormField label="Name" name="name" required>
          <UInput v-model="state.name" placeholder="My Awesome Store" />
        </UFormField>

        <UFormField label="Address" name="address" required>
          <UInput v-model="state.address" placeholder="Main Street 1" />
        </UFormField>

        <div class="grid grid-cols-2 gap-4">
          <UFormField label="City" name="city" required>
            <UInput v-model="state.city" />
          </UFormField>
          <UFormField label="Zip Code" name="zip" required>
            <UInput v-model="state.zip" />
          </UFormField>
        </div>
      </UForm>
    </template>

    <template #footer>
      <div class="flex justify-end gap-2 p-4">
        <UButton
          label="Cancel"
          color="neutral"
          variant="ghost"
          @click="handleClose"
        />
        <UButton
          label="Save"
          color="primary"
          :loading="loading"
          @click="form?.submit()"
        />
      </div>
    </template>
  </USlideover>
</template>
