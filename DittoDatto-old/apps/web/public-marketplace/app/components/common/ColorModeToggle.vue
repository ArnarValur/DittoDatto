<script setup lang="ts">
const colorMode = useColorMode()
const { themePreference, setThemePreference } = useSolarTheme()

const toggleMode = () => {
  // Cycle: day → night → solar → day
  if (themePreference.value === 'light') {
    setThemePreference('dark')
  } else if (themePreference.value === 'dark') {
    setThemePreference('solar')
  } else {
    setThemePreference('light')
  }
}

const icon = computed(() => {
  if (themePreference.value === 'solar') return 'i-lucide-sunrise'
  return colorMode.value === 'dark' ? 'i-lucide-sun' : 'i-lucide-moon'
})

const label = computed(() => {
  if (themePreference.value === 'solar') return 'Solar'
  return colorMode.value === 'dark' ? 'Night' : 'Day'
})
</script>

<template>
  <UButton variant="ghost" color="neutral" :icon="icon" :aria-label="label" @click="toggleMode" />
</template>
