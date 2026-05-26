/// <reference types="node" />

/**
 * Server-side type declarations for Nitro.
 * These are normally auto-resolved by Nuxt at build time.
 * This file helps the IDE understand server-side types.
 */

// Re-export H3 types
import type { H3Event as H3EventType, EventHandler } from 'h3'

declare global {
  // Node.js environment
  namespace NodeJS {
    interface ProcessEnv {
      NUXT_PUBLIC_FIREBASE_PROJECT_ID?: string
      NUXT_PUBLIC_FIREBASE_API_KEY?: string
      GOOGLE_APPLICATION_CREDENTIALS?: string
      FIRESTORE_EMULATOR_HOST?: string
      FIREBASE_AUTH_EMULATOR_HOST?: string
      NODE_ENV?: 'development' | 'production' | 'test'
    }
  }
}

// Nitro auto-imports
declare global {
  const defineNitroPlugin: typeof import('nitropack/runtime').defineNitroPlugin
  const defineEventHandler: typeof import('h3').defineEventHandler
  const getHeader: typeof import('h3').getHeader
  const getCookie: typeof import('h3').getCookie
  const createError: typeof import('h3').createError
  const getQuery: typeof import('h3').getQuery
  const readBody: typeof import('h3').readBody
  const setResponseStatus: typeof import('h3').setResponseStatus
}

// H3 module augmentation for Firebase Admin context
declare module 'h3' {
  interface H3EventContext {
    firebaseAdmin: {
      auth: import('firebase-admin/auth').Auth
      firestore: import('firebase-admin/firestore').Firestore
    } | null
  }
}

export {}
