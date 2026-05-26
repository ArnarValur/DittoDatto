---
title: "Vue ContentToc Component"
source: "https://ui.nuxt.com/docs/components/content-toc"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A sticky Table of Contents with automatic active anchor link highlighting."
tags:
---
## ContentToc

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/content/ContentToc.vue)

A sticky Table of Contents with automatic active anchor link highlighting.

This component is only available when the `@nuxt/content` module is installed.

## Usage

Use the `links` prop with the `page?.body?.toc?.links` you get when fetching a page.

```
<script setup lang="ts">

const route = useRoute()

const { data: page } = await useAsyncData(route.path, () => queryCollection('docs').path(route.path).first())

if (!page.value) {

  throw createError({ statusCode: 404, statusMessage: 'Page not found', fatal: true })

}

</script>

<template>

  <UContentToc :links="page?.body?.toc?.links" />

</template>
```

Use the `title` prop to change the title of the Table of Contents.

```
<script setup lang="ts">

import type { ContentTocLink } from '@nuxt/ui'

const links = ref<ContentTocLink[]>([

  {

    id: 'usage',

    depth: 2,

    text: 'Usage',

    children: [

      {

        id: 'title',

        depth: 3,

        text: 'Title'

      },

      {

        id: 'color',

        depth: 3,

        text: 'Color'

      },

      {

        id: 'highlight',

        depth: 3,

        text: 'Highlight'

      }

    ]

  },

  {

    id: 'api',

    depth: 2,

    text: 'API',

    children: [

      {

        id: 'props',

        depth: 3,

        text: 'Props'

      },

      {

        id: 'slots',

        depth: 3,

        text: 'Slots'

      }

    ]

  },

  {

    id: 'theme',

    depth: 2,

    text: 'Theme'

  }

])

</script>

<template>

  <UContentToc title="On this page" :links="links" />

</template>
```

### Color

Use the `color` prop to change the color of the links.

```
<script setup lang="ts">

import type { ContentTocLink } from '@nuxt/ui'

const links = ref<ContentTocLink[]>([

  {

    id: 'usage',

    depth: 2,

    text: 'Usage',

    children: [

      {

        id: 'title',

        depth: 3,

        text: 'Title'

      },

      {

        id: 'color',

        depth: 3,

        text: 'Color'

      },

      {

        id: 'highlight',

        depth: 3,

        text: 'Highlight'

      }

    ]

  }

])

</script>

<template>

  <UContentToc color="neutral" :links="links" />

</template>
```

### Highlight

Use the `highlight` prop to display a highlighted border for the active item.

Use the `highlight-color` prop to change the color of the border. It defaults to the `color` prop.

```
<script setup lang="ts">

import type { ContentTocLink } from '@nuxt/ui'

const links = ref<ContentTocLink[]>([

  {

    id: 'usage',

    depth: 2,

    text: 'Usage',

    children: [

      {

        id: 'title',

        depth: 3,

        text: 'Title'

      },

      {

        id: 'color',

        depth: 3,

        text: 'Color'

      },

      {

        id: 'highlight',

        depth: 3,

        text: 'Highlight'

      }

    ]

  }

])

</script>

<template>

  <UContentToc highlight highlight-color="neutral" color="neutral" :links="links" />

</template>
```

## Examples

### Within a page

Use the ContentToc component in a page to display the Table of Contents:

pages/\[...slug\].vue

```
<script setup lang="ts">

const route = useRoute()

const { data: page } = await useAsyncData(route.path, () => queryCollection('docs').path(route.path).first())

if (!page.value) {

  throw createError({ statusCode: 404, statusMessage: 'Page not found', fatal: true })

}

</script>

<template>

  <UPage v-if="page">

    <UPageHeader :title="page.title" />

    <UPageBody>

      <ContentRenderer v-if="page.body" :value="page" />

      <USeparator v-if="surround?.filter(Boolean).length" />

      <UContentSurround :surround="(surround as any)" />

    </UPageBody>

    <template v-if="page?.body?.toc?.links?.length" #right>

      <UContentToc :links="page.body.toc.links" />

    </template>

  </UPage>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'nav'` | `any`  The element or component this component should render as. |
| `trailingIcon` | `appConfig.ui.icons.chevronDown` | `any`  The icon displayed to collapse the content. |
| `title` | `t('contentToc.title')` | ` string`  The title of the table of contents. |
| `color` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `highlight` | `false` | `boolean`  Display a line next to the active link. |
| `highlightColor` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `links` |  | ` T[]` |
| `defaultOpen` |  | `boolean`  The open state of the collapsible when it is initially rendered.   Use when you do not need to control its open state. |
| `open` |  | `boolean`  The controlled open state of the collapsible. Can be binded with `v-model`. |
| `ui` |  | ` { root?: ClassNameValue; container?: ClassNameValue; top?: ClassNameValue; bottom?: ClassNameValue; trigger?: ClassNameValue; title?: ClassNameValue; trailing?: ClassNameValue; trailingIcon?: ClassNameValue; content?: ClassNameValue; list?: ClassNameValue; listWithChildren?: ClassNameValue; item?: ClassNameValue; itemWithChildren?: ClassNameValue; link?: ClassNameValue; linkText?: ClassNameValue; indicator?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `leading` | `{ open: boolean; ui: object; }` |
| `default` | `{ open: boolean; }` |
| `trailing` | `{ open: boolean; ui: object; }` |
| `content` | `{ links: T[]; }` |
| `link` | `{ link: T; }` |
| `top` | `{ links?: T[] \| undefined; }` |
| `bottom` | `{ links?: T[] \| undefined; }` |

### Emits

| Event | Type |
| --- | --- |
| `update:open` | `[value: boolean]` |
| `move` | `[id: string]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    contentToc: {

      slots: {

        root: 'sticky top-(--ui-header-height) z-10 bg-default/75 lg:bg-[initial] backdrop-blur -mx-4 px-4 sm:px-6 sm:-mx-6 overflow-y-auto max-h-[calc(100vh-var(--ui-header-height))]',

        container: 'pt-4 sm:pt-6 pb-2.5 sm:pb-4.5 lg:py-8 border-b border-dashed border-default lg:border-0 flex flex-col',

        top: '',

        bottom: 'hidden lg:flex lg:flex-col gap-6',

        trigger: 'group text-sm font-semibold flex-1 flex items-center gap-1.5 py-1.5 -mt-1.5 focus-visible:outline-primary',

        title: 'truncate',

        trailing: 'ms-auto inline-flex gap-1.5 items-center',

        trailingIcon: 'size-5 transform transition-transform duration-200 shrink-0 group-data-[state=open]:rotate-180 lg:hidden',

        content: 'data-[state=open]:animate-[collapsible-down_200ms_ease-out] data-[state=closed]:animate-[collapsible-up_200ms_ease-out] overflow-hidden focus:outline-none',

        list: 'min-w-0',

        listWithChildren: 'ms-3',

        item: 'min-w-0',

        itemWithChildren: '',

        link: 'group relative text-sm flex items-center focus-visible:outline-primary py-1',

        linkText: 'truncate',

        indicator: 'absolute ms-2.5 transition-[translate,height] duration-200 h-(--indicator-size) translate-y-(--indicator-position) w-px rounded-full'

      },

      variants: {

        color: {

          primary: '',

          secondary: '',

          success: '',

          info: '',

          warning: '',

          error: '',

          neutral: ''

        },

        highlightColor: {

          primary: {

            indicator: 'bg-primary'

          },

          secondary: {

            indicator: 'bg-secondary'

          },

          success: {

            indicator: 'bg-success'

          },

          info: {

            indicator: 'bg-info'

          },

          warning: {

            indicator: 'bg-warning'

          },

          error: {

            indicator: 'bg-error'

          },

          neutral: {

            indicator: 'bg-inverted'

          }

        },

        active: {

          false: {

            link: [

              'text-muted hover:text-default',

              'transition-colors'

            ]

          }

        },

        highlight: {

          true: {

            list: 'ms-2.5 ps-4 border-s border-default',

            item: '-ms-px'

          }

        },

        body: {

          true: {

            bottom: 'mt-6'

          }

        }

      },

      compoundVariants: [

        {

          color: 'primary',

          active: true,

          class: {

            link: 'text-primary',

            linkLeadingIcon: 'text-primary'

          }

        },

        {

          color: 'neutral',

          active: true,

          class: {

            link: 'text-highlighted',

            linkLeadingIcon: 'text-highlighted'

          }

        }

      ],

      defaultVariants: {

        color: 'primary',

        highlightColor: 'primary'

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

        contentToc: {

          slots: {

            root: 'sticky top-(--ui-header-height) z-10 bg-default/75 lg:bg-[initial] backdrop-blur -mx-4 px-4 sm:px-6 sm:-mx-6 overflow-y-auto max-h-[calc(100vh-var(--ui-header-height))]',

            container: 'pt-4 sm:pt-6 pb-2.5 sm:pb-4.5 lg:py-8 border-b border-dashed border-default lg:border-0 flex flex-col',

            top: '',

            bottom: 'hidden lg:flex lg:flex-col gap-6',

            trigger: 'group text-sm font-semibold flex-1 flex items-center gap-1.5 py-1.5 -mt-1.5 focus-visible:outline-primary',

            title: 'truncate',

            trailing: 'ms-auto inline-flex gap-1.5 items-center',

            trailingIcon: 'size-5 transform transition-transform duration-200 shrink-0 group-data-[state=open]:rotate-180 lg:hidden',

            content: 'data-[state=open]:animate-[collapsible-down_200ms_ease-out] data-[state=closed]:animate-[collapsible-up_200ms_ease-out] overflow-hidden focus:outline-none',

            list: 'min-w-0',

            listWithChildren: 'ms-3',

            item: 'min-w-0',

            itemWithChildren: '',

            link: 'group relative text-sm flex items-center focus-visible:outline-primary py-1',

            linkText: 'truncate',

            indicator: 'absolute ms-2.5 transition-[translate,height] duration-200 h-(--indicator-size) translate-y-(--indicator-position) w-px rounded-full'

          },

          variants: {

            color: {

              primary: '',

              secondary: '',

              success: '',

              info: '',

              warning: '',

              error: '',

              neutral: ''

            },

            highlightColor: {

              primary: {

                indicator: 'bg-primary'

              },

              secondary: {

                indicator: 'bg-secondary'

              },

              success: {

                indicator: 'bg-success'

              },

              info: {

                indicator: 'bg-info'

              },

              warning: {

                indicator: 'bg-warning'

              },

              error: {

                indicator: 'bg-error'

              },

              neutral: {

                indicator: 'bg-inverted'

              }

            },

            active: {

              false: {

                link: [

                  'text-muted hover:text-default',

                  'transition-colors'

                ]

              }

            },

            highlight: {

              true: {

                list: 'ms-2.5 ps-4 border-s border-default',

                item: '-ms-px'

              }

            },

            body: {

              true: {

                bottom: 'mt-6'

              }

            }

          },

          compoundVariants: [

            {

              color: 'primary',

              active: true,

              class: {

                link: 'text-primary',

                linkLeadingIcon: 'text-primary'

              }

            },

            {

              color: 'neutral',

              active: true,

              class: {

                link: 'text-highlighted',

                linkLeadingIcon: 'text-highlighted'

              }

            }

          ],

          defaultVariants: {

            color: 'primary',

            highlightColor: 'primary'

          }

        }

      }

    })

  ]

})
```

Some colors in `compoundVariants` are omitted for readability. Check out the source code on GitHub.

## Changelog

[`6dd73`](https://github.com/nuxt/ui/commit/6dd731ce2879bb0a9914b61bd6a0134a5aca69e2) — chore: update nuxt framework to ^4.3.0 (v4) ([#5923](https://github.com/nuxt/ui/issues/5923))

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components