---
title: "useLazyAsyncData · Nuxt Composables v4"
source: "https://nuxt.com/docs/4.x/api/composables/use-lazy-async-data"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
`useLazyAsyncData` provides a wrapper around [`useAsyncData`](https://nuxt.com/docs/4.x/api/composables/use-async-data) that triggers navigation before the handler is resolved by setting the `lazy` option to `true`.

By default, [`useAsyncData`](https://nuxt.com/docs/4.x/api/composables/use-async-data) blocks navigation until its async handler is resolved. `useLazyAsyncData` allows navigation to occur immediately while data fetching continues in the background.

## Usage

app/pages/index.vue

```
<script setup lang="ts">

const { status, data: posts } = await useLazyAsyncData('posts', () => $fetch('/api/posts'))

</script>

<template>

  <div>

    <div v-if="status === 'pending'">

      Loading...

    </div>

    <div v-else-if="status === 'error'">

      Error loading posts

    </div>

    <div v-else>

      {{ posts }}

    </div>

  </div>

</template>
```

When using `useLazyAsyncData`, navigation will occur before fetching is complete. This means you must handle `pending` and `error` states directly within your component's template.

`useLazyAsyncData` is a reserved function name transformed by the compiler, so you should not name your own function `useLazyAsyncData`.

## Type

Signature

```ts
export function useLazyAsyncData<DataT, ErrorT> (

  handler: (ctx?: NuxtApp) => Promise<DataT>,

  options?: AsyncDataOptions<DataT>,

): AsyncData<DataT, ErrorT>

export function useLazyAsyncData<DataT, ErrorT> (

  key: string,

  handler: (ctx?: NuxtApp) => Promise<DataT>,

  options?: AsyncDataOptions<DataT>,

): AsyncData<DataT, ErrorT>
```

`useLazyAsyncData` has the same signature as [`useAsyncData`](https://nuxt.com/docs/4.x/api/composables/use-async-data).

## Parameters

`useLazyAsyncData` accepts the same parameters as [`useAsyncData`](https://nuxt.com/docs/4.x/api/composables/use-async-data), with the `lazy` option automatically set to `true`.

Read more in Docs > 4 X > API > Composables > Use Async Data#parameters.

## Return Values

`useLazyAsyncData` returns the same values as [`useAsyncData`](https://nuxt.com/docs/4.x/api/composables/use-async-data).

Read more in Docs > 4 X > API > Composables > Use Async Data#return Values.

## Example

app/pages/index.vue

```
<script setup lang="ts">

/* Navigation will occur before fetching is complete.

  Handle 'pending' and 'error' states directly within your component's template

*/

const { status, data: count } = await useLazyAsyncData('count', () => $fetch('/api/count'))

watch(count, (newCount) => {

  // Because count might start out null, you won't have access

  // to its contents immediately, but you can watch it.

})

</script>

<template>

  <div>

    {{ status === 'pending' ? 'Loading' : count }}

  </div>

</template>
```

Read more in Docs > 4 X > Getting Started > Data Fetching.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/2.composables/use-lazy-async-data.md)