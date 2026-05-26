import { z } from "zod";
import { IdSchema, DateTimeSchema } from "./common";

export const CategorySchema = z.object({
  id: IdSchema,
  name: z.string().min(1),
  slug: z.string().min(1), // Kebab-case version of name
  description: z.string().optional(),
  icon: z.string().optional(), // Lucide icon name
  // Store count - denormalized for cheap reads, updated by Firestore trigger
  count: z.number().int().nonnegative().default(0),
  createdAt: DateTimeSchema,
  updatedAt: DateTimeSchema,
});
export type Category = z.infer<typeof CategorySchema>;
