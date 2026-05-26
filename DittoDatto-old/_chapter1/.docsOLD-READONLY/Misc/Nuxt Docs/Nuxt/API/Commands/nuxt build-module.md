---
title: "nuxt build-module · Nuxt Commands v4"
source: "https://nuxt.com/docs/4.x/api/commands/build-module"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## nuxt build-module

[Source](https://github.com/nuxt/module-builder/blob/main/src/cli.ts)

Nuxt command to build your Nuxt module before publishing.

Terminal

```bash
npx nuxt build-module [ROOTDIR] [--cwd=<directory>] [--logLevel=<silent|info|verbose>] [--build] [--stub] [--sourcemap] [--prepare]
```

The `build-module` command runs `@nuxt/module-builder` to generate `dist` directory within your `rootDir` that contains the full build for your **nuxt-module**.

## Arguments

| Argument | Description |
| --- | --- |
| `ROOTDIR="."` | Specifies the working directory (default: `.`) |

## Options

| Option | Default | Description |
| --- | --- | --- |
| `--cwd=<directory>` |  | Specify the working directory, this takes precedence over ROOTDIR (default: `.`) |
| `--logLevel=<silent\|info\|verbose>` |  | Specify build-time log level |
| `--build` | `false` | Build module for distribution |
| `--stub` | `false` | Stub dist instead of actually building it for development |
| `--sourcemap` | `false` | Generate sourcemaps |
| `--prepare` | `false` | Prepare module for local development |

Read more about `@nuxt/module-builder`.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/4.commands/build-module.md)[nuxt build](https://nuxt.com/docs/4.x/api/commands/build)

[

Build your Nuxt application.

](https://nuxt.com/docs/4.x/api/commands/build)[

nuxt cleanup

Remove common generated Nuxt files and caches.

](https://nuxt.com/docs/4.x/api/commands/cleanup)