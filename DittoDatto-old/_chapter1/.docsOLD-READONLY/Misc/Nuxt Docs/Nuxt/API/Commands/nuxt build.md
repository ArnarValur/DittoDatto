---
title: "nuxt build · Nuxt Commands v4"
source: "https://nuxt.com/docs/4.x/api/commands/build"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## nuxt build

[Source](https://github.com/nuxt/cli/blob/main/packages/nuxi/src/commands/build.ts)

Build your Nuxt application.

Terminal

```bash
npx nuxt build [ROOTDIR] [--cwd=<directory>] [--logLevel=<silent|info|verbose>] [--prerender] [--preset] [--dotenv] [--envName] [-e, --extends=<layer-name>]
```

The `build` command creates a `.output` directory with all your application, server and dependencies ready for production.

## Arguments

| Argument | Description |
| --- | --- |
| `ROOTDIR="."` | Specifies the working directory (default: `.`) |

## Options

| Option | Default | Description |
| --- | --- | --- |
| `--cwd=<directory>` |  | Specify the working directory, this takes precedence over ROOTDIR (default: `.`) |
| `--logLevel=<silent\|info\|verbose>` |  | Specify build-time log level |
| `--prerender` |  | Build Nuxt and prerender static routes |
| `--preset` |  | Nitro server preset |
| `--dotenv` |  | Path to `.env` file to load, relative to the root directory |
| `--envName` |  | The environment to use when resolving configuration overrides (default is `production` when building, and `development` when running the dev server) |
| `-e, --extends=<layer-name>` |  | Extend from a Nuxt layer |

This command sets `process.env.NODE_ENV` to `production`.

`--prerender` will always set the `preset` to `static`

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/4.commands/build.md)[nuxt analyze](https://nuxt.com/docs/4.x/api/commands/analyze)

[

Analyze the production bundle or your Nuxt application.

](https://nuxt.com/docs/4.x/api/commands/analyze)[

nuxt build-module

Nuxt command to build your Nuxt module before publishing.

](https://nuxt.com/docs/4.x/api/commands/build-module)