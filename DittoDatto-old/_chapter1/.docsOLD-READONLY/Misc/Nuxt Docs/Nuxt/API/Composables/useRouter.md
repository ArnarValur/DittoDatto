---
title: "useRouter · Nuxt Composables v4"
source: "https://nuxt.com/docs/4.x/api/composables/use-router"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## useRouter

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/composables/router.ts)

The useRouter composable returns the router instance.

app/pages/index.vue

```
<script setup lang="ts">

const router = useRouter()

</script>
```

If you only need the router instance within your template, use `$router`:

app/pages/index.vue

```
<template>

  <button @click="$router.back()">

    Back

  </button>

</template>
```

If you have a `app/pages/` directory, `useRouter` is identical in behavior to the one provided by `vue-router`.

Read `vue-router` documentation about the `Router` interface.

## Basic Manipulation

- [`addRoute()`](https://router.vuejs.org/api/interfaces/router#addRoute-): Add a new route to the router instance. `parentName` can be provided to add new route as the child of an existing route.
- [`removeRoute()`](https://router.vuejs.org/api/interfaces/router#removeRoute-): Remove an existing route by its name.
- [`getRoutes()`](https://router.vuejs.org/api/interfaces/router#getRoutes-): Get a full list of all the route records.
- [`hasRoute()`](https://router.vuejs.org/api/interfaces/router#hasRoute-): Checks if a route with a given name exists.
- [`resolve()`](https://router.vuejs.org/api/interfaces/router#resolve-): Returns the normalized version of a route location. Also includes an `href` property that includes any existing base.

Example

```ts
const router = useRouter()

router.addRoute({ name: 'home', path: '/home', component: Home })

router.removeRoute('home')

router.getRoutes()

router.hasRoute('home')

router.resolve({ name: 'home' })
```

`router.addRoute()` adds route details into an array of routes and it is useful while building [Nuxt plugins](https://nuxt.com/docs/4.x/directory-structure/app/plugins) while `router.push()` on the other hand, triggers a new navigation immediately and it is useful in pages, Vue components and composable.

## Based on History API

- [`back()`](https://router.vuejs.org/api/interfaces/router#back-): Go back in history if possible, same as `router.go(-1)`.
- [`forward()`](https://router.vuejs.org/api/interfaces/router#forward-): Go forward in history if possible, same as `router.go(1)`.
- [`go()`](https://router.vuejs.org/api/interfaces/router#go-): Move forward or backward through the history without the hierarchical restrictions enforced in `router.back()` and `router.forward()`.
- [`push()`](https://router.vuejs.org/api/interfaces/router#push-): Programmatically navigate to a new URL by pushing an entry in the history stack. **It is recommended to use [`navigateTo`](https://nuxt.com/docs/4.x/api/utils/navigate-to) instead.**
- [`replace()`](https://router.vuejs.org/api/interfaces/router#replace-): Programmatically navigate to a new URL by replacing the current entry in the routes history stack. **It is recommended to use [`navigateTo`](https://nuxt.com/docs/4.x/api/utils/navigate-to) instead.**

Example

```ts
const router = useRouter()

router.back()

router.forward()

router.go(3)

router.push({ path: '/home' })

router.replace({ hash: '#bio' })
```

Read more about the browser's History API.

## Navigation Guards

`useRouter` composable provides `afterEach`, `beforeEach` and `beforeResolve` helper methods that acts as navigation guards.

However, Nuxt has a concept of **route middleware** that simplifies the implementation of navigation guards and provides a better developer experience.

Read more in Docs > 4 X > Directory Structure > App > Middleware.

- [`isReady()`](https://router.vuejs.org/api/interfaces/router#isReady-): Returns a Promise that resolves when the router has completed the initial navigation.
- [`onError`](https://router.vuejs.org/api/interfaces/router#onError-): Adds an error handler that is called every time a non caught error happens during navigation.

Read more in Vue Router Docs.

## Universal Router Instance

If you do not have a `app/pages/` folder, then [`useRouter`](https://nuxt.com/docs/4.x/api/composables/use-router) will return a universal router instance with similar helper methods, but be aware that not all features may be supported or behave in exactly the same way as with `vue-router`.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/2.composables/use-router.md)[useRouteAnnouncer](https://nuxt.com/docs/4.x/api/composables/use-route-announcer)

[

This composable observes the page title changes and updates the announcer message accordingly.

](https://nuxt.com/docs/4.x/api/composables/use-route-announcer)[

useRuntimeConfig

Access runtime config variables with the useRuntimeConfig composable.

](https://nuxt.com/docs/4.x/api/composables/use-runtime-config)