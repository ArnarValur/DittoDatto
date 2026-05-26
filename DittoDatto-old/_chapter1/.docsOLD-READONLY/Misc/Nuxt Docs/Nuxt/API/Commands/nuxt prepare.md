---
title: "nuxt prepare · Nuxt Commands v4"
source: "https://nuxt.com/docs/4.x/api/commands/prepare"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## nuxt prepare

[Source](https://github.com/nuxt/cli/blob/main/packages/nuxi/src/commands/prepare.ts)

The prepare command creates a.nuxt directory in your application and generates types.

Terminal

```bash
npx nuxt prepare [ROOTDIR] [--dotenv] [--cwd=<directory>] [--logLevel=<silent|info|verbose>] [--envName] [-e, --extends=<layer-name>]
```

The `prepare` command creates a [`.nuxt`](https://nuxt.com/docs/4.x/directory-structure/nuxt) directory in your application and generates types. This can be useful in a CI environment or as a `postinstall` command in your [`package.json`](https://nuxt.com/docs/4.x/directory-structure/package).

## Arguments

| Argument | Description |
| --- | --- |
| `ROOTDIR="."` | Specifies the working directory (default: `.`) |

## Options

| Option | Default | Description |
| --- | --- | --- |
| `--dotenv` |  | Path to `.env` file to load, relative to the root directory |
| `--cwd=<directory>` |  | Specify the working directory, this takes precedence over ROOTDIR (default: `.`) |
| `--logLevel=<silent\|info\|verbose>` |  | Specify build-time log level |
| `--envName` |  | The environment to use when resolving configuration overrides (default is `production` when building, and `development` when running the dev server) |
| `-e, --extends=<layer-name>` |  | Extend from a Nuxt layer |

This command sets `process.env.NODE_ENV` to `production`.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/4.commands/prepare.md)[nuxt module](https://nuxt.com/docs/4.x/api/commands/module)

[

Search and add modules to your Nuxt application with the command line.

](https://nuxt.com/docs/4.x/api/commands/module)[

nuxt preview

The preview command starts a server to preview your application after the build command.

](https://nuxt.com/docs/4.x/api/commands/preview)