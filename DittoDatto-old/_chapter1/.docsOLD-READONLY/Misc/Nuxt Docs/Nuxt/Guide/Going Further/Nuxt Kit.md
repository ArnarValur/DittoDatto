---
title: "Nuxt Kit · Nuxt Advanced v4"
source: "https://nuxt.com/docs/4.x/guide/going-further/kit"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## Nuxt Kit

@nuxt/kit provides features for module authors.

Nuxt Kit provides composable utilities to make interacting with [Nuxt Hooks](https://nuxt.com/docs/4.x/api/advanced/hooks), the [Nuxt Interface](https://nuxt.com/docs/4.x/guide/going-further/internals#the-nuxt-interface) and developing [Nuxt modules](https://nuxt.com/docs/4.x/guide/modules) super easy.

Discover all Nuxt Kit utilities.

## Usage

### Install Dependency

You can install the latest Nuxt Kit by adding it to the `dependencies` section of your `package.json`. However, please consider always explicitly installing the `@nuxt/kit` package even if it is already installed by Nuxt.

`@nuxt/kit` and `@nuxt/schema` are key dependencies for Nuxt. If you are installing it separately, make sure that the versions of `@nuxt/kit` and `@nuxt/schema` are equal to or greater than your `nuxt` version to avoid any unexpected behavior.

package.json

```json
{

  "dependencies": {

    "@nuxt/kit": "npm:@nuxt/kit-nightly@latest"

  }

}
```

### Import Kit Utilities

test.mjs

```ts
import { useNuxt } from '@nuxt/kit'
```

Read more in Docs > 4 X > API > Kit.

Nuxt Kit utilities are only available for modules and not meant to be imported in runtime (components, Vue composables, pages, plugins, or server routes).

Nuxt Kit is an [esm-only package](https://nuxt.com/docs/4.x/guide/concepts/esm) meaning that you **cannot** `require('@nuxt/kit')`. As a workaround, use dynamic import in the CommonJS context:

test.cjs

```ts
// This does NOT work!

// const kit = require('@nuxt/kit')

async function main () {

  const kit = await import('@nuxt/kit')

}

main()
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/3.guide/6.going-further/4.kit.md)[Lifecycle Hooks](https://nuxt.com/docs/4.x/guide/going-further/hooks)

[

Nuxt provides a powerful hooking system to expand almost every aspect using hooks.

](https://nuxt.com/docs/4.x/guide/going-further/hooks)[

NuxtApp

In Nuxt, you can access runtime app context within composables, components and plugins.

](https://nuxt.com/docs/4.x/guide/going-further/nuxt-app)