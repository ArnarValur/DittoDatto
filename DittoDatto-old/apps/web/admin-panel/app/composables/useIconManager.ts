import type { IconCollection, CreateIconCollectionRequest } from '@dittodatto/shared-types'

/**
 * Composable for managing icon collections
 */
export function useIconManager() {
  const toast = useToast()

  // State
  const collections = ref<IconCollection[]>([])
  const loading = ref(false)
  const isUploading = ref(false)
  const selectedCollection = ref<IconCollection | null>(null)
  const isModalOpen = ref(false)

  // Form state for create/edit
  const form = reactive({
    name: '',
    description: '',
    icons: [] as string[]
  })

  /**
   * Fetch all icon collections
   */
  async function fetchCollections() {
    loading.value = true
    try {
      const { data } = await useFetch<{ collections: IconCollection[] }>('/api/icon-collections')
      if (data.value) {
        collections.value = data.value.collections
      }
    } catch (error) {
      console.error('Failed to fetch collections:', error)
      toast.add({ title: 'Failed to load icon collections', color: 'error' })
    } finally {
      loading.value = false
    }
  }

  /**
   * Create a new icon collection
   */
  async function createCollection(data: CreateIconCollectionRequest) {
    loading.value = true
    try {
      await $fetch('/api/icon-collections', {
        method: 'POST',
        body: data
      })
      toast.add({ title: 'Collection created successfully', color: 'success' })
      await fetchCollections()
      closeModal()
    } catch (error: unknown) {
      const message = (error instanceof Error && 'data' in error)
        ? (error as { data?: { statusMessage?: string } }).data?.statusMessage
        : 'Failed to create collection'
      toast.add({ title: message || 'Failed to create collection', color: 'error' })
    } finally {
      loading.value = false
    }
  }

  /**
   * Update an existing icon collection
   */
  async function updateCollection(id: string, data: Partial<CreateIconCollectionRequest>) {
    loading.value = true
    try {
      await $fetch(`/api/icon-collections/${id}`, {
        method: 'PATCH',
        body: data
      })
      toast.add({ title: 'Collection updated successfully', color: 'success' })
      await fetchCollections()
      closeModal()
    } catch (error: unknown) {
      const message = (error instanceof Error && 'data' in error)
        ? (error as { data?: { statusMessage?: string } }).data?.statusMessage
        : 'Failed to update collection'
      toast.add({ title: message || 'Failed to update collection', color: 'error' })
    } finally {
      loading.value = false
    }
  }

  /**
   * Delete an icon collection
   */
  async function deleteCollection(id: string) {
    loading.value = true
    try {
      await $fetch(`/api/icon-collections/${id}`, { method: 'DELETE' })
      toast.add({ title: 'Collection deleted successfully', color: 'success' })
      await fetchCollections()
      closeModal()
    } catch (error: unknown) {
      const message = (error instanceof Error && 'data' in error)
        ? (error as { data?: { statusMessage?: string } }).data?.statusMessage
        : 'Failed to delete collection'
      toast.add({ title: message || 'Failed to delete collection', color: 'error' })
    } finally {
      loading.value = false
    }
  }

  /**
   * Parse JSON file for icon collection upload
   * Supports multiple formats:
   * 1. Iconify format: { prefix, icons: { iconName: {...} } }
   * 2. Solar/Array format: [{ name: "icon-name", svg: "..." }]
   * 3. Simple array: ["i-icon-name", ...]
   */
  function parseIconsFromJson(jsonContent: unknown): string[] {
    const icons: string[] = []

    // Format 1: Iconify collection format { prefix, icons }
    if (jsonContent && typeof jsonContent === 'object' && !Array.isArray(jsonContent) && 'icons' in jsonContent) {
      const data = jsonContent as { prefix?: string, icons?: Record<string, unknown> }
      const prefix = data.prefix || 'custom'
      const iconsObj = data.icons || {}

      for (const iconName of Object.keys(iconsObj)) {
        icons.push(`i-${prefix}-${iconName}`)
      }
      return icons
    }

    // Format 2 & 3: Array formats
    if (Array.isArray(jsonContent)) {
      for (const item of jsonContent) {
        // Format 2: Solar format [{ name: "solar:4k-bold", svg: "..." }]
        if (item && typeof item === 'object' && 'name' in item) {
          const iconObj = item as { name: string }
          // Convert "solar:4k-bold" to "i-solar-4k-bold"
          const iconName = iconObj.name.replace(':', '-')
          icons.push(iconName.startsWith('i-') ? iconName : `i-${iconName}`)
        }
        // Format 3: Simple string array
        else if (typeof item === 'string') {
          icons.push(item.startsWith('i-') ? item : `i-${item}`)
        }
      }
    }

    return icons
  }

  /**
   * Handle JSON file upload
   */
  async function handleFileUpload(file: File): Promise<string[]> {
    return new Promise((resolve, reject) => {
      const reader = new FileReader()
      reader.onload = (e) => {
        try {
          const content = JSON.parse(e.target?.result as string)
          const icons = parseIconsFromJson(content)
          if (icons.length === 0) {
            reject(new Error('No icons found in file'))
          } else {
            resolve(icons)
          }
        } catch (error) {
          reject(new Error('Invalid JSON file'))
        }
      }
      reader.onerror = () => reject(new Error('Failed to read file'))
      reader.readAsText(file)
    })
  }

  /**
   * Open modal for creating new collection
   */
  function openCreateModal() {
    selectedCollection.value = null
    form.name = ''
    form.description = ''
    form.icons = []
    isModalOpen.value = true
  }

  /**
   * Open modal for editing collection
   */
  function openEditModal(collection: IconCollection) {
    selectedCollection.value = collection
    form.name = collection.name
    form.description = collection.description || ''
    form.icons = [...collection.icons]
    isModalOpen.value = true
  }

  /**
   * Close modal and reset form
   */
  function closeModal() {
    isModalOpen.value = false
    selectedCollection.value = null
    form.name = ''
    form.description = ''
    form.icons = []
  }

  /**
   * Save collection (create or update)
   */
  async function saveCollection() {
    const data = {
      name: form.name,
      description: form.description,
      icons: form.icons
    }

    if (selectedCollection.value) {
      await updateCollection(selectedCollection.value.id, data)
    } else {
      await createCollection(data)
    }
  }

  /**
   * Get all icons from all collections (flattened)
   */
  const allIcons = computed(() => {
    const iconSet = new Set<string>()
    for (const collection of collections.value) {
      for (const icon of collection.icons) {
        iconSet.add(icon)
      }
    }
    return Array.from(iconSet)
  })

  return {
    // State
    collections,
    loading,
    isUploading,
    selectedCollection,
    isModalOpen,
    form,
    allIcons,

    // Actions
    fetchCollections,
    createCollection,
    updateCollection,
    deleteCollection,
    handleFileUpload,
    openCreateModal,
    openEditModal,
    closeModal,
    saveCollection
  }
}
