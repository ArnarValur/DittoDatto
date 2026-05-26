---
title: "nuxt.config.ts · Nuxt Directory Structure v4"
source: "https://nuxt.com/docs/4.x/directory-structure/nuxt-config"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## nuxt.config.ts

Nuxt can be easily configured with a single nuxt.config file.

The `nuxt.config` file extension can either be `.js`, `.ts` or `.mjs`.

nuxt.config.ts

```ts
export default defineNuxtConfig({

  // My Nuxt config

})
```

`defineNuxtConfig` helper is globally available without import.

You can explicitly import `defineNuxtConfig` from `nuxt/config` if you prefer:

nuxt.config.ts

```ts
import { defineNuxtConfig } from 'nuxt/config'

export default defineNuxtConfig({

  // My Nuxt config

})
```

Discover all the available options in the **Nuxt configuration** documentation.

To ensure your configuration is up to date, Nuxt will make a full restart when detecting changes in the main configuration file, the [`.env`](https://nuxt.com/docs/4.x/directory-structure/env), [`.nuxtignore`](https://nuxt.com/docs/4.x/directory-structure/nuxtignore) and [`.nuxtrc`](https://nuxt.com/docs/4.x/directory-structure/nuxtrc) dotfiles.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/2.directory-structure/3.nuxt-config.md)[.nuxtrc](https://nuxt.com/docs/4.x/directory-structure/nuxtrc)

[

The.nuxtrc file allows you to define nuxt configurations in a flat syntax.

](https://nuxt.com/docs/4.x/directory-structure/nuxtrc)[

package.json

The package.json file contains all the dependencies and scripts for your application.

](https://nuxt.com/docs/4.x/directory-structure/package)