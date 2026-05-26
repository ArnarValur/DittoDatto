---
title: "Vue extendLocale Composable"
source: "https://ui.nuxt.com/docs/composables/extend-locale"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A utility to extend an existing locale with custom translations."
tags:
---
## extendLocale

A utility to extend an existing locale with custom translations.

## Usage

Use the `extendLocale` utility to customize an existing locale by overriding specific properties or messages.

```
<script setup lang="ts">

import { en } from '@nuxt/ui/locale'

const locale = extendLocale(en, {

  code: 'en-AU',

  messages: {

    commandPalette: {

      placeholder: 'Search a component...'

    }

  }

})

</script>

<template>

  <UApp :locale="locale">

    <NuxtPage />

  </UApp>

</template>
```

This is useful when you want to:

- Create a regional variant of a language (e.g., `en-AU` from `en`)
- Override specific translations without redefining the entire locale
- Customize component labels for your application

Learn more about internationalization in the **i18n integration** documentation.

## API

`extendLocale<M>(locale: Locale<M>, options: Partial<DefineLocaleOptions<DeepPartial<M>>>): Locale<M>`

Extends an existing locale with the provided options, deeply merging the messages.

#### Parameters

locale

Locale<M> required

The base locale to extend. Import from `@nuxt/ui/locale`.

options

Partial<DefineLocaleOptions<DeepPartial<M>>> required

The properties to override:

**Returns:** A new `Locale<M>` object with the merged properties.

## Example

Here's an example extending the English locale for an Australian variant:

The `extendLocale` utility uses deep merging, so you only need to specify the messages you want to override. All other messages will be inherited from the base locale.