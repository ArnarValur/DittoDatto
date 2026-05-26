---
title: "Publish & Share Your Module · Nuxt Modules Author Guide v4"
source: "https://nuxt.com/docs/4.x/guide/modules/ecosystem"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
The [Nuxt module ecosystem](https://nuxt.com/modules) represents more than 35 million monthly NPM downloads and provides extended functionalities and integrations with all sort of tools. You can be part of this ecosystem!

Watch Vue School video about Nuxt module types.

## Understand Module Types

**Official modules** are modules prefixed (scoped) with `@nuxt/` (e.g. [`@nuxt/content`](https://content.nuxt.com/)). They are made and maintained actively by the Nuxt team. Like with the framework, contributions from the community are more than welcome to help make them better!

**Community modules** are modules prefixed (scoped) with `@nuxtjs/` (e.g. [`@nuxtjs/tailwindcss`](https://tailwindcss.nuxtjs.org/)). They are proven modules made and maintained by community members. Again, contributions are welcome from anyone.

**Third-party and other community modules** are modules (often) prefixed with `nuxt-`. Anyone can make them, using this prefix allows these modules to be discoverable on npm. This is the best starting point to draft and try an idea!

**Private or personal modules** are modules made for your own use case or company. They don't need to follow any naming rules to work with Nuxt and are often seen scoped under an npm organization (e.g. `@my-company/nuxt-auth`)

## List Your Module

Any community modules are welcome to be listed on [the module list](https://nuxt.com/modules). To be listed, [open an issue in the nuxt/modules](https://github.com/nuxt/modules/issues/new?template=module_request.yml) repository. The Nuxt team can help you to apply best practices before listing.

## Join nuxt-modules

By moving your modules to [nuxt-modules](https://github.com/nuxt-modules), there is always someone else to help, and this way, we can join forces to make one perfect solution.

If you have an already published and working module, and want to transfer it to `nuxt-modules`, [open an issue in nuxt/modules](https://github.com/nuxt/modules/issues/new).

By joining `nuxt-modules` we can rename your community module under the `@nuxtjs/` scope and provide a subdomain (e.g. `my-module.nuxtjs.org`) for its documentation.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/3.guide/4.modules/7.ecosystem.md)[Follow Best Practices](https://nuxt.com/docs/4.x/guide/modules/best-practices)

[

Build performant and maintainable Nuxt modules with these guidelines.

](https://nuxt.com/docs/4.x/guide/modules/best-practices)[

Custom Routing

In Nuxt, your routing is defined by the structure of your files inside the pages directory. However, since it uses vue-router under the hood, Nuxt offers you several ways to add custom routes in your project.

](https://nuxt.com/docs/4.x/guide/recipes/custom-routing)