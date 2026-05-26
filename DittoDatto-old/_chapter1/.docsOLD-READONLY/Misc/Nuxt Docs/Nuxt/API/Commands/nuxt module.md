---
title: "nuxt module · Nuxt Commands v4"
source: "https://nuxt.com/docs/4.x/api/commands/module"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## nuxt module

[Source](https://github.com/nuxt/cli/tree/main/packages/nuxi/src/commands/module)

Search and add modules to your Nuxt application with the command line.

Nuxt provides a few utilities to work with [Nuxt modules](https://nuxt.com/modules) seamlessly.

## nuxt module add

Terminal

```bash
npx nuxt module add <MODULENAME> [--cwd=<directory>] [--logLevel=<silent|info|verbose>] [--skipInstall] [--skipConfig] [--dev]
```

| Argument | Description |
| --- | --- |
| `MODULENAME` | Specify one or more modules to install by name, separated by spaces |

| Option | Default | Description |
| --- | --- | --- |
| `--cwd=<directory>` | `.` | Specify the working directory |
| `--logLevel=<silent\|info\|verbose>` |  | Specify build-time log level |
| `--skipInstall` |  | Skip npm install |
| `--skipConfig` |  | Skip nuxt.config.ts update |
| `--dev` |  | Install modules as dev dependencies |

The command lets you install [Nuxt modules](https://nuxt.com/modules) in your application with no manual work.

When running the command, it will:

- install the module as a dependency using your package manager
- add it to your [package.json](https://nuxt.com/docs/4.x/directory-structure/package) file
- update your [`nuxt.config`](https://nuxt.com/docs/4.x/directory-structure/nuxt-config) file

**Example:**

Installing the [`Pinia`](https://nuxt.com/modules/pinia) module

Terminal

```bash
npx nuxt module add pinia
```

Terminal

```bash
npx nuxt module search <QUERY> [--cwd=<directory>] [--nuxtVersion=<2|3>]
```

### Arguments

| Argument | Description |
| --- | --- |
| `QUERY` | keywords to search for |

### Options

| Option | Default | Description |
| --- | --- | --- |
| `--cwd=<directory>` | `.` | Specify the working directory |
| `--nuxtVersion=<2\|3>` |  | Filter by Nuxt version and list compatible modules only (auto detected by default) |

The command searches for Nuxt modules matching your query that are compatible with your Nuxt version.

**Example:**

Terminal

```bash
npx nuxt module search pinia
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/4.commands/module.md)[create nuxt](https://nuxt.com/docs/4.x/api/commands/init)

[

The init command initializes a fresh Nuxt project.

](https://nuxt.com/docs/4.x/api/commands/init)[

nuxt prepare

The prepare command creates a.nuxt directory in your application and generates types.

](https://nuxt.com/docs/4.x/api/commands/prepare)