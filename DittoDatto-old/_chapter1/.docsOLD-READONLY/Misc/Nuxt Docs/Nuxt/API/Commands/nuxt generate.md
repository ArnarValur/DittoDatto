---
title: "nuxt generate · Nuxt Commands v4"
source: "https://nuxt.com/docs/4.x/api/commands/generate"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## nuxt generate

[Source](https://github.com/nuxt/cli/blob/main/packages/nuxi/src/commands/generate.ts)

Pre-renders every route of the application and stores the result in plain HTML files.

Terminal

```bash
npx nuxt generate [ROOTDIR] [--cwd=<directory>] [--logLevel=<silent|info|verbose>] [--preset] [--dotenv] [--envName] [-e, --extends=<layer-name>]
```

The `generate` command pre-renders every route of your application and stores the result in plain HTML files that you can deploy on any static hosting services. The command triggers the `nuxt build` command with the `prerender` argument set to `true`

## Arguments

| Argument | Description |
| --- | --- |
| `ROOTDIR="."` | Specifies the working directory (default: `.`) |

## Options

| Option | Default | Description |
| --- | --- | --- |
| `--cwd=<directory>` |  | Specify the working directory, this takes precedence over ROOTDIR (default: `.`) |
| `--logLevel=<silent\|info\|verbose>` |  | Specify build-time log level |
| `--preset` |  | Nitro server preset |
| `--dotenv` |  | Path to `.env` file to load, relative to the root directory |
| `--envName` |  | The environment to use when resolving configuration overrides (default is `production` when building, and `development` when running the dev server) |
| `-e, --extends=<layer-name>` |  | Extend from a Nuxt layer |

Read more about pre-rendering and static hosting.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/4.commands/generate.md)[nuxt devtools](https://nuxt.com/docs/4.x/api/commands/devtools)

[

The devtools command allows you to enable or disable Nuxt DevTools on a per-project basis.

](https://nuxt.com/docs/4.x/api/commands/devtools)[

nuxt info

The info command logs information about the current or specified Nuxt project.

](https://nuxt.com/docs/4.x/api/commands/info)