<script setup lang="ts">
/**
 * DDEstablishmentPage - Shared Establishment Page Component
 * 
 * A reusable full-page component for displaying store/establishment details.
 * Used by both Public Marketplace and Business Portal preview.
 * 
 * @example
 * <DDEstablishmentPage
 *   :store="storeData"
 *   :services="services"
 *   :events="events"
 *   :loading="isLoading"
 *   mode="public"
 *   @book="handleBook"
 *   @book-service="handleServiceBook"
 *   @book-event="handleEventBook"
 * />
 */
import type { Store, Service, Event as DDEvent, OpeningSchedule, StaffMember, ServiceGroup } from '@dittodatto/shared-types'

const { t } = useI18n()

// ============================================================================
// Props
// ============================================================================

export interface EstablishmentPageProps {
  /** The store/establishment data */
  store: Store | null
  /** Services offered by this store */
  services?: Service[]
  /** Service groups for this store */
  serviceGroups?: ServiceGroup[]
  /** Upcoming events at this store */
  events?: DDEvent[]
  /** Bookable staff visible on storefront */
  staff?: StaffMember[]
  /** Loading state */
  loading?: boolean
  /** Loading state for services */
  servicesLoading?: boolean
  /** Loading state for events */
  eventsLoading?: boolean
  /** Loading state for staff */
  staffLoading?: boolean
  /** Display mode: 'public' (marketplace) or 'preview' (portal) */
  mode?: 'public' | 'preview'
  /** Show the services/menu tab */
  showServicesTab?: boolean
  /** Show the people/team tab */
  showPeopleTab?: boolean
  /** Show the events tab */
  showEventsTab?: boolean
  /** Show the about tab */
  showAboutTab?: boolean
  /** Back button URL (for not found state) */
  backUrl?: string
  /** Back button label */
  backLabel?: string
  /** Whether this establishment is in user's favorites */
  isFavorited?: boolean
}

const props = withDefaults(defineProps<EstablishmentPageProps>(), {
  services: () => [],
  serviceGroups: () => [],
  events: () => [],
  staff: () => [],
  loading: false,
  servicesLoading: false,
  eventsLoading: false,
  staffLoading: false,
  mode: 'public',
  showServicesTab: true,
  showPeopleTab: true,
  showEventsTab: true,
  showAboutTab: true,
  backUrl: '/',
  backLabel: 'Back to browse',
  isFavorited: false
})

// ============================================================================
// Emits
// ============================================================================

const emit = defineEmits<{
  /** Emitted when the main Book button is clicked */
  (e: 'book'): void
  /** Emitted when booking a specific service */
  (e: 'book-service', service: Service): void
  /** Emitted when getting tickets for an event */
  (e: 'book-event', event: DDEvent): void
  /** Emitted when booking with a specific staff member */
  (e: 'book-with-staff', staff: StaffMember): void
  /** Emitted when booking a multi-select group */
  (e: 'book-group', groupId: string): void
  /** Emitted when favorite button is clicked */
  (e: 'favorite'): void
  /** Emitted when more/share button is clicked */
  (e: 'more'): void
  /** Emitted when booking is confirmed - parent should handle MercuryEngine persistence */
  (e: 'confirm-booking', booking: { service: Service; date: Date; time: string; guestCount?: number }): void
}>()

// ============================================================================
// State
// ============================================================================

const activeTab = ref(0)
const ticketBookingOpen = ref(false)
const selectedEvent = ref<DDEvent | null>(null)

// ============================================================================
// Computed
// ============================================================================

/** Build dynamic tabs based on props and content */
const tabs = computed(() => {
  const result: { label: string; key: string }[] = []
  
  if (props.showServicesTab) {
    result.push({ label: t('establishment.menuServices'), key: 'services' })
  }
  if (props.showPeopleTab && (props.staff.length > 0 || props.staffLoading)) {
    result.push({ label: t('establishment.ourPeople'), key: 'people' })
  }
  if (props.showEventsTab) {
    result.push({ label: t('establishment.events'), key: 'events' })
  }
  if (props.showAboutTab) {
    result.push({ label: t('establishment.about'), key: 'about' })
  }
  
  return result
})

/** Format today's hours for display */
const hoursDisplay = computed(() => {
  if (!props.store?.openingSchedule) return t('establishment.hoursNotSet')
  const dayKeys = ['sun', 'mon', 'tue', 'wed', 'thu', 'fri', 'sat'] as const
  const today = dayKeys[new Date().getDay()]
  const schedule = props.store.openingSchedule[today]
  if (!schedule?.isOpen) return t('establishment.closedToday')
  return `${schedule.open} - ${schedule.close}`
})

/** Full address string */
const fullAddress = computed(() => {
  if (!props.store) return ''
  return `${props.store.address}, ${props.store.city}`
})

// ============================================================================
// Handlers
// ============================================================================

function handleBook() {
  emit('book')
}

function handleServiceSelect(service: Service) {
  emit('book-service', service)
}

function handleServiceBook(service: Service) {
  emit('book-service', service)
}

function handleStaffSelect(staff: StaffMember) {
  emit('book-with-staff', staff)
}

function handleGroupBook(groupId: string) {
  emit('book-group', groupId)
}

function handleBookingConfirm(booking: { service: Service; date: Date; time: string; guestCount?: number }) {
  // Emit to parent page which has MercuryEngine integration
  console.log('[EstablishmentPage] Emitting booking confirmation to parent:', booking)
  emit('confirm-booking', booking)
}

function handleEventTickets(event: DDEvent) {
  selectedEvent.value = event
  ticketBookingOpen.value = true
  emit('book-event', event)
}

function handleFavorite() {
  emit('favorite')
}

function handleMore() {
  emit('more')
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
        {{ t('establishment.notFound') }}
      </h2>
      <p class="text-muted mb-6">
        {{ t('establishment.notFoundDescription') }}
      </p>
      <UButton :to="backUrl" :label="backLabel" />
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
        :is-favorited="isFavorited"
        :favorites-count="store.favoritesCount"
        @book="handleBook"
        @favorite="handleFavorite"
        @more="handleMore"
      />

      <!-- 3. Tabs Navigation -->
      <div v-if="tabs.length > 1" class="border-b border-default">
        <div class="flex gap-8">
          <button
            v-for="(tab, index) in tabs"
            :key="tab.key"
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
        <div v-if="tabs[activeTab]?.key === 'services'" class="animate-fade-in">
          <h2 class="text-xl font-bold mb-6">
            {{ t('establishment.menuServices') }}
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
            v-else-if="services.length > 0"
            :services="services"
            :service-groups="serviceGroups"
            @select="handleServiceSelect"
            @book="handleServiceBook"
            @book-group="handleGroupBook"
          />

          <!-- Empty State -->
          <div v-else class="text-center py-12 text-muted">
            <UIcon name="i-lucide-briefcase" class="size-12 mx-auto mb-4 opacity-50" />
            <p class="font-medium text-default">{{ t('establishment.noServices') }}</p>
            <p v-if="mode === 'preview'" class="text-sm mt-1">
              {{ t('establishment.noServicesPreview') }}
            </p>
            <p v-else class="text-sm mt-1">
              {{ t('establishment.noServicesPublic') }}
            </p>
          </div>
        </div>

        <!-- People Tab -->
        <div v-else-if="tabs[activeTab]?.key === 'people'" class="animate-fade-in">
          <h2 class="text-xl font-bold mb-6">
            {{ t('establishment.ourPeople') }}
          </h2>
          <DDEstablishmentStaffGrid
            :staff="staff"
            :loading="staffLoading"
            @select="handleStaffSelect"
          />
        </div>

        <!-- Events Tab -->
        <div v-else-if="tabs[activeTab]?.key === 'events'" class="animate-fade-in">
          <h2 class="text-xl font-bold mb-6">
            {{ t('establishment.upcomingEvents') }}
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
            :events="events"
            empty-icon="i-lucide-calendar-days"
            empty-text=""
            @tickets="handleEventTickets"
          />
        </div>

        <!-- About Tab -->
        <div v-else-if="tabs[activeTab]?.key === 'about'" class="animate-fade-in">
          <h2 class="text-xl font-bold mb-6">
            {{ t('establishment.about') }}
          </h2>
          <DDEstablishmentAboutSection
            :description="store.about || t('establishment.noDescription')"
            :address="store.address"
            :city="store.city"
            :lat="store.gmapCoord?.lat"
            :lng="store.gmapCoord?.lng"
            :phone="store.phone"
            :email="store.email"
            :website="store.website"
            :social-links="store.slinks"
          />
        </div>
      </div>
    </template>



    <!-- Ticket Booking Flow for Events -->
    <USlideover
      v-model:open="ticketBookingOpen"
      :title="selectedEvent?.title || t('booking.getTickets')"
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
