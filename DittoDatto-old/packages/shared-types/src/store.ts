import { z } from "zod";
import { IdSchema, DateTimeSchema, AggregateRatingSchema } from "./common";
import { OpeningScheduleSchema } from "./schedule";
import { BookingPolicySchema } from "./booking-policy";



export const StoreSchema = z.object({
  id: IdSchema,
  companyId: IdSchema,

  name: z.string().min(1),
  slug: z.string().min(1),

  address: z.string().min(1),
  city: z.string().min(1),
  zip: z.string().min(1),
  country: z.string().min(2).max(255).default("NO"), // ISO country code

  gmapCoord: z
    .object({
      lat: z.number().min(-90).max(90),
      lng: z.number().min(-180).max(180),
    })
    .optional(),
  geoHash: z.string().optional(),

  // Contact & Branding (can override Company defaults)
  phone: z.string().optional(),
  email: z.email().optional(),
  website: z.url().optional(),
  // TODO: remove hardcoded social links and make it dynamic.
  slinks: z
    .object({
      fb: z.url().optional(),
      ig: z.url().optional(),
      x: z.url().optional(),
    })
    .optional(),

  about: z.string().optional(),
  
  // Media - structured image URLs
  images: z
    .object({
      logo: z.string().optional(),
      cover: z.string().optional(),
      gallery: z.array(z.string()).default([]),
    })
    .default({ gallery: [] }),

  // Cover layout mode for store preview page
  // - showcase: 3/4 cover + 1/4 vertical scroll gallery
  // - spotlight: Full-width single cover image
  // - bento: 2/4 cover + 2x2 grid (default)
  coverLayoutMode: z.enum(["showcase", "spotlight", "bento"]).default("bento"),
    
  openingSchedule: OpeningScheduleSchema,
  timezone: z.string().default("Europe/Oslo"),

  // Booking policy (controls booking window, cancellation, reschedule rules)
  bookingPolicy: BookingPolicySchema.optional(),

  // Business type for categorization (Store, Restaurant, Venue)
  storeType: z.enum(["store", "restaurant", "venue"]).default("store"),

  // Feature flags
  resourcesEnabled: z.boolean().default(false), // Enable resource management (tables, rooms, equipment, add-ons)

  bookingFormType: z
    .enum(["standard", "none", "tableReservation", "ticketSystem"])
    .default("standard"),
  reservationConfig: z
    .object({
      maxGuestsPerReservation: z.number().int().min(1).default(8),
      largePartyHandling: z
        .enum(["email", "call", "datto", "disabled"])
        .default("email"),
      largePartyContact: z.url().optional(),
      defaultDuration: z.number().int().min(15).default(90),
      slotInterval: z.number().int().min(15).default(30),
      bufferBetweenSlots: z.number().int().default(0),
      capacityMode: z.enum(["pool", "tables", "hybrid"]).default("pool"),
      totalCapacity: z.number().int().optional(),
      autoConfirm: z.boolean().default(true),
    })
    .optional(),
  isPublished: z.boolean(),
  isActive: z.boolean().default(true),
  category: z.string().min(1).optional(), // Added for denormalized filtering in marketplace
  aggregateRating: AggregateRatingSchema.optional(),
  
  // Favorites count - denormalized for cheap reads, updated by Firestore trigger
  favoritesCount: z.number().int().nonnegative().default(0),

  // Metadata
  createdAt: DateTimeSchema,
  updatedAt: DateTimeSchema,
});
export type Store = z.infer<typeof StoreSchema>;

