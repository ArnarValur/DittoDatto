---
title: "preloadComponents · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/preload-components"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## preloadComponents

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/composables/preload.ts)

Nuxt provides utilities to give you control over preloading components.

Preloading components loads components that your page will need very soon, which you want to start loading early in rendering lifecycle. This ensures they are available earlier and are less likely to block the page's render, improving performance.

Use `preloadComponents` to manually preload individual components that have been registered globally in your Nuxt app. By default Nuxt registers these as async components. You must use the Pascal-cased version of the component name.

```ts
await preloadComponents('MyGlobalComponent')

await preloadComponents(['MyGlobalComponent1', 'MyGlobalComponent2'])
```

On server, `preloadComponents` will have no effect.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/3.utils/preload-components.md)[prefetchComponents](https://nuxt.com/docs/4.x/api/utils/prefetch-components)

[

Nuxt provides utilities to give you control over prefetching components.

](https://nuxt.com/docs/4.x/api/utils/prefetch-components)[

preloadRouteComponents

preloadRouteComponents allows you to manually preload individual pages in your Nuxt app.

](https://nuxt.com/docs/4.x/api/utils/preload-route-components)****