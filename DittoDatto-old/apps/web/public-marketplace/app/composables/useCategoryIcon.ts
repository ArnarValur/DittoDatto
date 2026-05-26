/**
 * Maps bare Lucide icon names (as stored in Firestore)
 * to their full Iconify UnoCSS class names.
 *
 * This static mapping is required because UnoCSS tree-shakes icons
 * at build time — dynamic template literals like `i-lucide-${name}`
 * are invisible to the bundler.
 *
 * When adding new category icons, add the mapping here.
 */
const CATEGORY_ICON_MAP: Record<string, string> = {
  // --- Currently used by seed data ---
  'bike': 'i-lucide-bike',
  'building': 'i-lucide-building',
  'camera': 'i-lucide-camera',
  'car': 'i-lucide-car',
  'dumbbell': 'i-lucide-dumbbell',
  'leaf': 'i-lucide-leaf',
  'paw-print': 'i-lucide-paw-print',
  'scale': 'i-lucide-scale',
  'scissors': 'i-lucide-scissors',
  'spray-can': 'i-lucide-spray-can',
  'tag': 'i-lucide-tag',
  'ticket': 'i-lucide-ticket',
  'utensils': 'i-lucide-utensils',
  'wrench': 'i-lucide-wrench',

  // --- Common extras (future-proof) ---
  'heart': 'i-lucide-heart',
  'star': 'i-lucide-star',
  'home': 'i-lucide-home',
  'map-pin': 'i-lucide-map-pin',
  'music': 'i-lucide-music',
  'palette': 'i-lucide-palette',
  'shopping-bag': 'i-lucide-shopping-bag',
  'stethoscope': 'i-lucide-stethoscope',
  'baby': 'i-lucide-baby',
  'glasses': 'i-lucide-glasses',
  'briefcase': 'i-lucide-briefcase',
  'book-open': 'i-lucide-book-open',
  'coffee': 'i-lucide-coffee',
  'flame': 'i-lucide-flame',
  'grid-2x2': 'i-lucide-grid-2x2',
}

const FALLBACK_ICON = 'i-lucide-grid-2x2'

export function useCategoryIcon() {
  /**
   * Resolve a category's icon field to a valid UIcon name.
   * Handles bare names ('scissors'), full Iconify names ('i-lucide-scissors'),
   * and unknown values (falls back to grid icon).
   */
  function resolve(iconField: string | undefined | null): string {
    const raw = iconField || 'grid-2x2'

    // Already in full Iconify format
    if (raw.startsWith('i-')) return raw

    // Look up in static map
    return CATEGORY_ICON_MAP[raw] || FALLBACK_ICON
  }

  return { resolve }
}
