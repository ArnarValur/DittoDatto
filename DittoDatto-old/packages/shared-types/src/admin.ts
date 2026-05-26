import { z } from "zod";
import { IdSchema } from "./common";
import { UserRoleSchema, UserCompanyMembershipSchema } from "./user";

/**
 * The Update User Role Request Schema
 */
export const UpdateUserRoleRequestSchema = z.object({
  userId: IdSchema,
  role: UserRoleSchema.optional(),
  companyMemberships: z.array(UserCompanyMembershipSchema).optional(),
});
