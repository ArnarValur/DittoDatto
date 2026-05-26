---
title: "nuxt test · Nuxt Commands v4"
source: "https://nuxt.com/docs/4.x/api/commands/test"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## nuxt test

[Source](https://github.com/nuxt/cli/blob/main/packages/nuxi/src/commands/test.ts)

The test command runs tests using @nuxt/test-utils.

Terminal

```bash
npx nuxt test [ROOTDIR] [--cwd=<directory>] [--logLevel=<silent|info|verbose>] [--dev] [--watch]
```

The `test` command runs tests using [`@nuxt/test-utils`](https://nuxt.com/docs/4.x/getting-started/testing). This command sets `process.env.NODE_ENV` to `test` if not already set.

## Arguments

| Argument | Description |
| --- | --- |
| `ROOTDIR="."` | Specifies the working directory (default: `.`) |

## Options

| Option | Default | Description |
| --- | --- | --- |
| `--cwd=<directory>` |  | Specify the working directory, this takes precedence over ROOTDIR (default: `.`) |
| `--logLevel=<silent\|info\|verbose>` |  | Specify build-time log level |
| `--dev` |  | Run in dev mode |
| `--watch` |  | Watch mode |

This command sets `process.env.NODE_ENV` to `test`.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/4.commands/test.md)[nuxt preview](https://nuxt.com/docs/4.x/api/commands/preview)

[

The preview command starts a server to preview your application after the build command.

](https://nuxt.com/docs/4.x/api/commands/preview)[

nuxt typecheck

The typecheck command runs vue-tsc to check types throughout your app.

](https://nuxt.com/docs/4.x/api/commands/typecheck)