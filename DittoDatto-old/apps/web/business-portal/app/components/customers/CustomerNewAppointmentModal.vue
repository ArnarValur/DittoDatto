<script setup lang="ts">
import type { Customer } from '@dittodatto/shared-types'
import { formatDistanceToNow } from 'date-fns'
import { nb } from 'date-fns/locale'

const props = defineProps<{
  open: boolean
  customer?: Customer | null
}>()

const emit = defineEmits<{
  'update:open': [value: boolean]
  'selected': [customer: Customer]
}>()

const isOpen = computed({
  get: () => props.open,
  set: (val) => emit('update:open', val)
})

// Suggestion state
const { customers, searchQuery } = useCustomers()
const selectedCustomerId = ref<string | null>(props.customer?.id || null)

// Sync selected customer when prop changes
watch(() => props.customer, (c) => {
  selectedCustomerId.value = c?.id || null
})

// Filter suggestions based on input in the profile form
const suggestions = computed(() => {
  if (!searchQuery.value) return customers.value.slice(0, 5) // recent 5
  return customers.value.slice(0, 5)
})

function selectCustomer(cust: Customer) {
  selectedCustomerId.value = cust.id
  emit('selected', cust)
}

function timeSince(dateString?: string) {
  if (!dateString) return 'Aldri besøkt'
  return formatDistanceToNow(new Date(dateString), { addSuffix: true, locale: nb })
}
</script>

<template>
  <UModal
    v-model:open="isOpen"
    :ui="{ width: 'sm:max-w-4xl' }"
    title="New appointment"
  >
    <template #body>
      <div class="flex flex-col md:flex-row bg-elevated/20 rounded-xl overflow-hidden min-h-[500px]">

        <!-- LEFT: Profile Form -->
        <div class="flex-1 border-r border-default bg-background p-6">
          <div class="flex items-center justify-between mb-6">
            <h2 class="text-xl font-semibold">New appointment</h2>
            <UButton
              color="neutral"
              variant="ghost"
              icon="i-lucide-x"
              class="md:hidden"
              @click="isOpen = false"
            />
          </div>

          <CustomersCustomerProfileForm
            :customer="customer ?? undefined"
            @cancel="isOpen = false"
          />
        </div>

        <!-- RIGHT: Suggestions -->
        <div class="w-full md:w-[400px] bg-elevated/30 p-6 flex flex-col gap-4">
          <div class="flex items-center justify-between mb-2">
            <h3 class="text-sm font-semibold text-muted">Suggestions</h3>
            <UButton
              color="neutral"
              variant="ghost"
              icon="i-lucide-x"
              class="hidden md:flex"
              @click="isOpen = false"
            />
          </div>

          <UButton
            label="Create a new client"
            icon="i-lucide-user-plus"
            color="neutral"
            variant="outline"
            class="w-full justify-center bg-background rounded-xl border border-default py-3 text-sm font-medium hover:border-primary-500 transition-colors"
            @click="selectedCustomerId = null"
          />

          <div class="text-center text-xs text-muted my-2">
            ... or select an existing client:
          </div>

          <div class="flex-1 overflow-y-auto space-y-3 pr-2 scrollbar-thin">
            <button
              v-for="cust in suggestions"
              :key="cust.id"
              class="w-full text-left bg-background rounded-xl p-4 border transition-all duration-200"
              :class="selectedCustomerId === cust.id ? 'border-primary-500 shadow-md ring-1 ring-primary-500' : 'border-default hover:border-primary-300'"
              @click="selectCustomer(cust)"
            >
              <div class="flex justify-between items-start mb-1">
                <span class="font-semibold text-sm">{{ cust.name }}</span>
                <span class="text-xs text-muted">{{ cust.totalVisits }} visits</span>
              </div>

              <div class="flex justify-between items-start text-xs text-muted">
                <div class="flex flex-col gap-0.5">
                  <span v-if="cust.phone" class="font-medium text-highlighted">{{ cust.phoneCountryCode }} {{ cust.phone }}</span>
                  <span v-if="cust.email">{{ cust.email }}</span>
                </div>
                <span class="text-right max-w-[120px]">{{ timeSince(cust.lastVisitAt) }}</span>
              </div>

              <div v-if="cust.notes" class="mt-3 text-xs bg-elevated/50 p-2 rounded-lg text-muted line-clamp-2">
                {{ cust.notes }}
              </div>
            </button>
          </div>
        </div>

      </div>
    </template>
  </UModal>
</template>
