---
title: "Nuxt: The Full-Stack Vue Framework"
source: "https://nuxt.com/docs/4.x/directory-structure/output"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description: "Build fast, production-ready web apps with Vue. File-based routing, auto-imports, and server-side rendering — all configured out of the box."
tags:
  - "Nuxt"
---
## .output

Nuxt creates the.output/ directory when building your application for production.

This directory should be added to your [`.gitignore`](https://nuxt.com/docs/4.x/directory-structure/gitignore) file to avoid pushing the build output to your repository.

Use this directory to deploy your Nuxt application to production.

Read more in Docs > 4 X > Getting Started > Deployment.

You should not touch any files inside since the whole directory will be re-created when running [`nuxt build`](https://nuxt.com/docs/4.x/api/commands/build).

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/2.directory-structure/0.output.md)[.nuxt](https://nuxt.com/docs/4.x/directory-structure/nuxt)

[

Nuxt uses the.nuxt/ directory in development to generate your Vue application.

](https://nuxt.com/docs/4.x/directory-structure/nuxt)[

assets

The assets/ directory is used to add all the website's assets that the build tool will process.

](https://nuxt.com/docs/4.x/directory-structure/app/assets)