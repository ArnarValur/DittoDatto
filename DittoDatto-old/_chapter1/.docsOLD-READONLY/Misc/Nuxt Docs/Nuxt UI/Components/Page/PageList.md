---
title: "Vue PageList Component"
source: "https://ui.nuxt.com/docs/components/page-list"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A vertical list layout for displaying content in a stacked format."
tags:
---
## PageList

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/PageList.vue)

A vertical list layout for displaying content in a stacked format.

## Usage

The PageList component provides a flexible way to display content in a vertical list layout. It's perfect for creating stacked lists of [PageCard](https://ui.nuxt.com/docs/components/page-card) components or any other elements, with optional dividers between items.

```
<script setup lang="ts">

const users = ref([

  {

    name: 'Benjamin Canac',

    description: 'benjamincanac',

    to: 'https://github.com/benjamincanac',

    target: '_blank',

    avatar: {

      src: 'https://github.com/benjamincanac.png',

      alt: 'benjamincanac'

    }

  },

  {

    name: 'Romain Hamel',

    description: 'romhml',

    to: 'https://github.com/romhml',

    target: '_blank',

    avatar: {

      src: 'https://github.com/romhml.png',

      alt: 'romhml'

    }

  },

  {

    name: 'Sébastien Chopin',

    description: 'atinux',

    to: 'https://github.com/atinux',

    target: '_blank',

    avatar: {

      src: 'https://github.com/atinux.png',

      alt: 'atinux'

    }

  },

  {

    name: 'Hugo Richard',

    description: 'HugoRCD',

    to: 'https://github.com/HugoRCD',

    target: '_blank',

    avatar: {

      src: 'https://github.com/HugoRCD.png',

      alt: 'HugoRCD'

    }

  },

  {

    name: 'Sandro Circi',

    description: 'sandros94',

    to: 'https://github.com/sandros94',

    target: '_blank',

    avatar: {

      src: 'https://github.com/sandros94.png',

      alt: 'sandros94'

    }

  },

  {

    name: 'Daniel Roe',

    description: 'danielroe',

    to: 'https://github.com/danielroe',

    target: '_blank',

    avatar: {

      src: 'https://github.com/danielroe.png',

      alt: 'danielroe'

    }

  },

  {

    name: 'Jakub Michálek',

    description: 'J-Michalek',

    to: 'https://github.com/J-Michalek',

    target: '_blank',

    avatar: {

      src: 'https://github.com/J-Michalek.png',

      alt: 'J-Michalek'

    }

  },

  {

    name: 'Eugen Istoc',

    description: 'genu',

    to: 'https://github.com/genu',

    target: '_blank',

    avatar: {

      src: 'https://github.com/genu.png',

      alt: 'genu'

    }

  }

])

</script>

<template>

  <UPageList>

    <UPageCard

      v-for="(user, index) in users"

      :key="index"

      variant="ghost"

      :to="user.to"

      :target="user.target"

    >

      <template #body>

        <UUser :name="user.name" :description="user.description" :avatar="user.avatar" size="xl" class="relative" />

      </template>

    </UPageCard>

  </UPageList>

</template>
```

### Divide

Use the `divide` prop to add a divider between each child element.

```
<script setup lang="ts">

const users = ref([

  {

    name: 'Benjamin Canac',

    description: 'benjamincanac',

    to: 'https://github.com/benjamincanac',

    target: '_blank',

    avatar: {

      src: 'https://github.com/benjamincanac.png',

      alt: 'benjamincanac'

    }

  },

  {

    name: 'Romain Hamel',

    description: 'romhml',

    to: 'https://github.com/romhml',

    target: '_blank',

    avatar: {

      src: 'https://github.com/romhml.png',

      alt: 'romhml'

    }

  },

  {

    name: 'Sébastien Chopin',

    description: 'atinux',

    to: 'https://github.com/atinux',

    target: '_blank',

    avatar: {

      src: 'https://github.com/atinux.png',

      alt: 'atinux'

    }

  },

  {

    name: 'Hugo Richard',

    description: 'HugoRCD',

    to: 'https://github.com/HugoRCD',

    target: '_blank',

    avatar: {

      src: 'https://github.com/HugoRCD.png',

      alt: 'HugoRCD'

    }

  },

  {

    name: 'Sandro Circi',

    description: 'sandros94',

    to: 'https://github.com/sandros94',

    target: '_blank',

    avatar: {

      src: 'https://github.com/sandros94.png',

      alt: 'sandros94'

    }

  },

  {

    name: 'Daniel Roe',

    description: 'danielroe',

    to: 'https://github.com/danielroe',

    target: '_blank',

    avatar: {

      src: 'https://github.com/danielroe.png',

      alt: 'danielroe'

    }

  },

  {

    name: 'Jakub Michálek',

    description: 'J-Michalek',

    to: 'https://github.com/J-Michalek',

    target: '_blank',

    avatar: {

      src: 'https://github.com/J-Michalek.png',

      alt: 'J-Michalek'

    }

  },

  {

    name: 'Eugen Istoc',

    description: 'genu',

    to: 'https://github.com/genu',

    target: '_blank',

    avatar: {

      src: 'https://github.com/genu.png',

      alt: 'genu'

    }

  }

])

</script>

<template>

  <UPageList divide>

    <UPageCard

      v-for="(user, index) in users"

      :key="index"

      variant="ghost"

      :to="user.to"

      :target="user.target"

    >

      <template #body>

        <UUser :name="user.name" :description="user.description" :avatar="user.avatar" size="xl" />

      </template>

    </UPageCard>

  </UPageList>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `divide` | `false` | `boolean` |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    pageList: {

      base: 'relative flex flex-col',

      variants: {

        divide: {

          true: '*:not-last:after:absolute *:not-last:after:inset-x-1 *:not-last:after:bottom-0 *:not-last:after:bg-border *:not-last:after:h-px'

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

        pageList: {

          base: 'relative flex flex-col',

          variants: {

            divide: {

              true: '*:not-last:after:absolute *:not-last:after:inset-x-1 *:not-last:after:bottom-0 *:not-last:after:bg-border *:not-last:after:h-px'

            }

          }

        }

      }

    })

  ]

})
```

## Changelog

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[PageLinks](https://ui.nuxt.com/docs/components/page-links)

[

A list of links to be displayed in the page.

](https://ui.nuxt.com/docs/components/page-links)[

PageLogos

A list of logos or images to display on your pages.

](https://ui.nuxt.com/docs/components/page-logos)