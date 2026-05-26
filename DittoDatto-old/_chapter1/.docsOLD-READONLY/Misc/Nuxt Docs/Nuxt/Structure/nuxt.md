---
title: "Nuxt: The Full-Stack Vue Framework"
source: "https://nuxt.com/docs/4.x/directory-structure/nuxt"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description: "Build fast, production-ready web apps with Vue. File-based routing, auto-imports, and server-side rendering — all configured out of the box."
tags:
  - "Nuxt"
---
## .nuxt

Nuxt uses the.nuxt/ directory in development to generate your Vue application.

This directory should be added to your [`.gitignore`](https://nuxt.com/docs/4.x/directory-structure/gitignore) file to avoid pushing the dev build output to your repository.

This directory is interesting if you want to learn more about the files Nuxt generates based on your directory structure.

Nuxt also provides a Virtual File System (VFS) for modules to add templates to this directory without writing them to disk.

You can explore the generated files by opening the [Nuxt DevTools](https://devtools.nuxt.com/) in development mode and navigating to the **Virtual Files** tab.

You should not touch any files inside since the whole directory will be re-created when running [`nuxt dev`](https://nuxt.com/docs/4.x/api/commands/dev).

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/2.directory-structure/0.nuxt.md)[Upgrade Guide](https://nuxt.com/docs/4.x/getting-started/upgrade)

[

Learn how to upgrade to the latest Nuxt version.

](https://nuxt.com/docs/4.x/getting-started/upgrade)[

.output

Nuxt creates the.output/ directory when building your application for production.

](https://nuxt.com/docs/4.x/directory-structure/output)