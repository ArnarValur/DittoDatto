/**
 * Test App Factory
 * 
 * Creates a Hono app instance configured for testing.
 * Mocks Firebase Admin so no real Firebase connection is needed.
 * Uses the same route structure as server.ts but without side effects.
 */

import { vi } from 'vitest'

// Mock firebase-admin BEFORE any route imports
// This prevents real Firebase initialization during tests
vi.mock('firebase-admin/auth', () => ({
  getAuth: () => ({
    verifyIdToken: async (token: string) => ({
      uid: 'test-user-123',
      email: 'test@example.com',
      name: 'Test User',
    }),
    getUser: async (uid: string) => ({
      uid,
      email: 'test@example.com',
      displayName: 'Test User',
      customClaims: {},
    }),
  }),
}))

// Mock firebase config to use an in-memory mock
vi.mock('../../src/config/firebase.js', () => ({
  db: createMockFirestore(),
}))

// Mock env config to avoid process.env validation
vi.mock('../../src/config/env.js', () => ({
  env: {
    PORT: 5002,
    NODE_ENV: 'test',
    GCLOUD_PROJECT: 'test-project',
    INTERNAL_API_KEY: 'test-key',
  },
}))

import { Hono } from 'hono'
import appointments from '../../src/routes/appointments.js'
import reservations from '../../src/routes/reservations.js'
import ticketing from '../../src/routes/ticketing.js'
import cleanup from '../../src/routes/cleanup.js'

/**
 * Minimal Firestore mock — enough for route-level contract tests.
 * Returns empty collections by default. Deep-chains .where() infinitely.
 */
function createMockFirestore() {
  const emptySnap = {
    exists: false,
    data: () => null,
    id: 'mock-id',
  }
  const emptyQuery = {
    docs: [],
    empty: true,
  }

  // Self-referencing query mock — handles .where().where().where()... chains
  const createQueryMock = (): any => ({
    where: (...args: any[]) => createQueryMock(),
    get: async () => emptyQuery,
    limit: (...args: any[]) => createQueryMock(),
    orderBy: (...args: any[]) => createQueryMock(),
    count: () => ({
      get: async () => ({ data: () => ({ count: 0 }) }),
    }),
  })

  return {
    doc: (path: string) => ({
      get: async () => emptySnap,
      set: async () => {},
      update: async () => {},
      id: path.split('/').pop() || 'mock-id',
    }),
    collection: (path: string) => ({
      doc: (id?: string) => ({
        get: async () => emptySnap,
        set: async () => {},
        update: async () => {},
        id: id || 'auto-generated-id',
      }),
      ...createQueryMock(),
    }),
    runTransaction: async (fn: any) => {
      const transaction = {
        get: async (ref: any) => {
          if (typeof ref === 'object' && ref.get) return ref.get()
          return emptySnap
        },
        set: () => {},
        update: () => {},
        delete: () => {},
      }
      return fn(transaction)
    },
    batch: () => ({
      delete: () => {},
      commit: async () => {},
    }),
  }
}

/**
 * Create a test app with the same route structure as the real server.
 * No CORS, no logger — just routes with auth middleware intact.
 */
export function createTestApp() {
  const app = new Hono()

  // Health check
  app.get('/health', (c) => c.json({
    status: 'ok',
    service: 'mercury-engine',
    version: '0.2.0-test',
  }))

  // Mount routes (same as server.ts)
  app.route('/appointments', appointments)
  app.route('/reservations', reservations)
  app.route('/tickets', ticketing)
  app.route('/cleanup', cleanup)

  // Root
  app.get('/', (c) => c.json({
    name: 'MercuryEngine',
    endpoints: {
      appointments: '/appointments/*',
      reservations: '/reservations/*',
      tickets: '/tickets/*',
      cleanup: '/cleanup/*',
      health: '/health',
    },
  }))

  return app
}
