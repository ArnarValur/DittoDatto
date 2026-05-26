---
title: "Vue Collapsible Component"
source: "https://ui.nuxt.com/docs/components/collapsible"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A collapsible element to toggle visibility of its content."
tags:
---
## Collapsible

[Collapsible](https://reka-ui.com/docs/components/collapsible) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Collapsible.vue)

A collapsible element to toggle visibility of its content.

## Usage

Use a [Button](https://ui.nuxt.com/docs/components/button) or any other component in the default slot of the Collapsible.

Then, use the `#content` slot to add the content displayed when the Collapsible is open.

```
<template>

  <UCollapsible class="flex flex-col gap-2 w-48">

    <UButton

      label="Open"

      color="neutral"

      variant="subtle"

      trailing-icon="i-lucide-chevron-down"

      block

    />

    <template #content>

      <Placeholder class="h-48" />

    </template>

  </UCollapsible>

</template>
```

### Unmount

Use the `unmount-on-hide` prop to prevent the content from being unmounted when the Collapsible is collapsed. Defaults to `true`.

```
<template>

  <UCollapsible :unmount-on-hide="false" class="flex flex-col gap-2 w-48">

    <UButton

      label="Open"

      color="neutral"

      variant="subtle"

      trailing-icon="i-lucide-chevron-down"

      block

    />

    <template #content>

      <Placeholder class="h-48" />

    </template>

  </UCollapsible>

</template>
```

You can inspect the DOM to see the content being rendered.

### Disabled

Use the `disabled` prop to disable the Collapsible.

```
<template>

  <UCollapsible class="flex flex-col gap-2 w-48" disabled>

    <UButton

      label="Open"

      color="neutral"

      variant="subtle"

      trailing-icon="i-lucide-chevron-down"

      block

    />

    <template #content>

      <Placeholder class="h-48" />

    </template>

  </UCollapsible>

</template>
```

## Examples

### Control open state

You can control the open state by using the `default-open` prop or the `v-model:open` directive.

```
<script setup lang="ts">

const open = ref(true)

defineShortcuts({

  o: () => open.value = !open.value

})

</script>

<template>

  <UCollapsible v-model:open="open" class="flex flex-col gap-2 w-48">

    <UButton

      label="Open"

      color="neutral"

      variant="subtle"

      trailing-icon="i-lucide-chevron-down"

      block

    />

    <template #content>

      <Placeholder class="h-48" />

    </template>

  </UCollapsible>

</template>
```

In this example, leveraging [`defineShortcuts`](https://ui.nuxt.com/docs/composables/define-shortcuts), you can toggle the Collapsible by pressing O.

This allows you to move the trigger outside of the Collapsible or remove it entirely.

### With rotating icon

Here is an example with a rotating icon in the Button that indicates the open state of the Collapsible.

```
<template>

  <UCollapsible class="flex flex-col gap-2 w-48">

    <UButton

      class="group"

      label="Open"

      color="neutral"

      variant="subtle"

      trailing-icon="i-lucide-chevron-down"

      :ui="{

        trailingIcon: 'group-data-[state=open]:rotate-180 transition-transform duration-200'

      }"

      block

    />

    <template #content>

      <Placeholder class="h-48" />

    </template>

  </UCollapsible>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `disabled` |  | `boolean`  When `true`, prevents the user from interacting with the collapsible. |
| `defaultOpen` |  | `boolean`  The open state of the collapsible when it is initially rendered.   Use when you do not need to control its open state. |
| `open` |  | `boolean`  The controlled open state of the collapsible. Can be binded with `v-model`. |
| `unmountOnHide` | `true` | `boolean`  When `true`, the element will be unmounted on closed state. |
| `ui` |  | ` { root?: ClassNameValue; content?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{ open: boolean; }` |
| `content` | `{}` |

### Emits

| Event | Type |
| --- | --- |
| `update:open` | `[value: boolean]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    collapsible: {

      slots: {

        root: '',

        content: 'data-[state=open]:animate-[collapsible-down_200ms_ease-out] data-[state=closed]:animate-[collapsible-up_200ms_ease-out] overflow-hidden'

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

        collapsible: {

          slots: {

            root: '',

            content: 'data-[state=open]:animate-[collapsible-down_200ms_ease-out] data-[state=closed]:animate-[collapsible-up_200ms_ease-out] overflow-hidden'

          }

        }

      }

    })

  ]

})
```

## Changelog

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))[Chip](https://ui.nuxt.com/docs/components/chip)

[

An indicator of a numeric value or a state.

](https://ui.nuxt.com/docs/components/chip)[

FieldGroup

Group multiple button-like elements together.

](https://ui.nuxt.com/docs/components/field-group)