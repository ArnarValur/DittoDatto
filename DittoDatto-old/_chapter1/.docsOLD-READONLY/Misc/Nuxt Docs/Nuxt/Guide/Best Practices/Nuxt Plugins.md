---
title: "Nuxt Plugins · Best Practices v4"
source: "https://nuxt.com/docs/4.x/guide/best-practices/plugins"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## Nuxt Plugins

Best practices when using Nuxt plugins.

Plugins in Nuxt allow you to extend your application with additional functionality. However, improper use can lead to performance bottlenecks. This guide outlines best practices to optimize your Nuxt plugins.

## Avoid costly plugin setup

A large number of plugins can cause performance issues, especially if they require expensive computations or take too long to initialize. Since plugins run during the hydration phase, inefficient setups can block rendering and degrade the user experience.

## Use Composition whenever possible

Whenever possible, favor composition over plugins. Just like in Vue, many utilities and composables can be used directly without the need for a plugin. This keeps your project lightweight and improves maintainability.

## If async, enable parallel

By default, all plugins loads synchronously. When defining asynchronous plugins, setting `parallel: true` allows multiple plugins to load concurrently, improving performance by preventing blocking operations.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/3.guide/2.best-practices/plugins.md)[Nuxt Performance](https://nuxt.com/docs/4.x/guide/best-practices/performance)

[

Best practices for improving performance of Nuxt apps.

](https://nuxt.com/docs/4.x/guide/best-practices/performance)[

MCP Server

Use Nuxt documentation in your AI assistants with Model Context Protocol support.

](https://nuxt.com/docs/4.x/guide/ai/mcp)