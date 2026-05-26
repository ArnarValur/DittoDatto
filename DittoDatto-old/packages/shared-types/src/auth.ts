import { z } from "zod";
import { IdSchema } from "./common";
import { UserRoleSchema } from "./user";

/**
 * The Firebase Token Claims Schema
 */
export const FirebaseTokenClaimsSchema = z.object({
  role: UserRoleSchema,
  companyMembershipIds: z.array(IdSchema).optional(),
});
export type FirebaseTokenClaims = z.infer<typeof FirebaseTokenClaimsSchema>;

/**
 * The Firebase User Schema
 */
export const FirebaseUserSchema = z.object({
  uid: IdSchema,
  displayName: z.string(),
  email: z.string().email(),
  photoURL: z.string().optional(),
  role: UserRoleSchema,
  customClaims: z.record(z.string(), z.any()),
  metadata: z.any(),
});
export type FirebaseUser = z.infer<typeof FirebaseUserSchema>;
