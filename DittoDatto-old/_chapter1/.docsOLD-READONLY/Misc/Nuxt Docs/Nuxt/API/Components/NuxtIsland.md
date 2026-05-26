---
title: "<NuxtIsland> · Nuxt Components v4"
source: "https://nuxt.com/docs/4.x/api/components/nuxt-island"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## <NuxtIsland>

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/components/nuxt-island.ts)

Nuxt provides the <NuxtIsland> component to render a non-interactive component without any client JS.

When rendering an island component, the content of the island component is static, thus no JS is downloaded client-side.

Changing the island component props triggers a refetch of the island component to re-render it again.

Global styles of your application are sent with the response.

Server only components use `<NuxtIsland>` under the hood

## Props

- `name`: Name of the component to render.
	- **type**: `string`
	- **required**
- `lazy`: Make the component non-blocking.
	- **type**: `boolean`
	- **default**: `false`
- `props`: Props to send to the component to render.
	- **type**: `Record<string, any>`
- `source`: Remote source to call the island to render.
	- **type**: `string`
- **dangerouslyLoadClientComponents**: Required to load client components from a remote source.
	- **type**: `boolean`
	- **default**: `false`

Remote islands need `experimental.componentIslands` to be `'local+remote'` in your `nuxt.config`.

Using the `source` prop to render content from a remote server is inherently dangerous. When you specify a remote `source`, you are fully trusting that server to provide safe HTML content that will be rendered directly in your application.This is similar to using `v-html` with external content - the remote server can inject any HTML, including potentially malicious content. **Only use `source` with servers you fully trust and control.**The `dangerouslyLoadClientComponents` prop controls an additional layer of risk: whether to also download and execute client components from the remote source. Even with `dangerouslyLoadClientComponents` disabled (the default), you are still trusting the remote server's HTML output.

By default, component islands are scanned from the `~/components/islands/` directory. So the `~/components/islands/MyIsland.vue` component could be rendered with `<NuxtIsland name="MyIsland" />`.

## Slots

Slots can be passed to an island component if declared.

Every slot is interactive since the parent component is the one providing it.

Some slots are reserved to `NuxtIsland` for special cases.

- `#fallback`: Specify the content to be rendered before the island loads (if the component is lazy) or if `NuxtIsland` fails to fetch the component.

## Ref

- `refresh()`
	- **type**: `() => Promise<void>`
	- **description**: force refetch the server component by refetching it.

## Events

- `error`
	- **parameters**:
		- **error**:
			- **type**: `unknown`
	- **description**: emitted when when `NuxtIsland` fails to fetch the new island.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/1.components/8.nuxt-island.md)[<NuxtWelcome>](https://nuxt.com/docs/4.x/api/components/nuxt-welcome)

[

The <NuxtWelcome> component greets users in new projects made from the starter template.

](https://nuxt.com/docs/4.x/api/components/nuxt-welcome)[

<NuxtImg>

Nuxt provides a <NuxtImg> component to handle automatic image optimization.

](https://nuxt.com/docs/4.x/api/components/nuxt-img)