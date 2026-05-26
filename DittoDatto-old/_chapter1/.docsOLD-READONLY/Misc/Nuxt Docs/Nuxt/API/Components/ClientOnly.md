---
title: "<ClientOnly> · Nuxt Components v4"
source: "https://nuxt.com/docs/4.x/api/components/client-only"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## <ClientOnly>

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/components/client-only.ts)

Render components only in client-side with the <ClientOnly> component.

The `<ClientOnly>` component is used for purposely rendering a component only on client side.

The content of the default slot will be tree-shaken out of the server build. (This does mean that any CSS used by components within it may not be inlined when rendering the initial HTML.)

## Props

- `placeholderTag` | `fallbackTag`: specify a tag to be rendered server-side.
- `placeholder` | `fallback`: specify a content to be rendered server-side.

## Slots

- `#fallback`: specify a content to be rendered on the server and displayed until `<ClientOnly>` is mounted in the browser.

app/pages/example.vue

```
<template>

  <div>

    <Sidebar />

    <!-- This renders the "span" element on the server side -->

    <ClientOnly fallback-tag="span">

      <!-- this component will only be rendered on client side -->

      <Comments />

      <template #fallback>

        <!-- this will be rendered on server side -->

        <p>Loading comments...</p>

      </template>

    </ClientOnly>

  </div>

</template>
```

## Examples

### Accessing HTML Elements

Components inside `<ClientOnly>` are rendered only after being mounted. To access the rendered elements in the DOM, you can watch a template ref:

app/pages/example.vue

```
<script setup lang="ts">

const nuxtWelcomeRef = useTemplateRef('nuxtWelcomeRef')

// The watch will be triggered when the component is available

watch(nuxtWelcomeRef, () => {

  console.log('<NuxtWelcome /> mounted')

}, { once: true })

</script>

<template>

  <ClientOnly>

    <NuxtWelcome ref="nuxtWelcomeRef" />

  </ClientOnly>

</template>
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/1.components/1.client-only.md)[Debugging](https://nuxt.com/docs/4.x/guide/going-further/debugging)

[

In Nuxt, you can get started with debugging your application directly in the browser as well as in your IDE.

](https://nuxt.com/docs/4.x/guide/going-further/debugging)[

<DevOnly>

Render components only during development with the <DevOnly> component.

](https://nuxt.com/docs/4.x/api/components/dev-only)