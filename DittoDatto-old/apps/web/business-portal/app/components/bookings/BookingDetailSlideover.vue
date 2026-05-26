<script setup lang="ts">
/**
 * BookingDetailSlideover
 *
 * Interactive detail view for a booking in the business portal.
 * Supports status changes, staff assignment, and notes editing.
 * Actions are RBAC-gated via useStaffPermissions.
 */
import type { Booking } from "@dittodatto/shared-types";
import { format } from "date-fns";

const props = defineProps<{
  booking: Booking | null;
}>();

const emit = defineEmits<{
  "update:open": [value: boolean];
  "status-changed": [];
}>();

const open = defineModel<boolean>("open", { default: false });

const { isOwner, hasCapability } = useStaffPermissions();
const { updateBookingStatus, assignStaff, updateNotes } = useBookings();
const { allStaff } = useStaff();

const canManage = computed(
  () => isOwner.value || hasCapability("can_manage_bookings"),
);

// ---- Staff options for assignment ----
const bookableStaff = computed(() => {
  if (!props.booking) return [];
  return (allStaff.value ?? [])
    .filter(
      (s) =>
        s.status === "active" &&
        s.isBookable &&
        s.storeIds?.includes(props.booking!.storeId),
    )
    .map((s) => ({ label: s.displayName || s.email, value: s.id }));
});

const currentStaffName = computed(() => {
  const sid = props.booking?.staffId || props.booking?.personId;
  if (!sid) return null;
  const staff = (allStaff.value ?? []).find(
    (s) => s.id === sid,
  );
  return staff?.displayName || staff?.email || sid;
});

// ---- Notes editing ----
const editingNotes = ref(false);
const notesDraft = ref("");
const savingNotes = ref(false);

function startEditNotes() {
  notesDraft.value = props.booking?.notes || "";
  editingNotes.value = true;
}

async function saveNotes() {
  if (!props.booking) return;
  savingNotes.value = true;
  try {
    await updateNotes(props.booking.id, notesDraft.value);
    editingNotes.value = false;
  } finally {
    savingNotes.value = false;
  }
}

// ---- Status actions ----
const actionLoading = ref(false);
const showCancelConfirm = ref(false);
const cancelReason = ref("");

async function changeStatus(status: "confirmed" | "completed" | "no-show") {
  if (!props.booking) return;
  actionLoading.value = true;
  try {
    await updateBookingStatus(props.booking.id, status);
    emit("status-changed");
  } finally {
    actionLoading.value = false;
  }
}

async function confirmCancel() {
  if (!props.booking) return;
  actionLoading.value = true;
  try {
    await updateBookingStatus(
      props.booking.id,
      "cancelled",
      cancelReason.value || undefined,
    );
    showCancelConfirm.value = false;
    cancelReason.value = "";
    emit("status-changed");
  } finally {
    actionLoading.value = false;
  }
}

// ---- Staff assignment ----
const assigningStaff = ref(false);

async function handleAssignStaff(staffId: string | null) {
  if (!props.booking) return;
  assigningStaff.value = true;
  try {
    await assignStaff(props.booking.id, staffId);
  } finally {
    assigningStaff.value = false;
  }
}

// ---- Formatters ----
const statusColors: Record<
  string,
  "error" | "primary" | "secondary" | "success" | "info" | "warning" | "neutral"
> = {
  confirmed: "success",
  completed: "primary",
  pending: "warning",
  cancelled: "error",
  "no-show": "error",
};

function formatDateTime(date: string | Date | any) {
  if (!date) return "—";
  let d: Date;
  if (typeof date === "string") d = new Date(date);
  else if (date?.toDate)
    d = date.toDate(); // Firestore Timestamp
  else if (date instanceof Date) d = date;
  else d = new Date(date);
  return format(d, "EEE, dd MMM yyyy 'at' HH:mm");
}

function formatPrice(price: number, currency: string) {
  return new Intl.NumberFormat("nb-NO", {
    style: "currency",
    currency: currency || "NOK",
  }).format(price);
}

function copyToClipboard(text: string, label: string) {
  navigator.clipboard.writeText(text);
  useToast().add({
    title: "Copied",
    description: `${label} copied to clipboard`,
  });
}

// Reset state when slideover closes
watch(open, (val) => {
  if (!val) {
    editingNotes.value = false;
    showCancelConfirm.value = false;
    cancelReason.value = "";
  }
});
</script>

<template>
  <USlideover
    v-model:open="open"
    :title="booking?.serviceTitle || 'Booking Details'"
  >
    <template #body>
      <div v-if="booking" class="space-y-6 p-1">
        <!-- Status Banner -->
        <div class="flex items-center justify-between">
          <h3 class="text-lg font-semibold">
            {{ booking.serviceTitle }}
          </h3>
          <UBadge
            :color="statusColors[booking.status] || 'neutral'"
            variant="subtle"
            class="capitalize text-sm"
          >
            {{ booking.status }}
          </UBadge>
        </div>

        <!-- Customer Info -->
        <div class="space-y-2">
          <h4 class="text-xs font-semibold text-muted uppercase tracking-wider">
            Customer
          </h4>
          <div class="bg-elevated rounded-lg p-3 space-y-2">
            <div class="flex items-center justify-between">
              <div class="flex items-center gap-2">
                <UIcon name="i-lucide-user" class="size-4 text-muted" />
                <span class="font-medium">{{ booking.userName }}</span>
              </div>
              <UButton
                icon="i-lucide-copy"
                size="xs"
                color="neutral"
                variant="ghost"
                @click="copyToClipboard(booking.userName, 'Name')"
              />
            </div>
            <div class="flex items-center justify-between">
              <div class="flex items-center gap-2">
                <UIcon name="i-lucide-mail" class="size-4 text-muted" />
                <span class="text-sm text-muted">{{ booking.userEmail }}</span>
              </div>
              <UButton
                icon="i-lucide-copy"
                size="xs"
                color="neutral"
                variant="ghost"
                @click="copyToClipboard(booking.userEmail, 'Email')"
              />
            </div>
            <div
              v-if="booking.userPhone"
              class="flex items-center justify-between"
            >
              <div class="flex items-center gap-2">
                <UIcon name="i-lucide-phone" class="size-4 text-muted" />
                <span class="text-sm text-muted">{{ booking.userPhone }}</span>
              </div>
              <UButton
                icon="i-lucide-copy"
                size="xs"
                color="neutral"
                variant="ghost"
                @click="copyToClipboard(booking.userPhone!, 'Phone')"
              />
            </div>
          </div>
        </div>

        <!-- Schedule -->
        <div class="space-y-2">
          <h4 class="text-xs font-semibold text-muted uppercase tracking-wider">
            Schedule
          </h4>
          <div class="bg-elevated rounded-lg p-3 space-y-1">
            <div class="flex justify-between">
              <span class="text-muted">Start</span>
              <span class="font-medium">{{
                formatDateTime(booking.startTime)
              }}</span>
            </div>
            <div class="flex justify-between">
              <span class="text-muted">End</span>
              <span>{{ formatDateTime(booking.endTime) }}</span>
            </div>
            <div class="flex justify-between">
              <span class="text-muted">Duration</span>
              <span>{{ booking.duration }} min</span>
            </div>
          </div>
        </div>

        <!-- Payment -->
        <div class="space-y-2">
          <h4 class="text-xs font-semibold text-muted uppercase tracking-wider">
            Payment
          </h4>
          <div class="bg-elevated rounded-lg p-3 space-y-1">
            <div class="flex justify-between">
              <span class="text-muted">Price</span>
              <span class="font-medium">{{
                formatPrice(booking.priceAtTimeOfBooking, booking.currency)
              }}</span>
            </div>
            <div
              v-if="booking.paymentId"
              class="flex justify-between items-center"
            >
              <span class="text-muted">Payment ID</span>
              <div class="flex items-center gap-1">
                <span class="text-xs font-mono text-muted">{{
                  booking.paymentId
                }}</span>
                <UButton
                  icon="i-lucide-copy"
                  size="xs"
                  color="neutral"
                  variant="ghost"
                  @click="copyToClipboard(booking.paymentId!, 'Payment ID')"
                />
              </div>
            </div>
          </div>
        </div>

        <!-- Staff Assignment -->
        <div class="space-y-2">
          <h4 class="text-xs font-semibold text-muted uppercase tracking-wider">
            Staff Assignment
          </h4>
          <div class="bg-elevated rounded-lg p-3">
            <div
              v-if="currentStaffName && !canManage"
              class="flex items-center gap-2"
            >
              <UIcon name="i-lucide-user-check" class="size-4 text-success" />
              <span>{{ currentStaffName }}</span>
            </div>
            <div v-else-if="canManage">
              <USelectMenu
                :model-value="booking.staffId || booking.personId || undefined"
                :items="bookableStaff"
                placeholder="Assign staff member..."
                value-attribute="value"
                option-attribute="label"
                :loading="assigningStaff"
                @update:model-value="
                  (val: any) => handleAssignStaff(val || null)
                "
              />
              <p v-if="!bookableStaff.length" class="text-xs text-muted mt-1">
                No bookable staff assigned to this store.
              </p>
            </div>
            <div v-else class="text-sm text-muted">No staff assigned</div>
          </div>
        </div>

        <!-- Notes -->
        <div class="space-y-2">
          <div class="flex items-center justify-between">
            <h4
              class="text-xs font-semibold text-muted uppercase tracking-wider"
            >
              Notes
            </h4>
            <UButton
              v-if="canManage && !editingNotes"
              :icon="booking.notes ? 'i-lucide-pencil' : 'i-lucide-plus'"
              size="xs"
              color="neutral"
              variant="ghost"
              :label="booking.notes ? 'Edit' : 'Add'"
              @click="startEditNotes"
            />
          </div>
          <div class="bg-elevated rounded-lg p-3">
            <template v-if="editingNotes">
              <UTextarea
                v-model="notesDraft"
                placeholder="Add notes about this booking..."
                :rows="3"
                autofocus
              />
              <div class="flex justify-end gap-2 mt-2">
                <UButton
                  label="Cancel"
                  size="xs"
                  color="neutral"
                  variant="ghost"
                  @click="editingNotes = false"
                />
                <UButton
                  label="Save"
                  size="xs"
                  color="primary"
                  :loading="savingNotes"
                  @click="saveNotes"
                />
              </div>
            </template>
            <p v-else-if="booking.notes" class="text-sm">
              {{ booking.notes }}
            </p>
            <p v-else class="text-sm text-muted italic">No notes yet.</p>
          </div>
        </div>

        <!-- Service Items -->
        <div v-if="booking.items?.length" class="space-y-2">
          <h4 class="text-xs font-semibold text-muted uppercase tracking-wider">
            Service Items
          </h4>
          <div class="space-y-2">
            <div
              v-for="(item, i) in booking.items"
              :key="i"
              class="bg-elevated rounded-lg p-3 flex justify-between items-center"
            >
              <div>
                <span class="font-medium">{{ item.title }}</span>
                <span class="text-sm text-muted ml-2"
                  >{{ item.duration }} min</span
                >
              </div>
              <span class="text-sm">{{
                formatPrice(item.price, booking.currency)
              }}</span>
            </div>
          </div>
        </div>

        <!-- Metadata -->
        <div class="space-y-2">
          <h4 class="text-xs font-semibold text-muted uppercase tracking-wider">
            Details
          </h4>
          <div class="bg-elevated rounded-lg p-3 space-y-1 text-sm">
            <div class="flex justify-between items-center">
              <span class="text-muted">Booking ID</span>
              <div class="flex items-center gap-1">
                <span class="text-xs font-mono text-muted">{{
                  booking.id
                }}</span>
                <UButton
                  icon="i-lucide-copy"
                  size="xs"
                  color="neutral"
                  variant="ghost"
                  @click="copyToClipboard(booking.id, 'Booking ID')"
                />
              </div>
            </div>
            <div class="flex justify-between">
              <span class="text-muted">Channel</span>
              <UBadge color="neutral" variant="subtle" size="sm">{{
                booking.channel
              }}</UBadge>
            </div>
            <div v-if="booking.attendeeCount > 1" class="flex justify-between">
              <span class="text-muted">Attendees</span>
              <span>{{ booking.attendeeCount }}</span>
            </div>
            <div class="flex justify-between">
              <span class="text-muted">Created</span>
              <span>{{ formatDateTime(booking.createdAt) }}</span>
            </div>
            <div v-if="booking.updatedAt" class="flex justify-between">
              <span class="text-muted">Updated</span>
              <span>{{ formatDateTime(booking.updatedAt) }}</span>
            </div>
            <div v-if="booking.cancellationReason" class="flex justify-between">
              <span class="text-muted">Cancel Reason</span>
              <span class="text-error">{{ booking.cancellationReason }}</span>
            </div>
          </div>
        </div>
      </div>
    </template>

    <!-- Footer with actions -->
    <template v-if="canManage && booking" #footer>
      <div class="p-4">
        <!-- Cancel confirmation -->
        <div v-if="showCancelConfirm" class="space-y-3">
          <p class="text-sm font-medium text-warning">Cancel this booking?</p>
          <UTextarea
            v-model="cancelReason"
            placeholder="Reason for cancellation (optional)"
            :rows="2"
          />
          <div class="flex justify-end gap-2">
            <UButton
              label="Back"
              color="neutral"
              variant="ghost"
              size="sm"
              @click="showCancelConfirm = false"
            />
            <UButton
              label="Confirm Cancel"
              color="error"
              size="sm"
              :loading="actionLoading"
              @click="confirmCancel"
            />
          </div>
        </div>

        <!-- Normal action buttons -->
        <div v-else class="flex flex-wrap gap-2">
          <UButton
            v-if="booking.status === 'pending'"
            label="Confirm"
            icon="i-lucide-check"
            color="success"
            size="sm"
            :loading="actionLoading"
            @click="changeStatus('confirmed')"
          />
          <UButton
            v-if="booking.status === 'confirmed'"
            label="Complete"
            icon="i-lucide-check-circle"
            color="primary"
            size="sm"
            :loading="actionLoading"
            @click="changeStatus('completed')"
          />
          <UButton
            v-if="booking.status === 'confirmed' || booking.status === 'pending'"
            label="No-Show"
            icon="i-lucide-user-x"
            color="warning"
            variant="soft"
            size="sm"
            :loading="actionLoading"
            @click="changeStatus('no-show')"
          />
          <UButton
            v-if="
              booking.status === 'pending' || booking.status === 'confirmed'
            "
            label="Cancel"
            icon="i-lucide-x"
            color="error"
            variant="soft"
            size="sm"
            @click="showCancelConfirm = true"
          />
        </div>
      </div>
    </template>
  </USlideover>
</template>
