---
title: "NuxtApp · Nuxt Advanced v4"
source: "https://nuxt.com/docs/4.x/guide/going-further/nuxt-app"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## NuxtApp

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/nuxt.ts)

In Nuxt, you can access runtime app context within composables, components and plugins.

In Nuxt, you can access runtime app context within composables, components and plugins.

In Nuxt 2, this was referred to as **Nuxt context**.

## Nuxt App Interface

Jump over the `NuxtApp` interface documentation.

## The Nuxt Context

Many composables and utilities, both built-in and user-made, may require access to the Nuxt instance. This doesn't exist everywhere on your application, because a fresh instance is created on every request.

Currently, the Nuxt context is only accessible in [plugins](https://nuxt.com/docs/4.x/directory-structure/app/plugins), [Nuxt hooks](https://nuxt.com/docs/4.x/guide/going-further/hooks), [Nuxt middleware](https://nuxt.com/docs/4.x/directory-structure/app/middleware) (if wrapped in `defineNuxtRouteMiddleware`), and [setup functions](https://vuejs.org/api/composition-api-setup) (in pages and components).

If a composable is called without access to the context, you may get an error stating that 'A composable that requires access to the Nuxt instance was called outside of a plugin, Nuxt hook, Nuxt middleware, or Vue setup function.' In that case, you can also explicitly call functions within this context by using [`nuxtApp.runWithContext`](https://nuxt.com/docs/4.x/api/composables/use-nuxt-app#runwithcontext).

## Accessing NuxtApp

Within composables, plugins and components you can access `nuxtApp` with [`useNuxtApp()`](https://nuxt.com/docs/4.x/api/composables/use-nuxt-app):

app/composables/useMyComposable.ts

```ts
export function useMyComposable () {

  const nuxtApp = useNuxtApp()

  // access runtime nuxt app instance

}
```

If your composable does not always need `nuxtApp` or you simply want to check if it is present or not, since [`useNuxtApp`](https://nuxt.com/docs/4.x/api/composables/use-nuxt-app) throws an exception, you can use [`tryUseNuxtApp`](https://nuxt.com/docs/4.x/api/composables/use-nuxt-app#tryusenuxtapp) instead.

Plugins also receive `nuxtApp` as the first argument for convenience.

Read more in Docs > 4 X > Directory Structure > App > Plugins.

## Providing Helpers

You can provide helpers to be usable across all composables and application. This usually happens within a Nuxt plugin.

```ts
const nuxtApp = useNuxtApp()

nuxtApp.provide('hello', name => \`Hello ${name}!\`)

console.log(nuxtApp.$hello('name')) // Prints "Hello name!"
```

It is possible to inject helpers by returning an object with a `provide` key in plugins.

In Nuxt 2 plugins, this was referred to as **inject function**.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/3.guide/6.going-further/6.nuxt-app.md)[Nuxt Kit](https://nuxt.com/docs/4.x/guide/going-further/kit)

[

@nuxt/kit provides features for module authors.

](https://nuxt.com/docs/4.x/guide/going-further/kit)[

Authoring Nuxt Layers

Nuxt provides a powerful system that allows you to extend the default files, configs, and much more.

](https://nuxt.com/docs/4.x/guide/going-further/layers)