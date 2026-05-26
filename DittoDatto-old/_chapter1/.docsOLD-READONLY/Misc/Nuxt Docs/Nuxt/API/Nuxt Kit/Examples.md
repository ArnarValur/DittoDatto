---
title: "Examples · Nuxt Kit v4"
source: "https://nuxt.com/docs/4.x/api/kit/examples"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## Examples

Examples of Nuxt Kit utilities in use.

## Accessing Nuxt Vite Config

If you are building an integration that needs access to the runtime Vite or webpack config that Nuxt uses, it is possible to extract this using Kit utilities.

Some examples of projects doing this already:

- [histoire](https://github.com/histoire-dev/histoire/blob/main/packages/histoire-plugin-nuxt/src/index.ts)
- [nuxt-vitest](https://github.com/danielroe/nuxt-vitest/blob/main/packages/nuxt-vitest/src/config.ts)
- [@storybook-vue/nuxt](https://github.com/storybook-vue/storybook-nuxt/blob/main/packages/storybook-nuxt/src/preset.ts)

Here is a brief example of how you might access the Vite config from a project; you could implement a similar approach to get the webpack configuration.

```js
import { buildNuxt, loadNuxt } from '@nuxt/kit'

// https://github.com/nuxt/nuxt/issues/14534

async function getViteConfig () {

  const nuxt = await loadNuxt({ cwd: process.cwd(), dev: false, overrides: { ssr: false } })

  return new Promise((resolve, reject) => {

    nuxt.hook('vite:extend', (config) => {

      resolve(config)

      throw new Error('_stop_')

    })

    buildNuxt(nuxt).catch((err) => {

      if (!err.toString().includes('_stop_')) {

        reject(err)

      }

    })

  }).finally(() => nuxt.close())

}

const viteConfig = await getViteConfig()

console.log(viteConfig)
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/5.kit/15.examples.md)[Builder](https://nuxt.com/docs/4.x/api/kit/builder)

[

Nuxt Kit provides a set of utilities to help you work with the builder. These functions allow you to extend the Vite and webpack configurations.

](https://nuxt.com/docs/4.x/api/kit/builder)[

Layers

Nuxt Kit provides utilities to help you work with layers and their directory structures.

](https://nuxt.com/docs/4.x/api/kit/layers)****