<script setup lang="ts">
/**
 * About Section
 * 2-column layout:
 *   Left:  Description (top) + Contact card (bottom)
 *   Right: Map (full height)
 */

const { t } = useI18n()

interface Props {
  description: string
  address: string
  city: string
  lat?: number
  lng?: number
  phone?: string
  email?: string
  website?: string
  socialLinks?: {
    fb?: string
    ig?: string
    x?: string
  }
}

const props = defineProps<Props>()

// Normalize website URL — ensure it has a protocol so the browser
// doesn't treat it as an internal/relative link
const normalizedWebsite = computed(() => {
  if (!props.website) return ''
  const url = props.website.trim()
  if (url.startsWith('http://') || url.startsWith('https://')) return url
  return `https://${url}`
})

// Google Maps directions URL
const getDirectionsUrl = (lat?: number, lng?: number, address?: string, city?: string) => {
  if (lat && lng) {
    return `https://www.google.com/maps/dir/?api=1&destination=${lat},${lng}`
  }
  return `https://www.google.com/maps/dir/?api=1&destination=${encodeURIComponent(`${address}, ${city}, Norway`)}`
}
</script>

<template>
  <div class="grid grid-cols-1 md:grid-cols-2 gap-6 items-stretch">
    <!-- Left Column: Description + Contact stacked -->
    <div class="flex flex-col gap-6">
      <!-- A: Description -->
      <div class="prose dark:prose-invert max-w-none text-gray-600 dark:text-gray-300 leading-relaxed">
        <p style="white-space: pre-line;">{{ description }}</p>
      </div>

      <!-- C: Contact Info Card -->
      <div class="bg-elevated rounded-xl border border-default p-5 space-y-3">
        <h3 class="text-sm font-semibold text-muted uppercase tracking-wider mb-3">
          {{ t('establishment.contactInfo', 'Contact Information') }}
        </h3>

        <!-- Address -->
        <div class="flex items-start gap-3">
          <UIcon name="i-lucide-map-pin" class="size-4 text-primary mt-0.5 shrink-0" />
          <div>
            <p class="text-sm text-default">{{ address }}</p>
            <p class="text-xs text-muted">{{ city }}</p>
          </div>
        </div>

        <!-- Phone -->
        <a v-if="phone" :href="`tel:${phone}`" class="flex items-center gap-3 text-sm text-default hover:text-primary transition-colors group">
          <UIcon name="i-lucide-phone" class="size-4 text-primary shrink-0" />
          <span class="group-hover:underline">{{ phone }}</span>
        </a>

        <!-- Email -->
        <a v-if="email" :href="`mailto:${email}`" class="flex items-center gap-3 text-sm text-default hover:text-primary transition-colors group">
          <UIcon name="i-lucide-mail" class="size-4 text-primary shrink-0" />
          <span class="group-hover:underline">{{ email }}</span>
        </a>

        <!-- Website -->
        <a v-if="website" :href="normalizedWebsite" target="_blank" rel="noopener" class="flex items-center gap-3 text-sm text-default hover:text-primary transition-colors group">
          <UIcon name="i-lucide-globe" class="size-4 text-primary shrink-0" />
          <span class="group-hover:underline">{{ website.replace(/^https?:\/\//, '') }}</span>
          <UIcon name="i-lucide-external-link" class="size-3 text-muted shrink-0" />
        </a>

        <!-- Social Links -->
        <div v-if="socialLinks?.fb || socialLinks?.ig || socialLinks?.x" class="flex items-center gap-2 pt-2 border-t border-default">
          <span class="text-xs text-muted mr-1">{{ t('establishment.followUs', 'Follow us') }}</span>
          <a v-if="socialLinks.fb" :href="socialLinks.fb" target="_blank" rel="noopener" class="p-1.5 rounded-lg hover:bg-muted/50 transition-colors">
            <UIcon name="i-simple-icons-facebook" class="size-4 text-muted hover:text-[#1877F2]" />
          </a>
          <a v-if="socialLinks.ig" :href="socialLinks.ig" target="_blank" rel="noopener" class="p-1.5 rounded-lg hover:bg-muted/50 transition-colors">
            <UIcon name="i-simple-icons-instagram" class="size-4 text-muted hover:text-[#E4405F]" />
          </a>
          <a v-if="socialLinks.x" :href="socialLinks.x" target="_blank" rel="noopener" class="p-1.5 rounded-lg hover:bg-muted/50 transition-colors">
            <UIcon name="i-simple-icons-x" class="size-4 text-muted hover:text-default" />
          </a>
        </div>

        <!-- Empty contact state -->
        <p v-if="!phone && !email && !website" class="text-xs text-dimmed italic">
          {{ t('establishment.noContactInfo', 'Contact details not yet available.') }}
        </p>
      </div>
    </div>

    <!-- Right Column: Map (full height) -->
    <div class="w-full min-h-[350px] md:min-h-0 relative rounded-xl overflow-hidden">
      <!-- Interactive Map -->
      <ClientOnly v-if="lat && lng">
        <DDMapStoreMap
          :lat="lat"
          :lng="lng"
          :popup-name="address"
          :show-directions-button="false"
          height="100%"
          class="h-full"
        />
        <template #fallback>
          <div class="w-full h-full bg-gray-100 dark:bg-gray-800 rounded-xl flex flex-col items-center justify-center">
            <UIcon name="i-lucide-map" class="size-10 text-gray-400 animate-pulse mb-2" />
            <span class="text-sm text-gray-500">{{ t('common.loading', 'Loading map...') }}</span>
          </div>
        </template>
      </ClientOnly>

      <!-- Placeholder -->
      <div
        v-else
        class="w-full h-full flex flex-col items-center justify-center bg-gray-200 dark:bg-gray-700 text-gray-500 rounded-xl"
      >
        <UIcon name="i-lucide-map" class="size-12 mb-2" />
        <span class="text-sm font-medium">{{ t('establishment.locationNotSet', 'Location not set') }}</span>
      </div>

      <!-- Address Overlay -->
      <div class="absolute bottom-4 left-4 right-4 bg-white/90 dark:bg-black/80 backdrop-blur-sm p-4 rounded-lg flex items-center justify-between shadow-lg z-10">
        <div class="flex-1 min-w-0 mr-4">
          <p class="font-medium text-gray-900 dark:text-white truncate">{{ address }}</p>
          <p class="text-sm text-gray-500 dark:text-gray-400">{{ city }}</p>
        </div>
        <UButton
          :href="getDirectionsUrl(lat, lng, address, city)"
          target="_blank"
          size="sm"
          variant="ghost"
          color="primary"
          icon="i-lucide-navigation"
        >
          {{ t('establishment.directions', 'Directions') }}
        </UButton>
      </div>
    </div>
  </div>
</template>
