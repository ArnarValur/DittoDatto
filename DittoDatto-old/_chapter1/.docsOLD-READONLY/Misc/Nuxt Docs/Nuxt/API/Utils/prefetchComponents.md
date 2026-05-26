---
title: "prefetchComponents · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/prefetch-components"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## prefetchComponents

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/composables/preload.ts)

Nuxt provides utilities to give you control over prefetching components.

Prefetching component downloads the code in the background, this is based on the assumption that the component will likely be used for rendering, enabling the component to load instantly if and when the user requests it. The component is downloaded and cached for anticipated future use without the user making an explicit request for it.

Use `prefetchComponents` to manually prefetch individual components that have been registered globally in your Nuxt app. By default Nuxt registers these as async components. You must use the Pascal-cased version of the component name.

```ts
await prefetchComponents('MyGlobalComponent')

await prefetchComponents(['MyGlobalComponent1', 'MyGlobalComponent2'])
```

Current implementation behaves exactly the same as [`preloadComponents`](https://nuxt.com/docs/4.x/api/utils/preload-components) by preloading components instead of just prefetching we are working to improve this behavior.

On server, `prefetchComponents` will have no effect.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/3.utils/prefetch-components.md)[onNuxtReady](https://nuxt.com/docs/4.x/api/utils/on-nuxt-ready)

[

The onNuxtReady composable allows running a callback after your app has finished initializing.

](https://nuxt.com/docs/4.x/api/utils/on-nuxt-ready)[

preloadComponents

Nuxt provides utilities to give you control over preloading components.

](https://nuxt.com/docs/4.x/api/utils/preload-components)