---
title: "utils · Nuxt Directory Structure v4"
source: "https://nuxt.com/docs/4.x/directory-structure/app/utils"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## utils

Use the utils/ directory to auto-import your utility functions throughout your application.

The main purpose of the [`app/utils/` directory](https://nuxt.com/docs/4.x/directory-structure/app/utils) is to allow a semantic distinction between your Vue composables and other auto-imported utility functions.

## Usage

**Method 1:** Using named export

utils/index.ts

```ts
export const { format: formatNumber } = Intl.NumberFormat('en-GB', {

  notation: 'compact',

  maximumFractionDigits: 1,

})
```

**Method 2:** Using default export

utils/random-entry.ts or utils/randomEntry.ts

```ts
// It will be available as randomEntry() (camelCase of file name without extension)

export default function (arr: Array<any>) {

  return arr[Math.floor(Math.random() * arr.length)]

}
```

You can now use auto imported utility functions in `.js`, `.ts` and `.vue` files

app/app.vue

```
<template>

  <p>{{ formatNumber(1234) }}</p>

</template>
```

Read more in Docs > 4 X > Guide > Concepts > Auto Imports.

Read and edit a live example in [Docs > 4 X > Examples > Features > Auto Imports](https://nuxt.com/docs/4.x/examples/features/auto-imports).

The way `app/utils/` auto-imports work and are scanned is identical to the [`app/composables/`](https://nuxt.com/docs/4.x/directory-structure/app/composables) directory.

These utils are only available within the Vue part of your app.  
Only `server/utils` are auto-imported in the [`server/`](https://nuxt.com/docs/4.x/directory-structure/server#server-utilities) directory.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/2.directory-structure/1.app/1.utils.md)[plugins](https://nuxt.com/docs/4.x/directory-structure/app/plugins)

[

Nuxt has a plugins system to use Vue plugins and more at the creation of your Vue application.

](https://nuxt.com/docs/4.x/directory-structure/app/plugins)[

app.vue

The app.vue file is the main component of your Nuxt application.

](https://nuxt.com/docs/4.x/directory-structure/app/app)