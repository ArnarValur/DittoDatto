---
title: ".nuxtignore · Nuxt Directory Structure v4"
source: "https://nuxt.com/docs/4.x/directory-structure/nuxtignore"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## .nuxtignore

The.nuxtignore file lets Nuxt ignore files in your project’s root directory during the build phase.

The `.nuxtignore` file tells Nuxt to ignore files in your project’s root directory ([`rootDir`](https://nuxt.com/docs/4.x/api/nuxt-config#rootdir)) during the build phase.

It is subject to the same specification as [`.gitignore`](https://nuxt.com/docs/4.x/directory-structure/gitignore) and `.eslintignore` files, in which each line is a glob pattern indicating which files should be ignored.

You can also configure [`ignoreOptions`](https://nuxt.com/docs/4.x/api/nuxt-config#ignoreoptions), [`ignorePrefix`](https://nuxt.com/docs/4.x/api/nuxt-config#ignoreprefix) and [`ignore`](https://nuxt.com/docs/4.x/api/nuxt-config#ignore) in your `nuxt.config` file.

## Usage

.nuxtignore

```bash
# ignore layout foo.vue

app/layouts/foo.vue

# ignore layout files whose name ends with -ignore.vue

app/layouts/*-ignore.vue

# ignore page bar.vue

app/pages/bar.vue

# ignore page inside ignore folder

app/pages/ignore/*.vue

# ignore route middleware files under foo folder except foo/bar.js

app/middleware/foo/*.js

!app/middleware/foo/bar.js
```

More details about the spec are in the **gitignore documentation**.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/2.directory-structure/2.nuxtignore.md)[.gitignore](https://nuxt.com/docs/4.x/directory-structure/gitignore)

[

A.gitignore file specifies intentionally untracked files that git should ignore.

](https://nuxt.com/docs/4.x/directory-structure/gitignore)[

.nuxtrc

The.nuxtrc file allows you to define nuxt configurations in a flat syntax.

](https://nuxt.com/docs/4.x/directory-structure/nuxtrc)