<script setup lang="ts">
import type { Reservation } from '@dittodatto/shared-types';

const props = defineProps<{
  open: boolean;
  reservation: Reservation | null;
  resources: Array<{ id: string; name: string; capacity?: { min: number; max: number } }>;
}>();

const emit = defineEmits<{
  'update:open': [value: boolean];
}>();

const { updateReservation, cancelReservation } = useReservations();
const toast = useToast();

const isOpen = computed({
  get: () => props.open,
  set: (val) => emit('update:open', val),
});

const isWorking = ref(false);
const isCancelling = ref(false);
const showCancelConfirm = ref(false);
const selectedTableId = ref<string>('');
const notes = ref<string>('');

// Reset local state when the reservation changes
watch(
  () => props.reservation,
  (res) => {
    if (res) {
      selectedTableId.value = res.tableId || '';
      notes.value = res.internalNotes || '';
    }
  },
  { immediate: true }
);

const tableOptions = computed(() => {
  return [
    { label: 'Ikke tildelt (Unassigned)', value: '' },
    ...props.resources
      .filter((r) => r.id !== '__unassigned__')
      .map((r) => ({
        label: `${r.name} ${r.capacity ? `(🪑 ${r.capacity.max})` : ''}`,
        value: r.id,
      })),
  ];
});

async function saveChanges() {
  if (!props.reservation) return;
  isWorking.value = true;

  const { deleteField } = await import('firebase/firestore');
  
  const updates: Record<string, any> = {
    internalNotes: notes.value,
    ...(selectedTableId.value
      ? { tableId: selectedTableId.value }
      : { tableId: deleteField() }),
  };

  const success = await updateReservation(props.reservation.id, updates);
  isWorking.value = false;

  if (success) {
    toast.add({
      title: 'Endringer lagret',
      description: 'Reservasjonen har blitt oppdatert.',
      color: 'success',
      icon: 'i-lucide-check-circle',
    });
    isOpen.value = false;
  } else {
    toast.add({
      title: 'Feil oppstod',
      description: 'Kunne ikke lagre endringene. Prøv igjen.',
      color: 'error',
      icon: 'i-lucide-x-circle',
    });
  }
}

async function handleCancel() {
  if (!props.reservation) return;
  isCancelling.value = true;

  const success = await cancelReservation(props.reservation.id);
  isCancelling.value = false;
  showCancelConfirm.value = false;

  if (success) {
    toast.add({
      title: 'Reservasjon kansellert',
      description: `Reservasjonen for ${props.reservation.customerName} er kansellert.`,
      color: 'success',
      icon: 'i-lucide-check-circle',
    });
    isOpen.value = false;
  } else {
    toast.add({
      title: 'Feil oppstod',
      description: 'Kunne ikke kansellere reservasjonen. Prøv igjen.',
      color: 'error',
      icon: 'i-lucide-x-circle',
    });
  }
}
</script>

<template>
  <USlideover v-model:open="isOpen" :ui="{ width: 'max-w-md' }">
    <template #content>
      <div v-if="reservation" class="flex flex-col h-full">
        <!-- Header -->
        <div class="p-6 border-b border-default flex items-center justify-between">
          <h3 class="text-xl font-semibold">{{ reservation.customerName }}</h3>
          <div class="flex items-center gap-2">
            <UBadge
              :color="reservation.status === 'confirmed' ? 'success' : reservation.status === 'pending' ? 'warning' : 'neutral'"
              :label="reservation.status"
              class="uppercase"
            />
            <UButton
              icon="i-lucide-x"
              color="neutral"
              variant="ghost"
              size="sm"
              @click="isOpen = false"
            />
          </div>
        </div>

        <!-- Body -->
        <div class="flex-1 overflow-y-auto p-6 space-y-8">
          
          <!-- Key Info Grid -->
          <div class="grid grid-cols-2 gap-4 bg-muted/30 p-4 rounded-xl border border-default/50">
            <div>
              <div class="text-xs text-muted font-medium mb-1">Gjester</div>
              <div class="flex items-center gap-1.5 font-medium">
                <UIcon name="i-lucide-users" class="size-4 text-primary" />
                {{ reservation.guestCount }}
              </div>
            </div>
            <div>
              <div class="text-xs text-muted font-medium mb-1">Tidspunkt</div>
              <div class="flex items-center gap-1.5 font-medium">
                <UIcon name="i-lucide-clock" class="size-4 text-primary" />
                {{ reservation.time }} ({{ reservation.duration }} min)
              </div>
            </div>
            <div class="col-span-2 pt-2 border-t border-default/50">
              <div class="text-xs text-muted font-medium mb-1">Kontakt</div>
              <div class="flex items-center gap-4">
                <span class="flex items-center gap-1.5 text-sm">
                  <UIcon name="i-lucide-phone" class="size-3.5 text-muted" />
                  {{ reservation.customerPhone }}
                </span>
                <span v-if="reservation.customerEmail" class="flex items-center gap-1.5 text-sm">
                  <UIcon name="i-lucide-mail" class="size-3.5 text-muted" />
                  {{ reservation.customerEmail }}
                </span>
              </div>
            </div>
          </div>

          <USeparator />

          <!-- Table Assignment (Tildel bord) -->
          <UFormField label="Tildel bord (Ressurs)" name="tableId" description="Velg hvilket bord gjestene skal sitte ved.">
            <USelect
              v-model="selectedTableId"
              :items="tableOptions"
              value-key="value"
              label-key="label"
              placeholder="Velg et bord..."
              class="w-full"
            />
          </UFormField>

          <!-- Notes -->
          <div class="space-y-4">
            <UFormField v-if="reservation.notes" label="Gjestens notat">
              <div class="p-3 bg-muted/20 border border-default rounded-md text-sm italic">
                "{{ reservation.notes }}"
              </div>
            </UFormField>

            <UFormField label="Internt notat" name="internalNotes" description="Kun synlig for ansatte.">
              <UTextarea
                v-model="notes"
                placeholder="Skriv inn notater, preferanser eller advarsler her..."
                :rows="4"
              />
            </UFormField>
          </div>

        </div>

        <!-- Footer -->
        <div class="p-4 border-t border-default flex items-center bg-muted/10">
          <UButton
            label="Kanseller"
            color="error"
            variant="ghost"
            icon="i-lucide-ban"
            @click="showCancelConfirm = true"
            :disabled="isWorking"
          />
          <div class="flex-1" />
          <div class="flex gap-3">
            <UButton
              label="Avbryt"
              color="neutral"
              variant="ghost"
              @click="isOpen = false"
              :disabled="isWorking"
            />
            <UButton
              label="Lagre endringer"
              color="primary"
              icon="i-lucide-save"
              :loading="isWorking"
              @click="saveChanges"
            />
          </div>
        </div>
      </div>
    </template>
  </USlideover>

  <!-- Cancel Confirmation Modal -->
  <UModal v-model:open="showCancelConfirm">
    <template #content>
      <div class="p-6 space-y-4">
        <div class="flex items-center gap-3">
          <div class="flex items-center justify-center w-10 h-10 rounded-full bg-error/10">
            <UIcon name="i-lucide-alert-triangle" class="size-5 text-error" />
          </div>
          <div>
            <h3 class="text-lg font-semibold">Kanseller reservasjon?</h3>
            <p class="text-sm text-muted">
              Reservasjonen for <strong>{{ reservation?.customerName }}</strong> 
              kl. <strong>{{ reservation?.time }}</strong> vil bli kansellert.
            </p>
          </div>
        </div>
        <div class="flex justify-end gap-3 pt-2">
          <UButton
            label="Nei, behold"
            color="neutral"
            variant="ghost"
            @click="showCancelConfirm = false"
            :disabled="isCancelling"
          />
          <UButton
            label="Ja, kanseller"
            color="error"
            icon="i-lucide-ban"
            :loading="isCancelling"
            @click="handleCancel"
          />
        </div>
      </div>
    </template>
  </UModal>
</template>
