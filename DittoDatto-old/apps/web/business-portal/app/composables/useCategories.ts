import { collection } from 'firebase/firestore'
import type { Category } from '@dittodatto/shared-types'

/**
 * Composable to fetch available categories from Firestore
 */
export function useCategories() {
  const db = useFirestore()

  const categoriesQuery = collection(db, 'categories')

  const { data: categories, pending: loading } = useCollection<Category>(categoriesQuery)

  // Transform for USelectMenu
  const categoryOptions = computed(() => {
    if (!categories.value) return []
    return categories.value.map(cat => ({
      id: cat.id,
      name: cat.name,
      label: cat.name,
      icon: cat.icon
    }))
  })

  // Helper to find category name by ID
  function getCategoryName(categoryId: string): string {
    const found = categories.value?.find(c => c.id === categoryId)
    return found?.name || categoryId
  }

  return {
    categories,
    categoryOptions,
    loading,
    getCategoryName
  }
}
