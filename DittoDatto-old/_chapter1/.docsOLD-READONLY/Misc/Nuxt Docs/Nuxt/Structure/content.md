---
title: "content · Nuxt Directory Structure v4"
source: "https://nuxt.com/docs/4.x/directory-structure/content"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## content

Use the content/ directory to create a file-based CMS for your application.

[Nuxt Content](https://content.nuxt.com/) reads the `content/` directory in your project and parses `.md`, `.yml`, `.csv` and `.json` files to create a file-based CMS for your application.

- Render your content with built-in components.
- Query your content with a MongoDB-like API.
- Use your Vue components in Markdown files with the MDC syntax.
- Automatically generate your navigation.

Learn more in **Nuxt Content** documentation.

## Enable Nuxt Content

Install the `@nuxt/content` module in your project as well as adding it to your `nuxt.config.ts` with one command:

Terminal

```bash
npx nuxt module add content
```

## Create Content

Place your markdown files inside the `content/` directory:

content/index.md

```md
# Hello Content
```

The module automatically loads and parses them.

## Render Content

To render content pages, add a [catch-all route](https://nuxt.com/docs/4.x/directory-structure/app/pages/#catch-all-route) using the [`<ContentRenderer>`](https://content.nuxt.com/docs/components/content-renderer) component:

app/pages/\[...slug\].vue

```
<script lang="ts" setup>

const route = useRoute()

const { data: page } = await useAsyncData(route.path, () => {

  return queryCollection('content').path(route.path).first()

})

</script>

<template>

  <div>

    <header><!-- ... --></header>

    <ContentRenderer

      v-if="page"

      :value="page"

    />

    <footer><!-- ... --></footer>

  </div>

</template>
```

## Documentation

Head over to [https://content.nuxt.com](https://content.nuxt.com/) to learn more about the Content module features, such as how to build queries and use Vue components in your Markdown files with the MDC syntax.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/2.directory-structure/1.content.md)