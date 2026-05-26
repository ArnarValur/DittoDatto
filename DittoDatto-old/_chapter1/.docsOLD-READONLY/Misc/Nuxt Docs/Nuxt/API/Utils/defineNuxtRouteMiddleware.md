---
title: "defineNuxtRouteMiddleware · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/define-nuxt-route-middleware"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## defineNuxtRouteMiddleware

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/composables/router.ts)

Create named route middleware using defineNuxtRouteMiddleware helper function.

Route middleware are stored in the [`app/middleware/`](https://nuxt.com/docs/4.x/directory-structure/app/middleware) of your Nuxt application (unless [set otherwise](https://nuxt.com/docs/4.x/api/nuxt-config#middleware)).

## Type

Signature

```ts
export function defineNuxtRouteMiddleware (middleware: RouteMiddleware): RouteMiddleware

interface RouteMiddleware {

  (to: RouteLocationNormalized, from: RouteLocationNormalized): ReturnType<NavigationGuard>

}
```

## Parameters

### middleware

- **Type**: `RouteMiddleware`

A function that takes two Vue Router's route location objects as parameters: the next route `to` as the first, and the current route `from` as the second.

Learn more about available properties of `RouteLocationNormalized` in the **[Vue Router docs](https://router.vuejs.org/api/type-aliases/routelocationnormalized)**.

## Examples

You can use route middleware to throw errors and show helpful error messages:

app/middleware/error.ts

```ts
export default defineNuxtRouteMiddleware((to) => {

  if (to.params.id === '1') {

    throw createError({ status: 404, statusText: 'Page Not Found' })

  }

})
```

The above route middleware will redirect a user to the custom error page defined in the `~/error.vue` file, and expose the error message and code passed from the middleware.

### Redirection

Use [`useState`](https://nuxt.com/docs/4.x/api/composables/use-state) in combination with `navigateTo` helper function inside the route middleware to redirect users to different routes based on their authentication status:

app/middleware/auth.ts

```ts
export default defineNuxtRouteMiddleware((to, from) => {

  const auth = useState('auth')

  if (!auth.value.isAuthenticated) {

    return navigateTo('/login')

  }

  if (to.path !== '/dashboard') {

    return navigateTo('/dashboard')

  }

})
```

Both [navigateTo](https://nuxt.com/docs/4.x/api/utils/navigate-to) and [abortNavigation](https://nuxt.com/docs/4.x/api/utils/abort-navigation) are globally available helper functions that you can use inside `defineNuxtRouteMiddleware`.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/3.utils/define-nuxt-route-middleware.md)[defineNuxtPlugin](https://nuxt.com/docs/4.x/api/utils/define-nuxt-plugin)

[

defineNuxtPlugin() is a helper function for creating Nuxt plugins.

](https://nuxt.com/docs/4.x/api/utils/define-nuxt-plugin)[

definePageMeta

Define metadata for your page components.

](https://nuxt.com/docs/4.x/api/utils/define-page-meta)