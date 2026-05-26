---
title: "Logging · Nuxt Kit v4"
source: "https://nuxt.com/docs/4.x/api/kit/logging"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## Logging

[Source](https://github.com/nuxt/nuxt/blob/main/packages/kit/src/logger.ts)

Nuxt Kit provides a set of utilities to help you work with logging. These functions allow you to log messages with extra features.

Nuxt provides a logger instance that you can use to log messages with extra features. `useLogger` allows you to get a logger instance.

## useLogger

Returns a logger instance. It uses [consola](https://github.com/unjs/consola) under the hood.

### Usage

```ts
import { defineNuxtModule, useLogger } from '@nuxt/kit'

export default defineNuxtModule({

  setup (options, nuxt) {

    const logger = useLogger('my-module')

    logger.info('Hello from my module!')

  },

})
```

### Type

```ts
function useLogger (tag?: string, options?: Partial<ConsolaOptions>): ConsolaInstance
```

### Parameters

**`tag`**: A tag to suffix all log messages with, displayed on the right near the timestamp.

**`options`**: Consola configuration options.

### Examples

```ts
import { defineNuxtModule, useLogger } from '@nuxt/kit'

export default defineNuxtModule({

  setup (options, nuxt) {

    const logger = useLogger('my-module', { level: options.quiet ? 0 : 3 })

    logger.info('Hello from my module!')

  },

})
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/5.kit/13.logging.md)[Resolving](https://nuxt.com/docs/4.x/api/kit/resolving)

[

Nuxt Kit provides a set of utilities to help you resolve paths. These functions allow you to resolve paths relative to the current module, with unknown name or extension.

](https://nuxt.com/docs/4.x/api/kit/resolving)[

Builder

Nuxt Kit provides a set of utilities to help you work with the builder. These functions allow you to extend the Vite and webpack configurations.

](https://nuxt.com/docs/4.x/api/kit/builder)