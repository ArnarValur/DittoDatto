---
title: "Vue ChangelogVersions Component"
source: "https://ui.nuxt.com/docs/components/changelog-versions"
author:
  - "[[Nuxt UI]]"
published: 2025-04-27
created: 2026-01-28
description: "Display a list of changelog versions in a timeline."
tags:
---
## ChangelogVersions

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/ChangelogVersions.vue)

Display a list of changelog versions in a timeline.

## Usage

The ChangelogVersions component provides a flexible layout to display a list of [ChangelogVersion](https://ui.nuxt.com/docs/components/changelog-version) components using either the default slot or the `versions` prop.

```
<template>

  <UChangelogVersions>

    <UChangelogVersion

      v-for="(version, index) in versions"

      :key="index"

      v-bind="version"

    />

  </UChangelogVersions>

</template>
```

### Versions

Use the `versions` prop as an array of objects with the properties of the [ChangelogVersion](https://ui.nuxt.com/docs/components/changelog-version#props) component.

## Nuxt 3.17

Nuxt 3.17 is out - bringing a major reworking of the async data layer, a new built-in component, better warnings, and performance improvements!

![Nuxt 3.17](https://nuxt.com/assets/blog/v3.17.png)

## Nuxt 3.16

Nuxt 3.16 is out - packed with features and performance improvements!

![Nuxt 3.16](https://nuxt.com/assets/blog/v3.16.png)

## Nuxt 3.15

Nuxt 3.15 is out - with Vite 6, better HMR and faster performance!

![Nuxt 3.15](https://nuxt.com/assets/blog/v3.15.png)

```
<script setup lang="ts">

import type { ChangelogVersionProps } from '@nuxt/ui'

const versions = ref<ChangelogVersionProps[]>([

  {

    title: 'Nuxt 3.17',

    description: 'Nuxt 3.17 is out - bringing a major reworking of the async data layer, a new built-in component, better warnings, and performance improvements!',

    image: 'https://nuxt.com/assets/blog/v3.17.png',

    date: '2025-04-27',

    to: 'https://nuxt.com/blog/v3-17',

    target: '_blank',

    ui: {

      container: 'max-w-lg'

    }

  },

  {

    title: 'Nuxt 3.16',

    description: 'Nuxt 3.16 is out - packed with features and performance improvements!',

    image: 'https://nuxt.com/assets/blog/v3.16.png',

    date: '2025-03-07',

    to: 'https://nuxt.com/blog/v3-16',

    target: '_blank',

    ui: {

      container: 'max-w-lg'

    }

  },

  {

    title: 'Nuxt 3.15',

    description: 'Nuxt 3.15 is out - with Vite 6, better HMR and faster performance!',

    image: 'https://nuxt.com/assets/blog/v3.15.png',

    date: '2024-12-24',

    to: 'https://nuxt.com/blog/v3-15',

    target: '_blank',

    ui: {

      container: 'max-w-lg'

    }

  }

])

</script>

<template>

  <UChangelogVersions :versions="versions" />

</template>
```

### Indicator

Use the `indicator` prop to hide the indicator bar on the left. Defaults to `true`.

## Nuxt 3.17

Nuxt 3.17 is out - bringing a major reworking of the async data layer, a new built-in component, better warnings, and performance improvements!

![Nuxt 3.17](https://nuxt.com/assets/blog/v3.17.png)

## Nuxt 3.16

Nuxt 3.16 is out - packed with features and performance improvements!

![Nuxt 3.16](https://nuxt.com/assets/blog/v3.16.png)

## Nuxt 3.15

Nuxt 3.15 is out - with Vite 6, better HMR and faster performance!

![Nuxt 3.15](https://nuxt.com/assets/blog/v3.15.png)

```
<script setup lang="ts">

import type { ChangelogVersionProps } from '@nuxt/ui'

const versions = ref<ChangelogVersionProps[]>([

  {

    title: 'Nuxt 3.17',

    description: 'Nuxt 3.17 is out - bringing a major reworking of the async data layer, a new built-in component, better warnings, and performance improvements!',

    image: 'https://nuxt.com/assets/blog/v3.17.png',

    date: '2025-04-27',

    to: 'https://nuxt.com/blog/v3-17',

    target: '_blank',

    ui: {

      container: 'max-w-lg'

    }

  },

  {

    title: 'Nuxt 3.16',

    description: 'Nuxt 3.16 is out - packed with features and performance improvements!',

    image: 'https://nuxt.com/assets/blog/v3.16.png',

    date: '2025-03-07',

    to: 'https://nuxt.com/blog/v3-16',

    target: '_blank',

    ui: {

      container: 'max-w-lg'

    }

  },

  {

    title: 'Nuxt 3.15',

    description: 'Nuxt 3.15 is out - with Vite 6, better HMR and faster performance!',

    image: 'https://nuxt.com/assets/blog/v3.15.png',

    date: '2024-12-24',

    to: 'https://nuxt.com/blog/v3-15',

    target: '_blank',

    ui: {

      container: 'max-w-lg'

    }

  }

])

</script>

<template>

  <UChangelogVersions :indicator="false" :versions="versions" />

</template>
```

### Indicator Motion

Use the `indicator-motion` prop to customize or hide the motion effect on the indicator bar. Defaults to `true` with `{ damping: 30, restDelta: 0.001 }` [spring transition options](https://motion.dev/docs/vue-transitions#spring).

## Nuxt 3.17

Nuxt 3.17 is out - bringing a major reworking of the async data layer, a new built-in component, better warnings, and performance improvements!

![Nuxt 3.17](https://nuxt.com/assets/blog/v3.17.png)

## Nuxt 3.16

Nuxt 3.16 is out - packed with features and performance improvements!

![Nuxt 3.16](https://nuxt.com/assets/blog/v3.16.png)

## Nuxt 3.15

Nuxt 3.15 is out - with Vite 6, better HMR and faster performance!

![Nuxt 3.15](https://nuxt.com/assets/blog/v3.15.png)

```
<script setup lang="ts">

import type { ChangelogVersionProps } from '@nuxt/ui'

const versions = ref<ChangelogVersionProps[]>([

  {

    title: 'Nuxt 3.17',

    description: 'Nuxt 3.17 is out - bringing a major reworking of the async data layer, a new built-in component, better warnings, and performance improvements!',

    image: 'https://nuxt.com/assets/blog/v3.17.png',

    date: '2025-04-27',

    to: 'https://nuxt.com/blog/v3-17',

    target: '_blank',

    ui: {

      container: 'max-w-lg'

    }

  },

  {

    title: 'Nuxt 3.16',

    description: 'Nuxt 3.16 is out - packed with features and performance improvements!',

    image: 'https://nuxt.com/assets/blog/v3.16.png',

    date: '2025-03-07',

    to: 'https://nuxt.com/blog/v3-16',

    target: '_blank',

    ui: {

      container: 'max-w-lg'

    }

  },

  {

    title: 'Nuxt 3.15',

    description: 'Nuxt 3.15 is out - with Vite 6, better HMR and faster performance!',

    image: 'https://nuxt.com/assets/blog/v3.15.png',

    date: '2024-12-24',

    to: 'https://nuxt.com/blog/v3-15',

    target: '_blank',

    ui: {

      container: 'max-w-lg'

    }

  }

])

</script>

<template>

  <UChangelogVersions :versions="versions" />

</template>
```

## Examples

While these examples use [Nuxt Content](https://content.nuxt.com/), the components can be integrated with any content management system.

### Within a page

Use the ChangelogVersions component in a page to create a changelog page:

pages/changelog.vue

```
<script setup lang="ts">

const { data: versions } = await useAsyncData('versions', () => queryCollection('versions').all())

</script>

<template>

  <UPage>

    <UPageHero title="Changelog" />

    <UPageBody>

      <UChangelogVersions>

        <UChangelogVersion

          v-for="(version, index) in versions"

          :key="index"

          v-bind="version"

          :to="version.path"

        />

      </UChangelogVersions>

    </UPageBody>

  </UPage>

</template>
```

In this example, the `versions` are fetched using `queryCollection` from the `@nuxt/content` module.

The `to` prop is overridden here since `@nuxt/content` uses the `path` property.

### With sticky indicator

You can use the `ui` prop and the different slots to make the indicators sticky:

## Nuxt 3.17

Nuxt 3.17 is out - bringing a major reworking of the async data layer, a new built-in component, better warnings, and performance improvements!

![Nuxt 3.17](https://nuxt.com/assets/blog/v3.17.png)

Daniel Roe

## Nuxt 3.16

Nuxt 3.16 is out - packed with features and performance improvements!

![Nuxt 3.16](https://nuxt.com/assets/blog/v3.16.png)

Daniel Roe

## Nuxt 3.15

Nuxt 3.15 is out - with Vite 6, better HMR and faster performance!

![Nuxt 3.15](https://nuxt.com/assets/blog/v3.15.png)

Daniel Roe

```
<script setup lang="ts">

const versions = [

  {

    title: 'Nuxt 3.17',

    description:

      'Nuxt 3.17 is out - bringing a major reworking of the async data layer, a new built-in component, better warnings, and performance improvements!',

    date: '2025-04-27T00:00:00.000Z',

    image: 'https://nuxt.com/assets/blog/v3.17.png',

    badge: 'v3.17.0',

    to: 'https://nuxt.com/blog/nuxt-3-17',

    target: '_blank',

    authors: [

      {

        name: 'Daniel Roe',

        avatar: {

          src: 'https://github.com/danielroe.png',

          alt: 'Daniel Roe'

        },

        to: 'https://github.com/danielroe',

        target: '_blank'

      }

    ]

  },

  {

    title: 'Nuxt 3.16',

    description: 'Nuxt 3.16 is out - packed with features and performance improvements!',

    date: '2024-03-07T00:00:00.000Z',

    image: 'https://nuxt.com/assets/blog/v3.16.png',

    badge: 'v3.16.0',

    to: 'https://nuxt.com/blog/v3-16',

    target: '_blank',

    authors: [

      {

        name: 'Daniel Roe',

        avatar: {

          src: 'https://github.com/danielroe.png',

          alt: 'Daniel Roe'

        },

        to: 'https://github.com/danielroe',

        target: '_blank'

      }

    ]

  },

  {

    title: 'Nuxt 3.15',

    description: 'Nuxt 3.15 is out - with Vite 6, better HMR and faster performance!',

    date: '2024-12-24T00:00:00.000Z',

    image: 'https://nuxt.com/assets/blog/v3.15.png',

    badge: 'v3.15.0',

    to: 'https://nuxt.com/blog/v3-15',

    target: '_blank',

    authors: [

      {

        name: 'Daniel Roe',

        avatar: {

          src: 'https://github.com/danielroe.png',

          alt: 'Daniel Roe'

        },

        to: 'https://github.com/danielroe',

        target: '_blank'

      }

    ]

  }

]

</script>

<template>

  <UChangelogVersions :indicator="false">

    <UChangelogVersion

      v-for="version in versions"

      :key="version.title"

      v-bind="version"

      :badge="undefined"

      class="flex items-start"

      :ui="{

        container: 'max-w-lg me-0',

        indicator: 'sticky top-(--ui-header-height) pt-4 -mt-4 flex flex-col items-end'

      }"

    >

      <template #indicator>

        <UBadge :label="version.badge" variant="soft" />

        <span class="text-sm text-muted">{{

          new Date(version.date).toLocaleDateString('en-US', {

            year: 'numeric',

            month: 'short',

            day: 'numeric'

          })

        }}</span>

      </template>

    </UChangelogVersion>

  </UChangelogVersions>

</template>
```

### With scroll container 4.4+

Pass an object to the `indicator` prop to configure the scroll container. By default, the indicator tracks the window/page scroll ([https://motion.dev/docs/vue-use-scroll#page-scroll](https://motion.dev/docs/vue-use-scroll#page-scroll)).

```
<script setup lang="ts">

const scrollContainer = ref<HTMLElement>()

</script>

<template>

  <div ref="scrollContainer" class="max-h-96 overflow-y-auto">

    <UChangelogVersions v-if="scrollContainer" :indicator="{ container: scrollContainer }" />

  </div>

</template>
```

When using a custom `container`, make sure the container element is mounted before `UChangelogVersions`.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `versions` |  | ` T[]` |
| `indicator` | `true` | `boolean \| UseScrollOptions`  Display an indicator bar on the left. By default, the indicator will track the scroll of the page. ([https://motion.dev/docs/vue-use-scroll#page-scroll](https://motion.dev/docs/vue-use-scroll#page-scroll))  - [https://motion.dev/docs/vue-use-scroll#api](https://motion.dev/docs/vue-use-scroll#api) |
| `indicatorMotion` | `true` | `boolean \| SpringOptions`  Enable scrolling motion effect on the indicator bar.`{ damping: 30, restDelta: 0.001 }`  - [https://motion.dev/docs/vue-transitions#spring](https://motion.dev/docs/vue-transitions#spring) |
| `ui` |  | ` { root?: ClassNameValue; container?: ClassNameValue; indicator?: ClassNameValue; beam?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `header` | `{ version: T; }` |
| `badge` | `{ ui: object; } & { version: T; }` |
| `date` | `{ version: T; }` |
| `title` | `{ version: T; }` |
| `description` | `{ version: T; }` |
| `image` | `{ ui: object; } & { version: T; }` |
| `body` | `{ version: T; }` |
| `footer` | `{ version: T; }` |
| `authors` | `{ version: T; }` |
| `actions` | `{ version: T; }` |
| `indicator` | `{ ui: object; } & { version: T; }` |
| `default` | `{}` |

You can use all the slots of the [`ChangelogVersion`](https://ui.nuxt.com/docs/components/changelog-version#slots) component inside ChangelogVersions, they are automatically forwarded allowing you to customize individual versions when using the `versions` prop.

```
<template>

  <UChangelogVersions :versions="versions">

    <template #body="{ version }">

      <MDC v-if="version.content" :value="version.content" />

    </template>

  </UChangelogVersions>

</template>
```

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    changelogVersions: {

      slots: {

        root: 'relative',

        container: 'flex flex-col gap-y-8 sm:gap-y-12 lg:gap-y-16',

        indicator: 'absolute hidden lg:block overflow-hidden inset-y-3 start-32 h-full w-px bg-border -ms-[8.5px]',

        beam: 'absolute start-0 top-0 w-full bg-primary will-change-[height]'

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

        changelogVersions: {

          slots: {

            root: 'relative',

            container: 'flex flex-col gap-y-8 sm:gap-y-12 lg:gap-y-16',

            indicator: 'absolute hidden lg:block overflow-hidden inset-y-3 start-32 h-full w-px bg-border -ms-[8.5px]',

            beam: 'absolute start-0 top-0 w-full bg-primary will-change-[height]'

          }

        }

      }

    })

  ]

})
```

## Changelog

[`6a925`](https://github.com/nuxt/ui/commit/6a925cd4e51bca482d1638eca72bafaf2cddca72) — feat: handle scroll options in `indicator` prop ([#5257](https://github.com/nuxt/ui/issues/5257))

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`3173b`](https://github.com/nuxt/ui/commit/3173bee38ce9e518076848999f14374600069d35) — fix: proxySlots reactivity ([#4969](https://github.com/nuxt/ui/issues/4969))

[`f91c4`](https://github.com/nuxt/ui/commit/f91c4081e5d6b884fc7dd8c5669fd262ddb98649) — fix: handle RTL mode ([#4777](https://github.com/nuxt/ui/issues/4777))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[ChangelogVersion](https://ui.nuxt.com/docs/components/changelog-version)

[

A customizable article to display in a changelog.

](https://ui.nuxt.com/docs/components/changelog-version)[

Page

A grid layout for your pages with left and right columns.

](https://ui.nuxt.com/docs/components/page)