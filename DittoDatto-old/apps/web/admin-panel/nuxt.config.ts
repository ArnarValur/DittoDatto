// https://nuxt.com/docs/api/configuration/nuxt-config

// Build-time fallbacks (overridden by env vars at runtime)
const FIREBASE_CONFIG = {
  apiKey: 'AIzaSyBUvwCaaItSzPuMt9slv0yPUz3lYPBWbjA',
  authDomain: 'cs-poc-4zmxog23jmy4io0d4yx6rj0.firebaseapp.com',
  projectId: 'cs-poc-4zmxog23jmy4io0d4yx6rj0',
  storageBucket: 'cs-poc-4zmxog23jmy4io0d4yx6rj0.firebasestorage.app',
  messagingSenderId: '419230358494',
  appId: '1:419230358494:web:30c2e18b536648072a9b4f',
  measurementId: 'G-6HPFKX2V49',
};

export default defineNuxtConfig({
  extends: ['@dittodatto/ui'],

  modules: [
    '@nuxt/ui',
    '@nuxt/image',
    '@nuxt/eslint',
    '@nuxt/test-utils',
    'nuxt-vuefire',
    '@nuxtjs/i18n',
  ],

  ssr: true,
  devtools: { enabled: true },
  css: ['~/assets/css/main.css'],

  ui: {
    prefix: 'U',
    fonts: true,
    colorMode: true,
    theme: {
      colors: ['primary', 'secondary', 'success', 'info', 'warning', 'error'],
    },
  },

  routeRules: {
    // No prerendering - admin panel is fully dynamic
  },

  compatibilityDate: '2025-07-15',

  nitro: {
    preset: 'node-server',
  },

  runtimeConfig: {
    public: {
      mercuryUrl: process.env.NUXT_PUBLIC_MERCURY_URL || 'http://localhost:5002'
    }
  },

  // Dev server config
  devServer: {
    host: '0.0.0.0',
    port: 3000,
  },

  eslint: {
    config: {
      stylistic: {
        commaDangle: 'never',
        braceStyle: '1tbs',
      },
    },
  },

  i18n: {
    strategy: 'no_prefix',
    locales: [
      { code: 'en', iso: 'en-GB', file: 'en.json', name: 'English' },
      { code: 'nb', iso: 'nb-NO', file: 'nb.json', name: 'Norsk Bokmål' },
      { code: 'nn', iso: 'nn-NO', file: 'nn.json', name: 'Norsk Nynorsk' },
      { code: 'pl', iso: 'pl-PL', file: 'pl.json', name: 'Polski' },
    ],
    defaultLocale: 'nb',
    langDir: 'locales/',
  },

  vuefire: {
    auth: {
      enabled: true,
      // maxAge: 5 days (in seconds). Without explicit maxAge, cookie uses browser
      // session lifetime which can cause premature logout on tab close.
      sessionCookie: process.env.NODE_ENV === 'development'
        ? { secure: false, maxAge: 60 * 60 * 24 * 5 }
        : { maxAge: 60 * 60 * 24 * 5 },
    },
    config: {
      projectId:
        process.env.NUXT_PUBLIC_FIREBASE_PROJECT_ID ||
        FIREBASE_CONFIG.projectId,
      apiKey:
        process.env.NUXT_PUBLIC_FIREBASE_API_KEY || FIREBASE_CONFIG.apiKey,
      authDomain:
        process.env.NUXT_PUBLIC_FIREBASE_AUTH_DOMAIN ||
        FIREBASE_CONFIG.authDomain,
      storageBucket:
        process.env.NUXT_PUBLIC_FIREBASE_STORAGE_BUCKET ||
        FIREBASE_CONFIG.storageBucket,
      messagingSenderId:
        process.env.NUXT_PUBLIC_FIREBASE_MESSAGING_SENDER_ID ||
        FIREBASE_CONFIG.messagingSenderId,
      appId: process.env.NUXT_PUBLIC_FIREBASE_APP_ID || FIREBASE_CONFIG.appId,
    },
    // ⚠️ EMULATORS OFF — using live Firebase
    // To re-enable: set to { auth: {...}, firestore: {...}, functions: {...} }
    emulators: false,
  },
});
