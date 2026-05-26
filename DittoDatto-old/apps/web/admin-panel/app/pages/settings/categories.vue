<script setup lang="ts">
import type { Category } from '@dittodatto/shared-types'
import { refDebounced } from '@vueuse/core'

useHead({
  title: 'Categories - Settings'
})

definePageMeta({
  layout: 'admin-dashboard'
})

const toast = useToast()

// --- State ---
const search = ref('')
const page = ref(1)
const pageSize = ref(1000) // "All" categories practically
const loading = ref(false)

// Select Category for Edit (null = create mode)
const selectedCategory = ref<Category | null>(null)

interface CategoriesResponse {
  categories: Category[]
  total: number
  page: number
  pageSize: number
  hasNextPage: boolean
}

// --- API ---
const { data, refresh } = await useFetch<CategoriesResponse>('/api/settings/categories', {
  query: {
    page,
    pageSize,
    search: refDebounced(search, 500)
  }
})

// Form state

const state = reactive({
  id: undefined as string | undefined,
  name: '',
  description: '',
  icon: ''
})

// Sync form with selection
watch(selectedCategory, (newVal) => {
  if (newVal) {
    state.id = newVal.id
    state.name = newVal.name
    state.description = newVal.description || ''
    state.icon = newVal.icon || ''
  } else {
    resetForm()
  }
})

function resetForm() {
  state.id = undefined
  state.name = ''
  state.description = ''
  state.icon = ''
  selectedCategory.value = null
}

// --- Modal Controls ---
const isModalOpen = ref(false)

function openCreateModal() {
  resetForm()
  isModalOpen.value = true
}

function editCategory(category: Category) {
  selectedCategory.value = category
  isModalOpen.value = true
}

async function onSubmit() {
  loading.value = true
  try {
    await $fetch('/api/settings/categories', {
      method: 'POST',
      body: state
    })

    refresh()
    resetForm()
    isModalOpen.value = false
  } catch (err: unknown) {
    toast.add({ title: (err as Error)?.message || 'Failed to save category', color: 'error' })
  } finally {
    loading.value = false
  }
}

// Delete by ID (for modal button)
async function deleteById(id: string) {
  const confirmed = window.confirm('Are you sure you want to delete this category?')
  if (!confirmed) return

  loading.value = true
  try {
    await $fetch('/api/settings/categories', {
      method: 'DELETE',
      query: { id }
    })

    refresh()
    resetForm()
    isModalOpen.value = false
  } catch (err: unknown) {
    toast.add({ title: (err as Error)?.message || 'Failed to delete category', color: 'error' })
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <UDashboardPanel id="categories">
    <template #header>
      <UDashboardNavbar>
        <template #left>
          <UDashboardSidebarCollapse />
          <div class="ml-4 text-lg font-semibold">
            Categories
          </div>
        </template>

        <template #right>
          <UInput
            v-model="search"
            icon="i-lucide-search"
            placeholder="Search categories..."
            size="sm"
            class="hidden lg:block w-64"
          />
          <UButton
            label="Create Category"
            icon="i-lucide-plus"
            color="primary"
            @click="openCreateModal"
          />
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <!-- THE GRID (Clean & Visual) -->
      <div class="p-4 grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 lg:grid-cols-4 gap-4">
        <!-- Category Card -->
        <UCard
          v-for="category in data?.categories"
          :key="category.id"
          class="cursor-pointer hover:ring-2 hover:ring-primary-500 transition-all"
          @click="editCategory(category)"
        >
          <div class="flex items-center gap-4">
            <!-- Visual Icon Preview -->
            <div class="p-2 bg-gray-100 dark:bg-gray-800 rounded-lg">
              <UIcon
                :name="category.icon || 'i-lucide-folder'"
                class="w-6 h-6"
                :class="category.icon ? 'text-primary' : 'text-muted'"
              />
            </div>

            <div class="flex-1 min-w-0">
              <p class="font-medium truncate">
                {{ category.name }}
              </p>
              <p class="text-xs text-gray-500 truncate">
                {{ category.description || 'No description' }}
              </p>
            </div>
          </div>
        </UCard>

        <!-- Empty State -->
        <div
          v-if="!data?.categories?.length"
          class="col-span-full text-center text-gray-500 py-10"
        >
          No categories found. Create one to get started.
        </div>
      </div>
    </template>
  </UDashboardPanel>

  <!-- MODAL (The Form) -->

  <!-- eslint-disable-next-line vue/no-multiple-template-root -->
  <UModal
    v-model:open="isModalOpen"
    :title="state.id ? 'Edit Category' : 'Create Category'"
    :ui="{ footer: 'justify-end' }"
  >
    <template #body>
      <UForm
        :state="state"
        class="space-y-4"
        @submit="onSubmit"
      >
        <!-- Name -->
        <UFormField
          label="Name"
          required
        >
          <UInput
            v-model="state.name"
            placeholder="e.g. Burgers"
            autofocus
          />
        </UFormField>

        <!-- Icon (DDIconPicker) -->
        <UFormField
          label="Icon"
          help="Search and select an icon"
        >
          <DDIconPicker v-model="state.icon" />
        </UFormField>

        <!-- Description (Kept simple/optional) -->
        <UFormField label="Description (Optional)">
          <UTextarea
            v-model="state.description"
            placeholder="Short description for the store page..."
            :rows="2"
          />
        </UFormField>
      </UForm>
    </template>

    <template #footer>
      <UButton
        v-if="state.id"
        label="Delete"
        color="error"
        variant="ghost"
        @click="deleteById(state.id)"
      />
      <div class="flex gap-2 ml-auto">
        <UButton
          label="Cancel"
          color="neutral"
          variant="ghost"
          @click="isModalOpen = false"
        />
        <UButton
          label="Save"
          color="primary"
          :loading="loading"
          @click="onSubmit"
        />
      </div>
    </template>
  </UModal>
</template>
