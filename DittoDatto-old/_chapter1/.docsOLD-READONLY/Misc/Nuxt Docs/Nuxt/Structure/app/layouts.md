---
title: "layouts · Nuxt Directory Structure v4"
source: "https://nuxt.com/docs/4.x/directory-structure/app/layouts"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## layouts

Nuxt provides a layouts framework to extract common UI patterns into reusable layouts.

For best performance, components placed in this directory will be automatically loaded via asynchronous import when used.

## Enable Layouts

Layouts are enabled by adding [`<NuxtLayout>`](https://nuxt.com/docs/4.x/api/components/nuxt-layout) to your [`app.vue`](https://nuxt.com/docs/4.x/directory-structure/app/app):

app/app.vue

```
<template>

  <NuxtLayout>

    <NuxtPage />

  </NuxtLayout>

</template>
```

To use a layout:

- Set a `layout` property in your page with [definePageMeta](https://nuxt.com/docs/4.x/api/utils/define-page-meta).
- Set the `name` prop of `<NuxtLayout>`.
- Set the `appLayout` property in route rules.

The layout name is normalized to kebab-case, so `someLayout` becomes `some-layout`.

If no layout is specified, `app/layouts/default.vue` will be used.

If you only have a single layout in your application, we recommend using [`app.vue`](https://nuxt.com/docs/4.x/directory-structure/app/app) instead.

Unlike other components, your layouts must have a single root element to allow Nuxt to apply transitions between layout changes - and this root element cannot be a `<slot />`.

## Default Layout

Add a `~/layouts/default.vue`:

app/layouts/default.vue

```
<template>

  <div>

    <p>Some default layout content shared across all pages</p>

    <slot />

  </div>

</template>
```

In a layout file, the content of the page will be displayed in the `<slot />` component.

## Named Layout

Directory Structure

```bash
-| layouts/

---| default.vue

---| custom.vue
```

Then you can use the `custom` layout in your page:

pages/about.vue

```
definePageMeta({

  layout: 'custom',

})

</script>
```

Learn more about `definePageMeta`.

You can directly override the default layout for all pages using the `name` property of [`<NuxtLayout>`](https://nuxt.com/docs/4.x/api/components/nuxt-layout):

app/app.vue

```
<script setup lang="ts">

// You might choose this based on an API call or logged-in status

const layout = 'custom'

</script>

<template>

  <NuxtLayout :name="layout">

    <NuxtPage />

  </NuxtLayout>

</template>
```

If you have a layout in nested directories, the layout's name will be based on its own path directory and filename, with duplicate segments being removed.

| File | Layout Name |
| --- | --- |
| `~/layouts/desktop/default.vue` | `desktop-default` |
| `~/layouts/desktop-base/base.vue` | `desktop-base` |
| `~/layouts/desktop/index.vue` | `desktop` |

For clarity, we recommend that the layout's filename matches its name:

| File | Layout Name |
| --- | --- |
| `~/layouts/desktop/DesktopDefault.vue` | `desktop-default` |
| `~/layouts/desktop-base/DesktopBase.vue` | `desktop-base` |
| `~/layouts/desktop/Desktop.vue` | `desktop` |

Read and edit a live example in [Docs > 4 X > Examples > Features > Layouts](https://nuxt.com/docs/4.x/examples/features/layouts).

## Changing the Layout Dynamically

You can also use the [`setPageLayout`](https://nuxt.com/docs/4.x/api/utils/set-page-layout) helper to change the layout dynamically:

```
function enableCustomLayout () {

  setPageLayout('custom')

}

definePageMeta({

  layout: false,

})

</script>

<template>

  <div>

    <button @click="enableCustomLayout">

      Update layout

    </button>

  </div>

</template>
```

You can also set layouts for specific routes using the `appLayout` property in route rules:

nuxt.config.ts

```ts
export default defineNuxtConfig({

  routeRules: {

    // Set layout for specific route

    '/admin': { appLayout: 'admin' },

    // Set layout for multiple routes

    '/dashboard/**': { appLayout: 'dashboard' },

    // Disable layout for a route

    '/landing': { appLayout: false },

  },

})
```

This is useful when you want to manage layouts centrally in your configuration rather than in each page file, or when you need to apply layouts to routes that don't have corresponding page components (such as catchall pages which might match many paths).

Read and edit a live example in [Docs > 4 X > Examples > Features > Layouts](https://nuxt.com/docs/4.x/examples/features/layouts).

## Overriding a Layout on a Per-page Basis

If you are using pages, you can take full control by setting `layout: false` and then using the `<NuxtLayout>` component within the page.

If you use `<NuxtLayout>` within your pages, make sure it is not the root element (or [disable layout/page transitions](https://nuxt.com/docs/4.x/getting-started/transitions#disable-transitions)).

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/2.directory-structure/1.app/1.layouts.md)