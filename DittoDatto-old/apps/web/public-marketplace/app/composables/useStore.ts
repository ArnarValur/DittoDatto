/**
 * Store Detail Composable
 * 
 * Provides individual store details.
 * TODO: Connect to real Firebase/API backend when ready.
 */

import { createError } from '#imports'

export type StoreServiceItem = {
  id: string
  title: string
  description?: string
  duration: number
  price: number
  currency: string
  icon?: string
}

export type StoreServiceGroup = {
  id: string
  title: string
  icon?: string
  services: StoreServiceItem[]
}

export type StoreStaffMember = {
  id: string
  name: string
  about?: string
  avatar?: string
  isBookable: boolean
}

export type StoreDetail = {
  store: {
    id: string
    name: string
    slug: string
    address: string
    city: string
    categoryName: string
    rating: number
    reviewCount: number
    image: string
  }
  services: StoreServiceGroup[]
  staff: StoreStaffMember[]
}

export const useStore = () => {
  const fetchStoreBySlug = async (slug: string): Promise<StoreDetail> => {
    // TODO: Fetch from real API
    throw createError({
      statusCode: 404,
      statusMessage: 'Store not found'
    })
  }

  return {
    fetchStoreBySlug
  }
}
