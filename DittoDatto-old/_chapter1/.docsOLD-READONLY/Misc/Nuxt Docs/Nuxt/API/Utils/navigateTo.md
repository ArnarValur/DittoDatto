---
title: "navigateTo · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/navigate-to"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## Usage

`navigateTo` is available on both server side and client side. It can be used within the [Nuxt context](https://nuxt.com/docs/4.x/guide/going-further/nuxt-app#the-nuxt-context), or directly, to perform page navigation.

Make sure to always use `await` or `return` on result of `navigateTo` when calling it.

`navigateTo` cannot be used within Nitro routes. To perform a server-side redirect in Nitro routes, use [`sendRedirect`](https://h3.dev/utils/response#redirectlocation-status-statustext) instead.

### Within a Vue Component

### Within Route Middleware

When using `navigateTo` within route middleware, you must **return its result** to ensure the middleware execution flow works correctly.

For example, the following implementation **will not work as expected**:

In this case, `navigateTo` will be executed but not returned, which may lead to unexpected behavior.

Read more in Docs > 4 X > Directory Structure > App > Middleware.

### Navigating to an External URL

The `external` parameter in `navigateTo` influences how navigating to URLs is handled:

- **Without `external: true`**:
	- Internal URLs navigate as expected.
	- External URLs throw an error.
- **With `external: true`**:
	- Internal URLs navigate with a full-page reload.
	- External URLs navigate as expected.

#### Example

### Opening a Page in a New Tab

## Type

Signature

```ts
export function navigateTo (

  to: RouteLocationRaw | undefined | null,

  options?: NavigateToOptions,

): Promise<void | NavigationFailure | false> | false | void | RouteLocationRaw

interface NavigateToOptions {

  replace?: boolean

  redirectCode?: number

  external?: boolean

  open?: OpenOptions

}

type OpenOptions = {

  target: string

  windowFeatures?: OpenWindowFeatures

}

type OpenWindowFeatures = {

  popup?: boolean

  noopener?: boolean

  noreferrer?: boolean

} & XOR<{ width?: number }, { innerWidth?: number }>

  & XOR<{ height?: number }, { innerHeight?: number }>

  & XOR<{ left?: number }, { screenX?: number }>

  & XOR<{ top?: number }, { screenY?: number }>
```

## Parameters

### to

**Type**: [`RouteLocationRaw`](https://router.vuejs.org/api/interfaces/routelocationoptions) | `undefined` | `null`

**Default**: `'/'`

`to` can be a plain string or a route object to redirect to. When passed as `undefined` or `null`, it will default to `'/'`.

#### Example

### options (optional)

**Type**: `NavigateToOptions`

An object accepting the following properties:

- `replace`
	- **Type**: `boolean`
	- **Default**: `false`
	- By default, `navigateTo` pushes the given route into the Vue Router's instance on the client side.  
		This behavior can be changed by setting `replace` to `true`, to indicate that given route should be replaced.
- `redirectCode`
	- **Type**: `number`
	- **Default**: `302`
	- `navigateTo` redirects to the given path and sets the redirect code to [`302 Found`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/302) by default when the redirection takes place on the server side.  
		This default behavior can be modified by providing different `redirectCode`. Commonly, [`301 Moved Permanently`](https://developer.mozilla.org/en-US/docs/Web/HTTP/Reference/Status/301) can be used for permanent redirections.
- `external`
	- **Type**: `boolean`
	- **Default**: `false`
	- Allows navigating to an external URL when set to `true`. Otherwise, `navigateTo` will throw an error, as external navigation is not allowed by default.
- `open`
	- **Type**: `OpenOptions`
	- Allows navigating to the URL using the [open()](https://developer.mozilla.org/en-US/docs/Web/API/Window/open) method of the window. This option is only applicable on the client side and will be ignored on the server side.  
		An object accepting the following properties:
	- `target`
		- **Type**: `string`
		- **Default**: `'_blank'`
		- A string, without whitespace, specifying the name of the browsing context the resource is being loaded into.
	- `windowFeatures`
		- **Type**: `OpenWindowFeatures`
		- An object accepting the following properties:  
			Refer to the [documentation](https://developer.mozilla.org/en-US/docs/Web/API/Window/open#windowfeatures) for more detailed information on the **windowFeatures** properties.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/3.utils/navigate-to.md)