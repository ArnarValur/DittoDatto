---
title: "middleware · Nuxt Directory Structure v4"
source: "https://nuxt.com/docs/4.x/directory-structure/app/middleware"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
Nuxt provides a customizable **route middleware** framework you can use throughout your application, ideal for extracting code that you want to run before navigating to a particular route.

There are three kinds of route middleware:

1. Anonymous (or inline) route middleware are defined directly within the page.
2. Named route middleware, placed in the `app/middleware/` and automatically loaded via asynchronous import when used on a page.
3. Global route middleware, placed in the `app/middleware/` with a `.global` suffix and is run on every route change.

The first two kinds of route middleware can be defined in [`definePageMeta`](https://nuxt.com/docs/4.x/api/utils/define-page-meta).

Name of middleware are normalized to kebab-case: `myMiddleware` becomes `my-middleware`.

Route middleware run within the Vue part of your Nuxt app. Despite the similar name, they are completely different from [server middleware](https://nuxt.com/docs/4.x/directory-structure/server#server-middleware), which are run in the Nitro server part of your app.

## Usage

Route middleware are navigation guards that receive the current route and the next route as arguments.

middleware/my-middleware.ts

```ts
export default defineNuxtRouteMiddleware((to, from) => {

  if (to.params.id === '1') {

    return abortNavigation()

  }

  // In a real app you would probably not redirect every route to \`/\`

  // however it is important to check \`to.path\` before redirecting or you

  // might get an infinite redirect loop

  if (to.path !== '/') {

    return navigateTo('/')

  }

})
```

Nuxt provides two globally available helpers that can be returned directly from the middleware.

1. [`navigateTo`](https://nuxt.com/docs/4.x/api/utils/navigate-to) - Redirects to the given route
2. [`abortNavigation`](https://nuxt.com/docs/4.x/api/utils/abort-navigation) - Aborts the navigation, with an optional error message.

Unlike [navigation guards](https://router.vuejs.org/guide/advanced/navigation-guards#Global-Before-Guards) from `vue-router`, a third `next()` argument is not passed, and **redirect or route cancellation is handled by returning a value from the middleware**.

Possible return values are:

- nothing (a simple `return` or no return at all) - does not block navigation and will move to the next middleware function, if any, or complete the route navigation
- `return navigateTo('/')` - redirects to the given path and will set the redirect code to [`302` Found](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/302) if the redirect happens on the server side
- `return navigateTo('/', { redirectCode: 301 })` - redirects to the given path and will set the redirect code to [`301` Moved Permanently](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/301) if the redirect happens on the server side
- `return abortNavigation()` - stops the current navigation
- `return abortNavigation(error)` - rejects the current navigation with an error

Read more in Docs > 4 X > API > Utils > Navigate To.

Read more in Docs > 4 X > API > Utils > Abort Navigation.

We recommend using the helper functions above for performing redirects or stopping navigation. Other possible return values described in [the vue-router docs](https://router.vuejs.org/guide/advanced/navigation-guards#Global-Before-Guards) may work but there may be breaking changes in future.

## Middleware Order

Middleware runs in the following order:

1. Global Middleware
2. Page defined middleware order (if there are multiple middleware declared with the array syntax)

For example, assuming you have the following middleware and component:

app/middleware/ directory

```bash
-| middleware/

---| analytics.global.ts

---| setup.global.ts

---| auth.ts
```

pages/profile.vue

```
<script setup lang="ts">

definePageMeta({

  middleware: [

    function (to, from) {

      // Custom inline middleware

    },

    'auth',

  ],

})

</script>
```

You can expect the middleware to be run in the following order:

1. `analytics.global.ts`
2. `setup.global.ts`
3. Custom inline middleware
4. `auth.ts`

### Ordering Global Middleware

By default, global middleware is executed alphabetically based on the filename.

However, there may be times you want to define a specific order. For example, in the last scenario, `setup.global.ts` may need to run before `analytics.global.ts`. In that case, we recommend prefixing global middleware with 'alphabetical' numbering.

Directory structure

```bash
-| middleware/

---| 01.setup.global.ts

---| 02.analytics.global.ts

---| auth.ts
```

In case you're new to 'alphabetical' numbering, remember that filenames are sorted as strings, not as numeric values. For example, `10.new.global.ts` would come before `2.new.global.ts`. This is why the example prefixes single digit numbers with `0`.

## When Middleware Runs

If your site is server-rendered or generated, middleware for the initial page will be executed both when the page is rendered and then again on the client. This might be needed if your middleware needs a browser environment, such as if you have a generated site, aggressively cache responses, or want to read a value from local storage.

However, if you want to avoid this behaviour you can do so:

middleware/example.ts

```ts
export default defineNuxtRouteMiddleware((to) => {

  // skip middleware on server

  if (import.meta.server) {

    return

  }

  // skip middleware on client side entirely

  if (import.meta.client) {

    return

  }

  // or only skip middleware on initial client load

  const nuxtApp = useNuxtApp()

  if (import.meta.client && nuxtApp.isHydrating && nuxtApp.payload.serverRendered) {

    return

  }

})
```

This is true even if you throw an error in your middleware on the server, and an error page is rendered. The middleware will still run again in the browser.

Rendering an error page is an entirely separate page load, meaning any registered middleware will run again. You can use [`useError`](https://nuxt.com/docs/4.x/getting-started/error-handling#useerror) in middleware to check if an error is being handled.

## Accessing Route in Middleware

Always use the `to` and `from` parameters in your middleware to access the next and previous routes. Avoid using the [`useRoute()`](https://nuxt.com/docs/4.x/api/composables/use-route) composable in this context altogether. There is **no concept of a "current route" in middleware**, as middleware can abort a navigation or redirect to a different route. The `useRoute()` composable will always be inaccurate in this context.

Sometimes, you might call a composable that uses `useRoute()` internally, which can trigger this warning even if there is no direct call in your middleware. This leads to the **same issue as above**, so you should structure your functions to accept the route as an argument instead when they are used in middleware.

## Adding Middleware Dynamically

It is possible to add global or named route middleware manually using the [`addRouteMiddleware()`](https://nuxt.com/docs/4.x/api/utils/add-route-middleware) helper function, such as from within a plugin.

```ts
export default defineNuxtPlugin(() => {

  addRouteMiddleware('global-test', () => {

    console.log('this global middleware was added in a plugin and will be run on every route change')

  }, { global: true })

  addRouteMiddleware('named-test', () => {

    console.log('this named middleware was added in a plugin and would override any existing middleware of the same name')

  })

})
```

## Example

Directory Structure

```bash
-| middleware/

---| auth.ts
```

In your page file, you can reference this route middleware:

```
<script setup lang="ts">

definePageMeta({

  middleware: ['auth'],

  // or middleware: 'auth'

})

</script>
```

Now, before navigation to that page can complete, the `auth` route middleware will be run.

Read and edit a live example in [Docs > 4 X > Examples > Routing > Middleware](https://nuxt.com/docs/4.x/examples/routing/middleware).

## Setting Middleware at Build Time

Instead of using `definePageMeta` on each page, you can add named route middleware within the `pages:extend` hook.

nuxt.config.ts

```ts
import type { NuxtPage } from 'nuxt/schema'

export default defineNuxtConfig({

  hooks: {

    'pages:extend' (pages) {

      function setMiddleware (pages: NuxtPage[]) {

        for (const page of pages) {

          if (/* some condition */ Math.random() > 0.5) {

            page.meta ||= {}

            // Note that this will override any middleware set in \`definePageMeta\` in the page

            page.meta.middleware = ['named']

          }

          if (page.children) {

            setMiddleware(page.children)

          }

        }

      }

      setMiddleware(pages)

    },

  },

})
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/2.directory-structure/1.app/1.middleware.md)[layouts](https://nuxt.com/docs/4.x/directory-structure/app/layouts)

[

Nuxt provides a layouts framework to extract common UI patterns into reusable layouts.

](https://nuxt.com/docs/4.x/directory-structure/app/layouts)[

pages

Nuxt provides file-based routing to create routes within your web application.

](https://nuxt.com/docs/4.x/directory-structure/app/pages)