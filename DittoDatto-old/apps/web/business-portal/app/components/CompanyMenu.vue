<script setup lang="ts">
import type { DropdownMenuItem } from '@nuxt/ui'

defineProps<{
  collapsed?: boolean
}>()

// Get company data from composable (now with multi-company support)
const { company, companies, switchCompany, loading } = useCompany()

// Map companies to menu items
const companyItems = computed(() => {
  return companies.value.map(c => ({
    id: c.id,
    label: c.name,
    avatar: c.logoUrl
      ? {
          src: c.logoUrl,
          alt: c.name
        }
      : undefined,
    icon: c.logoUrl ? undefined : 'i-lucide-building-2'
  }))
})

const selectedCompany = computed(() => {
  if (!company.value) return null
  return {
    id: company.value.id,
    label: company.value.name,
    avatar: company.value.logoUrl
      ? {
          src: company.value.logoUrl,
          alt: company.value.name
        }
      : undefined,
    icon: company.value.logoUrl ? undefined : 'i-lucide-building-2'
  }
})

const items = computed<DropdownMenuItem[][]>(() => {
  const menuItems: DropdownMenuItem[] = companyItems.value.map(c => ({
    ...c,
    // Show checkmark for active company
    icon: c.id === company.value?.id ? 'i-lucide-check' : c.icon,
    onSelect() {
      if (c.id !== company.value?.id) {
        switchCompany(c.id)
        // Trigger page refresh to reload data for new company
        window.location.reload()
      }
    }
  }))

  return [menuItems]
})
</script>

<template>
  <UDropdownMenu
    v-if="companies.length > 1"
    :items="items"
    :content="{ align: 'center', collisionPadding: 12 }"
    :ui="{ content: collapsed ? 'w-48' : 'w-auto' }"
  >
    <UButton
      v-if="selectedCompany"
      v-bind="{
        ...selectedCompany,
        label: collapsed ? undefined : selectedCompany?.label,
        trailingIcon: collapsed ? undefined : 'i-lucide-chevrons-up-down'
      }"
      color="neutral"
      variant="ghost"
      block
      :square="collapsed"
      class="data-[state=open]:bg-elevated"
      :class="[!collapsed && 'py-2']"
      :ui="{
        trailingIcon: 'text-dimmed'
      }"
    />
  </UDropdownMenu>

  <!-- Single company or loading: no dropdown, just display -->
  <UButton
    v-else-if="loading"
    color="neutral"
    variant="ghost"
    block
    :square="collapsed"
    class="py-2"
  >
    <USkeleton class="h-5 w-5 rounded-full" />
    <USkeleton v-if="!collapsed" class="h-4 w-24" />
  </UButton>
  <UButton
    v-else-if="selectedCompany"
    v-bind="{
      ...selectedCompany,
      label: collapsed ? undefined : selectedCompany?.label
    }"
    color="neutral"
    variant="ghost"
    block
    :square="collapsed"
    :class="[!collapsed && 'py-2']"
  />
  <UButton
    v-else
    color="neutral"
    variant="ghost"
    block
    :square="collapsed"
    class="py-2"
    icon="i-lucide-loader-circle"
    :label="collapsed ? undefined : 'Laster...'"
  />
</template>
