<script setup lang="ts">
import type { MediaItem } from '@dittodatto/shared-types'
import { collection, query, where, orderBy } from 'firebase/firestore'
import { useFirestore, useCollection } from 'vuefire'

interface Props {
  open: boolean
  companyId: string
  storeId?: string
  filterTags?: string[]
  allowUpload?: boolean
  multiple?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  allowUpload: true
})

const emit = defineEmits<{
  'update:open': [value: boolean]
  select: [item: MediaItem]
  'select-multiple': [items: MediaItem[]]
}>()

const db = useFirestore()
const toast = useToast()
const { state: uploadState, uploadFile, validateFile } = useMediaUpload()

const selectedId = ref<string | null>(null)
const selectedIds = ref<string[]>([])
const activeTag = ref<string | null>(null)
const searchQuery = ref('')
const fileInput = ref<HTMLInputElement | null>(null)

// Optimistic preview for in-progress uploads
const optimisticPreview = ref<{ url: string; filename: string } | null>(null)

// Fetch company's media
const mediaQuery = computed(() => {
  if (!props.companyId) return null
  return query(
    collection(db, 'media'),
    where('companyId', '==', props.companyId),
    orderBy('createdAt', 'desc')
  )
})

const allMediaItems = useCollection<MediaItem>(mediaQuery)
const isLoading = computed(() => allMediaItems.pending.value)

// Extract unique tags from media items
const availableTags = computed(() => {
  const tagSet = new Set<string>()
  allMediaItems.value.forEach(item => {
    (item.tags || []).forEach(tag => tagSet.add(tag))
  })
  return Array.from(tagSet).sort()
})

// Filter items by active tag and search
const filteredItems = computed(() => {
  let items = allMediaItems.value || []
  
  if (activeTag.value) {
    items = items.filter(item => (item.tags || []).includes(activeTag.value!))
  }
  
  if (searchQuery.value) {
    const q = searchQuery.value.toLowerCase()
    items = items.filter(item => 
      (item.name || '').toLowerCase().includes(q) ||
      item.filename.toLowerCase().includes(q)
    )
  }
  
  return items
})

function handleSelect(item: MediaItem) {
  if (props.multiple) {
    const idx = selectedIds.value.indexOf(item.id)
    if (idx === -1) {
      selectedIds.value.push(item.id)
    } else {
      selectedIds.value.splice(idx, 1)
    }
  } else {
    selectedId.value = item.id
  }
}

function confirmSelection() {
  if (props.multiple) {
    const selected = allMediaItems.value.filter(item => selectedIds.value.includes(item.id))
    if (selected.length > 0) {
      emit('select-multiple', selected)
      emit('update:open', false)
      selectedIds.value = []
    }
  } else {
    const selected = allMediaItems.value.find(item => item.id === selectedId.value)
    if (selected) {
      emit('select', selected)
      emit('update:open', false)
      selectedId.value = null
    }
  }
}

function close() {
  emit('update:open', false)
  selectedId.value = null
  selectedIds.value = []
  activeTag.value = null
  searchQuery.value = ''
}

function clearTagFilter() {
  activeTag.value = null
}

function triggerUpload() {
  fileInput.value?.click()
}

async function handleFileSelect(event: Event) {
  const target = event.target as HTMLInputElement
  const file = target.files?.[0]
  if (!file || !props.companyId) return

  const validation = validateFile(file)
  if (!validation.valid) {
    toast.add({ title: 'Invalid File', description: validation.error, color: 'error' })
    target.value = ''
    return
  }

  // Show optimistic preview immediately
  optimisticPreview.value = {
    url: URL.createObjectURL(file),
    filename: file.name
  }

  // Use first filter tag or 'general' as the type
  const mediaType = (props.filterTags?.[0] || 'general') as 'logo' | 'cover' | 'store_gallery' | 'staff_portrait' | 'general'

  const result = await uploadFile(file, {
    companyId: props.companyId,
    storeId: props.storeId || undefined,
    type: mediaType
  })

  // Clean up optimistic preview
  if (optimisticPreview.value) {
    URL.revokeObjectURL(optimisticPreview.value.url)
    optimisticPreview.value = null
  }

  if (result) {
    toast.add({ title: 'Uploaded!', description: `${file.name} added to library.`, color: 'success' })
    // Auto-select the newly uploaded image
    selectedId.value = result.id
  } else if (uploadState.error) {
    toast.add({ title: 'Upload Failed', description: uploadState.error, color: 'error' })
  }

  target.value = ''
}
</script>

<template>
  <UModal
    :open="open"
    @update:open="close"
    class="max-w-4xl"
  >
    <!-- Header -->
    <template #header>
      <div class="flex items-center justify-between w-full px-6 py-4 border-b border-gray-200 dark:border-gray-800">
        <div>
          <h2 class="text-xl font-semibold text-gray-900 dark:text-white">Media</h2>
          <p class="text-sm text-gray-500 dark:text-gray-400">
            {{ filteredItems.length }} item{{ filteredItems.length === 1 ? '' : 's' }}
            <template v-if="activeTag">
              &middot; Filtered by "{{ activeTag }}"
            </template>
          </p>
        </div>
        <div class="flex items-center gap-2">
          <UInput
            v-model="searchQuery"
            placeholder="Search..."
            icon="i-lucide-search"
            size="sm"
            class="w-48"
          />
          <UButton
            v-if="allowUpload"
            icon="i-lucide-upload"
            color="neutral"
            variant="ghost"
            :loading="uploadState.isUploading"
            @click="triggerUpload"
          />
          <!-- Hidden file input -->
          <input
            ref="fileInput"
            type="file"
            accept="image/jpeg,image/png,image/webp,image/svg+xml"
            class="hidden"
            @change="handleFileSelect"
          >
          <UButton
            icon="i-lucide-x"
            color="neutral"
            variant="ghost"
            @click="close"
          />
        </div>
      </div>
    </template>

    <!-- Body -->
    <template #body>
      <div class="p-6 min-h-[400px] max-h-[60vh] overflow-y-auto">
        <!-- Tag Filter Chips -->
        <div v-if="availableTags.length > 0" class="flex flex-wrap gap-2 mb-6">
          <UButton
            size="xs"
            :color="activeTag === null ? 'primary' : 'neutral'"
            :variant="activeTag === null ? 'solid' : 'outline'"
            @click="clearTagFilter"
          >
            All
          </UButton>
          <UButton
            v-for="tag in availableTags"
            :key="tag"
            size="xs"
            :color="activeTag === tag ? 'primary' : 'neutral'"
            :variant="activeTag === tag ? 'solid' : 'outline'"
            @click="activeTag = tag"
          >
            {{ tag }}
          </UButton>
        </div>

        <!-- Optimistic upload preview -->
        <div v-if="optimisticPreview" class="mb-4">
          <div class="inline-block relative rounded-lg overflow-hidden border-2 border-primary-500 animate-pulse">
            <img
              :src="optimisticPreview.url"
              :alt="optimisticPreview.filename"
              class="w-32 h-24 object-cover opacity-70"
            />
            <div class="absolute inset-0 flex items-center justify-center bg-black/30">
              <UIcon name="i-lucide-loader-2" class="w-6 h-6 text-white animate-spin" />
            </div>
          </div>
          <p class="text-xs text-muted mt-1">Uploading {{ optimisticPreview.filename }}...</p>
        </div>

        <!-- Media Grid -->
        <DDMediaGrid
          :items="filteredItems"
          :loading="isLoading"
          :selectable="true"
          :selected-id="multiple ? undefined : (selectedId || undefined)"
          :selected-ids="multiple ? selectedIds : undefined"
          :columns="3"
          @select="handleSelect"
        />
      </div>
    </template>

    <!-- Footer -->
    <template #footer>
      <div class="flex items-center justify-between w-full px-6 py-4 border-t border-gray-200 dark:border-gray-800">
        <p class="text-sm text-gray-500">
          <template v-if="multiple && selectedIds.length > 0">
            {{ selectedIds.length }} image{{ selectedIds.length === 1 ? '' : 's' }} selected
          </template>
          <template v-else-if="selectedId">
            1 image selected
          </template>
          <template v-else>
            Click an image to select
          </template>
        </p>
        <div class="flex gap-2">
          <UButton
            label="Cancel"
            color="neutral"
            variant="outline"
            @click="close"
          />
          <UButton
            label="Use Selected"
            color="primary"
            :disabled="multiple ? selectedIds.length === 0 : !selectedId"
            @click="confirmSelection"
          />
        </div>
      </div>
    </template>
  </UModal>
</template>
