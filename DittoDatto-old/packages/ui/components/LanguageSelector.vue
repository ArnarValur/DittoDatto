<script setup lang="ts">
/**
 * Language Selector — flag-only trigger with dropdown
 *
 * Shows just the flag emoji in the navbar button.
 * Dropdown shows flag + language name for each locale.
 */
const { locale, locales, setLocale } = useI18n()

interface LocaleObject {
  code: string
  name?: string
  [key: string]: unknown
}

const FLAG_MAP: Record<string, string> = {
  nb: '🇳🇴',
  nn: '🇳🇴',
  en: '🇬🇧',
  pl: '🇵🇱'
}

function getFlag(code: string): string {
  return FLAG_MAP[code] || '🌐'
}

// Build dropdown items from locales
const localeItems = computed(() => {
  const sorted = (locales.value as LocaleObject[])
    .slice()
    .sort((a, b) => (a.name || a.code).localeCompare(b.name || b.code))

  return [sorted.map(loc => ({
    label: `${getFlag(loc.code)}  ${loc.name || loc.code}`,
    disabled: loc.code === locale.value,
    onSelect: () => setLocale(loc.code)
  }))]
})
</script>

<template>
  <UDropdownMenu :items="localeItems">
    <UButton
      variant="ghost"
      color="neutral"
      size="sm"
      class="text-lg"
    >
      {{ getFlag(locale) }}
    </UButton>
  </UDropdownMenu>
</template>

