---
title: "useRouteAnnouncer · Nuxt Composables v4"
source: "https://nuxt.com/docs/4.x/api/composables/use-route-announcer"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## useRouteAnnouncer

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/composables/route-announcer.ts)

This composable observes the page title changes and updates the announcer message accordingly.

This composable is available in Nuxt v3.12+.

## Description

A composable which observes the page title changes and updates the announcer message accordingly. Used by [`<NuxtRouteAnnouncer>`](https://nuxt.com/docs/4.x/api/components/nuxt-route-announcer) and controllable. It hooks into Unhead's `dom:rendered` hook to read the page's title and set it as the announcer message.

## Parameters

- `politeness`: Sets the urgency for screen reader announcements: `off` (disable the announcement), `polite` (waits for silence), or `assertive` (interrupts immediately). (default `polite`).

## Properties

### message

- **type**: `Ref<string>`
- **description**: The message to announce

### politeness

- **type**: `Ref<string>`
- **description**: Screen reader announcement urgency level `off`, `polite`, or `assertive`

## Methods

### set(message, politeness = "polite")

Sets the message to announce with its urgency level.

### polite(message)

Sets the message with `politeness = "polite"`

### assertive(message)

Sets the message with `politeness = "assertive"`

## Example

app/pages/index.vue

```
<script setup lang="ts">

const { message, politeness, set, polite, assertive } = useRouteAnnouncer({

  politeness: 'assertive',

})

</script>
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/2.composables/use-route-announcer.md)[useRoute](https://nuxt.com/docs/4.x/api/composables/use-route)

[

The useRoute composable returns the current route.

](https://nuxt.com/docs/4.x/api/composables/use-route)[

useRouter

The useRouter composable returns the router instance.

](https://nuxt.com/docs/4.x/api/composables/use-router)