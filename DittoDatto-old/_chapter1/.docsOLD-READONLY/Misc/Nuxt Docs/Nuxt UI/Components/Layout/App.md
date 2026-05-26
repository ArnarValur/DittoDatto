---
title: "Vue App Component"
source: "https://ui.nuxt.com/docs/components/app"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "Wraps your app to provide global configurations and more."
tags:
---
## App

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/App.vue)

Wraps your app to provide global configurations and more.

## Usage

This component implements Reka UI [ConfigProvider](https://reka-ui.com/docs/utilities/config-provider) to provide global configuration to all components:

- Enables all primitives to inherit global reading direction.
- Enables changing the behavior of scroll body when setting body lock.
- Much more controls to prevent layout shifts.

It's also using [ToastProvider](https://reka-ui.com/docs/components/toast#provider) and [TooltipProvider](https://reka-ui.com/docs/components/tooltip#provider) to provide global toasts and tooltips, as well as programmatic modals and slideovers.

Wrap your entire application with the App component in your `app.vue` file:

app.vue

```
<template>

  <UApp>

    <NuxtPage />

  </UApp>

</template>
```

Learn how to use the `locale` prop to change the locale of your app. This also controls the date/time format in components like Calendar, InputDate, and InputTime.

Learn how to use the `locale` prop to change the locale of your app. This also controls the date/time format in components like Calendar, InputDate, and InputTime.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `tooltip` |  | ` TooltipProviderProps` |
| `toaster` |  | ` null \| ToasterProps` |
| `locale` |  | ` Locale<T>` |
| `portal` | `'body'` | ` string \| false \| true \| HTMLElement` |
| `dir` | `'ltr'` | ` "ltr" \| "rtl"`  The global reading direction of your application. This will be inherited by all primitives. |
| `scrollBody` |  | `boolean \| ScrollBodyOption` |
| `nonce` |  | ` string` |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{}` |

## Changelog

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`7659f`](https://github.com/nuxt/ui/commit/7659fa11628238b89f85d6f402c7bc5ccdd077e1) — fix: allow global portal disabling ([#5111](https://github.com/nuxt/ui/issues/5111))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`29fa4`](https://github.com/nuxt/ui/commit/29fa46276d6bf69b5b87880c476c6f778c2820bf) — feat: add global `portal` prop ([#3688](https://github.com/nuxt/ui/issues/3688))

[`b9983`](https://github.com/nuxt/ui/commit/b9983549a4b743724ea3ef99cc4a243f5ca41e53) — fix: improve generic types ([#3331](https://github.com/nuxt/ui/issues/3331))[Container](https://ui.nuxt.com/docs/components/container)

[

A container lets you center and constrain the width of your content.

](https://ui.nuxt.com/docs/components/container)