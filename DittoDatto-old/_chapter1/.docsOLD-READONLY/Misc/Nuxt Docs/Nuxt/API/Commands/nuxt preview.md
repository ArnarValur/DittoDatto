---
title: "nuxt preview · Nuxt Commands v4"
source: "https://nuxt.com/docs/4.x/api/commands/preview"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## nuxt preview

[Source](https://github.com/nuxt/cli/blob/main/packages/nuxi/src/commands/preview.ts)

The preview command starts a server to preview your application after the build command.

Terminal

```bash
npx nuxt preview [ROOTDIR] [--cwd=<directory>] [--logLevel=<silent|info|verbose>] [--envName] [-e, --extends=<layer-name>] [-p, --port] [--dotenv]
```

The `preview` command starts a server to preview your Nuxt application after running the `build` command. The `start` command is an alias for `preview`. When running your application in production refer to the [Deployment section](https://nuxt.com/docs/4.x/getting-started/deployment).

## Arguments

| Argument | Description |
| --- | --- |
| `ROOTDIR="."` | Specifies the working directory (default: `.`) |

## Options

| Option | Default | Description |
| --- | --- | --- |
| `--cwd=<directory>` |  | Specify the working directory, this takes precedence over ROOTDIR (default: `.`) |
| `--logLevel=<silent\|info\|verbose>` |  | Specify build-time log level |
| `--envName` |  | The environment to use when resolving configuration overrides (default is `production` when building, and `development` when running the dev server) |
| `-e, --extends=<layer-name>` |  | Extend from a Nuxt layer |
| `-p, --port` |  | Port to listen on (use `PORT` environment variable to override) |
| `--dotenv` |  | Path to `.env` file to load, relative to the root directory |

This command sets `process.env.NODE_ENV` to `production`. To override, define `NODE_ENV` in a `.env` file or as command-line argument.

For convenience, in preview mode, your [`.env`](https://nuxt.com/docs/4.x/directory-structure/env) file will be loaded into `process.env`. (However, in production you will need to ensure your environment variables are set yourself. For example, with Node.js 20+ you could do this by running `node --env-file .env .output/server/index.mjs` to start your server.)

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/4.commands/preview.md)[nuxt prepare](https://nuxt.com/docs/4.x/api/commands/prepare)

[

The prepare command creates a.nuxt directory in your application and generates types.

](https://nuxt.com/docs/4.x/api/commands/prepare)[

nuxt test

The test command runs tests using @nuxt/test-utils.

](https://nuxt.com/docs/4.x/api/commands/test)