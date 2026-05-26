---
title: "nuxt typecheck · Nuxt Commands v4"
source: "https://nuxt.com/docs/4.x/api/commands/typecheck"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## nuxt typecheck

[Source](https://github.com/nuxt/cli/blob/main/packages/nuxi/src/commands/typecheck.ts)

The typecheck command runs vue-tsc to check types throughout your app.

Terminal

```bash
npx nuxt typecheck [ROOTDIR] [--cwd=<directory>] [--logLevel=<silent|info|verbose>] [--dotenv] [-e, --extends=<layer-name>]
```

The `typecheck` command runs [`vue-tsc`](https://github.com/vuejs/language-tools/tree/master/packages/tsc) to check types throughout your app.

## Arguments

| Argument | Description |
| --- | --- |
| `ROOTDIR="."` | Specifies the working directory (default: `.`) |

## Options

| Option | Default | Description |
| --- | --- | --- |
| `--cwd=<directory>` |  | Specify the working directory, this takes precedence over ROOTDIR (default: `.`) |
| `--logLevel=<silent\|info\|verbose>` |  | Specify build-time log level |
| `--dotenv` |  | Path to `.env` file to load, relative to the root directory |
| `-e, --extends=<layer-name>` |  | Extend from a Nuxt layer |

This command sets `process.env.NODE_ENV` to `production`. To override, define `NODE_ENV` in a [`.env`](https://nuxt.com/docs/4.x/directory-structure/env) file or as a command-line argument.

Read more on how to enable type-checking at build or development time.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/4.commands/typecheck.md)[nuxt test](https://nuxt.com/docs/4.x/api/commands/test)

[

The test command runs tests using @nuxt/test-utils.

](https://nuxt.com/docs/4.x/api/commands/test)[

nuxt upgrade

The upgrade command upgrades Nuxt to the latest version.

](https://nuxt.com/docs/4.x/api/commands/upgrade)