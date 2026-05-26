<script setup lang="ts">
/**
 * BookingChatMessages.vue
 *
 * Thin adapter between Firestore Message[] and UChatMessages.
 * Maps senderType → role so UChatMessages can render correctly without AI SDK.
 *
 * user  → role: 'user'    (right side, soft variant)
 * staff | datto → role: 'assistant' (left side, naked variant)
 *
 * No `status` prop — this is a human-to-human channel.
 * When Datto goes live, 'datto' senderType renders automatically as assistant.
 */

import type { Message } from '@dittodatto/shared-types'

const props = defineProps<{
  messages: Message[]
  loading: boolean
}>()

const { t } = useI18n()
const { user } = useAuth()

/** Map Firestore messages → UChatMessages UIMessage format.
 *  Role is derived from senderId, NOT senderType — the portal had a bug
 *  where all messages were stored as senderType:'user'. senderId is ground truth.
 */
const uiMessages = computed(() =>
  props.messages.map(m => ({
    id: m.id,
    role: (m.senderId === user.value?.uid ? 'user' : 'assistant') as 'user' | 'assistant',
    parts: [{ type: 'text' as const, text: m.content }]
  }))
)

const userAvatar = computed(() => ({
  src: user.value?.photoURL || undefined,
  icon: user.value?.photoURL ? undefined : 'i-lucide-user',
  alt: user.value?.displayName || 'Du'
}))
</script>

<template>
  <div class="flex-1 flex flex-col min-h-0 relative">
    <!-- Loading -->
    <div v-if="loading" class="flex-1 flex items-center justify-center">
      <div class="flex flex-col items-center gap-3 text-muted">
        <UIcon name="i-lucide-loader-2" class="size-6 animate-spin" />
      </div>
    </div>

    <!-- Empty state -->
    <div
      v-else-if="messages.length === 0"
      class="flex-1 flex items-center justify-center p-6"
    >
      <div class="text-center space-y-2">
        <div class="w-14 h-14 mx-auto rounded-full bg-primary-50 dark:bg-primary-950 flex items-center justify-center">
          <UIcon name="i-lucide-message-circle" class="size-7 text-primary-400" />
        </div>
        <p class="text-sm text-muted">{{ t('profile.chat.empty') }}</p>
      </div>
    </div>

    <!-- Messages -->
    <UChatMessages
      v-else
      :messages="uiMessages"
      should-auto-scroll
      :user="{
        avatar: userAvatar,
        variant: 'soft',
        side: 'right'
      }"
      :assistant="{
        avatar: { icon: 'i-lucide-store' },
        variant: 'naked',
        side: 'left'
      }"
    />
  </div>
</template>
