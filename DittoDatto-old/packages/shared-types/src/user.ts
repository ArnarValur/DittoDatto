import { z } from "zod";
import { IdSchema, DateTimeSchema } from "./common";

/**
 * The Company Role Schema
 */
export const CompanyRoleSchema = z.enum(["owner", "admin", "employee"]); // Refined from 'company-owner' to be more standard
export type CompanyRole = z.infer<typeof CompanyRoleSchema>;

/**
 * The User Role Schema
 */
export const UserRoleSchema = z.enum([
  "customer",
  "business",
  "admin",
  "super_admin",
]);
export type UserRole = z.infer<typeof UserRoleSchema>;

/**
 * The User Company Membership Schema
 */
export const UserCompanyMembershipSchema = z.object({
  companyId: IdSchema,
  role: CompanyRoleSchema, // The role within THAT specific company
  assignedAt: DateTimeSchema,
});
export type UserCompanyMembership = z.infer<typeof UserCompanyMembershipSchema>;

/**
 * The User Schema
 */
export const UserSchema = z.object({
  id: IdSchema,

  // Profile
  name: z.string().min(1).max(255),
  email: z.string().email(),
  username: z.string().min(1).max(30).optional(),
  bio: z.string().max(500).optional(),
  phone: z.string().optional(),
  photoUrl: z.string().url().optional(),

  // System Access
  role: UserRoleSchema, // 'customer' by default, 'business' if they own a store
  isOnboarded: z.boolean().default(false),

  // RBAC & Relationships
  // We keep this purely for the "Switch Company" UI dropdown
  companyMemberships: z.array(UserCompanyMembershipSchema).default([]),
  // We keep this for Firestore Rules (security optimization: "resource.data.companyMembershipIds.has(request.auth.uid)")
  companyMembershipIds: z.array(IdSchema).default([]),

  // Preferences
  language: z.enum(["nb", "en"]).default("en"),

  // Metadata
  createdAt: DateTimeSchema,
  updatedAt: DateTimeSchema,
});
export type User = z.infer<typeof UserSchema>;
