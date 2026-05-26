import SunCalc from 'suncalc'

export type ThemePreference = 'light' | 'dark' | 'system' | 'solar'

export interface SolarPhaseData {
  altitude: number
  phase: string
  lightness: number
  isNight: boolean
  starOpacity: number
  overlayOpacity: number
  overlayHue: number
}

// Default location: Drammen, Norway
const DEFAULT_LAT = 59.74
const DEFAULT_LNG = 10.21

// --- Module-level singletons ---
// Shared across ALL composable calls — prevents multiple engine instances
// and ensures stopSolarEngine() always clears the correct interval.
let _intervalId: ReturnType<typeof setInterval> | null = null

export const useSolarTheme = (
  lat: number = DEFAULT_LAT,
  lng: number = DEFAULT_LNG
) => {
  // Nuxt useState: shared across all composable instances in the same app
  const themePreference = useState<ThemePreference>('solar:preference', () => {
    // Initialise from the persistent cookie; default to 'solar' for first-time visitors
    const cookie = useCookie<ThemePreference>('dd_theme_preference', {
      maxAge: 60 * 60 * 24 * 365,
      path: '/'
    })
    return cookie.value ?? 'solar'
  })

  const solarPhase = useState<SolarPhaseData>('solar:phase', () => ({
    altitude: 0,
    phase: 'Day',
    lightness: 50,
    isNight: false,
    starOpacity: 0,
    overlayOpacity: 0,
    overlayHue: 40
  }))

  // Debug override — shared so debug bar can control the live engine
  const debugDate = useState<Date | null>('solar:debugDate', () => null)

  const isActive = computed(() => themePreference.value === 'solar')

  // Persist preference to cookie whenever it changes
  const persistCookie = (pref: ThemePreference) => {
    const cookie = useCookie<ThemePreference>('dd_theme_preference', {
      maxAge: 60 * 60 * 24 * 365,
      path: '/'
    })
    cookie.value = pref
  }

  const computeSolarData = (date: Date = new Date()): SolarPhaseData => {
    const position = SunCalc.getPosition(date, lat, lng)
    const altitudeDeg = position.altitude * (180 / Math.PI)

    let lightness = ((altitudeDeg + 20) / 80) * 90 + 5
    lightness = Math.max(5, Math.min(95, lightness))

    let phase = 'Night'
    if (altitudeDeg > 0) phase = 'Day'
    else if (altitudeDeg > -6) phase = 'Civil Twilight'
    else if (altitudeDeg > -12) phase = 'Nautical Twilight'
    else if (altitudeDeg > -18) phase = 'Astronomical Twilight'

    const isGoldenHour = altitudeDeg >= -2 && altitudeDeg < 8
    if (isGoldenHour) phase = 'Golden Hour'

    let starOpacity = 0
    if (altitudeDeg < -6) {
      starOpacity = Math.min(1, (Math.abs(altitudeDeg) - 6) / 12)
    }

    let overlayOpacity = 0
    let overlayHue = 40
    if (isGoldenHour) {
      overlayOpacity = Math.max(0, 0.12 - Math.abs(altitudeDeg - 3) * 0.012)
    } else if (altitudeDeg > -12 && altitudeDeg <= -2) {
      overlayHue = 220
      overlayOpacity = Math.max(0, 0.06 - (altitudeDeg + 12) * 0.003)
    }

    return {
      altitude: altitudeDeg,
      phase,
      lightness,
      isNight: altitudeDeg < -6,
      starOpacity,
      overlayOpacity,
      overlayHue
    }
  }

  const applyToDOM = (data: SolarPhaseData) => {
    if (!import.meta.client) return
    const colorMode = useColorMode()
    colorMode.preference = data.altitude < 0 ? 'dark' : 'light'
    const root = document.documentElement
    root.style.setProperty('--solar-overlay-opacity', `${data.overlayOpacity}`)
    root.style.setProperty('--solar-overlay-hue', `${data.overlayHue}`)
    root.style.setProperty('--star-opacity', `${data.starOpacity}`)
  }

  const updateSolar = () => {
    const date = debugDate.value ?? new Date()
    const data = computeSolarData(date)
    solarPhase.value = data
    applyToDOM(data)
  }

  const stopSolarEngine = () => {
    // Uses module-level _intervalId — works regardless of which instance calls it
    if (_intervalId) {
      clearInterval(_intervalId)
      _intervalId = null
    }
    if (import.meta.client) {
      const root = document.documentElement
      root.style.removeProperty('--solar-overlay-opacity')
      root.style.removeProperty('--solar-overlay-hue')
      root.style.removeProperty('--star-opacity')
    }
  }

  const startSolarEngine = () => {
    if (!import.meta.client) return
    stopSolarEngine() // Clear any existing interval first
    updateSolar()
    if (!debugDate.value) {
      _intervalId = setInterval(updateSolar, 60_000)
    }
  }

  const setThemePreference = (pref: ThemePreference) => {
    themePreference.value = pref
    persistCookie(pref)

    if (pref === 'solar') {
      startSolarEngine()
    } else {
      stopSolarEngine()
      if (import.meta.client) {
        const colorMode = useColorMode()
        colorMode.preference = pref
      }
    }
  }

  const setDebugDate = (date: Date | null) => {
    debugDate.value = date
    if (date) {
      if (_intervalId) {
        clearInterval(_intervalId)
        _intervalId = null
      }
      updateSolar()
    } else {
      if (isActive.value) {
        startSolarEngine()
      }
    }
  }

  if (import.meta.client) {
    onMounted(() => {
      // Only auto-start if the user's stored preference is solar
      if (themePreference.value === 'solar') {
        startSolarEngine()
      }
    })

    onUnmounted(() => {
      // Don't stop on unmount — the engine runs globally.
      // It will be stopped explicitly via setThemePreference().
    })
  }

  return {
    themePreference,
    isActive,
    solarPhase,
    debugDate,
    setThemePreference,
    setDebugDate,
    computeSolarData,
    startSolarEngine,
    stopSolarEngine
  }
}
