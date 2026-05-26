<script setup lang="ts">
/**
 * CustomersDeleteModal — confirmation dialog for batch-deleting customers.
 * Wraps its trigger slot and shows a confirm dialog on click.
 */
const props = defineProps<{
  count?: number
}>()

const emit = defineEmits<{
  confirm: []
}>()

const open = ref(false)

function handleConfirm() {
  emit('confirm')
  open.value = false
}
</script>

<template>
  <div>
    <!-- Trigger slot (e.g. delete button) -->
    <div @click="open = true">
      <slot />
    </div>

    <!-- Confirmation Dialog -->
    <UModal v-model:open="open">
      <template #content>
        <UCard>
          <template #header>
            <div class="flex items-center gap-2">
              <UIcon name="i-lucide-alert-triangle" class="size-5 text-error-500" />
              <h3 class="text-lg font-semibold">Delete customers</h3>
            </div>
          </template>

          <p class="text-muted">
            Are you sure you want to delete
            <span class="font-medium text-highlighted">{{ count ?? 0 }}</span>
            customer{{ (count ?? 0) === 1 ? '' : 's' }}? This action cannot be undone.
          </p>

          <template #footer>
            <div class="flex items-center justify-end gap-2">
              <UButton
                label="Cancel"
                color="neutral"
                variant="ghost"
                @click="open = false"
              />
              <UButton
                label="Delete"
                color="error"
                icon="i-lucide-trash"
                @click="handleConfirm"
              />
            </div>
          </template>
        </UCard>
      </template>
    </UModal>
  </div>
</template>
