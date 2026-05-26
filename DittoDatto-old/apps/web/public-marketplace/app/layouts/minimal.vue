<script setup lang="ts">
/**
 * Minimal Layout - Public Marketplace
 * 
 * Used for:
 * - Login/Signup pages
 * - Maintenance page
 * - Simple standalone pages
 * 
 * No header or bottom nav - just centered content
 */
const localePath = useLocalePath()
</script>

<template>
  <div class="min-h-screen bg-default flex flex-col">
    <!-- Simple Header with Logo Only -->
    <header class="py-6">
      <UContainer>
        <NuxtLink :to="localePath('/')" class="flex items-center justify-center gap-2">
          <span class="text-2xl font-bold text-primary">DittoDatto</span>
        </NuxtLink>
      </UContainer>
    </header>

    <!-- Centered Content -->
    <main class="flex-1 flex items-center justify-center px-4">
      <slot />
    </main>

    <!-- Minimal Footer -->
    <footer class="py-4 text-center text-sm text-muted">
      © {{ new Date().getFullYear() }} DittoDatto
    </footer>
  </div>
</template>
