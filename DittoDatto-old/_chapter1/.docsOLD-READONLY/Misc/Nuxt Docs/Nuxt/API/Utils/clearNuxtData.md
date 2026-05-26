---
title: "clearNuxtData · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/clear-nuxt-data"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## clearNuxtData

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/composables/asyncData.ts)

Delete cached data, error status and pending promises of useAsyncData and useFetch.

This method is useful if you want to invalidate the data fetching for another page.

## Type

Signature

```ts
export function clearNuxtData (keys?: string | string[] | ((key: string) => boolean)): void
```

## Parameters

- `keys`: One or an array of keys that are used in [`useAsyncData`](https://nuxt.com/docs/4.x/api/composables/use-async-data) to delete their cached data. If no keys are provided, **all data** will be invalidated.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/3.utils/clear-nuxt-data.md)[clearError](https://nuxt.com/docs/4.x/api/utils/clear-error)

[

The clearError composable clears all handled errors.

](https://nuxt.com/docs/4.x/api/utils/clear-error)[

clearNuxtState

Delete the cached state of useState.

](https://nuxt.com/docs/4.x/api/utils/clear-nuxt-state)