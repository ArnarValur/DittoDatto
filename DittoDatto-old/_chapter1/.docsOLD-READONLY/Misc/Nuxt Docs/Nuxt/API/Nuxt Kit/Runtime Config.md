---
title: "Runtime Config · Nuxt Kit v4"
source: "https://nuxt.com/docs/4.x/api/kit/runtime-config"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## Runtime Config

[Source](https://github.com/nuxt/nuxt/blob/main/packages/kit/src/runtime-config.ts)

Nuxt Kit provides a set of utilities to help you access and modify Nuxt runtime configuration.

## useRuntimeConfig

At build-time, it is possible to access the resolved Nuxt [runtime config](https://nuxt.com/docs/4.x/guide/going-further/runtime-config).

### Type

```ts
function useRuntimeConfig (): Record<string, unknown>
```

## updateRuntimeConfig

It is also possible to update runtime configuration. This will be merged with the existing runtime configuration, and if Nitro has already been initialized it will trigger an HMR event to reload the Nitro runtime config.

### Type

```ts
function updateRuntimeConfig (config: Record<string, unknown>): void | Promise<void>
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/5.kit/10.runtime-config.md)[Modules](https://nuxt.com/docs/4.x/api/kit/modules)

[

Nuxt Kit provides a set of utilities to help you create and use modules. You can use these utilities to create your own modules or to reuse existing modules.

](https://nuxt.com/docs/4.x/api/kit/modules)[

Templates

Nuxt Kit provides a set of utilities to help you work with templates. These functions allow you to generate extra files during development and build time.

](https://nuxt.com/docs/4.x/api/kit/templates)