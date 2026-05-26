---
title: "Import meta · Nuxt API v4"
source: "https://nuxt.com/docs/4.x/api/advanced/import-meta"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## The import.meta object

With ES modules you can obtain some metadata from the code that imports or compiles your ES-module. This is done through `import.meta`, which is an object that provides your code with this information. Throughout the Nuxt documentation you may see snippets that use this already to figure out whether the code is currently running on the client or server side.

Read more about `import.meta`.

## Runtime (App) Properties

These values are statically injected and can be used for tree-shaking your runtime code.

| Property | Type | Description |
| --- | --- | --- |
| `import.meta.client` | boolean | True when evaluated on the client side. |
| `import.meta.browser` | boolean | True when evaluated on the client side. |
| `import.meta.server` | boolean | True when evaluated on the server side. |
| `import.meta.nitro` | boolean | True when evaluated on the server side. |
| `import.meta.dev` | boolean | True when running the Nuxt dev server. |
| `import.meta.test` | boolean | True when running in a test context. |
| `import.meta.prerender` | boolean | True when rendering HTML on the server in the prerender stage of your build. |

## Builder Properties

These values are available both in modules and in your `nuxt.config`.

| Property | Type | Description |
| --- | --- | --- |
| `import.meta.env` | object | Equals `process.env` |
| `import.meta.url` | string | Resolvable path for the current file. |

## Examples

### Using import.meta.url to resolve files within modules

modules/my-module/index.ts

```ts
import { createResolver } from 'nuxt/kit'

// Resolve relative from the current file

const resolver = createResolver(import.meta.url)

export default defineNuxtModule({

  meta: { name: 'myModule' },

  setup () {

    addComponent({

      name: 'MyModuleComponent',

      // Resolves to '/modules/my-module/components/MyModuleComponent.vue'

      filePath: resolver.resolve('./components/MyModuleComponent.vue'),

    })

  },

})
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/6.advanced/2.import-meta.md)[Lifecycle Hooks](https://nuxt.com/docs/4.x/api/advanced/hooks)

[

Nuxt provides a powerful hooking system to expand almost every aspect using hooks.

](https://nuxt.com/docs/4.x/api/advanced/hooks)[

Nuxt Configuration

Discover all the options you can use in your nuxt.config.ts file.

](https://nuxt.com/docs/4.x/api/nuxt-config)