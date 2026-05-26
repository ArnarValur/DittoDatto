<script setup lang="ts">
type Membership = {
  companyId: string
  companyName?: string
  role?: string
}

const props = withDefaults(defineProps<{
  memberships: Membership[]
  availableCompanies?: { label: string, value: string }[]
  loading?: boolean
}>(), {
  availableCompanies: () => [],
  loading: false
})

const { memberships, availableCompanies, loading } = toRefs(props)

const emit = defineEmits<{
  add: [{ companyId: string, role: string }]
  remove: [companyId: string]
}>()

const selectedCompany = ref<string | null>(null)
const selectedRole = ref<'owner' | 'staff'>('staff')

const addMembership = () => {
  if (!selectedCompany.value) {
    return
  }
  emit('add', { companyId: selectedCompany.value, role: selectedRole.value })
  selectedCompany.value = null
  selectedRole.value = 'staff'
}

const handleRemove = (companyId: string) => {
  emit('remove', companyId)
}
</script>

<template>
  <div class="space-y-4">
    <div class="flex gap-2 items-end">
      <UFormField
        label="Add Company"
        class="flex-1"
      >
        <USelectMenu
          v-model="selectedCompany"
          searchable
          placeholder="Search company..."
          :options="availableCompanies || []"
          value-attribute="value"
          option-attribute="label"
        />
      </UFormField>
      <USelectMenu
        v-model="selectedRole"
        :options="[
          { label: 'Owner', value: 'owner' },
          { label: 'Staff', value: 'staff' }
        ]"
        class="w-28"
      />
      <UButton
        icon="i-lucide-plus"
        color="primary"
        square
        :disabled="!selectedCompany || loading"
        @click="addMembership"
      />
    </div>

    <div
      v-if="memberships.length === 0"
      class="text-sm text-gray-500"
    >
      No memberships yet.
    </div>

    <div
      v-else
      class="space-y-2"
    >
      <div
        v-for="membership in memberships"
        :key="membership.companyId"
        class="flex items-center justify-between p-3 rounded-md border border-gray-200 dark:border-gray-800 bg-gray-50 dark:bg-gray-800/40"
      >
        <div>
          <p class="text-sm font-medium">
            {{ membership.companyName || membership.companyId }}
          </p>
          <p class="text-xs text-gray-500">
            {{ membership.role || 'member' }}
          </p>
        </div>
        <UButton
          icon="i-lucide-trash-2"
          color="error"
          variant="ghost"
          size="xs"
          @click="handleRemove(membership.companyId)"
        />
      </div>
    </div>
  </div>
</template>
