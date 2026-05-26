---
title: "Vue ContentNavigation Component"
source: "https://ui.nuxt.com/docs/components/content-navigation"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "An accordion-style navigation component for organizing page links."
tags:
---
This component is only available when the `@nuxt/content` module is installed.

## Usage

Use the `navigation` prop with the `navigation` value you get when fetching the navigation of your app.

### Type

Set the `type` prop to `single` to only allow one item to be open at a time. Defaults to `multiple`.

### Color

Use the `color` prop to change the color of the navigation links.

### Variant

Use the `variant` prop to change the variant of the navigation links.

### Highlight

Use the `highlight` prop to display a highlighted border for the active link.

Use the `highlight-color` prop to change the color of the border. It defaults to the `color` prop.

### Trailing Icon

## Examples

### Within a layout

Use the ContentNavigation component inside a [PageAside](https://ui.nuxt.com/docs/components/page-aside) component within a layout to display the navigation of the page:

layouts/docs.vue

```
<script setup lang="ts">

import type { ContentNavigationItem } from '@nuxt/content'

const navigation = inject<Ref<ContentNavigationItem[]>>('navigation')

</script>

<template>

  <UPage>

    <template #left>

      <UPageAside>

        <UContentNavigation :navigation="navigation" highlight />

      </UPageAside>

    </template>

    <slot />

  </UPage>

</template>
```

### Within a header

Use the ContentNavigation component inside the `content` slot of a [Header](https://ui.nuxt.com/docs/components/header) component to display the navigation of the page on mobile:

components/Header.vue

```
<script setup lang="ts">

import type { ContentNavigationItem } from '@nuxt/content'

const navigation = inject<Ref<ContentNavigationItem[]>>('navigation')

</script>

<template>

  <UHeader>

    <template #body>

      <UContentNavigation :navigation="navigation" highlight />

    </template>

  </UHeader>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'nav'` | `any`  The element or component this component should render as. |
| `defaultOpen` | `undefined` | `boolean`  When `true`, the tree will be opened based on the current route. When `false`, the tree will be closed. When `undefined` (default), the first item will be opened with `type="single"` and the first level will be opened with `type="multiple"`. |
| `trailingIcon` | `appConfig.ui.icons.chevronDown` | `any`  The icon displayed to toggle the accordion. |
| `color` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `variant` | `'pill'` | ` "pill" \| "link"` |
| `highlight` | `false` | `boolean`  Display a line next to the active link. |
| `highlightColor` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `collapsible` | `true` | `boolean`  When type is "single", prevents closing the open item when clicking its trigger. When type is "multiple", disables the collapsible behavior. |
| `level` | `0` | ` number` |
| `navigation` |  | ` T[]` |
| `disabled` | `false` | `boolean`  When `true`, prevents the user from interacting with the accordion and all its items |
| `type` | `'multiple'` | ` "single" \| "multiple"`  Determines whether a "single" or "multiple" items can be selected at a time.  This prop will overwrite the inferred type from `modelValue` and `defaultValue`. |
| `unmountOnHide` | `true` | `boolean`  When `true`, the element will be unmounted on closed state. |
| `ui` |  | ` { root?: ClassNameValue; content?: ClassNameValue; list?: ClassNameValue; item?: ClassNameValue; listWithChildren?: ClassNameValue; itemWithChildren?: ClassNameValue; trigger?: ClassNameValue; link?: ClassNameValue; linkLeadingIcon?: ClassNameValue; linkTrailing?: ClassNameValue; linkTrailingBadge?: ClassNameValue; linkTrailingBadgeSize?: ClassNameValue; linkTrailingIcon?: ClassNameValue; linkTitle?: ClassNameValue; linkTitleExternalIcon?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `link` | `{ link: T; active?: boolean \| undefined; ui: object; }` |
| `link-leading` | `{ link: T; active?: boolean \| undefined; ui: object; }` |
| `link-title` | `{ link: T; active?: boolean \| undefined; ui: object; }` |
| `link-trailing` | `{ link: T; active?: boolean \| undefined; ui: object; }` |

### Emits

| Event | Type |
| --- | --- |
| `update:modelValue` | `[value: string \| string[] \| undefined]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    contentNavigation: {

      slots: {

        root: '',

        content: 'data-[state=open]:animate-[accordion-down_200ms_ease-out] data-[state=closed]:animate-[accordion-up_200ms_ease-out] overflow-hidden focus:outline-none',

        list: 'isolate -mx-2.5 -mt-1.5',

        item: '',

        listWithChildren: 'ms-5 border-s border-default',

        itemWithChildren: 'flex flex-col data-[state=open]:mb-1.5',

        trigger: 'font-semibold',

        link: 'group relative w-full px-2.5 py-1.5 before:inset-y-px before:inset-x-0 flex items-center gap-1.5 text-sm before:absolute before:z-[-1] before:rounded-md focus:outline-none focus-visible:outline-none focus-visible:before:ring-inset focus-visible:before:ring-2',

        linkLeadingIcon: 'shrink-0 size-5',

        linkTrailing: 'ms-auto inline-flex gap-1.5 items-center',

        linkTrailingBadge: 'shrink-0',

        linkTrailingBadgeSize: 'sm',

        linkTrailingIcon: 'size-5 transform transition-transform duration-200 shrink-0 group-data-[state=open]:rotate-180',

        linkTitle: 'truncate',

        linkTitleExternalIcon: 'size-3 align-top text-dimmed'

      },

      variants: {

        color: {

          primary: {

            trigger: 'focus-visible:ring-primary',

            link: 'focus-visible:before:ring-primary'

          },

          secondary: {

            trigger: 'focus-visible:ring-secondary',

            link: 'focus-visible:before:ring-secondary'

          },

          success: {

            trigger: 'focus-visible:ring-success',

            link: 'focus-visible:before:ring-success'

          },

          info: {

            trigger: 'focus-visible:ring-info',

            link: 'focus-visible:before:ring-info'

          },

          warning: {

            trigger: 'focus-visible:ring-warning',

            link: 'focus-visible:before:ring-warning'

          },

          error: {

            trigger: 'focus-visible:ring-error',

            link: 'focus-visible:before:ring-error'

          },

          neutral: {

            trigger: 'focus-visible:ring-inverted',

            link: 'focus-visible:before:ring-inverted'

          }

        },

        highlightColor: {

          primary: '',

          secondary: '',

          success: '',

          info: '',

          warning: '',

          error: '',

          neutral: ''

        },

        variant: {

          pill: '',

          link: ''

        },

        active: {

          true: {

            link: 'font-medium'

          },

          false: {

            link: 'text-muted',

            linkLeadingIcon: 'text-dimmed'

          }

        },

        disabled: {

          true: {

            trigger: 'data-[state=open]:text-highlighted'

          }

        },

        highlight: {

          true: {}

        },

        level: {

          true: {

            item: 'ps-1.5 -ms-px',

            itemWithChildren: 'ps-1.5 -ms-px'

          }

        }

      },

      compoundVariants: [

        {

          highlight: true,

          level: true,

          class: {

            link: [

              'after:absolute after:-left-1.5 after:inset-y-0.5 after:block after:w-px after:rounded-full',

              'after:transition-colors'

            ]

          }

        },

        {

          disabled: false,

          active: false,

          variant: 'pill',

          class: {

            link: [

              'hover:text-highlighted hover:before:bg-elevated/50 data-[state=open]:text-highlighted',

              'transition-colors before:transition-colors'

            ],

            linkLeadingIcon: [

              'group-hover:text-default group-data-[state=open]:text-default',

              'transition-colors'

            ]

          }

        },

        {

          color: 'primary',

          variant: 'pill',

          active: true,

          class: {

            link: 'text-primary',

            linkLeadingIcon: 'text-primary group-data-[state=open]:text-primary'

          }

        },

        {

          color: 'neutral',

          variant: 'pill',

          active: true,

          class: {

            link: 'text-highlighted',

            linkLeadingIcon: 'text-highlighted group-data-[state=open]:text-highlighted'

          }

        },

        {

          variant: 'pill',

          active: true,

          highlight: false,

          class: {

            link: 'before:bg-elevated'

          }

        },

        {

          variant: 'pill',

          active: true,

          highlight: true,

          disabled: false,

          class: {

            link: [

              'hover:before:bg-elevated/50',

              'before:transition-colors'

            ]

          }

        },

        {

          disabled: false,

          active: false,

          variant: 'link',

          class: {

            link: [

              'hover:text-highlighted data-[state=open]:text-highlighted',

              'transition-colors'

            ],

            linkLeadingIcon: [

              'group-hover:text-default group-data-[state=open]:text-default',

              'transition-colors'

            ]

          }

        },

        {

          color: 'primary',

          variant: 'link',

          active: true,

          class: {

            link: 'text-primary',

            linkLeadingIcon: 'text-primary group-data-[state=open]:text-primary'

          }

        },

        {

          color: 'neutral',

          variant: 'link',

          active: true,

          class: {

            link: 'text-highlighted',

            linkLeadingIcon: 'text-highlighted group-data-[state=open]:text-highlighted'

          }

        },

        {

          highlightColor: 'primary',

          highlight: true,

          level: true,

          active: true,

          class: {

            link: 'after:bg-primary'

          }

        },

        {

          highlightColor: 'neutral',

          highlight: true,

          level: true,

          active: true,

          class: {

            link: 'after:bg-inverted'

          }

        }

      ],

      defaultVariants: {

        color: 'primary',

        highlightColor: 'primary',

        variant: 'pill'

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

        contentNavigation: {

          slots: {

            root: '',

            content: 'data-[state=open]:animate-[accordion-down_200ms_ease-out] data-[state=closed]:animate-[accordion-up_200ms_ease-out] overflow-hidden focus:outline-none',

            list: 'isolate -mx-2.5 -mt-1.5',

            item: '',

            listWithChildren: 'ms-5 border-s border-default',

            itemWithChildren: 'flex flex-col data-[state=open]:mb-1.5',

            trigger: 'font-semibold',

            link: 'group relative w-full px-2.5 py-1.5 before:inset-y-px before:inset-x-0 flex items-center gap-1.5 text-sm before:absolute before:z-[-1] before:rounded-md focus:outline-none focus-visible:outline-none focus-visible:before:ring-inset focus-visible:before:ring-2',

            linkLeadingIcon: 'shrink-0 size-5',

            linkTrailing: 'ms-auto inline-flex gap-1.5 items-center',

            linkTrailingBadge: 'shrink-0',

            linkTrailingBadgeSize: 'sm',

            linkTrailingIcon: 'size-5 transform transition-transform duration-200 shrink-0 group-data-[state=open]:rotate-180',

            linkTitle: 'truncate',

            linkTitleExternalIcon: 'size-3 align-top text-dimmed'

          },

          variants: {

            color: {

              primary: {

                trigger: 'focus-visible:ring-primary',

                link: 'focus-visible:before:ring-primary'

              },

              secondary: {

                trigger: 'focus-visible:ring-secondary',

                link: 'focus-visible:before:ring-secondary'

              },

              success: {

                trigger: 'focus-visible:ring-success',

                link: 'focus-visible:before:ring-success'

              },

              info: {

                trigger: 'focus-visible:ring-info',

                link: 'focus-visible:before:ring-info'

              },

              warning: {

                trigger: 'focus-visible:ring-warning',

                link: 'focus-visible:before:ring-warning'

              },

              error: {

                trigger: 'focus-visible:ring-error',

                link: 'focus-visible:before:ring-error'

              },

              neutral: {

                trigger: 'focus-visible:ring-inverted',

                link: 'focus-visible:before:ring-inverted'

              }

            },

            highlightColor: {

              primary: '',

              secondary: '',

              success: '',

              info: '',

              warning: '',

              error: '',

              neutral: ''

            },

            variant: {

              pill: '',

              link: ''

            },

            active: {

              true: {

                link: 'font-medium'

              },

              false: {

                link: 'text-muted',

                linkLeadingIcon: 'text-dimmed'

              }

            },

            disabled: {

              true: {

                trigger: 'data-[state=open]:text-highlighted'

              }

            },

            highlight: {

              true: {}

            },

            level: {

              true: {

                item: 'ps-1.5 -ms-px',

                itemWithChildren: 'ps-1.5 -ms-px'

              }

            }

          },

          compoundVariants: [

            {

              highlight: true,

              level: true,

              class: {

                link: [

                  'after:absolute after:-left-1.5 after:inset-y-0.5 after:block after:w-px after:rounded-full',

                  'after:transition-colors'

                ]

              }

            },

            {

              disabled: false,

              active: false,

              variant: 'pill',

              class: {

                link: [

                  'hover:text-highlighted hover:before:bg-elevated/50 data-[state=open]:text-highlighted',

                  'transition-colors before:transition-colors'

                ],

                linkLeadingIcon: [

                  'group-hover:text-default group-data-[state=open]:text-default',

                  'transition-colors'

                ]

              }

            },

            {

              color: 'primary',

              variant: 'pill',

              active: true,

              class: {

                link: 'text-primary',

                linkLeadingIcon: 'text-primary group-data-[state=open]:text-primary'

              }

            },

            {

              color: 'neutral',

              variant: 'pill',

              active: true,

              class: {

                link: 'text-highlighted',

                linkLeadingIcon: 'text-highlighted group-data-[state=open]:text-highlighted'

              }

            },

            {

              variant: 'pill',

              active: true,

              highlight: false,

              class: {

                link: 'before:bg-elevated'

              }

            },

            {

              variant: 'pill',

              active: true,

              highlight: true,

              disabled: false,

              class: {

                link: [

                  'hover:before:bg-elevated/50',

                  'before:transition-colors'

                ]

              }

            },

            {

              disabled: false,

              active: false,

              variant: 'link',

              class: {

                link: [

                  'hover:text-highlighted data-[state=open]:text-highlighted',

                  'transition-colors'

                ],

                linkLeadingIcon: [

                  'group-hover:text-default group-data-[state=open]:text-default',

                  'transition-colors'

                ]

              }

            },

            {

              color: 'primary',

              variant: 'link',

              active: true,

              class: {

                link: 'text-primary',

                linkLeadingIcon: 'text-primary group-data-[state=open]:text-primary'

              }

            },

            {

              color: 'neutral',

              variant: 'link',

              active: true,

              class: {

                link: 'text-highlighted',

                linkLeadingIcon: 'text-highlighted group-data-[state=open]:text-highlighted'

              }

            },

            {

              highlightColor: 'primary',

              highlight: true,

              level: true,

              active: true,

              class: {

                link: 'after:bg-primary'

              }

            },

            {

              highlightColor: 'neutral',

              highlight: true,

              level: true,

              active: true,

              class: {

                link: 'after:bg-inverted'

              }

            }

          ],

          defaultVariants: {

            color: 'primary',

            highlightColor: 'primary',

            variant: 'pill'

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

[`e5c11`](https://github.com/nuxt/ui/commit/e5c11e6696e8fdfa2f4ed4f01157e230d1c25561) — fix: ensure proper badge display

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`22ee0`](https://github.com/nuxt/ui/commit/22ee075a398365464bc5b39ba4ac5f8648399ac4) — fix: improve path matching and recursion with `default-open`

[`c42c2`](https://github.com/nuxt/ui/commit/c42c2ab47125f31278730fa929d8afae5134572a) — feat: handle collapsible false with type multiple

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components