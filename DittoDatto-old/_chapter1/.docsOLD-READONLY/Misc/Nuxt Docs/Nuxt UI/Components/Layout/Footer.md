---
title: "Vue Footer Component"
source: "https://ui.nuxt.com/docs/components/footer"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A responsive footer component."
tags:
---
## Usage

The Footer component renders a `<footer>` element.

Use the `left`, `default` and `right` slots to customize the footer.

In this example, we use the [NavigationMenu](https://ui.nuxt.com/docs/components/navigation-menu) component to render the footer links in the center.

You can use the `FooterColumns` component to display a list of links inside the `top` slot.

## Examples

### Within app.vue

Use the Footer component in your `app.vue` or in a layout:

app.vue

```
<script setup lang="ts">

import type { NavigationMenuItem } from '@nuxt/ui'

const items: NavigationMenuItem[] = [{

  label: 'Figma Kit',

  to: 'https://go.nuxt.com/figma-ui',

  target: '_blank'

}, {

  label: 'Playground',

  to: 'https://stackblitz.com/edit/nuxt-ui',

  target: '_blank'

}, {

  label: 'Releases',

  to: 'https://github.com/nuxt/ui/releases',

  target: '_blank'

}]

</script>

<template>

  <UApp>

    <UHeader />

    <UMain>

      <NuxtLayout>

        <NuxtPage />

      </NuxtLayout>

    </UMain>

    <USeparator icon="i-simple-icons-nuxtdotjs" type="dashed" class="h-px" />

    <UFooter>

      <template #left>

        <p class="text-muted text-sm">

          Copyright © {{ new Date().getFullYear() }}

        </p>

      </template>

      <UNavigationMenu :items="items" variant="link" />

      <template #right>

        <UButton

          icon="i-simple-icons-discord"

          color="neutral"

          variant="ghost"

          to="https://go.nuxt.com/discord"

          target="_blank"

          aria-label="Discord"

        />

        <UButton

          icon="i-simple-icons-x"

          color="neutral"

          variant="ghost"

          to="https://go.nuxt.com/x"

          target="_blank"

          aria-label="X"

        />

        <UButton

          icon="i-simple-icons-github"

          color="neutral"

          variant="ghost"

          to="https://github.com/nuxt/nuxt"

          target="_blank"

          aria-label="GitHub"

        />

      </template>

    </UFooter>

  </UApp>

</template>
```

In this example, we use the [Separator](https://ui.nuxt.com/docs/components/separator) component to add a border above the footer.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'footer'` | `any`  The element or component this component should render as. |
| `ui` |  | ` { root?: ClassNameValue; top?: ClassNameValue; bottom?: ClassNameValue; container?: ClassNameValue; left?: ClassNameValue; center?: ClassNameValue; right?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `left` | `{}` |
| `default` | `{}` |
| `right` | `{}` |
| `top` | `{}` |
| `bottom` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    footer: {

      slots: {

        root: '',

        top: 'py-8 lg:py-12',

        bottom: 'py-8 lg:py-12',

        container: 'py-8 lg:py-4 lg:flex lg:items-center lg:justify-between lg:gap-x-3',

        left: 'flex items-center justify-center lg:justify-start lg:flex-1 gap-x-1.5 mt-3 lg:mt-0 lg:order-1',

        center: 'mt-3 lg:mt-0 lg:order-2 flex items-center justify-center',

        right: 'lg:flex-1 flex items-center justify-center lg:justify-end gap-x-1.5 lg:order-3'

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

        footer: {

          slots: {

            root: '',

            top: 'py-8 lg:py-12',

            bottom: 'py-8 lg:py-12',

            container: 'py-8 lg:py-4 lg:flex lg:items-center lg:justify-between lg:gap-x-3',

            left: 'flex items-center justify-center lg:justify-start lg:flex-1 gap-x-1.5 mt-3 lg:mt-0 lg:order-1',

            center: 'mt-3 lg:mt-0 lg:order-2 flex items-center justify-center',

            right: 'lg:flex-1 flex items-center justify-center lg:justify-end gap-x-1.5 lg:order-3'

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