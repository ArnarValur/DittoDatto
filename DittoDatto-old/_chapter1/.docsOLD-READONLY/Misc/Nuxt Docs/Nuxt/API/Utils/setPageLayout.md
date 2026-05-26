---
title: "setPageLayout · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/set-page-layout"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## setPageLayout

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/composables/router.ts)

setPageLayout allows you to dynamically change the layout of a page.

`setPageLayout` allows you to dynamically change the layout of a page. It relies on access to the Nuxt context and therefore can only be called within the [Nuxt context](https://nuxt.com/docs/4.x/guide/going-further/nuxt-app#the-nuxt-context).

app/middleware/custom-layout.ts

```ts
export default defineNuxtRouteMiddleware((to) => {

  // Set the layout on the route you are navigating _to_

  setPageLayout('other')

})
```

## Passing Props to Layouts

You can pass props to the layout by providing an object as the second argument:

app/middleware/admin-layout.ts

```ts
export default defineNuxtRouteMiddleware((to) => {

  setPageLayout('admin', {

    sidebar: true,

    title: 'Dashboard',

  })

})
```

The layout can then receive these props:

app/layouts/admin.vue

```
<script setup lang="ts">

const props = defineProps<{

  sidebar?: boolean

  title?: string

}>()

</script>

<template>

  <div>

    <aside v-if="sidebar">

      Sidebar

    </aside>

    <main>

      <h1>{{ title }}</h1>

      <slot />

    </main>

  </div>

</template>
```

If you choose to set the layout dynamically on the server side, you *must* do so before the layout is rendered by Vue (that is, within a plugin or route middleware) to avoid a hydration mismatch.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/3.utils/set-page-layout.md)