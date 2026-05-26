import { z } from "zod";
import { IdSchema, DateTimeSchema } from "./common";

export const CompanySchema = z.object({
  id: IdSchema,
  ownerId: IdSchema,
  ownerEmail: z.email().optional(),
  name: z.string().min(1).max(255),
  description: z.string().optional(),
  website: z.url().optional(),
  address: z.string().optional(),
  city: z.string().optional(),
  zip: z.string().optional(),
  country: z.string().min(2).max(255).default("NO"), // ISO country code

  email: z.email().optional(),
  phone: z.string().optional(),
  logoUrl: z.url().optional(),
  tier: z.enum(["free", "premium"]).default("free"),
  slinks: z
    .object({
      fb: z.url().optional(),
      ig: z.url().optional(),
      x: z.url().optional(),
    })
    .optional(),

  // Onboarding
  onboardingStatus: z.enum([
    "not_started",
    "ai_suggested",
    "verified",
    "complete",
  ]),
  aiSuggestedData: z
    .object({
      name: z.string().optional(),
      website: z.url().optional(),
      description: z.string().optional(),
      address: z.string().optional(),
      phone: z.string().optional(),
      suggestedAt: DateTimeSchema,
    })
    .optional(),

  // Feature Flags (Admin-controlled)
  enabledFeatures: z
    .object({
      tableReservation: z.boolean().default(false),
      aiAssistance: z.boolean().default(false),
      ticketSystem: z.boolean().default(false),
      eventSystem: z.boolean().default(false),
    })
    .default({
      tableReservation: false,
      aiAssistance: false,
      ticketSystem: false,
      eventSystem: false,
    }),

  // Store Policy (Admin-controlled)
  storePolicy: z
    .object({
      maxStores: z.number().int().min(0).default(1),
      canCreateOwnStores: z.boolean().default(false),
    })
    .default({
      maxStores: 1,
      canCreateOwnStores: false,
    }),

  // Media Configuration
  mediaConfig: z
    .object({
      defaultTags: z
        .array(z.string())
        .default(["logo", "cover", "staff", "store", "menu", "misc"]),
    })
    .default({
      defaultTags: ["logo", "cover", "staff", "store", "menu", "misc"],
    }),

  // Metadata
  createdAt: DateTimeSchema,
  updatedAt: DateTimeSchema,
  managerIds: z.array(IdSchema).optional(),
  memberIds: z.array(IdSchema).optional(),
});
export type Company = z.infer<typeof CompanySchema>;
