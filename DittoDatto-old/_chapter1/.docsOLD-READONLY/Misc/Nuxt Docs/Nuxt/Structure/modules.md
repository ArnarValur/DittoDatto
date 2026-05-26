---
title: "modules · Nuxt Directory Structure v4"
source: "https://nuxt.com/docs/4.x/directory-structure/modules"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
It is a good place to place any local modules you develop while building your application.

The auto-registered files patterns are:

- `modules/*/index.ts`
- `modules/*.ts`

You don't need to add those local modules to your [`nuxt.config.ts`](https://nuxt.com/docs/4.x/directory-structure/nuxt-config) separately.

```ts
// \`nuxt/kit\` is a helper subpath import you can use when defining local modules

// that means you do not need to add \`@nuxt/kit\` to your project's dependencies

import { addComponentsDir, addServerHandler, createResolver, defineNuxtModule } from 'nuxt/kit'

export default defineNuxtModule({

  meta: {

    name: 'hello',

  },

  setup () {

    const resolver = createResolver(import.meta.url)

    // Add an API route

    addServerHandler({

      route: '/api/hello',

      handler: resolver.resolve('./runtime/api-route'),

    })

    // Add components

    addComponentsDir({

      path: resolver.resolve('./runtime/app/components'),

      pathPrefix: true, // Prefix your exports to avoid conflicts with user code or other modules

    })

  },

})
```

When starting Nuxt, the `hello` module will be registered and the `/api/hello` route will be available.

Note that all components, pages, composables and other files that would be normally placed in your `app/` directory need to be in `modules/your-module/runtime/app/`. This ensures they can be type-checked properly.

Modules are executed in the following sequence:

- First, the modules defined in [`nuxt.config.ts`](https://nuxt.com/docs/4.x/api/nuxt-config#modules-1) are loaded.
- Then, modules found in the `modules/` directory are executed, and they load in alphabetical order.

You can change the order of local module by adding a number to the front of each directory name:

Directory structure

```bash
modules/

  1.first-module/

    index.ts

  2.second-module.ts
```

Read more in Docs > 4 X > Guide > Modules.

Watch Vue School video about Nuxt private modules.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/2.directory-structure/1.modules.md)