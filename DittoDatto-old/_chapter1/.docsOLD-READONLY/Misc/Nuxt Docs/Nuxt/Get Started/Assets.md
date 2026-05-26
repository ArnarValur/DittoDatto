---
title: "Nuxt: The Full-Stack Vue Framework"
source: "https://nuxt.com/docs/4.x/getting-started/assets"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description: "Build fast, production-ready web apps with Vue. File-based routing, auto-imports, and server-side rendering — all configured out of the box."
tags:
  - "Nuxt"
---
## Assets

Nuxt offers two options for your assets.

Nuxt uses two directories to handle assets like stylesheets, fonts or images.

- The [`public/`](https://nuxt.com/docs/4.x/directory-structure/public) directory content is served at the server root as-is.
- The [`app/assets/`](https://nuxt.com/docs/4.x/directory-structure/app/assets) directory contains by convention every asset that you want the build tool (Vite or webpack) to process.

## Public Directory

The [`public/`](https://nuxt.com/docs/4.x/directory-structure/public) directory is used as a public server for static assets publicly available at a defined URL of your application.

You can get a file in the [`public/`](https://nuxt.com/docs/4.x/directory-structure/public) directory from your application's code or from a browser by the root URL `/`.

### Example

For example, referencing an image file in the `public/img/` directory, available at the static URL `/img/nuxt.png`:

app/app.vue

```
<template>

  <img

    src="/img/nuxt.png"

    alt="Discover Nuxt"

  >

</template>
```

## Assets Directory

Nuxt uses [Vite](https://vite.dev/guide/assets) (default) or [webpack](https://webpack.js.org/guides/asset-management/) to build and bundle your application. The main function of these build tools is to process JavaScript files, but they can be extended through [plugins](https://vite.dev/plugins/) (for Vite) or [loaders](https://webpack.js.org/loaders/) (for webpack) to process other kinds of assets, like stylesheets, fonts or SVGs. This step transforms the original file, mainly for performance or caching purposes (such as stylesheet minification or browser cache invalidation).

By convention, Nuxt uses the [`app/assets/`](https://nuxt.com/docs/4.x/directory-structure/app/assets) directory to store these files but there is no auto-scan functionality for this directory, and you can use any other name for it.

In your application's code, you can reference a file located in the [`app/assets/`](https://nuxt.com/docs/4.x/directory-structure/app/assets) directory by using the `~/assets/` path.

### Example

For example, referencing an image file that will be processed if a build tool is configured to handle this file extension:

app/app.vue

```
<template>

  <img

    src="~/assets/img/nuxt.png"

    alt="Discover Nuxt"

  >

</template>
```

Nuxt won't serve files in the [`app/assets/`](https://nuxt.com/docs/4.x/directory-structure/app/assets) directory at a static URL like `/assets/my-file.png`. If you need a static URL, use the [`public/`](https://nuxt.com/docs/4.x/getting-started/assets#public-directory) directory.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/1.getting-started/05.assets.md)[Views](https://nuxt.com/docs/4.x/getting-started/views)

[

Nuxt provides several component layers to implement the user interface of your application.

](https://nuxt.com/docs/4.x/getting-started/views)[

Styling

Learn how to style your Nuxt application.

](https://nuxt.com/docs/4.x/getting-started/styling)