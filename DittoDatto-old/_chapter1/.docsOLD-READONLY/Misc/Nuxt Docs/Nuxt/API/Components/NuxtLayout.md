---
title: "<NuxtLayout> · Nuxt Components v4"
source: "https://nuxt.com/docs/4.x/api/components/nuxt-layout"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## <NuxtLayout>

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/components/nuxt-layout.ts)

Nuxt provides the <NuxtLayout> component to show layouts on pages and error pages.

You can use `<NuxtLayout />` component to activate the `default` layout on `app.vue` or `error.vue`.

app/app.vue

```
<template>

  <NuxtLayout>

    some page content

  </NuxtLayout>

</template>
```

Read more in Docs > 4 X > Directory Structure > App > Layouts.

## Props

- `name`: Specify a layout name to be rendered, can be a string, reactive reference or a computed property. It **must** match the name of the corresponding layout file in the [`app/layouts/`](https://nuxt.com/docs/4.x/directory-structure/app/layouts) directory, or `false` to disable the layout.
	- **type**: `string | false`
	- **default**: `default`

app/pages/index.vue

```
<script setup lang="ts">

// layouts/custom.vue

const layout = 'custom'

</script>

<template>

  <NuxtLayout :name="layout">

    <NuxtPage />

  </NuxtLayout>

</template>
```

Please note the layout name is normalized to kebab-case, so if your layout file is named `errorLayout.vue`, it will become `error-layout` when passed as a `name` property to `<NuxtLayout />`.

error.vue

```
<template>

  <NuxtLayout name="error-layout">

    <NuxtPage />

  </NuxtLayout>

</template>
```

Read more about dynamic layouts.

- `fallback`: If an invalid layout is passed to the `name` prop, no layout will be rendered. Specify a `fallback` layout to be rendered in this scenario. It **must** match the name of the corresponding layout file in the [`app/layouts/`](https://nuxt.com/docs/4.x/directory-structure/app/layouts) directory.
	- **type**: `string`
	- **default**: `null`

## Additional Props

`NuxtLayout` also accepts any additional props that you may need to pass to the layout. These custom props are then made accessible as attributes.

app/pages/some-page.vue

```
<template>

  <div>

    <NuxtLayout

      name="custom"

      title="I am a custom layout"

    >

      <!-- ... -->

    </NuxtLayout>

  </div>

</template>
```

In the above example, the value of `title` will be available using `$attrs.title` in the template or `useAttrs().title` in `<script setup>` at custom.vue.

app/layouts/custom.vue

```
<script setup lang="ts">

const layoutCustomProps = useAttrs()

console.log(layoutCustomProps.title) // I am a custom layout

</script>
```

## Transitions

`<NuxtLayout />` renders incoming content via `<slot />`, which is then wrapped around Vue’s `<Transition />` component to activate layout transition. For this to work as expected, it is recommended that `<NuxtLayout />` is **not** the root element of the page component.

Read more in Docs > 4 X > Getting Started > Transitions.

## Layout's Ref

To get the ref of a layout component, access it through `ref.value.layoutRef`.

Read more in Docs > 4 X > Directory Structure > App > Layouts.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/1.components/3.nuxt-layout.md)[<NuxtPage>](https://nuxt.com/docs/4.x/api/components/nuxt-page)

[

The <NuxtPage> component is required to display pages located in the pages/ directory.

](https://nuxt.com/docs/4.x/api/components/nuxt-page)[

<NuxtLink>

Nuxt provides <NuxtLink> component to handle any kind of links within your application.

](https://nuxt.com/docs/4.x/api/components/nuxt-link)