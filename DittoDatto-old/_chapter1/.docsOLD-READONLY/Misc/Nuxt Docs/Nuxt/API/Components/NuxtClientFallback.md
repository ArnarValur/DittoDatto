---
title: "<NuxtClientFallback> · Nuxt Components v4"
source: "https://nuxt.com/docs/4.x/api/components/nuxt-client-fallback"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
Nuxt provides the `<NuxtClientFallback>` component to render its content on the client if any of its children trigger an error in SSR.

This component is experimental and in order to use it you must enable the `experimental.clientFallback` option in your `nuxt.config`.

app/pages/example.vue

```
<template>

  <div>

    <Sidebar />

    <!-- this component will be rendered on client-side -->

    <NuxtClientFallback fallback-tag="span">

      <Comments />

      <BrokeInSSR />

    </NuxtClientFallback>

  </div>

</template>
```

## Events

- `@ssr-error`: Event emitted when a child triggers an error in SSR. Note that this will only be triggered on the server.
	```
	<template>
	  <NuxtClientFallback @ssr-error="logSomeError">
	    <!-- ... -->
	  </NuxtClientFallback>
	</template>
	```

## Props

- `placeholderTag` | `fallbackTag`: Specify a fallback tag to be rendered if the slot fails to render on the server.
	- **type**: `string`
	- **default**: `div`
- `placeholder` | `fallback`: Specify fallback content to be rendered if the slot fails to render.
	- **type**: `string`
- `keepFallback`: Keep the fallback content if it failed to render server-side.
	- **type**: `boolean`
	- **default**: `false`

The `placeholder` and `fallback` props render content as raw HTML. Do not pass untrusted user input to these props as it may lead to XSS vulnerabilities. Use the `#fallback` or `#placeholder` slots instead for dynamic content that needs proper escaping.

```
<template>

  <!-- render <span>Hello world</span> server-side if the default slot fails to render -->

  <NuxtClientFallback

    fallback-tag="span"

    fallback="Hello world"

  >

    <BrokeInSSR />

  </NuxtClientFallback>

</template>
```

## Slots

- `#fallback`: specify content to be displayed server-side if the slot fails to render.

```
<template>

  <NuxtClientFallback>

    <!-- ... -->

    <template #fallback>

      <!-- this will be rendered on server side if the default slot fails to render in ssr -->

      <p>Hello world</p>

    </template>

  </NuxtClientFallback>

</template>
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/1.components/1.nuxt-client-fallback.md)[<DevOnly>](https://nuxt.com/docs/4.x/api/components/dev-only)

[

Render components only during development with the <DevOnly> component.

](https://nuxt.com/docs/4.x/api/components/dev-only)[

<NuxtPicture>

Nuxt provides a <NuxtPicture> component to handle automatic image optimization.

](https://nuxt.com/docs/4.x/api/components/nuxt-picture)