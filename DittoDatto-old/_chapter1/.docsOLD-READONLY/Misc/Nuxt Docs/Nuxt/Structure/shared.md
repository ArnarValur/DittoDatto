---
title: "shared · Nuxt Directory Structure v4"
source: "https://nuxt.com/docs/4.x/directory-structure/shared"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
The `shared/` directory allows you to share code that can be used in both the Vue app and the Nitro server.

The `shared/` directory is available in Nuxt v3.14+.

Code in the `shared/` directory cannot import any Vue or Nitro code.

## Usage

**Method 1:** Named export

shared/utils/capitalize.ts

```ts
export const capitalize = (input: string) => {

  return input[0] ? input[0].toUpperCase() + input.slice(1) : ''

}
```

**Method 2:** Default export

shared/utils/capitalize.ts

```ts
export default function (input: string) {

  return input[0] ? input[0].toUpperCase() + input.slice(1) : ''

}
```

You can now use [auto-imported](https://nuxt.com/docs/4.x/directory-structure/shared) utilities in your Nuxt app and `server/` directory.

app/app.vue

```
<script setup lang="ts">

const hello = capitalize('hello')

</script>

<template>

  <div>

    {{ hello }}

  </div>

</template>
```

server/api/hello.get.ts

```ts
export default defineEventHandler((event) => {

  return {

    hello: capitalize('hello'),

  }

})
```

## How Files Are Scanned

Only files in the `shared/utils/` and `shared/types/` directories will be auto-imported. Files nested within subdirectories of these directories will not be auto-imported unless you add these directories to `imports.dirs` and `nitro.imports.dirs`.

The way `shared/utils` and `shared/types` auto-imports work and are scanned is identical to the [`app/composables/`](https://nuxt.com/docs/4.x/directory-structure/app/composables) and [`app/utils/`](https://nuxt.com/docs/4.x/directory-structure/app/utils) directories.

Read more in Docs > 4 X > Directory Structure > App > Composables#how Files Are Scanned.

Directory Structure

```bash
-| shared/

---| capitalize.ts        # Not auto-imported

---| formatters

-----| lower.ts           # Not auto-imported

---| utils/

-----| lower.ts           # Auto-imported

-----| formatters

-------| upper.ts         # Not auto-imported

---| types/

-----| bar.ts             # Auto-imported
```

Any other files you create in the `shared/` folder must be manually imported using the `#shared` alias (automatically configured by Nuxt):

This alias ensures consistent imports across your application, regardless of the importing file's location.

Read more in Docs > 4 X > Guide > Concepts > Auto Imports.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/2.directory-structure/1.shared.md)