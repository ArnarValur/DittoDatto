---
title: "refreshNuxtData · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/refresh-nuxt-data"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## refreshNuxtData

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/composables/asyncData.ts)

Refresh all or specific asyncData instances in Nuxt

`refreshNuxtData` is used to refetch all or specific `asyncData` instances, including those from [`useAsyncData`](https://nuxt.com/docs/4.x/api/composables/use-async-data), [`useLazyAsyncData`](https://nuxt.com/docs/4.x/api/composables/use-lazy-async-data), [`useFetch`](https://nuxt.com/docs/4.x/api/composables/use-fetch), and [`useLazyFetch`](https://nuxt.com/docs/4.x/api/composables/use-lazy-fetch).

If your component is cached by `<KeepAlive>` and enters a deactivated state, the `asyncData` inside the component will still be refetched until the component is unmounted.

## Type

Signature

```ts
export function refreshNuxtData (keys?: string | string[])
```

## Parameters

- `keys`: A single string or an array of strings as `keys` that are used to fetch the data. This parameter is **optional**. All [`useAsyncData`](https://nuxt.com/docs/4.x/api/composables/use-async-data) and [`useFetch`](https://nuxt.com/docs/4.x/api/composables/use-fetch) keys are re-fetched when no `keys` are explicitly specified.

## Return Values

`refreshNuxtData` returns a promise, resolving when all or specific `asyncData` instances have been refreshed.

## Examples

### Refresh All Data

This example below refreshes all data being fetched using `useAsyncData` and `useFetch` in Nuxt application.

app/pages/some-page.vue

```
<script setup lang="ts">

const refreshing = ref(false)

async function refreshAll () {

  refreshing.value = true

  try {

    await refreshNuxtData()

  } finally {

    refreshing.value = false

  }

}

</script>

<template>

  <div>

    <button

      :disabled="refreshing"

      @click="refreshAll"

    >

      Refetch All Data

    </button>

  </div>

</template>
```

### Refresh Specific Data

This example below refreshes only data where the key matches to `count` and `user`.

app/pages/some-page.vue

```
<script setup lang="ts">

const refreshing = ref(false)

async function refresh () {

  refreshing.value = true

  try {

    // you could also pass an array of keys to refresh multiple data

    await refreshNuxtData(['count', 'user'])

  } finally {

    refreshing.value = false

  }

}

</script>

<template>

  <div v-if="refreshing">

    Loading

  </div>

  <button @click="refresh">

    Refresh

  </button>

</template>
```

If you have access to the `asyncData` instance, it is recommended to use its `refresh` or `execute` method as the preferred way to refetch the data.

Read more in Docs > 4 X > Getting Started > Data Fetching.