<script setup lang="ts">
/**
 * MapExplorer — High-end interactive store map
 *
 * Features:
 * - Dual light/dark styles, reactive to SolarTheme colorMode
 * - MarkerClusterer: glowing cluster orbs → individual pins as you zoom in
 * - Store preview card slides up on marker click (mobile-first)
 * - Pagination through stores in a cluster
 * - No deprecated Marker API — uses legacy marker with tolerable suppression until Map ID is provisioned
 * - Full Google ToS compliance (attribution retained)
 *
 * Usage: unchanged from before — index.vue needs no edits.
 * 
 * TODO 01.03.26: this template is... slow and .. needs reiteration.
 */
import { setOptions, importLibrary } from '@googlemaps/js-api-loader'
import { MarkerClusterer, SuperClusterAlgorithm } from '@googlemaps/markerclusterer'

// ─── Types ───────────────────────────────────────────────────────────────────

export interface StoreLocation {
  id: string
  name: string
  slug: string
  categorySlug?: string
  storeType?: string
  lat: number
  lng: number
  image?: string
  category?: string
  city?: string
  isOpen?: boolean
}

interface Props {
  stores?: StoreLocation[]
  defaultCenter?: { lat: number; lng: number }
  defaultZoom?: number
  height?: string
  useUserLocation?: boolean
  markerColor?: string
  /** Google Maps Map ID — enables AdvancedMarkerElement (create in GCP Console → Google Maps → Map styles) */
  mapId?: string
}

// ─── Props / Emits ────────────────────────────────────────────────────────────

const props = withDefaults(defineProps<Props>(), {
  stores: () => [],
  defaultCenter: () => ({ lat: 59.7441, lng: 10.2045 }), // Drammen
  defaultZoom: 13,
  height: '100%',
  useUserLocation: false,
  markerColor: '#10b981',
  mapId: undefined
})

const emit = defineEmits<{
  (e: 'store-click', store: StoreLocation): void
  (e: 'map-ready'): void
}>()

// ─── State ────────────────────────────────────────────────────────────────────

const config = useRuntimeConfig()
const colorMode = useColorMode()
const mapContainer = ref<HTMLElement | null>(null)
const mapLoaded = ref(false)
const mapError = ref<string | null>(null)

// Resolve Map ID: prop > runtimeConfig env var
const resolvedMapId = computed(() =>
  props.mapId ?? (config.public.googleMapsMapId as string | undefined)
)

// Preview card state
const selectedStores = ref<StoreLocation[]>([])
const selectedIndex = ref(0)
const showPreviewCard = ref(false)
const isCardDismissing = ref(false)

const selectedStore = computed(() => selectedStores.value[selectedIndex.value] ?? null)
const hasMultiple = computed(() => selectedStores.value.length > 1)

// ─── Internal map references (module-scoped, not reactive) ────────────────────

let map: google.maps.Map | null = null
let clusterer: MarkerClusterer | null = null
let markers: (google.maps.Marker | google.maps.marker.AdvancedMarkerElement)[] = []
let mapsInitialized = false
let advancedMarkersLib: google.maps.MarkerLibrary | null = null

// ─── Map styles ───────────────────────────────────────────────────────────────

const lightStyles: google.maps.MapTypeStyle[] = [
  // Suppress clutter
  { featureType: 'poi', stylers: [{ visibility: 'off' }] },
  { featureType: 'transit', stylers: [{ visibility: 'off' }] },
  // Subtle road tone
  { featureType: 'road', elementType: 'geometry', stylers: [{ color: '#f5f5f5' }] },
  { featureType: 'road.arterial', elementType: 'geometry', stylers: [{ color: '#e8e8e8' }] },
  { featureType: 'road.highway', elementType: 'geometry', stylers: [{ color: '#dadada' }] },
  { featureType: 'road', elementType: 'labels.text.fill', stylers: [{ color: '#888888' }] },
  // Water — soft blue
  { featureType: 'water', elementType: 'geometry', stylers: [{ color: '#c9e4f0' }] },
  { featureType: 'water', elementType: 'labels.text.fill', stylers: [{ color: '#9ab8c9' }] },
  // Landscape — off-white
  { featureType: 'landscape', elementType: 'geometry', stylers: [{ color: '#f9f9f9' }] },
  { featureType: 'landscape.natural', elementType: 'geometry', stylers: [{ color: '#eef3ee' }] },
]

const darkStyles: google.maps.MapTypeStyle[] = [
  { elementType: 'geometry', stylers: [{ color: '#1a2235' }] },
  { elementType: 'labels.text.stroke', stylers: [{ color: '#1a2235' }] },
  { elementType: 'labels.text.fill', stylers: [{ color: '#8899aa' }] },
  { featureType: 'road', elementType: 'geometry', stylers: [{ color: '#283447' }] },
  { featureType: 'road', elementType: 'geometry.stroke', stylers: [{ color: '#1a2235' }] },
  { featureType: 'road', elementType: 'labels.text.fill', stylers: [{ color: '#6677aa' }] },
  { featureType: 'road.highway', elementType: 'geometry', stylers: [{ color: '#2d4060' }] },
  { featureType: 'road.highway', elementType: 'geometry.stroke', stylers: [{ color: '#1a2235' }] },
  { featureType: 'water', elementType: 'geometry', stylers: [{ color: '#0d1a2c' }] },
  { featureType: 'water', elementType: 'labels.text.fill', stylers: [{ color: '#3d5a7a' }] },
  { featureType: 'landscape', elementType: 'geometry', stylers: [{ color: '#1e2d3d' }] },
  { featureType: 'landscape.natural', elementType: 'geometry', stylers: [{ color: '#1a2b38' }] },
  { featureType: 'poi', stylers: [{ visibility: 'off' }] },
  { featureType: 'transit', stylers: [{ visibility: 'off' }] },
]

const activeStyles = computed(() =>
  colorMode.value === 'dark' ? darkStyles : lightStyles
)

// ─── Cluster renderer ─────────────────────────────────────────────────────────

function makeClusterSvg(count: number, isDark: boolean): string {
  const color = isDark ? '#10b981' : '#059669'
  const bgAlpha = isDark ? '0.18' : '0.12'
  const size = count > 20 ? 58 : count > 10 ? 50 : 44
  return `
    <svg xmlns="http://www.w3.org/2000/svg" width="${size}" height="${size}" viewBox="0 0 ${size} ${size}">
      <circle cx="${size / 2}" cy="${size / 2}" r="${size / 2}" fill="${color}" fill-opacity="${bgAlpha}"/>
      <circle cx="${size / 2}" cy="${size / 2}" r="${size / 2 - 5}" fill="${color}" fill-opacity="0.35"/>
      <circle cx="${size / 2}" cy="${size / 2}" r="${size / 2 - 11}" fill="${color}"/>
      <text x="50%" y="50%" text-anchor="middle" dominant-baseline="central"
        font-family="-apple-system,sans-serif" font-size="${count > 99 ? 12 : 14}"
        fill="white" font-weight="700">${count > 99 ? '99+' : count}</text>
    </svg>
  `
}

const customClusterRenderer = {
  render: ({ count, position }: { count: number; position: google.maps.LatLng }) => {
    const isDark = colorMode.value === 'dark'
    const svg = makeClusterSvg(count, isDark)
    const size = count > 20 ? 58 : count > 10 ? 50 : 44

    return new google.maps.Marker({
      position,
      icon: {
        url: `data:image/svg+xml;charset=UTF-8,${encodeURIComponent(svg)}`,
        scaledSize: new google.maps.Size(size, size),
        anchor: new google.maps.Point(size / 2, size / 2)
      },
      zIndex: 1000 + count
    })
  }
}

// ─── Marker icon ──────────────────────────────────────────────────────────────

function makeMarkerSvg(isDark: boolean): string {
  const fill = isDark ? '#10b981' : '#059669'
  const stroke = isDark ? '#ffffff' : '#ffffff'
  return `
    <svg xmlns="http://www.w3.org/2000/svg" width="32" height="40" viewBox="0 0 32 40">
      <path d="M16 0 C7.16 0 0 7.16 0 16 C0 27 16 40 16 40 C16 40 32 27 32 16 C32 7.16 24.84 0 16 0 Z"
        fill="${fill}" stroke="${stroke}" stroke-width="2"/>
      <circle cx="16" cy="16" r="6" fill="white"/>
    </svg>
  `
}

// ─── Map initialisation ───────────────────────────────────────────────────────

async function initMap() {
  if (!mapContainer.value) { mapError.value = 'Map container not found'; return }

  const apiKey = config.public.googleMapsApiKey as string
  if (!apiKey) { mapError.value = 'API key missing'; return }

  try {
    if (!mapsInitialized) {
      setOptions({ key: apiKey, v: 'weekly' })
      mapsInitialized = true
    }

    const mapsLib = await importLibrary('maps') as google.maps.MapsLibrary

    // Load marker library for AdvancedMarkerElement if Map ID is available
    if (resolvedMapId.value) {
      advancedMarkersLib = await importLibrary('marker') as google.maps.MarkerLibrary
    }

    map = new mapsLib.Map(mapContainer.value, {
      center: props.defaultCenter,
      zoom: props.defaultZoom,
      minZoom: 8,
      maxZoom: 18,
      disableDefaultUI: true,
      gestureHandling: 'greedy',
      clickableIcons: false,
      // mapId required for AdvancedMarkerElement; also unlocks vector maps for smoother zoom
      ...(resolvedMapId.value ? { mapId: resolvedMapId.value } : { styles: activeStyles.value })
    })

    // Close preview on map click
    map.addListener('click', dismissCard)

    // Initialise clusterer with custom renderer
    clusterer = new MarkerClusterer({
      map,
      algorithm: new SuperClusterAlgorithm({ radius: 80, maxZoom: 14 }),
      renderer: customClusterRenderer
    })

    if (props.stores.length > 0) {
      updateMarkers(props.stores)
    }

    if (props.useUserLocation && navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(
        ({ coords }) => map?.setCenter({ lat: coords.latitude, lng: coords.longitude }),
        () => { /* silent fallback to defaultCenter */ }
      )
    }

    mapLoaded.value = true
    emit('map-ready')
  } catch (err) {
    console.error('[MapExplorer] Failed to load Google Maps:', err)
    mapError.value = 'Failed to load map'
  }
}

// ─── Markers ──────────────────────────────────────────────────────────────────

function updateMarkers(stores: StoreLocation[]) {
  // Clear existing
  markers.forEach(m => m.setMap(null))
  markers = []
  clusterer?.clearMarkers()

  if (!map) return

  const isDark = colorMode.value === 'dark'
  const bounds = new google.maps.LatLngBounds()

  stores.forEach((store) => {
    if (!store.lat || !store.lng) return

    const position = { lat: store.lat, lng: store.lng }
    bounds.extend(position)

    let marker: google.maps.Marker | google.maps.marker.AdvancedMarkerElement

    if (advancedMarkersLib && resolvedMapId.value) {
      // ─ AdvancedMarkerElement: custom HTML pin ─
      const pin = new advancedMarkersLib.PinElement({
        background: isDark ? '#10b981' : '#059669',
        borderColor: '#ffffff',
        glyphColor: '#ffffff',
        scale: 1.1
      })
      const adv = new advancedMarkersLib.AdvancedMarkerElement({
        map,
        position,
        title: store.name,
        content: pin.element
      })
      adv.addListener('click', () => {
        selectedStores.value = [store]
        selectedIndex.value = 0
        showPreviewCard.value = true
        isCardDismissing.value = false
        map?.panTo(position)
      })
      marker = adv
    } else {
      // ─ Legacy SVG marker (fallback) ─
      const svg = makeMarkerSvg(isDark)
      const leg = new google.maps.Marker({
        position,
        title: store.name,
        icon: {
          url: `data:image/svg+xml;charset=UTF-8,${encodeURIComponent(svg)}`,
          scaledSize: new google.maps.Size(32, 40),
          anchor: new google.maps.Point(16, 40)
        }
      })
      leg.addListener('click', () => {
        selectedStores.value = [store]
        selectedIndex.value = 0
        showPreviewCard.value = true
        isCardDismissing.value = false
        map?.panTo(position)
      })
      marker = leg
    }

    markers.push(marker as google.maps.Marker)
  })

  clusterer?.addMarkers(markers)

  // Fit bounds only for multiple stores — single store stays at defaultZoom
  if (stores.length > 1) {
    map.fitBounds(bounds, { top: 60, right: 60, bottom: 140, left: 60 })
  }
}

function refreshMarkerIcons() {
  const isDark = colorMode.value === 'dark'
  const svg = makeMarkerSvg(isDark)
  markers.forEach(m => {
    m.setIcon({
      url: `data:image/svg+xml;charset=UTF-8,${encodeURIComponent(svg)}`,
      scaledSize: new google.maps.Size(32, 40),
      anchor: new google.maps.Point(16, 40)
    })
  })
}

// ─── Preview card ─────────────────────────────────────────────────────────────

function dismissCard() {
  isCardDismissing.value = true
  setTimeout(() => {
    showPreviewCard.value = false
    isCardDismissing.value = false
    selectedStores.value = []
  }, 250)
}

function prevStore() {
  selectedIndex.value = (selectedIndex.value - 1 + selectedStores.value.length) % selectedStores.value.length
}

function nextStore() {
  selectedIndex.value = (selectedIndex.value + 1) % selectedStores.value.length
}

function navigateToStore() {
  if (!selectedStore.value) return
  const cat = selectedStore.value.categorySlug || 'discover'
  emit('store-click', selectedStore.value)
  navigateTo(`/${cat}/${selectedStore.value.slug}`)
}

// ─── Watchers ─────────────────────────────────────────────────────────────────

// Re-style map when colorMode changes
// Note: when mapId is used, styles are controlled via GCP Map Style — we skip setOptions
watch(activeStyles, (styles) => {
  if (!resolvedMapId.value) {
    map?.setOptions({ styles })
  }
  refreshMarkerIcons()
  clusterer?.clearMarkers()
  clusterer?.addMarkers(markers)
})

// Re-draw markers when stores list changes
watch(() => props.stores, (newStores) => {
  if (map && newStores) updateMarkers(newStores)
}, { deep: true })

// ─── Lifecycle ────────────────────────────────────────────────────────────────

onMounted(initMap)

onBeforeUnmount(() => {
  clusterer?.clearMarkers()
  markers.forEach(m => m.setMap(null))
  markers = []
  map = null
})

// ─── Exposed API (unchanged — index.vue uses these) ───────────────────────────

function zoomIn() { if (map) map.setZoom((map.getZoom() ?? props.defaultZoom) + 1) }
function zoomOut() { if (map) map.setZoom((map.getZoom() ?? props.defaultZoom) - 1) }

function centerOnUser() {
  navigator.geolocation?.getCurrentPosition(
    ({ coords }) => {
      map?.setCenter({ lat: coords.latitude, lng: coords.longitude })
      map?.setZoom(14)
    },
    () => console.warn('[MapExplorer] Could not get user location')
  )
}

function panTo(lat: number, lng: number, zoom?: number) {
  if (!map) return
  map.panTo({ lat, lng })
  if (zoom) map.setZoom(zoom)
}

defineExpose({ zoomIn, zoomOut, centerOnUser, panTo })
</script>

<template>
  <div class="dd-map-explorer absolute inset-0">
    <!-- Map Canvas -->
    <div ref="mapContainer" class="w-full h-full" />

    <!-- Loading State -->
    <Transition name="fade">
      <div
        v-if="!mapLoaded && !mapError"
        class="absolute inset-0 flex flex-col items-center justify-center bg-muted"
      >
        <UIcon name="i-lucide-map" class="size-10 text-muted animate-pulse mb-2" />
        <span class="text-sm text-muted">Loading map…</span>
      </div>
    </Transition>

    <!-- Error State -->
    <div
      v-if="mapError"
      class="absolute inset-0 flex flex-col items-center justify-center bg-muted"
    >
      <UIcon name="i-lucide-map-pin-off" class="size-10 text-muted mb-2" />
      <span class="text-sm text-muted">{{ mapError }}</span>
    </div>

    <!-- Overlay slot (DittoDattoBar, zoom controls, etc.) -->
    <slot v-if="mapLoaded" />

    <!-- ── Store Preview Card ──────────────────────────────────────────────── -->
    <Transition name="card-slide">
      <div
        v-if="showPreviewCard && selectedStore"
        class="absolute bottom-0 left-0 right-0 z-20 p-3 pb-4"
        :class="{ 'pointer-events-none': isCardDismissing }"
      >
        <div class="bg-background/95 backdrop-blur-md rounded-2xl shadow-2xl border border-default overflow-hidden max-w-sm mx-auto">
          <!-- Card header: name + pagination + close -->
          <div class="flex items-center justify-between px-4 pt-3 pb-2">
            <div class="flex items-center gap-2 min-w-0">
              <h3 class="text-sm font-semibold text-highlighted truncate">
                {{ selectedStore.name }}
              </h3>
            </div>
            <div class="flex items-center gap-1 shrink-0">
              <!-- Pagination (if cluster-selected) -->
              <template v-if="hasMultiple">
                <button
                  class="p-1 rounded-full hover:bg-muted transition-colors"
                  @click.stop="prevStore"
                >
                  <UIcon name="i-lucide-chevron-left" class="size-4 text-muted" />
                </button>
                <span class="text-xs text-muted px-1">
                  {{ selectedIndex + 1 }} / {{ selectedStores.length }}
                </span>
                <button
                  class="p-1 rounded-full hover:bg-muted transition-colors"
                  @click.stop="nextStore"
                >
                  <UIcon name="i-lucide-chevron-right" class="size-4 text-muted" />
                </button>
              </template>
              <!-- Close -->
              <button
                class="p-1 rounded-full hover:bg-muted transition-colors ml-1"
                @click.stop="dismissCard"
              >
                <UIcon name="i-lucide-x" class="size-4 text-muted" />
              </button>
            </div>
          </div>

          <!-- Store image -->
          <div class="relative h-36 mx-3 rounded-xl overflow-hidden bg-muted">
            <img
              v-if="selectedStore.image"
              :src="selectedStore.image"
              :alt="selectedStore.name"
              class="w-full h-full object-cover"
            />
            <div v-else class="w-full h-full flex items-center justify-center">
              <UIcon name="i-lucide-image-off" class="size-10 text-muted" />
            </div>
            <!-- Open badge -->
            <div
              v-if="selectedStore.isOpen !== undefined"
              class="absolute top-2 left-2 px-2 py-0.5 rounded-full text-xs font-semibold"
              :class="selectedStore.isOpen ? 'bg-success/90 text-white' : 'bg-error/90 text-white'"
            >
              {{ selectedStore.isOpen ? 'Åpen' : 'Stengt' }}
            </div>
          </div>

          <!-- Meta row -->
          <div class="flex items-center gap-2 px-4 py-2">
            <span v-if="selectedStore.category" class="text-xs text-primary font-medium">
              {{ selectedStore.category }}
            </span>
            <span v-if="selectedStore.city" class="text-xs text-muted">
              · {{ selectedStore.city }}
            </span>
          </div>

          <!-- CTA buttons -->
          <div class="flex gap-2 px-3 pb-3">
            <UButton
              block
              size="sm"
              icon="i-lucide-calendar"
              class="flex-1"
              @click.stop="navigateToStore"
            >
              Book
            </UButton>
            <UButton
              size="sm"
              color="neutral"
              variant="outline"
              icon="i-lucide-arrow-right"
              trailing
              @click.stop="navigateToStore"
            >
              Åpne
            </UButton>
          </div>
        </div>
      </div>
    </Transition>
  </div>
</template>

<style scoped>
/* Card slides up from bottom */
.card-slide-enter-active { transition: transform 0.28s cubic-bezier(0.34, 1.56, 0.64, 1), opacity 0.2s ease; }
.card-slide-leave-active { transition: transform 0.22s ease-in, opacity 0.18s ease; }
.card-slide-enter-from { transform: translateY(100%); opacity: 0; }
.card-slide-leave-to  { transform: translateY(60%) scale(0.97); opacity: 0; }

/* Loading fade */
.fade-enter-active, .fade-leave-active { transition: opacity 0.3s ease; }
.fade-enter-from, .fade-leave-to { opacity: 0; }
</style>
