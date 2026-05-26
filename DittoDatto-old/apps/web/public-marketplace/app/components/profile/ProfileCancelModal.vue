<script setup lang="ts">
const { t } = useI18n()

defineProps<{
  open: boolean
  cancelling: boolean
  canCancel?: boolean
  cancelBlockReason?: string
}>()

const emit = defineEmits<{
  'update:open': [value: boolean]
  confirm: []
}>()
</script>

<template>
  <UModal
    :open="open"
    :title="t('profile.cancelBooking')"
    :description="canCancel !== false ? t('profile.cancelConfirmDesc') : undefined"
    :ui="{ footer: 'justify-end' }"
    @update:open="emit('update:open', $event)"
  >
    <template #body>
      <!-- Policy block: cancel not allowed -->
      <div v-if="canCancel === false" class="flex items-center gap-3 p-3 rounded-lg bg-amber-50 dark:bg-amber-950/30">
        <UIcon name="i-lucide-clock" class="size-5 text-amber-500 shrink-0" />
        <p class="text-sm text-amber-700 dark:text-amber-400">
          {{ cancelBlockReason || t('profile.cancelDeadlinePassed') }}
        </p>
      </div>
      <!-- Normal warning -->
      <div v-else class="flex items-center gap-3 p-2 rounded-lg bg-red-50 dark:bg-red-950/30">
        <UIcon name="i-lucide-alert-triangle" class="size-5 text-red-500 shrink-0" />
        <p class="text-sm text-red-700 dark:text-red-400">
          {{ t('profile.cancelWarning') }}
        </p>
      </div>
    </template>
    <template #footer="{ close }">
      <template v-if="canCancel !== false">
        <UButton
          :label="t('profile.keepIt')"
          color="neutral"
          variant="outline"
          @click="close"
        />
        <UButton
          :label="t('profile.yesCancel')"
          color="error"
          :loading="cancelling"
          @click="emit('confirm')"
        />
      </template>
      <UButton
        v-else
        :label="t('common.close') || 'Lukk'"
        color="neutral"
        variant="outline"
        @click="close"
      />
    </template>
  </UModal>
</template>

