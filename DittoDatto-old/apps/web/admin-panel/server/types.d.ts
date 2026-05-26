/// <reference types="node" />

/**
 * Type declarations for Nitro server plugins.
 * 
 * This file helps the IDE resolve types for server-side code.
 * These types are normally auto-resolved during Nuxt build.
 */

// Re-export h3 types for module augmentation
declare module 'h3' {
    interface H3EventContext {
        [key: string]: unknown
    }
}

// Ensure firebase-admin types are recognized
declare module 'firebase-admin/app' {
    export * from 'firebase-admin/lib/app'
}

declare module 'firebase-admin/auth' {
    export * from 'firebase-admin/lib/auth'
}

declare module 'firebase-admin/firestore' {
    export * from 'firebase-admin/lib/firestore'
}
