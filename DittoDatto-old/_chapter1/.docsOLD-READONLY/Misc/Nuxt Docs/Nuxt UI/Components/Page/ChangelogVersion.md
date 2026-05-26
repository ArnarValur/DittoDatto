---
title: "Vue ChangelogVersion Component"
source: "https://ui.nuxt.com/docs/components/changelog-version"
author:
  - "[[Nuxt UI]]"
published: 2025-03-12
created: 2026-01-28
description: "A customizable article to display in a changelog."
tags:
---
## ChangelogVersion

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/ChangelogVersion.vue)

A customizable article to display in a changelog.

## Usage

The ChangelogVersion component provides a flexible way to display an `<article>` element with customizable content including title, description, image, etc.

## Introducing Nuxt UI v3

Nuxt UI v3 is out! After 1500+ commits, this major redesign brings improved accessibility, Tailwind CSS support, and full Vue compatibility.

![Introducing Nuxt UI v3](https://nuxt.com/assets/blog/nuxt-ui-v3.png)

Use the `ChangelogVersions` component to display multiple changelog versions in a timeline with an indicator bar on the left.

Use the `title` prop to display the title of the ChangelogVersion.

## Introducing Nuxt UI v3

```
<template>

  <UChangelogVersion title="Introducing Nuxt UI v3" />

</template>
```

### Description

Use the `description` prop to display the description of the ChangelogVersion.

## Introducing Nuxt UI v3

Nuxt UI v3 is out! After 1500+ commits, this major redesign brings improved accessibility, Tailwind CSS support, and full Vue compatibility.

```
<template>

  <UChangelogVersion

    title="Introducing Nuxt UI v3"

    description="Nuxt UI v3 is out! After 1500+ commits, this major redesign brings improved accessibility, Tailwind CSS support, and full Vue compatibility."

  />

</template>
```

Use the `date` prop to display the date of the ChangelogVersion.

The date is automatically formatted to the [current locale](https://ui.nuxt.com/docs/getting-started/integrations/i18n/nuxt#locale). You can either pass a `Date` object or a string.

## Introducing Nuxt UI v3

Nuxt UI v3 is out! After 1500+ commits, this major redesign brings improved accessibility, Tailwind CSS support, and full Vue compatibility.

```
<template>

  <UChangelogVersion

    title="Introducing Nuxt UI v3"

    description="Nuxt UI v3 is out! After 1500+ commits, this major redesign brings improved accessibility, Tailwind CSS support, and full Vue compatibility."

    date="2025-03-12"

  />

</template>
```

### Badge

Use the `badge` prop to display a [Badge](https://ui.nuxt.com/docs/components/badge) on the ChangelogVersion.

Release

## Introducing Nuxt UI v3

Nuxt UI v3 is out! After 1500+ commits, this major redesign brings improved accessibility, Tailwind CSS support, and full Vue compatibility.

```
<template>

  <UChangelogVersion

    title="Introducing Nuxt UI v3"

    description="Nuxt UI v3 is out! After 1500+ commits, this major redesign brings improved accessibility, Tailwind CSS support, and full Vue compatibility."

    date="2025-03-12"

    badge="Release"

  />

</template>
```

You can pass any property from the [Badge](https://ui.nuxt.com/docs/components/badge#props) component to customize it.

Release

## Introducing Nuxt UI v3

Nuxt UI v3 is out! After 1500+ commits, this major redesign brings improved accessibility, Tailwind CSS support, and full Vue compatibility.

```
<template>

  <UChangelogVersion

    title="Introducing Nuxt UI v3"

    description="Nuxt UI v3 is out! After 1500+ commits, this major redesign brings improved accessibility, Tailwind CSS support, and full Vue compatibility."

    date="2025-03-12"

    :badge="{

      label: 'Release',

      color: 'primary',

      variant: 'outline'

    }"

  />

</template>
```

### Image

Use the `image` prop to display an image in the BlogPost.

If [`@nuxt/image`](https://image.nuxt.com/get-started/installation) is installed, the `<NuxtImg>` component will be used instead of the native `img` tag.

## Introducing Nuxt UI v3

Nuxt UI v3 is out! After 1500+ commits, this major redesign brings improved accessibility, Tailwind CSS support, and full Vue compatibility.

![Introducing Nuxt UI v3](https://nuxt.com/assets/blog/nuxt-ui-v3.png)

```
<template>

  <UChangelogVersion

    title="Introducing Nuxt UI v3"

    description="Nuxt UI v3 is out! After 1500+ commits, this major redesign brings improved accessibility, Tailwind CSS support, and full Vue compatibility."

    date="2025-03-12"

    image="https://nuxt.com/assets/blog/nuxt-ui-v3.png"

  />

</template>
```

Use the `authors` prop to display a list of [User](https://ui.nuxt.com/docs/components/user) in the ChangelogVersion as an array of objects with the following properties:

- `name?: string`
- `description?: string`
- `avatar?: Omit<AvatarProps, 'size'>`
- `chip?: boolean | Omit<ChipProps, 'size' | 'inset'>`
- `size?: UserProps['size']`
- `orientation?: UserProps['orientation']`

You can pass any property from the [Link](https://ui.nuxt.com/docs/components/link#props) component such as `to`, `target`, etc.

## Introducing Nuxt UI v3

Nuxt UI v3 is out! After 1500+ commits, this major redesign brings improved accessibility, Tailwind CSS support, and full Vue compatibility.

![Introducing Nuxt UI v3](https://nuxt.com/assets/blog/nuxt-ui-v3.png)

```
<script setup lang="ts">

import type { UserProps } from '@nuxt/ui'

const authors = ref<UserProps[]>([

  {

    name: 'Benjamin Canac',

    description: '@benjamincanac',

    avatar: {

      src: 'https://github.com/benjamincanac.png'

    },

    to: 'https://x.com/benjamincanac',

    target: '_blank'

  },

  {

    name: 'Sebastien Chopin',

    description: '@atinux',

    avatar: {

      src: 'https://github.com/atinux.png'

    },

    to: 'https://x.com/atinux',

    target: '_blank'

  },

  {

    name: 'Hugo Richard',

    description: '@hugorcd__',

    avatar: {

      src: 'https://github.com/hugorcd.png'

    },

    to: 'https://x.com/hugorcd__',

    target: '_blank'

  }

])

</script>

<template>

  <UChangelogVersion

    title="Introducing Nuxt UI v3"

    description="Nuxt UI v3 is out! After 1500+ commits, this major redesign brings improved accessibility, Tailwind CSS support, and full Vue compatibility."

    date="2025-03-12"

    image="https://nuxt.com/assets/blog/nuxt-ui-v3.png"

    :authors="authors"

  />

</template>
```

### Link

You can pass any property from the [`<NuxtLink>`](https://nuxt.com/docs/api/components/nuxt-link) component such as `to`, `target`, `rel`, etc.

## Introducing Nuxt UI v3

Nuxt UI v3 is out! After 1500+ commits, this major redesign brings improved accessibility, Tailwind CSS support, and full Vue compatibility.

![Introducing Nuxt UI v3](https://nuxt.com/assets/blog/nuxt-ui-v3.png)

```
<template>

  <UChangelogVersion

    title="Introducing Nuxt UI v3"

    description="Nuxt UI v3 is out! After 1500+ commits, this major redesign brings improved accessibility, Tailwind CSS support, and full Vue compatibility."

    date="2025-03-12"

    image="https://nuxt.com/assets/blog/nuxt-ui-v3.png"

    to="https://nuxt.com/blog/nuxt-ui-v3"

    target="_blank"

  />

</template>
```

### Indicator

Use the `indicator` prop to hide the indicator dot on the left. Defaults to `true`.

## Introducing Nuxt UI v3

Nuxt UI v3 is out! After 1500+ commits, this major redesign brings improved accessibility, Tailwind CSS support, and full Vue compatibility.

![Introducing Nuxt UI v3](https://nuxt.com/assets/blog/nuxt-ui-v3.png)

```
<template>

  <UChangelogVersion

    title="Introducing Nuxt UI v3"

    description="Nuxt UI v3 is out! After 1500+ commits, this major redesign brings improved accessibility, Tailwind CSS support, and full Vue compatibility."

    date="2025-03-12"

    image="https://nuxt.com/assets/blog/nuxt-ui-v3.png"

    :indicator="false"

  />

</template>
```

When the `indicator` prop is `false`, the date will be displayed over the title.

## Examples

### With body slot

You can use the `body` slot to display custom content between the image and the authors with:

- the [MDC](https://github.com/nuxt-modules/mdc?tab=readme-ov-file#mdc) component from `@nuxtjs/mdc` to display some markdown.
- the [ContentRenderer](https://content.nuxt.com/docs/components/content-renderer) component from `@nuxt/content` to render the content of the page or list.
- or use the `:u-changelog-version` component directly in your content with markdown inside the `body` slot as Nuxt UI provides pre-styled prose components.

Release

## Introducing Nuxt UI v3

Nuxt UI v3 is out! After 1500+ commits, this major redesign brings improved accessibility, Tailwind CSS support, and full Vue compatibility.

![Nuxt UI v3](https://nuxt.com/assets/blog/nuxt-ui-v3.png)

We are thrilled to introduce Nuxt UI v3, a comprehensive redesign of our UI library that delivers significant improvements in accessibility, performance, and developer experience. This major update represents over 1,500 commits of dedicated work, collaboration, and innovation from our team and the community.

Read the blog post announcement: [https://nuxt.com/blog/nuxt-ui-v3](https://nuxt.com/blog/nuxt-ui-v3)

**[Get started with Nuxt UI v3 →](https://ui3.nuxt.com/getting-started/installation/nuxt)**

### 🧩 Reka UI: A New Foundation

We've transitioned from [Headless UI](https://headlessui.com/) to [Reka UI](https://reka-ui.com/) as our core component foundation, bringing:

- **Expanded Component Library**: Access to 55+ primitives, significantly expanding our component offerings
- **Future-Proof Development**: Benefit from Reka UI's growing popularity and continuous improvements
- **First-Class Accessibility**: Built-in accessibility features aligned with our commitment to inclusive design

### 🚀 Tailwind CSS Integration

Nuxt UI now leverages the latest [Tailwind CSS](https://tailwindcss.com/), delivering:

- **Exceptional Performance**: Full builds up to 5× faster, with incremental builds over 100× faster
- **Streamlined Toolchain**: Built-in import handling, vendor prefixing, and syntax transforms with zero additional tooling
- **CSS-First Configuration**: Customize and extend the framework directly in CSS instead of JavaScript configuration

### 🎨 Tailwind Variants

We've adopted [Tailwind Variants](https://www.tailwind-variants.org/) to power our design system, offering:

- **Dynamic Styling**: Create flexible component variants with a powerful, intuitive API
- **Type Safety**: Full TypeScript support with intelligent auto-completion
- **Smart Conflict Resolution**: Efficiently merge conflicting styles with predictable results

## Migration from v2

We want to be transparent: migrating from Nuxt UI v2 to v3 requires significant effort. While we've maintained core concepts and components, Nuxt UI v3 has been rebuilt from the ground up to provide enhanced capabilities.

To upgrade your project:

1. Read our detailed [migration guide](https://ui3.nuxt.com/getting-started/migration)
2. Review the new documentation and components before attempting to upgrade
3. Report any issues on our [GitHub repository](https://github.com/nuxt/ui/issues)

## 🙏 Acknowledgements

This release represents thousands of hours of work from our team and the community. We'd like to thank everyone who contributed to making Nuxt UI v3 a reality, especially @romhml, @sandros94, and @hywax for their tremendous work.

Benjamin Canac

```
<script setup lang="ts">

const content = \`

![Nuxt UI v3](https://nuxt.com/assets/blog/nuxt-ui-v3.png)

We are thrilled to introduce Nuxt UI v3, a comprehensive redesign of our UI library that delivers significant improvements in accessibility, performance, and developer experience. This major update represents over 1,500 commits of dedicated work, collaboration, and innovation from our team and the community.

Read the blog post announcement: https://nuxt.com/blog/nuxt-ui-v3

**[Get started with Nuxt UI v3 →](https://ui3.nuxt.com/getting-started/installation/nuxt)**

### 🧩 Reka UI: A New Foundation

We've transitioned from [Headless UI](https://headlessui.com/) to [Reka UI](https://reka-ui.com/) as our core component foundation, bringing:

- **Expanded Component Library**: Access to 55+ primitives, significantly expanding our component offerings

- **Future-Proof Development**: Benefit from Reka UI's growing popularity and continuous improvements

- **First-Class Accessibility**: Built-in accessibility features aligned with our commitment to inclusive design

### 🚀 Tailwind CSS Integration

Nuxt UI now leverages the latest [Tailwind CSS](https://tailwindcss.com), delivering:

- **Exceptional Performance**: Full builds up to 5× faster, with incremental builds over 100× faster

- **Streamlined Toolchain**: Built-in import handling, vendor prefixing, and syntax transforms with zero additional tooling

- **CSS-First Configuration**: Customize and extend the framework directly in CSS instead of JavaScript configuration

### 🎨 Tailwind Variants

We've adopted [Tailwind Variants](https://www.tailwind-variants.org/) to power our design system, offering:

- **Dynamic Styling**: Create flexible component variants with a powerful, intuitive API

- **Type Safety**: Full TypeScript support with intelligent auto-completion

- **Smart Conflict Resolution**: Efficiently merge conflicting styles with predictable results

## Migration from v2

We want to be transparent: migrating from Nuxt UI v2 to v3 requires significant effort. While we've maintained core concepts and components, Nuxt UI v3 has been rebuilt from the ground up to provide enhanced capabilities.

To upgrade your project:

1. Read our detailed [migration guide](https://ui3.nuxt.com/getting-started/migration)

2. Review the new documentation and components before attempting to upgrade

3. Report any issues on our [GitHub repository](https://github.com/nuxt/ui/issues)

## 🙏 Acknowledgements

This release represents thousands of hours of work from our team and the community. We'd like to thank everyone who contributed to making Nuxt UI v3 a reality, especially @romhml, @sandros94, and @hywax for their tremendous work.

\`

const version = {

  title: 'Introducing Nuxt UI v3',

  description:

    'Nuxt UI v3 is out! After 1500+ commits, this major redesign brings improved accessibility, Tailwind CSS support, and full Vue compatibility.',

  date: '2025-03-12T00:00:00.000Z',

  badge: 'Release',

  to: 'https://nuxt.com/blog/nuxt-ui-v3',

  target: '_blank',

  content,

  authors: [

    {

      name: 'Benjamin Canac',

      avatar: {

        src: 'https://github.com/benjamincanac.png',

        alt: 'Benjamin Canac'

      },

      to: 'https://github.com/benjamincanac',

      target: '_blank'

    }

  ]

}

</script>

<template>

  <UChangelogVersion v-bind="version" :ui="{ container: 'max-w-lg' }" class="w-full">

    <template #body>

      <MDC :value="version.content" />

    </template>

  </UChangelogVersion>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'article'` | `any`  The element or component this component should render as. |
| `title` |  | ` string` |
| `description` |  | ` string` |
| `date` |  | ` string \| Date`  The date of the changelog version. Can be a string or a Date object. |
| `badge` |  | ` string \| BadgeProps`  Display a badge on the changelog version. Can be a string or an object.`{ color: 'neutral', variant: 'solid' }` |
| `authors` |  | ` UserProps[]`  The authors of the changelog version. |
| `image` |  | ` string \| Partial<HTMLImageElement> & { [key: string]: any; }`  The image of the changelog version. Can be a string or an object. |
| `indicator` | `true` | `boolean`  Display an indicator dot on the left. |
| `to` |  | ` string \| kt \| Tt` |
| `target` |  | ` null \| "_blank" \| "_parent" \| "_self" \| "_top" \| string & {}` |
| `ui` |  | ` { root?: ClassNameValue; container?: ClassNameValue; header?: ClassNameValue; meta?: ClassNameValue; date?: ClassNameValue; badge?: ClassNameValue; title?: ClassNameValue; description?: ClassNameValue; imageWrapper?: ClassNameValue; image?: ClassNameValue; authors?: ClassNameValue; footer?: ClassNameValue; indicator?: ClassNameValue; dot?: ClassNameValue; dotInner?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `header` | `{}` |
| `badge` | `{ ui: object; }` |
| `date` | `{}` |
| `title` | `{}` |
| `description` | `{}` |
| `image` | `{ ui: object; }` |
| `body` | `{}` |
| `footer` | `{}` |
| `authors` | `{}` |
| `actions` | `{}` |
| `indicator` | `{ ui: object; }` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    changelogVersion: {

      slots: {

        root: 'relative',

        container: 'flex flex-col mx-auto max-w-2xl',

        header: '',

        meta: 'flex items-center gap-3 mb-2',

        date: 'text-sm/6 text-toned truncate',

        badge: '',

        title: 'relative text-xl text-pretty font-semibold text-highlighted',

        description: 'text-base text-pretty text-muted mt-1',

        imageWrapper: 'relative overflow-hidden rounded-lg aspect-[16/9] mt-5 group/changelog-version-image',

        image: 'object-cover object-top w-full h-full',

        authors: 'flex flex-wrap gap-x-4 gap-y-1.5',

        footer: 'border-t border-default pt-5 flex items-center justify-between',

        indicator: 'absolute start-0 top-0 w-32 hidden lg:flex items-center justify-end gap-3 min-w-0',

        dot: 'size-4 rounded-full bg-default ring ring-default flex items-center justify-center my-1',

        dotInner: 'size-2 rounded-full bg-primary'

      },

      variants: {

        body: {

          false: {

            footer: 'mt-5'

          }

        },

        badge: {

          false: {

            meta: 'lg:hidden'

          }

        },

        to: {

          true: {

            title: [

              'has-focus-visible:ring-2 has-focus-visible:ring-primary rounded-xs',

              'transition'

            ],

            image: 'transform transition-transform duration-200 group-hover/changelog-version-image:scale-105 group-has-focus-visible/changelog-version-image:scale-105'

          }

        },

        hidden: {

          true: {

            date: 'lg:hidden'

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

        changelogVersion: {

          slots: {

            root: 'relative',

            container: 'flex flex-col mx-auto max-w-2xl',

            header: '',

            meta: 'flex items-center gap-3 mb-2',

            date: 'text-sm/6 text-toned truncate',

            badge: '',

            title: 'relative text-xl text-pretty font-semibold text-highlighted',

            description: 'text-base text-pretty text-muted mt-1',

            imageWrapper: 'relative overflow-hidden rounded-lg aspect-[16/9] mt-5 group/changelog-version-image',

            image: 'object-cover object-top w-full h-full',

            authors: 'flex flex-wrap gap-x-4 gap-y-1.5',

            footer: 'border-t border-default pt-5 flex items-center justify-between',

            indicator: 'absolute start-0 top-0 w-32 hidden lg:flex items-center justify-end gap-3 min-w-0',

            dot: 'size-4 rounded-full bg-default ring ring-default flex items-center justify-center my-1',

            dotInner: 'size-2 rounded-full bg-primary'

          },

          variants: {

            body: {

              false: {

                footer: 'mt-5'

              }

            },

            badge: {

              false: {

                meta: 'lg:hidden'

              }

            },

            to: {

              true: {

                title: [

                  'has-focus-visible:ring-2 has-focus-visible:ring-primary rounded-xs',

                  'transition'

                ],

                image: 'transform transition-transform duration-200 group-hover/changelog-version-image:scale-105 group-has-focus-visible/changelog-version-image:scale-105'

              }

            },

            hidden: {

              true: {

                date: 'lg:hidden'

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

[`6dd73`](https://github.com/nuxt/ui/commit/6dd731ce2879bb0a9914b61bd6a0134a5aca69e2) — chore: update nuxt framework to ^4.3.0 (v4) ([#5923](https://github.com/nuxt/ui/issues/5923))

[`47d93`](https://github.com/nuxt/ui/commit/47d93d31d99e893d71cf4e2e78265d54d2e561a2) — fix: allow tab focus

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`9632f`](https://github.com/nuxt/ui/commit/9632f990890589ec495e37939c736b2ef6931467) — fix: allow any attrs in `image` prop

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`f91c4`](https://github.com/nuxt/ui/commit/f91c4081e5d6b884fc7dd8c5669fd262ddb98649) — fix: handle RTL mode ([#4777](https://github.com/nuxt/ui/issues/4777))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[BlogPosts](https://ui.nuxt.com/docs/components/blog-posts)

[

Display a list of blog posts in a responsive grid layout.

](https://ui.nuxt.com/docs/components/blog-posts)[

ChangelogVersions

Display a list of changelog versions in a timeline.

](https://ui.nuxt.com/docs/components/changelog-versions)