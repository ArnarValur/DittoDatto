import { defineConfig } from 'vitest/config'

export default defineConfig({
  test: {
    globals: true,
    environment: 'node',
    include: ['tests/**/*.test.ts'],
    coverage: {
      provider: 'v8',
      include: ['src/core/**'],
      exclude: ['src/core/tickets/**'],
    },
  },
  resolve: {
    alias: {
      // Allow tests to import from src/ cleanly
      '@core': './src/core',
    },
  },
})
