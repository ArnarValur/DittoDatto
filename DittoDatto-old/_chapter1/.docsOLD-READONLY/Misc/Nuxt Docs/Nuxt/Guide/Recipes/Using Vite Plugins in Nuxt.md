---
title: "Using Vite Plugins in Nuxt · Recipes v4"
source: "https://nuxt.com/docs/4.x/guide/recipes/vite-plugin"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## Using Vite Plugins in Nuxt

Learn how to integrate Vite plugins into your Nuxt project.

While Nuxt modules offer extensive functionality, sometimes a specific Vite plugin might meet your needs more directly.

First, we need to install the Vite plugin, for our example, we'll use `@rollup/plugin-yaml`:

Next, we need to import and add it to our [`nuxt.config.ts`](https://nuxt.com/docs/4.x/directory-structure/nuxt-config) file:

nuxt.config.ts

```ts
import yaml from '@rollup/plugin-yaml'

export default defineNuxtConfig({

  vite: {

    plugins: [

      yaml(),

    ],

  },

})
```

Now we installed and configured our Vite plugin, we can start using YAML files directly in our project.

For example, we can have a `config.yaml` that stores configuration data and import this data in our Nuxt components:

## Using Vite Plugins in Nuxt Modules

If you're developing a Nuxt module and need to add Vite plugins, you should use the [`addVitePlugin`](https://nuxt.com/docs/4.x/api/kit/builder#addviteplugin) utility:

modules/my-module.ts

```ts
import { addVitePlugin, defineNuxtModule } from '@nuxt/kit'

import yaml from '@rollup/plugin-yaml'

export default defineNuxtModule({

  setup () {

    addVitePlugin(yaml())

  },

})
```

For environment-specific plugins in Nuxt 5+, use the `applyToEnvironment()` method:

modules/my-module.ts

```ts
import { addVitePlugin, defineNuxtModule } from '@nuxt/kit'

export default defineNuxtModule({

  setup () {

    addVitePlugin(() => ({

      name: 'my-client-plugin',

      applyToEnvironment (environment) {

        return environment.name === 'client'

      },

      // Plugin configuration

    }))

  },

})
```

If you're writing code that needs to access resolved Vite configuration, you should use the `config` and `configResolved` hooks *within* your Vite plugin, rather than using Nuxt's `vite:extend`, `vite:extendConfig` and `vite:configResolved`.

Read more about `addVitePlugin` in the Nuxt Kit documentation.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/3.guide/5.recipes/2.vite-plugin.md)[Custom Routing](https://nuxt.com/docs/4.x/guide/recipes/custom-routing)

[

In Nuxt, your routing is defined by the structure of your files inside the pages directory. However, since it uses vue-router under the hood, Nuxt offers you several ways to add custom routes in your project.

](https://nuxt.com/docs/4.x/guide/recipes/custom-routing)[

Custom useFetch

How to create a custom fetcher for calling your external API in Nuxt.

](https://nuxt.com/docs/4.x/guide/recipes/custom-usefetch)