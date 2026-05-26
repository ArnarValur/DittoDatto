<script setup lang="ts">
import { sendPasswordResetEmail, type Auth } from 'firebase/auth'

const { $auth } = useNuxtApp()
const user = useCurrentUser()
const toast = useToast()
const { isOwner } = useStaffPermissions()

const isLoading = ref(false)

async function handleSendResetEmail() {
  if (!user.value?.email) {
    toast.add({
      title: 'Error',
      description: 'No email address found for your account.',
      color: 'error'
    })
    return
  }

  isLoading.value = true
  try {
    await sendPasswordResetEmail($auth as Auth, user.value.email)
    toast.add({
      title: 'Email Sent',
      description: `A password reset link has been sent to ${user.value.email}. Please check your inbox.`,
      color: 'success'
    })
  } catch (error: unknown) {
    console.error('Error sending password reset email:', error)
    const errorMessage = error instanceof Error ? error.message : 'Failed to send password reset email. Please try again.'
    toast.add({
      title: 'Error',
      description: errorMessage,
      color: 'error'
    })
  } finally {
    isLoading.value = false
  }
}
</script>

<template>
  <UPageCard
    title="Password"
    description="Need to change your password? We'll send a secure reset link to your email address."
    variant="subtle"
  >
    <div class="flex flex-col gap-4 max-w-md">
      <p class="text-sm text-gray-500 dark:text-gray-400">
        For security reasons, password changes are handled via email. Click the button below and we'll send you a link to reset your password.
      </p>

      <div class="flex items-center gap-3">
        <UButton
          label="Send password reset email"
          icon="i-lucide-mail"
          :loading="isLoading"
          @click="handleSendResetEmail"
        />
        <span v-if="user?.email" class="text-sm text-gray-500 dark:text-gray-400">
          → {{ user.email }}
        </span>
      </div>
    </div>
  </UPageCard>

  <!-- Staff-only: Resign from company -->
  <UPageCard
    v-if="!isOwner"
    title="Resign"
    description="Leave this company. Your staff membership and access will be removed. This cannot be undone."
    class="bg-linear-to-tl from-warning/10 from-5% to-default"
  >
    <template #footer>
      <UTooltip text="Staff resignation is coming soon. Contact your company owner to be removed.">
        <UButton
          label="Resign from company"
          icon="i-lucide-log-out"
          color="warning"
          disabled
        />
      </UTooltip>
    </template>
  </UPageCard>

  <!-- Owner: Account deletion -->
  <UPageCard
    v-if="isOwner"
    title="Account"
    description="Account deletion will remove all your data, companies, and staff permanently. This action is not reversible."
    class="bg-linear-to-tl from-error/10 from-5% to-default"
  >
    <template #footer>
      <UTooltip text="Account deletion requests are coming soon. Contact support if you need to delete your account.">
        <UButton
          label="Delete account"
          color="error"
          disabled
        />
      </UTooltip>
    </template>
  </UPageCard>
</template>
