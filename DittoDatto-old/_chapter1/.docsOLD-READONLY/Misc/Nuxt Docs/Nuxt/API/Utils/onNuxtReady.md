---
title: "onNuxtReady · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/on-nuxt-ready"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
`onNuxtReady` only runs on the client-side.  
It is ideal for running code that should not block the initial rendering of your app.

app/plugins/ready.client.ts

```ts
export default defineNuxtPlugin(() => {

  onNuxtReady(async () => {

    const myAnalyticsLibrary = await import('my-big-analytics-library')

    // do something with myAnalyticsLibrary

  })

})
```

It is 'safe' to run even after your app has initialized. In this case, then the code will be registered to run in the next idle callback.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/3.utils/on-nuxt-ready.md)