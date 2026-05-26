---
title: "useRequestHeaders · Nuxt Composables v4"
source: "https://nuxt.com/docs/4.x/api/composables/use-request-headers"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
You can use built-in [`useRequestHeaders`](https://nuxt.com/docs/4.x/api/composables/use-request-headers) composable to access the incoming request headers within your pages, components, and plugins.

In the browser, `useRequestHeaders` will return an empty object.

## Example

We can use `useRequestHeaders` to access and proxy the initial request's `authorization` header to any future internal requests during SSR.

The example below adds the `authorization` request header to an isomorphic `$fetch` call.

app/pages/some-page.vue

```
<script setup lang="ts">

const { data } = await useFetch('/api/confidential', {

  headers: useRequestHeaders(['authorization']),

})

</script>
```