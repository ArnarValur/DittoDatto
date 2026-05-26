---
title: "nuxt upgrade · Nuxt Commands v4"
source: "https://nuxt.com/docs/4.x/api/commands/upgrade"
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
npx nuxt upgrade [ROOTDIR] [--cwd=<directory>] [--logLevel=<silent|info|verbose>] [--dedupe] [-f, --force] [-ch, --channel=<stable|nightly|v3|v4|v4-nightly|v3-nightly>]
```

The `upgrade` command upgrades Nuxt to the latest version.

## Arguments

| Argument | Description |
| --- | --- |
| `ROOTDIR="."` | Specifies the working directory (default: `.`) |

## Options

| Option | Default | Description |
| --- | --- | --- |
| `--cwd=<directory>` |  | Specify the working directory, this takes precedence over ROOTDIR (default: `.`) |
| `--logLevel=<silent\|info\|verbose>` |  | Specify build-time log level |
| `--dedupe` |  | Dedupe dependencies after upgrading |
| `-f, --force` |  | Force upgrade to recreate lockfile and node\_modules |
| `-ch, --channel=<stable\|nightly\|v3\|v4\|v4-nightly\|v3-nightly>` | `stable` | Specify a channel to install from (default: stable) |

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/4.commands/upgrade.md)[nuxt typecheck](https://nuxt.com/docs/4.x/api/commands/typecheck)

[

The typecheck command runs vue-tsc to check types throughout your app.

](https://nuxt.com/docs/4.x/api/commands/typecheck)[

Modules

Nuxt Kit provides a set of utilities to help you create and use modules. You can use these utilities to create your own modules or to reuse existing modules.

](https://nuxt.com/docs/4.x/api/kit/modules)