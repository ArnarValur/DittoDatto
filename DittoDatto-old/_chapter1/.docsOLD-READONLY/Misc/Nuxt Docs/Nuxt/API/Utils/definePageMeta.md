---
title: "definePageMeta · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/define-page-meta"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## definePageMeta

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/pages/runtime/composables.ts)

Define metadata for your page components.

`definePageMeta` is a compiler macro that you can use to set metadata for your **page** components located in the [`app/pages/`](https://nuxt.com/docs/4.x/directory-structure/app/pages) directory (unless [set otherwise](https://nuxt.com/docs/4.x/api/nuxt-config#pages)). This way you can set custom metadata for each static or dynamic route of your Nuxt application.

app/pages/some-page.vue

```
<script setup lang="ts">

definePageMeta({

  layout: 'default',

})

</script>
```

Read more in Docs > 4 X > Directory Structure > App > Pages#page Metadata.

## Type

Signature

```ts
export function definePageMeta (meta: PageMeta): void

interface PageMeta {

  validate?: ((route: RouteLocationNormalized) => boolean | Promise<boolean> | Partial<NuxtError> | Promise<Partial<NuxtError>>)

  redirect?: RouteRecordRedirectOption

  name?: string

  path?: string

  props?: RouteRecordRaw['props']

  alias?: string | string[]

  groups?: string[]

  pageTransition?: boolean | TransitionProps

  layoutTransition?: boolean | TransitionProps

  viewTransition?: boolean | 'always'

  key?: false | string | ((route: RouteLocationNormalizedLoaded) => string)

  keepalive?: boolean | KeepAliveProps

  layout?: false | LayoutKey | Ref<LayoutKey> | ComputedRef<LayoutKey>

  middleware?: MiddlewareKey | NavigationGuard | Array<MiddlewareKey | NavigationGuard>

  scrollToTop?: boolean | ((to: RouteLocationNormalizedLoaded, from: RouteLocationNormalizedLoaded) => boolean)

  [key: string]: unknown

}
```

## Parameters

### meta

- **Type**: `PageMeta`  
	An object accepting the following page metadata:  
	**`name`**
	- **Type**: `string`  
		You may define a name for this page's route. By default, name is generated based on path inside the [`app/pages/` directory](https://nuxt.com/docs/4.x/directory-structure/app/pages).
	  
	**`path`**
	- **Type**: `string`  
		You may define a [custom regular expression](https://nuxt.com/docs/4.x/api/utils/define-page-meta#using-a-custom-regular-expression) if you have a more complex pattern than can be expressed with the file name.
	  
	**`props`**
	- **Type**: [`RouteRecordRaw['props']`](https://router.vuejs.org/guide/essentials/passing-props)  
		Allows accessing the route `params` as props passed to the page component.
	  
	**`alias`**
	- **Type**: `string | string[]`  
		Aliases for the record. Allows defining extra paths that will behave like a copy of the record. Allows having paths shorthands like `/users/:id` and `/u/:id`. All `alias` and `path` values must share the same params.
	  
	**`groups`**
	- **Type**: `string[]`  
		Route groups the page belongs to, based on the folder structure. Automatically populated for pages within [route groups](https://nuxt.com/docs/4.x/guide/directory-structure/app/pages#route-groups).
	  
	**`keepalive`**
	- **Type**: `boolean` | [`KeepAliveProps`](https://vuejs.org/api/built-in-components#keepalive)  
		Set to `true` when you want to preserve page state across route changes or use the [`KeepAliveProps`](https://vuejs.org/api/built-in-components#keepalive) for a fine-grained control.
	  
	**`key`**
	- **Type**: `false` | `string` | `((route: RouteLocationNormalizedLoaded) => string)`  
		Set `key` value when you need more control over when the `<NuxtPage>` component is re-rendered.
	  
	**`layout`**
	- **Type**: `false` | `LayoutKey` | `Ref<LayoutKey>` | `ComputedRef<LayoutKey>`  
		Set a static or dynamic name of the layout for each route. This can be set to `false` in case the default layout needs to be disabled.
	  
	**`layoutTransition`**
	- **Type**: `boolean` | [`TransitionProps`](https://vuejs.org/api/built-in-components#transition)  
		Set name of the transition to apply for current layout. You can also set this value to `false` to disable the layout transition.
	  
	**`middleware`**
	- **Type**: `MiddlewareKey` | [`NavigationGuard`](https://router.vuejs.org/api/interfaces/navigationguard) | `Array<MiddlewareKey | NavigationGuard>`  
		Define anonymous or named middleware directly within `definePageMeta`. Learn more about [route middleware](https://nuxt.com/docs/4.x/directory-structure/app/middleware).
	  
	**`pageTransition`**
	- **Type**: `boolean` | [`TransitionProps`](https://vuejs.org/api/built-in-components#transition)  
		Set name of the transition to apply for current page. You can also set this value to `false` to disable the page transition.
	  
	**`viewTransition`**
	- **Type**: `boolean | 'always'`  
		**Experimental feature, only available when [enabled in your nuxt.config file](https://nuxt.com/docs/4.x/getting-started/transitions#view-transitions-api-experimental)**  
		Enable/disable View Transitions for the current page. If set to true, Nuxt will not apply the transition if the users browser matches `prefers-reduced-motion: reduce` (recommended). If set to `always`, Nuxt will always apply the transition.
	  
	**`redirect`**
	- **Type**: [`RouteRecordRedirectOption`](https://router.vuejs.org/guide/essentials/redirect-and-alias)  
		Where to redirect if the route is directly matched. The redirection happens before any navigation guard and triggers a new navigation with the new target location.
	  
	**`validate`**
	- **Type**: `(route: RouteLocationNormalized) => boolean | Promise<boolean> | Partial<NuxtError> | Promise<Partial<NuxtError>>`  
		Validate whether a given route can validly be rendered with this page. Return true if it is valid, or false if not. If another match can't be found, this will mean a 404. You can also directly return an object with `status` / `statusText` to respond immediately with an error (other matches will not be checked).
	  
	**`scrollToTop`**
	- **Type**: `boolean | (to: RouteLocationNormalized, from: RouteLocationNormalized) => boolean`  
		Tell Nuxt to scroll to the top before rendering the page or not. If you want to overwrite the default scroll behavior of Nuxt, you can do so in `~/router.options.ts` (see [custom routing](https://nuxt.com/docs/4.x/guide/recipes/custom-routing#using-routeroptions)) for more info.
	  
	**`[key: string]`**
	- **Type**: `any`  
		Apart from the above properties, you can also set **custom** metadata. You may wish to do so in a type-safe way by [augmenting the type of the `meta` object](https://nuxt.com/docs/4.x/directory-structure/app/pages/#typing-custom-metadata).

## Examples

### Basic Usage

The example below demonstrates:

- how `key` can be a function that returns a value;
- how `keepalive` property makes sure that the `<modal>` component is not cached when switching between multiple components;
- adding `pageType` as a custom property:

app/pages/some-page.vue

```
<script setup lang="ts">

definePageMeta({

  key: route => route.fullPath,

  keepalive: {

    exclude: ['modal'],

  },

  pageType: 'Checkout',

})

</script>
```

### Defining Middleware

The example below shows how the middleware can be defined using a `function` directly within the `definePageMeta` or set as a `string` that matches the middleware file name located in the `app/middleware/` directory:

app/pages/some-page.vue

```
<script setup lang="ts">

definePageMeta({

  // define middleware as a function

  middleware: [

    function (to, from) {

      const auth = useState('auth')

      if (!auth.value.authenticated) {

        return navigateTo('/login')

      }

      if (to.path !== '/checkout') {

        return navigateTo('/checkout')

      }

    },

  ],

  // ... or a string

  middleware: 'auth',

  // ... or multiple strings

  middleware: ['auth', 'another-named-middleware'],

})

</script>
```

### Using a Custom Regular Expression

A custom regular expression is a good way to resolve conflicts between overlapping routes, for instance:

The two routes "/test-category" and "/1234-post" match both `[postId]-[postSlug].vue` and `[categorySlug].vue` page routes.

To make sure that we are only matching digits (`\d+`) for `postId` in the `[postId]-[postSlug]` route, we can add the following to the `[postId]-[postSlug].vue` page template:

app/pages/\[postId\]-\[postSlug\].vue

```
<script setup lang="ts">

definePageMeta({

  path: '/:postId(\\d+)-:postSlug',

})

</script>
```

For more examples see [Vue Router's Matching Syntax](https://router.vuejs.org/guide/essentials/route-matching-syntax).

### Defining Layout

You can define the layout that matches the layout's file name located (by default) in the [`app/layouts/` directory](https://nuxt.com/docs/4.x/directory-structure/app/layouts). You can also disable the layout by setting the `layout` to `false`:

app/pages/some-page.vue

```
<script setup lang="ts">

definePageMeta({

  // set custom layout

  layout: 'admin',

  // ... or disable a default layout

  layout: false,

})

</script>
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/3.utils/define-page-meta.md)[defineNuxtRouteMiddleware](https://nuxt.com/docs/4.x/api/utils/define-nuxt-route-middleware)

[

Create named route middleware using defineNuxtRouteMiddleware helper function.

](https://nuxt.com/docs/4.x/api/utils/define-nuxt-route-middleware)[

defineRouteRules

Define route rules for hybrid rendering at the page level.

](https://nuxt.com/docs/4.x/api/utils/define-route-rules)