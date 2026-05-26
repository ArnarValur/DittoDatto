<script setup lang="ts">
import { format } from 'date-fns'
import type { User } from '@dittodatto/shared-types'

definePageMeta({
  layout: 'admin-dashboard'
})

const route = useRoute()
const router = useRouter()
const userId = route.params.id as string

const searchQuery = ref('')
const isSearching = ref(false)
// const toast = useAppToast()

// 1. Fetch the specific user.
const { data: user, pending, refresh } = await useFetch<User>(`/api/users/${userId}`, {
  key: userId // Ensure key changes when route param changes
})

// 2. Define the tabs for the view.
const items = computed(() => {
  const tabs = [{
    slot: 'general',
    label: 'General Profile',
    icon: 'i-lucide-user'
  }]

  if (user.value?.role === 'business' || user.value?.role === 'super_admin') {
    tabs.push({
      slot: 'company',
      label: 'Company Data',
      icon: 'i-lucide-building-2'
    }, {
      slot: 'store',
      label: 'Store Management',
      icon: 'i-lucide-store'
    })
  }

  return tabs
})

// Helper to format dates cleanly
function formatDate(dateString?: string) {
  if (!dateString) return 'N/A'
  return format(new Date(dateString), 'PPP p')
}

// Lookup Logic
async function handleLookup() {
  if (!searchQuery.value.trim()) return

  isSearching.value = true
  try {
    // Attempt to find the user.
    // 1. If it looks like a UID, try direct fetch.
    // 2. If email/phone, search list (assuming query param support).

    // Strategy: We'll try to hit the user list with a filter.
    // If your API supports ?search= or ?email=, use that.
    // For now, we will simulate a smart lookup by trying to fetch as ID first.

    const query = searchQuery.value.trim()

    // Check if it's a direct ID match (cheap way)
    try {
      const directUser = await $fetch(`/api/users/${query}`)
      if (directUser) {
        navigateTo(`/users/${(directUser as any).uid}`)
        searchQuery.value = ''
        return
      }
    } catch (e) {
      // Not a valid ID or not found, proceed to search
    }

    // Fallback: Search endpoint (assuming implementation)
    // const found = await $fetch('/api/users/search', { query: { q: query } })

    // If we can't search, we just warn the user for this MVP
    // toast.add({
    //   title: 'Lookup Failed',
    //   description: 'Could not find a user with that ID. Search by Email/Phone requires backend implementation.',
    //   color: 'warning'
    // })
  } catch (e) {
    // toast.add({ title: 'Error', description: 'User not found.', color: 'error' })
  } finally {
    isSearching.value = false
  }
}

const isEditOpen = ref(false)
</script>

<template>
  <UDashboardPanel>
    <template #header>
      <UDashboardNavbar title="User Details">
        <template #leading>
          <UButton
            icon="i-lucide-arrow-left"
            variant="ghost"
            color="neutral"
            @click="router.back()"
          />
        </template>
        <template #right>
          <UBadge
            v-if="user"
            :color="user.role === 'business' ? 'primary' : 'neutral'"
            variant="subtle"
            class="capitalize"
          >
            {{ user.role }}
          </UBadge>
        </template>
      </UDashboardNavbar>

      <UDashboardToolbar>
        <div class="flex w-full max-w-lg">
          <UInput
            v-model="searchQuery"
            icon="i-lucide-search"
            placeholder="Lookup User by ID, Email or Phone..."
            class="flex-1"
            :loading="isSearching"
            @keydown.enter="handleLookup"
          />
          <UButton
            label="Go"
            color="neutral"
            variant="outline"
            :loading="isSearching"
            @click="handleLookup"
          />
        </div>
      </UDashboardToolbar>
    </template>

    <template #body>
      <!-- Quick Lookup Bar -->

      <div
        v-if="pending"
        class="flex flex-col gap-4 p-4"
      >
        <USkeleton class="h-12 w-full" />
        <USkeleton class="h-64 w-full" />
      </div>

      <div
        v-else-if="user"
        class="grid grid-cols-1 lg:grid-cols-3 gap-6"
      >
        <UCard class="lg:col-span-1 h-fit">
          <div class="flex flex-col items-center text-center gap-4">
            <UAvatar
              :src="user.photoUrl || user.photoUrl"
              :alt="user.name || user.name"
              size="3xl"
              class="ring-4 ring-background"
            />
            <div>
              <h2 class="text-xl font-semibold text-highlighted">
                {{ user.name || user.name || 'Unknown User' }}
              </h2>
              <p class="text-muted text-sm">
                {{ user.email }}
              </p>
            </div>

            <UDivider />

            <div class="w-full grid grid-cols-2 gap-4 text-left text-sm">
              <div>
                <p class="text-muted text-xs mb-1">
                  Status
                </p>
                <div class="flex items-center gap-2">
                  <div class="w-2 h-2 rounded-full bg-green-500" />
                  <span>Active</span>
                </div>
              </div>
              <div>
                <p class="text-muted text-xs mb-1">
                  Language
                </p>
                <span class="uppercase">{{ user.language || 'EN' }}</span>
              </div>
              <div class="col-span-2">
                <p class="text-muted text-xs mb-1">
                  User ID
                </p>
                <code class="text-xs bg-muted/10 p-1 rounded">{{ user.id || user.id }}</code>
              </div>
            </div>
          </div>
        </UCard>

        <div class="lg:col-span-2">
          <UTabs
            :items="items"
            class="w-full"
          >
            <template #general>
              <UCard class="mt-4">
                <template #header>
                  <div class="flex items-center justify-between">
                    <h3 class="text-base font-semibold">
                      Personal Information
                    </h3>
                    <UButton
                      label="Edit"
                      variant="ghost"
                      color="primary"
                      icon="i-lucide-pencil"
                      @click="isEditOpen = true"
                    />
                  </div>
                </template>

                <dl class="divide-y divide-default">
                  <div class="py-3 grid grid-cols-1 sm:grid-cols-3 gap-4">
                    <dt class="font-medium text-muted">
                      Full Name
                    </dt>
                    <dd class="sm:col-span-2">
                      {{ user.name || user.name }}
                    </dd>
                  </div>
                  <div class="py-3 grid grid-cols-1 sm:grid-cols-3 gap-4">
                    <dt class="font-medium text-muted">
                      Email Address
                    </dt>
                    <dd class="sm:col-span-2">
                      {{ user.email }}
                    </dd>
                  </div>
                  <div class="py-3 grid grid-cols-1 sm:grid-cols-3 gap-4">
                    <dt class="font-medium text-muted">
                      Phone
                    </dt>
                    <dd class="sm:col-span-2">
                      {{ user.phone || 'Not provided' }}
                    </dd>
                  </div>
                  <div class="py-3 grid grid-cols-1 sm:grid-cols-3 gap-4">
                    <dt class="font-medium text-muted">
                      Onboarded
                    </dt>
                    <dd class="sm:col-span-2">
                      <UBadge
                        :color="user.isOnboarded ? 'success' : 'warning'"
                        variant="subtle"
                        size="xs"
                      >
                        {{ user.isOnboarded ? 'Yes' : 'Pending' }}
                      </UBadge>
                    </dd>
                  </div>
                  <div class="py-3 grid grid-cols-1 sm:grid-cols-3 gap-4">
                    <dt class="font-medium text-muted">
                      Joined
                    </dt>
                  </div>
                </dl>
              </UCard>
            </template>

            <template #company>
              <UCard class="mt-4 border-dashed border-2 border-default bg-transparent shadow-none">
                <div class="text-center py-8">
                  <div class="bg-primary/10 w-12 h-12 rounded-full flex items-center justify-center mx-auto mb-4">
                    <UIcon
                      name="i-lucide-building-2"
                      class="w-6 h-6 text-primary"
                    />
                  </div>
                  <h3 class="font-semibold">
                    Company Information
                  </h3>
                  <p class="text-muted text-sm mt-1 max-w-sm mx-auto">
                    <!-- Placeholder Comment -->
                    This Users Details page will grow in the future with total user overview.
                    Company and Store details will be implemented later in development.
                  </p>
                  <UButton
                    label="Link Company"
                    variant="outline"
                    class="mt-4"
                    disabled
                  />
                </div>
              </UCard>
            </template>

            <template #store>
              <UCard class="mt-4 border-dashed border-2 border-default bg-transparent shadow-none">
                <div class="text-center py-8">
                  <div class="bg-primary/10 w-12 h-12 rounded-full flex items-center justify-center mx-auto mb-4">
                    <UIcon
                      name="i-lucide-store"
                      class="w-6 h-6 text-primary"
                    />
                  </div>
                  <h3 class="font-semibold">
                    Store Dashboard
                  </h3>
                  <p class="text-muted text-sm mt-1 max-w-sm mx-auto">
                    <!-- Placeholder Comment -->
                    This Users Details page will grow in the future with total user overview.
                    Store performance, inventory overview, and recent orders will be implemented later in development.
                  </p>
                </div>
              </UCard>
            </template>
          </UTabs>
        </div>
      </div>

      <div
        v-else
        class="flex flex-col items-center justify-center h-full text-muted"
      >
        <UIcon
          name="i-lucide-user-x"
          class="w-12 h-12 mb-2"
        />
        <p>User not found</p>
      </div>
    </template>
  </UDashboardPanel>
</template>
