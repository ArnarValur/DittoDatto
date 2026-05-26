---
title: "public · Nuxt Directory Structure v4"
source: "https://nuxt.com/docs/4.x/directory-structure/public"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## public

The public/ directory is used to serve your website's static assets.

Files contained within the `public/` directory are served at the root and are not modified by the build process. This is suitable for files that have to keep their names (e.g. `robots.txt`) *or* likely won't change (e.g. `favicon.ico`).

Directory structure

```bash
-| public/

---| favicon.ico

---| og-image.png

---| robots.txt
```

app/app.vue

```
<script setup lang="ts">

useSeoMeta({

  ogImage: '/og-image.png',

})

</script>
```

This is known as the `static/` directory in Nuxt 2.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/2.directory-structure/1.public.md)