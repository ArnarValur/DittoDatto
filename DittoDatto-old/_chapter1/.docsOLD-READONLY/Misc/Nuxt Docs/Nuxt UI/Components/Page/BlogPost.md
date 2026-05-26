---
title: "Vue BlogPost Component"
source: "https://ui.nuxt.com/docs/components/blog-post"
author:
  - "[[Nuxt UI]]"
published: 2024-11-25
created: 2026-01-28
description: "A customizable article to display in a blog page."
tags:
---
## BlogPost

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/BlogPost.vue)

A customizable article to display in a blog page.

## Usage

The BlogPost component provides a flexible way to display an `<article>` element with customizable content including title, description, image, etc.

Use the `BlogPosts` component to display multiple blog posts in a responsive grid layout.

Use the `title` prop to display the title of the BlogPost.

```
<template>

  <UBlogPost title="Introducing Nuxt Icon v1" />

</template>
```

### Description

Use the `description` prop to display the description of the BlogPost.

```
<template>

  <UBlogPost

    title="Introducing Nuxt Icon v1"

    description="Discover Nuxt Icon v1 - a modern, versatile, and customizable icon solution for your Nuxt projects."

  />

</template>
```

Use the `date` prop to display the date of the BlogPost.

The date is automatically formatted to the [current locale](https://ui.nuxt.com/docs/getting-started/integrations/i18n/nuxt#locale). You can either pass a `Date` object or a string.

```
<template>

  <UBlogPost

    title="Introducing Nuxt Icon v1"

    description="Discover Nuxt Icon v1 - a modern, versatile, and customizable icon solution for your Nuxt projects."

    date="2024-11-25"

  />

</template>
```

### Badge

Use the `badge` prop to display a [Badge](https://ui.nuxt.com/docs/components/badge) in the BlogPost.

```
<template>

  <UBlogPost

    title="Introducing Nuxt Icon v1"

    description="Discover Nuxt Icon v1 - a modern, versatile, and customizable icon solution for your Nuxt projects."

    badge="Release"

  />

</template>
```

You can pass any property from the [Badge](https://ui.nuxt.com/docs/components/badge#props) component to customize it.

```
<template>

  <UBlogPost

    title="Introducing Nuxt Icon v1"

    description="Discover Nuxt Icon v1 - a modern, versatile, and customizable icon solution for your Nuxt projects."

    :badge="{

      label: 'Release',

      color: 'primary',

      variant: 'solid'

    }"

  />

</template>
```

### Image

Use the `image` prop to display an image in the BlogPost.

If [`@nuxt/image`](https://image.nuxt.com/get-started/installation) is installed, the `<NuxtImg>` component will be used instead of the native `img` tag.

```
<template>

  <UBlogPost

    title="Introducing Nuxt Icon v1"

    description="Discover Nuxt Icon v1 - a modern, versatile, and customizable icon solution for your Nuxt projects."

    image="https://nuxt.com/assets/blog/nuxt-icon/cover.png"

    date="2024-11-25"

  />

</template>
```

Use the `authors` prop to display a list of [User](https://ui.nuxt.com/docs/components/user) in the BlogPost as an array of objects with the following properties:

- `name?: string`
- `description?: string`
- `avatar?: Omit<AvatarProps, 'size'>`
- `chip?: boolean | Omit<ChipProps, 'size' | 'inset'>`
- `size?: UserProps['size']`
- `orientation?: UserProps['orientation']`

You can pass any property from the [Link](https://ui.nuxt.com/docs/components/link#props) component such as `to`, `target`, etc.

```
<script setup lang="ts">

import type { UserProps } from '@nuxt/ui'

const authors = ref<UserProps[]>([

  {

    name: 'Anthony Fu',

    description: 'antfu7',

    avatar: {

      src: 'https://github.com/antfu.png'

    },

    to: 'https://github.com/antfu',

    target: '_blank'

  }

])

</script>

<template>

  <UBlogPost

    title="Introducing Nuxt Icon v1"

    description="Discover Nuxt Icon v1 - a modern, versatile, and customizable icon solution for your Nuxt projects."

    image="https://nuxt.com/assets/blog/nuxt-icon/cover.png"

    date="2024-11-25"

    :authors="authors"

  />

</template>
```

When the `authors` prop has more than one item, the [AvatarGroup](https://ui.nuxt.com/docs/components/avatar-group) component is used.

```
<script setup lang="ts">

import type { UserProps } from '@nuxt/ui'

const authors = ref<UserProps[]>([

  {

    name: 'Anthony Fu',

    description: 'antfu7',

    avatar: {

      src: 'https://github.com/antfu.png'

    },

    to: 'https://github.com/antfu',

    target: '_blank'

  },

  {

    name: 'Benjamin Canac',

    description: 'benjamincanac',

    avatar: {

      src: 'https://github.com/benjamincanac.png'

    },

    to: 'https://github.com/benjamincanac',

    target: '_blank'

  }

])

</script>

<template>

  <UBlogPost

    title="Introducing Nuxt Icon v1"

    description="Discover Nuxt Icon v1 - a modern, versatile, and customizable icon solution for your Nuxt projects."

    image="https://nuxt.com/assets/blog/nuxt-icon/cover.png"

    date="2024-11-25"

    :authors="authors"

  />

</template>
```

### Link

You can pass any property from the [`<NuxtLink>`](https://nuxt.com/docs/api/components/nuxt-link) component such as `to`, `target`, `rel`, etc.

```
<template>

  <UBlogPost

    title="Introducing Nuxt Icon v1"

    description="Discover Nuxt Icon v1 - a modern, versatile, and customizable icon solution for your Nuxt projects."

    image="https://nuxt.com/assets/blog/nuxt-icon/cover.png"

    date="2024-11-25"

    to="https://nuxt.com/blog/nuxt-icon-v1-0"

    target="_blank"

  />

</template>
```

### Variant

Use the `variant` prop to change the style of the BlogPost.

```
<template>

  <UBlogPost

    title="Introducing Nuxt Icon v1"

    description="Discover Nuxt Icon v1 - a modern, versatile, and customizable icon solution for your Nuxt projects."

    image="https://nuxt.com/assets/blog/nuxt-icon/cover.png"

    date="2024-11-25"

    to="https://nuxt.com/blog/nuxt-icon-v1-0"

    target="_blank"

    variant="naked"

  />

</template>
```

The styling will be different wether you provide a `to` prop or an `image`.

### Orientation

Use the `orientation` prop to change the BlogPost orientation. Defaults to `vertical`.

![Introducing Nuxt Icon v1](https://nuxt.com/assets/blog/nuxt-icon/cover.png)

## Introducing Nuxt Icon v1

Discover Nuxt Icon v1 - a modern, versatile, and customizable icon solution for your Nuxt projects.

```
<template>

  <UBlogPost

    title="Introducing Nuxt Icon v1"

    description="Discover Nuxt Icon v1 - a modern, versatile, and customizable icon solution for your Nuxt projects."

    image="https://nuxt.com/assets/blog/nuxt-icon/cover.png"

    date="2024-11-25"

    to="https://nuxt.com/blog/nuxt-icon-v1-0"

    target="_blank"

    orientation="horizontal"

    variant="outline"

  />

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'article'` | `any`  The element or component this component should render as. |
| `title` |  | ` string` |
| `description` |  | ` string` |
| `date` |  | ` string \| Date`  The date of the blog post. Can be a string or a Date object. |
| `badge` |  | ` string \| BadgeProps`  Display a badge on the blog post. Can be a string or an object.`{ color: 'neutral', variant: 'subtle' }` |
| `authors` |  | ` UserProps[]`  The authors of the blog post. |
| `image` |  | ` string \| Partial<HTMLImageElement> & { [key: string]: any; }`  The image of the blog post. Can be a string or an object. |
| `orientation` | `'vertical'` | ` "vertical" \| "horizontal"`  The orientation of the blog post. |
| `variant` | `'outline'` | ` "outline" \| "soft" \| "subtle" \| "ghost" \| "naked"` |
| `to` |  | ` string \| kt \| Tt` |
| `target` |  | ` null \| "_blank" \| "_parent" \| "_self" \| "_top" \| string & {}` |
| `ui` |  | ` { root?: ClassNameValue; header?: ClassNameValue; body?: ClassNameValue; footer?: ClassNameValue; image?: ClassNameValue; title?: ClassNameValue; description?: ClassNameValue; authors?: ClassNameValue; avatar?: ClassNameValue; meta?: ClassNameValue; date?: ClassNameValue; badge?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `date` | `{}` |
| `badge` | `{}` |
| `title` | `{}` |
| `description` | `{}` |
| `authors` | `{ ui: object; }` |
| `header` | `{ ui: object; }` |
| `body` | `{}` |
| `footer` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    blogPost: {

      slots: {

        root: 'relative group/blog-post flex flex-col rounded-lg overflow-hidden',

        header: 'relative overflow-hidden aspect-[16/9] w-full pointer-events-none',

        body: 'min-w-0 flex-1 flex flex-col',

        footer: '',

        image: 'object-cover object-top w-full h-full',

        title: 'text-xl text-pretty font-semibold text-highlighted',

        description: 'mt-1 text-base text-pretty',

        authors: 'pt-4 mt-auto flex flex-wrap gap-x-3 gap-y-1.5',

        avatar: '',

        meta: 'flex items-center gap-2 mb-2',

        date: 'text-sm',

        badge: ''

      },

      variants: {

        orientation: {

          horizontal: {

            root: 'lg:grid lg:grid-cols-2 lg:items-center gap-x-8',

            body: 'justify-center p-4 sm:p-6 lg:px-0'

          },

          vertical: {

            root: 'flex flex-col',

            body: 'p-4 sm:p-6'

          }

        },

        variant: {

          outline: {

            root: 'bg-default ring ring-default',

            date: 'text-toned',

            description: 'text-muted'

          },

          soft: {

            root: 'bg-elevated/50',

            date: 'text-muted',

            description: 'text-toned'

          },

          subtle: {

            root: 'bg-elevated/50 ring ring-default',

            date: 'text-muted',

            description: 'text-toned'

          },

          ghost: {

            date: 'text-toned',

            description: 'text-muted',

            header: 'shadow-lg rounded-lg'

          },

          naked: {

            root: 'p-0 sm:p-0',

            date: 'text-toned',

            description: 'text-muted',

            header: 'shadow-lg rounded-lg'

          }

        },

        to: {

          true: {

            root: [

              'has-focus-visible:ring-2 has-focus-visible:ring-primary',

              'transition'

            ],

            image: 'transform transition-transform duration-200 group-hover/blog-post:scale-110',

            avatar: 'transform transition-transform duration-200 hover:scale-115 focus-visible:outline-primary'

          }

        },

        image: {

          true: ''

        }

      },

      compoundVariants: [

        {

          variant: 'outline',

          to: true,

          class: {

            root: 'hover:bg-elevated/50'

          }

        },

        {

          variant: 'soft',

          to: true,

          class: {

            root: 'hover:bg-elevated'

          }

        },

        {

          variant: 'subtle',

          to: true,

          class: {

            root: 'hover:bg-elevated hover:ring-accented'

          }

        },

        {

          variant: 'ghost',

          to: true,

          class: {

            root: 'hover:bg-elevated/50',

            header: [

              'group-hover/blog-post:shadow-none',

              'transition-all'

            ]

          }

        },

        {

          variant: 'ghost',

          to: true,

          orientation: 'vertical',

          class: {

            header: 'group-hover/blog-post:rounded-b-none'

          }

        },

        {

          variant: 'ghost',

          to: true,

          orientation: 'horizontal',

          class: {

            header: 'group-hover/blog-post:rounded-r-none'

          }

        },

        {

          orientation: 'vertical',

          image: false,

          variant: 'naked',

          class: {

            body: 'p-0 sm:p-0'

          }

        }

      ],

      defaultVariants: {

        variant: 'outline'

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

        blogPost: {

          slots: {

            root: 'relative group/blog-post flex flex-col rounded-lg overflow-hidden',

            header: 'relative overflow-hidden aspect-[16/9] w-full pointer-events-none',

            body: 'min-w-0 flex-1 flex flex-col',

            footer: '',

            image: 'object-cover object-top w-full h-full',

            title: 'text-xl text-pretty font-semibold text-highlighted',

            description: 'mt-1 text-base text-pretty',

            authors: 'pt-4 mt-auto flex flex-wrap gap-x-3 gap-y-1.5',

            avatar: '',

            meta: 'flex items-center gap-2 mb-2',

            date: 'text-sm',

            badge: ''

          },

          variants: {

            orientation: {

              horizontal: {

                root: 'lg:grid lg:grid-cols-2 lg:items-center gap-x-8',

                body: 'justify-center p-4 sm:p-6 lg:px-0'

              },

              vertical: {

                root: 'flex flex-col',

                body: 'p-4 sm:p-6'

              }

            },

            variant: {

              outline: {

                root: 'bg-default ring ring-default',

                date: 'text-toned',

                description: 'text-muted'

              },

              soft: {

                root: 'bg-elevated/50',

                date: 'text-muted',

                description: 'text-toned'

              },

              subtle: {

                root: 'bg-elevated/50 ring ring-default',

                date: 'text-muted',

                description: 'text-toned'

              },

              ghost: {

                date: 'text-toned',

                description: 'text-muted',

                header: 'shadow-lg rounded-lg'

              },

              naked: {

                root: 'p-0 sm:p-0',

                date: 'text-toned',

                description: 'text-muted',

                header: 'shadow-lg rounded-lg'

              }

            },

            to: {

              true: {

                root: [

                  'has-focus-visible:ring-2 has-focus-visible:ring-primary',

                  'transition'

                ],

                image: 'transform transition-transform duration-200 group-hover/blog-post:scale-110',

                avatar: 'transform transition-transform duration-200 hover:scale-115 focus-visible:outline-primary'

              }

            },

            image: {

              true: ''

            }

          },

          compoundVariants: [

            {

              variant: 'outline',

              to: true,

              class: {

                root: 'hover:bg-elevated/50'

              }

            },

            {

              variant: 'soft',

              to: true,

              class: {

                root: 'hover:bg-elevated'

              }

            },

            {

              variant: 'subtle',

              to: true,

              class: {

                root: 'hover:bg-elevated hover:ring-accented'

              }

            },

            {

              variant: 'ghost',

              to: true,

              class: {

                root: 'hover:bg-elevated/50',

                header: [

                  'group-hover/blog-post:shadow-none',

                  'transition-all'

                ]

              }

            },

            {

              variant: 'ghost',

              to: true,

              orientation: 'vertical',

              class: {

                header: 'group-hover/blog-post:rounded-b-none'

              }

            },

            {

              variant: 'ghost',

              to: true,

              orientation: 'horizontal',

              class: {

                header: 'group-hover/blog-post:rounded-r-none'

              }

            },

            {

              orientation: 'vertical',

              image: false,

              variant: 'naked',

              class: {

                body: 'p-0 sm:p-0'

              }

            }

          ],

          defaultVariants: {

            variant: 'outline'

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

[`45148`](https://github.com/nuxt/ui/commit/4514880902ba6ec75b5bf69099f4b6bef0f58efa) — fix: ensure date slot renders ([#4743](https://github.com/nuxt/ui/issues/4743))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components