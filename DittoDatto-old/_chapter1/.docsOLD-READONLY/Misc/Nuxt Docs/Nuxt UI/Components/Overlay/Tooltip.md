---
title: "Vue Tooltip Component"
source: "https://ui.nuxt.com/docs/components/tooltip"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A popup that reveals information when hovering over an element."
tags:
---
## Tooltip

[Tooltip](https://reka-ui.com/docs/components/tooltip) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Tooltip.vue)

A popup that reveals information when hovering over an element.

## Usage

Use a [Button](https://ui.nuxt.com/docs/components/button) or any other component in the default slot of the Tooltip.

```
<template>

  <UTooltip text="Open on GitHub">

    <UButton label="Open" color="neutral" variant="subtle" />

  </UTooltip>

</template>
```

Make sure to wrap your app with the [`App`](https://ui.nuxt.com/docs/components/app) component which uses the [`TooltipProvider`](https://reka-ui.com/docs/components/tooltip#provider) component from Reka UI.

You can check the `App` component `tooltip` prop to see how to configure the Tooltip globally.

### Text

Use the `text` prop to set the content of the Tooltip.

```
<template>

  <UTooltip text="Open on GitHub">

    <UButton label="Open" color="neutral" variant="subtle" />

  </UTooltip>

</template>
```

### Kbds

Use the `kbds` prop to render [Kbd](https://ui.nuxt.com/docs/components/kbd) components in the Tooltip.

```
<template>

  <UTooltip text="Open on GitHub" :kbds="['meta', 'G']">

    <UButton label="Open" color="neutral" variant="subtle" />

  </UTooltip>

</template>
```

You can use special keys like `meta` that displays as `⌘` on macOS and `Ctrl` on other platforms.

### Delay

Use the `delay-duration` prop to change the delay before the Tooltip appears. For example, you can make it appear instantly by setting it to `0`.

```
<template>

  <UTooltip :delay-duration="0" text="Open on GitHub">

    <UButton label="Open" color="neutral" variant="subtle" />

  </UTooltip>

</template>
```

This can be configured globally through the `tooltip.delayDuration` option in the [`App`](https://ui.nuxt.com/docs/components/app) component.

Use the `content` prop to control how the Tooltip content is rendered, like its `align` or `side` for example.

```
<template>

  <UTooltip

    :content="{

      align: 'center',

      side: 'bottom',

      sideOffset: 8

    }"

    text="Open on GitHub"

  >

    <UButton label="Open" color="neutral" variant="subtle" />

  </UTooltip>

</template>
```

### Arrow

Use the `arrow` prop to display an arrow on the Tooltip.

```
<template>

  <UTooltip arrow text="Open on GitHub">

    <UButton label="Open" color="neutral" variant="subtle" />

  </UTooltip>

</template>
```

### Disabled

Use the `disabled` prop to disable the Tooltip.

```
<template>

  <UTooltip disabled text="Open on GitHub">

    <UButton label="Open" color="neutral" variant="subtle" />

  </UTooltip>

</template>
```

## Examples

### Control open state

You can control the open state by using the `default-open` prop or the `v-model:open` directive.

```
<script setup lang="ts">

const open = ref(false)

defineShortcuts({

  o: () => open.value = !open.value

})

</script>

<template>

  <UTooltip v-model:open="open" text="Open on GitHub">

    <UButton label="Open" color="neutral" variant="subtle" />

  </UTooltip>

</template>
```

In this example, leveraging [`defineShortcuts`](https://ui.nuxt.com/docs/composables/define-shortcuts), you can toggle the Tooltip by pressing O.

### With following cursor

You can make the Tooltip follow the cursor when hovering over an element using the [`reference`](https://reka-ui.com/docs/components/tooltip#trigger) prop:

Hover me

```
<script setup lang="ts">

const open = ref(false)

const anchor = ref({ x: 0, y: 0 })

const reference = computed(() => ({

  getBoundingClientRect: () =>

    ({

      width: 0,

      height: 0,

      left: anchor.value.x,

      right: anchor.value.x,

      top: anchor.value.y,

      bottom: anchor.value.y,

      ...anchor.value

    } as DOMRect)

}))

</script>

<template>

  <UTooltip

    :open="open"

    :reference="reference"

    :content="{ side: 'top', sideOffset: 16, updatePositionStrategy: 'always' }"

  >

    <div

      class="flex items-center justify-center rounded-md border border-dashed border-accented text-sm aspect-video w-72"

      @pointerenter="open = true"

      @pointerleave="open = false"

      @pointermove="(ev: PointerEvent) => {

        anchor.x = ev.clientX

        anchor.y = ev.clientY

      }"

    >

      Hover me

    </div>

    <template #content>

      {{ anchor.x.toFixed(0) }} - {{ anchor.y.toFixed(0) }}

    </template>

  </UTooltip>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `text` |  | ` string`  The text content of the tooltip. |
| `kbds` |  | ` (string \| undefined)[] \| KbdProps[]`  The keyboard keys to display in the tooltip. |
| `content` | `{ side: 'bottom', sideOffset: 8, collisionPadding: 8 }` | ` TooltipContentProps & Partial<EmitsToProps<TooltipContentImplEmits>>`  The content of the tooltip. |
| `arrow` | `false` | `boolean \| TooltipArrowProps`  Display an arrow alongside the tooltip. |
| `portal` | `true` | ` string \| false \| true \| HTMLElement`  Render the tooltip in a portal. |
| `reference` |  | ` Element \| VirtualElement`  The reference (or anchor) element that is being referred to for positioning.  If not provided will use the current component as anchor. |
| `defaultOpen` |  | `boolean`  The open state of the tooltip when it is initially rendered. Use when you do not need to control its open state. |
| `open` |  | `boolean`  The controlled open state of the tooltip. |
| `delayDuration` | `700` | ` number`  Override the duration given to the `Provider` to customise the open delay for a specific tooltip. |
| `disableHoverableContent` |  | `boolean`  Prevents Tooltip.Content from remaining open when hovering. Disabling this has accessibility consequences. Inherits from Tooltip.Provider. |
| `disableClosingTrigger` | `false` | `boolean`  When `true`, clicking on trigger will not close the content. |
| `disabled` | `false` | `boolean`  When `true`, disable tooltip |
| `ignoreNonKeyboardFocus` | `false` | `boolean`  Prevent the tooltip from opening if the focus did not come from the keyboard by matching against the `:focus-visible` selector. This is useful if you want to avoid opening it when switching browser tabs or closing a dialog. |
| `ui` |  | ` { content?: ClassNameValue; arrow?: ClassNameValue; text?: ClassNameValue; kbds?: ClassNameValue; kbdsSize?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{ open: boolean; }` |
| `content` | `{ ui: object; }` |

### Emits

| Event | Type |
| --- | --- |
| `update:open` | `[value: boolean]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    tooltip: {

      slots: {

        content: 'flex items-center gap-1 bg-default text-highlighted shadow-sm rounded-sm ring ring-default h-6 px-2.5 py-1 text-xs select-none data-[state=delayed-open]:animate-[scale-in_100ms_ease-out] data-[state=closed]:animate-[scale-out_100ms_ease-in] origin-(--reka-tooltip-content-transform-origin) pointer-events-auto',

        arrow: 'fill-default',

        text: 'truncate',

        kbds: "hidden lg:inline-flex items-center shrink-0 gap-0.5 not-first-of-type:before:content-['·'] not-first-of-type:before:me-0.5",

        kbdsSize: 'sm'

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

        tooltip: {

          slots: {

            content: 'flex items-center gap-1 bg-default text-highlighted shadow-sm rounded-sm ring ring-default h-6 px-2.5 py-1 text-xs select-none data-[state=delayed-open]:animate-[scale-in_100ms_ease-out] data-[state=closed]:animate-[scale-out_100ms_ease-in] origin-(--reka-tooltip-content-transform-origin) pointer-events-auto',

            arrow: 'fill-default',

            text: 'truncate',

            kbds: "hidden lg:inline-flex items-center shrink-0 gap-0.5 not-first-of-type:before:content-['·'] not-first-of-type:before:me-0.5",

            kbdsSize: 'sm'

          }

        }

      }

    })

  ]

})
```

## Changelog

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`5e39c`](https://github.com/nuxt/ui/commit/5e39cbb3b284f382d910de96d8f19faf4044108e) — fix: render only if `text` or `kbds` are present ([#4568](https://github.com/nuxt/ui/issues/4568))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`63476`](https://github.com/nuxt/ui/commit/63476e516b9db1dd060e48154910a0b1a6bf0f9a) — fix: display separator only with `text` and `kbds` ([#4570](https://github.com/nuxt/ui/issues/4570))

[`b00e0`](https://github.com/nuxt/ui/commit/b00e07f13df34fa528d6349e0172845c37ab8906) — feat: add `reference` prop

[`69a7b`](https://github.com/nuxt/ui/commit/69a7b957d5ecc0b26d63112ebb20765a85874993) — feat: add `reference` prop

[`0634a`](https://github.com/nuxt/ui/commit/0634a756a496f5131841abafd218ae7e4aaa61e5) — fix: increase padding for consistency

[`29fa4`](https://github.com/nuxt/ui/commit/29fa46276d6bf69b5b87880c476c6f778c2820bf) — feat: add global `portal` prop ([#3688](https://github.com/nuxt/ui/issues/3688))

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`01d8d`](https://github.com/nuxt/ui/commit/01d8dc72adb0b32ad68bb4a98bf24b17f435a89c) — fix: respect `transform-origin` in popper content ([#3919](https://github.com/nuxt/ui/issues/3919))

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`5dec0`](https://github.com/nuxt/ui/commit/5dec0e16e28549b8833aaab17a87fada63d6598c) — feat: handle events in `content` prop