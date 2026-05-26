---
title: "preloadRouteComponents · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/preload-route-components"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## preloadRouteComponents

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/composables/preload.ts)

preloadRouteComponents allows you to manually preload individual pages in your Nuxt app.

Preloading routes loads the components of a given route that the user might navigate to in future. This ensures that the components are available earlier and less likely to block the navigation, improving performance.

Nuxt already automatically preloads the necessary routes if you're using the `NuxtLink` component.

Read more in Docs > 4 X > API > Components > Nuxt Link.

## Example

Preload a route when using `navigateTo`.

Read more in Docs > 4 X > API > Utils > Navigate To.

On server, `preloadRouteComponents` will have no effect.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/3.utils/preload-route-components.md)[preloadComponents](https://nuxt.com/docs/4.x/api/utils/preload-components)

[

Nuxt provides utilities to give you control over preloading components.

](https://nuxt.com/docs/4.x/api/utils/preload-components)[

prerenderRoutes

prerenderRoutes hints to Nitro to prerender an additional route.

](https://nuxt.com/docs/4.x/api/utils/prerender-routes)