---
title: "Vue Header Component"
source: "https://ui.nuxt.com/docs/components/header"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A responsive header component."
tags:
---
## Usage

The Header component renders a `<header>` element.

Its height is defined through a `--ui-header-height` CSS variable.

Use the `left`, `default` and `right` slots to customize the header and the `body` or `content` slots to customize the header menu.

In this example, we use the [NavigationMenu](https://ui.nuxt.com/docs/components/navigation-menu) component to render the header links in the center.

Use the `title` prop to change the title of the header. Defaults to `Nuxt UI`.

You can also use the `title` slot to add your own logo.

You should still add the `title` prop to replace the default `aria-label` of the link.

### To

Use the `to` prop to change the link of the title. Defaults to `/`.

You can also use the `left` slot to override the link entirely.

### Mode

Use the `mode` prop to change the mode of the header menu. Defaults to `modal`.

Use the `body` slot to fill the menu body (under the header) or the `content` slot to fill the entire menu.

You can use the `menu` prop to customize the menu of the header, it will adapt depending on the mode you choose.

```
<script setup lang="ts">

import type { NavigationMenuItem } from '@nuxt/ui'

const route = useRoute()

const items = computed<NavigationMenuItem[]>(() => [{

  label: 'Docs',

  to: '/docs/getting-started',

  icon: 'i-lucide-book-open',

  active: route.path.startsWith('/docs/getting-started')

}, {

  label: 'Components',

  to: '/docs/components',

  icon: 'i-lucide-box',

  active: route.path.startsWith('/docs/components')

}, {

  label: 'Figma',

  icon: 'i-simple-icons-figma',

  to: 'https://go.nuxt.com/figma-ui',

  target: '_blank'

}, {

  label: 'Releases',

  icon: 'i-lucide-rocket',

  to: 'https://github.com/nuxt/ui/releases',

  target: '_blank'

}])

</script>

<template>

  <UHeader>

    <template #title>

      <Logo class="h-6 w-auto" />

    </template>

    <UNavigationMenu :items="items" />

    <template #right>

      <UColorModeButton />

      <UTooltip text="Open on GitHub" :kbds="['meta', 'G']">

        <UButton

          color="neutral"

          variant="ghost"

          to="https://github.com/nuxt/ui"

          target="_blank"

          icon="i-simple-icons-github"

          aria-label="GitHub"

        />

      </UTooltip>

    </template>

    <template #body>

      <UNavigationMenu :items="items" orientation="vertical" class="-mx-2.5" />

    </template>

  </UHeader>

</template>
```

### Toggle

Use the `toggle` prop to customize the toggle button displayed on mobile.

You can pass any property from the [Button](https://ui.nuxt.com/docs/components/button) component to customize it.

```
<script setup lang="ts">

import type { NavigationMenuItem } from '@nuxt/ui'

const route = useRoute()

const items = computed<NavigationMenuItem[]>(() => [{

  label: 'Docs',

  to: '/docs/getting-started',

  icon: 'i-lucide-book-open',

  active: route.path.startsWith('/docs/getting-started')

}, {

  label: 'Components',

  to: '/docs/components',

  icon: 'i-lucide-box',

  active: route.path.startsWith('/docs/components')

}, {

  label: 'Figma',

  icon: 'i-simple-icons-figma',

  to: 'https://go.nuxt.com/figma-ui',

  target: '_blank'

}, {

  label: 'Releases',

  icon: 'i-lucide-rocket',

  to: 'https://github.com/nuxt/ui/releases',

  target: '_blank'

}])

</script>

<template>

  <UHeader

    :toggle="{

      color: 'primary',

      variant: 'subtle',

      class: 'rounded-full'

    }"

  >

    <template #title>

      <Logo class="h-6 w-auto" />

    </template>

    <UNavigationMenu :items="items" />

    <template #right>

      <UColorModeButton />

      <UTooltip text="Open on GitHub" :kbds="['meta', 'G']">

        <UButton

          color="neutral"

          variant="ghost"

          to="https://github.com/nuxt/ui"

          target="_blank"

          icon="i-simple-icons-github"

          aria-label="GitHub"

        />

      </UTooltip>

    </template>

    <template #body>

      <UNavigationMenu :items="items" orientation="vertical" class="-mx-2.5" />

    </template>

  </UHeader>

</template>
```

### Toggle Side

Use the `toggle-side` prop to change the side of the toggle button. Defaults to `right`.

```
<script setup lang="ts">

import type { NavigationMenuItem } from '@nuxt/ui'

const route = useRoute()

const items = computed<NavigationMenuItem[]>(() => [{

  label: 'Docs',

  to: '/docs/getting-started',

  icon: 'i-lucide-book-open',

  active: route.path.startsWith('/docs/getting-started')

}, {

  label: 'Components',

  to: '/docs/components',

  icon: 'i-lucide-box',

  active: route.path.startsWith('/docs/components')

}, {

  label: 'Figma',

  icon: 'i-simple-icons-figma',

  to: 'https://go.nuxt.com/figma-ui',

  target: '_blank'

}, {

  label: 'Releases',

  icon: 'i-lucide-rocket',

  to: 'https://github.com/nuxt/ui/releases',

  target: '_blank'

}])

</script>

<template>

  <UHeader toggle-side="left">

    <template #title>

      <Logo class="h-6 w-auto" />

    </template>

    <UNavigationMenu :items="items" />

    <template #right>

      <UColorModeButton />

      <UTooltip text="Open on GitHub" :kbds="['meta', 'G']">

        <UButton

          color="neutral"

          variant="ghost"

          to="https://github.com/nuxt/ui"

          target="_blank"

          icon="i-simple-icons-github"

          aria-label="GitHub"

        />

      </UTooltip>

    </template>

    <template #body>

      <UNavigationMenu :items="items" orientation="vertical" class="-mx-2.5" />

    </template>

  </UHeader>

</template>
```

## Examples

### Within app.vue

Use the Header component in your `app.vue` or in a layout:

app.vue

```
<script setup lang="ts">

import type { NavigationMenuItem } from '@nuxt/ui'

const route = useRoute()

const items = computed<NavigationMenuItem[]>(() => [{

  label: 'Docs',

  to: '/docs/getting-started',

  active: route.path.startsWith('/docs/getting-started')

}, {

  label: 'Components',

  to: '/docs/components',

  active: route.path.startsWith('/docs/components')

}, {

  label: 'Figma',

  to: 'https://go.nuxt.com/figma-ui',

  target: '_blank'

}, {

  label: 'Releases',

  to: 'https://github.com/nuxt/ui/releases',

  target: '_blank'

}])

</script>

<template>

  <UApp>

    <UHeader>

      <template #title>

        <Logo class="h-6 w-auto" />

      </template>

      <UNavigationMenu :items="items" />

      <template #right>

        <UColorModeButton />

        <UButton

          color="neutral"

          variant="ghost"

          to="https://github.com/nuxt/ui"

          target="_blank"

          icon="i-simple-icons-github"

          aria-label="GitHub"

        />

      </template>

      <template #body>

        <UNavigationMenu :items="items" orientation="vertical" class="-mx-2.5" />

      </template>

    </UHeader>

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
| `as` | `'header'` | `any`  The element or component this component should render as. |
| `title` | `'Nuxt UI'` | ` string` |
| `to` | `'/'` | ` string` |
| `mode` | `'modal'` | ` T` |
| `menu` |  | ` HeaderMenu<T>` |
| `toggle` | `true` | `boolean \| Omit<ButtonProps, LinkPropsKeys>`  Customize the toggle button to open the header menu displayed when the `content` slot is used.`{ color: 'neutral', variant: 'ghost' }` |
| `toggleSide` | `'right'` | ` "left" \| "right"`  The side to render the toggle button on. |
| `open` | `false` | `boolean` |
| `ui` |  | ` { root?: ClassNameValue; container?: ClassNameValue; left?: ClassNameValue; center?: ClassNameValue; right?: ClassNameValue; title?: ClassNameValue; toggle?: ClassNameValue; content?: ClassNameValue; overlay?: ClassNameValue; header?: ClassNameValue; body?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `title` | `{}` |
| `left` | `{}` |
| `default` | `{}` |
| `right` | `{}` |
| `toggle` | `{ open: boolean; toggle: () => void; ui: object; }` |
| `top` | `{}` |
| `bottom` | `{}` |
| `body` | `{}` |
| `content` | `{ close?: (() => void) \| undefined; }` |

### Emits

| Event | Type |
| --- | --- |
| `update:open` | `[value: boolean]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    header: {

      slots: {

        root: 'bg-default/75 backdrop-blur border-b border-default h-(--ui-header-height) sticky top-0 z-50',

        container: 'flex items-center justify-between gap-3 h-full',

        left: 'lg:flex-1 flex items-center gap-1.5',

        center: 'hidden lg:flex',

        right: 'flex items-center justify-end lg:flex-1 gap-1.5',

        title: 'shrink-0 font-bold text-xl text-highlighted flex items-end gap-1.5',

        toggle: 'lg:hidden',

        content: 'lg:hidden',

        overlay: 'lg:hidden',

        header: 'px-4 sm:px-6 h-(--ui-header-height) shrink-0 flex items-center justify-between gap-3',

        body: 'p-4 sm:p-6 overflow-y-auto'

      },

      variants: {

        toggleSide: {

          left: {

            toggle: '-ms-1.5'

          },

          right: {

            toggle: '-me-1.5'

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

        header: {

          slots: {

            root: 'bg-default/75 backdrop-blur border-b border-default h-(--ui-header-height) sticky top-0 z-50',

            container: 'flex items-center justify-between gap-3 h-full',

            left: 'lg:flex-1 flex items-center gap-1.5',

            center: 'hidden lg:flex',

            right: 'flex items-center justify-end lg:flex-1 gap-1.5',

            title: 'shrink-0 font-bold text-xl text-highlighted flex items-end gap-1.5',

            toggle: 'lg:hidden',

            content: 'lg:hidden',

            overlay: 'lg:hidden',

            header: 'px-4 sm:px-6 h-(--ui-header-height) shrink-0 flex items-center justify-between gap-3',

            body: 'p-4 sm:p-6 overflow-y-auto'

          },

          variants: {

            toggleSide: {

              left: {

                toggle: '-ms-1.5'

              },

              right: {

                toggle: '-me-1.5'

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

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components