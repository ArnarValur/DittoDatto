---
title: "package.json · Nuxt Directory Structure v4"
source: "https://nuxt.com/docs/4.x/directory-structure/package"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## package.json

The package.json file contains all the dependencies and scripts for your application.

The minimal `package.json` of your Nuxt application should looks like:

package.json

```json
{

  "name": "nuxt-app",

  "private": true,

  "type": "module",

  "scripts": {

    "build": "nuxt build",

    "dev": "nuxt dev",

    "generate": "nuxt generate",

    "preview": "nuxt preview",

    "postinstall": "nuxt prepare"

  },

  "dependencies": {

    "nuxt": "latest",

    "vue": "latest",

    "vue-router": "latest"

  }

}
```

Read more about the `package.json` file.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/2.directory-structure/3.package.md)[nuxt.config.ts](https://nuxt.com/docs/4.x/directory-structure/nuxt-config)

[

Nuxt can be easily configured with a single nuxt.config file.

](https://nuxt.com/docs/4.x/directory-structure/nuxt-config)[

tsconfig.json

Learn how Nuxt manages TypeScript configuration across different parts of your project.

](https://nuxt.com/docs/4.x/directory-structure/tsconfig)