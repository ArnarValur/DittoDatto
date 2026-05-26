---
title: "Vue BlogPosts Component"
source: "https://ui.nuxt.com/docs/components/blog-posts"
author:
  - "[[Nuxt UI]]"
published: 2024-11-25
created: 2026-01-28
description: "Display a list of blog posts in a responsive grid layout."
tags:
---
## BlogPosts

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/BlogPosts.vue)

Display a list of blog posts in a responsive grid layout.

## Usage

The BlogPosts component provides a flexible layout to display a list of [BlogPost](https://ui.nuxt.com/docs/components/blog-post) components using either the default slot or the `posts` prop.

```
<template>

  <UBlogPosts>

    <UBlogPost

      v-for="(post, index) in posts"

      :key="index"

      v-bind="post"

    />

  </UBlogPosts>

</template>
```

### Posts

Use the `posts` prop as an array of objects with the properties of the [BlogPost](https://ui.nuxt.com/docs/components/blog-post#props) component.

```
<script setup lang="ts">

import type { BlogPostProps } from '@nuxt/ui'

const posts = ref<BlogPostProps[]>([

  {

    title: 'Nuxt Icon v1',

    description: 'Discover Nuxt Icon v1!',

    image: 'https://nuxt.com/assets/blog/nuxt-icon/cover.png',

    date: '2024-11-25'

  },

  {

    title: 'Nuxt 3.14',

    description: 'Nuxt 3.14 is out!',

    image: 'https://nuxt.com/assets/blog/v3.14.png',

    date: '2024-11-04'

  },

  {

    title: 'Nuxt 3.13',

    description: 'Nuxt 3.13 is out!',

    image: 'https://nuxt.com/assets/blog/v3.13.png',

    date: '2024-08-22'

  }

])

</script>

<template>

  <UBlogPosts :posts="posts" />

</template>
```

### Orientation

Use the `orientation` prop to change the orientation of the BlogPosts. Defaults to `horizontal`.

```
<script setup lang="ts">

import type { BlogPostProps } from '@nuxt/ui'

const posts = ref<BlogPostProps[]>([

  {

    title: 'Nuxt Icon v1',

    description: 'Discover Nuxt Icon v1!',

    image: 'https://nuxt.com/assets/blog/nuxt-icon/cover.png',

    date: '2024-11-25'

  },

  {

    title: 'Nuxt 3.14',

    description: 'Nuxt 3.14 is out!',

    image: 'https://nuxt.com/assets/blog/v3.14.png',

    date: '2024-11-04'

  },

  {

    title: 'Nuxt 3.13',

    description: 'Nuxt 3.13 is out!',

    image: 'https://nuxt.com/assets/blog/v3.13.png',

    date: '2024-08-22'

  }

])

</script>

<template>

  <UBlogPosts orientation="vertical" :posts="posts" />

</template>
```

When using the `posts` prop instead of the default slot, the `orientation` of the posts is automatically reversed, `horizontal` to `vertical` and vice versa.

## Examples

While these examples use [Nuxt Content](https://content.nuxt.com/), the components can be integrated with any content management system.

### Within a page

Use the BlogPosts component in a page to create a blog page:

pages/blog/index.vue

```
<script setup lang="ts">

const { data: posts } = await useAsyncData('posts', () => queryCollection('posts').all())

</script>

<template>

  <UPage>

    <UPageHero title="Blog" />

    <UPageBody>

      <UContainer>

        <UBlogPosts>

          <UBlogPost

            v-for="(post, index) in posts"

            :key="index"

            v-bind="post"

            :to="post.path"

          />

        </UBlogPosts>

      </UContainer>

    </UPageBody>

  </UPage>

</template>
```

In this example, the `posts` are fetched using `queryCollection` from the `@nuxt/content` module.

The `to` prop is overridden here since `@nuxt/content` uses the `path` property.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `posts` |  | ` BlogPostProps[]` |
| `orientation` | `'horizontal'` | ` "horizontal" \| "vertical"`  The orientation of the blog posts. |

### Slots

| Slot | Type |
| --- | --- |
| `date` | `{ post: T; }` |
| `badge` | `{ post: T; }` |
| `title` | `{ post: T; }` |
| `description` | `{ post: T; }` |
| `authors` | `{ ui: object; } & { post: T; }` |
| `header` | `{ ui: object; } & { post: T; }` |
| `body` | `{ post: T; }` |
| `footer` | `{ post: T; }` |
| `default` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    blogPosts: {

      base: 'flex flex-col gap-8 lg:gap-y-16',

      variants: {

        orientation: {

          horizontal: 'sm:grid sm:grid-cols-2 lg:grid-cols-3',

          vertical: ''

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

        blogPosts: {

          base: 'flex flex-col gap-8 lg:gap-y-16',

          variants: {

            orientation: {

              horizontal: 'sm:grid sm:grid-cols-2 lg:grid-cols-3',

              vertical: ''

            }

          }

        }

      }

    })

  ]

})
```

## Changelog

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[BlogPost](https://ui.nuxt.com/docs/components/blog-post)

[

A customizable article to display in a blog page.

](https://ui.nuxt.com/docs/components/blog-post)[

ChangelogVersion

A customizable article to display in a changelog.

](https://ui.nuxt.com/docs/components/changelog-version)