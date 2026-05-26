---
title: "clearNuxtState · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/clear-nuxt-state"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## clearNuxtState

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/composables/state.ts)

Delete the cached state of useState.

This method is useful if you want to invalidate the state of `useState`.

## Type

Signature

```ts
export function clearNuxtState (keys?: string | string[] | ((key: string) => boolean)): void
```

## Parameters

- `keys`: One or an array of keys that are used in [`useState`](https://nuxt.com/docs/4.x/api/composables/use-state) to delete their cached state. If no keys are provided, **all state** will be invalidated.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/3.utils/clear-nuxt-state.md)[clearNuxtData](https://nuxt.com/docs/4.x/api/utils/clear-nuxt-data)

[

Delete cached data, error status and pending promises of useAsyncData and useFetch.

](https://nuxt.com/docs/4.x/api/utils/clear-nuxt-data)[

createError

Create an error object with additional metadata.

](https://nuxt.com/docs/4.x/api/utils/create-error)