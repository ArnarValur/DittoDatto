---
title: "Builder · Nuxt Kit v4"
source: "https://nuxt.com/docs/4.x/api/kit/builder"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## Builder

[Source](https://github.com/nuxt/nuxt/blob/main/packages/kit/src/build.ts)

Nuxt Kit provides a set of utilities to help you work with the builder. These functions allow you to extend the Vite and webpack configurations.

Nuxt have builders based on [Vite](https://github.com/nuxt/nuxt/tree/main/packages/vite) and [webpack](https://github.com/nuxt/nuxt/tree/main/packages/webpack). You can extend the config passed to each one using `extendViteConfig` and `extendWebpackConfig` functions. You can also add additional plugins via `addVitePlugin`, `addWebpackPlugin` and `addBuildPlugin`.

## extendViteConfig

Extends the Vite configuration. Callback function can be called multiple times, when applying to both client and server builds.

This hook is now deprecated, and we recommend using a Vite plugin instead with a `config` hook, or — for environment-specific configuration — the `applyToEnvironment` hook.

### Usage

```ts
import { defineNuxtModule, extendViteConfig } from '@nuxt/kit'

export default defineNuxtModule({

  setup () {

    extendViteConfig((config) => {

      config.optimizeDeps ||= {}

      config.optimizeDeps.include ||= []

      config.optimizeDeps.include.push('cross-fetch')

    })

  },

})
```

For environment-specific configuration in Nuxt 5+, use `addVitePlugin()` instead:

```ts
import { addVitePlugin, defineNuxtModule } from '@nuxt/kit'

export default defineNuxtModule({

  setup () {

    // For global configuration (affects all environments)

    addVitePlugin(() => ({

      name: 'my-global-plugin',

      config (config) {

        // This runs before environment setup

        config.optimizeDeps ||= {}

        config.optimizeDeps.include ||= []

        config.optimizeDeps.include.push('cross-fetch')

      },

    }))

    // For environment-specific configuration

    addVitePlugin(() => ({

      name: 'my-client-plugin',

      applyToEnvironment (environment) {

        return environment.name === 'client'

      },

      configEnvironment (name, config) {

        // This only affects the client environment

        config.optimizeDeps ||= {}

        config.optimizeDeps.include ||= []

        config.optimizeDeps.include.push('client-only-package')

      },

    }))

  },

})
```

**Important:** The `config` hook runs before `applyToEnvironment` and modifies the global configuration. Use `configEnvironment` for environment-specific configuration changes.

### Type

```ts
function extendViteConfig (callback: ((config: ViteConfig) => void), options?: ExtendViteConfigOptions): void
```

Check out the Vite website for more information about its configuration.

### Parameters

**`callback`**: A callback function that will be called with the Vite configuration object.

**`options`**: Options to pass to the callback function. This object can have the following properties:

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `dev` | `boolean` | `false` | If set to `true`, the callback function will be called when building in development mode. |
| `build` | `boolean` | `false` | If set to `true`, the callback function will be called when building in production mode. |
| `server` | `boolean` | `false` | If set to `true`, the callback function will be called when building the server bundle. **Deprecated in Nuxt 5+.** Use `addVitePlugin()` with `applyToEnvironment()` instead. |
| `client` | `boolean` | `false` | If set to `true`, the callback function will be called when building the client bundle. **Deprecated in Nuxt 5+.** Use `addVitePlugin()` with `applyToEnvironment()` instead. |
| `prepend` | `boolean` | `false` | If set to `true`, the callback function will be prepended to the array with `unshift()` instead of `push()`. |

## extendWebpackConfig

Extends the webpack configuration. Callback function can be called multiple times, when applying to both client and server builds.

### Usage

```ts
import { defineNuxtModule, extendWebpackConfig } from '@nuxt/kit'

export default defineNuxtModule({

  setup () {

    extendWebpackConfig((config) => {

      config.module!.rules!.push({

        test: /\.txt$/,

        use: 'raw-loader',

      })

    })

  },

})
```

### Type

```ts
function extendWebpackConfig (callback: ((config: WebpackConfig) => void), options?: ExtendWebpackConfigOptions): void
```

Check out webpack website for more information about its configuration.

### Parameters

**`callback`**: A callback function that will be called with the webpack configuration object.

**`options`**: Options to pass to the callback function. This object can have the following properties:

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `dev` | `boolean` | `false` | If set to `true`, the callback function will be called when building in development mode. |
| `build` | `boolean` | `false` | If set to `true`, the callback function will be called when building in production mode. |
| `server` | `boolean` | `false` | If set to `true`, the callback function will be called when building the server bundle. |
| `client` | `boolean` | `false` | If set to `true`, the callback function will be called when building the client bundle. |
| `prepend` | `boolean` | `false` | If set to `true`, the callback function will be prepended to the array with `unshift()` instead of `push()`. |

## addVitePlugin

Append Vite plugin to the config.

In Nuxt 5+, plugins registered with `server: false` or `client: false` options will not have their `config` or `configResolved` hooks called. Instead, use the `applyToEnvironment()` method instead for environment-specific plugins.

### Usage

```ts
import { addVitePlugin, defineNuxtModule } from '@nuxt/kit'

import { svg4VuePlugin } from 'vite-plugin-svg4vue'

export default defineNuxtModule({

  meta: {

    name: 'nuxt-svg-icons',

    configKey: 'nuxtSvgIcons',

  },

  defaults: {

    svg4vue: {

      assetsDirName: 'assets/icons',

    },

  },

  setup (options) {

    addVitePlugin(svg4VuePlugin(options.svg4vue))

    // or, to add a vite plugin to only one environment

    addVitePlugin(() => ({

      name: 'my-client-plugin',

      applyToEnvironment (environment) {

        return environment.name === 'client'

      },

      // ... rest of your client-only plugin

    }))

  },

})
```

### Type

```ts
function addVitePlugin (pluginOrGetter: VitePlugin | VitePlugin[] | (() => VitePlugin | VitePlugin[]), options?: ExtendViteConfigOptions): void
```

See [Vite website](https://vite.dev/guide/api-plugin) for more information about Vite plugins. You can also use [this repository](https://github.com/vitejs/awesome-vite#plugins) to find a plugin that suits your needs.

### Parameters

**`pluginOrGetter`**: A Vite plugin instance or an array of Vite plugin instances. If a function is provided, it must return a Vite plugin instance or an array of Vite plugin instances. The function can also be async or return a Promise, which is useful for lazy-loading plugins:

```ts
import { addVitePlugin, defineNuxtModule } from '@nuxt/kit'

export default defineNuxtModule({

  setup () {

    // Lazy load the plugin - only imported when the build actually runs

    addVitePlugin(() => import('my-vite-plugin').then(r => r.default()))

  },

})
```

**`options`**: Options to pass to the callback function. This object can have the following properties:

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `dev` | `boolean` | `false` | If set to `true`, the callback function will be called when building in development mode. |
| `build` | `boolean` | `false` | If set to `true`, the callback function will be called when building in production mode. |
| `server` | `boolean` | `false` | If set to `true`, the callback function will be called when building the server bundle. **Deprecated in Nuxt 5+.** Use `applyToEnvironment()` instead. |
| `client` | `boolean` | `false` | If set to `true`, the callback function will be called when building the client bundle. **Deprecated in Nuxt 5+.** Use `applyToEnvironment()` instead. |
| `prepend` | `boolean` | `false` | If set to `true`, the callback function will be prepended to the array with `unshift()` instead of `push()`. |

## addWebpackPlugin

Append webpack plugin to the config.

### Usage

```ts
import EslintWebpackPlugin from 'eslint-webpack-plugin'

import { addWebpackPlugin, defineNuxtModule } from '@nuxt/kit'

export default defineNuxtModule({

  meta: {

    name: 'nuxt-eslint',

    configKey: 'eslint',

  },

  defaults: nuxt => ({

    include: [\`${nuxt.options.srcDir}/**/*.{js,jsx,ts,tsx,vue}\`],

    lintOnStart: true,

  }),

  setup (options, nuxt) {

    const webpackOptions = {

      ...options,

      context: nuxt.options.srcDir,

      files: options.include,

      lintDirtyModulesOnly: !options.lintOnStart,

    }

    addWebpackPlugin(new EslintWebpackPlugin(webpackOptions), { server: false })

  },

})
```

### Type

```ts
function addWebpackPlugin (pluginOrGetter: WebpackPluginInstance | WebpackPluginInstance[] | (() => WebpackPluginInstance | WebpackPluginInstance[]), options?: ExtendWebpackConfigOptions): void
```

See [webpack website](https://webpack.js.org/concepts/plugins/) for more information about webpack plugins. You can also use [this collection](https://webpack.js.org/awesome-webpack/#webpack-plugins) to find a plugin that suits your needs.

### Parameters

**`pluginOrGetter`**: A webpack plugin instance or an array of webpack plugin instances. If a function is provided, it must return a webpack plugin instance or an array of webpack plugin instances. The function can also be async or return a Promise, enabling lazy-loading of plugins.

**`options`**: Options to pass to the callback function. This object can have the following properties:

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `dev` | `boolean` | `false` | If set to `true`, the callback function will be called when building in development mode. |
| `build` | `boolean` | `false` | If set to `true`, the callback function will be called when building in production mode. |
| `server` | `boolean` | `false` | If set to `true`, the callback function will be called when building the server bundle. |
| `client` | `boolean` | `false` | If set to `true`, the callback function will be called when building the client bundle. |
| `prepend` | `boolean` | `false` | If set to `true`, the callback function will be prepended to the array with `unshift()` instead of `push()`. |

## addBuildPlugin

Builder-agnostic version of `addVitePlugin` and `addWebpackPlugin`. It will add the plugin to both Vite and webpack configurations if they are present.

### Type

```ts
function addBuildPlugin (pluginFactory: AddBuildPluginFactory, options?: ExtendConfigOptions): void
```

### Parameters

**`pluginFactory`**: A factory function that returns an object with `vite` and/or `webpack` properties. These properties must be functions that return a Vite plugin instance or an array of Vite plugin instances and/or a webpack plugin instance or an array of webpack plugin instances.

**`options`**: Options to pass to the callback function. This object can have the following properties:

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `dev` | `boolean` | `false` | If set to `true`, the callback function will be called when building in development mode. |
| `build` | `boolean` | `false` | If set to `true`, the callback function will be called when building in production mode. |
| `server` | `boolean` | `false` | If set to `true`, the callback function will be called when building the server bundle. |
| `client` | `boolean` | `false` | If set to `true`, the callback function will be called when building the client bundle. |
| `prepend` | `boolean` | `false` | If set to `true`, the callback function will be prepended to the array with `unshift()` instead of `push()`. |

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/5.kit/14.builder.md)[Logging](https://nuxt.com/docs/4.x/api/kit/logging)

[

Nuxt Kit provides a set of utilities to help you work with logging. These functions allow you to log messages with extra features.

](https://nuxt.com/docs/4.x/api/kit/logging)[

Examples

Examples of Nuxt Kit utilities in use.

](https://nuxt.com/docs/4.x/api/kit/examples)