import { z } from "zod";
import { CompanySchema } from "../company";
import { IdSchema } from "../common";

// ============================================================================
// ADMIN - COMPANY MANAGEMENT SCHEMAS
// ============================================================================

/**
 * Admin Create Company Request Schema
 *
 * Used by admins to create a new company and elevate an existing user
 * to company-owner role.
 */
export const AdminCreateCompanySchema = z.object({
  // The email of the existing user who will own this company
  ownerEmail: z.email(),

  // Company Details
  name: z.string().min(2).max(100),
  // NOTE: category/subcategory removed - categories belong at Store level (Option A architecture)
  tier: z.enum(["free", "premium"]).default("free"),
  onboardingStatus: z
    .enum(["not_started", "ai_suggested", "verified", "complete"])
    .default("verified"),

  // Contact Info
  email: z.email().optional(),
  phone: z.string().optional(),
  country: z.string().min(2).max(255).default("NO"),

  // Feature Flags (Admin-controlled)
  enabledFeatures: z
    .object({
      tableReservation: z.boolean().default(false),
      aiAssistance: z.boolean().default(false),
      ticketSystem: z.boolean().default(false),
      eventSystem: z.boolean().default(false),
    })
    .optional(),

  // Store Policy (Admin-controlled)
  storePolicy: z
    .object({
      maxStores: z.number().int().min(0).default(1),
      canCreateOwnStores: z.boolean().default(false),
    })
    .optional(),
});

export type AdminCreateCompanyRequest = z.infer<
  typeof AdminCreateCompanySchema
>;

export const AdminUpdateCompanySchema = z.object({
  companyId: IdSchema,
  ownerId: IdSchema.optional(),
  ownerEmail: z.email().optional(),
  name: z.string().min(2).max(100).optional(),
  // NOTE: category removed - categories belong at Store level (Option A architecture)
  tier: z.enum(["free", "premium"]).optional(),
  onboardingStatus: z
    .enum(["not_started", "ai_suggested", "verified", "complete"])
    .optional(),
  phone: z.string().optional(),
  logoUrl: z.url().optional(),
  managerIds: z.array(IdSchema).optional(),
  memberIds: z.array(IdSchema).optional(),
});
export type AdminUpdateCompanyRequest = z.infer<
  typeof AdminUpdateCompanySchema
>;

export const AdminDeleteCompanyRequestSchema = z.object({
  companyId: IdSchema,
  softDelete: z.boolean().default(true),
});
export type AdminDeleteCompanyRequest = z.infer<
  typeof AdminDeleteCompanyRequestSchema
>;

export const AdminListCompaniesRequestSchema = z.object({
  page: z.number().int().positive().default(1),
  pageSize: z.number().int().min(1).max(100).default(25),
  ownerId: IdSchema.optional(),
  search: z.string().min(1).max(120).optional(),
});
export type AdminListCompaniesRequest = z.infer<
  typeof AdminListCompaniesRequestSchema
>;

export const AdminListCompaniesResponseSchema = z.object({
  companies: z.array(CompanySchema),
  total: z.number().nonnegative(),
  page: z.number().int().positive(),
  pageSize: z.number().int().positive(),
  hasNextPage: z.boolean(),
});
export type AdminListCompaniesResponse = z.infer<
  typeof AdminListCompaniesResponseSchema
>;
