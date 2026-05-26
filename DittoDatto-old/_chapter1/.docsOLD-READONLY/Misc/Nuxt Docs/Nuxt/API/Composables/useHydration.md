---
title: "useHydration · Nuxt Composables v4"
source: "https://nuxt.com/docs/4.x/api/composables/use-hydration"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## useHydration

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/composables/hydrate.ts)

Allows full control of the hydration cycle to set and receive data from the server.

`useHydration` is a built-in composable that provides a way to set data on the server side every time a new HTTP request is made and receive that data on the client side. This way `useHydration` allows you to take full control of the hydration cycle.

This is an advanced composable, primarily designed for use within plugins, mostly used by Nuxt modules.

`useHydration` is designed to **ensure state synchronization and restoration during SSR**. If you need to create a globally reactive state that is SSR-friendly in Nuxt, [`useState`](https://nuxt.com/docs/4.x/api/composables/use-state) is the recommended choice.

## Usage

The data returned from the `get` function on the server is stored in `nuxtApp.payload` under the unique key provided as the first parameter to `useHydration`. During hydration, this data is then retrieved on the client, preventing redundant computations or API calls.

## Type

Signature

```ts
export function useHydration<T> (key: string, get: () => T, set: (value: T) => void): void
```

## Parameters

| Parameter | Type | Description |
| --- | --- | --- |
| `key` | `string` | A unique key that identifies the data in your Nuxt application. |
| `get` | `() => T` | A function executed **only on the server** (called when SSR rendering is done) to set the initial value. |
| `set` | `(value: T) => void` | A function executed **only on the client** (called when initial Vue instance is created) to receive the data. |

## Return Values

This composable does not return any value.