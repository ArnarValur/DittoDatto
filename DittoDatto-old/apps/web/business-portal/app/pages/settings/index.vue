<script setup lang="ts">
import { UserSchema } from '@dittodatto/shared-types'
import type { User } from '@dittodatto/shared-types'

useHead({
  title: 'General Settings'
})

definePageMeta({
  layout: 'dashboard'
})

const { profile, loading, updateProfile, uploadAvatar } = useUserProfile()

const state = reactive({
  name: '',
  email: '',
  username: '',
  bio: ''
})

// Sync state when profile is loaded
watch(profile, (val) => {
  if (val) {
    state.name = val.name || ''
    state.email = val.email || ''
    state.username = val.username || ''
    state.bio = val.bio || ''
  }
}, { immediate: true })

async function onSubmit() {
  try {
    await updateProfile({
      name: state.name,
      email: state.email,
      username: state.username,
      bio: state.bio
    })
  } catch {
    // Error handled in composable toast
  }
}

async function onFileChange(e: Event) {
  const input = e.target as HTMLInputElement
  if (!input.files || input.files.length === 0) return

  const file = input.files[0]
  if (!file) return

  if (file.size > 1024 * 1024) {
    useToast().add({ title: 'File too large', description: 'Max size is 1MB', color: 'error' })
    return
  }

  try {
    await uploadAvatar(file)
  } catch {
    // Error handled in composable toast
  }
}

const fileInput = ref<HTMLInputElement | null>(null)
function triggerFileInput() {
  fileInput.value?.click()
}
</script>

<template>
  <UDashboardPanel id="settings-general">
    <template #header>
      <UDashboardNavbar>
        <template #left>
          <UDashboardSidebarCollapse />
          <div class="ml-4 text-lg font-semibold">
            Settings
          </div>
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <div class="p-6">
        <UDashboardSection
          title="Profile"
          description="These informations will be displayed publicly."
        >
          <UForm
            :schema="UserSchema.partial()"
            :state="state"
            class="space-y-6 max-w-2xl bg-elevated/50 p-6 rounded-lg border border-default"
            @submit="onSubmit"
          >
            <UFormField
              name="name"
              label="Name"
              description="Will appear on receipts, invoices, and other communication."
              required
            >
              <UInput v-model="state.name" placeholder="Your full name" class="w-full" />
            </UFormField>

            <UFormField
              name="email"
              label="Email"
              description="Used to sign in, for email receipts and product updates."
              required
            >
              <UInput v-model="state.email" placeholder="email@example.com" class="w-full" />
            </UFormField>

            <UFormField
              name="username"
              label="Username"
              description="Your unique username for logging in and your profile URL."
              required
            >
              <UInput v-model="state.username" placeholder="username" class="w-full" />
            </UFormField>

            <UFormField
              name="photoUrl"
              label="Avatar"
              description="JPG, GIF or PNG. 1MB Max."
            >
              <div class="flex items-center gap-4">
                <UAvatar
                  :src="profile?.photoUrl"
                  :alt="state.name"
                  size="lg"
                  class="bg-neutral-800"
                />
                <input
                  ref="fileInput"
                  type="file"
                  accept="image/*"
                  class="hidden"
                  @change="onFileChange"
                >
                <UButton
                  label="Choose"
                  color="neutral"
                  variant="outline"
                  @click="triggerFileInput"
                />
              </div>
            </UFormField>

            <UFormField
              name="bio"
              label="Bio"
              description="Brief description for your profile. URLs are hyperlinked."
            >
              <UTextarea
                v-model="state.bio"
                placeholder="Tell us about yourself..."
                class="w-full"
                :rows="4"
              />
            </UFormField>

            <div class="flex justify-end pt-4 border-t border-default">
              <UButton
                label="Save changes"
                icon="i-lucide-save"
                color="primary"
                type="submit"
                :loading="loading"
              />
            </div>
          </UForm>
        </UDashboardSection>
      </div>
    </template>
  </UDashboardPanel>
</template>
