---
title: "addRouteMiddleware · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/add-route-middleware"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
Route middleware are navigation guards stored in the [`app/middleware/`](https://nuxt.com/docs/4.x/directory-structure/app/middleware) directory of your Nuxt application (unless [set otherwise](https://nuxt.com/docs/4.x/api/nuxt-config#middleware)).

## Type

```ts
function addRouteMiddleware (name: string, middleware: RouteMiddleware, options?: AddRouteMiddlewareOptions): void

function addRouteMiddleware (middleware: RouteMiddleware): void

interface AddRouteMiddlewareOptions {

  global?: boolean

}
```

## Parameters

### name

- **Type:**`string` | `RouteMiddleware`

Can be either a string or a function of type `RouteMiddleware`. Function takes the next route `to` as the first argument and the current route `from` as the second argument, both of which are Vue route objects.

Learn more about available properties of [route objects](https://nuxt.com/docs/4.x/api/composables/use-route).

### middleware

- **Type:**`RouteMiddleware`

The second argument is a function of type `RouteMiddleware`. Same as above, it provides `to` and `from` route objects. It becomes optional if the first argument in `addRouteMiddleware()` is already passed as a function.

### options

- **Type:**`AddRouteMiddlewareOptions`

An optional `options` argument lets you set the value of `global` to `true` to indicate whether the router middleware is global or not (set to `false` by default).

## Examples

### Named Route Middleware

Named route middleware is defined by providing a string as the first argument and a function as the second:

app/plugins/my-plugin.ts

```ts
export default defineNuxtPlugin(() => {

  addRouteMiddleware('named-middleware', () => {

    console.log('named middleware added in Nuxt plugin')

  })

})
```

When defined in a plugin, it overrides any existing middleware of the same name located in the `app/middleware/` directory.

### Global Route Middleware

Global route middleware can be defined in two ways:

- Pass a function directly as the first argument without a name. It will automatically be treated as global middleware and applied on every route change.
	app/plugins/my-plugin.ts
	```ts
	export default defineNuxtPlugin(() => {
	  addRouteMiddleware((to, from) => {
	    console.log('anonymous global middleware that runs on every route change')
	  })
	})
	```
- Set an optional, third argument `{ global: true }` to indicate whether the route middleware is global.
	app/plugins/my-plugin.ts
	```ts
	export default defineNuxtPlugin(() => {
	  addRouteMiddleware('global-middleware', (to, from) => {
	    console.log('global middleware that runs on every route change')
	  },
	  { global: true },
	  )
	})
	```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/3.utils/add-route-middleware.md)[abortNavigation](https://nuxt.com/docs/4.x/api/utils/abort-navigation)

[

abortNavigation is a helper function that prevents navigation from taking place and throws an error if one is set as a parameter.

](https://nuxt.com/docs/4.x/api/utils/abort-navigation)[

callOnce

Run a given function or block of code once during SSR or CSR.

](https://nuxt.com/docs/4.x/api/utils/call-once)