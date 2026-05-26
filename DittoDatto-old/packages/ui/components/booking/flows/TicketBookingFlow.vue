<script setup lang="ts">
/**
 * TicketBookingFlow
 * 
 * Ticket purchase flow for events:
 * 1. Select ticket tier
 * 2. Select quantity
 * 3. Review & confirm (mock payment for now)
 */

interface TicketGroup {
  groupId: string
  name: string
  description?: string
  price: number
  currency: string
  availableCount: number
  isAvailable: boolean
}

interface Props {
  eventId: string
  eventTitle?: string
  eventDate?: Date | string
  eventLocation?: string
  maxPerPurchase?: number
  groups?: TicketGroup[]
}

const props = withDefaults(defineProps<Props>(), {
  eventTitle: 'Event',
  maxPerPurchase: 10,
  groups: () => []
})

const emit = defineEmits<{
  (e: 'back'): void
  (e: 'cancel'): void
  (e: 'complete', data: { groupId: string; quantity: number; totalPrice: number }): void
  (e: 'confirm', data: { groupId: string; quantity: number; totalPrice: number }): void
}>()

// Use provided groups or mock data for demo
const ticketGroups = computed(() => {
  if (props.groups && props.groups.length > 0) {
    return props.groups
  }
  // Demo mock data
  return [
    { groupId: 'general', name: 'General Admission', description: 'Standard entry', price: 15000, currency: 'NOK', availableCount: 50, isAvailable: true },
    { groupId: 'vip', name: 'VIP', description: 'Priority entry + backstage', price: 35000, currency: 'NOK', availableCount: 10, isAvailable: true }
  ]
})

// State
type Step = 'select' | 'quantity' | 'confirm'
const step = ref<Step>('select')
const selectedGroup = ref<TicketGroup | null>(null)
const quantity = ref(1)
const processing = ref(false)

// Computed
const maxQuantity = computed(() => {
  if (!selectedGroup.value) return 1
  return Math.min(props.maxPerPurchase, selectedGroup.value.availableCount)
})

const totalPrice = computed(() => {
  if (!selectedGroup.value) return 0
  return selectedGroup.value.price * quantity.value
})

// Format helpers
function formatPrice(price: number, currency: string = 'NOK'): string {
  if (price === 0) return 'Free'
  return new Intl.NumberFormat('nb-NO', {
    style: 'decimal',
    minimumFractionDigits: 2
  }).format(price / 100) + ' ' + currency
}

function formatDate(date: Date | string): string {
  const d = typeof date === 'string' ? new Date(date) : date
  return new Intl.DateTimeFormat('nb-NO', {
    weekday: 'short',
    day: 'numeric',
    month: 'short',
    hour: '2-digit',
    minute: '2-digit'
  }).format(d)
}

// Actions
function selectTier(group: TicketGroup) {
  if (!group.isAvailable) return
  selectedGroup.value = group
  quantity.value = 1
  step.value = 'quantity'
}

function goBack() {
  if (step.value === 'quantity') {
    step.value = 'select'
    selectedGroup.value = null
  } else if (step.value === 'confirm') {
    step.value = 'quantity'
  } else {
    emit('back')
  }
}

function proceedToConfirm() {
  step.value = 'confirm'
}

async function confirmPurchase() {
  if (!selectedGroup.value) return
  processing.value = true
  
  // Simulate network delay
  await new Promise(resolve => setTimeout(resolve, 1000))
  
  emit('confirm', {
    groupId: selectedGroup.value.groupId,
    quantity: quantity.value,
    totalPrice: totalPrice.value
  })
  
  processing.value = false
}
</script>

<template>
  <div class="flex flex-col h-full">
    <!-- Header -->
    <div class="p-4 border-b border-default">
      <div class="flex items-start gap-3">
        <div class="shrink-0 size-12 rounded-lg bg-purple-500/20 flex items-center justify-center">
          <UIcon name="i-lucide-ticket" class="size-6 text-purple-500" />
        </div>
        <div class="flex-1 min-w-0">
          <h2 class="font-bold text-lg">{{ eventTitle }}</h2>
          <p class="text-sm text-muted">
            {{ formatDate(eventDate) }}
            <span v-if="eventLocation"> · {{ eventLocation }}</span>
          </p>
        </div>
      </div>
    </div>

    <!-- Step Content -->
    <div class="flex-1 overflow-y-auto p-4">
      <!-- Step 1: Select Tier -->
      <div v-if="step === 'select'" class="space-y-3">
        <h3 class="font-semibold text-sm text-muted mb-4">Select Ticket Type</h3>
        
        <div
          v-for="group in ticketGroups"
          :key="group.groupId"
          class="p-4 rounded-xl border transition-all cursor-pointer"
          :class="[
            group.isAvailable
              ? 'border-default hover:border-primary bg-muted/30'
              : 'border-default bg-muted/10 opacity-50 cursor-not-allowed'
          ]"
          @click="selectTier(group)"
        >
          <div class="flex items-center justify-between">
            <div>
              <h4 class="font-semibold">{{ group.name }}</h4>
              <p v-if="group.description" class="text-sm text-muted">
                {{ group.description }}
              </p>
            </div>
            <div class="text-right">
              <p class="font-bold" :class="group.price === 0 ? 'text-green-500' : 'text-primary'">
                {{ formatPrice(group.price, group.currency) }}
              </p>
              <p class="text-xs text-muted">
                {{ group.isAvailable ? `${group.availableCount} left` : 'Sold out' }}
              </p>
            </div>
          </div>
        </div>

        <div v-if="ticketGroups.length === 0" class="text-center py-8 text-muted">
          <UIcon name="i-lucide-ticket-x" class="size-12 mx-auto mb-2 opacity-50" />
          <p>No tickets available</p>
        </div>
      </div>

      <!-- Step 2: Select Quantity -->
      <div v-else-if="step === 'quantity'" class="space-y-6">
        <div class="p-4 rounded-xl bg-purple-50 dark:bg-purple-900/20">
          <p class="text-sm text-muted mb-1">Selected</p>
          <p class="font-semibold text-lg">{{ selectedGroup?.name }}</p>
          <p class="text-primary font-bold">
            {{ formatPrice(selectedGroup?.price || 0, selectedGroup?.currency) }} each
          </p>
        </div>

        <div>
          <h4 class="font-semibold mb-4">How many tickets?</h4>
          <div class="flex items-center justify-center gap-6">
            <UButton
              icon="i-lucide-minus"
              color="neutral"
              variant="soft"
              size="lg"
              :disabled="quantity <= 1"
              @click="quantity--"
            />
            <span class="text-4xl font-bold min-w-16 text-center">{{ quantity }}</span>
            <UButton
              icon="i-lucide-plus"
              color="neutral"
              variant="soft"
              size="lg"
              :disabled="quantity >= maxQuantity"
              @click="quantity++"
            />
          </div>
          <p class="text-center text-sm text-muted mt-2">
            Max {{ maxQuantity }} per purchase
          </p>
        </div>

        <div class="p-4 rounded-xl bg-muted/50">
          <div class="flex justify-between text-lg">
            <span>Total</span>
            <span class="font-bold text-primary">
              {{ formatPrice(totalPrice, selectedGroup?.currency) }}
            </span>
          </div>
        </div>
      </div>

      <!-- Step 3: Confirm -->
      <div v-else-if="step === 'confirm'" class="space-y-4">
        <div class="p-4 rounded-xl bg-green-50 dark:bg-green-900/20 text-center">
          <UIcon name="i-lucide-check-circle" class="size-12 mx-auto mb-2 text-green-500" />
          <h3 class="font-bold text-lg">Ready to Purchase</h3>
          <p class="text-sm text-muted">Review your order below</p>
        </div>

        <div class="p-4 rounded-xl border border-default space-y-3">
          <div class="flex justify-between">
            <span class="text-muted">Event</span>
            <span class="font-medium">{{ eventTitle }}</span>
          </div>
          <div class="flex justify-between">
            <span class="text-muted">Tickets</span>
            <span class="font-medium">{{ quantity }}x {{ selectedGroup?.name }}</span>
          </div>
          <USeparator />
          <div class="flex justify-between text-lg">
            <span class="font-semibold">Total</span>
            <span class="font-bold text-primary">
              {{ formatPrice(totalPrice, selectedGroup?.currency) }}
            </span>
          </div>
        </div>

        <!-- Payment Notice -->
        <div class="p-3 rounded-lg bg-yellow-50 dark:bg-yellow-900/20 flex items-start gap-2">
          <UIcon name="i-lucide-info" class="size-4 text-yellow-600 mt-0.5" />
          <div class="text-sm text-yellow-700 dark:text-yellow-300">
            <p class="font-medium">Demo Mode</p>
            <p class="text-xs">Payment integration coming Q1 2026. Click confirm to complete mock purchase.</p>
          </div>
        </div>
      </div>
    </div>

    <!-- Footer -->
    <div class="p-4 border-t border-default">
      <div class="flex gap-3">
        <UButton
          icon="i-lucide-arrow-left"
          color="neutral"
          variant="ghost"
          @click="goBack"
        />
        
        <UButton
          v-if="step === 'quantity'"
          label="Continue"
          color="primary"
          block
          size="lg"
          @click="proceedToConfirm"
        />
        
        <UButton
          v-else-if="step === 'confirm'"
          label="Confirm Purchase"
          color="primary"
          block
          size="lg"
          :loading="processing"
          @click="confirmPurchase"
        />
      </div>
    </div>
  </div>
</template>
