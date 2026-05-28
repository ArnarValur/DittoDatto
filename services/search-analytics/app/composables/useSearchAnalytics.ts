import { ref, computed, onMounted, onUnmounted } from 'vue'
import type { getFirestore } from 'firebase/firestore'
import { collection, query, where, onSnapshot, Timestamp, orderBy } from 'firebase/firestore'
import { getAuth, onAuthStateChanged } from 'firebase/auth'
import { useNuxtApp } from '#app'

export interface SearchMetric {
  title: string
  value: string | number
  icon: string
  trend?: {
    value: string
    isPositive: boolean
  }
}

export interface TopQuery {
  id: string
  query: string
  count: number
  trend: number
  conversionRate: string
}

export interface ZeroResultQuery {
  id: string
  query: string
  count: number
  lastSeen: string
}

export function useSearchAnalytics() {
  const isLoading = ref(true)
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  const rawEvents = ref<Record<string, any>[]>([])
  let unsubscribe: (() => void) | null = null

  let authUnsubscribe: (() => void) | null = null

  const listenToEvents = () => {
    try {
      if (unsubscribe) return // Already listening

      const nuxtApp = useNuxtApp()
      if (!nuxtApp.$db) {
        throw new Error('Firestore not initialized')
      }

      const db = nuxtApp.$db as unknown as ReturnType<typeof getFirestore>

      // Fetch last 30 days
      const thirtyDaysAgo = new Date()
      thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30)

      const q = query(
        collection(db, 'searchEvents'),
        where('createdAt', '>=', Timestamp.fromDate(thirtyDaysAgo)),
        orderBy('createdAt', 'desc')
      )

      // Use onSnapshot for real-time live data mapping!
      unsubscribe = onSnapshot(q, (snapshot) => {
        rawEvents.value = snapshot.docs.map(doc => ({ id: doc.id, ...doc.data() }))
        if (isLoading.value) {
          isLoading.value = false
        }
      }, (error) => {
        console.error('Snapshot error on searchEvents:', error)
        isLoading.value = false
      })
    } catch (e) {
      console.error('Failed to listen to search events from Firestore:', e)
      isLoading.value = false
    }
  }

  onMounted(() => {
    if (import.meta.client) {
      const auth = getAuth()
      authUnsubscribe = onAuthStateChanged(auth, async (user) => {
        if (user) {
          // Ensure we have the latest token with claims before listening
          await user.getIdToken(true)
          listenToEvents()
        } else {
          if (unsubscribe) {
            unsubscribe()
            unsubscribe = null
          }
          rawEvents.value = []
        }
      })
    }
  })

  onUnmounted(() => {
    if (unsubscribe) {
      unsubscribe()
      unsubscribe = null
    }
    if (authUnsubscribe) {
      authUnsubscribe()
      authUnsubscribe = null
    }
  })

  // Dynamic Computing of KPIs based on Firestore raw events
  const metrics = computed<SearchMetric[]>(() => {
    const total = rawEvents.value.length
    const zeroResultsCount = rawEvents.value.filter(e => e.resultCount === 0).length

    // CTR = generic click through mapping if `selectedResult` or equivalent is tracked
    const clicks = rawEvents.value.filter(e => !!e.selectedResult).length
    const ctr = total > 0 ? ((clicks / total) * 100).toFixed(1) + '%' : '0%'

    // Unique Sessions
    const uniqueSessions = new Set(rawEvents.value.map(e => e.sessionId)).size

    return [
      {
        title: 'Total Searches',
        value: total.toLocaleString(),
        icon: 'i-lucide-search',
        trend: {
          value: '30d Window',
          isPositive: true
        }
      },
      {
        title: 'Zero-Result Queries',
        value: zeroResultsCount.toLocaleString(),
        icon: 'i-lucide-search-x',
        trend: {
          value: '30d Window',
          isPositive: true
        }
      },
      {
        title: 'Avg. Click-Through Rate',
        value: ctr,
        icon: 'i-lucide-mouse-pointer-click',
        trend: {
          value: '30d Window',
          isPositive: true
        }
      },
      {
        title: 'Unique Sessions',
        value: uniqueSessions.toLocaleString(),
        icon: 'i-lucide-users',
        trend: {
          value: '30d Window',
          isPositive: true
        }
      }
    ]
  })

  // Dynamic Top Queries
  const topQueries = computed<TopQuery[]>(() => {
    const counts: Record<string, { count: number, clicks: number }> = {}

    rawEvents.value.forEach((e) => {
      if (!e.query) return
      // Normalize Search Queries
      const normalizedQuery = String(e.query).toLowerCase().trim()
      if (!normalizedQuery) return

      if (!counts[normalizedQuery]) {
        counts[normalizedQuery] = { count: 0, clicks: 0 }
      }
      counts[normalizedQuery].count++
      if (e.selectedResult) counts[normalizedQuery].clicks++
    })

    const sortedEntries = Object.entries(counts).sort((a, b) => b[1].count - a[1].count).slice(0, 10)

    return sortedEntries.map(([queryStr, stats], idx) => {
      const convRate = stats.count > 0 ? ((stats.clicks / stats.count) * 100).toFixed(1) + '%' : '0%'
      return {
        id: idx.toString(),
        query: queryStr,
        count: stats.count,
        trend: 0,
        conversionRate: convRate
      }
    })
  })

  // Dynamic Zero-Result Queries
  const zeroResultQueries = computed<ZeroResultQuery[]>(() => {
    const counts: Record<string, { count: number, lastSeen?: Date }> = {}

    rawEvents.value
      .filter(e => e.resultCount === 0)
      .forEach((e) => {
        if (!e.query) return
        const normalizedQuery = String(e.query).toLowerCase().trim()
        if (!normalizedQuery) return

        if (!counts[normalizedQuery]) {
          counts[normalizedQuery] = { count: 0 }
        }
        counts[normalizedQuery].count++

        const eventDateObj = e.createdAt?.toDate ? e.createdAt.toDate() : new Date()

        // Update last seen to be the most recent date
        if (!counts[normalizedQuery].lastSeen || eventDateObj > counts[normalizedQuery].lastSeen!) {
          counts[normalizedQuery].lastSeen = eventDateObj
        }
      })

    const sortedEntries = Object.entries(counts).sort((a, b) => b[1].count - a[1].count).slice(0, 10)

    return sortedEntries.map(([queryStr, stats], idx) => {
      const dateString = stats.lastSeen
        ? stats.lastSeen.toLocaleString('en-US', {
            month: 'short', day: 'numeric', hour: '2-digit', minute: '2-digit'
          })
        : 'Unknown'

      return {
        id: idx.toString(),
        query: queryStr,
        count: stats.count,
        lastSeen: dateString
      }
    })
  })

  return {
    isLoading,
    metrics,
    topQueries,
    zeroResultQueries
  }
}
