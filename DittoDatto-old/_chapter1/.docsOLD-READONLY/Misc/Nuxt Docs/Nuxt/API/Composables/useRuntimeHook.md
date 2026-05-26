---
title: "useRuntimeHook · Nuxt Composables v4"
source: "https://nuxt.com/docs/4.x/api/composables/use-runtime-hook"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
This composable is available in Nuxt v3.14+.

signature

```ts
function useRuntimeHook<THookName extends keyof RuntimeNuxtHooks> (

  name: THookName,

  fn: RuntimeNuxtHooks[THookName] extends HookCallback ? RuntimeNuxtHooks[THookName] : never,

): void
```

## Usage

### Parameters

- `name`: The name of the runtime hook to register. You can see the full list of [runtime Nuxt hooks here](https://nuxt.com/docs/4.x/api/advanced/hooks#app-hooks-runtime).
- `fn`: The callback function to execute when the hook is triggered. The function signature varies based on the hook name.

### Returns

The composable doesn't return a value, but it automatically unregisters the hook when the component's scope is destroyed.

## Example

pages/index.vue

```ts
<script setup lang="ts">

// Register a hook that runs every time a link is prefetched, but which will be

// automatically cleaned up (and not called again) when the component is unmounted

useRuntimeHook('link:prefetch', (link) => {

  console.log('Prefetching', link)

})

</script>
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/2.composables/use-runtime-hook.md)[useRuntimeConfig](https://nuxt.com/docs/4.x/api/composables/use-runtime-config)

[

Access runtime config variables with the useRuntimeConfig composable.

](https://nuxt.com/docs/4.x/api/composables/use-runtime-config)[

useSeoMeta

The useSeoMeta composable lets you define your site's SEO meta tags as a flat object with full TypeScript support.

](https://nuxt.com/docs/4.x/api/composables/use-seo-meta)