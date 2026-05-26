<script setup lang="ts">
/**
 * DDDattoBar Component
 * Datto's AI-powered navigation bar for business portal pages.
 * Provides back navigation, AI search placeholder, language selector,
 * theme toggle, and user avatar.
 * 
 * Reusable across the business portal wherever owners need to interact with Datto AI.
 */
import { useCurrentUser } from 'vuefire'

interface Props {
  /** Custom back button label */
  backLabel?: string
  /** Fallback route if no history */
  backTo?: string
  /** Show AI search bar (default: true) */
  showSearch?: boolean
  /** Show language selector (default: true) */
  showLanguageSelector?: boolean
  /** Show theme toggle (default: true) */
  showThemeToggle?: boolean
  /** Show user avatar (default: true) */
  showUserAvatar?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  backLabel: 'Back',
  backTo: '/',
  showSearch: true,
  showLanguageSelector: true,
  showThemeToggle: true,
  showUserAvatar: true
})

const router = useRouter()

// User data from Firebase Auth
const currentUser = useCurrentUser()

const userAvatar = computed(() => ({
  src: currentUser.value?.photoURL || '',
  alt: currentUser.value?.displayName || 'User'
}))

// Navigate back or to fallback
function handleBack() {
  if (import.meta.client && window.history.length > 1) {
    router.back()
  } else {
    router.push(props.backTo)
  }
}
</script>

<template>
  <header
    class="h-16 border-b border-default bg-elevated/90 backdrop-blur-md sticky top-0 z-40 flex items-center px-4 md:px-8 gap-4"
  >
    <!-- Back Button -->
    <UButton
      icon="i-lucide-arrow-left"
      variant="ghost"
      color="neutral"
      :label="backLabel"
      class="mr-4"
      @click="handleBack"
    />

    <!-- AI Search Bar (Placeholder) -->
    <div v-if="showSearch" class="flex-1 max-w-xl mx-auto hidden md:block">
      <div class="relative group">
        <UIcon
          name="i-lucide-sparkles"
          class="absolute left-3 top-1/2 -translate-y-1/2 text-primary size-5"
        />
        <input
          type="text"
          placeholder="Ask Datto about anything..."
          class="w-full bg-elevated border border-default rounded-full h-10 pl-10 pr-4 text-sm focus:outline-none focus:border-primary focus:ring-1 focus:ring-primary transition-all cursor-not-allowed opacity-60"
          disabled
        >
      </div>
    </div>

    <!-- Right Side Actions -->
    <div class="flex-1 md:flex-none flex justify-end items-center gap-3">
      <!-- Language Selector -->
      <LanguageSelector v-if="showLanguageSelector" />

      <!-- Theme Toggle -->
      <UColorModeSwitch v-if="showThemeToggle" />

      <!-- User Avatar -->
      <UAvatar
        v-if="showUserAvatar && currentUser"
        :src="userAvatar.src"
        :alt="userAvatar.alt"
        size="sm"
        class="ring-2 ring-default"
      />
    </div>
  </header>
</template>


