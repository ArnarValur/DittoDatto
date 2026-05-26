---
title: "useSeoMeta · Nuxt Composables v4"
source: "https://nuxt.com/docs/4.x/api/composables/use-seo-meta"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## useSeoMeta

[Source](https://github.com/unjs/unhead/blob/main/packages/vue/src/composables.ts)

The useSeoMeta composable lets you define your site's SEO meta tags as a flat object with full TypeScript support.

This helps you avoid common mistakes, such as using `name` instead of `property`, as well as typos - with over 100+ meta tags fully typed.

This is the recommended way to add meta tags to your site as it is XSS safe and has full TypeScript support.

Read more in Docs > 4 X > Getting Started > Seo Meta.

## Usage

app/app.vue

```
<script setup lang="ts">

useSeoMeta({

  title: 'My Amazing Site',

  ogTitle: 'My Amazing Site',

  description: 'This is my amazing site, let me tell you all about it.',

  ogDescription: 'This is my amazing site, let me tell you all about it.',

  ogImage: 'https://example.com/image.png',

  twitterCard: 'summary_large_image',

})

</script>
```

When inserting tags that are reactive, you should use the computed getter syntax (`() => value`):

app/app.vue

```
<script setup lang="ts">

const title = ref('My title')

useSeoMeta({

  title,

  description: () => \`This is a description for the ${title.value} page\`,

})

</script>
```

## Parameters

There are over 100 parameters. See the [full list of parameters in the source code](https://github.com/harlan-zw/zhead/blob/main/packages/zhead/src/metaFlat.ts#L1035).

Read more in Docs > 4 X > Getting Started > Seo Meta.

## Performance

In most instances, SEO meta tags don't need to be reactive as search engine robots primarily scan the initial page load.

For better performance, you can wrap your `useSeoMeta` calls in a server-only condition when the meta tags don't need to be reactive:

app/app.vue

```
<script setup lang="ts">

if (import.meta.server) {

  // These meta tags will only be added during server-side rendering

  useSeoMeta({

    robots: 'index, follow',

    description: 'Static description that does not need reactivity',

    ogImage: 'https://example.com/image.png',

    // other static meta tags...

  })

}

const dynamicTitle = ref('My title')

// Only use reactive meta tags outside the condition when necessary

useSeoMeta({

  title: () => dynamicTitle.value,

  ogTitle: () => dynamicTitle.value,

})

</script>
```

This previously used the [`useServerSeoMeta`](https://nuxt.com/docs/4.x/api/composables/use-server-seo-meta) composable, but it has been deprecated in favor of this approach.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/2.composables/use-seo-meta.md)[useRuntimeHook](https://nuxt.com/docs/4.x/api/composables/use-runtime-hook)

[

Registers a runtime hook in a Nuxt application and ensures it is properly disposed of when the scope is destroyed.

](https://nuxt.com/docs/4.x/api/composables/use-runtime-hook)[

useServerSeoMeta

The useServerSeoMeta composable lets you define your site's SEO meta tags as a flat object with full TypeScript support.

](https://nuxt.com/docs/4.x/api/composables/use-server-seo-meta)