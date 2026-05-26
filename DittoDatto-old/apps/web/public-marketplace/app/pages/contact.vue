<script setup lang="ts">
import { getFunctions, httpsCallable } from 'firebase/functions'
import { useFirebaseApp } from 'vuefire'

definePageMeta({ layout: 'default' })
const { t } = useI18n()
const toast = useToast()
const firebaseApp = useFirebaseApp()

useHead({
  title: `${t('pages.contact.title')} — DittoDatto`,
  meta: [{ name: 'description', content: t('pages.contact.subtitle') }]
})

const form = reactive({
  name: '',
  phone: '',
  message: ''
})
const loading = ref(false)

async function handleSubmit() {
  if (!form.name.trim() || !form.message.trim()) return

  loading.value = true

  try {
    const functions = getFunctions(firebaseApp, 'europe-west1')
    const submitFeedback = httpsCallable(functions, 'feedback_submit')

    await submitFeedback({
      senderName: form.name.trim(),
      senderEmail: '',
      source: 'public_contact',
      category: 'general',
      body: form.message.trim(),
      metadata: {
        phone: form.phone.trim() || undefined,
        url: window.location.href,
      },
    })

    toast.add({
      title: t('pages.contact.successTitle'),
      description: t('pages.contact.successDesc'),
      color: 'success'
    })

    form.name = ''
    form.phone = ''
    form.message = ''
  } catch (e: any) {
    console.error('[Contact] Submit failed:', e)
    toast.add({
      title: 'Sending failed',
      description: e?.message || 'Please try again later.',
      color: 'error'
    })
  } finally {
    loading.value = false
  }
}
</script>

<template>
  <div class="py-12 md:py-20">
    <UContainer class="max-w-lg">
      <div class="text-center mb-10">
        <h1 class="text-2xl md:text-3xl font-bold tracking-tight mb-2">
          {{ t("pages.contact.title") }}
        </h1>
        <p class="text-muted">
          {{ t("pages.contact.subtitle") }}
        </p>
      </div>

      <!-- Elevated card container -->
      <div class="rounded border border-default bg-elevated shadow-lg p-6 md:p-8">
        <form @submit.prevent="handleSubmit" class="space-y-5">
          <UFormField :label="t('pages.contact.nameLabel')" required>
            <UInput
              v-model="form.name"
              :placeholder="t('pages.contact.namePlaceholder')"
              icon="i-lucide-user"
              required
              size="lg"
            />
          </UFormField>

          <UFormField label="Phone">
            <UInput
              v-model="form.phone"
              type="tel"
              placeholder="92913093"
              icon="i-lucide-phone"
              size="lg"
            />
          </UFormField>

          <UFormField :label="t('pages.contact.messageLabel')" required>
            <UTextarea
              v-model="form.message"
              :placeholder="t('pages.contact.messagePlaceholder')"
              :rows="4"
              :cols="60"
              required
              size="lg"
              :maxlength="2000"
            />
            <p class="text-xs text-muted mt-1 text-right">
              {{ form.message.length }} / 2000
            </p>
          </UFormField>

          <UButton
            type="submit"
            color="primary"
            size="lg"
            :loading="loading"
            :disabled="!form.name.trim() || !form.message.trim()"
            block
            icon="i-lucide-send"
          >
            {{ t("pages.contact.send") }}
          </UButton>
        </form>
      </div>

      <!-- Location -->
      <p class="mt-6 text-center text-xs text-muted/60">
        Drammen, Norway
      </p>
    </UContainer>
  </div>
</template>
