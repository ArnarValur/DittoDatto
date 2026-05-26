---
title: "Resolving · Nuxt Kit v4"
source: "https://nuxt.com/docs/4.x/api/kit/resolving"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## Resolving

[Source](https://github.com/nuxt/nuxt/blob/main/packages/kit/src/resolve.ts)

Nuxt Kit provides a set of utilities to help you resolve paths. These functions allow you to resolve paths relative to the current module, with unknown name or extension.

Sometimes you need to resolve a paths: relative to the current module, with unknown name or extension. For example, you may want to add a plugin that is located in the same directory as the module. To handle this cases, nuxt provides a set of utilities to resolve paths. `resolvePath` and `resolveAlias` are used to resolve paths relative to the current module. `findPath` is used to find first existing file in given paths. `createResolver` is used to create resolver relative to base path.

## resolvePath

Resolves full path to a file or directory respecting Nuxt alias and extensions options. If path could not be resolved, normalized input path will be returned.

### Usage

```ts
import { defineNuxtModule, resolvePath } from '@nuxt/kit'

export default defineNuxtModule({

  async setup () {

    const entrypoint = await resolvePath('@unhead/vue')

    console.log(\`Unhead entrypoint is ${entrypoint}\`)

  },

})
```

### Type

```ts
function resolvePath (path: string, options?: ResolvePathOptions): Promise<string>
```

### Parameters

**`path`**: A path to resolve.

**`options`**: Options to pass to the resolver. This object can have the following properties:

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `cwd` | `string` | `false` | Base for resolving paths from. Default is Nuxt rootDir. |
| `alias` | `Record<string, string>` | `false` | An object of aliases. Default is Nuxt configured aliases. |
| `extensions` | `string[]` | `false` | The file extensions to try. Default is Nuxt configured extensions. |
| `virtual` | `boolean` | `false` | Whether to resolve files that exist in the Nuxt VFS (for example, as a Nuxt template). |
| `fallbackToOriginal` | `boolean` | `false` | Whether to fallback to the original path if the resolved path does not exist instead of returning the normalized input path. |

### Examples

```ts
import { defineNuxtModule, resolvePath } from '@nuxt/kit'

import { join } from 'pathe'

const headlessComponents: ComponentGroup[] = [

  {

    relativePath: 'combobox/combobox.js',

    chunkName: 'headlessui/combobox',

    exports: [

      'Combobox',

      'ComboboxLabel',

      'ComboboxButton',

      'ComboboxInput',

      'ComboboxOptions',

      'ComboboxOption',

    ],

  },

]

export default defineNuxtModule({

  meta: {

    name: 'nuxt-headlessui',

    configKey: 'headlessui',

  },

  defaults: {

    prefix: 'Headless',

  },

  async setup (options) {

    const entrypoint = await resolvePath('@headlessui/vue')

    const root = join(entrypoint, '../components')

    for (const group of headlessComponents) {

      for (const e of group.exports) {

        addComponent(

          {

            name: e,

            export: e,

            filePath: join(root, group.relativePath),

            chunkName: group.chunkName,

            mode: 'all',

          },

        )

      }

    }

  },

})
```

## resolveAlias

Resolves path aliases respecting Nuxt alias options.

### Type

```ts
function resolveAlias (path: string, alias?: Record<string, string>): string
```

### Parameters

**`path`**: A path to resolve.

**`alias`**: An object of aliases. If not provided, it will be read from `nuxt.options.alias`.

## findPath

Try to resolve first existing file in given paths.

### Usage

```ts
import { defineNuxtModule, findPath } from '@nuxt/kit'

import { join } from 'pathe'

export default defineNuxtModule({

  async setup (_, nuxt) {

    // Resolve main (app.vue)

    const mainComponent = await findPath([

      join(nuxt.options.srcDir, 'App'),

      join(nuxt.options.srcDir, 'app'),

    ])

  },

})
```

### Type

```ts
function findPath (paths: string | string[], options?: ResolvePathOptions, pathType: 'file' | 'dir'): Promise<string | null>
```

### Parameters

**`paths`**: A path or an array of paths to resolve.

**`options`**: Options to pass to the resolver. This object can have the following properties:

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `cwd` | `string` | `false` | Base for resolving paths from. Default is Nuxt rootDir. |
| `alias` | `Record<string, string>` | `false` | An object of aliases. Default is Nuxt configured aliases. |
| `extensions` | `string[]` | `false` | The file extensions to try. Default is Nuxt configured extensions. |
| `virtual` | `boolean` | `false` | Whether to resolve files that exist in the Nuxt VFS (for example, as a Nuxt template). |
| `fallbackToOriginal` | `boolean` | `false` | Whether to fallback to the original path if the resolved path does not exist instead of returning the normalized input path. |

## createResolver

Creates resolver relative to base path.

Watch Vue School video about createResolver.

### Usage

```ts
import { createResolver, defineNuxtModule } from '@nuxt/kit'

export default defineNuxtModule({

  setup (_, nuxt) {

    const { resolve, resolvePath } = createResolver(import.meta.url)

  },

})
```

### Type

```ts
function createResolver (basePath: string | URL): Resolver
```

### Parameters

**`basePath`**: A base path to resolve from. It can be a string or a URL.

### Return Value

The `createResolver` function returns an object with the following properties:

| Property | Type | Description |
| --- | --- | --- |
| `resolve` | `(path: string) => string` | A function that resolves a path relative to the base path. |
| `resolvePath` | `(path: string, options?: ResolvePathOptions) => Promise<string>` | A function that resolves a path relative to the base path and respects Nuxt alias and extensions options. |

### Examples

```ts
import { createResolver, defineNuxtModule, isNuxt2 } from '@nuxt/kit'

export default defineNuxtModule({

  setup (options, nuxt) {

    const resolver = createResolver(import.meta.url)

    nuxt.hook('modules:done', () => {

      if (isNuxt2()) {

        addPlugin(resolver.resolve('./runtime/plugin.vue2'))

      } else {

        addPlugin(resolver.resolve('./runtime/plugin.vue3'))

      }

    })

  },

})
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/5.kit/12.resolving.md)[Nitro](https://nuxt.com/docs/4.x/api/kit/nitro)

[

Nuxt Kit provides a set of utilities to help you work with Nitro. These functions allow you to add server handlers, plugins, and prerender routes.

](https://nuxt.com/docs/4.x/api/kit/nitro)[

Logging

Nuxt Kit provides a set of utilities to help you work with logging. These functions allow you to log messages with extra features.

](https://nuxt.com/docs/4.x/api/kit/logging)