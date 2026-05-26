<script setup lang="ts">
/**
 * Store Preview Page
 * Shows the public-facing view of a store with real data.
 * URL: /establishments/[slug]/preview
 */
import { collection, getDocs } from 'firebase/firestore'
import type { Service, Event as DDEvent } from '@dittodatto/shared-types'

definePageMeta({
  layout: 'visual-preview'
})

const route = useRoute()
const slug = computed(() => route.params.slug as string)

const { companyId } = useCompany()
const { stores, loading } = useStores()
const db = useFirestore()

// Find the current store by slug OR id (fallback for backwards compatibility)
const store = computed(() =>
  stores.value?.find(s => s.slug === slug.value || s.id === slug.value)
)

// State
const bookingOpen = ref(false)
const selectedServiceForBooking = ref<Service | null>(null)
const activeTab = ref(0)
const servicesLoading = ref(false)
const storeServices = ref<Service[]>([])
const storeEvents = ref<DDEvent[]>([])
const eventsLoading = ref(false)

// Ticket booking state
const ticketBookingOpen = ref(false)
const selectedEvent = ref<DDEvent | null>(null)

const tabs = [
  { label: 'Menu / Services' },
  { label: 'Events' },
  { label: 'About Us' }
]

// Fetch services for this store
watch([store, companyId], async ([storeVal, companyIdVal]) => {
  if (!storeVal?.id || !companyIdVal) {
    storeServices.value = []
    return
  }

  servicesLoading.value = true
  try {
    const servicesRef = collection(db, 'companies', companyIdVal, 'stores', storeVal.id, 'services')
    const snapshot = await getDocs(servicesRef)
    storeServices.value = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    } as Service))
  } catch (e) {
    console.error('[Preview] Error fetching services:', e)
    storeServices.value = []
  } finally {
    servicesLoading.value = false
  }
}, { immediate: true })

// Fetch events for this store
watch([store, companyId], async ([storeVal, companyIdVal]) => {
  if (!storeVal?.id || !companyIdVal) {
    storeEvents.value = []
    return
  }

  eventsLoading.value = true
  console.log('[Preview] Fetching events for store:', storeVal.id)
  try {
    const eventsRef = collection(db, 'events')
    const { query, where, getDocs: getDocsQuery, orderBy } = await import('firebase/firestore')
    const eventsQuery = query(
      eventsRef,
      where('storeId', '==', storeVal.id),
      where('status', '==', 'published'),
      orderBy('startDateTime', 'asc')
    )
    const snapshot = await getDocsQuery(eventsQuery)
    console.log('[Preview] Found events:', snapshot.size)
    storeEvents.value = snapshot.docs.map(doc => ({
      id: doc.id,
      ...doc.data()
    } as DDEvent))
  } catch (e: unknown) {
    const err = e as { code?: string, message?: string }
    console.error('[Preview] Error fetching events:', err)
    // If index error, provide helpful message
    if (err.code === 'failed-precondition') {
      console.error('[Preview] FIRESTORE INDEX REQUIRED - Check console for index creation link')
    }
    storeEvents.value = []
  } finally {
    eventsLoading.value = false
  }
}, { immediate: true })

// Format hours for display
const hoursDisplay = computed(() => {
  if (!store.value?.openingSchedule) return 'Hours not set'
  const today = new Date().toLocaleDateString('en-US', { weekday: 'short' }).toLowerCase().slice(0, 3)
  const schedule = store.value.openingSchedule[today as keyof typeof store.value.openingSchedule]
  if (!schedule?.isOpen) return 'Closed today'
  return `${schedule.open} - ${schedule.close}`
})


function handleBook() {
  selectedServiceForBooking.value = null
  bookingOpen.value = true
}

function handleServiceSelect(service: any) {
  selectedServiceForBooking.value = service as Service
  bookingOpen.value = true
}

function handleServiceBook(service: any) {
  selectedServiceForBooking.value = service as Service
  bookingOpen.value = true
}

function handleBookingConfirm(booking: any) {
  // Preview mode — no MercuryEngine.
  // Just close the slideover
  bookingOpen.value = false
  console.log('[Preview] Booking confirm (preview only):', booking)
}

function handleEventTickets(event: any) {
  selectedEvent.value = event
  ticketBookingOpen.value = true
}
</script>

<template>
  <div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8 space-y-8 pb-32">
    <!-- Loading State -->
    <div v-if="loading" class="space-y-6">
      <USkeleton class="h-80 w-full rounded-xl" />
      <USkeleton class="h-24 w-full" />
      <USkeleton class="h-48 w-full" />
    </div>

    <!-- Not Found -->
    <div v-else-if="!store" class="text-center py-20">
      <UIcon name="i-lucide-store" class="size-16 text-muted mx-auto mb-4" />
      <h2 class="text-2xl font-bold mb-2">
        Store not found
      </h2>
      <p class="text-muted mb-6">
        This store doesn't exist or you don't have access.
      </p>
      <UButton to="/establishments" label="Back to establishments" />
    </div>

    <!-- Store Content -->
    <template v-else>
      <!-- 1. Hero Gallery -->
      <DDEstablishmentImageGallery
        :images="store.images"
        :layout-mode="store.coverLayoutMode || 'bento'"
      />

      <!-- 2. Info Bar -->
      <DDEstablishmentInfoBar
        :name="store.name"
        :logo="store.images?.logo"
        :address="store.address"
        :city="store.city"
        :hours-display="hoursDisplay"
        @book="handleBook"
        @favorite="() => {}"
        @more="() => {}"
      />

      <!-- 3. Tabs Navigation -->
      <div class="border-b border-default">
        <div class="flex gap-8">
          <button
            v-for="(tab, index) in tabs"
            :key="index"
            class="pb-4 text-sm font-semibold border-b-2 transition-colors duration-200"
            :class="[
              activeTab === index
                ? 'border-primary text-primary'
                : 'border-transparent text-muted hover:text-default'
            ]"
            @click="activeTab = index"
          >
            {{ tab.label }}
          </button>
        </div>
      </div>

      <!-- 4. Tab Content -->
      <div class="min-h-[400px]">
        <!-- Services Tab -->
        <div v-if="activeTab === 0" class="animate-fade-in">
          <h2 class="text-xl font-bold mb-6">
            Menu / Services
          </h2>

          <!-- Loading Services -->
          <div v-if="servicesLoading" class="grid grid-cols-2 md:grid-cols-4 gap-4">
            <div v-for="i in 4" :key="i" class="space-y-2">
              <USkeleton class="aspect-4/3 w-full rounded-xl" />
              <USkeleton class="h-4 w-3/4" />
              <USkeleton class="h-4 w-1/2" />
            </div>
          </div>

          <!-- Service Grid -->
          <DDServiceGrid
            v-else-if="storeServices.length > 0"
            :services="storeServices"
            @select="handleServiceSelect"
            @book="handleServiceBook"
          />

          <!-- Empty State -->
          <div v-else class="text-center py-12 text-muted">
            <UIcon name="i-lucide-briefcase" class="size-12 mx-auto mb-4" />
            <p>No services configured yet.</p>
            <p class="text-sm">
              Add services in the store management page.
            </p>
          </div>
        </div>

        <!-- Events Tab -->
        <div v-else-if="activeTab === 1" class="animate-fade-in">
          <h2 class="text-xl font-bold mb-6">
            Upcoming Events
          </h2>

          <!-- Loading Events -->
          <div v-if="eventsLoading" class="grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 gap-4">
            <div v-for="i in 3" :key="i" class="space-y-2">
              <USkeleton class="aspect-video w-full rounded-xl" />
              <USkeleton class="h-5 w-3/4" />
              <USkeleton class="h-4 w-1/2" />
            </div>
          </div>

          <!-- Event Grid -->
          <DDEventGrid
            v-else
            :events="storeEvents"
            empty-icon="i-lucide-calendar-days"
            empty-text="No upcoming events at this location."
            @tickets="handleEventTickets"
          />
        </div>

        <!-- About Tab -->
        <div v-else-if="activeTab === 2" class="animate-fade-in">
          <h2 class="text-xl font-bold mb-6">
            About Us
          </h2>
          <DDEstablishmentAboutSection
            :description="store.about || 'No description available.'"
            :address="store.address"
            :city="store.city"
            :lat="store.gmapCoord?.lat"
            :lng="store.gmapCoord?.lng"
          />
        </div>
      </div>
    </template>

    <!-- Booking Slideover -->
    <DDBookingSlideover
      v-model:open="bookingOpen"
      :store-name="store?.name || ''"
      :store-address="`${store?.address || ''}, ${store?.city || ''}`"
      :store-logo="store?.images?.logo"
      :services="storeServices"
      :preselected-service="selectedServiceForBooking"
      :opening-schedule="store?.openingSchedule"
      @confirm="handleBookingConfirm"
    />

    <!-- Ticket Booking Flow for Events -->
    <USlideover
      v-model:open="ticketBookingOpen"
      :title="selectedEvent?.title || 'Get Tickets'"
    >
      <template #body>
        <DDBookingFlowsTicketBookingFlow
          v-if="selectedEvent"
          :event-id="selectedEvent.id"
          :event-name="selectedEvent.title"
          :event-date="selectedEvent.startDateTime"
          :event-location="selectedEvent.location?.city"
          @complete="ticketBookingOpen = false"
          @cancel="ticketBookingOpen = false"
        />
      </template>
    </USlideover>
  </div>
</template>

<style scoped>
.animate-fade-in {
  animation: fadeIn 0.4s ease-out forwards;
}

@keyframes fadeIn {
  from { opacity: 0; transform: translateY(10px); }
  to { opacity: 1; transform: translateY(0); }
}
</style>
