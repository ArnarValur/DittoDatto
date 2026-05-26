---
title: "Lifecycle Hooks · Nuxt Advanced v4"
source: "https://nuxt.com/docs/4.x/guide/going-further/hooks"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## Lifecycle Hooks

Nuxt provides a powerful hooking system to expand almost every aspect using hooks.

The hooking system is powered by [unjs/hookable](https://github.com/unjs/hookable).

## Nuxt Hooks (Build Time)

These hooks are available for [Nuxt modules](https://nuxt.com/docs/4.x/guide/modules) and build context.

### Within nuxt.config.ts

nuxt.config.ts

```ts
export default defineNuxtConfig({

  hooks: {

    close: () => { },

  },

})
```

### Within Nuxt Modules

```js
import { defineNuxtModule } from '@nuxt/kit'

export default defineNuxtModule({

  setup (options, nuxt) {

    nuxt.hook('close', async () => { })

  },

})
```

Explore all available Nuxt hooks.

## App Hooks (Runtime)

App hooks can be mainly used by [Nuxt Plugins](https://nuxt.com/docs/4.x/directory-structure/app/plugins) to hook into rendering lifecycle but could also be used in Vue composables.

app/plugins/test.ts

```ts
export default defineNuxtPlugin((nuxtApp) => {

  nuxtApp.hook('page:start', () => {

    /* your code goes here */

  })

})
```

Explore all available App hooks.

## Server Hooks (Runtime)

These hooks are available for [server plugins](https://nuxt.com/docs/4.x/directory-structure/server#server-plugins) to hook into Nitro's runtime behavior.

~~/server/plugins/test.ts

```ts
export default defineNitroPlugin((nitroApp) => {

  nitroApp.hooks.hook('render:html', (html, { event }) => {

    console.log('render:html', html)

    html.bodyAppend.push('<hr>Appended by custom plugin')

  })

  nitroApp.hooks.hook('render:response', (response, { event }) => {

    console.log('render:response', response)

  })

})
```

Learn more about available Nitro lifecycle hooks.

## Adding Custom Hooks

You can define your own custom hooks support by extending Nuxt's hook interfaces.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/3.guide/6.going-further/2.hooks.md)[Nightly Release Channel](https://nuxt.com/docs/4.x/guide/going-further/nightly-release-channel)

[

The nightly release channel allows using Nuxt built directly from the latest commits to the repository.

](https://nuxt.com/docs/4.x/guide/going-further/nightly-release-channel)[

Nuxt Kit

@nuxt/kit provides features for module authors.

](https://nuxt.com/docs/4.x/guide/going-further/kit)