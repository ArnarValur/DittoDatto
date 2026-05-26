---
title: "Nitro · Nuxt Kit v4"
source: "https://nuxt.com/docs/4.x/api/kit/nitro"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## Nitro

[Source](https://github.com/nuxt/nuxt/blob/main/packages/kit/src/nitro.ts)

Nuxt Kit provides a set of utilities to help you work with Nitro. These functions allow you to add server handlers, plugins, and prerender routes.

Nitro is an open source TypeScript framework to build ultra-fast web servers. Nuxt uses Nitro as its server engine. You can use `useNitro` to access the Nitro instance, `addServerHandler` to add a server handler, `addDevServerHandler` to add a server handler to be used only in development mode, `addServerPlugin` to add a plugin to extend Nitro's runtime behavior, and `addPrerenderRoutes` to add routes to be prerendered by Nitro.

## addServerHandler

Adds a Nitro server handler. Use this if you want to create server middleware or a custom route.

### Usage

```ts
import { addServerHandler, createResolver, defineNuxtModule } from '@nuxt/kit'

export default defineNuxtModule({

  setup (options) {

    const { resolve } = createResolver(import.meta.url)

    addServerHandler({

      route: '/robots.txt',

      handler: resolve('./runtime/robots.get'),

    })

  },

})
```

### Type

```ts
function addServerHandler (handler: NitroEventHandler): void
```

### Parameters

**handler**: A handler object with the following properties:

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `handler` | `string` | `true` | Path to event handler. |
| `route` | `string` | `false` | Path prefix or route. If an empty string used, will be used as a middleware. |
| `middleware` | `boolean` | `false` | Specifies this is a middleware handler. Middleware are called on every route and should normally return nothing to pass to the next handlers. |
| `lazy` | `boolean` | `false` | Use lazy loading to import the handler. This is useful when you only want to load the handler on demand. |
| `method` | `string` | `false` | Router method matcher. If handler name contains method name, it will be used as a default value. |

### Examples

#### Basic Usage

You can use `addServerHandler` to add a server handler from your module.

When you access `/robots.txt`, it will return the following response:

```
User-agent: *

Disallow: /
```

## addDevServerHandler

Adds a Nitro server handler to be used only in development mode. This handler will be excluded from production build.

### Usage

```ts
import { defineEventHandler } from 'h3'

import { addDevServerHandler, createResolver, defineNuxtModule } from '@nuxt/kit'

export default defineNuxtModule({

  setup () {

    addDevServerHandler({

      handler: defineEventHandler(() => {

        return {

          body: \`Response generated at ${new Date().toISOString()}\`,

        }

      }),

      route: '/_handler',

    })

  },

})
```

### Type

```ts
function addDevServerHandler (handler: NitroDevEventHandler): void
```

### Parameters

**handler**: A handler object with the following properties:

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `handler` | `EventHandler` | `true` | Event handler. |
| `route` | `string` | `false` | Path prefix or route. If an empty string used, will be used as a middleware. |

### Examples

#### Basic Usage

In some cases, you may want to create a server handler specifically for development purposes, such as a Tailwind config viewer.

```ts
import { joinURL } from 'ufo'

import { addDevServerHandler, defineNuxtModule } from '@nuxt/kit'

export default defineNuxtModule({

  async setup (options, nuxt) {

    const route = joinURL(nuxt.options.app?.baseURL, '/_tailwind')

    // @ts-expect-error - tailwind-config-viewer does not have correct types

    const createServer = await import('tailwind-config-viewer/server/index.js').then(r => r.default || r) as any

    const viewerDevMiddleware = createServer({ tailwindConfigProvider: () => options, routerPrefix: route }).asMiddleware()

    addDevServerHandler({ route, handler: viewerDevMiddleware })

  },

})
```

## useNitro

Returns the Nitro instance.

You can call `useNitro()` only after `ready` hook.

Changes to the Nitro instance configuration are not applied.

### Usage

```ts
import { defineNuxtModule, useNitro } from '@nuxt/kit'

export default defineNuxtModule({

  setup (options, nuxt) {

    const resolver = createResolver(import.meta.url)

    nuxt.hook('ready', () => {

      const nitro = useNitro()

      // Do something with Nitro instance

    })

  },

})
```

### Type

```ts
function useNitro (): Nitro
```

## addServerPlugin

Add plugin to extend Nitro's runtime behavior.

You can read more about Nitro plugins in the [Nitro documentation](https://nitro.build/guide/plugins).

It is necessary to explicitly import `defineNitroPlugin` from `nitropack/runtime` within your plugin file. The same requirement applies to utilities such as `useRuntimeConfig`.

### Usage

```ts
import { addServerPlugin, createResolver, defineNuxtModule } from '@nuxt/kit'

export default defineNuxtModule({

  setup () {

    const { resolve } = createResolver(import.meta.url)

    addServerPlugin(resolve('./runtime/plugin.ts'))

  },

})
```

### Type

```ts
function addServerPlugin (plugin: string): void
```

### Parameters

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `plugin` | `string` | `true` | Path to the plugin. The plugin must export a default function that accepts the Nitro instance as an argument. |

### Examples

## addPrerenderRoutes

Add routes to be prerendered to Nitro.

### Usage

```ts
import { addPrerenderRoutes, defineNuxtModule } from '@nuxt/kit'

export default defineNuxtModule({

  meta: {

    name: 'nuxt-sitemap',

    configKey: 'sitemap',

  },

  defaults: {

    sitemapUrl: '/sitemap.xml',

    prerender: true,

  },

  setup (options) {

    if (options.prerender) {

      addPrerenderRoutes(options.sitemapUrl)

    }

  },

})
```

### Type

```ts
function addPrerenderRoutes (routes: string | string[]): void
```

### Parameters

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `routes` | `string \| string[]` | `true` | A route or an array of routes to prerender. |

## addServerImports

Add imports to the server. It makes your imports available in Nitro without the need to import them manually.

If you want to provide a utility that works in both server and client contexts and is usable in the [`shared/`](https://nuxt.com/docs/4.x/directory-structure/shared) directory, the function must be imported from the same source file for both [`addImports`](https://nuxt.com/docs/4.x/api/kit/autoimports#addimports) and `addServerImports` and should have identical signature. That source file should not import anything context-specific (i.e., Nitro context, Nuxt app context) or else it might cause errors during type-checking.

### Usage

```ts
import { addServerImports, createResolver, defineNuxtModule } from '@nuxt/kit'

export default defineNuxtModule({

  setup (options) {

    const names = [

      'useStoryblok',

      'useStoryblokApi',

      'useStoryblokBridge',

      'renderRichText',

      'RichTextSchema',

    ]

    names.forEach(name =>

      addServerImports({ name, as: name, from: '@storyblok/vue' }),

    )

  },

})
```

### Type

```ts
function addServerImports (dirs: Import | Import[]): void
```

### Parameters

`imports`: An object or an array of objects with the following properties:

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `name` | `string` | `true` | Import name to be detected. |
| `from` | `string` | `true` | Module specifier to import from. |
| `priority` | `number` | `false` | Priority of the import; if multiple imports have the same name, the one with the highest priority will be used. |
| `disabled` | `boolean` | `false` | If this import is disabled. |
| `meta` | `Record<string, any>` | `false` | Metadata of the import. |
| `type` | `boolean` | `false` | If this import is a pure type import. |
| `typeFrom` | `string` | `false` | Use this as the `from` value when generating type declarations. |
| `as` | `string` | `false` | Import as this name. |

## addServerImportsDir

Add a directory to be scanned for auto-imports by Nitro.

### Usage

```ts
import { addServerImportsDir, createResolver, defineNuxtModule } from '@nuxt/kit'

export default defineNuxtModule({

  meta: {

    name: 'my-module',

    configKey: 'myModule',

  },

  setup (options) {

    const { resolve } = createResolver(import.meta.url)

    addServerImportsDir(resolve('./runtime/server/composables'))

  },

})
```

### Type

```ts
function addServerImportsDir (dirs: string | string[], opts: { prepend?: boolean }): void
```

### Parameters

### Examples

You can use `addServerImportsDir` to add a directory to be scanned by Nitro. This is useful when you want Nitro to auto-import functions from a custom server directory.

You can then use the `useApiSecret` function in your server code:

runtime/server/api/hello.ts

```ts
export default defineEventHandler(() => {

  const apiSecret = useApiSecret()

  // Do something with the apiSecret

})
```

## addServerScanDir

Add directories to be scanned by Nitro. It will check for subdirectories, which will be registered just like the `~~/server` folder is.

Only `~~/server/api`, `~~/server/routes`, `~~/server/middleware`, and `~~/server/utils` are scanned.

### Usage

```ts
import { addServerScanDir, createResolver, defineNuxtModule } from '@nuxt/kit'

export default defineNuxtModule({

  meta: {

    name: 'my-module',

    configKey: 'myModule',

  },

  setup (options) {

    const { resolve } = createResolver(import.meta.url)

    addServerScanDir(resolve('./runtime/server'))

  },

})
```

### Type

```ts
function addServerScanDir (dirs: string | string[], opts: { prepend?: boolean }): void
```

### Parameters

### Examples

You can use `addServerScanDir` to add a directory to be scanned by Nitro. This is useful when you want to add a custom server directory.

You can then use the `hello` function in your server code.

runtime/server/api/hello.ts

```ts
export default defineEventHandler(() => {

  return hello() // Hello from server utils!

})
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/5.kit/11.nitro.md)[Templates](https://nuxt.com/docs/4.x/api/kit/templates)

[

Nuxt Kit provides a set of utilities to help you work with templates. These functions allow you to generate extra files during development and build time.

](https://nuxt.com/docs/4.x/api/kit/templates)[

Resolving

Nuxt Kit provides a set of utilities to help you resolve paths. These functions allow you to resolve paths relative to the current module, with unknown name or extension.

](https://nuxt.com/docs/4.x/api/kit/resolving)