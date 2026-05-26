---
title: "<DevOnly> · Nuxt Components v4"
source: "https://nuxt.com/docs/4.x/api/components/dev-only"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## <DevOnly>

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/components/dev-only.ts)

Render components only during development with the <DevOnly> component.

Nuxt provides the `<DevOnly>` component to render a component only during development.

The content will not be included in production builds.

app/pages/example.vue

```
<template>

  <div>

    <Sidebar />

    <DevOnly>

      <!-- this component will only be rendered during development -->

      <LazyDebugBar />

      <!-- if you ever require to have a replacement during production -->

      <!-- be sure to test these using \`nuxt preview\` -->

      <template #fallback>

        <div><!-- empty div for flex.justify-between --></div>

      </template>

    </DevOnly>

  </div>

</template>
```

## Slots

- `#fallback`: if you ever require to have a replacement during production.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/1.components/1.dev-only.md)[<ClientOnly>](https://nuxt.com/docs/4.x/api/components/client-only)

[

Render components only in client-side with the <ClientOnly> component.

](https://nuxt.com/docs/4.x/api/components/client-only)[

<NuxtClientFallback>

Nuxt provides the <NuxtClientFallback> component to render its content on the client if any of its children trigger an error in SSR

](https://nuxt.com/docs/4.x/api/components/nuxt-client-fallback)