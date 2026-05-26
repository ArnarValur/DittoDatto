<script setup lang="ts">
type StatusType = 'tier' | 'onboarding' | 'role' | 'status'

const props = defineProps<{
  type: StatusType
  value: string
}>()

const config = computed(() => {
  switch (props.type) {
    case 'tier':
      return props.value === 'premium'
        ? { color: 'primary', icon: 'i-lucide-crown', label: 'Premium' }
        : { color: 'neutral', icon: 'i-lucide-box', label: 'Free' }
    case 'onboarding': {
      const map: Record<string, { color: string, label: string }> = {
        not_started: { color: 'neutral', label: 'Not Started' },
        ai_suggested: { color: 'warning', label: 'AI Suggested' },
        verified: { color: 'primary', label: 'Verified' },
        complete: { color: 'success', label: 'Complete' }
      }
      return map[props.value] || { color: 'neutral', label: props.value }
    }
    case 'role': {
      if (props.value === 'admin' || props.value === 'super-admin') {
        return { color: 'primary', icon: 'i-lucide-shield', label: props.value.replace('-', ' ') }
      }
      if (props.value === 'business_owner' || props.value === 'company-owner') {
        return { color: 'secondary', icon: 'i-lucide-briefcase', label: 'Owner' }
      }
      if (props.value === 'company-person') {
        return { color: 'info', icon: 'i-lucide-users', label: 'Staff' }
      }
      return { color: 'neutral', icon: 'i-lucide-user', label: props.value.replace('_', ' ') }
    }
    default:
      if (props.value === 'active') {
        return { color: 'success', label: 'Active' }
      }
      if (props.value === 'pending') {
        return { color: 'warning', label: 'Pending' }
      }
      return { color: 'neutral', label: props.value || 'Unknown' }
  }
})
</script>

<template>
  <UBadge
    :color="config.color as any"
    :label="config.label"
    :icon="config.icon"
    variant="subtle"
    size="xs"
    class="capitalize"
  />
</template>
