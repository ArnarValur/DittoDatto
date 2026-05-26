<script setup lang="ts">
/**
 * Visual Preview Layout
 * A minimal layout for previewing the establishment page.
 * Uses DDDattoBar for navigation and features.
 */
</script>

<template>
  <div class="min-h-screen flex flex-col font-sans antialiased">
    <!-- DattoBar Navigation -->
    <DDDattoBar
      back-label="Back"
      back-to="/stores"
    />

    <!-- Page Content -->
    <main class="flex-1">
      <slot />
    </main>
  </div>
</template>
