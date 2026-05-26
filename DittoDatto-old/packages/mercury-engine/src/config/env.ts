/**
 * MercuryEngine - Environment Configuration
 *
 * Validates all required environment variables at startup using Zod.
 * If any required variable is missing or malformed, the app crashes
 * immediately with a clear error — fail-fast, not fail-open.
 */

import { z } from 'zod'

const EnvSchema = z.object({
  // Server
  PORT: z.coerce.number().default(5002),
  NODE_ENV: z.enum(['development', 'production', 'test']).default('development'),

  // Firebase / GCP
  GCLOUD_PROJECT: z.string().default('cs-poc-4zmxog23jmy4io0d4yx6rj0'),
  FIRESTORE_EMULATOR_HOST: z.string().optional(),

  // Security — required in production, optional in dev
  INTERNAL_API_KEY: z.string().optional(),
})

// Parse and validate on import — crash immediately on misconfiguration
function loadConfig() {
  const result = EnvSchema.safeParse(process.env)
  if (!result.success) {
    console.error('❌ Invalid environment configuration:')
    console.error(result.error.format())
    process.exit(1)
  }

  const config = result.data

  // Warn in dev, crash in prod if INTERNAL_API_KEY is missing
  if (!config.INTERNAL_API_KEY) {
    if (config.NODE_ENV === 'production') {
      console.error('❌ INTERNAL_API_KEY is required in production')
      process.exit(1)
    }
    console.warn('⚠️  INTERNAL_API_KEY not set — internal endpoints unprotected (dev only)')
  }

  return config
}

export const env = loadConfig()
