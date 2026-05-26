---
title: "useAppConfig · Nuxt Composables v4"
source: "https://nuxt.com/docs/4.x/api/composables/use-app-config"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## useAppConfig

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/config.ts)

Access the reactive app config defined in the project.

## Usage

```ts
const appConfig = useAppConfig()

console.log(appConfig)
```

Read more in Docs > 4 X > Directory Structure > App > App Config.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/2.composables/use-app-config.md)[onPrehydrate](https://nuxt.com/docs/4.x/api/composables/on-prehydrate)

[

Use onPrehydrate to run a callback on the client immediately before Nuxt hydrates the page.

](https://nuxt.com/docs/4.x/api/composables/on-prehydrate)[

useAsyncData

useAsyncData provides access to data that resolves asynchronously in an SSR-friendly composable.

](https://nuxt.com/docs/4.x/api/composables/use-async-data)