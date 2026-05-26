---
title: "<NuxtRouteAnnouncer> · Nuxt Components v4"
source: "https://nuxt.com/docs/4.x/api/components/nuxt-route-announcer"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## <NuxtRouteAnnouncer>

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/components/nuxt-route-announcer.ts)

The <NuxtRouteAnnouncer> component adds a hidden element with the page title to announce route changes to assistive technologies.

This component is available in Nuxt v3.12+.

## Usage

Add `<NuxtRouteAnnouncer/>` in your [`app.vue`](https://nuxt.com/docs/4.x/directory-structure/app/app) or [`app/layouts/`](https://nuxt.com/docs/4.x/directory-structure/app/layouts) to enhance accessibility by informing assistive technologies about page title changes. This ensures that navigational changes are announced to users relying on screen readers.

app/app.vue

```
<template>

  <NuxtRouteAnnouncer />

  <NuxtLayout>

    <NuxtPage />

  </NuxtLayout>

</template>
```

## Slots

You can pass custom HTML or components through the route announcer's default slot.

```
<template>

  <NuxtRouteAnnouncer>

    <template #default="{ message }">

      <p>{{ message }} was loaded.</p>

    </template>

  </NuxtRouteAnnouncer>

</template>
```

## Props

- `atomic`: Controls if screen readers only announce changes or the entire content. Set to true for full content readouts on updates, false for changes only. (default `false`)
- `politeness`: Sets the urgency for screen reader announcements: `off` (disable the announcement), `polite` (waits for silence), or `assertive` (interrupts immediately). (default `polite`)

This component is optional.  
To achieve full customization, you can implement your own one based on [its source code](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/components/nuxt-route-announcer.ts).

You can hook into the underlying announcer instance using [the `useRouteAnnouncer` composable](https://nuxt.com/docs/4.x/api/composables/use-route-announcer), which allows you to set a custom announcement message.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/1.components/12.nuxt-route-announcer.md)[<Teleport>](https://nuxt.com/docs/4.x/api/components/teleports)

[

The <Teleport> component teleports a component to a different location in the DOM.

](https://nuxt.com/docs/4.x/api/components/teleports)[

<NuxtTime>

The <NuxtTime> component displays time in a locale-friendly format with server-client consistency.

](https://nuxt.com/docs/4.x/api/components/nuxt-time)