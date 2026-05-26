---
title: "Vue ContentSearchButton Component"
source: "https://ui.nuxt.com/docs/components/content-search-button"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A pre-styled Button to open the ContentSearch modal."
tags:
---
## ContentSearchButton

[Button](https://ui.nuxt.com/docs/components/button) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/content/ContentSearchButton.vue)

A pre-styled Button to open the ContentSearch modal.

This component is only available when the `@nuxt/content` module is installed.

## Usage

The ContentSearchButton component is used to open the [ContentSearch](https://ui.nuxt.com/docs/components/content-search) modal.

```
<template>

  <UContentSearchButton />

</template>
```

It extends the [Button](https://ui.nuxt.com/docs/components/button) component, so you can pass any property such as `color`, `variant`, `size`, etc.

```
<template>

  <UContentSearchButton variant="subtle" />

</template>
```

The button defaults to `color="neutral"` and `variant="outline"` when not collapsed, `variant="ghost"` when collapsed.

### Collapsed

Use the `collapsed` prop to show the button's label and [kbds](https://ui.nuxt.com/docs/components/#kbds). Defaults to `true`.

```
<template>

  <UContentSearchButton :collapsed="false" />

</template>
```

### Kbds

Use the `kbds` prop to display keyboard keys in the button. Defaults to `['meta', 'K']` to match the default shortcut of the [ContentSearch](https://ui.nuxt.com/docs/components/content-search#shortcut) component.

```
<template>

  <UContentSearchButton :collapsed="false" :kbds="['alt', 'O']" />

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'button'` | `any`  The element or component this component should render as when not a link. |
| `icon` | `appConfig.ui.icons.search` | `any`  The icon displayed in the button. |
| `label` | `t('contentSearchButton.label')` | ` string`  The label displayed in the button. |
| `color` | `'neutral'` | ` "error" \| "neutral" \| "primary" \| "secondary" \| "success" \| "info" \| "warning"`  The color of the button. |
| `variant` |  | ` "solid" \| "outline" \| "soft" \| "subtle" \| "ghost" \| "link"`  The variant of the button. Defaults to 'outline' when not collapsed, 'ghost' when collapsed. |
| `collapsed` | `true` | `boolean`  Whether the button is collapsed. |
| `tooltip` | `false` | `boolean \| TooltipProps`  Display a tooltip on the button when is collapsed with the button label. This has priority over the global `tooltip` prop. |
| `kbds` | `["meta", "k"]` | ` (string \| undefined)[] \| KbdProps[]`  The keyboard keys to display in the button.`{ variant: 'subtle' }` |
| `autofocus` |  | ` false \| true \| "true" \| "false"` |
| `disabled` |  | `boolean` |
| `name` |  | ` string` |
| `type` | `'button'` | ` "reset" \| "submit" \| "button"`  The type of the button when not a link. |
| `activeColor` |  | ` "error" \| "neutral" \| "primary" \| "secondary" \| "success" \| "info" \| "warning"` |
| `activeVariant` |  | ` "solid" \| "outline" \| "soft" \| "subtle" \| "ghost" \| "link"` |
| `size` | `'md'` | ` "xs" \| "sm" \| "md" \| "lg" \| "xl"` |
| `square` |  | `boolean`  Render the button with equal padding on all sides. |
| `block` |  | `boolean`  Render the button full width. |
| `loadingAuto` |  | `boolean`  Set loading state automatically based on the `@click` promise state |
| `avatar` |  | ` AvatarProps`  Display an avatar on the left side. |
| `leading` |  | `boolean`  When `true`, the icon will be displayed on the left side. |
| `leadingIcon` |  | `any`  Display an icon on the left side. |
| `trailing` |  | `boolean`  When `true`, the icon will be displayed on the right side. |
| `trailingIcon` |  | `any`  Display an icon on the right side. |
| `loading` |  | `boolean`  When `true`, the loading icon will be displayed. |
| `loadingIcon` | `appConfig.ui.icons.loading` | `any`  The icon when the `loading` prop is `true`. |
| `ui` |  | ` { base?: ClassNameValue; label?: ClassNameValue; trailing?: ClassNameValue; } & { base?: ClassNameValue; label?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; trailingIcon?: ClassNameValue; }` |

This component also supports all native `<button>` HTML attributes.

### Slots

| Slot | Type |
| --- | --- |
| `leading` | `{ ui: { base: (props?: Record<string, any> \| undefined) => string; label: (props?: Record<string, any> \| undefined) => string; leadingIcon: (props?: Record<string, any> \| undefined) => string; leadingAvatar: (props?: Record<string, any> \| undefined) => string; leadingAvatarSize: (props?: Record<string, any> \| undefined) => string; trailingIcon: (props?: Record<string, any> \| undefined) => string; }; }` |
| `default` | `{ ui: { base: (props?: Record<string, any> \| undefined) => string; label: (props?: Record<string, any> \| undefined) => string; leadingIcon: (props?: Record<string, any> \| undefined) => string; leadingAvatar: (props?: Record<string, any> \| undefined) => string; leadingAvatarSize: (props?: Record<string, any> \| undefined) => string; trailingIcon: (props?: Record<string, any> \| undefined) => string; }; }` |
| `trailing` | `{ ui: { base: (props?: Record<string, any> \| undefined) => string; label: (props?: Record<string, any> \| undefined) => string; leadingIcon: (props?: Record<string, any> \| undefined) => string; leadingAvatar: (props?: Record<string, any> \| undefined) => string; leadingAvatarSize: (props?: Record<string, any> \| undefined) => string; trailingIcon: (props?: Record<string, any> \| undefined) => string; }; }` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    contentSearchButton: {

      slots: {

        base: '',

        label: '',

        trailing: 'hidden lg:flex items-center gap-0.5 ms-auto'

      },

      variants: {

        collapsed: {

          true: {

            label: 'hidden',

            trailing: 'lg:hidden'

          }

        }

      }

    }

  }

})
```

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

        contentSearchButton: {

          slots: {

            base: '',

            label: '',

            trailing: 'hidden lg:flex items-center gap-0.5 ms-auto'

          },

          variants: {

            collapsed: {

              true: {

                label: 'hidden',

                trailing: 'lg:hidden'

              }

            }

          }

        }

      }

    })

  ]

})
```

## Changelog

[`184ea`](https://github.com/nuxt/ui/commit/184eaab1cd5f4f4943b509ea1a3efb1b6f6d7f91) — chore: reduce type verbosity by omitting link props from action buttons

[`3e72b`](https://github.com/nuxt/ui/commit/3e72bf85aab2a6bd2945b42b5f20bdb26da8ff23) — fix: hide label and trailing with css when collapsed

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`3173b`](https://github.com/nuxt/ui/commit/3173bee38ce9e518076848999f14374600069d35) — fix: proxySlots reactivity ([#4969](https://github.com/nuxt/ui/issues/4969))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components