---
title: "Vue Alert Component"
source: "https://ui.nuxt.com/docs/components/alert"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A callout to draw user's attention."
tags:
---
## Alert

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Alert.vue)

A callout to draw user's attention.

## Usage

Use the `title` prop to set the title of the Alert.

```
<template>

  <UAlert title="Heads up!" />

</template>
```

### Description

Use the `description` prop to set the description of the Alert.

```
<template>

  <UAlert title="Heads up!" description="You can change the primary color in your app config." />

</template>
```

### Icon

Use the `icon` prop to show an [Icon](https://ui.nuxt.com/docs/components/icon).

```
<template>

  <UAlert

    title="Heads up!"

    description="You can change the primary color in your app config."

    icon="i-lucide-terminal"

  />

</template>
```

Use the `avatar` prop to show an [Avatar](https://ui.nuxt.com/docs/components/avatar).

```
<template>

  <UAlert

    title="Heads up!"

    description="You can change the primary color in your app config."

    :avatar="{

      src: 'https://github.com/nuxt.png'

    }"

  />

</template>
```

### Color

Use the `color` prop to change the color of the Alert.

```
<template>

  <UAlert

    color="neutral"

    title="Heads up!"

    description="You can change the primary color in your app config."

    icon="i-lucide-terminal"

  />

</template>
```

### Variant

Use the `variant` prop to change the variant of the Alert.

```
<template>

  <UAlert

    color="neutral"

    variant="subtle"

    title="Heads up!"

    description="You can change the primary color in your app config."

    icon="i-lucide-terminal"

  />

</template>
```

### Close

Use the `close` prop to display a [Button](https://ui.nuxt.com/docs/components/button) to dismiss the Alert.

An `update:open` event will be emitted when the close button is clicked.

```
<template>

  <UAlert

    title="Heads up!"

    description="You can change the primary color in your app config."

    color="neutral"

    variant="outline"

    close

  />

</template>
```

You can pass any property from the [Button](https://ui.nuxt.com/docs/components/button) component to customize it.

```
<template>

  <UAlert

    title="Heads up!"

    description="You can change the primary color in your app config."

    color="neutral"

    variant="outline"

    :close="{

      color: 'primary',

      variant: 'outline',

      class: 'rounded-full'

    }"

  />

</template>
```

### Close Icon

Use the `close-icon` prop to customize the close button [Icon](https://ui.nuxt.com/docs/components/icon). Defaults to `i-lucide-x`.

```
<template>

  <UAlert

    title="Heads up!"

    description="You can change the primary color in your app config."

    color="neutral"

    variant="outline"

    close

    close-icon="i-lucide-arrow-right"

  />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.close` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.close` key.

### Actions

Use the `actions` prop to add some [Button](https://ui.nuxt.com/docs/components/button) actions to the Alert.

```
<template>

  <UAlert

    title="Heads up!"

    description="You can change the primary color in your app config."

    color="neutral"

    variant="outline"

    :actions="[

      {

        label: 'Action 1'

      },

      {

        label: 'Action 2',

        color: 'neutral',

        variant: 'subtle'

      }

    ]"

  />

</template>
```

### Orientation

Use the `orientation` prop to change the orientation of the Alert.

Heads up!

You can change the primary color in your app config.

```
<template>

  <UAlert

    title="Heads up!"

    description="You can change the primary color in your app config."

    color="neutral"

    variant="outline"

    orientation="horizontal"

    :actions="[

      {

        label: 'Action 1'

      },

      {

        label: 'Action 2',

        color: 'neutral',

        variant: 'subtle'

      }

    ]"

  />

</template>
```

## Examples

### class prop

Use the `class` prop to override the base styles of the Alert.

```
<template>

  <UAlert

    title="Heads up!"

    description="You can change the primary color in your app config."

    class="rounded-none"

  />

</template>
```

### ui prop

Use the `ui` prop to override the slots styles of the Alert.

```
<template>

  <UAlert

    title="Heads up!"

    description="You can change the primary color in your app config."

    icon="i-lucide-rocket"

    :ui="{

      icon: 'size-11'

    }"

  />

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `title` |  | ` string` |
| `description` |  | ` string` |
| `icon` |  | `any` |
| `avatar` |  | ` AvatarProps` |
| `color` | `'primary'` | ` "error" \| "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "neutral"` |
| `variant` | `'solid'` | ` "solid" \| "outline" \| "soft" \| "subtle"` |
| `orientation` | `'vertical'` | ` "vertical" \| "horizontal"`  The orientation between the content and the actions. |
| `actions` |  | ` ButtonProps[]`  Display a list of actions:  - under the title and description when orientation is `vertical` - next to the close button when orientation is `horizontal` `{ size: 'xs' }` |
| `close` | `false` | `boolean \| Omit<ButtonProps, LinkPropsKeys>`  Display a close button to dismiss the alert.`{ size: 'md', color: 'neutral', variant: 'link' }` |
| `closeIcon` | `appConfig.ui.icons.close` | `any`  The icon displayed in the close button. |
| `ui` |  | ` { root?: ClassNameValue; wrapper?: ClassNameValue; title?: ClassNameValue; description?: ClassNameValue; icon?: ClassNameValue; avatar?: ClassNameValue; avatarSize?: ClassNameValue; actions?: ClassNameValue; close?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `leading` | `{ ui: object; }` |
| `title` | `{}` |
| `description` | `{}` |
| `actions` | `{}` |
| `close` | `{ ui: object; }` |

### Emits

| Event | Type |
| --- | --- |
| `update:open` | `[value: boolean]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    alert: {

      slots: {

        root: 'relative overflow-hidden w-full rounded-lg p-4 flex gap-2.5',

        wrapper: 'min-w-0 flex-1 flex flex-col',

        title: 'text-sm font-medium',

        description: 'text-sm opacity-90',

        icon: 'shrink-0 size-5',

        avatar: 'shrink-0',

        avatarSize: '2xl',

        actions: 'flex flex-wrap gap-1.5 shrink-0',

        close: 'p-0'

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

        variant: {

          solid: '',

          outline: '',

          soft: '',

          subtle: ''

        },

        orientation: {

          horizontal: {

            root: 'items-center',

            actions: 'items-center'

          },

          vertical: {

            root: 'items-start',

            actions: 'items-start mt-2.5'

          }

        },

        title: {

          true: {

            description: 'mt-1'

          }

        }

      },

      compoundVariants: [

        {

          color: 'primary',

          variant: 'solid',

          class: {

            root: 'bg-primary text-inverted'

          }

        },

        {

          color: 'primary',

          variant: 'outline',

          class: {

            root: 'text-primary ring ring-inset ring-primary/25'

          }

        },

        {

          color: 'primary',

          variant: 'soft',

          class: {

            root: 'bg-primary/10 text-primary'

          }

        },

        {

          color: 'primary',

          variant: 'subtle',

          class: {

            root: 'bg-primary/10 text-primary ring ring-inset ring-primary/25'

          }

        },

        {

          color: 'neutral',

          variant: 'solid',

          class: {

            root: 'text-inverted bg-inverted'

          }

        },

        {

          color: 'neutral',

          variant: 'outline',

          class: {

            root: 'text-highlighted bg-default ring ring-inset ring-default'

          }

        },

        {

          color: 'neutral',

          variant: 'soft',

          class: {

            root: 'text-highlighted bg-elevated/50'

          }

        },

        {

          color: 'neutral',

          variant: 'subtle',

          class: {

            root: 'text-highlighted bg-elevated/50 ring ring-inset ring-accented'

          }

        }

      ],

      defaultVariants: {

        color: 'primary',

        variant: 'solid'

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

        alert: {

          slots: {

            root: 'relative overflow-hidden w-full rounded-lg p-4 flex gap-2.5',

            wrapper: 'min-w-0 flex-1 flex flex-col',

            title: 'text-sm font-medium',

            description: 'text-sm opacity-90',

            icon: 'shrink-0 size-5',

            avatar: 'shrink-0',

            avatarSize: '2xl',

            actions: 'flex flex-wrap gap-1.5 shrink-0',

            close: 'p-0'

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

            variant: {

              solid: '',

              outline: '',

              soft: '',

              subtle: ''

            },

            orientation: {

              horizontal: {

                root: 'items-center',

                actions: 'items-center'

              },

              vertical: {

                root: 'items-start',

                actions: 'items-start mt-2.5'

              }

            },

            title: {

              true: {

                description: 'mt-1'

              }

            }

          },

          compoundVariants: [

            {

              color: 'primary',

              variant: 'solid',

              class: {

                root: 'bg-primary text-inverted'

              }

            },

            {

              color: 'primary',

              variant: 'outline',

              class: {

                root: 'text-primary ring ring-inset ring-primary/25'

              }

            },

            {

              color: 'primary',

              variant: 'soft',

              class: {

                root: 'bg-primary/10 text-primary'

              }

            },

            {

              color: 'primary',

              variant: 'subtle',

              class: {

                root: 'bg-primary/10 text-primary ring ring-inset ring-primary/25'

              }

            },

            {

              color: 'neutral',

              variant: 'solid',

              class: {

                root: 'text-inverted bg-inverted'

              }

            },

            {

              color: 'neutral',

              variant: 'outline',

              class: {

                root: 'text-highlighted bg-default ring ring-inset ring-default'

              }

            },

            {

              color: 'neutral',

              variant: 'soft',

              class: {

                root: 'text-highlighted bg-elevated/50'

              }

            },

            {

              color: 'neutral',

              variant: 'subtle',

              class: {

                root: 'text-highlighted bg-elevated/50 ring ring-inset ring-accented'

              }

            }

          ],

          defaultVariants: {

            color: 'primary',

            variant: 'solid'

          }

        }

      }

    })

  ]

})
```

Some colors in `compoundVariants` are omitted for readability. Check out the source code on GitHub.

## Changelog

[`184ea`](https://github.com/nuxt/ui/commit/184eaab1cd5f4f4943b509ea1a3efb1b6f6d7f91) — chore: reduce type verbosity by omitting link props from action buttons

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`6f2ce`](https://github.com/nuxt/ui/commit/6f2ce5c610e1247e70b6e2072059cf6ecbe82711) — refactor: unite syntax for emits declaration ([#4512](https://github.com/nuxt/ui/issues/4512))

[`be41a`](https://github.com/nuxt/ui/commit/be41aed1f3d3476801e1840dbb8766926bc93c05) — fix: remove default `md` size on buttons ([#4357](https://github.com/nuxt/ui/issues/4357))

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`50863`](https://github.com/nuxt/ui/commit/50863635d653c8083772046ddc5b828fba7047d0) — fix: display actions when using slots

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`b9983`](https://github.com/nuxt/ui/commit/b9983549a4b743724ea3ef99cc4a243f5ca41e53) — fix: improve generic types ([#3331](https://github.com/nuxt/ui/issues/3331))[Main](https://ui.nuxt.com/docs/components/main)

[

A main element that fills the available viewport height.

](https://ui.nuxt.com/docs/components/main)[

Avatar

An img element with fallback and Nuxt Image support.

](https://ui.nuxt.com/docs/components/avatar)