<script setup lang="ts">
/**
 * Legacy /s/[slug] redirect
 * Redirects to the new /{category}/{slug} URL pattern
 */
const route = useRoute()
const slug = computed(() => route.params.slug as string)

// Redirect to discover/{slug} as fallback (category is cosmetic, page resolves by slug)
// The [category]/[slug].vue page handles resolution
navigateTo(`/discover/${slug.value}`, { replace: true, redirectCode: 301 })
</script>

<template>
  <div class="flex items-center justify-center min-h-screen">
    <UIcon name="i-lucide-loader-2" class="animate-spin size-8 text-primary" />
  </div>
</template>
