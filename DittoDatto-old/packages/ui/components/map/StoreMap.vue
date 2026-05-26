<script setup lang="ts">
/**
 * StoreMap - Interactive Google Map for store locations
 * Uses Google Maps JavaScript API with @googlemaps/js-api-loader v2.x
 * 
 * Usage:
 * <ClientOnly>
 *   <DDMapStoreMap :lat="59.7441" :lng="10.2045" popup-name="My Store" />
 * </ClientOnly>
 */
import { setOptions, importLibrary } from '@googlemaps/js-api-loader'

interface Props {
  lat: number
  lng: number
  popupName?: string
  zoom?: number
  height?: string
  showDirectionsButton?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  popupName: 'We are here!',
  zoom: 16,
  height: '300px',
  showDirectionsButton: true
})

const config = useRuntimeConfig()
const mapContainer = ref<HTMLElement | null>(null)
const mapLoaded = ref(false)
const mapError = ref<string | null>(null)

let map: google.maps.Map | null = null
let marker: google.maps.Marker | null = null

// Google Maps directions URL
const directionsUrl = computed(() => 
  `https://www.google.com/maps/dir/?api=1&destination=${props.lat},${props.lng}`
)

// Initialize Google Maps once
let mapsInitialized = false

onMounted(async () => {
  console.log('[StoreMap] Mounting with coords:', props.lat, props.lng)
  
  if (!mapContainer.value) {
    console.error('[StoreMap] No map container ref')
    mapError.value = 'Map container not found'
    return
  }
  
  if (!props.lat || !props.lng) {
    console.error('[StoreMap] Invalid coordinates:', props.lat, props.lng)
    mapError.value = 'Invalid coordinates'
    return
  }

  const apiKey = config.public.googleMapsApiKey as string
  if (!apiKey) {
    console.error('[StoreMap] No API key found')
    mapError.value = 'API key missing'
    return
  }

  try {
    console.log('[StoreMap] Loading Google Maps...')
    
    // Set options only once (new v2.x API)
    if (!mapsInitialized) {
      setOptions({ key: apiKey, v: 'weekly' })
      mapsInitialized = true
    }
    
    // Import libraries
    const mapsLib = await importLibrary('maps') as google.maps.MapsLibrary
    
    console.log('[StoreMap] Google Maps loaded successfully')

    // Initialize map with dark mode styling
    map = new mapsLib.Map(mapContainer.value, {
      center: { lat: props.lat, lng: props.lng },
      zoom: props.zoom,
      disableDefaultUI: false,
      zoomControl: true,
      mapTypeControl: false,
      streetViewControl: false,
      fullscreenControl: true,
      styles: [
        { elementType: 'geometry', stylers: [{ color: '#242f3e' }] },
        { elementType: 'labels.text.stroke', stylers: [{ color: '#242f3e' }] },
        { elementType: 'labels.text.fill', stylers: [{ color: '#746855' }] },
        { featureType: 'road', elementType: 'geometry', stylers: [{ color: '#38414e' }] },
        { featureType: 'road', elementType: 'geometry.stroke', stylers: [{ color: '#212a37' }] },
        { featureType: 'water', elementType: 'geometry', stylers: [{ color: '#17263c' }] },
        { featureType: 'poi', stylers: [{ visibility: 'off' }] },
        { featureType: 'transit', stylers: [{ visibility: 'off' }] }
      ]
    })

    // Add standard marker (AdvancedMarkerElement requires Map ID)
    marker = new google.maps.Marker({
      map,
      position: { lat: props.lat, lng: props.lng },
      title: props.popupName,
      icon: {
        path: google.maps.SymbolPath.CIRCLE,
        scale: 10,
        fillColor: '#10b981',
        fillOpacity: 1,
        strokeColor: '#ffffff',
        strokeWeight: 3
      }
    })

    mapLoaded.value = true
    console.log('[StoreMap] Map initialized successfully')
  } catch (err) {
    console.error('[StoreMap] Failed to load Google Maps:', err)
    mapError.value = 'Failed to load map'
  }
})

onBeforeUnmount(() => {
  if (marker) {
    if ('setMap' in marker) {
      (marker as google.maps.Marker).setMap(null)
    }
    marker = null
  }
  map = null
})
</script>

<template>
  <div 
    class="dd-store-map-wrapper relative rounded-xl overflow-hidden shadow-sm border border-gray-200 dark:border-gray-700 w-full"
    :style="{ height, minHeight: height === '100%' ? '250px' : undefined }"
  >
    <!-- Map Container -->
    <div 
      ref="mapContainer" 
      class="w-full h-full absolute inset-0"
    />

    <!-- Loading State -->
    <div 
      v-if="!mapLoaded && !mapError" 
      class="absolute inset-0 flex flex-col items-center justify-center bg-gray-100 dark:bg-gray-800"
    >
      <UIcon name="i-lucide-map" class="size-10 text-gray-400 animate-pulse mb-2" />
      <span class="text-sm text-gray-500">Loading map...</span>
    </div>

    <!-- Error State -->
    <div 
      v-if="mapError" 
      class="absolute inset-0 flex flex-col items-center justify-center bg-gray-100 dark:bg-gray-800"
    >
      <UIcon name="i-lucide-map-pin-off" class="size-10 text-gray-400 mb-2" />
      <span class="text-sm text-gray-500">{{ mapError }}</span>
    </div>

    <!-- Directions Button -->
    <a
      v-if="showDirectionsButton && mapLoaded"
      :href="directionsUrl"
      target="_blank"
      rel="noopener noreferrer"
      class="absolute bottom-4 right-4 z-10 bg-white dark:bg-gray-900 text-gray-800 dark:text-white px-4 py-2 rounded-full text-sm font-medium shadow-lg hover:shadow-xl transition-shadow flex items-center gap-2 border border-gray-200 dark:border-gray-700"
    >
      <UIcon name="i-lucide-navigation" class="size-4 text-primary" />
      Directions
    </a>
  </div>
</template>
