<script setup lang="ts">
import { z } from 'zod'
import type { FormSubmitEvent } from '#ui/types'
import type { Store, Company, Category } from '@dittodatto/shared-types'

const props = defineProps<{
  store?: Store
  open?: boolean
}>()

const emit = defineEmits<{
  (e: 'close', payload?: Store): void
  (e: 'update:open', value: boolean): void
  (e: 'saved'): void
}>()

const toast = useToast()
const form = ref()
const loading = ref(false)

// --- 1. Async Company Lookup ---
// We need to select which Company this store belongs to.
interface CompanyOption {
  id: string
  name: string
  label: string
}

const selectedCompany = ref<CompanyOption | undefined>(undefined)

// Fetch companies for the dropdown
// optimization: In a real app with 10k companies, we would use server-side filtering.
// For MVP, fetching the list is fine.
const { data: companiesData } = await useFetch<{ companies: Company[] }>('/api/companies/companies', {
  lazy: true,
  default: () => ({ companies: [] })
})

// Fetch categories for the dropdown
interface CategoryOption {
  id: string
  name: string
  label: string
  icon?: string
}

const { data: categoriesData } = await useFetch<{ categories: Category[] }>('/api/settings/categories', {
  lazy: true,
  query: { pageSize: 1000 },
  default: () => ({ categories: [] })
})

// Transform for USelectMenu
const companyOptions = computed<CompanyOption[]>(() => {
  return companiesData.value.companies.map(c => ({
    id: c.id,
    name: c.name,
    label: `${c.name} (${c.tier})`
  }))
})

const categoryOptions = computed<CategoryOption[]>(() => {
  return categoriesData.value.categories.map(cat => ({
    id: cat.id,
    name: cat.name,
    label: cat.name,
    icon: cat.icon
  }))
})

// --- 2. Form State ---
const state = reactive({
  companyId: props.store?.companyId ?? '',
  name: props.store?.name ?? '',
  address: props.store?.address ?? '',
  city: props.store?.city ?? '',
  zip: props.store?.zip ?? '',
  country: props.store?.country ?? 'Norge',
  bookingFormType: 'standard' as const, // Deprecated - kept for backwards compatibility, booking mode is now on service level
  category: props.store?.category ?? '',
  isActive: props.store?.isActive ?? true
})

const selectedCategory = ref<CategoryOption | undefined>(undefined)

// Pre-fill state if editing
watch(() => props.store, (newVal) => {
  if (newVal) {
    // 1. Set Company
    if (newVal.companyId && companyOptions.value.length > 0) {
      const found = companyOptions.value.find(c => c.id === newVal.companyId)
      if (found) selectedCompany.value = found
    }

    // 2. Set other fields
    state.companyId = newVal.companyId
    state.name = newVal.name
    state.address = newVal.address
    state.city = newVal.city
    state.zip = newVal.zip
    state.country = newVal.country ?? 'Norge'
    // Note: bookingFormType is deprecated - always 'standard', booking mode is on service level
    state.category = newVal.category ?? ''
    state.isActive = newVal.isActive

    if (newVal.category && categoryOptions.value.length > 0) {
      const found = categoryOptions.value.find(c => c.id === newVal.category || c.name === newVal.category)
      if (found) selectedCategory.value = found
    }
  } else {
    // Reset for new store
    selectedCompany.value = undefined
    state.companyId = ''
    state.name = ''
    state.address = ''
    state.city = ''
    state.zip = ''
    state.country = 'Norge'
    state.bookingFormType = 'standard'
    state.category = ''
    state.isActive = true
    selectedCategory.value = undefined
  }
}, { immediate: true })

// Also watch companyOptions to set selectedCompany if data loads after store prop
watch(companyOptions, (opts) => {
  if (props.store?.companyId && opts.length > 0 && !selectedCompany.value) {
    const found = opts.find(c => c.id === props.store?.companyId)
    if (found) selectedCompany.value = found
  }
})

// Sync Dropdown -> State
watch(selectedCompany, (val) => {
  if (val) {
    state.companyId = val.id
  }
})

watch(selectedCategory, (val) => {
  if (val) state.category = val.id
})

// --- 3. Schema & Validation ---
// We refine the shared schema to match our form needs
const FormSchema = z.object({
  companyId: z.string().min(1, 'Company is required'),
  name: z.string().min(2, 'Name is too short'),
  address: z.string().min(5, 'Address is required'),
  city: z.string().min(2, 'City is required'),
  zip: z.string().optional(),
  country: z.string().optional(),
  bookingFormType: z.string().default('standard'), // Deprecated - kept for backwards compat
  category: z.string().min(1, 'Category is required'),
  isActive: z.boolean()
})

type Schema = z.output<typeof FormSchema>

// --- 4. Actions ---
function handleClose() {
  emit('update:open', false)
  emit('close')
}

async function onSubmit(event: FormSubmitEvent<Schema>) {
  loading.value = true
  try {
    const isEdit = !!props.store?.id
    const endpoint = '/api/stores/stores'
    const method = isEdit ? 'PATCH' : 'POST'

    const payload = {
      ...event.data,
      id: props.store?.id // Only needed for PATCH
    }

    await $fetch(endpoint, { method, body: payload })

    toast.add({
      title: isEdit ? 'Store updated' : 'Store created',
      description: `${payload.name} is ready for business.`,
      color: 'success'
    })

    emit('saved')
    handleClose()
  } catch (error: unknown) {
    toast.add({
      title: 'Error',
      description: (error as Error)?.message || 'Failed to save store',
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
    :title="store ? 'Edit Store' : 'New Store'"
    :description="store ? `Manage location details for ${store.name}` : 'Add a new physical location.'"
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
            label="Parent Company"
            name="companyId"
            required
          >
            <USelectMenu
              v-model="selectedCompany"
              :items="companyOptions"
              searchable
              searchable-placeholder="Search companies..."
              placeholder="Select a company"
              icon="i-lucide-building-2"
              class="w-full"
              :disabled="!!store"
            >
              <template #item-label="{ item }">
                <div class="flex flex-col">
                  <span class="font-medium">{{ item.name }}</span>
                </div>
              </template>
            </USelectMenu>
          </UFormField>

          <UFormField
            label="Store Name"
            name="name"
            required
          >
            <UInput
              v-model="state.name"
              placeholder="Viking Barbers Oslo S"
              class="w-full"
            />
          </UFormField>

          <UFormField
            label="Category"
            name="category"
            required
          >
            <USelectMenu
              v-model="selectedCategory"
              :items="categoryOptions"
              searchable
              searchable-placeholder="Search categories..."
              placeholder="Select a category"
              icon="i-lucide-tag"
              class="w-full"
            >
              <template #item-label="{ item }">
                <div class="flex items-center gap-2">
                  <span>{{ item.name }}</span>
                </div>
              </template>
            </USelectMenu>
          </UFormField>

          <!-- Booking Mode removed - now configured per-service -->
          <!-- Status toggle hidden - not needed in form -->
        </div>

        <USeparator class="my-2" />

        <!-- Group 2: Location -->
        <div class="space-y-4 p-4">
          <h3 class="text-sm font-semibold text-gray-900 dark:text-white mb-2">
            Location
          </h3>

          <UFormField
            label="Street Address"
            name="address"
            required
          >
            <UInput
              v-model="state.address"
              icon="i-lucide-map-pin"
              placeholder="Storgata 1"
            />
          </UFormField>

          <div class="grid grid-cols-3 gap-">
            <UFormField
              label="Zip"
              name="zip"
              class="col-span-1 w-16"
            >
              <UInput
                v-model="state.zip"
                placeholder="0155"
              />
            </UFormField>
            <UFormField
              label="City"
              name="city"
              class="col-span-2"
              required
            >
              <UInput
                v-model="state.city"
                placeholder="Oslo"
              />
            </UFormField>
          </div>

          <!-- <UFormField label="Country" name="country">
            <UInput v-model="state.country" placeholder="Norge" />
          </UFormField> -->
        </div>
      </UForm>
    </template>

    <template #footer>
      <UButton
        label="Cancel"
        color="neutral"
        variant="ghost"
        type="button"
        @click="handleClose"
      />
      <UButton
        type="submit"
        :loading="loading"
        color="primary"
        @click="form?.submit()"
      >
        {{ store ? 'Save Changes' : 'Launch Store' }}
      </UButton>
    </template>
  </USlideover>
</template>
