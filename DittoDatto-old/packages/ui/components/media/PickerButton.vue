<script setup lang="ts">
import type { MediaItem } from '@dittodatto/shared-types'

interface Props {
  modelValue?: string
  label?: string
  placeholder?: string
  filterTags?: string[]
  showPreview?: boolean
  previewSize?: 'sm' | 'md'
  companyId: string
  storeId?: string
  multiple?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  label: 'Choose Image',
  placeholder: 'No image selected',
  showPreview: true,
  previewSize: 'md',
  multiple: false
})

const emit = defineEmits<{
  'update:modelValue': [url: string]
  'update:modelValues': [urls: string[]]
  select: [item: MediaItem]
  'select-multiple': [items: MediaItem[]]
}>()

const isOpen = ref(false)

function handleSelect(item: MediaItem) {
  emit('update:modelValue', item.url)
  emit('select', item)
}

function handleSelectMultiple(items: MediaItem[]) {
  const urls = items.map(i => i.url)
  emit('update:modelValues', urls)
  emit('select-multiple', items)
}

function clearSelection() {
  emit('update:modelValue', '')
}

const previewSizeClass = computed(() => {
  return props.previewSize === 'sm' ? 'w-12 h-12' : 'w-16 h-16'
})
</script>

<template>
  <div class="flex items-center gap-3">
    <!-- Preview Thumbnail (only for single selection) -->
    <div
      v-if="showPreview && !multiple"
      class="rounded-lg overflow-hidden border border-gray-200 dark:border-gray-700 bg-gray-100 dark:bg-gray-800 flex-shrink-0"
      :class="previewSizeClass"
    >
      <img
        v-if="modelValue"
        :src="modelValue"
        alt="Selected"
        class="w-full h-full object-cover"
      />
      <div
        v-else
        class="w-full h-full flex items-center justify-center"
      >
        <UIcon name="i-lucide-image" class="w-6 h-6 text-gray-400" />
      </div>
    </div>

    <!-- Button Group -->
    <div class="flex flex-col gap-1">
      <div class="flex gap-2">
        <UButton
          :label="label"
          icon="i-lucide-folder-open"
          color="neutral"
          variant="outline"
          size="sm"
          @click="isOpen = true"
        />
        <UButton
          v-if="modelValue && !multiple"
          icon="i-lucide-x"
          color="neutral"
          variant="ghost"
          size="sm"
          @click="clearSelection"
        />
      </div>
      <p v-if="!modelValue && placeholder && !multiple" class="text-xs text-gray-500">
        {{ placeholder }}
      </p>
      <p v-else-if="modelValue && !multiple" class="text-xs text-gray-500 truncate max-w-xs">
        {{ modelValue.split('/').pop() }}
      </p>
    </div>

    <!-- Modal -->
    <DDMediaLibraryModal
      v-model:open="isOpen"
      :company-id="companyId"
      :store-id="storeId"
      :filter-tags="filterTags"
      :multiple="multiple"
      @select="handleSelect"
      @select-multiple="handleSelectMultiple"
    />
  </div>
</template>
