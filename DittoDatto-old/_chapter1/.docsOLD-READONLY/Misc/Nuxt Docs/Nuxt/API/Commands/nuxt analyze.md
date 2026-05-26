---
title: "nuxt analyze · Nuxt Commands v4"
source: "https://nuxt.com/docs/4.x/api/commands/analyze"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## nuxt analyze

[Source](https://github.com/nuxt/cli/blob/main/packages/nuxi/src/commands/analyze.ts)

Analyze the production bundle or your Nuxt application.

Terminal

```bash
npx nuxt analyze [ROOTDIR] [--cwd=<directory>] [--logLevel=<silent|info|verbose>] [--dotenv] [-e, --extends=<layer-name>] [--name=<name>] [--no-serve]
```

The `analyze` command builds Nuxt and analyzes the production bundle (experimental).

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
| `--name=<name>` | `default` | Name of the analysis |
| `--no-serve` |  | Skip serving the analysis results |

This command sets `process.env.NODE_ENV` to `production`.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/4.commands/analyze.md)[nuxt add](https://nuxt.com/docs/4.x/api/commands/add)

[

Scaffold an entity into your Nuxt application.

](https://nuxt.com/docs/4.x/api/commands/add)[

nuxt build

Build your Nuxt application.

](https://nuxt.com/docs/4.x/api/commands/build)