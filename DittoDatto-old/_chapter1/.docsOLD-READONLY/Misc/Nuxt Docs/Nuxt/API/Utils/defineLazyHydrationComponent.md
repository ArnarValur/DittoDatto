---
title: "defineLazyHydrationComponent · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/define-lazy-hydration-component"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## defineLazyHydrationComponent

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/components/plugins/lazy-hydration-macro-transform.ts)

Define a lazy hydration component with a specific strategy.

`defineLazyHydrationComponent` is a compiler macro that helps you create a component with a specific lazy hydration strategy. Lazy hydration defers hydration until components become visible or until the browser has completed more critical tasks. This can significantly reduce the initial performance cost, especially for non-essential components.

## Usage

### Visibility Strategy

Hydrates the component when it becomes visible in the viewport.

```
<script setup lang="ts">

const LazyHydrationMyComponent = defineLazyHydrationComponent(

  'visible',

  () => import('./components/MyComponent.vue'),

)

</script>

<template>

  <div>

    <!--

      Hydration will be triggered when

      the element(s) is 100px away from entering the viewport.

    -->

    <LazyHydrationMyComponent :hydrate-on-visible="{ rootMargin: '100px' }" />

  </div>

</template>
```

The `hydrateOnVisible` prop is optional. You can pass an object to customize the behavior of the `IntersectionObserver` under the hood.

Read more about the options for `hydrate-on-visible`.

Under the hood, this uses Vue's built-in [`hydrateOnVisible` strategy](https://vuejs.org/guide/components/async#hydrate-on-visible).

### Idle Strategy

Hydrates the component when the browser is idle. This is suitable if you need the component to load as soon as possible, but not block the critical rendering path.

```
<script setup lang="ts">

const LazyHydrationMyComponent = defineLazyHydrationComponent(

  'idle',

  () => import('./components/MyComponent.vue'),

)

</script>

<template>

  <div>

    <!-- Hydration will be triggered when the browser is idle or after 2000ms. -->

    <LazyHydrationMyComponent :hydrate-on-idle="2000" />

  </div>

</template>
```

The `hydrateOnIdle` prop is optional. You can pass a positive number to specify the maximum timeout.

Idle strategy is for components that can be hydrated when the browser is idle.

Under the hood, this uses Vue's built-in [`hydrateOnIdle` strategy](https://vuejs.org/guide/components/async#hydrate-on-idle).

Hydrates the component after a specified interaction (e.g., click, mouseover).

```
<script setup lang="ts">

const LazyHydrationMyComponent = defineLazyHydrationComponent(

  'interaction',

  () => import('./components/MyComponent.vue'),

)

</script>

<template>

  <div>

    <!--

      Hydration will be triggered when

      the element(s) is hovered over by the pointer.

    -->

    <LazyHydrationMyComponent hydrate-on-interaction="mouseover" />

  </div>

</template>
```

The `hydrateOnInteraction` prop is optional. If you do not pass an event or a list of events, it defaults to hydrating on `pointerenter`, `click`, and `focus`.

Under the hood, this uses Vue's built-in [`hydrateOnInteraction` strategy](https://vuejs.org/guide/components/async#hydrate-on-interaction).

### Media Query Strategy

Hydrates the component when the window matches a media query.

```
<script setup lang="ts">

const LazyHydrationMyComponent = defineLazyHydrationComponent(

  'mediaQuery',

  () => import('./components/MyComponent.vue'),

)

</script>

<template>

  <div>

    <!--

      Hydration will be triggered when

      the window width is greater than or equal to 768px.

    -->

    <LazyHydrationMyComponent hydrate-on-media-query="(min-width: 768px)" />

  </div>

</template>
```

Under the hood, this uses Vue's built-in [`hydrateOnMediaQuery` strategy](https://vuejs.org/guide/components/async#hydrate-on-media-query).

### Time Strategy

Hydrates the component after a specified delay (in milliseconds).

```
<script setup lang="ts">

const LazyHydrationMyComponent = defineLazyHydrationComponent(

  'time',

  () => import('./components/MyComponent.vue'),

)

</script>

<template>

  <div>

    <!-- Hydration is triggered after 1000ms. -->

    <LazyHydrationMyComponent :hydrate-after="1000" />

  </div>

</template>
```

Time strategy is for components that can wait a specific amount of time.

### If Strategy

Hydrates the component based on a boolean condition.

```
<script setup lang="ts">

const LazyHydrationMyComponent = defineLazyHydrationComponent(

  'if',

  () => import('./components/MyComponent.vue'),

)

const isReady = ref(false)

function myFunction () {

  // Trigger custom hydration strategy...

  isReady.value = true

}

</script>

<template>

  <div>

    <!-- Hydration is triggered when isReady becomes true. -->

    <LazyHydrationMyComponent :hydrate-when="isReady" />

  </div>

</template>
```

If strategy is best for components that might not always need to be hydrated.

### Never Hydrate

Never hydrates the component.

```
<script setup lang="ts">

const LazyHydrationMyComponent = defineLazyHydrationComponent(

  'never',

  () => import('./components/MyComponent.vue'),

)

</script>

<template>

  <div>

    <!-- This component will never be hydrated by Vue. -->

    <LazyHydrationMyComponent />

  </div>

</template>
```

### Listening to Hydration Events

All delayed hydration components emit a `@hydrated` event when they are hydrated.

```
<script setup lang="ts">

const LazyHydrationMyComponent = defineLazyHydrationComponent(

  'visible',

  () => import('./components/MyComponent.vue'),

)

function onHydrate () {

  console.log('Component has been hydrated!')

}

</script>

<template>

  <div>

    <LazyHydrationMyComponent

      :hydrate-on-visible="{ rootMargin: '100px' }"

      @hydrated="onHydrated"

    />

  </div>

</template>
```

## Parameters

To ensure that the compiler correctly recognizes this macro, avoid using external variables. The following approach will prevent the macro from being properly recognized:

```
<script setup lang="ts">

const strategy = 'visible'

const source = () => import('./components/MyComponent.vue')

const LazyHydrationMyComponent = defineLazyHydrationComponent(strategy, source)

</script>
```

### strategy

- **Type**: `'visible' | 'idle' | 'interaction' | 'mediaQuery' | 'if' | 'time' | 'never'`
- **Required**: `true`

| Strategy | Description |
| --- | --- |
| `visible` | Hydrates when the component becomes visible in the viewport. |
| `idle` | Hydrates when the browser is idle or after a delay. |
| `interaction` | Hydrates upon user interaction (e.g., click, hover). |
| `mediaQuery` | Hydrates when the specified media query condition is met. |
| `if` | Hydrates when a specified boolean condition is met. |
| `time` | Hydrates after a specified time delay. |
| `never` | Prevents Vue from hydrating the component. |

### source

- **Type**: `() => Promise<Component>`
- **Required**: `true`

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/3.utils/define-lazy-hydration-component.md)[createError](https://nuxt.com/docs/4.x/api/utils/create-error)

[

Create an error object with additional metadata.

](https://nuxt.com/docs/4.x/api/utils/create-error)[

defineNuxtComponent

defineNuxtComponent() is a helper function for defining type safe components with Options API.

](https://nuxt.com/docs/4.x/api/utils/define-nuxt-component)