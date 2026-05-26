<script setup>

const { settings } = useSiteSettings()
const route = useRoute()

useHead({
  meta: [
    { name: 'viewport', content: 'width=device-width, initial-scale=1' }
  ],
  link: [
    { rel: 'icon', href: '/favicon.ico' }
  ],
  htmlAttrs: {
    lang: 'no'
  }
})

const title = 'Dittodatto'
const description = 'En samfunnsmessig platform for å finne serviser og reservasjoner fra Dittodatto'

useSeoMeta({
  title,
  description,
  ogTitle: title,
  ogDescription: description,
  ogImage: '/og-image.png',
  twitterImage: '/og-image.png',
  twitterCard: 'summary_large_image'
})

// Watch for maintenance mode changes
watch(() => settings.value?.maintenanceMode?.enabled, (enabled) => {
  if (enabled && route.path !== '/maintenance') {
    navigateTo('/maintenance')
  } else if (!enabled && route.path === '/maintenance') {
    navigateTo('/')
  }
})
</script>

<template>
  <UApp>
    <NuxtLayout>
      <NuxtPage />
    </NuxtLayout>
  </UApp>
</template>