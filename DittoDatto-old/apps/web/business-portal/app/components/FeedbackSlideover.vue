<script setup lang="ts">
/**
 * FeedbackSlideover — Portal user feedback form
 *
 * Opens from sidebar "Feedback" link. Sends to feedback_submit CF
 * with source: 'portal_feedback' or 'portal_support'.
 */
import { getFunctions, httpsCallable } from 'firebase/functions'
import { useCurrentUser, useFirebaseApp } from 'vuefire'

const props = defineProps<{
  modelValue: boolean
}>()
const emit = defineEmits<{
  'update:modelValue': [value: boolean]
}>()

const open = computed({
  get: () => props.modelValue,
  set: (v) => emit('update:modelValue', v)
})

const firebaseApp = useFirebaseApp()
const user = useCurrentUser()
const toast = useToast()
const loading = ref(false)

const categories = [
  { label: 'General feedback', value: 'general', icon: 'i-lucide-message-square' },
  { label: 'Bug report', value: 'bug', icon: 'i-lucide-bug' },
  { label: 'Feature request', value: 'feature_request', icon: 'i-lucide-lightbulb' },
  { label: 'UX issue', value: 'ux_issue', icon: 'i-lucide-monitor-x' },
  { label: 'Compliment', value: 'compliment', icon: 'i-lucide-heart' },
  { label: 'Question', value: 'question', icon: 'i-lucide-help-circle' },
] as const

const form = reactive({
  category: 'general',
  subject: '',
  body: '',
})

async function handleSubmit() {
  if (!form.body.trim()) return

  loading.value = true

  try {
    const functions = getFunctions(firebaseApp, 'europe-west1')
    const submitFeedback = httpsCallable(functions, 'feedback_submit')

    await submitFeedback({
      senderName: user.value?.displayName || 'Portal User',
      senderEmail: user.value?.email || 'unknown@portal',
      source: form.category === 'bug' || form.category === 'ux_issue'
        ? 'portal_support'
        : 'portal_feedback',
      category: form.category,
      subject: form.subject.trim() || undefined,
      body: form.body.trim(),
      metadata: {
        url: window.location.href,
        userAgent: navigator.userAgent,
        viewport: `${window.innerWidth}x${window.innerHeight}`,
      },
    })

    toast.add({
      title: 'Tilbakemelding sendt!',
      description: 'Takk for din tilbakemelding. Vi setter stor pris på det.',
      color: 'success',
      icon: 'i-lucide-check-circle',
    })

    // Reset and close
    form.category = 'general'
    form.subject = ''
    form.body = ''
    open.value = false
  } catch (e: any) {
    console.error('[Feedback] Submit failed:', e)
    toast.add({
      title: 'Sending mislyktes',
      description: e?.message || 'Prøv igjen senere.',
      color: 'error',
    })
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <USlideover v-model:open="open" title="Send tilbakemelding" description="Your feedback helps us improve DittoDatto.">
    <template #body>
      <form class="space-y-4" @submit.prevent="handleSubmit">
        <!-- Category pills -->
        <UFormField label="Category">
          <div class="flex flex-wrap gap-2">
            <UButton
              v-for="cat in categories"
              :key="cat.value"
              size="sm"
              :variant="form.category === cat.value ? 'solid' : 'outline'"
              :color="form.category === cat.value ? 'primary' : 'neutral'"
              :icon="cat.icon"
              :label="cat.label"
              @click="form.category = cat.value"
            />
          </div>
        </UFormField>

        <!-- Subject (optional) -->
        <UFormField label="Subject (optional)">
          <UInput
            v-model="form.subject"
            placeholder="Short summary..."
            size="lg"
          />
        </UFormField>

        <!-- Body -->
        <UFormField label="Your feedback" required>
          <UTextarea
            v-model="form.body"
            placeholder="Tell us what's on your mind..."
            :rows="6"
            size="lg"
          />
        </UFormField>

        <!-- Context info -->
        <div class="text-xs text-muted space-y-0.5">
          <p>Logged in as <span class="font-medium text-default">{{ user?.displayName || user?.email }}</span></p>
          <p>Current page: <span class="font-mono text-default">{{ $route.path }}</span></p>
        </div>
      </form>
    </template>

    <template #footer>
      <div class="flex items-center justify-end gap-2">
        <UButton
          variant="ghost"
          color="neutral"
          label="Cancel"
          @click="open = false"
        />
        <UButton
          color="primary"
          label="Send feedback"
          icon="i-lucide-send"
          :loading="loading"
          :disabled="!form.body.trim()"
          @click="handleSubmit"
        />
      </div>
    </template>
  </USlideover>
</template>
