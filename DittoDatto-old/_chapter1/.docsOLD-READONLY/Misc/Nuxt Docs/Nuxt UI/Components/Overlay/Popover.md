---
title: "Vue Popover Component"
source: "https://ui.nuxt.com/docs/components/popover"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A non-modal dialog that floats around a trigger element."
tags:
---
## Usage

Use a [Button](https://ui.nuxt.com/docs/components/button) or any other component in the default slot of the Popover.

Then, use the `#content` slot to add the content displayed when the Popover is open.

```
<template>

  <UPopover>

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #content>

      <Placeholder class="size-48 m-4 inline-flex" />

    </template>

  </UPopover>

</template>
```

### Mode

Use the `mode` prop to change the mode of the Popover. Defaults to `click`.

```
<template>

  <UPopover mode="hover">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #content>

      <Placeholder class="size-48 m-4 inline-flex" />

    </template>

  </UPopover>

</template>
```

When using the `hover` mode, the Reka UI [`HoverCard`](https://reka-ui.com/docs/components/hover-card) component is used instead of the [`Popover`](https://reka-ui.com/docs/components/popover).

### Delay

When using the `hover` mode, you can use the `open-delay` and `close-delay` props to control the delay before the Popover is opened or closed.

```
<template>

  <UPopover mode="hover" :open-delay="500" :close-delay="300">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #content>

      <Placeholder class="size-48 m-4 inline-flex" />

    </template>

  </UPopover>

</template>
```

Use the `content` prop to control how the Popover content is rendered, like its `align` or `side` for example.

```
<template>

  <UPopover

    :content="{

      align: 'center',

      side: 'bottom',

      sideOffset: 8

    }"

  >

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #content>

      <Placeholder class="size-48 m-4 inline-flex" />

    </template>

  </UPopover>

</template>
```

### Arrow

Use the `arrow` prop to display an arrow on the Popover.

```
<template>

  <UPopover arrow>

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #content>

      <Placeholder class="size-48 m-4 inline-flex" />

    </template>

  </UPopover>

</template>
```

### Modal

Use the `modal` prop to control whether the Popover blocks interaction with outside content. Defaults to `false`.

```
<template>

  <UPopover modal>

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #content>

      <Placeholder class="size-48 m-4 inline-flex" />

    </template>

  </UPopover>

</template>
```

### Dismissible

Use the `dismissible` prop to control whether the Popover is dismissible when clicking outside of it or pressing escape. Defaults to `true`.

A `close:prevent` event will be emitted when the user tries to close it.

```
<template>

  <UPopover :dismissible="false" :ui="{ content: 'p-4' }">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #content="{ close }">

      <div class="flex items-center gap-4 mb-4">

        <h2 class="text-highlighted font-semibold">

          Popover non-dismissible

        </h2>

        <UButton color="neutral" variant="ghost" icon="i-lucide-x" @click="close" />

      </div>

      <Placeholder class="size-full min-h-48" />

    </template>

  </UPopover>

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

  <UPopover v-model:open="open">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #content>

      <Placeholder class="size-48 m-4 inline-flex" />

    </template>

  </UPopover>

</template>
```

In this example, leveraging [`defineShortcuts`](https://ui.nuxt.com/docs/composables/define-shortcuts), you can toggle the Popover by pressing O.

### With command palette

You can use a [CommandPalette](https://ui.nuxt.com/docs/components/command-palette) component inside the Popover's content.

```
<script setup lang="ts">

import type { CommandPaletteItem } from '@nuxt/ui'

const items = ref([

  {

    label: 'bug',

    value: 'bug',

    chip: {

      color: 'error'

    }

  },

  {

    label: 'feature',

    value: 'feature',

    chip: {

      color: 'success'

    }

  },

  {

    label: 'enhancement',

    value: 'enhancement',

    chip: {

      color: 'info'

    }

  }

] satisfies CommandPaletteItem[])

const label = ref([])

</script>

<template>

  <UPopover :content="{ side: 'right', align: 'start' }">

    <UButton

      icon="i-lucide-tag"

      label="Select labels"

      color="neutral"

      variant="subtle"

    />

    <template #content>

      <UCommandPalette

        v-model="label"

        multiple

        placeholder="Search labels..."

        :groups="[{ id: 'labels', items }]"

        :ui="{ input: '[&>input]:h-8 [&>input]:text-sm' }"

      />

    </template>

  </UPopover>

</template>
```

### With following cursor

You can make the Popover follow the cursor when hovering over an element using the [`reference`](https://reka-ui.com/docs/components/tooltip#trigger) prop:

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

  <UPopover

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

      <div class="p-4">

        {{ anchor.x.toFixed(0) }} - {{ anchor.y.toFixed(0) }}

      </div>

    </template>

  </UPopover>

</template>
```

### With anchor slot

You can use the `#anchor` slot to position the Popover against a custom element.

This slot only works when `mode` is `click`.

```
<script lang="ts" setup>

const open = ref(false)

</script>

<template>

  <UPopover

    v-model:open="open"

    :dismissible="false"

    :ui="{ content: 'w-(--reka-popper-anchor-width) p-4' }"

  >

    <template #anchor>

      <UInput placeholder="Focus to open" @focus="open = true" @blur="open = false" />

    </template>

    <template #content>

      <Placeholder class="w-full aspect-square" />

    </template>

  </UPopover>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `mode` | `'click'` | ` M`  The display mode of the popover. |
| `content` | `{ side: 'bottom', sideOffset: 8, collisionPadding: 8 }` | ` PopoverContentProps & Partial<EmitsToProps<PopoverContentImplEmits>>`  The content of the popover. |
| `arrow` | `false` | `boolean \| PopoverArrowProps`  Display an arrow alongside the popover. |
| `portal` | `true` | ` string \| false \| true \| HTMLElement`  Render the popover in a portal. |
| `reference` |  | ` Element \| VirtualElement`  The reference (or anchor) element that is being referred to for positioning.  If not provided will use the current component as anchor. |
| `dismissible` | `true` | `boolean`  When `false`, the popover will not close when clicking outside or pressing escape. |
| `defaultOpen` |  | `boolean`  The open state of the popover when it is initially rendered. Use when you do not need to control its open state. |
| `open` |  | `boolean`  The controlled open state of the popover. |
| `modal` | `false` | `boolean`  The modality of the popover. When set to true, interaction with outside elements will be disabled and only popover content will be visible to screen readers. |
| `openDelay` | `0` | ` number`  The duration from when the mouse enters the trigger until the hover card opens. |
| `closeDelay` | `0` | ` number`  The duration from when the mouse leaves the trigger or content until the hover card closes. |
| `ui` |  | ` { content?: ClassNameValue; arrow?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{ open: boolean; }` |
| `content` | `SlotProps<M>` |
| `anchor` | `SlotProps<M>` |

The `close` function is only available when `mode` is set to `click` because Reka UI exposes this for [`Popover`](https://reka-ui.com/docs/components/popover#close-using-slot-props) but not for [`HoverCard`](https://reka-ui.com/docs/components/hover-card).

### Emits

| Event | Type |
| --- | --- |
| `close:prevent` | `[]` |
| `update:open` | `[value: boolean]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    popover: {

      slots: {

        content: 'bg-default shadow-lg rounded-md ring ring-default data-[state=open]:animate-[scale-in_100ms_ease-out] data-[state=closed]:animate-[scale-out_100ms_ease-in] origin-(--reka-popover-content-transform-origin) focus:outline-none pointer-events-auto',

        arrow: 'fill-default'

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

        popover: {

          slots: {

            content: 'bg-default shadow-lg rounded-md ring ring-default data-[state=open]:animate-[scale-in_100ms_ease-out] data-[state=closed]:animate-[scale-out_100ms_ease-in] origin-(--reka-popover-content-transform-origin) focus:outline-none pointer-events-auto',

            arrow: 'fill-default'

          }

        }

      }

    })

  ]

})
```

## Changelog

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`53c65`](https://github.com/nuxt/ui/commit/53c65089370d975ed30b2a21dd274c1acb73fcc6) — feat: add `close` method in slots ([#5176](https://github.com/nuxt/ui/issues/5176))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`b00e0`](https://github.com/nuxt/ui/commit/b00e07f13df34fa528d6349e0172845c37ab8906) — feat: add `reference` prop

[`150b3`](https://github.com/nuxt/ui/commit/150b334b1d242c6dc132193e23359c03e6f35666) — fix: don't emit `close:prevent` on `closeAutoFocus`

[`47351`](https://github.com/nuxt/ui/commit/473513c2460d4329d7d2e0a0ea69bf1310a072d1) — feat: add `anchor` slot ([#4119](https://github.com/nuxt/ui/issues/4119))

[`f4864`](https://github.com/nuxt/ui/commit/f4864233812eac0ed37e0a2d076a95c285a22c01) — feat: add `close:prevent` event ([#3958](https://github.com/nuxt/ui/issues/3958))

[`29fa4`](https://github.com/nuxt/ui/commit/29fa46276d6bf69b5b87880c476c6f778c2820bf) — feat: add global `portal` prop ([#3688](https://github.com/nuxt/ui/issues/3688))

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`01d8d`](https://github.com/nuxt/ui/commit/01d8dc72adb0b32ad68bb4a98bf24b17f435a89c) — fix: respect `transform-origin` in popper content ([#3919](https://github.com/nuxt/ui/issues/3919))

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`5dec0`](https://github.com/nuxt/ui/commit/5dec0e16e28549b8833aaab17a87fada63d6598c) — feat: handle events in `content` prop[Modal](https://ui.nuxt.com/docs/components/modal)

[

A dialog window that can be used to display a message or request user input.

](https://ui.nuxt.com/docs/components/modal)[

Slideover

A dialog that slides in from any side of the screen.

](https://ui.nuxt.com/docs/components/slideover)