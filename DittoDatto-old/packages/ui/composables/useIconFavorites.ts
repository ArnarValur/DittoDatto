import { doc, getDoc, setDoc } from 'firebase/firestore'

/**
 * Composable for managing user's favorite icons
 * Stores in Firestore: users/{userId}/iconFavorites/default
 */
export function useIconFavorites() {
  const toast = useToast()
  const user = useCurrentUser()
  const db = useFirestore()

  // State
  const favorites = ref<string[]>([])
  const loading = ref(false)
  const hasFetched = ref(false)

  // Firestore document reference
  const favoritesDocRef = computed(() => {
    if (!user.value?.uid || !db) return null
    return doc(db, 'users', user.value.uid, 'iconFavorites', 'default')
  })

  /**
   * Fetch user's favorite icons
   */
  async function fetchFavorites() {
    if (!favoritesDocRef.value || hasFetched.value) return

    loading.value = true
    try {
      const docSnap = await getDoc(favoritesDocRef.value)
      if (docSnap.exists()) {
        favorites.value = docSnap.data()?.icons || []
      }
      hasFetched.value = true
    } catch (error) {
      console.error('Failed to fetch favorites:', error)
    } finally {
      loading.value = false
    }
  }

  /**
   * Add icon to favorites
   */
  async function addFavorite(iconName: string) {
    if (!favoritesDocRef.value) {
      toast.add({ title: 'Please log in to save favorites', color: 'warning' })
      return
    }

    if (favorites.value.includes(iconName)) return

    favorites.value.push(iconName)

    try {
      await setDoc(favoritesDocRef.value, {
        icons: favorites.value,
        updatedAt: new Date()
      }, { merge: true })
      toast.add({ title: 'Added to My Collection', color: 'success' })
    } catch (error) {
      console.error('Failed to add favorite:', error)
      favorites.value = favorites.value.filter((i) => i !== iconName)
      toast.add({ title: 'Failed to add favorite', color: 'error' })
    }
  }

  /**
   * Remove icon from favorites
   */
  async function removeFavorite(iconName: string) {
    if (!favoritesDocRef.value) return

    const index = favorites.value.indexOf(iconName)
    if (index === -1) return

    favorites.value.splice(index, 1)

    try {
      await setDoc(favoritesDocRef.value, {
        icons: favorites.value,
        updatedAt: new Date()
      }, { merge: true })
      toast.add({ title: 'Removed from My Collection', color: 'success' })
    } catch (error) {
      console.error('Failed to remove favorite:', error)
      favorites.value.splice(index, 0, iconName)
      toast.add({ title: 'Failed to remove', color: 'error' })
    }
  }

  /**
   * Check if icon is a favorite
   */
  function isFavorite(iconName: string): boolean {
    return favorites.value.includes(iconName)
  }

  return {
    favorites,
    loading,
    fetchFavorites,
    addFavorite,
    removeFavorite,
    isFavorite
  }
}
