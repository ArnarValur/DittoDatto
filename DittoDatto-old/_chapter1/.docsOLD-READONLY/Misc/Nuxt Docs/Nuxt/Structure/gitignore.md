---
title: ".gitignore · Nuxt Directory Structure v4"
source: "https://nuxt.com/docs/4.x/directory-structure/gitignore"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## .gitignore

A.gitignore file specifies intentionally untracked files that git should ignore.

A `.gitignore` file specifies intentionally untracked files that git should ignore.

Read more in the git documentation.

We recommend having a `.gitignore` file that has **at least** the following entries present:

.gitignore

```bash
# Nuxt dev/build outputs

.output

.data

.nuxt

.nitro

.cache

dist

# Node dependencies

node_modules

# Logs

logs

*.log

# Misc

.DS_Store

# Local env files

.env

.env.*

!.env.example
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/2.directory-structure/2.gitignore.md)[.env](https://nuxt.com/docs/4.x/directory-structure/env)

[

A.env file specifies your build/dev-time environment variables.

](https://nuxt.com/docs/4.x/directory-structure/env)[

.nuxtignore

The.nuxtignore file lets Nuxt ignore files in your project’s root directory during the build phase.

](https://nuxt.com/docs/4.x/directory-structure/nuxtignore)