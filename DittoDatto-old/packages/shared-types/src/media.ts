import { z } from "zod";
import { IdSchema, DateTimeSchema } from "./common";

/**
 * Media Gallery Types
 * @deprecated Use tags array instead for flexible categorization
 */
export const MediaTypeSchema = z.enum([
  "logo",
  "cover",
  "store_gallery",
  "staff_portrait",
  "general",
]);
export type MediaType = z.infer<typeof MediaTypeSchema>;

/**
 * Default media tags available to all companies
 */
export const DefaultMediaTags = [
  "logo",
  "cover",
  "staff",
  "store",
  "menu",
  "misc",
] as const;
export type DefaultMediaTag = (typeof DefaultMediaTags)[number];

/**
 * Allowed MIME types for media uploads
 */
export const AllowedMediaMimeTypes = [
  "image/jpeg",
  "image/png",
  "image/webp",
  "image/svg+xml",
  "image/heic",
  "image/heif",
] as const;

export const MediaMimeTypeSchema = z.enum(AllowedMediaMimeTypes);
export type MediaMimeType = z.infer<typeof MediaMimeTypeSchema>;

/**
 * Media Item Schema
 * Represents a single media asset stored in Firebase Storage with metadata in Firestore
 */
export const MediaItemSchema = z.object({
  id: IdSchema,
  companyId: IdSchema,
  storeId: IdSchema.optional(),
  uploaderId: IdSchema,

  // Storage info
  url: z.string().url(),
  path: z.string().min(1), // Full Storage path for deletion
  filename: z.string().min(1),
  mimeType: MediaMimeTypeSchema,
  size: z.number().int().positive().max(10 * 1024 * 1024), // Max 10MB

  // Dimensions (optional, extracted after upload)
  width: z.number().int().positive().optional(),
  height: z.number().int().positive().optional(),

  // Categorization
  name: z.string().optional(), // User-friendly display name
  tags: z.array(z.string()).default([]), // e.g. ["logo", "cover"]
  
  /** @deprecated Use tags instead */
  type: MediaTypeSchema.optional(),
  
  createdAt: DateTimeSchema,
  updatedAt: DateTimeSchema,
});

export type MediaItem = z.infer<typeof MediaItemSchema>;

/**
 * Schema for creating a new media item (subset of fields)
 */
export const CreateMediaItemSchema = MediaItemSchema.omit({
  id: true,
  url: true,
  createdAt: true,
  updatedAt: true,
});

export type CreateMediaItem = z.infer<typeof CreateMediaItemSchema>;

/**
 * Validation constants
 */
export const MEDIA_MAX_FILE_SIZE = 10 * 1024 * 1024; // 10MB
export const MEDIA_ALLOWED_TYPES = AllowedMediaMimeTypes;
