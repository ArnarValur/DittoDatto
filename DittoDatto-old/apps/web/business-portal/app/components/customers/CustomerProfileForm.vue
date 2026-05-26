<script setup lang="ts">
import type { Customer } from '@dittodatto/shared-types'
import { z } from 'zod'

const props = defineProps<{
  customer?: Customer
}>()

const emit = defineEmits<{
  save: [data: Partial<Customer>]
  cancel: []
}>()

// We use the same schema we just created, but customized for the form
const formSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  email: z.string().email('Invalid email').optional().or(z.literal('')),
  phoneCountryCode: z.string().optional(),
  phone: z.string().optional(),
  notes: z.string().optional()
})

type FormState = z.infer<typeof formSchema>

const state = reactive<FormState>({
  name: props.customer?.name || '',
  email: props.customer?.email || '',
  phoneCountryCode: props.customer?.phoneCountryCode || '+47',
  phone: props.customer?.phone || '',
  notes: props.customer?.notes || ''
})

const countryCodes = [
  { label: '🇳🇴 +47', value: '+47' },
  { label: '🇵🇹 +351', value: '+351' },
  { label: '🇸🇪 +46', value: '+46' },
  { label: '🇩🇰 +45', value: '+45' },
  { label: '🇬🇧 +44', value: '+44' },
  { label: '🇺🇸 +1', value: '+1' },
]

async function onSubmit() {
  emit('save', {
    name: state.name,
    email: state.email,
    phoneCountryCode: state.phoneCountryCode,
    phone: state.phone,
    notes: state.notes
  })
}

// Reset form when customer prop changes
watch(() => props.customer, (c) => {
  if (c) {
    state.name = c.name || ''
    state.email = c.email || ''
    state.phoneCountryCode = c.phoneCountryCode || '+47'
    state.phone = c.phone || ''
    state.notes = c.notes || ''
  }
})
</script>

<template>
  <UForm
    :schema="formSchema"
    :state="state"
    @submit="onSubmit"
  >
    <div class="space-y-4">
      <!-- Name -->
      <UFormField label="NAME" name="name">
        <UInput
          v-model="state.name"
          placeholder="Maria Alberto"
          class="w-full"
        />
      </UFormField>

      <!-- Phone -->
      <UFormField label="PHONE NUMBER" name="phone">
        <div class="flex flex-col sm:flex-row gap-2">
          <USelectMenu
            v-model="state.phoneCountryCode"
            :items="countryCodes"
            value-attribute="value"
            option-attribute="label"
            class="sm:w-32"
          />
          <UInput
            v-model="state.phone"
            type="tel"
            placeholder="555 111 555"
            class="flex-1"
          />
        </div>
      </UFormField>



      <!-- Email -->
      <UFormField label="EMAIL ADDRESS" name="email">
        <UInput
          v-model="state.email"
          type="email"
          placeholder="maria@email.com"
          class="w-full"
        />
      </UFormField>

      <!-- Notes -->
      <div class="pt-4 border-t border-default mt-4">
        <label class="text-xs font-semibold text-muted uppercase tracking-wider mb-2 block">CLIENT NOTES</label>
        <UTextarea
          v-model="state.notes"
          placeholder="Andrea's sister & best client ever ❤️"
          :rows="4"
          variant="none"
          class="bg-elevated/50 p-2 rounded-lg resize-none min-h-24 hover:bg-elevated transition-colors w-full"
        />
      </div>

      <!-- Actions -->
      <div class="flex justify-end gap-2 pt-4">
        <UButton
          label="Cancel"
          color="neutral"
          variant="ghost"
          @click="emit('cancel')"
        />
        <UButton
          type="submit"
          label="Save Client"
          color="primary"
        />
      </div>
    </div>
  </UForm>
</template>
