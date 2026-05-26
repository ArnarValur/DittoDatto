<script setup lang="ts">
import type { MediaItem } from '@dittodatto/shared-types'

interface Props {
  items: MediaItem[]
  loading?: boolean
  selectable?: boolean
  selectedId?: string
  selectedIds?: string[]
  columns?: number
}

const props = withDefaults(defineProps<Props>(), {
  loading: false,
  selectable: false,
  columns: 3
})

const emit = defineEmits<{
  select: [item: MediaItem]
  delete: [item: MediaItem]
}>()

// ── Lightbox state ──────────────────────────────────
const lightboxOpen = ref(false)
const lightboxItem = ref<MediaItem | null>(null)
const lightboxIndex = ref(0)

function openLightbox(item: MediaItem, index: number) {
  lightboxItem.value = item
  lightboxIndex.value = index
  lightboxOpen.value = true
}

function closeLightbox() {
  lightboxOpen.value = false
  lightboxItem.value = null
}

function lightboxPrev() {
  if (lightboxIndex.value > 0) {
    lightboxIndex.value--
    lightboxItem.value = props.items[lightboxIndex.value]
  }
}

function lightboxNext() {
  if (lightboxIndex.value < props.items.length - 1) {
    lightboxIndex.value++
    lightboxItem.value = props.items[lightboxIndex.value]
  }
}

// Keyboard navigation
function handleKeydown(e: KeyboardEvent) {
  if (!lightboxOpen.value) return
  if (e.key === 'ArrowLeft') lightboxPrev()
  else if (e.key === 'ArrowRight') lightboxNext()
  else if (e.key === 'Escape') closeLightbox()
}

onMounted(() => window.addEventListener('keydown', handleKeydown))
onUnmounted(() => window.removeEventListener('keydown', handleKeydown))

// ── Helpers ─────────────────────────────────────────
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

function formatFileSize(bytes: number): string {
  if (bytes < 1024) return `${bytes} B`
  if (bytes < 1024 * 1024) return `${(bytes / 1024).toFixed(1)} KB`
  return `${(bytes / (1024 * 1024)).toFixed(1)} MB`
}

function handleClick(item: MediaItem, index: number) {
  if (props.selectable) {
    emit('select', item)
  } else {
    openLightbox(item, index)
  }
}

function handleDelete(event: Event, item: MediaItem) {
  event.stopPropagation()
  emit('delete', item)
}
</script>

<template>
  <!-- Loading State -->
  <div v-if="loading" class="grid grid-cols-2 sm:grid-cols-3 gap-4">
    <div
      v-for="i in 6"
      :key="i"
      class="aspect-video rounded-lg bg-muted animate-pulse"
    />
  </div>

  <!-- Empty State -->
  <div v-else-if="!items || items.length === 0" class="flex flex-col items-center justify-center py-12 text-center">
    <div class="w-16 h-16 rounded-full bg-muted flex items-center justify-center mb-4">
      <UIcon name="i-lucide-image" class="w-8 h-8 text-muted" />
    </div>
    <p class="text-muted">No media found</p>
  </div>

  <!-- Grid -->
  <div
    v-else
    class="grid gap-4"
    :class="{
      'grid-cols-1 sm:grid-cols-2 md:grid-cols-3': columns === 3,
      'grid-cols-2 sm:grid-cols-3 md:grid-cols-4': columns === 4,
      'grid-cols-2 sm:grid-cols-2': columns === 2
    }"
  >
    <div
      v-for="(item, index) in items"
      :key="item.id"
      class="group relative rounded-lg overflow-hidden border transition-all duration-200 cursor-pointer"
      :class="[
        selectable ? 'hover:scale-[1.02]' : '',
        (selectedId === item.id || selectedIds?.includes(item.id))
          ? 'ring-2 ring-primary-500 border-primary-500 dark:border-primary-400'
          : 'border-default hover:border-muted'
      ]"
      @click="handleClick(item, index)"
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

      <!-- Preview icon overlay on hover (non-selectable mode) -->
      <div
        v-if="!selectable"
        class="absolute inset-0 bg-black/0 group-hover:bg-black/20 transition-colors duration-200 flex items-center justify-center pointer-events-none"
      >
        <div class="opacity-0 group-hover:opacity-100 transition-opacity duration-200">
          <div class="w-10 h-10 rounded-full bg-black/50 backdrop-blur-sm flex items-center justify-center">
            <UIcon name="i-lucide-expand" class="w-5 h-5 text-white" />
          </div>
        </div>
      </div>

      <!-- Footer Metadata -->
      <div class="p-3 bg-elevated">
        <p class="text-sm font-medium truncate">
          {{ item.name || item.filename }}
        </p>
        <div class="flex items-center justify-between mt-1">
          <!-- Tags -->
          <div class="flex gap-1 flex-wrap">
            <UBadge
              v-for="tag in (item.tags || []).slice(0, 2)"
              :key="tag"
              color="neutral"
              variant="subtle"
              size="sm"
            >
              {{ tag }}
            </UBadge>
          </div>
          <!-- Date -->
          <div class="flex items-center gap-1 text-xs text-dimmed">
            <UIcon name="i-lucide-clock" class="w-3 h-3" />
            <span>{{ formatDate(item.createdAt) }}</span>
          </div>
        </div>
      </div>

      <!-- Selection Overlay -->
      <div
        v-if="selectedId === item.id || selectedIds?.includes(item.id)"
        class="absolute top-2 right-2"
      >
        <div class="w-6 h-6 rounded-full bg-primary-500 flex items-center justify-center">
          <UIcon name="i-lucide-check" class="w-4 h-4 text-white" />
        </div>
      </div>

      <!-- Hover Delete Action -->
      <div
        v-if="!selectable"
        class="absolute top-2 right-2 opacity-0 group-hover:opacity-100 transition-opacity"
      >
        <UButton
          icon="i-lucide-trash-2"
          color="error"
          variant="solid"
          size="xs"
          @click="(e: Event) => handleDelete(e, item)"
        />
      </div>
    </div>
  </div>

  <!-- Lightbox Modal -->
  <Teleport to="body">
    <Transition name="lightbox">
      <div
        v-if="lightboxOpen && lightboxItem"
        class="fixed inset-0 z-50 flex items-center justify-center"
        @click.self="closeLightbox"
      >
        <!-- Backdrop -->
        <div class="absolute inset-0 bg-black/80 backdrop-blur-sm" @click="closeLightbox" />

        <!-- Content -->
        <div class="relative z-10 max-w-[90vw] max-h-[90vh] flex flex-col items-center gap-4">
          <!-- Close button -->
          <div class="absolute -top-2 -right-2 z-20">
            <UButton
              icon="i-lucide-x"
              color="neutral"
              variant="solid"
              size="sm"
              class="bg-black/60 hover:bg-black/80 text-white border-0"
              @click="closeLightbox"
            />
          </div>

          <!-- Navigation: Previous -->
          <button
            v-if="lightboxIndex > 0"
            class="absolute left-0 top-1/2 -translate-y-1/2 -translate-x-14 w-10 h-10 rounded-full bg-black/60 hover:bg-black/80 text-white flex items-center justify-center transition-colors"
            @click.stop="lightboxPrev"
          >
            <UIcon name="i-lucide-chevron-left" class="w-6 h-6" />
          </button>

          <!-- Image -->
          <img
            :src="lightboxItem.url"
            :alt="lightboxItem.name || lightboxItem.filename"
            class="max-w-full max-h-[75vh] object-contain rounded-lg shadow-2xl"
          />

          <!-- Navigation: Next -->
          <button
            v-if="lightboxIndex < items.length - 1"
            class="absolute right-0 top-1/2 -translate-y-1/2 translate-x-14 w-10 h-10 rounded-full bg-black/60 hover:bg-black/80 text-white flex items-center justify-center transition-colors"
            @click.stop="lightboxNext"
          >
            <UIcon name="i-lucide-chevron-right" class="w-6 h-6" />
          </button>

          <!-- Info bar -->
          <div class="flex items-center gap-4 px-4 py-2 rounded-lg bg-black/60 backdrop-blur-sm text-white text-sm">
            <span class="font-medium">{{ lightboxItem.name || lightboxItem.filename }}</span>
            <span class="text-white/60">·</span>
            <span class="text-white/80">{{ formatFileSize(lightboxItem.size) }}</span>
            <span v-if="lightboxItem.width && lightboxItem.height" class="text-white/60">·</span>
            <span v-if="lightboxItem.width && lightboxItem.height" class="text-white/80">{{ lightboxItem.width }}×{{ lightboxItem.height }}</span>
            <span class="text-white/60">·</span>
            <span class="text-white/80">{{ lightboxIndex + 1 }} / {{ items.length }}</span>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<style scoped>
.lightbox-enter-active,
.lightbox-leave-active {
  transition: opacity 0.2s ease;
}
.lightbox-enter-from,
.lightbox-leave-to {
  opacity: 0;
}
</style>
