---
title: "Templates · Nuxt Kit v4"
source: "https://nuxt.com/docs/4.x/api/kit/templates"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## Templates

[Source](https://github.com/nuxt/nuxt/blob/main/packages/kit/src/template.ts)

Nuxt Kit provides a set of utilities to help you work with templates. These functions allow you to generate extra files during development and build time.

Templates allow you to generate extra files during development and build time. These files will be available in virtual filesystem and can be used in plugins, layouts, components, etc. `addTemplate` and `addTypeTemplate` allow you to add templates to the Nuxt application. `updateTemplates` allows you to regenerate templates that match the filter.

## addTemplate

Renders given template during build into the virtual file system, and optionally to disk in the project `buildDir`

### Usage

```ts
import { addTemplate, defineNuxtModule } from '@nuxt/kit'

import { defu } from 'defu'

export default defineNuxtModule({

  setup (options, nuxt) {

    const globalMeta = defu(nuxt.options.app.head, {

      charset: options.charset,

      viewport: options.viewport,

    })

    addTemplate({

      filename: 'meta.config.mjs',

      getContents: () => 'export default ' + JSON.stringify({ globalMeta, mixinKey: 'setup' }),

    })

  },

})
```

### Type

```ts
function addTemplate (template: NuxtTemplate | string): ResolvedNuxtTemplate
```

### Parameters

**template**: A template object or a string with the path to the template. If a string is provided, it will be converted to a template object with `src` set to the string value. If a template object is provided, it must have the following properties:

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `src` | `string` | `false` | Path to the template. If `src` is not provided, `getContents` must be provided instead. |
| `filename` | `string` | `false` | Filename of the template. If `filename` is not provided, it will be generated from the `src` path. In this case, the `src` option is required. |
| `dst` | `string` | `false` | Path to the destination file. If `dst` is not provided, it will be generated from the `filename` path and nuxt `buildDir` option. |
| `options` | `Options` | `false` | Options to pass to the template. |
| `getContents` | `(data: Options) => string \| Promise<string>` | `false` | A function that will be called with the `options` object. It should return a string or a promise that resolves to a string. If `src` is provided, this function will be ignored. |
| `write` | `boolean` | `false` | If set to `true`, the template will be written to the destination file. Otherwise, the template will be used only in virtual filesystem. |

### Examples

#### Creating a Virtual File for Runtime Plugin

In this example, we merge an object inside a module and consume the result in a runtime plugin.

module.ts

```ts
import { addTemplate, defineNuxtModule } from '@nuxt/kit'

import { defu } from 'defu'

export default defineNuxtModule({

  setup (options, nuxt) {

    const globalMeta = defu(nuxt.options.app.head, {

      charset: options.charset,

      viewport: options.viewport,

    })

    addTemplate({

      filename: 'meta.config.mjs',

      getContents: () => 'export default ' + JSON.stringify({ globalMeta, mixinKey: 'setup' }),

    })

  },

})
```

In the module above, we generate a virtual file named `meta.config.mjs`. In the runtime plugin, we can import it using the `#build` alias:

runtime/plugin.ts

```ts
import { createHead as createServerHead } from '@unhead/vue/server'

import { createHead as createClientHead } from '@unhead/vue/client'

import { defineNuxtPlugin } from '#imports'

// @ts-expect-error - virtual file

import metaConfig from '#build/meta.config.mjs'

export default defineNuxtPlugin((nuxtApp) => {

  const createHead = import.meta.server ? createServerHead : createClientHead

  const head = createHead()

  head.push(metaConfig.globalMeta)

  nuxtApp.vueApp.use(head)

})
```

## addTypeTemplate

Renders given template during build into the project buildDir, then registers it as types.

### Usage

```ts
import { addTypeTemplate, defineNuxtModule } from '@nuxt/kit'

export default defineNuxtModule({

  setup () {

    addTypeTemplate({

      filename: 'types/markdown.d.ts',

      getContents: () => \`declare module '*.md' {

  import type { ComponentOptions } from 'vue'

  const Component: ComponentOptions

  export default Component

}\`,

    })

  },

})
```

### Type

```ts
function addTypeTemplate (template: NuxtTypeTemplate | string, context?: { nitro?: boolean, nuxt?: boolean }): ResolvedNuxtTemplate
```

### Parameters

**template**: A template object or a string with the path to the template. If a string is provided, it will be converted to a template object with `src` set to the string value. If a template object is provided, it must have the following properties:

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `src` | `string` | `false` | Path to the template. If `src` is not provided, `getContents` must be provided instead. |
| `filename` | `string` | `false` | Filename of the template. If `filename` is not provided, it will be generated from the `src` path. In this case, the `src` option is required. |
| `dst` | `string` | `false` | Path to the destination file. If `dst` is not provided, it will be generated from the `filename` path and nuxt `buildDir` option. |
| `options` | `Options` | `false` | Options to pass to the template. |
| `getContents` | `(data: Options) => string \| Promise<string>` | `false` | A function that will be called with the `options` object. It should return a string or a promise that resolves to a string. If `src` is provided, this function will be ignored. |

**context**: An optional context object can be passed to control where the type is added. If omitted, the type will only be added to the Nuxt context. This object supports the following properties:

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `nuxt` | `boolean` | `false` | If set to `true`, the type will be added to the Nuxt context. |
| `nitro` | `boolean` | `false` | If set to `true`, the type will be added to the Nitro context. |

### Examples

#### Adding Type Templates to the Nitro Context

By default, －－ only adds the type declarations to the Nuxt context. To also add them to the Nitro context, set nitro to true.

```ts
import { addTypeTemplate, defineNuxtModule } from '@nuxt/kit'

export default defineNuxtModule({

  setup () {

    addTypeTemplate({

      filename: 'types/auth.d.ts',

      getContents: () => \`declare module '#auth-utils' {

  interface User {

    id: string;

    name: string;

  }

}\`,

    }, {

      nitro: true,

    })

  },

})
```

This allows the `#auth-utils` module to be used within the Nitro context.

server/api/auth.ts

```ts
import type { User } from '#auth-utils'

export default eventHandler(() => {

  const user: User = {

    id: '123',

    name: 'John Doe',

  }

  // do something with the user

  return user

})
```

## addServerTemplate

Adds a virtual file that can be used within the Nuxt Nitro server build.

### Usage

```ts
import { addServerTemplate, defineNuxtModule } from '@nuxt/kit'

export default defineNuxtModule({

  setup () {

    addServerTemplate({

      filename: '#my-module/test.mjs',

      getContents () {

        return 'export const test = 123'

      },

    })

  },

})
```

### Type

```ts
function addServerTemplate (template: NuxtServerTemplate): NuxtServerTemplate
```

### Parameters

**template**: A template object. It must have the following properties:

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `filename` | `string` | `true` | Filename of the template. |
| `getContents` | `() => string \| Promise<string>` | `true` | A function that will be called with the `options` object. It should return a string or a promise that resolves to a string. |

### Examples

### Creating a Virtual File for Nitro

In this example, we create a virtual file that can be used within the Nuxt Nitro server build.

```ts
import { addServerTemplate, defineNuxtModule } from '@nuxt/kit'

export default defineNuxtModule({

  setup () {

    addServerTemplate({

      filename: '#my-module/test.mjs',

      getContents () {

        return 'export const test = 123'

      },

    })

  },

})
```

And then in a runtime file

server/api/test.ts

```ts
import { test } from '#my-module/test.js'

export default eventHandler(() => {

  return test

})
```

## updateTemplates

Regenerate templates that match the filter. If no filter is provided, all templates will be regenerated.

### Usage

```ts
import { defineNuxtModule, updateTemplates } from '@nuxt/kit'

import { resolve } from 'pathe'

export default defineNuxtModule({

  setup (options, nuxt) {

    const updateTemplatePaths = [

      resolve(nuxt.options.srcDir, 'pages'),

    ]

    // watch and rebuild routes template list when one of the pages changes

    nuxt.hook('builder:watch', async (event, relativePath) => {

      if (event === 'change') {

        return

      }

      const path = resolve(nuxt.options.srcDir, relativePath)

      if (updateTemplatePaths.some(dir => path.startsWith(dir))) {

        await updateTemplates({

          filter: template => template.filename === 'routes.mjs',

        })

      }

    })

  },

})
```

### Type

```ts
async function updateTemplates (options: UpdateTemplatesOptions): void
```

### Parameters

**options**: Options to pass to the template. This object can have the following property:

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `filter` | `(template: ResolvedNuxtTemplate) => boolean` | `false` | A function that will be called with the `template` object. It should return a boolean indicating whether the template should be regenerated. If `filter` is not provided, all templates will be regenerated. |

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/5.kit/10.templates.md)[Runtime Config](https://nuxt.com/docs/4.x/api/kit/runtime-config)

[

Nuxt Kit provides a set of utilities to help you access and modify Nuxt runtime configuration.

](https://nuxt.com/docs/4.x/api/kit/runtime-config)[

Nitro

Nuxt Kit provides a set of utilities to help you work with Nitro. These functions allow you to add server handlers, plugins, and prerender routes.

](https://nuxt.com/docs/4.x/api/kit/nitro)