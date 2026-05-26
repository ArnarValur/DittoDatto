---
title: "create nuxt · Nuxt Commands v4"
source: "https://nuxt.com/docs/4.x/api/commands/init"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## create nuxt

[Source](https://github.com/nuxt/cli/blob/main/packages/nuxi/src/commands/init.ts)

The init command initializes a fresh Nuxt project.

Terminal

```bash
npm create nuxt@latest [DIR] [--cwd=<directory>] [--logLevel=<silent|info|verbose>] [-t, --template] [-f, --force] [--offline] [--preferOffline] [--no-install] [--gitInit] [--shell] [--packageManager] [-M, --modules] [--no-modules] [--nightly]
```

The `create-nuxt` command initializes a fresh Nuxt project using [unjs/giget](https://github.com/unjs/giget).

## Arguments

| Argument | Description |
| --- | --- |
| `DIR=""` | Project directory |

## Options

| Option | Default | Description |
| --- | --- | --- |
| `--cwd=<directory>` | `.` | Specify the working directory |
| `--logLevel=<silent\|info\|verbose>` |  | Specify build-time log level |
| `-t, --template` |  | Template name |
| `-f, --force` |  | Override existing directory |
| `--offline` |  | Force offline mode |
| `--preferOffline` |  | Prefer offline mode |
| `--no-install` |  | Skip installing dependencies |
| `--gitInit` |  | Initialize git repository |
| `--shell` |  | Start shell after installation in project directory |
| `--packageManager` |  | Package manager choice (npm, pnpm, yarn, bun) |
| `-M, --modules` |  | Nuxt modules to install (comma separated without spaces) |
| `--no-modules` |  | Skip module installation prompt |
| `--nightly` |  | Use Nuxt nightly release channel (3x or latest) |

## Environment variables

- `NUXI_INIT_REGISTRY`: Set to a custom template registry. ([learn more](https://github.com/unjs/giget#custom-registry)).
	- Default registry is loaded from [nuxt/starter/templates](https://github.com/nuxt/starter/tree/templates/templates)

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/4.commands/init.md)[nuxt info](https://nuxt.com/docs/4.x/api/commands/info)

[

The info command logs information about the current or specified Nuxt project.

](https://nuxt.com/docs/4.x/api/commands/info)[

nuxt module

Search and add modules to your Nuxt application with the command line.

](https://nuxt.com/docs/4.x/api/commands/module)