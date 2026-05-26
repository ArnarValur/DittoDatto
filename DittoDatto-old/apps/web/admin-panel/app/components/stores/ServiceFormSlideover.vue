<script setup lang="ts">
import { z } from 'zod'
import type { FormSubmitEvent } from '#ui/types'
import type { Service, Store, Company } from '@dittodatto/shared-types'

const props = defineProps<{
  service?: Service & { companyId: string }
  open?: boolean
}>()

const emit = defineEmits<{
  (e: 'close'): void
  (e: 'update:open', value: boolean): void
  (e: 'saved'): void
}>()

const toast = useToast()
const form = ref()
const loading = ref(false)

// --- 1. Async Lookups ---
const selectedCompany = ref<{ id: string, name: string, label: string } | undefined>(undefined)
const selectedStore = ref<{ id: string, name: string, label: string } | undefined>(undefined)

// Fetch Companies
const { data: companiesData } = await useFetch<{ companies: Company[] }>('/api/companies/companies', {
  lazy: true,
  default: () => ({ companies: [] })
})

const companyOptions = computed(() => {
  return companiesData.value.companies.map(c => ({
    id: c.id,
    name: c.name,
    label: c.name
  }))
})

// Fetch Stores (reactive to selectedCompany)
const { data: storesData, refresh: refreshStores } = await useFetch<{ stores: Store[] }>('/api/stores/stores', {
  lazy: true,
  query: computed(() => ({ companyId: selectedCompany.value?.id })),
  default: () => ({ stores: [] })
})

const storeOptions = computed(() => {
  return storesData.value.stores.map(s => ({
    id: s.id,
    name: s.name,
    label: s.name
  }))
})

// --- 2. Form State ---
const state = reactive({
  companyId: props.service?.companyId ?? '',
  storeId: props.service?.storeId ?? '',
  title: props.service?.title ?? '',
  description: props.service?.description ?? '',
  duration: props.service?.duration ?? 30,
  price: props.service?.price ?? 0,
  currency: props.service?.currency ?? 'NOK',
  isActive: props.service?.isActive ?? true,
  keywords: props.service?.keywords ?? [] as string[],
  serviceType: props.service?.serviceType ?? [] as string[]
})

// Sync lookups on edit
watch(() => props.service, (newVal) => {
  if (newVal) {
    state.companyId = newVal.companyId
    state.storeId = newVal.storeId
    state.title = newVal.title
    state.description = newVal.description ?? ''
    state.duration = newVal.duration
    state.price = newVal.price
    state.currency = newVal.currency
    state.isActive = newVal.isActive
    state.keywords = newVal.keywords ? [...newVal.keywords] : []
    state.serviceType = newVal.serviceType ? [...newVal.serviceType] : []

    // Set selected objects
    if (newVal.companyId) {
      selectedCompany.value = companyOptions.value.find(c => c.id === newVal.companyId)
    }
  } else {
    // Reset
    state.companyId = ''
    state.storeId = ''
    state.title = ''
    state.description = ''
    state.duration = 30
    state.price = 0
    state.currency = 'NOK'
    state.isActive = true
    state.keywords = []
    state.serviceType = []
    selectedCompany.value = undefined
    selectedStore.value = undefined
  }
}, { immediate: true })

// Set selectedStore when stores load during edit
watch(storeOptions, (opts) => {
  if (props.service?.storeId && opts.length > 0 && !selectedStore.value) {
    selectedStore.value = opts.find(s => s.id === props.service?.storeId)
  }
})

// Sync selections to state
watch(selectedCompany, (val) => {
  state.companyId = val?.id ?? ''
  if (!val) {
    selectedStore.value = undefined
    state.storeId = ''
  }
})
watch(selectedStore, (val) => {
  state.storeId = val?.id ?? ''
})

// --- 3. Validation ---
const FormSchema = z.object({
  companyId: z.string().min(1, 'Company is required'),
  storeId: z.string().min(1, 'Store is required'),
  title: z.string().min(2, 'Title is too short'),
  description: z.string().optional(),
  duration: z.number().int().positive('Duration must be positive'),
  price: z.number().min(0, 'Price cannot be negative'),
  currency: z.enum(['NOK', 'USD']),
  isActive: z.boolean(),
  keywords: z.array(z.string()).default([]),
  serviceType: z.array(z.string()).default([])
})

// --- 4. Actions ---
function handleClose() {
  emit('update:open', false)
  emit('close')
}

// Help with Tag Input (Keywords)
const newKeyword = ref('')
function addKeyword() {
  if (newKeyword.value.trim() && !state.keywords.includes(newKeyword.value.trim())) {
    state.keywords.push(newKeyword.value.trim())
    newKeyword.value = ''
  }
}
function removeKeyword(index: number) {
  state.keywords.splice(index, 1)
}

async function onSubmit(event: FormSubmitEvent<any>) {
  loading.value = true
  try {
    const isEdit = !!props.service?.id
    const method = isEdit ? 'PATCH' : 'POST'

    const payload = {
      ...event.data,
      id: props.service?.id
    }

    await $fetch('/api/services/services', { method, body: payload })

    toast.add({
      title: isEdit ? 'Service updated' : 'Service created',
      description: `"${payload.title}" is now available.`,
      color: 'success'
    })

    emit('saved')
    handleClose()
  } catch (error: any) {
    toast.add({
      title: 'Error',
      description: error.data?.statusMessage || error.message,
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
    :title="service ? 'Edit Service' : 'New Service'"
    :description="service ? `Manage details for ${service.title}` : 'Define a new offering for a store.'"
    :dismissible="false"
    :ui="{ footer: 'justify-end' }"
    @update:open="(val) => emit('update:open', val)"
  >
    <template #body>
      <UForm
        ref="form"
        :schema="FormSchema"
        :state="state"
        class="space-y-6"
        @submit="onSubmit"
      >
        <!-- Context: Where does this service belong? -->
        <div class="space-y-4 p-4 bg-gray-50 dark:bg-gray-800/50 rounded-lg">
          <h3 class="text-xs font-bold uppercase tracking-wider text-gray-400">
            Context
          </h3>

          <UFormField
            label="Company"
            name="companyId"
            required
          >
            <USelectMenu
              v-model="selectedCompany"
              :items="companyOptions"
              searchable
              placeholder="Select Company"
              :disabled="!!service"
            />
          </UFormField>

          <UFormField
            label="Store"
            name="storeId"
            required
          >
            <USelectMenu
              v-model="selectedStore"
              :items="storeOptions"
              searchable
              placeholder="Select Store"
              :disabled="!selectedCompany || !!service"
            />
          </UFormField>
        </div>

        <!-- Essentials -->
        <div class="space-y-4 p-4">
          <h3 class="text-xs font-bold uppercase tracking-wider text-gray-400">
            Basic Info
          </h3>

          <UFormField
            label="Title"
            name="title"
            required
          >
            <UInput
              v-model="state.title"
              placeholder="Haircut, Consultation, etc."
            />
          </UFormField>

          <UFormField
            label="Description"
            name="description"
          >
            <UTextarea
              v-model="state.description"
              placeholder="Short summary of the service..."
            />
          </UFormField>

          <div class="grid grid-cols-2 gap-4">
            <UFormField
              label="Duration (min)"
              name="duration"
              required
            >
              <UInput
                v-model.number="state.duration"
                type="number"
              />
            </UFormField>

            <UFormField
              label="Status"
              name="isActive"
            >
              <div class="flex items-center h-full">
                <UToggle v-model="state.isActive" />
                <span class="ml-2 text-sm">{{ state.isActive ? 'Active' : 'Inactive' }}</span>
              </div>
            </UFormField>
          </div>
        </div>

        <!-- Pricing -->
        <div class="space-y-4 p-4 bg-gray-50 dark:bg-gray-800/50 rounded-lg">
          <h3 class="text-xs font-bold uppercase tracking-wider text-gray-400">
            Pricing
          </h3>
          <div class="grid grid-cols-2 gap-4">
            <UFormField
              label="Price"
              name="price"
              required
            >
              <UInput
                v-model.number="state.price"
                type="number"
              />
            </UFormField>
            <UFormField
              label="Currency"
              name="currency"
              required
            >
              <USelect
                v-model="state.currency"
                :items="['NOK', 'USD']"
              />
            </UFormField>
          </div>
        </div>

        <!-- AI Keywords / Tags -->
        <div class="space-y-4 p-4">
          <h3 class="text-xs font-bold uppercase tracking-wider text-gray-400">
            Meta & Keywords (AI)
          </h3>

          <UFormField
            label="Keywords (Press Enter to add)"
            name="keywords"
          >
            <UInput
              v-model="newKeyword"
              placeholder="e.g. hair, beauty, massage"
              @keydown.enter.prevent="addKeyword"
            />
            <div class="flex flex-wrap gap-1 mt-2">
              <UBadge
                v-for="(tag, idx) in state.keywords"
                :key="idx"
                variant="subtle"
                class="flex items-center gap-1"
              >
                {{ tag }}
                <UIcon
                  name="i-lucide-x"
                  class="w-3 h-3 cursor-pointer hover:text-red-500"
                  @click="removeKeyword(idx)"
                />
              </UBadge>
            </div>
          </UFormField>
        </div>
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
        {{ service ? 'Save Changes' : 'Create Service' }}
      </UButton>
    </template>
  </USlideover>
</template>
