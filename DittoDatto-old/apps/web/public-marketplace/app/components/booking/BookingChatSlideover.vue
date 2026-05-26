<script setup lang="ts">
/**
 * BookingChatSlideover.vue
 *
 * User-facing chat panel for a booking thread.
 * Opens as a USlideover — stays in context, works on mobile.
 *
 * Props:
 *   open      — v-model open state
 *   booking   — the Booking object for context display
 *   threadId  — the Firestore thread ID
 */

import type { Booking } from '@dittodatto/shared-types'

const props = defineProps<{
  open: boolean
  booking: Booking | null
  threadId: string | null
}>()

const emit = defineEmits<{
  'update:open': [value: boolean]
}>()

const { t, locale } = useI18n()
const { openThread, closeThread, messages, messagesLoading, sendMessage } = useUserThreads()

const input = ref('')
const sending = ref(false)

// Open the thread when the slideover opens
watch(() => props.open, (isOpen) => {
  if (isOpen && props.threadId) {
    openThread(props.threadId)
  } else if (!isOpen) {
    closeThread()
    input.value = ''
  }
}, { immediate: true })

async function handleSend(event: Event) {
  event.preventDefault()
  if (!props.threadId || !input.value.trim() || sending.value) return

  sending.value = true
  await sendMessage(props.threadId, input.value)
  input.value = ''
  sending.value = false
}

// Booking display helpers
const bookingDate = computed(() => {
  if (!props.booking?.startTime) return ''
  try {
    return new Date(props.booking.startTime).toLocaleDateString(locale.value, {
      weekday: 'short', day: 'numeric', month: 'short'
    })
  } catch { return '' }
})

const bookingTime = computed(() => {
  if (!props.booking?.startTime) return ''
  try {
    const fmt = (iso: string) => new Date(iso).toLocaleTimeString(locale.value, {
      hour: '2-digit', minute: '2-digit', hour12: false
    })
    return `${fmt(props.booking!.startTime)} – ${fmt(props.booking!.endTime)}`
  } catch { return '' }
})
</script>

<template>
  <USlideover
    :open="open"
    side="right"
    :title="booking?.serviceTitle || t('profile.chat.title')"
    :ui="{
      content: 'flex flex-col',
      body: 'flex-1 flex flex-col min-h-0 p-0 overflow-hidden'
    }"
    @update:open="emit('update:open', $event)"
  >
    <template #header>
      <div class="flex items-start gap-3 min-w-0">
        <!-- Back / Close -->
        <UButton
          icon="i-lucide-x"
          color="neutral"
          variant="ghost"
          size="xs"
          class="shrink-0 mt-0.5"
          @click="emit('update:open', false)"
        />
        <!-- Context -->
        <div class="min-w-0">
          <h2 class="font-semibold text-base truncate text-gray-900 dark:text-white">
            {{ booking?.serviceTitle || t('profile.chat.title') }}
          </h2>
          <p v-if="booking" class="text-xs text-muted truncate">
            {{ bookingDate }} · {{ bookingTime }}
          </p>
        </div>
      </div>
    </template>

    <template #body>
      <!-- No thread fallback -->
      <div v-if="!threadId" class="flex-1 flex items-center justify-center p-6">
        <div class="text-center space-y-2">
          <UIcon name="i-lucide-message-circle-off" class="size-10 text-muted mx-auto" />
          <p class="text-sm text-muted">{{ t('profile.chat.noThread') }}</p>
        </div>
      </div>

      <!-- Chat messages -->
      <div v-else class="flex-1 flex flex-col min-h-0 overflow-hidden">
        <div class="flex-1 overflow-y-auto py-3 px-2">
          <BookingChatMessages
            :messages="messages"
            :loading="messagesLoading"
          />
        </div>

        <!-- Divider + Input -->
        <div class="border-t border-default px-3 py-3 bg-default/50 backdrop-blur-sm">
          <UChatPrompt
            v-model="input"
            variant="subtle"
            :placeholder="t('profile.chat.placeholder')"
            :disabled="sending"
            @submit="handleSend"
          >
            <template #trailing>
              <UButton
                icon="i-lucide-send-horizontal"
                color="primary"
                variant="ghost"
                size="xs"
                :loading="sending"
                :disabled="!input.trim()"
                class="rounded-full"
                @click="handleSend"
              />
            </template>
          </UChatPrompt>
        </div>
      </div>
    </template>
  </USlideover>
</template>
