<script setup lang="ts">
import { definePageMeta, useToast } from '#imports'
import { AppSettingsSchema } from '@dittodatto/shared-types'
import type { AppSettings } from '@dittodatto/shared-types'

useHead({
  title: 'General Settings'
})

definePageMeta({
  layout: 'admin-dashboard'
})

const toast = useToast()
const loading = ref(false)

// --- State ---
const { data: settings, refresh } = await useFetch<AppSettings>('/api/settings/general')

const state = reactive({
  maintenanceMode: settings.value?.maintenanceMode ?? false,
  maintenanceMessage: settings.value?.maintenanceMessage ?? '',
  solarDebugEnabled: settings.value?.solarDebugEnabled ?? false
})

// Sync state if data changes
watch(settings, (newVal) => {
  if (newVal) {
    state.maintenanceMode = newVal.maintenanceMode
    state.maintenanceMessage = newVal.maintenanceMessage ?? ''
    state.solarDebugEnabled = newVal.solarDebugEnabled ?? false
  }
}, { immediate: true })

async function onSubmit() {
  loading.value = true
  try {
    await $fetch('/api/settings/general', {
      method: 'POST',
      body: state
    })
    toast.add({ title: 'Settings updated', color: 'success' })
    await refresh()
  } catch (err: any) {
    toast.add({
      title: err.data?.statusMessage || 'Failed to update settings',
      color: 'error'
    })
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <UDashboardPanel id="settings-general">
    <template #header>
      <UDashboardNavbar>
        <template #left>
          <UDashboardSidebarCollapse />
          <div class="ml-4 text-lg font-semibold">
            General Settings
          </div>
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <div class="p-6">
        <UDashboardSection
          title="Maintenance Mode"
          description="Configure when the marketplace is accessible to the public."
        >
          <UForm
            :schema="AppSettingsSchema.partial()"
            :state="state"
            class="space-y-6 max-w-2xl"
            @submit="onSubmit"
          >
            <UFormField
              name="maintenanceMode"
              label="Enable Maintenance Mode"
              description="When enabled, the public marketplace will be closed to all users except super-admins."
            >
              <USwitch v-model="state.maintenanceMode" />
            </UFormField>

            <UFormField
              name="maintenanceMessage"
              label="Maintenance Message"
              description="The message shown to users when maintenance mode is active."
            >
              <UTextarea
                v-model="state.maintenanceMessage"
                placeholder="We are currently under maintenance..."
                class="w-full"
              />
            </UFormField>

            <UButton
              type="submit"
              color="primary"
              :loading="loading"
            >
              Save Changes
            </UButton>
          </UForm>
        </UDashboardSection>

        <UDashboardSection
          title="Solar Theme Debug"
          description="Enable the time-slider debug bar on the public marketplace for dev/calibration use."
        >
          <UForm
            :schema="AppSettingsSchema.partial()"
            :state="state"
            class="space-y-6 max-w-2xl"
            @submit="onSubmit"
          >
            <UFormField
              name="solarDebugEnabled"
              label="Enable Solar Debug Bar"
              description="Shows a floating time-slider on the public marketplace. Should remain off in production."
            >
              <USwitch v-model="state.solarDebugEnabled" />
            </UFormField>

            <UButton
              type="submit"
              color="primary"
              :loading="loading"
            >
              Save Changes
            </UButton>
          </UForm>
        </UDashboardSection>
      </div>
    </template>
  </UDashboardPanel>
</template>
