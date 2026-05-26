<script setup lang="ts">
/**
 * Establishment Page - Public Marketplace
 *
 * URL Pattern: /{category}/{slug}
 * Examples:
 *   - /barber/nordic-cuts
 *   - /restaurant/fjord-bistro
 *   - /discover/mystery-shop (fallback for uncategorized)
 *
 * This page uses the shared DDEstablishmentPage component.
 */
import {
  collection,
  collectionGroup,
  query,
  where,
  getDocs,
  orderBy,
} from "firebase/firestore";
import { type BookingDetails } from "@dittodatto/ui/components/booking/BookingConfirmation.vue";
import { useBookingState, type BookingFetchAdapter } from "@dittodatto/ui/composables/useBookingState";
import type {
  Store,
  Service,
  ServiceGroup,
  Event as DDEvent,
  StaffMember,
} from "@dittodatto/shared-types";

definePageMeta({
  layout: "default",
});

const route = useRoute();
const db = useFirestore();
const localePath = useLocalePath();
const { t, locale } = useI18n();
const user = useCurrentUser();
const toast = useToast();

// Favorites
const { favorites, addFavorite, removeFavorite, fetchFavorites } =
  useFavorites();

// Booking integration via useBookingState composable
// Adapter bridges the shared composable to MercuryEngine REST API
const { fetchFromMercury } = useMercuryREST()

const bookingAdapter: BookingFetchAdapter = {
  fetchSlots: (opts) => fetchFromMercury('/appointments/slots', { method: 'GET', query: opts }),
  fetchReservationSlots: (opts) => fetchFromMercury('/reservations/availability', { method: 'GET', query: opts }),
  createHold: (opts) => fetchFromMercury('/appointments/holds', { method: 'POST', body: opts }),
  confirmBooking: (opts) => fetchFromMercury('/appointments/bookings', {
    method: 'POST',
    body: { ...opts, paymentId: `mock_${Date.now()}` },
  }),
  createReservation: (opts) => fetchFromMercury('/reservations', { method: 'POST', body: opts }),
}

const booking = useBookingState(bookingAdapter)

// Route params
const categorySlug = computed(() => route.params.category as string);
const storeSlug = computed(() => route.params.slug as string);

// State
const store = ref<Store | null>(null);
const services = ref<Service[]>([]);
const serviceGroups = ref<ServiceGroup[]>([]);
const events = ref<DDEvent[]>([]);
const staff = ref<StaffMember[]>([]);
const loading = ref(true);
const servicesLoading = ref(false);
const eventsLoading = ref(false);
const staffLoading = ref(false);
const error = ref<string | null>(null);

// Check if current store is favorited
const isFavorited = computed(() => {
  if (!store.value?.id) return false;
  return favorites.value.some((f) => f.id === store.value!.id);
});

// Fetch favorites when user is logged in
watch(
  user,
  (newUser) => {
    if (newUser) {
      fetchFavorites("store");
    }
  },
  { immediate: true },
);

/**
 * Calculate booking end time based on start and duration.
 */
function calculateEndTime(
  date: Date,
  startTime: string,
  duration: number,
): string {
  const [hours = 0, minutes = 0] = startTime.split(":").map(Number);
  const startDate = new Date(date);
  startDate.setHours(hours, minutes, 0, 0);
  const endDate = new Date(startDate.getTime() + duration * 60000);
  return endDate.toISOString();
}

// ============================================================================
// Data Fetching
// ============================================================================

/**
 * Fetch store by slug.
 *
 * Stores are nested: companies/{companyId}/stores/{storeId}
 * We use collectionGroup to query across all 'stores' subcollections.
 *
 * The category in URL is for SEO/UX, not for filtering - slug should be unique.
 */
async function fetchStore() {
  loading.value = true;
  error.value = null;

  try {
    // Query stores across all companies using collectionGroup
    const storesQuery = query(
      collectionGroup(db, "stores"),
      where("slug", "==", storeSlug.value),
    );

    const snapshot = await getDocs(storesQuery);

    if (snapshot.empty) {
      store.value = null;
      error.value = "not_found";
      return;
    }

    const doc = snapshot.docs[0];
    if (!doc) {
      store.value = null;
      error.value = "not_found";
      return;
    }
    const storeData = { id: doc.id, ...doc.data() } as Store;

    // Ensure companyId is set — extract from document path as fallback
    // Path: companies/{companyId}/stores/{storeId}
    if (!storeData.companyId) {
      const pathCompanyId = doc.ref.parent.parent?.id;
      if (pathCompanyId) {
        storeData.companyId = pathCompanyId;
      }
    }

    // Redirect to home if store is not published
    if (storeData.isPublished !== true) {
      await navigateTo("/");
      return;
    }

    store.value = storeData;

    // Set booking composable context
    if (storeData.companyId) {
      booking.setStoreContext({ companyId: storeData.companyId, storeId: storeData.id });
    }

    // Fetch services, service groups, events, and staff in parallel
    await Promise.all([fetchServices(), fetchServiceGroups(), fetchEvents(), fetchStaff()]);
  } catch (e) {
    console.error("[EstablishmentPage] Error fetching store:", e);
    error.value = "fetch_error";
    store.value = null;
  } finally {
    loading.value = false;
  }
}

/**
 * Fetch services for the current store
 */
async function fetchServices() {
  if (!store.value?.id || !store.value?.companyId) {
    services.value = [];
    return;
  }

  servicesLoading.value = true;
  try {
    const servicesRef = collection(
      db,
      "companies",
      store.value.companyId,
      "stores",
      store.value.id,
      "services",
    );
    const snapshot = await getDocs(servicesRef);
    services.value = snapshot.docs.map(
      (doc) =>
        ({
          id: doc.id,
          ...doc.data(),
        }) as Service,
    );
  } catch (e) {
    console.error("[EstablishmentPage] Error fetching services:", e);
    services.value = [];
  } finally {
    servicesLoading.value = false;
  }
}

/**
 * Fetch service groups for the current store
 */
async function fetchServiceGroups() {
  if (!store.value?.id || !store.value?.companyId) {
    serviceGroups.value = [];
    return;
  }

  try {
    const groupsRef = collection(
      db,
      "companies",
      store.value.companyId,
      "stores",
      store.value.id,
      "serviceGroups",
    );
    const snapshot = await getDocs(groupsRef);
    serviceGroups.value = snapshot.docs.map(
      (doc) =>
        ({
          id: doc.id,
          ...doc.data(),
        }) as ServiceGroup,
    );
  } catch (e) {
    console.error("[EstablishmentPage] Error fetching service groups:", e);
    serviceGroups.value = [];
  }
}

/**
 * Fetch published events for the current store
 */
async function fetchEvents() {
  if (!store.value?.id) {
    events.value = [];
    return;
  }

  eventsLoading.value = true;
  try {
    const eventsRef = collection(db, "events");
    const eventsQuery = query(
      eventsRef,
      where("storeId", "==", store.value.id),
      where("status", "==", "published"),
      orderBy("startDateTime", "asc"),
    );
    const snapshot = await getDocs(eventsQuery);
    events.value = snapshot.docs.map(
      (doc) =>
        ({
          id: doc.id,
          ...doc.data(),
        }) as DDEvent,
    );
  } catch (e: unknown) {
    const err = e as { code?: string };
    console.error("[EstablishmentPage] Error fetching events:", err);
    if (err.code === "failed-precondition") {
      console.error("[EstablishmentPage] Firestore index required");
    }
    events.value = [];
  } finally {
    eventsLoading.value = false;
  }
}

/**
 * Fetch bookable staff visible on storefront for the current store.
 */
async function fetchStaff() {
  if (!store.value?.id || !store.value?.companyId) {
    staff.value = [];
    return;
  }

  staffLoading.value = true;
  try {
    const staffRef = collection(
      db,
      "companies",
      store.value.companyId,
      "staff",
    );
    const staffQuery = query(
      staffRef,
      where("isBookable", "==", true),
      where("showOnStorefront", "==", true),
      where("status", "==", "active"),
    );
    const snapshot = await getDocs(staffQuery);
    // Filter client-side to only staff assigned to this store
    staff.value = snapshot.docs
      .map((doc) => ({ id: doc.id, ...doc.data() }) as StaffMember)
      .filter((s) => s.storeIds?.includes(store.value!.id));
  } catch (e) {
    console.error("[EstablishmentPage] Error fetching staff:", e);
    staff.value = [];
  } finally {
    staffLoading.value = false;
  }
}

// ============================================================================
// Booking Helpers
// ============================================================================

/**
 * Format date for display (e.g., "Monday, Jan 15")
 */
function formatDateForDisplay(date: Date): string {
  return new Intl.DateTimeFormat(locale.value, {
    weekday: "long",
    month: "short",
    day: "numeric",
  }).format(date);
}

// ============================================================================
// Event Handlers — thin wrappers delegating to booking composable
// ============================================================================

function handleBook() {
  booking.open();
}

function handleBookWithStaff(staffMember: StaffMember) {
  booking.open({ staff: staffMember });
}

function handleBookService(_service: Service) {
  // Open slideover at service list
  booking.open();
}

function handleBookGroup(groupId: string) {
  const group = serviceGroups.value.find(g => g.id === groupId);
  booking.open({ groupName: group?.name });
}

/**
 * Handle booking confirmation
 */
async function handleBookingConfirm(bookingData: {
  date: Date;
  time: string;
  service: Service;
  guestCount?: number;
  notes?: string;
}) {
  if (!store.value?.id || !store.value?.companyId || !user.value) {
    toast.add({
      title: t("common.error"),
      description: "Missing required information",
      color: "error",
    });
    return;
  }

  booking.confirming.value = true;

  try {
    const isReservation = bookingData.service.bookingMode === 'tableReservation';

    if (isReservation) {
      console.log("[EstablishmentPage] Creating reservation for:", bookingData.time);

      const reservation = await booking.adapter.createReservation({
        companyId: store.value.companyId,
        storeId: store.value.id,
        date: booking.formatDateForAPI(bookingData.date),
        time: bookingData.time,
        partySize: bookingData.guestCount || 2,
        serviceId: bookingData.service.id,
        customerName: user.value.displayName || "Guest",
        customerEmail: user.value.email || "",
        customerPhone: user.value.phoneNumber || "Ikke oppgitt",
        notes: bookingData.notes
      });

      if (reservation.success) {
        booking.clearBookingState();

        const [hours = 0, minutes = 0] = bookingData.time.split(":").map(Number);
        const startDate = new Date(bookingData.date);
        startDate.setHours(hours, minutes, 0, 0);

        const startTime = startDate.toISOString();
        const endTime = calculateEndTime(
          bookingData.date,
          bookingData.time,
          bookingData.service.duration || 60,
        );

        booking.confirmedBooking.value = {
          id: reservation.reservationId,
          serviceTitle: bookingData.service.title,
          storeName: store.value?.name || "",
          storeAddress: store.value
            ? `${store.value.address}, ${store.value.city}`
            : "",
          startTime,
          endTime,
          price: bookingData.service.price || 0,
          currency: bookingData.service.currency || "NOK",
        };

        toast.add({
          title: t("booking.bookingConfirmed"),
          description: `Your reservation at ${store.value?.name} is confirmed for ${formatDateForDisplay(bookingData.date)} at ${bookingData.time}`,
          color: "success",
        });
      } else {
        toast.add({
          title: t("booking.bookingFailed"),
          description: reservation.error || "Please try again",
          color: "error",
        });
      }
      return;
    }

    // Step 1: Create hold
    console.log("[EstablishmentPage] Creating hold for:", bookingData.time);

    // Auto-assign staff: explicit selection > single-staff store > unassigned
    const staffForHold = booking.selectedStaff.value?.id
      || (staff.value.length === 1 ? staff.value[0].id : undefined);

    // Use all selected service IDs (multi-select support)
    const serviceIds = booking.getAllServiceIds().length > 0
      ? booking.getAllServiceIds()
      : [bookingData.service.id];

    const hold = await booking.adapter.createHold({
      companyId: store.value.companyId,
      storeId: store.value.id,
      date: booking.formatDateForAPI(bookingData.date),
      slotTime: bookingData.time,
      serviceIds,
      staffId: staffForHold,
    });

    if (!hold.success || !hold.holdId) {
      toast.add({
        title: t("booking.bookingUnavailable"),
        description: t("booking.slotUnavailable"),
        color: "warning",
      });
      return;
    }

    // Step 2: Confirm booking
    console.log(
      "[EstablishmentPage] Confirming booking with holdId:",
      hold.holdId,
    );

    const bookingResult = await booking.adapter.confirmBooking({
      companyId: store.value.companyId,
      storeId: store.value.id,
      holdId: hold.holdId,
      customerDetails: {
        name: user.value.displayName || "Guest",
        email: user.value.email || "",
        phone: user.value.phoneNumber || "",
      },
      notes: bookingData.notes || "",
    });

    if (bookingResult.success) {
      // Success! Keep slideover open — it will switch to confirmation view
      booking.clearBookingState();

      // Calculate start and end ISO strings
      const [hours = 0, minutes = 0] = bookingData.time.split(":").map(Number);
      const startDate = new Date(bookingData.date);
      startDate.setHours(hours, minutes, 0, 0);

      const startTime = startDate.toISOString();

      // Aggregate all selected services for confirmation display
      const allServiceIds = booking.getAllServiceIds().length > 0
        ? booking.getAllServiceIds()
        : [bookingData.service.id];
      const allSelectedServices = services.value.filter(s => allServiceIds.includes(s.id));
      const totalDuration = allSelectedServices.reduce((sum, s) => sum + (s.duration || 60), 0);
      const totalPrice = allSelectedServices.reduce((sum, s) => sum + (s.price || 0), 0);
      const serviceTitle = allSelectedServices.length > 1
        ? allSelectedServices.map(s => s.title).join(', ')
        : bookingData.service.title;

      const endTime = calculateEndTime(
        bookingData.date,
        bookingData.time,
        totalDuration,
      );

      // Set confirmed booking data — slideover will pick this up via prop
      booking.confirmedBooking.value = {
        id: bookingResult.bookingId,
        serviceTitle,
        storeName: store.value?.name || "",
        storeAddress: store.value
          ? `${store.value.address}, ${store.value.city}`
          : "",
        startTime,
        endTime,
        price: totalPrice,
        currency: bookingData.service.currency || "NOK",
      };

      toast.add({
        title: t("booking.bookingConfirmed"),
        description: `Your appointment at ${store.value?.name} is confirmed for ${formatDateForDisplay(bookingData.date)} at ${bookingData.time}`,
        color: "success",
      });

      console.log("[EstablishmentPage] Booking created:", bookingResult.bookingId);
    } else {
      toast.add({
        title: t("booking.bookingFailed"),
        description: bookingResult.error || "Please try again",
        color: "error",
      });
    }
  } catch (err: any) {
    console.error("[EstablishmentPage] Booking error:", err);

    // Use engine-provided error message when available
    const engineMessage = err?.data?.error

    // Distinguish network errors from other errors
    const isNetworkError =
      err?.code === "functions/unavailable" ||
      err?.code === "functions/deadline-exceeded" ||
      err?.message?.includes("Failed to fetch") ||
      err?.message?.includes("NetworkError") ||
      !navigator.onLine;

    toast.add({
      title: isNetworkError
        ? t("booking.connectionError")
        : t("booking.bookingFailed"),
      description: isNetworkError
        ? t("booking.connectionErrorDesc")
        : engineMessage || t("booking.unexpectedError"),
      color: "error",
      icon: isNetworkError ? "i-lucide-wifi-off" : "i-lucide-alert-triangle",
    });
  } finally {
    booking.confirming.value = false;
  }
}

function handleHoldExpired() {
  booking.clearBookingState();
  toast.add({
    title: t("booking.holdExpired"),
    description: t("booking.holdExpiredDesc"),
    color: "warning",
    icon: "i-lucide-clock",
  });
}

function handleViewBookings() {
  booking.handleViewBookings();
  navigateTo("/profile/bookings");
}

function handleDone() {
  booking.handleDone();
}

function handleBookEvent(event: DDEvent) {
  // Analytics: Track event ticket
  console.log("[EstablishmentPage] Book event:", event.title);
}

async function handleFavorite() {
  // Must be logged in
  if (!user.value) {
    navigateTo(localePath("/login"));
    return;
  }

  if (!store.value?.id) return;

  // Toggle favorite
  if (isFavorited.value) {
    await removeFavorite(store.value.id, "store");
  } else {
    await addFavorite(store.value.id, "store", store.value.companyId);
  }
}

function handleMore() {
  // TODO: Show share/more options modal
  console.log("[EstablishmentPage] More clicked");
}

// ============================================================================
// SEO
// ============================================================================

// Set page meta for SEO
useSeoMeta({
  title: () =>
    store.value ? `${store.value.name} | DittoDatto` : "Loading...",
  description: () =>
    store.value?.about || `Find and book services at ${store.value?.name}`,
  ogTitle: () => store.value?.name,
  ogDescription: () => store.value?.about,
  ogImage: () => store.value?.images?.cover || store.value?.images?.logo,
});

// ============================================================================
// Lifecycle
// ============================================================================

// Fetch data on mount and when route changes
watch([categorySlug, storeSlug], () => fetchStore(), { immediate: true });
</script>

<template>
  <div>
    <!-- Page Component -->
    <DDEstablishmentPage
      :store="store"
      :services="services"
      :service-groups="serviceGroups"
      :events="events"
      :staff="staff"
      :loading="loading"
      :services-loading="servicesLoading"
      :events-loading="eventsLoading"
      :staff-loading="staffLoading"
      :is-favorited="isFavorited"
      mode="public"
      back-url="/"
      :back-label="t('establishment.backToBrowse')"
      @book="handleBook"
      @book-service="handleBookService"
      @book-event="handleBookEvent"
      @book-with-staff="handleBookWithStaff"
      @book-group="handleBookGroup"
      @favorite="handleFavorite"
      @more="handleMore"
      @confirm-booking="handleBookingConfirm"
    />

    <!-- Booking Slideover -->
    <DDBookingSlideover
      :ref="(el: any) => { booking.slideoverRef.value = el }"
      v-model:open="booking.isOpen.value"
      :store-name="store?.name || ''"
      :store-address="store?.address || ''"
      :store-logo="store?.images?.logo"
      :services="services"
      :service-groups="serviceGroups"
      :opening-schedule="store?.openingSchedule"
      :reservation-config="store?.reservationConfig"
      :preselected-service="booking.selectedService.value"
      :available-slots="booking.slots.value"
      :slots-loading="booking.slotsLoading.value"
      :slots-error="booking.slotsError.value"
      :hold-expires-at="booking.holdExpiresAt.value"
      :confirmed-booking="booking.confirmedBooking.value"
      :is-authenticated="!!user"
      :confirming="booking.confirming.value"
      :staff="staff"
      :preselected-staff="booking.selectedStaff.value"
      :pre-expanded-group="booking.preExpandedGroup.value"
      @date-change="booking.handleDateChange"
      @service-selected="booking.handleServiceSelected"
      @staff-selected="booking.handleStaffSelected"
      @confirm="(data: any) => handleBookingConfirm(data)"
      @hold-expired="handleHoldExpired"
      @view-bookings="handleViewBookings"
      @done="handleDone"
      @clear-staff="booking.handleClearStaff"
      @login="
        navigateTo({ path: '/login', query: { redirect: $route.fullPath } })
      "
      @signup="
        navigateTo({ path: '/signup', query: { redirect: $route.fullPath } })
      "
    />
  </div>
</template>
