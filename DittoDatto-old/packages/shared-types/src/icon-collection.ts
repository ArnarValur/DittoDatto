import { z } from 'zod'
import { DateTimeSchema } from './common'

/**
 * Icon Collection Schema - stored in Firestore `iconCollections/{id}`
 */
export const IconCollectionSchema = z.object({
  id: z.string(),
  name: z.string().min(1, 'Name is required'),
  description: z.string().optional(),
  icons: z.array(z.string()),
  isDefault: z.boolean().default(false),
  createdAt: DateTimeSchema,
  updatedAt: DateTimeSchema
})

export type IconCollection = z.infer<typeof IconCollectionSchema>

/**
 * Create Icon Collection request
 */
export const CreateIconCollectionSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  description: z.string().optional(),
  icons: z.array(z.string()).min(1, 'At least one icon is required')
})

export type CreateIconCollectionRequest = z.infer<typeof CreateIconCollectionSchema>

/**
 * Update Icon Collection request
 */
export const UpdateIconCollectionSchema = z.object({
  name: z.string().min(1).optional(),
  description: z.string().optional(),
  icons: z.array(z.string()).optional()
})

export type UpdateIconCollectionRequest = z.infer<typeof UpdateIconCollectionSchema>
