---
title: "Vue Badge Component"
source: "https://ui.nuxt.com/docs/components/badge"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A short text to represent a status or a category."
tags:
---
---
title: "Vue Banner Component"
source: "https://ui.nuxt.com/docs/components/banner"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "Display a banner at the top of your website to inform users about important information."
tags:
---
## Usage

Use the `title` prop to display a title on the Banner.

### Icon

Use the `icon` prop to display an icon on the Banner.

### Color

Use the `color` prop to change the color of the Banner.

### Close

Use the `close` prop to display a [Button](https://ui.nuxt.com/docs/components/button) to dismiss the Banner. Defaults to `false`.

A `close` event will be emitted when the close button is clicked.

When closed, `banner-${id}` will be stored in the local storage to prevent it from being displayed again.  
For the example above, `banner-example` will be stored in the local storage.

### Close Icon

Use the `close-icon` prop to customize the close button [Icon](https://ui.nuxt.com/docs/components/icon). Defaults to `i-lucide-x`.

You can customize this icon globally in your `app.config.ts` under `ui.icons.close` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.close` key.

### Actions

Use the `actions` prop to add some [Button](https://ui.nuxt.com/docs/components/button) actions to the Banner.

The action buttons default to `color="neutral"` and `size="xs"`. You can customize these values by passing them directly to each action button.

### Link

You can pass any property from the [`<NuxtLink>`](https://nuxt.com/docs/api/components/nuxt-link) component such as `to`, `target`, `rel`, etc.

The `NuxtLink` component will inherit all other attributes you pass to the `User` component.

## Examples

### Within app.vue

Use the Banner component in your `app.vue` or in a layout:

app.vue

```
<template>

  <UApp>

    <UBanner icon="i-lucide-construction" title="Nuxt UI v4 has been released!" />

    <UHeader />

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
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `id` |  | ` string`  A unique id saved to local storage to remember if the banner has been dismissed. Without an explicit id, the banner will not be persisted and will reappear on page reload. |
| `icon` |  | `any`  The icon displayed next to the title. |
| `title` |  | ` string` |
| `actions` |  | ` ButtonProps[]`  Display a list of actions next to the title.`{ color: 'neutral', size: 'xs' }` |
| `to` |  | ` string \| kt \| Tt` |
| `target` |  | ` null \| "_blank" \| "_parent" \| "_self" \| "_top" \| string & {}` |
| `color` | `'primary'` | ` "error" \| "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "neutral"` |
| `close` | `false` | `boolean \| Omit<ButtonProps, LinkPropsKeys>`  Display a close button to dismiss the banner.`{ size: 'md', color: 'neutral', variant: 'ghost' }` |
| `closeIcon` | `appConfig.ui.icons.close` | `any`  The icon displayed in the close button. |
| `ui` |  | ` { root?: ClassNameValue; container?: ClassNameValue; left?: ClassNameValue; center?: ClassNameValue; right?: ClassNameValue; icon?: ClassNameValue; title?: ClassNameValue; actions?: ClassNameValue; close?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `leading` | `{ ui: object; }` |
| `title` | `{}` |
| `actions` | `{}` |
| `close` | `{ ui: object; }` |

### Emits

| Event | Type |
| --- | --- |
| `close` | `[]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    banner: {

      slots: {

        root: [

          'relative z-50 w-full',

          'transition-colors'

        ],

        container: 'flex items-center justify-between gap-3 h-12',

        left: 'hidden lg:flex-1 lg:flex lg:items-center',

        center: 'flex items-center gap-1.5 min-w-0',

        right: 'lg:flex-1 flex items-center justify-end',

        icon: 'size-5 shrink-0 text-inverted pointer-events-none',

        title: 'text-sm text-inverted font-medium truncate',

        actions: 'flex gap-1.5 shrink-0 isolate',

        close: 'text-inverted hover:bg-default/10 focus-visible:bg-default/10 -me-1.5 lg:me-0'

      },

      variants: {

        color: {

          primary: {

            root: 'bg-primary'

          },

          secondary: {

            root: 'bg-secondary'

          },

          success: {

            root: 'bg-success'

          },

          info: {

            root: 'bg-info'

          },

          warning: {

            root: 'bg-warning'

          },

          error: {

            root: 'bg-error'

          },

          neutral: {

            root: 'bg-inverted'

          }

        },

        to: {

          true: ''

        }

      },

      compoundVariants: [

        {

          color: 'primary',

          to: true,

          class: {

            root: 'hover:bg-primary/90'

          }

        },

        {

          color: 'neutral',

          to: true,

          class: {

            root: 'hover:bg-inverted/90'

          }

        }

      ],

      defaultVariants: {

        color: 'primary'

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

        banner: {

          slots: {

            root: [

              'relative z-50 w-full',

              'transition-colors'

            ],

            container: 'flex items-center justify-between gap-3 h-12',

            left: 'hidden lg:flex-1 lg:flex lg:items-center',

            center: 'flex items-center gap-1.5 min-w-0',

            right: 'lg:flex-1 flex items-center justify-end',

            icon: 'size-5 shrink-0 text-inverted pointer-events-none',

            title: 'text-sm text-inverted font-medium truncate',

            actions: 'flex gap-1.5 shrink-0 isolate',

            close: 'text-inverted hover:bg-default/10 focus-visible:bg-default/10 -me-1.5 lg:me-0'

          },

          variants: {

            color: {

              primary: {

                root: 'bg-primary'

              },

              secondary: {

                root: 'bg-secondary'

              },

              success: {

                root: 'bg-success'

              },

              info: {

                root: 'bg-info'

              },

              warning: {

                root: 'bg-warning'

              },

              error: {

                root: 'bg-error'

              },

              neutral: {

                root: 'bg-inverted'

              }

            },

            to: {

              true: ''

            }

          },

          compoundVariants: [

            {

              color: 'primary',

              to: true,

              class: {

                root: 'hover:bg-primary/90'

              }

            },

            {

              color: 'neutral',

              to: true,

              class: {

                root: 'hover:bg-inverted/90'

              }

            }

          ],

          defaultVariants: {

            color: 'primary'

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

[`4e334`](https://github.com/nuxt/ui/commit/4e334a0efddc6469aee4c30a4cc14982dd6ee77f) — fix: prevent XSS via id prop injection

[`184ea`](https://github.com/nuxt/ui/commit/184eaab1cd5f4f4943b509ea1a3efb1b6f6d7f91) — chore: reduce type verbosity by omitting link props from action buttons

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`5d6e1`](https://github.com/nuxt/ui/commit/5d6e1fcb29d7f58254847e328f4a66f65dddab70) — fix: ensure `actions` slot renders ([#4946](https://github.com/nuxt/ui/issues/4946))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[Badge](https://ui.nuxt.com/docs/components/badge)

[

A short text to represent a status or a category.

](https://ui.nuxt.com/docs/components/badge)[

Button

A button element that can act as a link or trigger an action.

](https://ui.nuxt.com/docs/components/button)