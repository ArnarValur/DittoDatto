<script setup lang="ts">
/**
 * Establishment Image Gallery
 * Displays a hero image gallery with 3 configurable layout modes:
 * - bento: 2/4 cover + 2x2 grid (default)
 * - showcase: 3/4 cover + 1/4 vertical auto-scroll
 * - spotlight: Full-width single cover image
 */

interface StoreImages {
  logo?: string
  cover?: string
  gallery?: string[]
}

interface Props {
  /** Can be legacy array format or new object format */
  images?: string[] | StoreImages
  /** Layout mode: bento, showcase, or spotlight */
  layoutMode?: 'bento' | 'showcase' | 'spotlight'
  loading?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  images: () => [],
  layoutMode: 'bento',
  loading: false
})

// Normalize images to always work with an array
const normalizedImages = computed(() => {
  if (Array.isArray(props.images)) {
    return props.images
  }
  const imgs: string[] = []
  if (props.images?.cover) imgs.push(props.images.cover)
  if (props.images?.gallery) imgs.push(...props.images.gallery)
  return imgs
})

const mainImage = computed(() => normalizedImages.value[0])
const sideImages = computed(() => normalizedImages.value.slice(1, 5))
const scrollImages = computed(() => normalizedImages.value.slice(1))
const totalImages = computed(() => normalizedImages.value.length)

// Container classes based on layout mode
const containerClass = computed(() => {
  switch (props.layoutMode) {
    case 'spotlight':
      return 'grid grid-cols-1'
    case 'showcase':
      return 'grid grid-cols-1 md:grid-cols-4'
    case 'bento':
    default:
      return 'grid grid-cols-1 md:grid-cols-4'
  }
})

// Main image column span based on layout mode
const mainColSpan = computed(() => {
  switch (props.layoutMode) {
    case 'spotlight':
      return 'col-span-1'
    case 'showcase':
      return 'md:col-span-3'
    case 'bento':
    default:
      return 'md:col-span-2'
  }
})

// Showcase mode: CSS-based infinite scroll
const isHovering = ref(false)

// For seamless loop, we need to double the images
const infiniteScrollImages = computed(() => {
  if (scrollImages.value.length < 2) return scrollImages.value
  // Clone images for seamless infinite loop
  return [...scrollImages.value, ...scrollImages.value]
})

// Calculate animation duration based on number of images (slower = smoother)
// ~5 seconds per image for smooth viewing
const animationDuration = computed(() => {
  const imageCount = scrollImages.value.length
  return Math.max(15, imageCount * 5) // Minimum 15s, 5s per image
})

// ── Lightbox ────────────────────────────────────────────────────────────────
const lightboxOpen = ref(false)
const lightboxIndex = ref(0)

function openLightbox(index = 0) {
  lightboxIndex.value = index
  lightboxOpen.value = true
}

function closeLightbox() {
  lightboxOpen.value = false
}

function lightboxPrev() {
  lightboxIndex.value =
    (lightboxIndex.value - 1 + normalizedImages.value.length) % normalizedImages.value.length
}

function lightboxNext() {
  lightboxIndex.value =
    (lightboxIndex.value + 1) % normalizedImages.value.length
}

// Keyboard nav
function onLightboxKeydown(e: KeyboardEvent) {
  if (e.key === 'Escape') closeLightbox()
  if (e.key === 'ArrowLeft') lightboxPrev()
  if (e.key === 'ArrowRight') lightboxNext()
}

watch(lightboxOpen, (open) => {
  if (open) {
    window.addEventListener('keydown', onLightboxKeydown)
    document.body.style.overflow = 'hidden'
  } else {
    window.removeEventListener('keydown', onLightboxKeydown)
    document.body.style.overflow = ''
  }
})

// Touch swipe support
const touchStartX = ref(0)
const touchStartY = ref(0)

function onTouchStart(e: TouchEvent) {
  touchStartX.value = e.touches[0]?.clientX ?? 0
  touchStartY.value = e.touches[0]?.clientY ?? 0
}

function onTouchEnd(e: TouchEvent) {
  const dx = (e.changedTouches[0]?.clientX ?? 0) - touchStartX.value
  const dy = (e.changedTouches[0]?.clientY ?? 0) - touchStartY.value
  // Only swipe if horizontal movement > vertical (avoid scroll conflicts)
  if (Math.abs(dx) > 50 && Math.abs(dx) > Math.abs(dy)) {
    if (dx > 0) lightboxPrev()
    else lightboxNext()
  }
}
</script>

<template>
  <div
    class="w-full h-[400px] md:h-[500px] gap-2 rounded-xl overflow-hidden relative group"
    :class="containerClass"
  >
    <!-- Skeleton Loading -->
    <template v-if="loading">
      <USkeleton class="w-full h-full" :class="mainColSpan" />
      <div v-if="layoutMode !== 'spotlight'" class="hidden md:grid col-span-1 gap-2 h-full" :class="layoutMode === 'bento' ? 'grid-cols-2 col-span-2' : 'grid-cols-1'">
        <USkeleton v-for="i in (layoutMode === 'bento' ? 4 : 3)" :key="i" class="w-full h-full" />
      </div>
    </template>

    <!-- Content -->
    <template v-else>
      <!-- Main Image (with overflow-hidden to contain scale) -->
      <div class="relative h-full overflow-hidden cursor-pointer" :class="mainColSpan" @click="openLightbox(0)">
        <NuxtImg
          v-if="mainImage"
          :src="mainImage"
          alt="Main establishment image"
          class="w-full h-full object-cover hover:scale-105 transition-transform duration-500"
          sizes="(max-width: 768px) 100vw, 75vw"
          placeholder
        />
        <div v-else class="w-full h-full bg-gray-100 dark:bg-gray-800 flex items-center justify-center">
          <UIcon name="i-lucide-image" class="size-12 text-gray-400" />
        </div>
      </div>

      <!-- Bento Mode: 2x2 Grid -->
      <div v-if="layoutMode === 'bento'" class="hidden md:grid col-span-2 grid-cols-2 gap-2 h-full">
        <template v-for="(img, index) in sideImages" :key="index">
          <div class="relative w-full h-full overflow-hidden cursor-pointer" @click="openLightbox(index + 1)">
            <NuxtImg
              :src="img"
              alt="Gallery image"
              class="w-full h-full object-cover hover:scale-105 transition-transform duration-500"
              loading="lazy"
              sizes="25vw"
              placeholder
            />
          <div
              v-if="index === 3 && totalImages > 5"
              class="absolute inset-0 bg-black/50 flex items-center justify-center cursor-pointer"
              @click.stop="openLightbox(4)"
            >
              <span class="text-white font-medium flex items-center gap-2">
                <UIcon name="i-lucide-grid" class="size-5" />
                View all photos ({{ totalImages }})
              </span>
            </div>
          </div>
        </template>

        <template v-if="sideImages.length < 4">
          <div
            v-for="i in (4 - sideImages.length)"
            :key="`placeholder-${i}`"
            class="bg-gray-100 dark:bg-gray-800 flex items-center justify-center"
          >
            <UIcon name="i-lucide-image" class="size-8 text-gray-400" />
          </div>
        </template>
      </div>

      <!-- Showcase Mode: Seamless Infinite Scroll Strip -->
      <div
        v-if="layoutMode === 'showcase'"
        class="hidden md:block col-span-1 h-full overflow-hidden relative"
        @mouseenter="isHovering = true"
        @mouseleave="isHovering = false"
      >
        <!-- Empty state -->
        <template v-if="scrollImages.length === 0">
          <div class="flex flex-col gap-2 h-full">
            <div
              v-for="i in 3"
              :key="`placeholder-${i}`"
              class="w-full shrink-0 h-1/3 bg-gray-100 dark:bg-gray-800 flex items-center justify-center rounded-lg"
            >
              <UIcon name="i-lucide-image" class="size-8 text-gray-400" />
            </div>
          </div>
        </template>

        <!-- Infinite scroll track -->
        <div
          v-else
          class="carousel-track flex flex-col gap-2"
          :class="{ 'paused': isHovering }"
          :style="{ animationDuration: `${animationDuration}s` }"
        >
          <div
            v-for="(img, index) in infiniteScrollImages"
            :key="`scroll-${index}`"
            class="relative w-full shrink-0 aspect-4/3 overflow-hidden rounded-lg"
          >
            <NuxtImg
              :src="img"
              alt="Gallery image"
              class="w-full h-full object-cover hover:scale-105 transition-transform duration-500"
              loading="lazy"
              sizes="25vw"
            />
          </div>
        </div>

        <!-- Gradient overlays for smooth visual fade -->
        <div class="absolute inset-x-0 top-0 h-8 bg-linear-to-b from-black/30 to-transparent pointer-events-none" />
        <div class="absolute inset-x-0 bottom-0 h-8 bg-linear-to-t from-black/30 to-transparent pointer-events-none" />
      </div>

      <!-- Spotlight Mode: Gallery button overlay (desktop only — mobile uses the right-side button) -->
      <div
        v-if="layoutMode === 'spotlight' && totalImages > 1"
        class="absolute bottom-4 left-4 hidden md:block"
      >
        <UButton
          icon="i-lucide-images"
          color="neutral"
          variant="solid"
          size="sm"
          @click="openLightbox(0)"
        >
          View {{ totalImages }} Photos
        </UButton>
      </div>

      <!-- Mobile Button overlay -->
      <div class="absolute bottom-4 right-4 md:hidden">
        <UButton
          icon="i-lucide-grid"
          color="neutral"
          variant="solid"
          size="sm"
          @click="openLightbox(0)"
        >
          View Photos
        </UButton>
      </div>

      <!-- TODO: Action Buttons Overlay (Top Right) -->
    </template>
  </div>

  <!-- ═══ Lightbox Overlay ═══ -->
  <Teleport to="body">
    <Transition name="lightbox">
      <div
        v-if="lightboxOpen"
        class="fixed inset-0 z-[9999] bg-black/95 flex items-center justify-center"
        @click.self="closeLightbox"
        @touchstart="onTouchStart"
        @touchend="onTouchEnd"
      >
        <!-- Close -->
        <button
          class="absolute top-4 right-4 z-10 p-2 rounded-full bg-white/10 hover:bg-white/20 text-white transition-colors"
          @click="closeLightbox"
        >
          <UIcon name="i-lucide-x" class="size-6" />
        </button>

        <!-- Counter -->
        <div class="absolute top-4 left-4 z-10 text-white/70 text-sm font-medium">
          {{ lightboxIndex + 1 }} / {{ normalizedImages.length }}
        </div>

        <!-- Previous -->
        <button
          v-if="normalizedImages.length > 1"
          class="absolute left-2 md:left-4 z-10 p-2 rounded-full bg-white/10 hover:bg-white/20 text-white transition-colors"
          @click.stop="lightboxPrev"
        >
          <UIcon name="i-lucide-chevron-left" class="size-6" />
        </button>

        <!-- Image -->
        <div class="max-w-[90vw] max-h-[85vh] flex items-center justify-center">
          <NuxtImg
            :key="lightboxIndex"
            :src="normalizedImages[lightboxIndex]"
            alt="Gallery image"
            class="max-w-full max-h-[85vh] object-contain rounded-lg select-none lightbox-image"
            sizes="90vw"
          />
        </div>

        <!-- Next -->
        <button
          v-if="normalizedImages.length > 1"
          class="absolute right-2 md:right-4 z-10 p-2 rounded-full bg-white/10 hover:bg-white/20 text-white transition-colors"
          @click.stop="lightboxNext"
        >
          <UIcon name="i-lucide-chevron-right" class="size-6" />
        </button>

        <!-- Thumbnail strip (desktop only) -->
        <div v-if="normalizedImages.length > 1" class="hidden md:flex absolute bottom-4 left-1/2 -translate-x-1/2 gap-2 max-w-[80vw] overflow-x-auto p-2 rounded-xl bg-black/50 backdrop-blur-sm">
          <button
            v-for="(img, i) in normalizedImages"
            :key="i"
            class="shrink-0 w-16 h-12 rounded-md overflow-hidden ring-2 transition-all"
            :class="i === lightboxIndex ? 'ring-primary-500 opacity-100' : 'ring-transparent opacity-50 hover:opacity-80'"
            @click.stop="lightboxIndex = i"
          >
            <NuxtImg :src="img" alt="" class="w-full h-full object-cover" sizes="64px" />
          </button>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<style scoped>
/* Seamless infinite scroll carousel */
.carousel-track {
  animation: scroll-up linear infinite;
}

.carousel-track.paused {
  animation-play-state: paused;
}

@keyframes scroll-up {
  0% {
    transform: translateY(0);
  }
  100% {
    /* Scroll exactly 50% (first set of images) for seamless loop */
    transform: translateY(-50%);
  }
}

/* Smooth hover transition for pause */
.carousel-track {
  transition: animation-play-state 0.3s ease;
}

/* Lightbox transitions */
.lightbox-enter-active,
.lightbox-leave-active {
  transition: opacity 0.25s ease;
}
.lightbox-enter-from,
.lightbox-leave-to {
  opacity: 0;
}

.lightbox-image {
  animation: lightbox-fade-in 0.2s ease;
}

@keyframes lightbox-fade-in {
  from { opacity: 0; transform: scale(0.95); }
  to { opacity: 1; transform: scale(1); }
}
</style>
