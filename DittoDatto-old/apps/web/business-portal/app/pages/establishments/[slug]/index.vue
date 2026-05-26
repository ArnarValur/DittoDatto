<script setup lang="ts">
import { doc, updateDoc } from 'firebase/firestore'

definePageMeta({
  layout: 'dashboard'
})

const route = useRoute()
const storeIdOrSlug = computed(() => route.params.slug as string)
const db = useFirestore()
const toast = useToast()

const { companyId } = useCompany()
const { stores, loading: storesLoading } = useStores()
const { categoryOptions } = useCategories()

// Note: Booking type options removed - booking mode is now configured per-service

// Find the current store by ID or slug
const store = computed(() => {
  const param = storeIdOrSlug.value
  return stores.value?.find(s => s.id === param || s.slug === param)
})

// Form state
const saving = ref(false)
const activeTab = ref('general')

const state = reactive({
  // General
  name: '',
  category: '',
  about: '',
  storeType: 'store' as 'store' | 'restaurant' | 'venue',
  resourcesEnabled: false,

  // Location
  address: '',
  city: '',
  zip: '',
  // country is always 'NO' - hardcoded in save logic
  gmapCoord: {
    lat: null as number | null,
    lng: null as number | null
  },

  // Contact
  phone: '',
  email: '',
  website: '',
  images: {
    logo: '',
    cover: '',
    gallery: [] as string[]
  },
  slinks: {
    fb: '',
    ig: '',
    x: ''
  },

  // Hours
  openingSchedule: {
    mon: { isOpen: true, open: '09:00', close: '17:00' },
    tue: { isOpen: true, open: '09:00', close: '17:00' },
    wed: { isOpen: true, open: '09:00', close: '17:00' },
    thu: { isOpen: true, open: '09:00', close: '17:00' },
    fri: { isOpen: true, open: '09:00', close: '17:00' },
    sat: { isOpen: true, open: '10:00', close: '16:00' },
    sun: { isOpen: false, open: '00:00', close: '00:00' }
  },

  // Settings
  isPublished: false,
  // Note: bookingFormType removed - booking mode is now on service level

  // Media / Layout
  coverLayoutMode: 'bento' as 'showcase' | 'spotlight' | 'bento',

  // Reservation Config
  reservationConfig: {
    slotInterval: 30,
    defaultDuration: 60,
    bufferBetweenSlots: 0,
    totalCapacity: 50,
    maxGuestsPerReservation: 8,
    autoConfirm: true
  },


  // Booking Policy (cancellation, reschedule rules)
  bookingPolicy: {
    clientCancelEnabled: true,
    minCancelNoticeHours: 24,
    clientRescheduleEnabled: true,
    minRescheduleNoticeHours: 24
  }
})

// Sync form state when store loads
watch(store, (s) => {
  if (s) {
    state.name = s.name || ''
    state.category = s.category || ''
    state.about = s.about || ''
    state.storeType = s.storeType || 'store'
    state.resourcesEnabled = s.resourcesEnabled ?? false
    state.address = s.address || ''
    state.city = s.city || ''
    state.zip = s.zip || ''
    // Sync coordinates
    state.gmapCoord = {
      lat: s.gmapCoord?.lat ?? null,
      lng: s.gmapCoord?.lng ?? null
    }
    state.phone = s.phone || ''
    state.email = s.email || ''
    state.website = s.website || ''
    state.images = {
      logo: s.images?.logo || '',
      cover: s.images?.cover || '',
      gallery: s.images?.gallery || []
    }
    state.slinks = {
      fb: s.slinks?.fb || '',
      ig: s.slinks?.ig || '',
      x: s.slinks?.x || ''
    }
    state.openingSchedule = s.openingSchedule || state.openingSchedule
    state.isPublished = s.isPublished || false
    // Note: bookingFormType sync removed - now on service level
    state.coverLayoutMode = s.coverLayoutMode || 'bento'
    if (s.reservationConfig) {
      state.reservationConfig = {
        ...state.reservationConfig,
        ...s.reservationConfig
      }
    }
    // Sync booking policy
    if (s.bookingPolicy) {
      state.bookingPolicy = {
        ...state.bookingPolicy,
        ...s.bookingPolicy
      }
    }
  }
}, { immediate: true })

const baseTabs = [
  { label: 'General', value: 'general', icon: 'i-lucide-info' },
  { label: 'Location', value: 'location', icon: 'i-lucide-map-pin' },
  { label: 'Contact', value: 'contact', icon: 'i-lucide-phone' },
  { label: 'Hours', value: 'hours', icon: 'i-lucide-clock' },
  { label: 'Settings', value: 'settings', icon: 'i-lucide-settings' },
  { label: 'Media', value: 'media', icon: 'i-lucide-image' }
]

const tabs = computed(() => {
  return [...baseTabs]
})

const layoutModeOptions = [
  {
    value: 'bento',
    label: 'Bento Grid',
    description: '2/4 cover + 2x2 gallery grid',
    icon: 'i-lucide-layout-grid'
  },
  {
    value: 'showcase',
    label: 'Showcase',
    description: '3/4 cover + vertical scroll gallery',
    icon: 'i-lucide-layout-panel-left'
  },
  {
    value: 'spotlight',
    label: 'Spotlight',
    description: 'Full-width cover image',
    icon: 'i-lucide-maximize'
  }
]

const days = [
  { key: 'mon', label: 'Monday' },
  { key: 'tue', label: 'Tuesday' },
  { key: 'wed', label: 'Wednesday' },
  { key: 'thu', label: 'Thursday' },
  { key: 'fri', label: 'Friday' },
  { key: 'sat', label: 'Saturday' },
  { key: 'sun', label: 'Sunday' }
]

// Geocoding state
const config = useRuntimeConfig()
const geocoding = ref(false)
const geocodeError = ref<string | null>(null)
let geocoder: google.maps.Geocoder | null = null

// Check if address is complete enough for geocoding
const canGeocode = computed(() => {
  return state.address.trim().length > 0 && state.city.trim().length > 0
})

// Geocode address to coordinates using Maps JavaScript API Geocoder
async function geocodeAddress() {
  if (!canGeocode.value) {
    toast.add({ title: 'Missing Address', description: 'Please enter street address and city first', color: 'warning' })
    return
  }

  geocoding.value = true
  geocodeError.value = null

  try {
    // Import the geocoding library if not already loaded
    const { setOptions, importLibrary } = await import('@googlemaps/js-api-loader')

    // Ensure Maps API is configured
    const apiKey = config.public.googleMapsApiKey as string
    try {
      setOptions({ key: apiKey, v: 'weekly' })
    } catch {
      // Options already set, ignore
    }

    // Load geocoding library
    const geocodingLib = await importLibrary('geocoding') as google.maps.GeocodingLibrary
    geocoder = new geocodingLib.Geocoder()

    const address = `${state.address}, ${state.zip} ${state.city}, Norway`

    // Use the JavaScript API Geocoder
    const result = await geocoder.geocode({ address })

    if (result.results && result.results.length > 0) {
      const location = result.results[0].geometry.location
      state.gmapCoord.lat = location.lat()
      state.gmapCoord.lng = location.lng()
      toast.add({ title: 'Location Found', description: 'Map coordinates updated', color: 'success' })
    } else {
      geocodeError.value = 'Address not found. Try a more specific address.'
      toast.add({ title: 'Not Found', description: 'Could not find this address on the map', color: 'warning' })
    }
  } catch (err: unknown) {
    console.error('[Geocoding] Error:', err)
    const message = err instanceof Error ? err.message : 'Unknown error'
    if (message.includes('ZERO_RESULTS')) {
      geocodeError.value = 'Address not found. Try a more specific address.'
      toast.add({ title: 'Not Found', description: 'Could not find this address on the map', color: 'warning' })
    } else {
      geocodeError.value = 'Geocoding failed'
      toast.add({ title: 'Error', description: 'Failed to find location', color: 'error' })
    }
  } finally {
    geocoding.value = false
  }
}

// Clear coordinates
function clearCoordinates() {
  state.gmapCoord.lat = null
  state.gmapCoord.lng = null
  geocodeError.value = null
}

async function handleSave() {
  if (!companyId.value || !store.value?.id) return

  saving.value = true
  try {
    const storeRef = doc(db, 'companies', companyId.value, 'stores', store.value.id)

    await updateDoc(storeRef, {
      name: state.name,
      category: state.category || null,
      about: state.about || null,
      storeType: state.storeType,
      address: state.address,
      city: state.city,
      zip: state.zip,
      country: 'NO', // Always Norway
      // Save coordinates if both lat and lng are set
      gmapCoord: (state.gmapCoord.lat && state.gmapCoord.lng)
        ? { lat: state.gmapCoord.lat, lng: state.gmapCoord.lng }
        : null,
      phone: state.phone || null,
      email: state.email || null,
      website: state.website || null,
      images: {
        logo: state.images.logo || null,
        cover: state.images.cover || null,
        gallery: state.images.gallery || []
      },
      slinks: state.slinks,
      openingSchedule: state.openingSchedule,
      isPublished: state.isPublished,
      resourcesEnabled: state.resourcesEnabled,
      // Note: bookingFormType removed - now on service level
      coverLayoutMode: state.coverLayoutMode,
      reservationConfig: state.reservationConfig,
      bookingPolicy: state.bookingPolicy,
      updatedAt: new Date()
    })

    toast.add({ title: 'Saved', description: 'Store updated successfully', color: 'success' })
  } catch (err: unknown) {
    console.error(err)
    const message = err instanceof Error ? err.message : 'An unexpected error occurred'
    toast.add({ title: 'Error', description: message, color: 'error' })
  } finally {
    saving.value = false
  }
}
</script>

<template>
  <!--
  -- TODO: This page must be modularized, its almost 1k lines of template :)
  -->
  <UDashboardPanel id="store-management">
    <template #header>
      <UDashboardNavbar :title="store?.name || 'Store'" :ui="{ right: 'gap-3' }">
        <template #leading>
          <UDashboardSidebarCollapse />
          <UButton
            icon="i-lucide-arrow-left"
            variant="ghost"
            color="neutral"
            to="/establishments"
            class="mr-2"
          />
        </template>

        <template #right>
          <UBadge v-if="store?.isPublished" color="success" variant="subtle">
            Published
          </UBadge>
          <UBadge v-else color="warning" variant="subtle">
            Draft
          </UBadge>

          <UButton
            icon="i-lucide-eye"
            label="Preview"
            color="neutral"
            variant="outline"
            :to="`/establishments/${store?.slug}/preview`"
          />

          <UButton
            icon="i-lucide-save"
            label="Save Changes"
            color="primary"
            :loading="saving"
            @click="handleSave"
          />
        </template>
      </UDashboardNavbar>
    </template>

    <template #body>
      <div v-if="storesLoading" class="p-6">
        <USkeleton class="h-12 w-64 mb-4" />
        <USkeleton class="h-96 w-full" />
      </div>

      <div v-else-if="!store" class="p-6 text-center">
        <UIcon name="i-lucide-alert-circle" class="size-16 text-muted mx-auto mb-4" />
        <h2 class="text-xl font-semibold mb-2">
          Store not found
        </h2>
        <UButton to="/establishments" label="Back to establishments" />
      </div>

      <div v-else class="p-6">
        <!-- Tabs Navigation -->
        <div class="flex gap-2 mb-6 border-b border-default pb-4">
          <UButton
            v-for="tab in tabs"
            :key="tab.value"
            :icon="tab.icon"
            :label="tab.label"
            :color="activeTab === tab.value ? 'primary' : 'neutral'"
            :variant="activeTab === tab.value ? 'solid' : 'ghost'"
            @click="activeTab = tab.value"
          />
        </div>

        <!-- Tab Content -->
        <div class="max-w-2xl">
          <!-- General Tab -->
          <div v-if="activeTab === 'general'" class="space-y-6">
            <UFormField label="Name" required>
              <UInput v-model="state.name" placeholder="My Awesome Store" class="w-full" />
            </UFormField>

            <UFormField label="Business Type" required>
              <USelectMenu
                v-model="state.storeType"
                :items="[
                  { label: 'Store', value: 'store', icon: 'i-lucide-store' },
                  { label: 'Restaurant', value: 'restaurant', icon: 'i-lucide-utensils' },
                  { label: 'Venue', value: 'venue', icon: 'i-lucide-building-2' }
                ]"
                value-key="value"
                class="w-full"
              >
                <template #item="{ item }">
                  <div class="flex items-center gap-2">
                    <UIcon :name="item.icon" class="size-4" />
                    <span>{{ item.label }}</span>
                  </div>
                </template>
              </USelectMenu>
            </UFormField>

            <UFormField label="Category">
              <USelectMenu
                v-model="state.category"
                :items="categoryOptions"
                value-key="id"
                placeholder="Select a category"
                class="w-full"
              />
            </UFormField>

            <UFormField label="About / Description">
              <UTextarea
                v-model="state.about"
                placeholder="Tell customers about your business..."
                :rows="5"
                class="w-full"
              />
            </UFormField>
          </div>

          <!-- Location Tab -->
          <div v-if="activeTab === 'location'" class="space-y-6">
            <UFormField label="Street Address" required>
              <UInput v-model="state.address" placeholder="Main Street 1" class="w-full" />
            </UFormField>

            <div class="grid grid-cols-2 gap-4">
              <UFormField label="City" required>
                <UInput v-model="state.city" placeholder="Oslo" class="w-full" />
              </UFormField>
              <UFormField label="Zip Code" required>
                <UInput v-model="state.zip" placeholder="0001" class="w-full" />
              </UFormField>
            </div>

            <!-- Map Preview Section -->
            <USeparator label="Map Preview" />

            <div class="p-4 rounded-lg border border-default bg-muted/30">
              <!-- No coordinates yet -->
              <div v-if="!state.gmapCoord.lat || !state.gmapCoord.lng">
                <div class="flex items-center gap-2 mb-3">
                  <UIcon name="i-lucide-map-pin" class="size-5 text-primary" />
                  <h3 class="font-semibold">
                    Find on Map
                  </h3>
                </div>
                <p class="text-sm text-muted mb-4">
                  Click the button below to find your store's location based on the address above.
                </p>

                <!-- Error message -->
                <div v-if="geocodeError" class="mb-4 p-3 rounded-lg bg-red-500/10 border border-red-500/30">
                  <p class="text-sm text-red-400">
                    {{ geocodeError }}
                  </p>
                </div>

                <UButton
                  icon="i-lucide-search"
                  label="Find on Map"
                  color="primary"
                  :loading="geocoding"
                  :disabled="!canGeocode"
                  @click="geocodeAddress"
                />

                <p v-if="!canGeocode" class="text-xs text-muted mt-2">
                  Enter street address and city above first.
                </p>
              </div>

              <!-- Has coordinates - show map -->
              <div v-else>
                <div class="flex items-center justify-between mb-3">
                  <div class="flex items-center gap-2">
                    <UIcon name="i-lucide-map-pin" class="size-5 text-primary" />
                    <h3 class="font-semibold">
                      Location Preview
                    </h3>
                    <UBadge color="success" variant="subtle" size="xs">
                      Found
                    </UBadge>
                  </div>
                  <UButton
                    icon="i-lucide-x"
                    label="Clear"
                    color="neutral"
                    variant="ghost"
                    size="xs"
                    @click="clearCoordinates"
                  />
                </div>

                <ClientOnly>
                  <DDMapStoreMap
                    :lat="state.gmapCoord.lat"
                    :lng="state.gmapCoord.lng"
                    :popup-name="state.name || 'Your Store'"
                    height="250px"
                  />
                  <template #fallback>
                    <div class="h-[250px] bg-gray-100 dark:bg-gray-800 rounded-xl flex items-center justify-center">
                      <UIcon name="i-lucide-loader-2" class="size-6 text-gray-400 animate-spin" />
                    </div>
                  </template>
                </ClientOnly>

                <p class="text-xs text-muted mt-2">
                  Coordinates: {{ state.gmapCoord.lat?.toFixed(6) }}, {{ state.gmapCoord.lng?.toFixed(6) }}
                </p>
              </div>
            </div>
          </div>

          <!-- Contact Tab -->
          <div v-if="activeTab === 'contact'" class="space-y-6">
            <UFormField label="Phone">
              <UInput v-model="state.phone" placeholder="+47 123 45 678" class="w-full" />
            </UFormField>

            <UFormField label="Email">
              <UInput
                v-model="state.email"
                type="email"
                placeholder="hello@store.com"
                class="w-full"
              />
            </UFormField>

            <UFormField label="Website">
              <UInput v-model="state.website" placeholder="https://store.com" class="w-full" />
            </UFormField>

            <UFormField label="Store Logo">
              <DDMediaPickerButton
                v-model="state.images.logo"
                :company-id="companyId || ''"
                :store-id="store?.id"
                :filter-tags="['logo']"
                label="Choose Logo"
                placeholder="Select a logo from your media library"
              />
            </UFormField>

            <USeparator label="Social Links" />

            <div class="grid grid-cols-3 gap-4">
              <UFormField label="Facebook">
                <UInput v-model="state.slinks.fb" placeholder="https://facebook.com/..." class="w-full" />
              </UFormField>
              <UFormField label="Instagram">
                <UInput v-model="state.slinks.ig" placeholder="https://instagram.com/..." class="w-full" />
              </UFormField>
              <UFormField label="X (Twitter)">
                <UInput v-model="state.slinks.x" placeholder="https://x.com/..." class="w-full" />
              </UFormField>
            </div>
          </div>

          <!-- Hours Tab -->
          <div v-if="activeTab === 'hours'" class="space-y-4">
            <div
              v-for="day in days"
              :key="day.key"
              class="flex items-center gap-4 p-3 rounded-lg border border-default"
            >
              <div class="w-24 font-medium">
                {{ day.label }}
              </div>

              <USwitch
                v-model="state.openingSchedule[day.key as keyof typeof state.openingSchedule].isOpen"
              />

              <template v-if="state.openingSchedule[day.key as keyof typeof state.openingSchedule].isOpen">
                <UInput
                  v-model="state.openingSchedule[day.key as keyof typeof state.openingSchedule].open"
                  type="time"
                  class="w-32"
                />
                <span class="text-muted">to</span>
                <UInput
                  v-model="state.openingSchedule[day.key as keyof typeof state.openingSchedule].close"
                  type="time"
                  class="w-32"
                />
              </template>
              <span v-else class="text-muted">Closed</span>
            </div>

            <!-- Booking Policy -->
            <StoresBookingPolicyCard v-model="state.bookingPolicy" />
          </div>

          <!-- Settings Tab -->
          <div v-if="activeTab === 'settings'" class="space-y-6">

            <!-- Simple Capacity (optional) -->
            <div class="p-4 rounded-lg border border-default bg-muted/30">
              <div class="flex items-center gap-2 mb-3">
                <UIcon name="i-lucide-users" class="size-5 text-primary" />
                <h3 class="font-semibold">
                  Venue Capacity
                </h3>
                <UBadge color="info" variant="subtle" size="xs">
                  Optional
                </UBadge>
              </div>
              <p class="text-sm text-muted mb-4">
                Total capacity of your venue. Useful for AI-powered booking suggestions and availability management.
              </p>
              <UFormField label="Maximum Capacity" hint="Total guests/customers this venue can accommodate">
                <UInput
                  v-model.number="state.reservationConfig.totalCapacity"
                  type="number"
                  :min="1"
                  placeholder="e.g. 50"
                  class="w-48"
                />
              </UFormField>
            </div>

            <USeparator class="my-6" />

            <div class="flex items-center justify-between p-4 rounded-lg border border-default">
              <div>
                <p class="font-medium">
                  Publish Establishment
                </p>
                <p class="text-sm text-muted">
                  Make this establishment visible to customers
                </p>
              </div>
              <USwitch v-model="state.isPublished" />
            </div>

            <!-- Resource Management Feature Toggle -->
            <div class="flex items-center justify-between p-4 rounded-lg border border-default">
              <div>
                <div class="flex items-center gap-2">
                  <p class="font-medium">
                    Resource Management
                  </p>
                  <UBadge color="info" variant="subtle" size="xs">
                    Tables, Rooms, Equipment
                  </UBadge>
                </div>
                <p class="text-sm text-muted">
                  Enable to manage physical resources like tables, rooms, stations, and add-ons for this establishment
                </p>
              </div>
              <USwitch v-model="state.resourcesEnabled" />
            </div>
          </div>

          <!-- Media Tab -->
          <div v-if="activeTab === 'media'" class="space-y-6">
            <!-- Layout Mode Selector -->
            <div>
              <h3 class="text-lg font-semibold mb-4">
                Cover Layout Mode
              </h3>
              <p class="text-sm text-muted mb-4">
                Choose how your store's hero images are displayed on the preview page.
              </p>

              <div class="grid grid-cols-1 md:grid-cols-3 gap-4">
                <button
                  v-for="mode in layoutModeOptions"
                  :key="mode.value"
                  type="button"
                  class="p-4 rounded-xl border-2 text-left transition-all duration-200"
                  :class="[
                    state.coverLayoutMode === mode.value
                      ? 'border-primary-500 bg-primary-500/10'
                      : 'border-default hover:border-gray-500'
                  ]"
                  @click="state.coverLayoutMode = mode.value as 'showcase' | 'spotlight' | 'bento'"
                >
                  <div class="flex items-start gap-3">
                    <div
                      class="size-10 rounded-lg flex items-center justify-center"
                      :class="[
                        state.coverLayoutMode === mode.value
                          ? 'bg-primary-500 text-white'
                          : 'bg-gray-700 text-gray-400'
                      ]"
                    >
                      <UIcon :name="mode.icon" class="size-5" />
                    </div>
                    <div class="flex-1">
                      <p class="font-medium">
                        {{ mode.label }}
                      </p>
                      <p class="text-sm text-muted">
                        {{ mode.description }}
                      </p>
                    </div>
                    <UIcon
                      v-if="state.coverLayoutMode === mode.value"
                      name="i-lucide-check-circle"
                      class="size-5 text-primary-500"
                    />
                  </div>
                </button>
              </div>
            </div>

            <USeparator label="Images" class="my-6" />

            <!-- Cover Image -->
            <UFormField label="Cover Image" hint="Main hero image for your store">
              <DDMediaPickerButton
                v-model="state.images.cover"
                :company-id="companyId || ''"
                :store-id="store?.id"
                :filter-tags="['cover']"
                label="Choose Cover"
                placeholder="Select a cover image from your media library"
              />
            </UFormField>

            <!-- Gallery Images -->
            <UFormField label="Gallery Images" hint="Additional images shown alongside the cover">
              <div class="space-y-3">
                <div v-if="state.images.gallery.length > 0" class="grid grid-cols-4 gap-3">
                  <div
                    v-for="(img, index) in state.images.gallery"
                    :key="index"
                    class="relative aspect-square rounded-lg overflow-hidden group"
                  >
                    <NuxtImg :src="img" :alt="`Gallery ${index + 1}`" class="w-full h-full object-cover" loading="lazy" sizes="150px" />
                    <button
                      type="button"
                      class="absolute top-1 right-1 size-6 bg-red-500 text-white rounded-full opacity-0 group-hover:opacity-100 transition-opacity flex items-center justify-center"
                      @click="state.images.gallery.splice(index, 1)"
                    >
                      <UIcon name="i-lucide-x" class="size-4" />
                    </button>
                  </div>
                </div>
                <DDMediaPickerButton
                  :model-value="''"
                  :company-id="companyId || ''"
                  :store-id="store?.id"
                  :filter-tags="['gallery']"
                  :multiple="true"
                  label="Add to Gallery"
                  placeholder="Select images for your gallery"
                  @select-multiple="(items: { url: string }[]) => items.forEach(item => state.images.gallery.push(item.url))"
                />
              </div>
            </UFormField>

            <!-- Logo (moved from Contact) -->
            <UFormField label="Store Logo" hint="Small logo shown on info bar">
              <DDMediaPickerButton
                v-model="state.images.logo"
                :company-id="companyId || ''"
                :store-id="store?.id"
                :filter-tags="['logo']"
                label="Choose Logo"
                placeholder="Select a logo from your media library"
              />
            </UFormField>
          </div>


        </div>
      </div>
    </template>
  </UDashboardPanel>
</template>
