/**
 * useFavorites composable
 *
 * Manages user favorites stored at: users/{userId}/favorites/{favoriteId}
 * Document shape: { entityId, type, companyId, addedAt }
 *
 * When fetching, resolves store data (name, slug, category, images, city)
 * so the UI can display rich cards and correct URLs.
 */
import {
  collection,
  doc,
  setDoc,
  deleteDoc,
  getDocs,
  query,
  where,
  serverTimestamp
} from 'firebase/firestore'

export interface FavoriteItem {
  /** Firestore document ID of the favorite entry */
  favoriteDocId: string
  /** The entity ID (e.g. store ID) */
  id: string
  type: 'store' | 'person'
  companyId?: string
  addedAt: string | null

  // Resolved store data (populated after fetch)
  name?: string
  slug?: string
  category?: string
  city?: string
  coverImage?: string
  logoImage?: string
  rating?: number
  reviewCount?: number
}

export function useFavorites() {
  const db = useFirestore()
  const user = useCurrentUser()

  const favorites = ref<FavoriteItem[]>([])
  const loading = ref(false)
  const error = ref<string | null>(null)

  /**
   * Fetch all favorites of a given type for the current user.
   * Resolves store data via collectionGroup query for rich display.
   */
  async function fetchFavorites(type: 'store' | 'person' = 'store') {
    if (!user.value) {
      favorites.value = []
      return
    }

    loading.value = true
    error.value = null

    try {
      const favsRef = collection(db, 'users', user.value.uid, 'favorites')
      const favsQuery = query(favsRef, where('type', '==', type))
      const snapshot = await getDocs(favsQuery)

      const rawFavs = snapshot.docs.map(d => {
        const data = d.data()
        return {
          favoriteDocId: d.id,
          id: data.entityId as string,
          type: data.type as 'store' | 'person',
          companyId: data.companyId as string | undefined,
          addedAt: data.addedAt?.toDate?.()?.toISOString?.() ?? null
        }
      })

      // Resolve store data for each favorite using direct path
      if (type === 'store' && rawFavs.length > 0) {
        const { getDoc } = await import('firebase/firestore')
        const resolved = new Map<string, any>()

        await Promise.all(
          rawFavs.map(async (fav) => {
            if (!fav.companyId) return
            try {
              const storeRef = doc(db, 'companies', fav.companyId, 'stores', fav.id)
              const storeSnap = await getDoc(storeRef)
              if (storeSnap.exists()) {
                resolved.set(storeSnap.id, storeSnap.data())
              }
            } catch { /* skip unresolvable */ }
          })
        )

        favorites.value = rawFavs.map(fav => {
          const storeData = resolved.get(fav.id)
          return {
            ...fav,
            name: storeData?.name,
            slug: storeData?.slug,
            category: storeData?.category ?? 'discover',
            city: storeData?.city,
            coverImage: storeData?.images?.cover,
            logoImage: storeData?.images?.logo,
            rating: storeData?.aggregateRating?.average,
            reviewCount: storeData?.aggregateRating?.count
          } as FavoriteItem
        })
      } else {
        favorites.value = rawFavs as FavoriteItem[]
      }
    } catch (e: any) {
      console.error('[useFavorites] Error fetching favorites:', e)
      error.value = e.message || 'Failed to fetch favorites'
      favorites.value = []
    } finally {
      loading.value = false
    }
  }

  /**
   * Add a favorite for the current user.
   */
  async function addFavorite(entityId: string, type: 'store' | 'person' = 'store', companyId?: string) {
    if (!user.value) return

    try {
      const favRef = doc(db, 'users', user.value.uid, 'favorites', entityId)
      await setDoc(favRef, {
        entityId,
        type,
        companyId: companyId || null,
        addedAt: serverTimestamp()
      })

      // Optimistic update
      favorites.value.push({
        favoriteDocId: entityId,
        id: entityId,
        type,
        companyId,
        addedAt: new Date().toISOString()
      })
    } catch (e: any) {
      console.error('[useFavorites] Error adding favorite:', e)
    }
  }

  /**
   * Remove a favorite for the current user.
   */
  async function removeFavorite(entityId: string, _type?: string) {
    if (!user.value) return

    try {
      const favRef = doc(db, 'users', user.value.uid, 'favorites', entityId)
      await deleteDoc(favRef)

      // Optimistic update
      favorites.value = favorites.value.filter(f => f.id !== entityId)
    } catch (e: any) {
      console.error('[useFavorites] Error removing favorite:', e)
    }
  }

  return {
    favorites,
    loading,
    error,
    fetchFavorites,
    addFavorite,
    removeFavorite
  }
}
