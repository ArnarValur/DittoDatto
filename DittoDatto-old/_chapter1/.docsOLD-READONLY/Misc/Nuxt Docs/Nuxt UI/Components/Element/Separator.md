---
title: "Vue Separator Component"
source: "https://ui.nuxt.com/docs/components/separator"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "Separates content horizontally or vertically."
tags:
---
## Separator

[Separator](https://reka-ui.com/docs/components/separator) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Separator.vue)

Separates content horizontally or vertically.

## Usage

Use the Separator component as-is to separate content.

```
<template>

  <USeparator />

</template>
```

### Orientation

Use the `orientation` prop to change the orientation of the Separator. Defaults to `horizontal`.

```
<template>

  <USeparator orientation="vertical" class="h-48" />

</template>
```

### Label

Use the `label` prop to display a label in the middle of the Separator.

Hello World

```
<template>

  <USeparator label="Hello World" />

</template>
```

### Icon

Use the `icon` prop to display an icon in the middle of the Separator.

```
<template>

  <USeparator icon="i-simple-icons-nuxtdotjs" />

</template>
```

Use the `avatar` prop to display an avatar in the middle of the Separator.

```
<template>

  <USeparator

    :avatar="{

      src: 'https://github.com/nuxt.png'

    }"

  />

</template>
```

### Color

Use the `color` prop to change the color of the Separator. Defaults to `neutral`.

```
<template>

  <USeparator color="primary" type="solid" />

</template>
```

### Type

Use the `type` prop to change the type of the Separator. Defaults to `solid`.

```
<template>

  <USeparator type="dashed" />

</template>
```

### Size

Use the `size` prop to change the size of the Separator. Defaults to `xs`.

```
<template>

  <USeparator size="lg" />

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `label` |  | ` string`  Display a label in the middle. |
| `icon` |  | `any`  Display an icon in the middle. |
| `avatar` |  | ` AvatarProps`  Display an avatar in the middle. |
| `color` | `'neutral'` | ` "error" \| "neutral" \| "primary" \| "secondary" \| "success" \| "info" \| "warning"` |
| `size` | `'xs'` | ` "xs" \| "sm" \| "md" \| "lg" \| "xl"` |
| `type` | `'solid'` | ` "solid" \| "dashed" \| "dotted"` |
| `orientation` | `'horizontal'` | ` "horizontal" \| "vertical"`  The orientation of the separator. |
| `decorative` |  | `boolean` |
| `ui` |  | ` { root?: ClassNameValue; border?: ClassNameValue; container?: ClassNameValue; icon?: ClassNameValue; avatar?: ClassNameValue; avatarSize?: ClassNameValue; label?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{ ui: object; }` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    separator: {

      slots: {

        root: 'flex items-center align-center text-center',

        border: '',

        container: 'font-medium text-default flex',

        icon: 'shrink-0 size-5',

        avatar: 'shrink-0',

        avatarSize: '2xs',

        label: 'text-sm'

      },

      variants: {

        color: {

          primary: {

            border: 'border-primary'

          },

          secondary: {

            border: 'border-secondary'

          },

          success: {

            border: 'border-success'

          },

          info: {

            border: 'border-info'

          },

          warning: {

            border: 'border-warning'

          },

          error: {

            border: 'border-error'

          },

          neutral: {

            border: 'border-default'

          }

        },

        orientation: {

          horizontal: {

            root: 'w-full flex-row',

            border: 'w-full',

            container: 'mx-3 whitespace-nowrap'

          },

          vertical: {

            root: 'h-full flex-col',

            border: 'h-full',

            container: 'my-2'

          }

        },

        size: {

          xs: '',

          sm: '',

          md: '',

          lg: '',

          xl: ''

        },

        type: {

          solid: {

            border: 'border-solid'

          },

          dashed: {

            border: 'border-dashed'

          },

          dotted: {

            border: 'border-dotted'

          }

        }

      },

      compoundVariants: [

        {

          orientation: 'horizontal',

          size: 'xs',

          class: {

            border: 'border-t'

          }

        },

        {

          orientation: 'horizontal',

          size: 'sm',

          class: {

            border: 'border-t-[2px]'

          }

        },

        {

          orientation: 'horizontal',

          size: 'md',

          class: {

            border: 'border-t-[3px]'

          }

        },

        {

          orientation: 'horizontal',

          size: 'lg',

          class: {

            border: 'border-t-[4px]'

          }

        },

        {

          orientation: 'horizontal',

          size: 'xl',

          class: {

            border: 'border-t-[5px]'

          }

        },

        {

          orientation: 'vertical',

          size: 'xs',

          class: {

            border: 'border-s'

          }

        },

        {

          orientation: 'vertical',

          size: 'sm',

          class: {

            border: 'border-s-[2px]'

          }

        },

        {

          orientation: 'vertical',

          size: 'md',

          class: {

            border: 'border-s-[3px]'

          }

        },

        {

          orientation: 'vertical',

          size: 'lg',

          class: {

            border: 'border-s-[4px]'

          }

        },

        {

          orientation: 'vertical',

          size: 'xl',

          class: {

            border: 'border-s-[5px]'

          }

        }

      ],

      defaultVariants: {

        color: 'neutral',

        size: 'xs',

        type: 'solid'

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

        separator: {

          slots: {

            root: 'flex items-center align-center text-center',

            border: '',

            container: 'font-medium text-default flex',

            icon: 'shrink-0 size-5',

            avatar: 'shrink-0',

            avatarSize: '2xs',

            label: 'text-sm'

          },

          variants: {

            color: {

              primary: {

                border: 'border-primary'

              },

              secondary: {

                border: 'border-secondary'

              },

              success: {

                border: 'border-success'

              },

              info: {

                border: 'border-info'

              },

              warning: {

                border: 'border-warning'

              },

              error: {

                border: 'border-error'

              },

              neutral: {

                border: 'border-default'

              }

            },

            orientation: {

              horizontal: {

                root: 'w-full flex-row',

                border: 'w-full',

                container: 'mx-3 whitespace-nowrap'

              },

              vertical: {

                root: 'h-full flex-col',

                border: 'h-full',

                container: 'my-2'

              }

            },

            size: {

              xs: '',

              sm: '',

              md: '',

              lg: '',

              xl: ''

            },

            type: {

              solid: {

                border: 'border-solid'

              },

              dashed: {

                border: 'border-dashed'

              },

              dotted: {

                border: 'border-dotted'

              }

            }

          },

          compoundVariants: [

            {

              orientation: 'horizontal',

              size: 'xs',

              class: {

                border: 'border-t'

              }

            },

            {

              orientation: 'horizontal',

              size: 'sm',

              class: {

                border: 'border-t-[2px]'

              }

            },

            {

              orientation: 'horizontal',

              size: 'md',

              class: {

                border: 'border-t-[3px]'

              }

            },

            {

              orientation: 'horizontal',

              size: 'lg',

              class: {

                border: 'border-t-[4px]'

              }

            },

            {

              orientation: 'horizontal',

              size: 'xl',

              class: {

                border: 'border-t-[5px]'

              }

            },

            {

              orientation: 'vertical',

              size: 'xs',

              class: {

                border: 'border-s'

              }

            },

            {

              orientation: 'vertical',

              size: 'sm',

              class: {

                border: 'border-s-[2px]'

              }

            },

            {

              orientation: 'vertical',

              size: 'md',

              class: {

                border: 'border-s-[3px]'

              }

            },

            {

              orientation: 'vertical',

              size: 'lg',

              class: {

                border: 'border-s-[4px]'

              }

            },

            {

              orientation: 'vertical',

              size: 'xl',

              class: {

                border: 'border-s-[5px]'

              }

            }

          ],

          defaultVariants: {

            color: 'neutral',

            size: 'xs',

            type: 'solid'

          }

        }

      }

    })

  ]

})
```

## Changelog

[`55646`](https://github.com/nuxt/ui/commit/55646eaeab1598ad53b95baa2c8acb15f798482b) — feat: add `valueKey` prop ([#5905](https://github.com/nuxt/ui/issues/5905))

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))[Progress](https://ui.nuxt.com/docs/components/progress)

[

An indicator showing the progress of a task.

](https://ui.nuxt.com/docs/components/progress)[

Skeleton

A placeholder to show while content is loading.

](https://ui.nuxt.com/docs/components/skeleton)