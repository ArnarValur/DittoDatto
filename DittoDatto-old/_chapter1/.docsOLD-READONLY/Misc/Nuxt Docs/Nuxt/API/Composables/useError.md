---
title: "useError · Nuxt Composables v4"
source: "https://nuxt.com/docs/4.x/api/composables/use-error"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## useError

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/composables/error.ts)

useError composable returns the global Nuxt error that is being handled.

## Usage

The `useError` composable returns the global Nuxt error that is being handled and is available on both client and server. It provides a reactive, SSR-friendly error state across your app.

```ts
const error = useError()
```

You can use this composable in your components, pages, or plugins to access or react to the current Nuxt error.

## Type

```ts
interface NuxtError<DataT = unknown> {

  status: number

  statusText: string

  message: string

  data?: DataT

  error?: true

}

export const useError: () => Ref<NuxtError | undefined>
```

## Parameters

This composable does not take any parameters.

## Return Values

Returns a `Ref` containing the current Nuxt error (or `undefined` if there is no error). The error object is reactive and will update automatically when the error state changes.

## Example

```
<script setup lang="ts">

const error = useError()

if (error.value) {

  console.error('Nuxt error:', error.value)

}

</script>
```

Read more in Docs > 4 X > Getting Started > Error Handling.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/2.composables/use-error.md)