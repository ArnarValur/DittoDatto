<script setup lang="ts">
import { z } from 'zod'
import type { FormSubmitEvent } from '#ui/types'
import type { ResourceGroup } from '@dittodatto/shared-types'
import { getFunctions, httpsCallable } from 'firebase/functions'
import { getApp } from 'firebase/app'

/**
 * ResourceGroupFormSlideover
 *
 * Create/Edit resource groups (areas) for a store.
 * Examples: "Main Dining", "Outside Terrace", "Massage Rooms"
 */

const props = defineProps<{
  group?: Partial<ResourceGroup> & { id?: string }
  storeId: string
  companyId: string
  open?: boolean
}>()

const emit = defineEmits<{
  (e: 'close'): void
  (e: 'update:open', value: boolean): void
  (e: 'saved'): void
  (e: 'deleted'): void
}>()

const functions = getFunctions(getApp(), 'europe-west1')
const toast = useToast()
const loading = ref(false)
const deleting = ref(false)
const showDeleteConfirm = ref(false)
const form = ref()

const isEditMode = computed(() => !!props.group?.id)

const state = reactive({
  name: '',
  description: '',
  sortOrder: 0,
  showOnStorefront: false
})

watch(() => props.group, (g) => {
  if (g) {
    state.name = g.name || ''
    state.description = g.description || ''
    state.sortOrder = g.sortOrder ?? 0
    state.showOnStorefront = g.showOnStorefront ?? false
  } else {
    Object.assign(state, { name: '', description: '', sortOrder: 0, showOnStorefront: false })
  }
}, { immediate: true })

const FormSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  description: z.string().optional(),
  sortOrder: z.number().int().default(0),
  showOnStorefront: z.boolean().default(false)
})

type FormData = z.infer<typeof FormSchema>

async function onSubmit(event: FormSubmitEvent<FormData>) {
  if (!props.storeId || !props.companyId) return

  loading.value = true
  try {
    const payload = Object.fromEntries(
      Object.entries(event.data).filter(([_, v]) => v !== undefined && v !== '')
    )

    if (isEditMode.value) {
      const updateFn = httpsCallable(functions, 'resourceGroups_update')
      await updateFn({
        groupId: props.group!.id,
        storeId: props.storeId,
        companyId: props.companyId,
        ...payload
      })
      toast.add({ title: 'Resource group updated', color: 'success' })
    } else {
      const createFn = httpsCallable(functions, 'resourceGroups_create')
      await createFn({
        storeId: props.storeId,
        companyId: props.companyId,
        ...payload
      })
      toast.add({ title: 'Resource group created', color: 'success' })
    }

    emit('saved')
    handleClose()
  } catch (err: unknown) {
    console.error(err)
    toast.add({ title: 'Error', description: (err as Error).message, color: 'error' })
  } finally {
    loading.value = false
  }
}

async function handleDelete() {
  if (!props.group?.id || !props.storeId || !props.companyId) return

  deleting.value = true
  try {
    const deleteFn = httpsCallable(functions, 'resourceGroups_delete')
    await deleteFn({
      groupId: props.group.id,
      storeId: props.storeId,
      companyId: props.companyId
    })
    toast.add({ title: 'Resource group deleted', color: 'success' })
    emit('deleted')
    handleClose()
  } catch (err: unknown) {
    console.error(err)
    const message = (err as Error)?.message || 'Failed to delete group'
    if (message.includes('linked resources')) {
      toast.add({
        title: 'Cannot delete',
        description: 'Remove all resources from this group first',
        color: 'warning'
      })
    } else {
      toast.add({ title: 'Error', description: message, color: 'error' })
    }
  } finally {
    deleting.value = false
    showDeleteConfirm.value = false
  }
}

function handleClose() {
  emit('update:open', false)
  emit('close')
}
</script>

<template>
  <USlideover
    :open="open ?? true"
    :dismissible="false"
    :title="isEditMode ? 'Edit Resource Group' : 'Create Resource Group'"
    @update:open="(val) => emit('update:open', val)"
  >
    <template #body>
      <UForm
        ref="form"
        :schema="FormSchema"
        :state="state"
        class="space-y-4 p-4"
        @submit="onSubmit"
      >
        <UFormField label="Group Name" name="name" required>
          <UInput v-model="state.name" placeholder="e.g. Main Dining, Outside Terrace, VIP Area" />
        </UFormField>

        <UFormField label="Description" name="description">
          <UTextarea v-model="state.description" placeholder="Optional description..." />
        </UFormField>

        <UFormField label="Sort Order" name="sortOrder" help="Lower numbers appear first">
          <UInput v-model.number="state.sortOrder" type="number" min="0" />
        </UFormField>

        <USeparator label="Visibility" />

        <UFormField name="showOnStorefront">
          <div class="flex items-center justify-between">
            <div>
              <p class="text-sm font-medium">Show on Store Page</p>
              <p class="text-xs text-muted">Let customers browse individual resources (e.g. halls, studios)</p>
            </div>
            <USwitch v-model="state.showOnStorefront" />
          </div>
        </UFormField>
      </UForm>
    </template>

    <template #footer>
      <div class="flex items-center justify-between p-4">
        <div>
          <UButton
            v-if="isEditMode && !showDeleteConfirm"
            label="Delete"
            color="error"
            variant="ghost"
            icon="i-lucide-trash-2"
            @click="showDeleteConfirm = true"
          />
          <div v-if="showDeleteConfirm" class="flex items-center gap-2">
            <span class="text-sm text-error">Delete this group?</span>
            <UButton
              label="Yes"
              color="error"
              size="xs"
              :loading="deleting"
              @click="handleDelete"
            />
            <UButton
              label="No"
              color="neutral"
              variant="ghost"
              size="xs"
              @click="showDeleteConfirm = false"
            />
          </div>
        </div>

        <div class="flex gap-2">
          <UButton
            label="Cancel"
            color="neutral"
            variant="ghost"
            @click="handleClose"
          />
          <UButton
            :label="isEditMode ? 'Update' : 'Create'"
            color="primary"
            :loading="loading"
            @click="() => form?.submit()"
          />
        </div>
      </div>
    </template>
  </USlideover>
</template>
