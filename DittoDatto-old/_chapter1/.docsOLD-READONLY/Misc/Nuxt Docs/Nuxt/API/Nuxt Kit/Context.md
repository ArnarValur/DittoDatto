---
title: "Context · Nuxt Kit v4"
source: "https://nuxt.com/docs/4.x/api/kit/context"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## Context

[Source](https://github.com/nuxt/nuxt/blob/main/packages/kit/src/context.ts)

Nuxt Kit provides a set of utilities to help you work with context.

Nuxt modules allow you to enhance Nuxt's capabilities. They offer a structured way to keep your code organized and modular. If you're looking to break down your module into smaller components, Nuxt offers the `useNuxt` and `tryUseNuxt` functions. These functions enable you to conveniently access the Nuxt instance from the context without having to pass it as an argument.

When you're working with the `setup` function in Nuxt modules, Nuxt is already provided as the second argument. This means you can access it directly without needing to call `useNuxt()`.

## useNuxt

Get the Nuxt instance from the context. It will throw an error if Nuxt is not available.

### Usage

```ts
import { useNuxt } from '@nuxt/kit'

const setupSomeFeature = () => {

  const nuxt = useNuxt()

  // You can now use the nuxt instance

  console.log(nuxt.options)

}
```

### Type

```ts
function useNuxt (): Nuxt
```

### Return Value

The `useNuxt` function returns the Nuxt instance, which contains all the options and methods available in Nuxt.

### Examples

## tryUseNuxt

Get the Nuxt instance from the context. It will return `null` if Nuxt is not available.

### Usage

```ts
import { tryUseNuxt } from '@nuxt/kit'

function setupSomething () {

  const nuxt = tryUseNuxt()

  if (nuxt) {

    // You can now use the nuxt instance

    console.log(nuxt.options)

  } else {

    console.log('Nuxt is not available')

  }

}
```

### Type

```ts
function tryUseNuxt (): Nuxt | null
```

### Return Value

The `tryUseNuxt` function returns the Nuxt instance if available, or `null` if Nuxt is not available.

The Nuxt instance as described in the `useNuxt` section.

### Examples

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/5.kit/6.context.md)[Components](https://nuxt.com/docs/4.x/api/kit/components)

[

Nuxt Kit provides a set of utilities to help you work with components. You can register components globally or locally, and also add directories to be scanned for components.

](https://nuxt.com/docs/4.x/api/kit/components)[

Pages

Nuxt Kit provides a set of utilities to help you create and use pages. You can use these utilities to manipulate the pages configuration or to define route rules.

](https://nuxt.com/docs/4.x/api/kit/pages)