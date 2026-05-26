---
title: "useRequestEvent · Nuxt Composables v4"
source: "https://nuxt.com/docs/4.x/api/composables/use-request-event"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## useRequestEvent

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/composables/ssr.ts)

Access the incoming request event with the useRequestEvent composable.

Within the [Nuxt context](https://nuxt.com/docs/4.x/guide/going-further/nuxt-app#the-nuxt-context) you can use `useRequestEvent` to access the incoming request.

```ts
// Get underlying request event

const event = useRequestEvent()

// Get the URL

const url = event?.path
```

In the browser, `useRequestEvent` will return `undefined`.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/2.composables/use-request-event.md)