<script setup lang="ts">
import type { MediaItem, MediaType } from '@dittodatto/shared-types'
import { collection, query, where, orderBy, doc, updateDoc } from 'firebase/firestore'
import { useFirestore, useCollection } from 'vuefire'

useHead({
  title: 'Media Gallery'
})

definePageMeta({
  layout: 'dashboard'
})

const db = useFirestore()
const toast = useToast()
const { companyId, loading: companyLoading } = useCompany()
const { stores, loading: storesLoading } = useStores()
const { state: uploadState, uploadFile, uploadFiles, deleteMedia, validateFile } = useMediaUpload()
const { isOwner, hasCapability } = useStaffPermissions()

const canManageMedia = computed(() => isOwner.value || hasCapability('can_manage_media'))

// ── Filters ─────────────────────────────────────────
const searchQuery = ref('')
const selectedStoreId = ref<string | null>(null)
const selectedTag = ref<string | null>(null)

// Upload type selector
const mediaTypeOptions = [
  { value: 'logo', label: 'Logo' },
  { value: 'cover', label: 'Cover Image' },
  { value: 'store_gallery', label: 'Store Gallery' },
  { value: 'staff_portrait', label: 'Staff' },
  { value: 'general', label: 'General' }
]
const selectedUploadType = ref('general')

// ── Data ────────────────────────────────────────────
const mediaQuery = computed(() => {
  if (!companyId.value) return null
  return query(
    collection(db, 'media'),
    where('companyId', '==', companyId.value),
    orderBy('createdAt', 'desc')
  )
})

const mediaItems = useCollection<MediaItem>(mediaQuery)
const isLoading = computed(() => mediaItems.pending.value || companyLoading.value)

// ── Store filter options ────────────────────────────
const storeFilterOptions = computed(() => {
  const options: { value: string | null; label: string; icon?: string }[] = [
    { value: null, label: 'All Stores', icon: 'i-lucide-layers' }
  ]
  if (stores.value) {
    for (const store of stores.value) {
      options.push({
        value: store.id,
        label: store.name || store.id,
        icon: 'i-lucide-store'
      })
    }
  }
  options.push({ value: '__none__', label: 'Company-wide', icon: 'i-lucide-building-2' })
  return options
})

// ── Extract unique tags from all media ──────────────
const availableTags = computed(() => {
  const tagSet = new Set<string>()
  if (mediaItems.value) {
    for (const item of mediaItems.value) {
      for (const tag of (item.tags || [])) {
        tagSet.add(tag)
      }
      // Also include the deprecated `type` field as a tag for filtering
      if (item.type) tagSet.add(item.type)
    }
  }
  return Array.from(tagSet).sort()
})

// ── Filtered items ──────────────────────────────────
const filteredItems = computed(() => {
  let items = mediaItems.value || []

  // Store filter
  if (selectedStoreId.value === '__none__') {
    items = items.filter(item => !item.storeId)
  } else if (selectedStoreId.value) {
    items = items.filter(item => item.storeId === selectedStoreId.value)
  }

  // Tag filter
  if (selectedTag.value) {
    items = items.filter(item =>
      (item.tags || []).includes(selectedTag.value!) ||
      item.type === selectedTag.value
    )
  }

  // Search
  if (searchQuery.value) {
    const q = searchQuery.value.toLowerCase()
    items = items.filter(item =>
      (item.name || '').toLowerCase().includes(q) ||
      item.filename.toLowerCase().includes(q) ||
      (item.tags || []).some(tag => tag.toLowerCase().includes(q))
    )
  }

  return items
})

// Active filter count for badge
const activeFilterCount = computed(() => {
  let count = 0
  if (selectedStoreId.value) count++
  if (selectedTag.value) count++
  if (searchQuery.value) count++
  return count
})

function clearFilters() {
  searchQuery.value = ''
  selectedStoreId.value = null
  selectedTag.value = null
}

// ── File upload ─────────────────────────────────────
const fileInput = ref<HTMLInputElement | null>(null)
const optimisticPreviews = ref<{ url: string; filename: string; done: boolean }[]>([])

function triggerUpload() {
  if (!companyId.value) {
    toast.add({ title: 'Error', description: 'Company not loaded yet.', color: 'error' })
    return
  }
  fileInput.value?.click()
}

async function handleFileSelect(event: Event) {
  const target = event.target as HTMLInputElement
  const files = target.files
  if (!files || files.length === 0 || !companyId.value) return

  // Convert FileList to array and validate
  const fileArray = Array.from(files)
  const validFiles: File[] = []
  for (const file of fileArray) {
    const validation = validateFile(file)
    if (!validation.valid) {
      toast.add({ title: 'Skipped', description: `${file.name}: ${validation.error}`, color: 'warning' })
    } else {
      validFiles.push(file)
    }
  }

  if (validFiles.length === 0) {
    target.value = ''
    return
  }

  // Show optimistic previews for all queued files
  optimisticPreviews.value = validFiles.map(f => ({
    url: URL.createObjectURL(f),
    filename: f.name,
    done: false
  }))

  // Resolve storeId: if a specific store is selected in the filter, tag to that store
  const uploadStoreId = selectedStoreId.value && selectedStoreId.value !== '__none__'
    ? selectedStoreId.value
    : undefined

  const options = {
    companyId: companyId.value,
    storeId: uploadStoreId,
    type: selectedUploadType.value as MediaType
  }

  let successCount = 0
  let failCount = 0

  await uploadFiles(validFiles, options, (_file, result, index) => {
    // Mark preview as done
    if (optimisticPreviews.value[index]) {
      optimisticPreviews.value[index].done = true
    }
    if (result) {
      successCount++
    } else {
      failCount++
      toast.add({ title: 'Failed', description: `${_file.name}: ${uploadState.error || 'Upload failed'}`, color: 'error' })
    }
  })

  // Clean up optimistic previews
  for (const preview of optimisticPreviews.value) {
    URL.revokeObjectURL(preview.url)
  }
  optimisticPreviews.value = []

  // Summary toast TODO: Fix undefined
  if (successCount > 0) {
    toast.add({
      title: 'Upload Complete',
      description: successCount === 1
        ? `${validFiles[0].name} added to your gallery.`
        : `${successCount} files added to your gallery.${failCount > 0 ? ` ${failCount} failed.` : ''}`,
      color: 'success'
    })
  }

  target.value = ''
}

async function handleDelete(item: MediaItem) {
  if (!confirm(`Delete "${item.filename}"? This cannot be undone.`)) return

  const success = await deleteMedia(item)
  if (success) {
    toast.add({ title: 'Deleted', description: 'File removed from gallery.', color: 'success' })
  } else {
    toast.add({ title: 'Error', description: 'Failed to delete file.', color: 'error' })
  }
}

// ── Store reassignment ──────────────────────────────
const reassignItem = ref<MediaItem | null>(null)
const reassignStoreId = ref<string | null>(null)
const reassignOpen = ref(false)
const reassigning = ref(false)

function openReassign(item: MediaItem) {
  reassignItem.value = item
  reassignStoreId.value = item.storeId || null
  reassignOpen.value = true
}

const reassignStoreOptions = computed(() => {
  const options: { value: string | null; label: string; icon?: string }[] = [
    { value: null, label: 'Company-wide (no store)', icon: 'i-lucide-building-2' }
  ]
  if (stores.value) {
    for (const store of stores.value) {
      options.push({
        value: store.id,
        label: store.name || store.id,
        icon: 'i-lucide-store'
      })
    }
  }
  return options
})

async function confirmReassign() {
  if (!reassignItem.value) return

  reassigning.value = true
  try {
    const mediaRef = doc(db, 'media', reassignItem.value.id)
    await updateDoc(mediaRef, {
      storeId: reassignStoreId.value || null,
      updatedAt: new Date()
    })

    const targetName = reassignStoreId.value
      ? reassignStoreOptions.value.find(o => o.value === reassignStoreId.value)?.label || 'store'
      : 'Company-wide'

    toast.add({
      title: 'Moved',
      description: `"${reassignItem.value.filename}" moved to ${targetName}.`,
      color: 'success'
    })
    reassignOpen.value = false
    reassignItem.value = null
  } catch (err) {
    console.error('Reassign error:', err)
    toast.add({ title: 'Error', description: 'Failed to move media.', color: 'error' })
  } finally {
    reassigning.value = false
  }
}

// ── Helpers ─────────────────────────────────────────
function getStoreName(storeId: string | undefined): string {
  if (!storeId || !stores.value) return 'Company-wide'
  const store = stores.value.find(s => s.id === storeId)
  return store?.name || 'Unknown Store'
}

function formatDate(timestamp: any): string {
  if (!timestamp) return ''
  const date = timestamp.toDate ? timestamp.toDate() : new Date(timestamp)
  const now = new Date()
  const diffMs = now.getTime() - date.getTime()
  const diffDays = Math.floor(diffMs / (1000 * 60 * 60 * 24))

  if (diffDays === 0) return 'Today'
  if (diffDays === 1) return 'Yesterday'
  if (diffDays < 7) return `${diffDays}d ago`
  if (diffDays < 30) return `${Math.floor(diffDays / 7)}w ago`
  return `${Math.floor(diffDays / 30)}mo ago`
}
</script>

<template>
  <!--
  -- TODO: Low priority but this page can be modularized into smaller components, its getting long.
  -->
  <UDashboardPanel id="media-gallery">
    <template #header>
      <UDashboardNavbar>
        <template #left>
          <UDashboardSidebarCollapse />
          <div class="ml-4">
            <h1 class="text-lg font-semibold">Media Gallery</h1>
          </div>
        </template>

        <template #right>
          <div v-if="canManageMedia" class="flex gap-2 items-center">
            <!-- Upload type selector -->
            <USelectMenu
              v-model="selectedUploadType"
              :items="mediaTypeOptions"
              value-key="value"
              class="w-40"
            >
              <template #default="{ modelValue }">
                {{ mediaTypeOptions.find(o => o.value === modelValue)?.label || 'General' }}
              </template>
            </USelectMenu>
            <UButton
              icon="i-lucide-upload"
              label="Upload"
              color="neutral"
              :loading="uploadState.isUploading"
              :disabled="!companyId"
              @click="triggerUpload"
            />
          </div>
          <input
            ref="fileInput"
            type="file"
            accept="image/jpeg,image/png,image/webp,image/svg+xml,image/heic,image/heif"
            multiple
            class="hidden"
            @change="handleFileSelect"
          >
        </template>
      </UDashboardNavbar>

      <!-- Filter Toolbar -->
      <UDashboardToolbar>
        <template #left>
          <div class="flex items-center gap-3 flex-wrap">
            <!-- Search -->
            <UInput
              v-model="searchQuery"
              icon="i-lucide-search"
              placeholder="Search media..."
              size="sm"
              class="w-48"
            />

            <!-- Store filter -->
            <USelectMenu
              v-model="selectedStoreId"
              :items="storeFilterOptions"
              value-key="value"
              size="sm"
              class="w-44"
            >
              <template #leading="{ modelValue }">
                <UIcon
                  :name="storeFilterOptions.find(o => o.value === modelValue)?.icon || 'i-lucide-layers'"
                  class="size-4 text-muted"
                />
              </template>
              <template #default="{ modelValue }">
                {{ storeFilterOptions.find(o => o.value === modelValue)?.label || 'All Stores' }}
              </template>
            </USelectMenu>

            <!-- Tag filter chips -->
            <div v-if="availableTags.length > 0" class="flex gap-1.5 flex-wrap">
              <UButton
                size="xs"
                :color="selectedTag === null ? 'primary' : 'neutral'"
                :variant="selectedTag === null ? 'solid' : 'outline'"
                @click="selectedTag = null"
              >
                All
              </UButton>
              <UButton
                v-for="tag in availableTags"
                :key="tag"
                size="xs"
                :color="selectedTag === tag ? 'primary' : 'neutral'"
                :variant="selectedTag === tag ? 'solid' : 'outline'"
                @click="selectedTag = selectedTag === tag ? null : tag"
              >
                {{ tag }}
              </UButton>
            </div>
          </div>
        </template>

        <template #right>
          <!-- Active filter indicator -->
          <div v-if="activeFilterCount > 0" class="flex items-center gap-2">
            <UBadge color="primary" variant="subtle" size="sm">
              {{ filteredItems.length }} of {{ mediaItems?.length ?? 0 }}
            </UBadge>
            <UButton
              icon="i-lucide-x"
              size="xs"
              color="neutral"
              variant="ghost"
              label="Clear"
              @click="clearFilters"
            />
          </div>
        </template>
      </UDashboardToolbar>
    </template>

    <template #body>
      <!-- Upload progress bar -->
      <div v-if="uploadState.isUploading" class="px-4 py-3 bg-primary-50 dark:bg-primary-950 border-b border-primary-100 dark:border-primary-900">
        <div class="flex items-center gap-3">
          <UIcon name="i-lucide-upload" class="text-primary-600 dark:text-primary-400 animate-pulse" />
          <span class="text-sm text-primary-600 dark:text-primary-400">
            Uploading{{ uploadState.totalFiles > 1 ? ` ${uploadState.currentIndex} of ${uploadState.totalFiles}` : '' }}...
            <span v-if="uploadState.currentFileName" class="text-xs opacity-75"> {{ uploadState.currentFileName }}</span>
          </span>
          <div class="flex-1 bg-primary-200 dark:bg-primary-800 rounded-full h-2">
            <div
              class="bg-primary-600 h-2 rounded-full transition-all duration-300"
              :style="{ width: `${uploadState.progress}%` }"
            />
          </div>
          <span class="text-sm font-medium text-primary-600 dark:text-primary-400">{{ uploadState.progress }}%</span>
        </div>
      </div>

      <div class="p-6">
        <!-- Optimistic previews -->
        <div v-if="optimisticPreviews.length > 0" class="mb-4 flex gap-3 flex-wrap">
          <div
            v-for="(preview, idx) in optimisticPreviews"
            :key="idx"
            class="inline-block relative rounded-lg overflow-hidden border-2 transition-all duration-300"
            :class="preview.done ? 'border-green-500 opacity-100' : 'border-primary-500 animate-pulse'"
          >
            <img
              :src="preview.url"
              :alt="preview.filename"
              class="w-24 h-18 object-cover"
              :class="preview.done ? 'opacity-100' : 'opacity-70'"
            />
            <div v-if="!preview.done" class="absolute inset-0 flex items-center justify-center bg-black/30">
              <UIcon name="i-lucide-loader-2" class="w-5 h-5 text-white animate-spin" />
            </div>
            <div v-else class="absolute inset-0 flex items-center justify-center bg-green-500/20">
              <UIcon name="i-lucide-check" class="w-5 h-5 text-green-400" />
            </div>
            <p class="absolute bottom-0 left-0 right-0 text-[10px] text-white bg-black/60 px-1 py-0.5 truncate">{{ preview.filename }}</p>
          </div>
        </div>

        <!-- Loading state -->
        <div v-if="isLoading" class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
          <div
            v-for="i in 8"
            :key="i"
            class="aspect-video rounded-lg bg-muted animate-pulse"
          />
        </div>

        <!-- Empty state (no media at all) -->
        <div v-else-if="!mediaItems || mediaItems.length === 0" class="flex flex-col items-center justify-center py-16 gap-4">
          <div class="w-16 h-16 rounded-full bg-muted flex items-center justify-center">
            <UIcon name="i-lucide-image" class="w-8 h-8 text-muted" />
          </div>
          <div class="text-center">
            <p class="font-medium">No media yet</p>
            <p class="text-sm text-muted">Upload your first image to get started.</p>
          </div>
          <UButton
            icon="i-lucide-upload"
            label="Upload Image"
            color="neutral"
            variant="outline"
            @click="triggerUpload"
          />
        </div>

        <!-- No results for current filter -->
        <div v-else-if="filteredItems.length === 0" class="flex flex-col items-center justify-center py-16 gap-4">
          <div class="w-16 h-16 rounded-full bg-muted flex items-center justify-center">
            <UIcon name="i-lucide-filter-x" class="w-8 h-8 text-muted" />
          </div>
          <div class="text-center">
            <p class="font-medium">No media matches your filters</p>
            <p class="text-sm text-muted">Try adjusting your search or filter criteria.</p>
          </div>
          <UButton
            label="Clear Filters"
            color="neutral"
            variant="outline"
            @click="clearFilters"
          />
        </div>

        <!-- Media grid -->
        <div
          v-else
          class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4"
        >
          <div
            v-for="item in filteredItems"
            :key="item.id"
            class="group relative rounded-lg overflow-hidden border border-default hover:border-muted transition-all duration-200"
          >
            <!-- Image -->
            <div class="aspect-video w-full overflow-hidden bg-muted">
              <img
                :src="item.url"
                :alt="item.name || item.filename"
                class="w-full h-full object-cover transition-transform duration-300 group-hover:scale-105"
                loading="lazy"
              />
            </div>

            <!-- Hover Actions -->
            <div class="absolute top-2 right-2 flex gap-1 opacity-0 group-hover:opacity-100 transition-opacity">
              <UButton
                v-if="canManageMedia"
                icon="i-lucide-move"
                color="neutral"
                variant="solid"
                size="xs"
                class="bg-black/60 hover:bg-black/80 text-white border-0"
                title="Move to store"
                @click.stop="openReassign(item)"
              />
              <UButton
                v-if="canManageMedia"
                icon="i-lucide-trash-2"
                color="error"
                variant="solid"
                size="xs"
                @click.stop="handleDelete(item)"
              />
            </div>

            <!-- Footer Metadata -->
            <div class="p-3 bg-elevated">
              <p class="text-sm font-medium truncate">
                {{ item.name || item.filename }}
              </p>
              <div class="flex items-center justify-between mt-1">
                <!-- Store badge -->
                <UBadge
                  :color="item.storeId ? 'primary' : 'neutral'"
                  variant="subtle"
                  size="sm"
                >
                  <UIcon :name="item.storeId ? 'i-lucide-store' : 'i-lucide-building-2'" class="size-3 mr-1" />
                  {{ getStoreName(item.storeId) }}
                </UBadge>
                <!-- Date -->
                <div class="flex items-center gap-1 text-xs text-dimmed">
                  <UIcon name="i-lucide-clock" class="w-3 h-3" />
                  <span>{{ formatDate(item.createdAt) }}</span>
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </template>

    <template #footer>
      <div class="flex items-center justify-between px-4 py-3 border-t border-default">
        <div class="flex items-center gap-3 text-sm text-muted">
          <span>{{ filteredItems.length }} {{ filteredItems.length === 1 ? 'item' : 'items' }}</span>
          <template v-if="activeFilterCount > 0">
            <span>·</span>
            <span>{{ mediaItems?.length ?? 0 }} total</span>
          </template>
        </div>
        <div class="text-sm text-dimmed">
          Max 10MB per file · JPEG, PNG, WebP, SVG
        </div>
      </div>
    </template>
  </UDashboardPanel>

  <!-- Store Reassignment Modal -->
  <UModal
    v-model:open="reassignOpen"
  >
    <template #header>
      <div class="px-6 py-4 border-b border-default">
        <h3 class="text-lg font-semibold">Move Media</h3>
        <p v-if="reassignItem" class="text-sm text-muted mt-1">
          Move "{{ reassignItem.filename }}" to a different store
        </p>
      </div>
    </template>

    <template #body>
      <div class="p-6 space-y-4">
        <!-- Preview -->
        <div v-if="reassignItem" class="flex items-center gap-4">
          <img
            :src="reassignItem.url"
            :alt="reassignItem.filename"
            class="w-20 h-14 object-cover rounded-lg border border-default"
          />
          <div>
            <p class="font-medium text-sm">{{ reassignItem.name || reassignItem.filename }}</p>
            <p class="text-xs text-muted">Currently: {{ getStoreName(reassignItem.storeId) }}</p>
          </div>
        </div>

        <!-- Store selector -->
        <UFormField label="Move to">
          <USelectMenu
            v-model="reassignStoreId"
            :items="reassignStoreOptions"
            value-key="value"
            class="w-full"
          >
            <template #leading="{ modelValue }">
              <UIcon
                :name="reassignStoreOptions.find(o => o.value === modelValue)?.icon || 'i-lucide-building-2'"
                class="size-4 text-muted"
              />
            </template>
            <template #default="{ modelValue }">
              {{ reassignStoreOptions.find(o => o.value === modelValue)?.label || 'Company-wide' }}
            </template>
          </USelectMenu>
        </UFormField>
      </div>
    </template>

    <template #footer>
      <div class="flex justify-end gap-2 px-6 py-4 border-t border-default">
        <UButton
          label="Cancel"
          color="neutral"
          variant="outline"
          @click="reassignOpen = false"
        />
        <UButton
          label="Move"
          color="primary"
          icon="i-lucide-move"
          :loading="reassigning"
          @click="confirmReassign"
        />
      </div>
    </template>
  </UModal>
</template>

