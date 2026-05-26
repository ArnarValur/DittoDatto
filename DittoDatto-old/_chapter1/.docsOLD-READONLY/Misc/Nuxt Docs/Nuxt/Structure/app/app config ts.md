---
title: "app.config.ts · Nuxt Directory Structure v4"
source: "https://nuxt.com/docs/4.x/directory-structure/app/app-config"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## app.config.ts

Expose reactive configuration within your application with the App Config file.

Nuxt provides an `app/app.config.ts` config file to expose reactive configuration within your application with the ability to update it at runtime within lifecycle or using a nuxt plugin and editing it with HMR (hot-module-replacement).

You can easily provide runtime app configuration using `app.config.ts` file. It can have either of `.ts`, `.js`, or `.mjs` extensions.

app/app.config.ts

```ts
export default defineAppConfig({

  foo: 'bar',

})
```

When configuring a custom [`srcDir`](https://nuxt.com/docs/4.x/api/nuxt-config#srcdir), make sure to place the `app.config` file at the root of the new `srcDir` path.

## Usage

To expose config and environment variables to the rest of your app, you will need to define configuration in `app.config` file.

app/app.config.ts

```ts
export default defineAppConfig({

  theme: {

    primaryColor: '#ababab',

  },

})
```

We can now universally access `theme` both when server-rendering the page and in the browser using [`useAppConfig`](https://nuxt.com/docs/4.x/api/composables/use-app-config) composable.

app/pages/index.vue

```
<script setup lang="ts">

const appConfig = useAppConfig()

console.log(appConfig.theme)

</script>
```

The [`updateAppConfig`](https://nuxt.com/docs/4.x/api/utils/update-app-config) utility can be used to update the `app.config` at runtime.

app/pages/index.vue

```
<script setup>

const appConfig = useAppConfig() // { foo: 'bar' }

const newAppConfig = { foo: 'baz' }

updateAppConfig(newAppConfig)

console.log(appConfig) // { foo: 'baz' }

</script>
```

Read more about the `updateAppConfig` utility.

## Typing App Config

Nuxt tries to automatically generate a TypeScript interface from provided app config so you won't have to type it yourself.

However, there are some cases where you might want to type it yourself. There are two possible things you might want to type.

### App Config Input

`AppConfigInput` might be used by module authors who are declaring what valid *input* options are when setting app config. This will not affect the type of `useAppConfig()`.

index.d.ts

```ts
declare module 'nuxt/schema' {

  interface AppConfigInput {

    /** Theme configuration */

    theme?: {

      /** Primary app color */

      primaryColor?: string

    }

  }

}

// It is always important to ensure you import/export something when augmenting a type

export {}
```

### App Config Output

If you want to type the result of calling [`useAppConfig()`](https://nuxt.com/docs/4.x/api/composables/use-app-config), then you will want to extend `AppConfig`.

Be careful when typing `AppConfig` as you will overwrite the types Nuxt infers from your actually defined app config.

index.d.ts

```ts
declare module 'nuxt/schema' {

  interface AppConfig {

    // This will entirely replace the existing inferred \`theme\` property

    theme: {

      // You might want to type this value to add more specific types than Nuxt can infer,

      // such as string literal types

      primaryColor?: 'red' | 'blue'

    }

  }

}

// It is always important to ensure you import/export something when augmenting a type

export {}
```

## Merging Strategy

Nuxt uses a custom merging strategy for the `AppConfig` within [the layers](https://nuxt.com/docs/4.x/getting-started/layers) of your application.

This strategy is implemented using a [Function Merger](https://github.com/unjs/defu#function-merger), which allows defining a custom merging strategy for every key in `app.config` that has an array as value.

The function merger can only be used in the extended layers and not the main `app.config` in project.

Here's an example of how you can use:

## Known Limitations

As of Nuxt v3.3, the `app.config.ts` file is shared with Nitro, which results in the following limitations:

1. You cannot import Vue components directly in `app.config.ts`.
2. Some auto-imports are not available in the Nitro context.

These limitations occur because Nitro processes the app config without full Vue component support.

While it's possible to use Vite plugins in the Nitro config as a workaround, this approach is not recommended:

nuxt.config.ts

```ts
export default defineNuxtConfig({

  nitro: {

    vite: {

      plugins: [vue()],

    },

  },

})
```

Using this workaround may lead to unexpected behavior and bugs. The Vue plugin is one of many that are not available in the Nitro context.

Related issues:

- [Issue #19858](https://github.com/nuxt/nuxt/issues/19858)
- [Issue #19854](https://github.com/nuxt/nuxt/issues/19854)

Nitro v3 will resolve these limitations by removing support for the app config. You can track the progress in [this pull request](https://github.com/nitrojs/nitro/pull/2521).

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/2.directory-structure/1.app/3.app-config.md)[app.vue](https://nuxt.com/docs/4.x/directory-structure/app/app)

[

The app.vue file is the main component of your Nuxt application.

](https://nuxt.com/docs/4.x/directory-structure/app/app)[

error.vue

The error.vue file is the error page in your Nuxt application.

](https://nuxt.com/docs/4.x/directory-structure/app/error)