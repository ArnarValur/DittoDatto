<script setup lang="ts">
/**
 * DDDittoBar — DittoDatto Search Bar
 *
 * A 3-state search component for the public marketplace frontpage.
 * States: idle → searching → results
 *
 * Replaces the static search pill on the map hero.
 */
import type { DittoSearchStoreResult, DittoSearchCategoryResult } from '~/composables/useDittoSearch'

const props = defineProps<{
  stores: any[] | undefined
  categories: any[] | undefined
}>()

const emit = defineEmits<{
  'focus-store': [payload: { lat: number; lng: number }]
}>()

const { t } = useI18n()
const { resolve: getCategoryIcon } = useCategoryIcon()

// Convert props to refs for the composable
const storesRef = toRef(props, 'stores')
const categoriesRef = toRef(props, 'categories')

const {
  query,
  debouncedQuery,
  isSearching,
  categoryMatches,
  storeMatches,
  allResults,
  hasResults,
  currentResult,
  selectedResultIndex,
  selectNext,
  selectPrev,
  clearSearch,
  logResultSelected
} = useDittoSearch(storesRef, categoriesRef)

// State machine: idle | searching | results
type DittoBarState = 'idle' | 'searching' | 'results'
const barState = ref<DittoBarState>('idle')

const inputRef = ref<HTMLInputElement | null>(null)
const barRef = ref<HTMLElement | null>(null)

// Rotating placeholder
const placeholders = computed(() => [
  t('dittobar.placeholder1', 'Søk etter tjenester...'),
  t('dittobar.placeholder2', 'Frisør i nærheten?'),
  t('dittobar.placeholder3', 'Hva trenger du i dag?')
])
const currentPlaceholderIndex = ref(0)
const placeholderVisible = ref(true)

let placeholderInterval: ReturnType<typeof setInterval> | null = null

function startPlaceholderRotation() {
  if (placeholderInterval) return
  placeholderInterval = setInterval(() => {
    placeholderVisible.value = false
    setTimeout(() => {
      currentPlaceholderIndex.value =
        (currentPlaceholderIndex.value + 1) % placeholders.value.length
      placeholderVisible.value = true
    }, 300)
  }, 3000)
}

function stopPlaceholderRotation() {
  if (placeholderInterval) {
    clearInterval(placeholderInterval)
    placeholderInterval = null
  }
}

onMounted(() => startPlaceholderRotation())
onUnmounted(() => stopPlaceholderRotation())

// State transitions
function activateSearch() {
  barState.value = 'searching'
  stopPlaceholderRotation()
  nextTick(() => inputRef.value?.focus())
}

function deactivateSearch() {
  if (query.value.trim()) return
  barState.value = 'idle'
  clearSearch()
  startPlaceholderRotation()
}

function enterResultsState(storeResult: DittoSearchStoreResult) {
  // Find the store index in allResults
  const idx = allResults.value.findIndex(r => r.id === storeResult.id)
  if (idx >= 0) selectedResultIndex.value = idx
  barState.value = 'results'

  // Analytics: log store selection
  logResultSelected({ type: 'store', id: storeResult.id, name: storeResult.name })

  // Pan map to store
  if (storeResult.lat && storeResult.lng) {
    emit('focus-store', { lat: storeResult.lat, lng: storeResult.lng })
  }
}

function navigateToCategory(cat: DittoSearchCategoryResult) {
  logResultSelected({ type: 'category', id: cat.id, name: cat.name })
  navigateTo(`/discover?category=${cat.slug}`)
}

function navigateToStore(store: DittoSearchStoreResult) {
  navigateTo(`/${store.categorySlug}/${store.slug}`)
}

function bookStore(store: DittoSearchStoreResult) {
  navigateTo(`/${store.categorySlug}/${store.slug}`)
}

function backToIdle() {
  barState.value = 'idle'
  clearSearch()
  startPlaceholderRotation()
}

// Watch currentResult to emit map focus
watch(currentResult, (result) => {
  if (result?.lat && result?.lng && barState.value === 'results') {
    emit('focus-store', { lat: result.lat, lng: result.lng })
  }
})

// Keyboard navigation
function handleKeydown(e: KeyboardEvent) {
  if (e.key === 'Escape') {
    if (barState.value === 'results') {
      backToIdle()
    } else {
      deactivateSearch()
    }
    inputRef.value?.blur()
  }
  if (e.key === 'Enter' && storeMatches.value.length > 0 && barState.value === 'searching') {
    enterResultsState(storeMatches.value[0])
  }
}

// Click outside to close — use mousedown to avoid race with v-if DOM swap
function handleClickOutside(e: MouseEvent) {
  if (barRef.value && !barRef.value.contains(e.target as Node)) {
    if (barState.value === 'searching' && !query.value.trim()) {
      deactivateSearch()
    }
  }
}

onMounted(() => document.addEventListener('mousedown', handleClickOutside))
onUnmounted(() => document.removeEventListener('mousedown', handleClickOutside))

// Show autocomplete dropdown
const showDropdown = computed(() =>
  barState.value === 'searching' &&
  debouncedQuery.value.length >= 2 &&
  hasResults.value
)

// Floating position for teleported overlays
const floatingPos = ref({ top: 0, left: 0, width: 0 })

function updateFloatingPos() {
  if (!barRef.value) return
  const rect = barRef.value.getBoundingClientRect()
  floatingPos.value = {
    top: rect.bottom + 8 + window.scrollY,
    left: rect.left + window.scrollX,
    width: rect.width
  }
}

const floatingStyle = computed(() => ({
  position: 'absolute' as const,
  top: `${floatingPos.value.top}px`,
  left: `${floatingPos.value.left}px`,
  width: `${floatingPos.value.width}px`,
  zIndex: 9999
}))

// Update position when state changes or on scroll/resize
watch([barState, showDropdown], () => {
  nextTick(updateFloatingPos)
})

let rafId: number | null = null
function onScrollOrResize() {
  if (rafId) cancelAnimationFrame(rafId)
  rafId = requestAnimationFrame(updateFloatingPos)
}

onMounted(() => {
  window.addEventListener('scroll', onScrollOrResize, true)
  window.addEventListener('resize', onScrollOrResize)
})
onUnmounted(() => {
  window.removeEventListener('scroll', onScrollOrResize, true)
  window.removeEventListener('resize', onScrollOrResize)
  if (rafId) cancelAnimationFrame(rafId)
})
</script>

<template>
  <div ref="barRef" class="dittobar-container">
    <!-- ═══════════════ STATE 1: IDLE ═══════════════ -->
    <div
      v-if="barState === 'idle'"
      class="dittobar-pill"
      role="button"
      tabindex="0"
      @click.stop="activateSearch"
      @keydown.enter="activateSearch"
    >
      <div class="dittobar-icon dittobar-icon--pulse">
        <UIcon name="i-lucide-search" class="size-5 text-primary" />
      </div>

      <div class="dittobar-placeholder-area">
        <Transition name="dittobar-fade" mode="out-in">
          <span
            :key="currentPlaceholderIndex"
            class="dittobar-placeholder-text"
          >
            {{ placeholders[currentPlaceholderIndex] }}
          </span>
        </Transition>
      </div>

      <div class="dittobar-icon">
        <UIcon name="i-lucide-mic" class="size-5 text-dimmed" />
      </div>
    </div>

    <!-- ═══════════════ STATE 2: SEARCHING ═══════════════ -->
    <div
      v-else-if="barState === 'searching'"
      class="dittobar-pill dittobar-pill--active"
    >
      <div class="dittobar-icon">
        <UIcon
          :name="isSearching ? 'i-lucide-loader-circle' : 'i-lucide-search'"
          :class="['size-5 text-primary', { 'animate-spin': isSearching }]"
        />
      </div>

      <input
        ref="inputRef"
        v-model="query"
        type="text"
        class="dittobar-input"
        :placeholder="t('dittobar.searchPlaceholder', 'Søk...')"
        @keydown="handleKeydown"
      >

      <button
        v-if="query"
        class="dittobar-icon dittobar-icon--button"
        @click="clearSearch(); deactivateSearch()"
      >
        <UIcon name="i-lucide-x" class="size-5 text-dimmed hover:text-default transition-colors" />
      </button>
      <div v-else class="dittobar-icon">
        <UIcon name="i-lucide-mic" class="size-5 text-dimmed" />
      </div>
    </div>

    <!-- ═══════════════ STATE 3: RESULTS ═══════════════ -->
    <div
      v-else-if="barState === 'results'"
      class="dittobar-pill dittobar-pill--results"
    >
      <button class="dittobar-nav-btn" @click="selectPrev">
        <UIcon name="i-lucide-chevron-left" class="size-5" />
      </button>

      <div class="dittobar-result-title">
        <span class="font-semibold text-sm text-default truncate">
          {{ currentResult?.name || '—' }}
        </span>
        <span class="text-xs text-muted">
          {{ selectedResultIndex + 1 }} / {{ allResults.length }}
        </span>
      </div>

      <button class="dittobar-nav-btn" @click="selectNext">
        <UIcon name="i-lucide-chevron-right" class="size-5" />
      </button>

      <button class="dittobar-close-btn" @click="backToIdle">
        <UIcon name="i-lucide-x" class="size-4" />
      </button>
    </div>
  </div>

  <!-- ═══════════════ TELEPORTED OVERLAYS ═══════════════ -->
  <!-- Rendered at body level to escape map stacking context -->
  <Teleport to="#__nuxt">
    <!-- AUTOCOMPLETE DROPDOWN -->
    <Transition name="dittobar-dropdown">
      <div
        v-if="showDropdown"
        class="dittobar-floating"
        :style="floatingStyle"
      >
        <!-- Categories -->
        <div v-if="categoryMatches.length > 0" class="dittobar-dropdown-section">
          <div class="dittobar-dropdown-label">
            {{ t('dittobar.categories', 'Kategorier') }}
          </div>
          <button
            v-for="cat in categoryMatches"
            :key="cat.id"
            class="dittobar-dropdown-item"
            @click="navigateToCategory(cat)"
          >
            <UIcon :name="getCategoryIcon(cat.icon)" class="size-4 text-primary shrink-0" />
            <span class="truncate">{{ cat.name }}</span>
          </button>
        </div>

        <!-- Divider -->
        <div
          v-if="categoryMatches.length > 0 && storeMatches.length > 0"
          class="dittobar-dropdown-divider"
        />

        <!-- Stores -->
        <div v-if="storeMatches.length > 0" class="dittobar-dropdown-section">
          <div class="dittobar-dropdown-label">
            {{ t('dittobar.places', 'Steder') }}
          </div>
          <button
            v-for="store in storeMatches"
            :key="store.id"
            class="dittobar-dropdown-item"
            @click="enterResultsState(store)"
          >
            <UIcon name="i-lucide-store" class="size-4 text-primary shrink-0" />
            <span class="truncate font-medium">{{ store.name }}</span>
            <span v-if="store.categoryName" class="text-xs text-muted shrink-0">{{ store.categoryName }}</span>
            <span v-if="store.city" class="text-xs text-dimmed shrink-0">· {{ store.city }}</span>
          </button>
        </div>
      </div>
    </Transition>

    <!-- RESULT CARD -->
    <Transition name="dittobar-dropdown">
      <div
        v-if="barState === 'results' && currentResult"
        class="dittobar-floating dittobar-result-card"
        :style="floatingStyle"
      >
        <div class="dittobar-result-card-image">
          <NuxtImg
            :src="currentResult.image"
            :alt="currentResult.name"
            loading="lazy"
            class="w-full h-full object-cover"
            sizes="320px"
          />
        </div>
        <div class="dittobar-result-card-body">
          <div class="flex items-center gap-2 text-xs text-muted mb-2">
            <span v-if="currentResult.categoryName" class="font-medium text-primary">
              {{ currentResult.categoryName }}
            </span>
            <span v-if="currentResult.city">· {{ currentResult.city }}</span>
            <span :class="currentResult.isActive ? 'text-green-500' : 'text-red-400'">
              · {{ currentResult.isActive ? t('dittobar.open', 'Åpen') : t('dittobar.closed', 'Stengt') }}
            </span>
          </div>
          <div class="flex items-center gap-2">
            <UButton
              color="primary"
              size="sm"
              class="flex-1"
              @click="bookStore(currentResult)"
            >
              <UIcon name="i-lucide-calendar-check" class="size-4 mr-1" />
              {{ t('dittobar.book', 'Book') }}
            </UButton>
            <UButton
              color="neutral"
              variant="outline"
              size="sm"
              class="flex-1"
              @click="navigateToStore(currentResult)"
            >
              {{ t('dittobar.openPage', 'Åpne') }}
              <UIcon name="i-lucide-arrow-right" class="size-4 ml-1" />
            </UButton>
          </div>
        </div>
      </div>
    </Transition>
  </Teleport>
</template>

<style scoped>
/* ═══════════════ CONTAINER ═══════════════ */
.dittobar-container {
  position: relative;
  width: 100%;
  max-width: 28rem;
}

/* ═══════════════ PILL (all states) ═══════════════ */
.dittobar-pill {
  display: flex;
  align-items: center;
  gap: 0.75rem;
  padding: 0.75rem 1.25rem;
  border-radius: 9999px;
  background: var(--ui-bg);
  backdrop-filter: blur(12px);
  box-shadow:
    0 4px 6px -1px rgba(0, 0, 0, 0.1),
    0 2px 4px -2px rgba(0, 0, 0, 0.1);
  border: 1px solid var(--ui-border);
  cursor: pointer;
  transition: all 0.2s ease;
}

.dittobar-pill:hover {
  box-shadow:
    0 10px 15px -3px rgba(0, 0, 0, 0.1),
    0 4px 6px -4px rgba(0, 0, 0, 0.1);
}

.dittobar-pill--active {
  cursor: default;
  box-shadow:
    0 10px 15px -3px rgba(0, 0, 0, 0.1),
    0 4px 6px -4px rgba(0, 0, 0, 0.1),
    0 0 0 2px var(--ui-color-primary);
}

.dittobar-pill--results {
  cursor: default;
  gap: 0.5rem;
}

/* ═══════════════ ICONS ═══════════════ */
.dittobar-icon {
  display: flex;
  align-items: center;
  justify-content: center;
  flex-shrink: 0;
}

.dittobar-icon--pulse {
  animation: dittobar-pulse 2s ease-in-out infinite;
}

.dittobar-icon--button {
  cursor: pointer;
  padding: 0.125rem;
  border-radius: 9999px;
  background: none;
  border: none;
}

/* ═══════════════ PLACEHOLDER ═══════════════ */
.dittobar-placeholder-area {
  flex: 1;
  overflow: hidden;
  min-width: 0;
}

.dittobar-placeholder-text {
  display: block;
  font-size: 0.875rem;
  color: var(--ui-text-muted);
  white-space: nowrap;
  overflow: hidden;
  text-overflow: ellipsis;
}

/* ═══════════════ INPUT ═══════════════ */
.dittobar-input {
  flex: 1;
  background: transparent;
  border: none;
  outline: none;
  font-size: 0.875rem;
  color: var(--ui-text);
  min-width: 0;
}

.dittobar-input::placeholder {
  color: var(--ui-text-muted);
}

/* ═══════════════ NAV BUTTONS (State 3) ═══════════════ */
.dittobar-nav-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 2rem;
  height: 2rem;
  border-radius: 9999px;
  background: var(--ui-bg-elevated);
  border: 1px solid var(--ui-border);
  cursor: pointer;
  flex-shrink: 0;
  transition: all 0.15s ease;
  color: var(--ui-text);
}

.dittobar-nav-btn:hover {
  background: var(--ui-color-primary);
  color: white;
  border-color: var(--ui-color-primary);
}

.dittobar-close-btn {
  display: flex;
  align-items: center;
  justify-content: center;
  width: 1.5rem;
  height: 1.5rem;
  border-radius: 9999px;
  background: transparent;
  border: none;
  cursor: pointer;
  color: var(--ui-text-dimmed);
  margin-left: 0.25rem;
  flex-shrink: 0;
  transition: color 0.15s ease;
}

.dittobar-close-btn:hover {
  color: var(--ui-text);
}

.dittobar-result-title {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
  min-width: 0;
  gap: 0.125rem;
}

/* ═══════════════ ANIMATIONS (scoped — apply to pill elements) ═══════════════ */
@keyframes dittobar-pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.5;
  }
}

/* Placeholder fade */
.dittobar-fade-enter-active,
.dittobar-fade-leave-active {
  transition: opacity 0.3s ease, transform 0.3s ease;
}

.dittobar-fade-enter-from {
  opacity: 0;
  transform: translateY(4px);
}

.dittobar-fade-leave-to {
  opacity: 0;
  transform: translateY(-4px);
}

/* ═══════════════ FLOATING OVERLAYS ═══════════════ */
/* NOTE: Teleported elements are outside the scoped tree.
   Their styles are in the non-scoped block below. */
</style>

<style>
/* ═══════════════ FLOATING OVERLAYS (teleported to body) ═══════════════ */
.dittobar-floating {
  background: var(--ui-bg);
  backdrop-filter: blur(12px);
  border-radius: 1rem;
  border: 1px solid var(--ui-border);
  box-shadow:
    0 10px 15px -3px rgba(0, 0, 0, 0.1),
    0 4px 6px -4px rgba(0, 0, 0, 0.1);
  overflow: hidden;
}

.dittobar-dropdown-section {
  padding: 0.5rem;
}

.dittobar-dropdown-label {
  font-size: 0.6875rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.05em;
  color: var(--ui-text-dimmed);
  padding: 0.375rem 0.5rem 0.25rem;
}

.dittobar-dropdown-item {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  width: 100%;
  padding: 0.5rem;
  border-radius: 0.5rem;
  font-size: 0.875rem;
  color: var(--ui-text);
  background: transparent;
  border: none;
  cursor: pointer;
  text-align: left;
  transition: background 0.15s ease;
}

.dittobar-dropdown-item:hover {
  background: var(--ui-bg-elevated);
}

.dittobar-dropdown-divider {
  height: 1px;
  background: var(--ui-border);
  margin: 0 0.5rem;
}

/* ═══════════════ RESULT CARD ═══════════════ */
.dittobar-result-card-image {
  width: 100%;
  height: 8rem;
  overflow: hidden;
}

.dittobar-result-card-body {
  padding: 0.75rem 1rem;
}

/* ═══════════════ DROPDOWN TRANSITION ═══════════════ */
.dittobar-dropdown-enter-active {
  transition: all 0.2s ease-out;
}

.dittobar-dropdown-leave-active {
  transition: all 0.15s ease-in;
}

.dittobar-dropdown-enter-from {
  opacity: 0;
  transform: translateY(-8px) scale(0.96);
}

.dittobar-dropdown-leave-to {
  opacity: 0;
  transform: translateY(-4px) scale(0.98);
}
</style>
