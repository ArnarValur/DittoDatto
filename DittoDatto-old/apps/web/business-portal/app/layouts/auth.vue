<script setup lang="ts">
/**
 * Auth Layout - Business Portal
 *
 * Clean, mode-aware layout for the login page.
 * Theme toggle allows user to switch between light/dark.
 */
const colorMode = useColorMode()

const isDark = computed({
  get: () => colorMode.value === 'dark',
  set: () => { colorMode.preference = colorMode.value === 'dark' ? 'light' : 'dark' }
})
</script>

<template>
  <div class="min-h-screen flex flex-col bg-background relative overflow-hidden">
    <!-- Subtle background accents — only visible in dark mode -->
    <div class="absolute inset-0 pointer-events-none overflow-hidden">
      <div class="absolute -top-24 -right-24 w-96 h-96 dark:bg-primary/8 rounded-full blur-3xl" />
      <div class="absolute -bottom-32 -left-32 w-[500px] h-[500px] dark:bg-primary/5 rounded-full blur-3xl" />
    </div>

    <!-- Theme toggle — top right -->
    <div class="absolute top-4 right-4 z-20">
      <UButton
        :icon="isDark ? 'i-lucide-sun' : 'i-lucide-moon'"
        color="neutral"
        variant="ghost"
        size="md"
        :aria-label="isDark ? 'Switch to light mode' : 'Switch to dark mode'"
        @click="isDark = !isDark"
      />
    </div>

    <!-- Header with Logo -->
    <header class="py-8 relative z-10">
      <div class="max-w-md mx-auto px-4">
        <div class="flex items-center justify-center gap-3 group">
          <div class="size-10 rounded-xl bg-primary/15 flex items-center justify-center transition-transform group-hover:scale-105">
            <UIcon name="i-lucide-building-2" class="size-5 text-primary" />
          </div>
          <span class="text-xl font-bold tracking-tight text-highlighted transition-transform group-hover:scale-105">
            DittoDatto
          </span>
        </div>
      </div>
    </header>

    <!-- Main Content -->
    <main class="flex-1 flex items-center justify-center px-4 pb-12 relative z-10">
      <slot />
    </main>

    <!-- Footer -->
    <footer class="py-6 text-center text-xs text-muted relative z-10">
      <p>© {{ new Date().getFullYear() }} DittoDatto. All rights reserved.</p>
    </footer>
  </div>
</template>

