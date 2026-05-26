import { z } from "zod";
import { IdSchema, DateTimeSchema } from "./common";

export const AppSettingsSchema = z.object({
  maintenanceMode: z.boolean().default(false),
  maintenanceMessage: z.string().optional(),
  solarDebugEnabled: z.boolean().default(false),
  updatedAt: DateTimeSchema,
  updatedBy: IdSchema.optional(),
});
export type AppSettings = z.infer<typeof AppSettingsSchema>;
