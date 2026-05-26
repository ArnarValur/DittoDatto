---
title: "clearError · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/clear-error"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## clearError

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/composables/error.ts)

The clearError composable clears all handled errors.

Within your pages, components, and plugins, you can use `clearError` to clear all errors and redirect the user.

**Parameters:**

- `options?: { redirect?: string }`

You can provide an optional path to redirect to (for example, if you want to navigate to a 'safe' page).

Errors are set in state using [`useError()`](https://nuxt.com/docs/4.x/api/composables/use-error). The `clearError` composable will reset this state and calls the `app:error:cleared` hook with the provided options.

Read more in Docs > 4 X > Getting Started > Error Handling.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/3.utils/clear-error.md)[callOnce](https://nuxt.com/docs/4.x/api/utils/call-once)

[

Run a given function or block of code once during SSR or CSR.

](https://nuxt.com/docs/4.x/api/utils/call-once)[

clearNuxtData

Delete cached data, error status and pending promises of useAsyncData and useFetch.

](https://nuxt.com/docs/4.x/api/utils/clear-nuxt-data)