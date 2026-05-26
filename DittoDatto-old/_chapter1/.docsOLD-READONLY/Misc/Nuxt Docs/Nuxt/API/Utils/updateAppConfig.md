---
title: "updateAppConfig · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/update-app-config"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## updateAppConfig

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/config.ts)

Update the App Config at runtime.

Updates the [`app.config`](https://nuxt.com/docs/4.x/directory-structure/app/app-config) using deep assignment. Existing (nested) properties will be preserved.

## Usage

```js
import { updateAppConfig, useAppConfig } from '#imports'

const appConfig = useAppConfig() // { foo: 'bar' }

const newAppConfig = { foo: 'baz' }

updateAppConfig(newAppConfig)

console.log(appConfig) // { foo: 'baz' }
```

Read more in Docs > 4 X > Directory Structure > App > App Config.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/3.utils/update-app-config.md)[showError](https://nuxt.com/docs/4.x/api/utils/show-error)

[

Nuxt provides a quick and simple way to show a full screen error page if needed.

](https://nuxt.com/docs/4.x/api/utils/show-error)[

nuxt add

Scaffold an entity into your Nuxt application.

](https://nuxt.com/docs/4.x/api/commands/add)