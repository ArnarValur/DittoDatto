---
title: "Vue defineLocale Composable"
source: "https://ui.nuxt.com/docs/composables/define-locale"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A utility to create a custom locale for your app."
tags:
---
## defineLocale

A utility to create a custom locale for your app.

## Usage

Use the `defineLocale` utility to create a custom locale with your own translations.

```
<script setup lang="ts">

import type { Messages } from '@nuxt/ui'

const locale = defineLocale<Messages>({

  name: 'My custom locale',

  code: 'en',

  dir: 'ltr',

  messages: {

    // implement pairs

  }

})

</script>

<template>

  <UApp :locale="locale">

    <NuxtPage />

  </UApp>

</template>
```

Learn more about internationalization in the **i18n integration** documentation.

## API

`defineLocale<M>(options: DefineLocaleOptions<M>): Locale<M>`

Creates a new locale object with the provided options.

#### Parameters

options

DefineLocaleOptions<M>

The locale configuration object with the following properties:

**Returns:** A `Locale<M>` object that can be passed to the `locale` prop of the [App](https://ui.nuxt.com/docs/components/app) component.

## Example

Here's a complete example of creating a custom locale:

```
<script setup lang="ts">

import type { Messages } from '@nuxt/ui'

const locale = defineLocale<Messages>({

  name: 'Español',

  code: 'es',

  dir: 'ltr',

  messages: {

    alert: {

      close: 'Cerrar'

    },

    modal: {

      close: 'Cerrar'

    },

    commandPalette: {

      back: 'Atrás',

      close: 'Cerrar',

      noData: 'Sin datos',

      noMatch: 'Sin resultados',

      placeholder: 'Escribe un comando o busca…'

    }

    // ... other component messages

  }

})

</script>

<template>

  <UApp :locale="locale">

    <NuxtPage />

  </UApp>

</template>
```

You can look at the [built-in locales](https://github.com/nuxt/ui/tree/v4/src/runtime/locale) for reference on how to structure the messages object.[defineShortcuts](https://ui.nuxt.com/docs/composables/define-shortcuts)

[

A composable to define keyboard shortcuts in your app.

](https://ui.nuxt.com/docs/composables/define-shortcuts)