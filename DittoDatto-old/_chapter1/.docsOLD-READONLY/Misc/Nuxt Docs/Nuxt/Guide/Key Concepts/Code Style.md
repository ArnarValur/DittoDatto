---
title: "Code Style · Nuxt Concepts v4"
source: "https://nuxt.com/docs/4.x/guide/concepts/code-style"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## Code Style

Nuxt supports ESLint out of the box

## ESLint

The recommended approach for Nuxt is to enable ESLint support using the [`@nuxt/eslint`](https://eslint.nuxt.com/packages/module) module, that will setup project-aware ESLint configuration for you.

The module is designed for the [new ESLint flat config format](https://eslint.org/docs/latest/use/configure/configuration-files) which is the [default format since ESLint v9](https://eslint.org/blog/2024/04/eslint-v9.0.0-released/). If you are using the legacy `.eslintrc` config, you will need to [configure manually with `@nuxt/eslint-config`](https://eslint.nuxt.com/packages/config#customizing-the-config). We highly recommend you to migrate over the flat config to be future-proof.

## Quick Setup

```bash
npx nuxt module add eslint
```

Start your Nuxt app, a `eslint.config.mjs` file will be generated under your project root. You can customize it as needed.

You can learn more about the module and customizations in [Nuxt ESLint's documentation](https://eslint.nuxt.com/packages/module).

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/3.guide/1.concepts/9.code-style.md)[TypeScript](https://nuxt.com/docs/4.x/guide/concepts/typescript)

[

Nuxt is fully typed and provides helpful shortcuts to ensure you have access to accurate type information when you are coding.

](https://nuxt.com/docs/4.x/guide/concepts/typescript)[

Nuxt and hydration

Why fixing hydration issues is important

](https://nuxt.com/docs/4.x/guide/best-practices/hydration)