---
title: "Vue LocaleSelect Component"
source: "https://ui.nuxt.com/docs/components/locale-select"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A Select to switch between locales."
tags:
---
## Usage

The LocaleSelect component extends the [SelectMenu](https://ui.nuxt.com/docs/components/select-menu) component, so you can pass any property such as `color`, `variant`, `size`, etc.

This component is meant to be used with the **i18n** system. Learn more about it in the guide.

This component is meant to be used with the **i18n** system. Learn more about it in the guide.

The flags are displayed using Unicode characters. This may result in a different display, e.g. Microsoft Edge under Windows displays the ISO 3166-1 alpha-2 code instead, as no flag icons are shipped with the OS fonts.

### Locales

Use the `locales` prop with an array of locales from `@nuxt/ui/locale`.

```
<script setup lang="ts">

import * as locales from '@nuxt/ui/locale'

const locale = ref('en')

</script>

<template>

  <ULocaleSelect v-model="locale" :locales="Object.values(locales)" class="w-48" />

</template>
```

You can pass only the locales you need in your application:

```
<script setup lang="ts">

import { en, es, fr } from '@nuxt/ui/locale'

const locale = ref('en')

</script>

<template>

  <ULocaleSelect v-model="locale" :locales="[en, es, fr]" />

</template>
```

### Dynamic locale

You can use it with Nuxt i18n:

```
<script setup lang="ts">

import * as locales from '@nuxt/ui/locale'

const { locale, setLocale } = useI18n()

</script>

<template>

  <ULocaleSelect

    :model-value="locale"

    :locales="Object.values(locales)"

    @update:model-value="setLocale($event)"

  />

</template>
```

You can use it with Vue i18n:

```
<script setup lang="ts">

import { useI18n } from 'vue-i18n'

import * as locales from '@nuxt/ui/locale'

const { locale, setLocale } = useI18n()

</script>

<template>

  <ULocaleSelect

    :model-value="locale"

    :locales="Object.values(locales)"

    @update:model-value="setLocale($event)"

  />

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `modelValue` |  | `string` |
| `locales` |  | ` Locale<any>[]` |
| `name` |  | ` string`  The name of the field. Submitted with its owning form as part of a name/value pair. |
| `avatar` |  | ` AvatarProps`  Display an avatar on the left side. |
| `size` | `'md'` | ` "md" \| "xs" \| "sm" \| "lg" \| "xl"` |
| `loading` |  | `boolean`  When `true`, the loading icon will be displayed. |
| `icon` |  | `any`  Display an icon based on the `leading` and `trailing` props. |
| `color` | `'primary'` | ` "error" \| "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "neutral"` |
| `autofocus` |  | `boolean` |
| `disabled` |  | `boolean`  When `true`, prevents the user from interacting with listbox |
| `open` |  | `boolean`  The controlled open state of the Combobox. Can be binded with with `v-model:open`. |
| `defaultOpen` |  | `boolean`  The open state of the combobox when it is initially rendered.   Use when you do not need to control its open state. |
| `resetSearchTermOnBlur` | `` `true` `` | `boolean`  Whether to reset the searchTerm when the Combobox input blurred |
| `resetSearchTermOnSelect` | `` `true` `` | `boolean`  Whether to reset the searchTerm when the Combobox value is selected |
| `resetModelValueOnClear` |  | `boolean`  When `true` the `modelValue` will be reset to `null` (or `[]` if `multiple`) |
| `highlightOnHover` |  | `boolean`  When `true`, hover over item will trigger highlight |
| `by` |  | ` string \| (a: Locale<any>[], b: Locale<any>[]): boolean`  Use this to compare objects by a particular field, or pass your own comparison function for complete control over how objects are compared. |
| `defaultValue` |  | ` string` |
| `multiple` |  | ` false`  Whether multiple options can be selected or not. |
| `required` |  | `boolean` |
| `id` |  | ` string` |
| `placeholder` |  | ` string`  The placeholder text when the select is empty. |
| `searchInput` | `false` | `boolean \| InputProps<AcceptableValue>`  Whether to display the search input or not. Can be an object to pass additional props to the input.`{ placeholder: 'Search...', variant: 'none' }` |
| `variant` | `'outline'` | ` "outline" \| "soft" \| "subtle" \| "ghost" \| "none"` |
| `trailingIcon` | `appConfig.ui.icons.chevronDown` | `any` |
| `selectedIcon` | `appConfig.ui.icons.check` | `any`  The icon displayed when an item is selected. |
| `clear` | `false` | `boolean \| Partial<Omit<ButtonProps, LinkPropsKeys>>`  Display a clear button to reset the model value. Can be an object to pass additional props to the Button. |
| `clearIcon` | `appConfig.ui.icons.close` | `any`  The icon displayed in the clear button. |
| `content` | `{ side: 'bottom', sideOffset: 8, collisionPadding: 8, position: 'popper' }` | ` ComboboxContentProps & Partial<EmitsToProps<DismissableLayerEmits>>` |
| `arrow` | `false` | `boolean \| ComboboxArrowProps` |
| `portal` | `true` | ` string \| false \| true \| HTMLElement` |
| `virtualize` | `false` | `boolean \| { overscan?: number ; estimateSize?: number \| ((index: number) => number) \| undefined; } \| undefined`  Enable virtualization for large lists. Note: when enabled, all groups are flattened into a single list due to a limitation of Reka UI ([https://github.com/unovue/reka-ui/issues/1885](https://github.com/unovue/reka-ui/issues/1885)). |
| `valueKey` | `'code'` | ` "code"`  When `items` is an array of objects, select the field to use as the value instead of the object itself. |
| `labelKey` | `'name'` | ``  "name" \| "code" \| "dir" \| "messages" \| `messages.${string}` ``  When `items` is an array of objects, select the field to use as the label. |
| `descriptionKey` | `'description'` | ``  "name" \| "code" \| "dir" \| "messages" \| `messages.${string}` ``  When `items` is an array of objects, select the field to use as the description. |
| `modelModifiers` |  | ` Omit<ModelModifiers<string>, "lazy">` |
| `highlight` |  | `boolean`  Highlight the ring color like a focus state. |
| `createItem` | `false` | `boolean \| "always" \| { position?: "top" \| "bottom" ; when?: "empty" \| "always" \| undefined; } \| undefined`  Determines if custom user input that does not exist in options can be added. |
| `filterFields` | `[labelKey]` | ` string[]`  Fields to filter items by. |
| `ignoreFilter` | `false` | `boolean`  When `true`, disable the default filters, useful for custom filtering (useAsyncData, useFetch, etc.). |
| `autofocusDelay` |  | ` number` |
| `leading` |  | `boolean`  When `true`, the icon will be displayed on the left side. |
| `leadingIcon` |  | `any`  Display an icon on the left side. |
| `trailing` |  | `boolean`  When `true`, the icon will be displayed on the right side. |
| `loadingIcon` | `appConfig.ui.icons.loading` | `any`  The icon when the `loading` prop is `true`. |
| `ui` |  | ` { base?: ClassNameValue; leading?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; trailing?: ClassNameValue; trailingIcon?: ClassNameValue; value?: ClassNameValue; placeholder?: ClassNameValue; arrow?: ClassNameValue; content?: ClassNameValue; viewport?: ClassNameValue; group?: ClassNameValue; empty?: ClassNameValue; label?: ClassNameValue; separator?: ClassNameValue; item?: ClassNameValue; itemLeadingIcon?: ClassNameValue; itemLeadingAvatar?: ClassNameValue; itemLeadingAvatarSize?: ClassNameValue; itemLeadingChip?: ClassNameValue; itemLeadingChipSize?: ClassNameValue; itemTrailing?: ClassNameValue; itemTrailingIcon?: ClassNameValue; itemWrapper?: ClassNameValue; itemLabel?: ClassNameValue; itemDescription?: ClassNameValue; input?: ClassNameValue; focusScope?: ClassNameValue; trailingClear?: ClassNameValue; }` |

## Changelog

[`b0139`](https://github.com/nuxt/ui/commit/b0139f01283d7cae5fbbe2618c3485ef939fb79e) — feat: add English (United Kingdom) language ([#5561](https://github.com/nuxt/ui/issues/5561))

[`33315`](https://github.com/nuxt/ui/commit/3331533026f4cb110d2a766128681870afa73518) — feat: add Albanian language ([#5461](https://github.com/nuxt/ui/issues/5461))

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[ColorModeSwitch](https://ui.nuxt.com/docs/components/color-mode-switch)

[

A switch to toggle between light and dark mode.

](https://ui.nuxt.com/docs/components/color-mode-switch)