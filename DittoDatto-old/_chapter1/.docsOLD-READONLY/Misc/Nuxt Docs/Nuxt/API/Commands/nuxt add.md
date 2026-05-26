---
title: "nuxt add · Nuxt Commands v4"
source: "https://nuxt.com/docs/4.x/api/commands/add"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
Terminal

```bash
npx nuxt add <TEMPLATE> <NAME> [--cwd=<directory>] [--logLevel=<silent|info|verbose>] [--force]
```

## Arguments

| Argument | Description |
| --- | --- |
| `TEMPLATE` | Specify which template to generate (options: ) |
| `NAME` | Specify name of the generated file |

## Options

| Option | Default | Description |
| --- | --- | --- |
| `--cwd=<directory>` | `.` | Specify the working directory |
| `--logLevel=<silent\|info\|verbose>` |  | Specify build-time log level |
| `--force` | `false` | Force override file if it already exists |

**Modifiers:**

Some templates support additional modifier flags to add a suffix (like `.client` or `.get`) to their name.

Terminal

```bash
# Generates \`/plugins/sockets.client.ts\`

npx nuxt add plugin sockets --client
```

## nuxt add component

- Modifier flags: `--mode client|server` or `--client` or `--server`

Terminal

```bash
# Generates \`app/components/TheHeader.vue\`

npx nuxt add component TheHeader
```

## nuxt add composable

Terminal

```bash
# Generates \`app/composables/foo.ts\`

npx nuxt add composable foo
```

## nuxt add layout

Terminal

```bash
# Generates \`app/layouts/custom.vue\`

npx nuxt add layout custom
```

## nuxt add plugin

- Modifier flags: `--mode client|server` or `--client` or `--server`

Terminal

```bash
# Generates \`app/plugins/analytics.ts\`

npx nuxt add plugin analytics
```

## nuxt add page

Terminal

```bash
# Generates \`app/pages/about.vue\`

npx nuxt add page about
```

Terminal

```bash
# Generates \`app/pages/category/[id].vue\`

npx nuxt add page "category/[id]"
```

## nuxt add middleware

- Modifier flags: `--global`

Terminal

```bash
# Generates \`app/middleware/auth.ts\`

npx nuxt add middleware auth
```

## nuxt add api

- Modifier flags: `--method` (can accept `connect`, `delete`, `get`, `head`, `options`, `patch`, `post`, `put` or `trace`) or alternatively you can directly use `--get`, `--post`, etc.

Terminal

```bash
# Generates \`server/api/hello.ts\`

npx nuxt add api hello
```

## nuxt add layer

Terminal

```bash
# Generates \`layers/subscribe/nuxt.config.ts\`

npx nuxt add layer subscribe
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/4.commands/add.md)[updateAppConfig](https://nuxt.com/docs/4.x/api/utils/update-app-config)

[

Update the App Config at runtime.

](https://nuxt.com/docs/4.x/api/utils/update-app-config)[

nuxt analyze

Analyze the production bundle or your Nuxt application.

](https://nuxt.com/docs/4.x/api/commands/analyze)