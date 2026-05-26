---
title: "Nuxt: The Full-Stack Vue Framework"
source: "https://nuxt.com/docs/4.x/getting-started/configuration"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description: "Build fast, production-ready web apps with Vue. File-based routing, auto-imports, and server-side rendering — all configured out of the box."
tags:
  - "Nuxt"
---
## Configuration

Nuxt is configured with sensible defaults to make you productive.

By default, Nuxt is configured to cover most use cases. The [`nuxt.config.ts`](https://nuxt.com/docs/4.x/directory-structure/nuxt-config) file can override or extend this default configuration.

## Nuxt Configuration

The [`nuxt.config.ts`](https://nuxt.com/docs/4.x/directory-structure/nuxt-config) file is located at the root of a Nuxt project and can override or extend the application's behavior.

A minimal configuration file exports the `defineNuxtConfig` function containing an object with your configuration. The `defineNuxtConfig` helper is globally available without import.

nuxt.config.ts

```ts
export default defineNuxtConfig({

  // My Nuxt config

})
```

This file will often be mentioned in the documentation, for example to add custom scripts, register modules or change rendering modes.

Every option is described in the **Configuration Reference**.

You don't have to use TypeScript to build an application with Nuxt. However, it is strongly recommended to use the `.ts` extension for the `nuxt.config` file. This way you can benefit from hints in your IDE to avoid typos and mistakes while editing your configuration.

### Environment Overrides

You can configure fully typed, per-environment overrides in your nuxt.config

nuxt.config.ts

```ts
export default defineNuxtConfig({

  $production: {

    routeRules: {

      '/**': { isr: true },

    },

  },

  $development: {

    //

  },

  $env: {

    staging: {

      //

    },

  },

})
```

To select an environment when running a Nuxt CLI command, simply pass the name to the `--envName` flag, like so: `nuxt build --envName staging`.

To learn more about the mechanism behind these overrides, please refer to the `c12` documentation on [environment-specific configuration](https://github.com/unjs/c12?tab=readme-ov-file#environment-specific-configuration).

If you're authoring layers, you can also use the `$meta` key to provide metadata that you or the consumers of your layer might use.

### Environment Variables and Private Tokens

The `runtimeConfig` API exposes values like environment variables to the rest of your application. By default, these keys are only available server-side. The keys within `runtimeConfig.public` and `runtimeConfig.app` (which is used by Nuxt internally) are also available client-side.

Those values should be defined in `nuxt.config` and can be overridden using environment variables.

These variables are exposed to the rest of your application using the [`useRuntimeConfig()`](https://nuxt.com/docs/4.x/api/composables/use-runtime-config) composable.

app/pages/index.vue

```
<script setup lang="ts">

const runtimeConfig = useRuntimeConfig()

</script>
```

Read more in Docs > 4 X > Guide > Going Further > Runtime Config.

## App Configuration

The `app.config.ts` file, located in the source directory (by default `app/`), is used to expose public variables that can be determined at build time. Contrary to the `runtimeConfig` option, these cannot be overridden using environment variables.

A minimal configuration file exports the `defineAppConfig` function containing an object with your configuration. The `defineAppConfig` helper is globally available without import.

app/app.config.ts

```ts
export default defineAppConfig({

  title: 'Hello Nuxt',

  theme: {

    dark: true,

    colors: {

      primary: '#ff0000',

    },

  },

})
```

These variables are exposed to the rest of your application using the [`useAppConfig`](https://nuxt.com/docs/4.x/api/composables/use-app-config) composable.

app/pages/index.vue

```
<script setup lang="ts">

const appConfig = useAppConfig()

</script>
```

Read more in Docs > 4 X > Directory Structure > App > App Config.

## runtimeConfig vs. app.config

As stated above, `runtimeConfig` and `app.config` are both used to expose variables to the rest of your application. To determine whether you should use one or the other, here are some guidelines:

- `runtimeConfig`: Private or public tokens that need to be specified after build using environment variables.
- `app.config`: Public tokens that are determined at build time, website configuration such as theme variant, title and any project config that are not sensitive.

| Feature | `runtimeConfig` | `app.config` |
| --- | --- | --- |
| Client-side | Hydrated | Bundled |
| Environment variables | ✅ Yes | ❌ No |
| Reactive | ✅ Yes | ✅ Yes |
| Types support | ✅ Partial | ✅ Yes |
| Configuration per request | ❌ No | ✅ Yes |
| Hot module replacement | ❌ No | ✅ Yes |
| Non-primitive JS types | ❌ No | ✅ Yes |

## External Configuration Files

Nuxt uses [`nuxt.config.ts`](https://nuxt.com/docs/4.x/directory-structure/nuxt-config) file as the single source of truth for configurations and skips reading external configuration files. During the course of building your project, you may have a need to configure those. The following table highlights common configurations and, where applicable, how they can be configured with Nuxt.

| Name | Config File | How To Configure |
| --- | --- | --- |
| [Nitro](https://nitro.build/) | ~~`nitro.config.ts`~~ | Use [`nitro`](https://nuxt.com/docs/4.x/api/nuxt-config#nitro) key in `nuxt.config` |
| [PostCSS](https://postcss.org/) | ~~`postcss.config.js`~~ | Use [`postcss`](https://nuxt.com/docs/4.x/api/nuxt-config#postcss) key in `nuxt.config` |
| [Vite](https://vite.dev/) | ~~`vite.config.ts`~~ | Use [`vite`](https://nuxt.com/docs/4.x/api/nuxt-config#vite) key in `nuxt.config` |
| [webpack](https://webpack.js.org/) | ~~`webpack.config.ts`~~ | Use [`webpack`](https://nuxt.com/docs/4.x/api/nuxt-config#webpack-1) key in `nuxt.config` |

Here is a list of other common config files:

## Vue Configuration

### With Vite

If you need to pass options to `@vitejs/plugin-vue` or `@vitejs/plugin-vue-jsx`, you can do this in your `nuxt.config` file.

- `vite.vue` for `@vitejs/plugin-vue`. Check [available options](https://github.com/vitejs/vite-plugin-vue/tree/main/packages/plugin-vue).
- `vite.vueJsx` for `@vitejs/plugin-vue-jsx`. Check [available options](https://github.com/vitejs/vite-plugin-vue/tree/main/packages/plugin-vue-jsx).

nuxt.config.ts

```ts
export default defineNuxtConfig({

  vite: {

    vue: {

      customElement: true,

    },

    vueJsx: {

      mergeProps: true,

    },

  },

})
```

Read more in Docs > 4 X > API > Configuration > Nuxt Config#vue.

### With webpack

If you use webpack and need to configure `vue-loader`, you can do this using `webpack.loaders.vue` key inside your `nuxt.config` file. The available options are [defined here](https://github.com/vuejs/vue-loader/blob/main/src/index.ts#L32-L62).

nuxt.config.ts

```ts
export default defineNuxtConfig({

  webpack: {

    loaders: {

      vue: {

        hotReload: true,

      },

    },

  },

})
```

Read more in Docs > 4 X > API > Configuration > Nuxt Config#loaders.

### Enabling Experimental Vue Features

You may need to enable experimental features in Vue, such as `propsDestructure`. Nuxt provides an easy way to do that in `nuxt.config.ts`, no matter which builder you are using:

nuxt.config.ts

```ts
export default defineNuxtConfig({

  vue: {

    propsDestructure: true,

  },

})
```

#### experimental reactivityTransform migration from Vue 3.4 and Nuxt 3.9

Since Nuxt 3.9 and Vue 3.4, `reactivityTransform` has been moved from Vue to Vue Macros which has a [Nuxt integration](https://vue-macros.dev/guide/nuxt-integration.html).

Read more in Docs > 4 X > API > Configuration > Nuxt Config#vue 1.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/1.getting-started/03.configuration.md)[Installation](https://nuxt.com/docs/4.x/getting-started/installation)

[

Get started with Nuxt quickly with our online starters or start locally with your terminal.

](https://nuxt.com/docs/4.x/getting-started/installation)[

Views

Nuxt provides several component layers to implement the user interface of your application.

](https://nuxt.com/docs/4.x/getting-started/views)