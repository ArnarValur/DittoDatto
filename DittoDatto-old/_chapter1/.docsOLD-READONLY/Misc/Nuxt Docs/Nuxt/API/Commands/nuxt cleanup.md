---
title: "nuxt cleanup · Nuxt Commands v4"
source: "https://nuxt.com/docs/4.x/api/commands/cleanup"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## nuxt cleanup

[Source](https://github.com/nuxt/cli/blob/main/packages/nuxi/src/commands/cleanup.ts)

Remove common generated Nuxt files and caches.

Terminal

```bash
npx nuxt cleanup [ROOTDIR] [--cwd=<directory>]
```

The `cleanup` command removes common generated Nuxt files and caches, including:

- `.nuxt`
- `.output`
- `node_modules/.vite`
- `node_modules/.cache`

## Arguments

| Argument | Description |
| --- | --- |
| `ROOTDIR="."` | Specifies the working directory (default: `.`) |

## Options

| Option | Default | Description |
| --- | --- | --- |
| `--cwd=<directory>` |  | Specify the working directory, this takes precedence over ROOTDIR (default: `.`) |

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/4.commands/cleanup.md)[nuxt build-module](https://nuxt.com/docs/4.x/api/commands/build-module)

[

Nuxt command to build your Nuxt module before publishing.

](https://nuxt.com/docs/4.x/api/commands/build-module)[

nuxt dev

The dev command starts a development server with hot module replacement at http://localhost:3000

](https://nuxt.com/docs/4.x/api/commands/dev)