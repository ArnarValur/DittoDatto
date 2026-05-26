/**
 * useSystemAlerts composable
 *
 * Zero-fan-out: queries systemAlerts/ for active alerts matching
 * the user's audience. One write by admin, all matching users see it.
 *
 * Dismissed alerts are stored in localStorage to avoid re-showing.
 */
import {
  collection,
  query,
  orderBy,
  onSnapshot,
  type Unsubscribe,
} from 'firebase/firestore'
import { useFirestore } from 'vuefire'

export interface SystemAlert {
  id: string
  title: string
  body: string
  severity: 'info' | 'warning' | 'critical'
  targetAudience: 'all' | 'business' | 'customers' | 'admin'
  isActive: boolean
  actionUrl?: string
  actionLabel?: string
  startsAt?: string | null
  expiresAt?: string | null
  createdAt: string | null
}

const STORAGE_KEY = 'dd-dismissed-alerts'

function getDismissedIds(): Set<string> {
  try {
    const raw = localStorage.getItem(STORAGE_KEY)
    return raw ? new Set(JSON.parse(raw)) : new Set()
  } catch {
    return new Set()
  }
}

function persistDismissed(ids: Set<string>) {
  localStorage.setItem(STORAGE_KEY, JSON.stringify([...ids]))
}

// Module-level state
const alerts = ref<SystemAlert[]>([])
const loading = ref(false)
let unsubscribe: Unsubscribe | null = null

/**
 * @param audience - Which audience this client represents:
 *   'business' for portal, 'customers' for marketplace, 'admin' for admin panel
 */
export function useSystemAlerts(audience: 'business' | 'customers' | 'admin') {
  const db = useFirestore()

  const dismissed = ref<Set<string>>(new Set())

  // Active alerts for this audience (not dismissed, not expired)
  const visibleAlerts = computed(() => {
    const now = Date.now()
    return alerts.value.filter((a) => {
      if (!a.isActive) return false
      if (dismissed.value.has(a.id)) return false
      if (a.expiresAt && new Date(a.expiresAt).getTime() < now) return false
      if (a.startsAt && new Date(a.startsAt).getTime() > now) return false
      return true
    })
  })

  function subscribe() {
    if (unsubscribe) {
      unsubscribe()
      unsubscribe = null
    }

    loading.value = true

    // Simple query — no composite index needed. Filter isActive client-side.
    const q = query(
      collection(db, 'systemAlerts'),
      orderBy('createdAt', 'desc')
    )

    unsubscribe = onSnapshot(
      q,
      (snapshot) => {
        alerts.value = snapshot.docs
          .map((d) => {
            const data = d.data()
            return {
              id: d.id,
              title: data.title || '',
              body: data.body || '',
              severity: data.severity || 'info',
              targetAudience: data.targetAudience || 'all',
              isActive: data.isActive ?? true,
              actionUrl: data.actionUrl,
              actionLabel: data.actionLabel,
              startsAt: data.startsAt?.toDate?.()?.toISOString?.() ?? null,
              expiresAt: data.expiresAt?.toDate?.()?.toISOString?.() ?? null,
              createdAt: data.createdAt?.toDate?.()?.toISOString?.() ?? null,
            } as SystemAlert
          })
          .filter((a) => a.targetAudience === 'all' || a.targetAudience === audience)

        loading.value = false
      },
      (err) => {
        console.error('[useSystemAlerts] Listener error:', err)
        loading.value = false
      }
    )
  }

  function stop() {
    unsubscribe?.()
    unsubscribe = null
    alerts.value = []
  }

  function dismiss(alertId: string) {
    dismissed.value = new Set([...dismissed.value, alertId])
    persistDismissed(dismissed.value)
  }

  // Auto-subscribe on mount
  onMounted(() => {
    dismissed.value = getDismissedIds()
    subscribe()
  })

  onUnmounted(() => {
    stop()
  })

  return {
    alerts: readonly(alerts),
    visibleAlerts,
    loading: readonly(loading),
    dismiss,
  }
}
