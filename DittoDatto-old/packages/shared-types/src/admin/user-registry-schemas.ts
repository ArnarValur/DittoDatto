import { z } from "zod";
import {
  UserSchema,
  UserRoleSchema,
  UserCompanyMembershipSchema,
} from "../user";
import { IdSchema } from "../common";

export const ListUsersRequestSchema = z.object({
  page: z.number().int().positive().default(1),
  pageSize: z.number().int().min(1).max(100).default(25),
  role: UserRoleSchema.optional(),
  companyId: IdSchema.optional(),
  search: z.string().min(1).max(120).optional(),
});
export type ListUsersRequest = z.infer<typeof ListUsersRequestSchema>;

export const ListUsersResponseSchema = z.object({
  users: z.array(UserSchema),
  total: z.number().nonnegative(),
  page: z.number().int().positive(),
  pageSize: z.number().int().positive(),
  hasNextPage: z.boolean(),
});
export type ListUsersResponse = z.infer<typeof ListUsersResponseSchema>;

export const CreateUserRequestSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8).max(128).optional(),
  name: z.string().min(1).max(255),
  phone: z.string().optional(),
  role: UserRoleSchema,
  tier: z.enum(["free", "premium"]).optional(),
  isOnboarded: z.boolean().optional(),
  primaryCompanyId: IdSchema.optional(),
  companyMemberships: z.array(UserCompanyMembershipSchema).optional(),
});
export type CreateUserRequest = z.infer<typeof CreateUserRequestSchema>;

export const CreateUserResponseSchema = z.object({
  user: UserSchema,
  createdAuthUser: z.boolean(),
});
export type CreateUserResponse = z.infer<typeof CreateUserResponseSchema>;

export const UpdateUserRequestSchema = z.object({
  userId: IdSchema,
  name: z.string().min(1).max(255).optional(),
  phone: z.string().optional(),
  role: UserRoleSchema.optional(),
  tier: z.enum(["free", "premium"]).optional(),
  isOnboarded: z.boolean().optional(),
  primaryCompanyId: IdSchema.nullable().optional(),
  companyMemberships: z.array(UserCompanyMembershipSchema).optional(),
});
export type UpdateUserRequest = z.infer<typeof UpdateUserRequestSchema>;

export const UpdateUserResponseSchema = z.object({
  user: UserSchema,
  updatedCustomClaims: z.boolean(),
});
export type UpdateUserResponse = z.infer<typeof UpdateUserResponseSchema>;

export const DeleteUserRequestSchema = z.object({
  userId: IdSchema,
  hardDelete: z.boolean().default(false),
});
export type DeleteUserRequest = z.infer<typeof DeleteUserRequestSchema>;

export const DeleteUserResponseSchema = z.object({
  success: z.boolean(),
});
export type DeleteUserResponse = z.infer<typeof DeleteUserResponseSchema>;
