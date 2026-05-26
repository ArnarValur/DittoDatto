<script setup lang="ts">
import { ref } from 'vue'

definePageMeta({
  layout: 'admin-dashboard'
})
// Simple Lookup Page
const searchQuery = ref('')
const isSearching = ref(false)
const toast = useAppToast()
const router = useRouter()

async function handleLookup() {
  if (!searchQuery.value.trim()) return

  isSearching.value = true
  try {
    const query = searchQuery.value.trim()

    // MVP: Assume query is ID.
    // Future: Backend Search API
    try {
      const directUser = await $fetch(`/api/users/${query}`)
      if (directUser) {
        navigateTo(`/users/${(directUser as any).uid}`)
        return
      }
    } catch (e: any) {
      if (e.statusCode !== 404) throw e
    }

    // If we get here, ID lookup failed.
    toast.add({
      title: 'User not found',
      description: 'Could not find a user with this ID.',
      color: 'warning'
    })
  } catch (e) {
    toast.add({ title: 'Error', description: 'Lookup failed.', color: 'error' })
  } finally {
    isSearching.value = false
  }
}
</script>

<template>
  <UDashboardPanel>
    <template #header>
      <UDashboardNavbar title="User Lookup">
        <template #leading>
          <UButton
            icon="i-lucide-arrow-left"
            variant="ghost"
            color="neutral"
            @click="router.back()"
          />
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <UCard class="max-w-md mx-auto mt-10">
        <div class="text-center mb-6">
          <div class="bg-primary/10 w-12 h-12 rounded-full flex items-center justify-center mx-auto mb-4">
            <UIcon
              name="i-lucide-search"
              class="w-6 h-6 text-primary"
            />
          </div>
          <h3 class="font-semibold text-lg">
            Find a User
          </h3>
          <p class="text-muted text-sm mt-1">
            Enter a User ID to view their full profile details.
          </p>
        </div>

        <div class="flex gap-2">
          <UInput
            v-model="searchQuery"
            icon="i-lucide-search"
            placeholder="User ID..."
            class="flex-1"
            :loading="isSearching"
            @keydown.enter="handleLookup"
          />
          <UButton
            label="Go"
            color="primary"
            :loading="isSearching"
            @click="handleLookup"
          />
        </div>

        <div class="mt-4 text-xs text-center text-muted">
          <p>Tip: You can copy IDs from the User List.</p>
        </div>
      </UCard>
    </template>
  </UDashboardPanel>
</template>
