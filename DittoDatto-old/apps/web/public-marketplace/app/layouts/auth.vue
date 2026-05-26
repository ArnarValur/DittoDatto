<script setup lang="ts">
/**
 * Auth Layout - Public Marketplace
 *
 * Clean, mode-aware layout for login/signup pages.
 * Follows SolarTheme: light in day, dark at night.
 */
const { t } = useI18n()
const localePath = useLocalePath()
</script>

<template>
  <div class="min-h-screen flex flex-col bg-background relative overflow-hidden">
    <!-- Subtle background accents — only visible in dark mode -->
    <div class="absolute inset-0 pointer-events-none overflow-hidden">
      <div class="absolute -top-24 -right-24 w-96 h-96 dark:bg-primary/8 rounded-full blur-3xl" />
      <div class="absolute -bottom-32 -left-32 w-[500px] h-[500px] dark:bg-primary/5 rounded-full blur-3xl" />
    </div>

    <!-- Header with Logo -->
    <header class="py-6 relative z-10">
      <div class="max-w-md mx-auto px-4 flex items-center justify-center">
        <NuxtLink :to="localePath('/')" class="flex items-center gap-2 group">
          <span class="text-2xl font-bold text-primary transition-transform group-hover:scale-105">
            DittoDatto
          </span>
        </NuxtLink>
      </div>
    </header>

    <!-- Main Content -->
    <main class="flex-1 flex items-center justify-center px-4 py-8 relative z-10">
      <slot />
    </main>

    <!-- Footer -->
    <footer class="py-6 text-center text-sm text-muted relative z-10">
      <p>{{ t('footer.copyright', { year: new Date().getFullYear() }) }}</p>
    </footer>
  </div>
</template>

