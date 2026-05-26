---
title: "nuxt devtools · Nuxt Commands v4"
source: "https://nuxt.com/docs/4.x/api/commands/devtools"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## nuxt devtools

[Source](https://github.com/nuxt/cli/blob/main/packages/nuxi/src/commands/devtools.ts)

The devtools command allows you to enable or disable Nuxt DevTools on a per-project basis.

Terminal

```bash
npx nuxt devtools <COMMAND> [ROOTDIR] [--cwd=<directory>]
```

Running `nuxt devtools enable` will install the Nuxt DevTools globally, and also enable it within the particular project you are using. It is saved as a preference in your user-level `.nuxtrc`. If you want to remove devtools support for a particular project, you can run `nuxt devtools disable`.

## Arguments

| Argument | Description |
| --- | --- |
| `COMMAND` | Command to run (options: ) |
| `ROOTDIR="."` | Specifies the working directory (default: `.`) |

## Options

| Option | Default | Description |
| --- | --- | --- |
| `--cwd=<directory>` |  | Specify the working directory, this takes precedence over ROOTDIR (default: `.`) |

Read more about the **Nuxt DevTools**.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/4.commands/devtools.md)[nuxt dev](https://nuxt.com/docs/4.x/api/commands/dev)

[

The dev command starts a development server with hot module replacement at http://localhost:3000

](https://nuxt.com/docs/4.x/api/commands/dev)[

nuxt generate

Pre-renders every route of the application and stores the result in plain HTML files.

](https://nuxt.com/docs/4.x/api/commands/generate)