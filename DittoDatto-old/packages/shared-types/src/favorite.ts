import { z } from "zod";
import { IdSchema, DateTimeSchema } from "./common";

/**
 * The User Favorite Schema
 */
export const UserFavoriteSchema = z.object({
  id: IdSchema, // Store ID or Person ID
  type: z.enum(["store", "person"]),
  addedAt: DateTimeSchema,
});
export type UserFavorite = z.infer<typeof UserFavoriteSchema>;
