---
title: "useServerSeoMeta · Nuxt Composables v4"
source: "https://nuxt.com/docs/4.x/api/composables/use-server-seo-meta"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## useServerSeoMeta

[Source](https://github.com/unjs/unhead/blob/main/packages/vue/src/composables.ts)

The useServerSeoMeta composable lets you define your site's SEO meta tags as a flat object with full TypeScript support.

Just like [`useSeoMeta`](https://nuxt.com/docs/4.x/api/composables/use-seo-meta), `useServerSeoMeta` composable lets you define your site's SEO meta tags as a flat object with full TypeScript support.

Read more in Docs > 4 X > API > Composables > Use Seo Meta.

In most instances, the meta doesn't need to be reactive as robots will only scan the initial load. So we recommend using [`useServerSeoMeta`](https://nuxt.com/docs/4.x/api/composables/use-server-seo-meta) as a performance-focused utility that will not do anything (or return a `head` object) on the client.

app/app.vue

```
<script setup lang="ts">

useServerSeoMeta({

  robots: 'index, follow',

})

</script>
```

Parameters are exactly the same as with [`useSeoMeta`](https://nuxt.com/docs/4.x/api/composables/use-seo-meta)

Read more in Docs > 4 X > Getting Started > Seo Meta.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/2.composables/use-server-seo-meta.md)