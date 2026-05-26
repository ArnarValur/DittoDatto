<script setup lang="ts">
/**
 * SolarDebugBar — Dev-only floating panel for inspecting SolarTheme
 *
 * Provides a time slider (0–1439 minutes) to simulate any time of day,
 * showing live solar metrics (phase, altitude, lightness, star opacity).
 * Gated by NUXT_PUBLIC_SOLAR_DEBUG=true in .env.
 */
const { solarPhase, setDebugDate } = useSolarTheme()

const getCurrentMinutes = () => {
  const now = new Date()
  return now.getHours() * 60 + now.getMinutes()
}

const sliderMinutes = ref(getCurrentMinutes())
const isManual = ref(false)
const isCollapsed = ref(false)

const simulatedDate = computed(() => {
  const d = new Date()
  d.setHours(0, 0, 0, 0)
  d.setMinutes(sliderMinutes.value)
  return d
})

const formattedTime = computed(() => {
  const h = Math.floor(sliderMinutes.value / 60)
  const m = sliderMinutes.value % 60
  return `${String(h).padStart(2, '0')}:${String(m).padStart(2, '0')}`
})

// Phase emoji for quick visual
const phaseEmoji = computed(() => {
  const p = solarPhase.value.phase
  if (p === 'Night') return '🌙'
  if (p === 'Astronomical Twilight') return '🌌'
  if (p === 'Nautical Twilight') return '🌊'
  if (p === 'Civil Twilight') return '🌆'
  if (p === 'Golden Hour') return '🌅'
  return '☀️'
})

watch(sliderMinutes, () => {
  isManual.value = true
  setDebugDate(simulatedDate.value)
})

const resetToNow = () => {
  isManual.value = false
  sliderMinutes.value = getCurrentMinutes()
  setDebugDate(null)
}

onUnmounted(() => {
  setDebugDate(null)
})
</script>

<template>
  <!-- Collapsed: small floating button -->
  <button
    v-if="isCollapsed"
    class="fixed bottom-20 md:bottom-4 right-4 z-[9999] w-10 h-10 rounded-full bg-gray-900/80 backdrop-blur-md border border-white/20 text-white flex items-center justify-center shadow-lg hover:scale-110 transition-transform cursor-pointer"
    title="Open Solar Debug Bar"
    @click="isCollapsed = false"
  >
    ☀️
  </button>

  <!-- Expanded: full debug panel -->
  <div
    v-else
    class="fixed bottom-20 md:bottom-4 right-4 z-[9999] w-80 rounded-xl bg-gray-900/90 backdrop-blur-xl border border-white/15 text-white shadow-2xl overflow-hidden"
  >
    <!-- Header -->
    <div class="flex items-center justify-between px-4 py-2.5 border-b border-white/10">
      <div class="flex items-center gap-2">
        <span class="text-sm font-semibold tracking-wide">☀️ Solar Debug</span>
        <span class="text-[10px] px-1.5 py-0.5 rounded-full font-mono uppercase tracking-wider"
          :class="isManual ? 'bg-amber-500/20 text-amber-400' : 'bg-emerald-500/20 text-emerald-400'"
        >
          {{ isManual ? 'Manual' : 'Live' }}
        </span>
      </div>
      <button
        class="text-white/50 hover:text-white transition-colors text-lg leading-none cursor-pointer"
        title="Collapse"
        @click="isCollapsed = true"
      >
        ✕
      </button>
    </div>

    <div class="px-4 py-3 space-y-3">
      <!-- Time display -->
      <div class="flex items-end justify-between">
        <div class="flex items-baseline gap-2">
          <span class="text-3xl font-thin font-mono tabular-nums">{{ formattedTime }}</span>
          <span class="text-lg">{{ phaseEmoji }}</span>
        </div>
        <span class="text-xs text-white/40 font-medium">{{ solarPhase.phase }}</span>
      </div>

      <!-- Time Slider -->
      <div class="space-y-1">
        <input
          v-model.number="sliderMinutes"
          type="range"
          :min="0"
          :max="1439"
          :step="1"
          class="w-full h-1.5 rounded-full appearance-none cursor-pointer
                 bg-gradient-to-r from-indigo-900 via-amber-500 to-indigo-900
                 [&::-webkit-slider-thumb]:appearance-none
                 [&::-webkit-slider-thumb]:w-4 [&::-webkit-slider-thumb]:h-4
                 [&::-webkit-slider-thumb]:rounded-full
                 [&::-webkit-slider-thumb]:bg-white
                 [&::-webkit-slider-thumb]:shadow-md
                 [&::-webkit-slider-thumb]:cursor-pointer
                 [&::-moz-range-thumb]:w-4 [&::-moz-range-thumb]:h-4
                 [&::-moz-range-thumb]:rounded-full
                 [&::-moz-range-thumb]:bg-white
                 [&::-moz-range-thumb]:border-0
                 [&::-moz-range-thumb]:shadow-md
                 [&::-moz-range-thumb]:cursor-pointer"
        >
        <div class="flex justify-between text-[9px] text-white/30 font-mono">
          <span>00:00</span>
          <span>06:00</span>
          <span>12:00</span>
          <span>18:00</span>
          <span>23:59</span>
        </div>
      </div>

      <!-- Metrics Grid -->
      <div class="grid grid-cols-4 gap-2 text-center">
        <div class="bg-white/5 rounded-lg py-1.5 px-1">
          <p class="text-[9px] text-white/40 uppercase tracking-wider">Alt</p>
          <p class="text-sm font-mono font-semibold tabular-nums">{{ solarPhase.altitude.toFixed(1) }}°</p>
        </div>
        <div class="bg-white/5 rounded-lg py-1.5 px-1">
          <p class="text-[9px] text-white/40 uppercase tracking-wider">Light</p>
          <p class="text-sm font-mono font-semibold tabular-nums">{{ solarPhase.lightness.toFixed(0) }}%</p>
        </div>
        <div class="bg-white/5 rounded-lg py-1.5 px-1">
          <p class="text-[9px] text-white/40 uppercase tracking-wider">Stars</p>
          <p class="text-sm font-mono font-semibold tabular-nums">{{ solarPhase.starOpacity.toFixed(2) }}</p>
        </div>
        <div class="bg-white/5 rounded-lg py-1.5 px-1">
          <p class="text-[9px] text-white/40 uppercase tracking-wider">Night</p>
          <p class="text-sm font-mono font-semibold tabular-nums">{{ solarPhase.isNight ? '✓' : '✗' }}</p>
        </div>
      </div>

      <!-- Return to Now -->
      <button
        v-if="isManual"
        class="w-full py-1.5 rounded-lg text-xs font-medium bg-white/10 hover:bg-white/20 transition-colors cursor-pointer"
        @click="resetToNow"
      >
        ↻ Return to Now
      </button>
    </div>
  </div>
</template>
