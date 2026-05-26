---
title: "Vue User Component"
source: "https://ui.nuxt.com/docs/components/user"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "Display user information with name, description and avatar."
tags:
---
## User

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/User.vue)

Display user information with name, description and avatar.

## Usage

### Name

Use the `name` prop to display a name for the user.

John Doe

```
<template>

  <UUser name="John Doe" />

</template>
```

### Description

Use the `description` prop to display a description for the user.

John Doe

Software Engineer

```
<template>

  <UUser name="John Doe" description="Software Engineer" />

</template>
```

Use the `avatar` prop to display an [Avatar](https://ui.nuxt.com/docs/components/avatar) component.

John Doe

Software Engineer

```
<template>

  <UUser

    name="John Doe"

    description="Software Engineer"

    :avatar="{

      src: 'https://i.pravatar.cc/150?u=john-doe',

      icon: 'i-lucide-image'

    }"

  />

</template>
```

### Chip

Use the `chip` prop to display a [Chip](https://ui.nuxt.com/docs/components/chip) component.

John Doe

Software Engineer

```
<template>

  <UUser

    name="John Doe"

    description="Software Engineer"

    :avatar="{

      src: 'https://i.pravatar.cc/150?u=john-doe'

    }"

    :chip="{

      color: 'primary',

      position: 'top-right'

    }"

  />

</template>
```

### Size

Use the `size` prop to change the size of the user avatar and text.

John Doe

Software Engineer

```
<template>

  <UUser

    name="John Doe"

    description="Software Engineer"

    :avatar="{

      src: 'https://i.pravatar.cc/150?u=john-doe'

    }"

    chip

    size="xl"

  />

</template>
```

### Orientation

Use the `orientation` prop to change the orientation. Defaults to `horizontal`.

```
<template>

  <UUser

    orientation="vertical"

    name="John Doe"

    description="Software Engineer"

    :avatar="{

      src: 'https://i.pravatar.cc/150?u=john-doe'

    }"

  />

</template>
```

### Link

You can pass any property from the [`<NuxtLink>`](https://nuxt.com/docs/api/components/nuxt-link) component such as `to`, `target`, `rel`, etc.

Benjamin Canac

Software Engineer

```
<template>

  <UUser

    to="https://github.com/benjamincanac"

    target="_blank"

    name="Benjamin Canac"

    description="Software Engineer"

    :avatar="{

      src: 'https://github.com/benjamincanac.png'

    }"

  />

</template>
```

The `NuxtLink` component will inherit all other attributes you pass to the `User` component.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `name` |  | ` string` |
| `description` |  | ` string` |
| `avatar` |  | ` Omit<AvatarProps, "size"> & { [key: string]: any; }` |
| `chip` |  | `boolean \| Omit<ChipProps, "size" \| "inset">` |
| `size` | `'md'` | ` "md" \| "3xs" \| "2xs" \| "xs" \| "sm" \| "lg" \| "xl" \| "2xl" \| "3xl"` |
| `orientation` | `'horizontal'` | ` "horizontal" \| "vertical"`  The orientation of the user. |
| `to` |  | ` string \| kt \| Tt` |
| `target` |  | ` null \| "_blank" \| "_parent" \| "_self" \| "_top" \| string & {}` |
| `ui` |  | ` { root?: ClassNameValue; wrapper?: ClassNameValue; name?: ClassNameValue; description?: ClassNameValue; avatar?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `avatar` | `{ ui: object; }` |
| `name` | `{}` |
| `description` | `{}` |
| `default` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    user: {

      slots: {

        root: 'relative group/user',

        wrapper: '',

        name: 'font-medium',

        description: 'text-muted',

        avatar: 'shrink-0'

      },

      variants: {

        orientation: {

          horizontal: {

            root: 'flex items-center'

          },

          vertical: {

            root: 'flex flex-col'

          }

        },

        to: {

          true: {

            name: [

              'text-default peer-hover:text-highlighted peer-focus-visible:text-highlighted',

              'transition-colors'

            ],

            description: [

              'peer-hover:text-toned peer-focus-visible:text-toned',

              'transition-colors'

            ],

            avatar: 'transform transition-transform duration-200 group-hover/user:scale-115 group-has-focus-visible/user:scale-115'

          },

          false: {

            name: 'text-highlighted',

            description: ''

          }

        },

        size: {

          '3xs': {

            root: 'gap-1',

            wrapper: 'flex items-center gap-1',

            name: 'text-xs',

            description: 'text-xs'

          },

          '2xs': {

            root: 'gap-1.5',

            wrapper: 'flex items-center gap-1.5',

            name: 'text-xs',

            description: 'text-xs'

          },

          xs: {

            root: 'gap-1.5',

            wrapper: 'flex items-center gap-1.5',

            name: 'text-xs',

            description: 'text-xs'

          },

          sm: {

            root: 'gap-2',

            name: 'text-xs',

            description: 'text-xs'

          },

          md: {

            root: 'gap-2',

            name: 'text-sm',

            description: 'text-xs'

          },

          lg: {

            root: 'gap-2.5',

            name: 'text-sm',

            description: 'text-sm'

          },

          xl: {

            root: 'gap-2.5',

            name: 'text-base',

            description: 'text-sm'

          },

          '2xl': {

            root: 'gap-3',

            name: 'text-base',

            description: 'text-base'

          },

          '3xl': {

            root: 'gap-3',

            name: 'text-lg',

            description: 'text-base'

          }

        }

      },

      defaultVariants: {

        size: 'md'

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

        user: {

          slots: {

            root: 'relative group/user',

            wrapper: '',

            name: 'font-medium',

            description: 'text-muted',

            avatar: 'shrink-0'

          },

          variants: {

            orientation: {

              horizontal: {

                root: 'flex items-center'

              },

              vertical: {

                root: 'flex flex-col'

              }

            },

            to: {

              true: {

                name: [

                  'text-default peer-hover:text-highlighted peer-focus-visible:text-highlighted',

                  'transition-colors'

                ],

                description: [

                  'peer-hover:text-toned peer-focus-visible:text-toned',

                  'transition-colors'

                ],

                avatar: 'transform transition-transform duration-200 group-hover/user:scale-115 group-has-focus-visible/user:scale-115'

              },

              false: {

                name: 'text-highlighted',

                description: ''

              }

            },

            size: {

              '3xs': {

                root: 'gap-1',

                wrapper: 'flex items-center gap-1',

                name: 'text-xs',

                description: 'text-xs'

              },

              '2xs': {

                root: 'gap-1.5',

                wrapper: 'flex items-center gap-1.5',

                name: 'text-xs',

                description: 'text-xs'

              },

              xs: {

                root: 'gap-1.5',

                wrapper: 'flex items-center gap-1.5',

                name: 'text-xs',

                description: 'text-xs'

              },

              sm: {

                root: 'gap-2',

                name: 'text-xs',

                description: 'text-xs'

              },

              md: {

                root: 'gap-2',

                name: 'text-sm',

                description: 'text-xs'

              },

              lg: {

                root: 'gap-2.5',

                name: 'text-sm',

                description: 'text-sm'

              },

              xl: {

                root: 'gap-2.5',

                name: 'text-base',

                description: 'text-sm'

              },

              '2xl': {

                root: 'gap-3',

                name: 'text-base',

                description: 'text-base'

              },

              '3xl': {

                root: 'gap-3',

                name: 'text-lg',

                description: 'text-base'

              }

            }

          },

          defaultVariants: {

            size: 'md'

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

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components