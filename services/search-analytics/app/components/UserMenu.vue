<script setup lang="ts">
import { getAuth, signOut } from 'firebase/auth'

const router = useRouter()
const toast = useToast()

const items = [
  [{
    label: 'Profile',
    icon: 'i-lucide-user',
    to: '/settings'
  }, {
    label: 'Settings',
    icon: 'i-lucide-settings',
    to: '/settings'
  }],
  [{
    label: 'Sign out',
    icon: 'i-lucide-log-out',
    onSelect: async () => {
      try {
        const auth = getAuth()
        await signOut(auth)
        router.push('/')
        toast.add({
          title: 'Signed Out',
          description: 'You have been successfully signed out.',
          color: 'primary'
        })
      } catch (error) {
        console.error('Failed to sign out', error)
        toast.add({
          title: 'Error',
          description: 'Failed to sign out.',
          color: 'error'
        })
      }
    }
  }]
]
</script>

<template>
  <UDropdownMenu
    :items="items"
    :ui="{ content: 'w-48' }"
  >
    <UButton
      icon="i-lucide-user"
      label="Captain"
      color="neutral"
      variant="ghost"
      class="w-full justify-start"
      trailing-icon="i-lucide-chevrons-up-down"
    />
  </UDropdownMenu>
</template>
