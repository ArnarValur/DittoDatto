<script setup lang="ts">
useHead({
  title: 'Icon Manager - Settings'
})

definePageMeta({
  layout: 'admin-dashboard'
})

const {
  collections,
  loading,
  selectedCollection,
  isModalOpen,
  form,
  fetchCollections,
  deleteCollection,
  handleFileUpload,
  openCreateModal,
  openEditModal,
  closeModal,
  saveCollection
} = useIconManager()

const toast = useToast()
const fileInput = ref<HTMLInputElement | null>(null)
const searchQuery = ref('')
const uploading = ref(false)

// Fetch collections on mount
onMounted(() => {
  fetchCollections()
})

// Filtered icons for display
const filteredIcons = computed(() => {
  if (!searchQuery.value) return form.icons.slice(0, 100)
  const query = searchQuery.value.toLowerCase()
  return form.icons.filter(icon => icon.toLowerCase().includes(query)).slice(0, 100)
})

// Handle file selection
async function onFileChange(event: Event) {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  if (!file) return

  uploading.value = true
  try {
    const icons = await handleFileUpload(file)
    form.icons = icons
    toast.add({ title: `Loaded ${icons.length} icons from file`, color: 'success' })
  } catch (err) {
    toast.add({ title: (err as Error).message, color: 'error' })
  } finally {
    uploading.value = false
  }

  // Reset input
  if (fileInput.value) fileInput.value.value = ''
}

// Remove icon from form
function removeIcon(index: number) {
  form.icons.splice(index, 1)
}

// Clear all icons
function clearIcons() {
  form.icons = []
}

// Confirm delete
async function confirmDelete(id: string) {
  if (confirm('Are you sure you want to delete this collection?')) {
    await deleteCollection(id)
  }
}
</script>

<template>
  <!-- eslint-disable-next-line vue/no-multiple-template-root -->
  <UDashboardPanel id="icon-manager">
    <template #header>
      <UDashboardNavbar>
        <template #left>
          <UDashboardSidebarCollapse />
          <div class="ml-4 text-lg font-semibold">
            Icon Manager
          </div>
        </template>

        <template #right>
          <UButton
            label="Add Collection"
            icon="i-lucide-plus"
            color="primary"
            @click="openCreateModal"
          />
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <div class="p-4 space-y-6">
        <!-- Loading State -->
        <div
          v-if="loading"
          class="flex justify-center py-10"
        >
          <UIcon
            name="i-lucide-loader-2"
            class="size-8 animate-spin text-primary"
          />
        </div>

        <!-- Collections Grid -->
        <div
          v-else
          class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4"
        >
          <UCard
            v-for="collection in collections"
            :key="collection.id"
            class="cursor-pointer hover:ring-2 hover:ring-primary transition-all"
            @click="openEditModal(collection)"
          >
            <div class="space-y-3">
              <!-- Header -->
              <div class="flex items-center justify-between">
                <h3 class="font-semibold">
                  {{ collection.name }}
                </h3>
                <UBadge
                  v-if="collection.isDefault"
                  color="primary"
                  variant="subtle"
                >
                  Default
                </UBadge>
              </div>

              <!-- Description -->
              <p
                v-if="collection.description"
                class="text-sm text-muted truncate"
              >
                {{ collection.description }}
              </p>

              <!-- Icon Preview Grid -->
              <div class="grid grid-cols-8 gap-1">
                <div
                  v-for="icon in collection.icons.slice(0, 16)"
                  :key="icon"
                  class="flex items-center justify-center w-6 h-6 bg-elevated rounded"
                >
                  <UIcon
                    :name="icon"
                    class="size-4"
                  />
                </div>
                <div
                  v-if="collection.icons.length > 16"
                  class="flex items-center justify-center w-6 h-6 bg-elevated rounded text-xs text-muted"
                >
                  +{{ collection.icons.length - 16 }}
                </div>
              </div>

              <!-- Stats -->
              <div class="text-xs text-muted">
                {{ collection.icons.length }} icons
              </div>
            </div>
          </UCard>

          <!-- Empty State -->
          <div
            v-if="collections.length === 0"
            class="col-span-full text-center text-muted py-10"
          >
            No icon collections found. Create one to get started.
          </div>
        </div>
      </div>
    </template>
  </UDashboardPanel>

  <!-- Edit/Create Modal -->
  <UModal
    v-model:open="isModalOpen"
    :title="selectedCollection ? 'Edit Collection' : 'Create Collection'"
    :ui="{ content: 'max-w-2xl' }"
  >
    <template #body>
      <div class="space-y-4">
        <!-- Name -->
        <UFormField
          label="Collection Name"
          required
        >
          <UInput
            v-model="form.name"
            placeholder="e.g., Sushi Icons"
            :disabled="selectedCollection?.isDefault"
          />
        </UFormField>

        <!-- Description -->
        <UFormField label="Description">
          <UTextarea
            v-model="form.description"
            placeholder="Optional description..."
            :rows="2"
          />
        </UFormField>

        <!-- JSON Upload -->
        <UFormField label="Upload Icons (JSON)">
          <div class="border-2 border-dashed border-accented rounded-lg p-4 text-center">
            <input
              ref="fileInput"
              type="file"
              accept=".json"
              class="hidden"
              @change="onFileChange"
            >
            <!-- Loading Spinner -->
            <template v-if="uploading">
              <UIcon
                name="i-lucide-loader-2"
                class="size-8 text-primary mx-auto mb-2 animate-spin"
              />
              <p class="text-sm text-muted mb-2">
                Processing icons...
              </p>
            </template>
            <!-- Upload Prompt -->
            <template v-else>
              <UIcon
                name="i-lucide-upload"
                class="size-8 text-muted mx-auto mb-2"
              />
              <p class="text-sm text-muted mb-2">
                Drop Iconify/Solar JSON or click to upload
              </p>
              <UButton
                size="sm"
                variant="outline"
                :disabled="selectedCollection?.isDefault"
                @click="fileInput?.click()"
              >
                Choose File
              </UButton>
            </template>
          </div>
        </UFormField>

        <!-- Icons Preview -->
        <UFormField
          v-if="form.icons.length > 0"
          label="Icons"
        >
          <div class="space-y-2">
            <div class="flex items-center justify-between">
              <span class="text-sm text-muted">{{ form.icons.length }} icons loaded</span>
              <UButton
                v-if="!selectedCollection?.isDefault"
                size="xs"
                color="error"
                variant="ghost"
                @click="clearIcons"
              >
                Clear All
              </UButton>
            </div>

            <!-- Search -->
            <UInput
              v-model="searchQuery"
              placeholder="Filter icons..."
              icon="i-lucide-search"
              size="sm"
            />

            <!-- Icon Grid -->
            <div class="grid grid-cols-10 gap-1 max-h-48 overflow-y-auto border border-default rounded p-2">
              <div
                v-for="(icon, index) in filteredIcons"
                :key="icon"
                class="relative group flex items-center justify-center w-8 h-8 border border-default rounded hover:bg-elevated cursor-pointer"
                :title="icon"
                @click="removeIcon(index)"
              >
                <UIcon
                  :name="icon"
                  class="size-5"
                />
                <div
                  v-if="!selectedCollection?.isDefault"
                  class="absolute -top-1 -right-1 w-4 h-4 bg-error text-white rounded-full flex items-center justify-center text-xs opacity-0 group-hover:opacity-100 transition-opacity"
                >
                  ×
                </div>
              </div>
            </div>
          </div>
        </UFormField>
      </div>
    </template>

    <template #footer>
      <div class="flex justify-between w-full">
        <UButton
          v-if="selectedCollection && !selectedCollection.isDefault"
          label="Delete"
          color="error"
          variant="ghost"
          @click="confirmDelete(selectedCollection.id)"
        />
        <div class="flex gap-2 ml-auto">
          <UButton
            label="Cancel"
            color="neutral"
            variant="ghost"
            @click="closeModal"
          />
          <UButton
            label="Save"
            color="primary"
            :loading="loading"
            :disabled="!form.name || form.icons.length === 0 || selectedCollection?.isDefault"
            @click="saveCollection"
          />
        </div>
      </div>
    </template>
  </UModal>
</template>
