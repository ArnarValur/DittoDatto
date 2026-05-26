---
title: "Vue ColorModeSelect Component"
source: "https://ui.nuxt.com/docs/components/color-mode-select"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A Select to switch between system, dark & light mode."
tags:
---
## Usage

The ColorModeSelect component extends the [SelectMenu](https://ui.nuxt.com/docs/components/select-menu) component, so you can pass any property such as `color`, `variant`, `size`, etc.

```
<template>

  <UColorModeSelect />

</template>
```

## Examples

### With custom icons

Use the `app.config.ts` to customize the icon with the `ui.icons` property:

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    icons: {

      system: 'i-ph-desktop',

      light: 'i-ph-sun',

      dark: 'i-ph-moon'

    }

  }

})
```

Use the `vite.config.ts` to customize the icon with the `ui.icons` property:

vite.config.ts

```ts
import { defineConfig } from 'vite'

import vue from '@vitejs/plugin-vue'

import ui from '@nuxt/ui/vite'

export default defineConfig({

  plugins: [

    vue(),

    ui({

      ui: {

        icons: {

          light: 'i-ph-sun',

          dark: 'i-ph-moon'

        }

      }

    })

  ]

})
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `defaultOpen` |  | `boolean`  The open state of the combobox when it is initially rendered.   Use when you do not need to control its open state. |
| `open` |  | `boolean`  The controlled open state of the Combobox. Can be binded with with `v-model:open`. |
| `trailingIcon` | `appConfig.ui.icons.chevronDown` | `any` |
| `color` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `highlight` |  | `boolean`  Highlight the ring color like a focus state. |
| `name` |  | ` string`  The name of the field. Submitted with its owning form as part of a name/value pair. |
| `trailing` |  | `boolean`  When `true`, the icon will be displayed on the right side. |
| `content` | `{ side: 'bottom', sideOffset: 8, collisionPadding: 8, position: 'popper' }` | ` ComboboxContentProps & Partial<EmitsToProps<DismissableLayerEmits>>` |
| `loading` |  | `boolean`  When `true`, the loading icon will be displayed. |
| `size` | `'md'` | ` "md" \| "xs" \| "sm" \| "lg" \| "xl"` |
| `avatar` |  | ` AvatarProps`  Display an avatar on the left side. |
| `variant` | `'outline'` | ` "ghost" \| "outline" \| "soft" \| "subtle" \| "none"` |
| `autofocus` |  | `boolean` |
| `disabled` |  | `boolean`  When `true`, prevents the user from interacting with listbox |
| `leading` |  | `boolean`  When `true`, the icon will be displayed on the left side. |
| `leadingIcon` |  | `any`  Display an icon on the left side. |
| `loadingIcon` | `appConfig.ui.icons.loading` | `any`  The icon when the `loading` prop is `true`. |
| `resetSearchTermOnBlur` | `` `true` `` | `boolean`  Whether to reset the searchTerm when the Combobox input blurred |
| `resetSearchTermOnSelect` | `` `true` `` | `boolean`  Whether to reset the searchTerm when the Combobox value is selected |
| `resetModelValueOnClear` |  | `boolean`  When `true` the `modelValue` will be reset to `null` (or `[]` if `multiple`) |
| `highlightOnHover` |  | `boolean`  When `true`, hover over item will trigger highlight |
| `by` |  | ` string \| (a: SelectMenuItem[], b: SelectMenuItem[]): boolean`  Use this to compare objects by a particular field, or pass your own comparison function for complete control over how objects are compared. |
| `defaultValue` |  | ` null \| string \| number \| bigint \| false \| true \| { [key: string]: any; label?: string \| undefined; description?: string \| undefined; icon?: any; avatar?: AvatarProps \| undefined; chip?: ChipProps \| undefined; type?: "item" \| "label" \| "separator" \| undefined; disabled?: boolean \| undefined; onSelect?: ((e: Event) => void) \| undefined; class?: any; ui?: Pick<{ base?: ClassNameValue; leading?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; trailing?: ClassNameValue; trailingIcon?: ClassNameValue; value?: ClassNameValue; placeholder?: ClassNameValue; arrow?: ClassNameValue; content?: ClassNameValue; viewport?: ClassNameValue; group?: ClassNameValue; empty?: ClassNameValue; label?: ClassNameValue; separator?: ClassNameValue; item?: ClassNameValue; itemLeadingIcon?: ClassNameValue; itemLeadingAvatar?: ClassNameValue; itemLeadingAvatarSize?: ClassNameValue; itemLeadingChip?: ClassNameValue; itemLeadingChipSize?: ClassNameValue; itemTrailing?: ClassNameValue; itemTrailingIcon?: ClassNameValue; itemWrapper?: ClassNameValue; itemLabel?: ClassNameValue; itemDescription?: ClassNameValue; input?: ClassNameValue; focusScope?: ClassNameValue; trailingClear?: ClassNameValue; }, "item" \| "label" \| "separator" \| "itemLeadingIcon" \| "itemLeadingAvatar" \| "itemLeadingAvatarSize" \| "itemLeadingChip" \| "itemLeadingChipSize" \| "itemTrailing" \| "itemTrailingIcon" \| "itemWrapper" \| "itemLabel" \| "itemDescription"> \| undefined; }` |
| `multiple` |  | ` false`  Whether multiple options can be selected or not. |
| `required` |  | `boolean` |
| `id` |  | ` string` |
| `placeholder` |  | ` string`  The placeholder text when the select is empty. |
| `searchInput` | `false` | `boolean \| InputProps<AcceptableValue>`  Whether to display the search input or not. Can be an object to pass additional props to the input.`{ placeholder: 'Search...', variant: 'none' }` |
| `selectedIcon` | `appConfig.ui.icons.check` | `any`  The icon displayed when an item is selected. |
| `clear` | `false` | `boolean \| Partial<Omit<ButtonProps, LinkPropsKeys>>`  Display a clear button to reset the model value. Can be an object to pass additional props to the Button. |
| `clearIcon` | `appConfig.ui.icons.close` | `any`  The icon displayed in the clear button. |
| `arrow` | `false` | `boolean \| ComboboxArrowProps` |
| `portal` | `true` | ` string \| false \| true \| HTMLElement` |
| `virtualize` | `false` | `boolean \| { overscan?: number ; estimateSize?: number \| ((index: number) => number) \| undefined; } \| undefined`  Enable virtualization for large lists. Note: when enabled, all groups are flattened into a single list due to a limitation of Reka UI ([https://github.com/unovue/reka-ui/issues/1885](https://github.com/unovue/reka-ui/issues/1885)). |
| `valueKey` | `undefined` | `undefined`  When `items` is an array of objects, select the field to use as the value instead of the object itself. |
| `labelKey` | `'label'` | ` string \| number`  When `items` is an array of objects, select the field to use as the label. |
| `descriptionKey` | `'description'` | ` string \| number`  When `items` is an array of objects, select the field to use as the description. |
| `modelModifiers` |  | ` Omit<ModelModifiers<SelectMenuItem>, "lazy">` |
| `createItem` | `false` | `boolean \| "always" \| { position?: "top" \| "bottom" ; when?: "empty" \| "always" \| undefined; } \| undefined`  Determines if custom user input that does not exist in options can be added. |
| `filterFields` | `[labelKey]` | ` string[]`  Fields to filter items by. |
| `ignoreFilter` | `false` | `boolean`  When `true`, disable the default filters, useful for custom filtering (useAsyncData, useFetch, etc.). |
| `autofocusDelay` |  | ` number` |
| `ui` |  | ` { base?: ClassNameValue; leading?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; trailing?: ClassNameValue; trailingIcon?: ClassNameValue; value?: ClassNameValue; placeholder?: ClassNameValue; arrow?: ClassNameValue; content?: ClassNameValue; viewport?: ClassNameValue; group?: ClassNameValue; empty?: ClassNameValue; label?: ClassNameValue; separator?: ClassNameValue; item?: ClassNameValue; itemLeadingIcon?: ClassNameValue; itemLeadingAvatar?: ClassNameValue; itemLeadingAvatarSize?: ClassNameValue; itemLeadingChip?: ClassNameValue; itemLeadingChipSize?: ClassNameValue; itemTrailing?: ClassNameValue; itemTrailingIcon?: ClassNameValue; itemWrapper?: ClassNameValue; itemLabel?: ClassNameValue; itemDescription?: ClassNameValue; input?: ClassNameValue; focusScope?: ClassNameValue; trailingClear?: ClassNameValue; }` |

## Changelog

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[ColorModeImage](https://ui.nuxt.com/docs/components/color-mode-image)

[

An image element with a different source for light and dark mode.

](https://ui.nuxt.com/docs/components/color-mode-image)[

ColorModeSwitch

A switch to toggle between light and dark mode.

](https://ui.nuxt.com/docs/components/color-mode-switch)