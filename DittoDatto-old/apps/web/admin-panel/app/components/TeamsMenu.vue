<script setup lang="ts">
import type { DropdownMenuItem } from '@nuxt/ui'
import { ref, shallowRef } from 'vue'

defineProps<{
  collapsed?: boolean
}>()

const teams = ref(shallowRef([
  {
    label: 'DittoDatto Admin'
  }
]))
const selectedTeam = ref(teams.value[0])

const items = computed<DropdownMenuItem[][]>(() => {
  return [teams.value.map(team => ({
    ...team,
    onSelect() {
      selectedTeam.value = team
    }
  })), [{
    label: 'Create Area',
    icon: 'i-lucide-map-pin-plus'
  }, {
    label: 'Manage Areas',
    icon: 'lucide:map-pinned'
  }]]
})
</script>

<template>
  <ClientOnly>
    <UDropdownMenu
      :items="items"
      :content="{ align: 'center', collisionPadding: 12 }"
      :ui="{ content: collapsed ? 'w-40' : 'w-(--reka-dropdown-menu-trigger-width)' }"
    >
      <UButton
        v-bind="{
          ...selectedTeam,
          label: collapsed ? undefined : selectedTeam?.label,
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
  </ClientOnly>
</template>
