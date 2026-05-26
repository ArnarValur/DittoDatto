---
title: "abortNavigation · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/abort-navigation"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
`abortNavigation` is only usable inside a [route middleware handler](https://nuxt.com/docs/4.x/directory-structure/app/middleware).

## Type

Signature

```ts
export function abortNavigation (err?: Error | string): false
```

## Parameters

### err

- **Type**: [`Error`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error) | `string`  
	Optional error to be thrown by `abortNavigation`.

## Examples

The example below shows how you can use `abortNavigation` in a route middleware to prevent unauthorized route access:

app/middleware/auth.ts

```ts
export default defineNuxtRouteMiddleware((to, from) => {

  const user = useState('user')

  if (!user.value.isAuthorized) {

    return abortNavigation()

  }

  if (to.path !== '/edit-post') {

    return navigateTo('/edit-post')

  }

})
```

### err as a String

You can pass the error as a string:

app/middleware/auth.ts

```ts
export default defineNuxtRouteMiddleware((to, from) => {

  const user = useState('user')

  if (!user.value.isAuthorized) {

    return abortNavigation('Insufficient permissions.')

  }

})
```

### err as an Error Object

You can pass the error as an [`Error`](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Global_Objects/Error) object, e.g. caught by the `catch` -block:

app/middleware/auth.ts

```ts
export default defineNuxtRouteMiddleware((to, from) => {

  try {

    /* code that might throw an error */

  } catch (err) {

    return abortNavigation(err)

  }

})
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/3.utils/abort-navigation.md)[$fetch](https://nuxt.com/docs/4.x/api/utils/dollarfetch)

[

Nuxt uses ofetch to expose globally the $fetch helper for making HTTP requests.

](https://nuxt.com/docs/4.x/api/utils/dollarfetch)[

addRouteMiddleware

addRouteMiddleware() is a helper function to dynamically add middleware in your application.

](https://nuxt.com/docs/4.x/api/utils/add-route-middleware)