---
title: "prerenderRoutes · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/prerender-routes"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## prerenderRoutes

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/composables/ssr.ts)

prerenderRoutes hints to Nitro to prerender an additional route.

When prerendering, you can hint to Nitro to prerender additional paths, even if their URLs do not show up in the HTML of the generated page.

`prerenderRoutes` can only be called within the [Nuxt context](https://nuxt.com/docs/4.x/guide/going-further/nuxt-app#the-nuxt-context).

`prerenderRoutes` has to be executed during prerendering. If the `prerenderRoutes` is used in dynamic pages/routes which are not prerendered, then it will not be executed.

```ts
const route = useRoute()

prerenderRoutes('/')

prerenderRoutes(['/', '/about'])
```

In the browser, or if called outside prerendering, `prerenderRoutes` will have no effect.

You can even prerender API routes which is particularly useful for full statically generated sites (SSG) because you can then `$fetch` data as if you have an available server!

```ts
prerenderRoutes('/api/content/article/name-of-article')

// Somewhere later in App

const articleContent = await $fetch('/api/content/article/name-of-article', {

  responseType: 'json',

})
```

Prerendered API routes in production may not return the expected response headers, depending on the provider you deploy to. For example, a JSON response might be served with an `application/octet-stream` content type. Always manually set `responseType` when fetching prerendered API routes.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/3.utils/prerender-routes.md)