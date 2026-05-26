---
title: "Vue Main Component"
source: "https://ui.nuxt.com/docs/components/main"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A main element that fills the available viewport height."
tags:
---
## Main

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Main.vue)

A main element that fills the available viewport height.

## Usage

The Main component renders a `<main>` element that works together with the [Header](https://ui.nuxt.com/docs/components/header) component to create a full-height layout that extends to the viewport's available height.

The Main component uses the `--ui-header-height` CSS variable to position itself correctly below the `Header`.

## Examples

### Within app.vue

Use the Main component in your `app.vue` or in a layout:

app.vue

```
<template>

  <UApp>

    <UHeader />

    <UMain>

      <NuxtLayout>

        <NuxtPage />

      </NuxtLayout>

    </UMain>

    <UFooter />

  </UApp>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'main'` | `any`  The element or component this component should render as. |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{}` |

## Theme

## Changelog

[`6ccb1`](https://github.com/nuxt/ui/commit/6ccb1f53b9286852bce78259c3fa4eb36bb0390d) — fix: render as `main` instead of `div`

[`2a09a`](https://github.com/nuxt/ui/commit/2a09ac0c1ed5b528dc843ebeb0032395dc8a125b) — fix: render as `div` instead of `main`

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components