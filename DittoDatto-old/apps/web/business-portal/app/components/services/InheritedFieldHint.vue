<script setup lang="ts">
/**
 * InheritedFieldHint
 *
 * Shows a subtle hint below a form field indicating where the value is inherited from.
 * Also shows the inherited value as a placeholder suggestion.
 */

const props = defineProps<{
  source: 'store' | 'group' | 'service' | 'default'
  sourceName?: string
  inheritedValue?: string | number
}>()

const sourceLabel = computed(() => {
  switch (props.source) {
    case 'group':
      return `Inherited from: ${props.sourceName || 'Group'}`
    case 'store':
      return `Inherited from: ${props.sourceName || 'Store defaults'}`
    case 'default':
      return 'Using system default'
    case 'service':
    default:
      return null // No hint needed
  }
})

const sourceIcon = computed(() => {
  switch (props.source) {
    case 'group':
      return 'i-lucide-folder'
    case 'store':
      return 'i-lucide-store'
    case 'default':
      return 'i-lucide-settings-2'
    case 'service':
    default:
      return null
  }
})
</script>

<template>
  <div
    v-if="sourceLabel"
    class="flex items-center gap-1.5 mt-1 text-xs text-muted"
  >
    <UIcon v-if="sourceIcon" :name="sourceIcon" class="size-3" />
    <span>{{ sourceLabel }}</span>
    <span v-if="inheritedValue !== undefined" class="text-primary font-medium">
      ({{ inheritedValue }})
    </span>
  </div>
</template>
