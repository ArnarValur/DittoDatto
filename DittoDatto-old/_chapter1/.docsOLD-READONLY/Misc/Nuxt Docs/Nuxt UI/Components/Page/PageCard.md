---
title: "Vue PageCard Component"
source: "https://ui.nuxt.com/docs/components/page-card"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A pre-styled card component that displays a title, description and optional link."
tags:
---
## PageCard

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/PageCard.vue)

A pre-styled card component that displays a title, description and optional link.

## Usage

The PageCard component provides a flexible way to display content in a card with an illustration in the default slot.

Use the [PageGrid](https://ui.nuxt.com/docs/components/page-grid), [PageColumns](https://ui.nuxt.com/docs/components/page-columns) or [PageList](https://ui.nuxt.com/docs/components/page-list) components to display multiple PageCard.

Use the `title` prop to set the title of the card.

```
<template>

  <UPageCard title="Tailwind CSS" />

</template>
```

### Description

Use the `description` prop to set the description of the card.

```
<template>

  <UPageCard

    title="Tailwind CSS"

    description="Nuxt UI integrates with latest Tailwind CSS, bringing significant improvements."

  />

</template>
```

### Icon

Use the `icon` prop to set the icon of the card.

```
<template>

  <UPageCard

    title="Tailwind CSS"

    description="Nuxt UI integrates with latest Tailwind CSS, bringing significant improvements."

    icon="i-simple-icons-tailwindcss"

  />

</template>
```

### Link

You can pass any property from the [`<NuxtLink>`](https://nuxt.com/docs/api/components/nuxt-link) component such as `to`, `target`, `rel`, etc.

```
<template>

  <UPageCard

    title="Tailwind CSS"

    description="Nuxt UI integrates with latest Tailwind CSS, bringing significant improvements."

    icon="i-simple-icons-tailwindcss"

    to="https://tailwindcss.com/docs/v4-beta"

    target="_blank"

  />

</template>
```

### Variant

Use the `variant` prop to change the style of the card.

```
<template>

  <UPageCard

    title="Tailwind CSS"

    description="Nuxt UI integrates with latest Tailwind CSS, bringing significant improvements."

    icon="i-simple-icons-tailwindcss"

    to="https://tailwindcss.com/docs/v4-beta"

    target="_blank"

    variant="soft"

  />

</template>
```

You can apply the `light` or `dark` class to the `links` slot when using the `solid` variant to reverse the colors.

### Orientation

Use the `orientation` prop to change the orientation with the default slot. Defaults to `vertical`.

Tailwind CSS

Nuxt UI integrates with latest Tailwind CSS, bringing significant improvements.

![Tailwind CSS](https://ui.nuxt.com/_ipx/_/tailwindcss-v4.svg)

```
<template>

  <UPageCard

    title="Tailwind CSS"

    description="Nuxt UI integrates with latest Tailwind CSS, bringing significant improvements."

    icon="i-simple-icons-tailwindcss"

    orientation="horizontal"

  >

    <img src="/tailwindcss-v4.svg" alt="Tailwind CSS" class="w-full" />

  </UPageCard>

</template>
```

### Reverse

Use the `reverse` prop to reverse the orientation of the default slot.

Tailwind CSS

Nuxt UI integrates with latest Tailwind CSS, bringing significant improvements.

![Tailwind CSS](https://ui.nuxt.com/_ipx/_/tailwindcss-v4.svg)

```
<template>

  <UPageCard

    title="Tailwind CSS"

    description="Nuxt UI integrates with latest Tailwind CSS, bringing significant improvements."

    icon="i-simple-icons-tailwindcss"

    orientation="horizontal"

    reverse

  >

    <img src="/tailwindcss-v4.svg" alt="Tailwind CSS" class="w-full" />

  </UPageCard>

</template>
```

### Highlight

Use the `highlight` and `highlight-color` props to display a highlighted border around the card.

Tailwind CSS

Nuxt UI integrates with latest Tailwind CSS, bringing significant improvements.

![Tailwind CSS](https://ui.nuxt.com/_ipx/_/tailwindcss-v4.svg)

```
<template>

  <UPageCard

    title="Tailwind CSS"

    description="Nuxt UI integrates with latest Tailwind CSS, bringing significant improvements."

    icon="i-simple-icons-tailwindcss"

    orientation="horizontal"

    highlight

    highlight-color="primary"

  >

    <img src="/tailwindcss-v4.svg" alt="Tailwind CSS" class="w-full" />

  </UPageCard>

</template>
```

### Spotlight

Use the `spotlight` and `spotlight-color` props to display a spotlight effect that follows your mouse cursor and highlights borders on hover.

The spotlight effect will take over hover effects when using a `to` prop. It's best to use it with the `outline` variant.

```
<template>

  <UPageCard

    title="Tailwind CSS"

    description="Nuxt UI integrates with latest Tailwind CSS, bringing significant improvements."

    icon="i-simple-icons-tailwindcss"

    orientation="horizontal"

    spotlight

    spotlight-color="primary"

  >

    <img src="/tailwindcss-v4.svg" alt="Tailwind CSS" class="w-full" />

  </UPageCard>

</template>
```

You can also customize the color and size by using the `--spotlight-color` and `--spotlight-size` CSS variables:

```
<template>

  <UPageCard spotlight class="[--spotlight-color:var(--ui-error)] [--spotlight-size:200px]" />

</template>
```

## Examples

### As a testimonial

Use the [User](https://ui.nuxt.com/docs/components/user) component in the `header` or `footer` slot to make the card look like a testimonial.

You can use the `PageColumns` component to display multiple PageCard in a multi-column layout.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `icon` |  | `any`  The icon displayed above the title. |
| `title` |  | ` string` |
| `description` |  | ` string` |
| `orientation` | `'vertical'` | ` "vertical" \| "horizontal"`  The orientation of the page card. |
| `reverse` | `false` | `boolean`  Reverse the order of the default slot. |
| `highlight` |  | `boolean`  Display a line around the page card. |
| `highlightColor` | `'primary'` | ` "error" \| "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "neutral"` |
| `spotlight` |  | `boolean`  Display a spotlight effect that follows your mouse cursor and highlights borders on hover. |
| `spotlightColor` | `'primary'` | ` "error" \| "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "neutral"` |
| `variant` | `'outline'` | ` "solid" \| "outline" \| "soft" \| "subtle" \| "ghost" \| "naked"` |
| `to` |  | ` string \| kt \| Tt` |
| `target` |  | ` null \| "_blank" \| "_parent" \| "_self" \| "_top" \| string & {}` |
| `ui` |  | ` { root?: ClassNameValue; spotlight?: ClassNameValue; container?: ClassNameValue; wrapper?: ClassNameValue; header?: ClassNameValue; body?: ClassNameValue; footer?: ClassNameValue; leading?: ClassNameValue; leadingIcon?: ClassNameValue; title?: ClassNameValue; description?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `header` | `{}` |
| `body` | `{}` |
| `leading` | `{ ui: object; }` |
| `title` | `{}` |
| `description` | `{}` |
| `footer` | `{}` |
| `default` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    pageCard: {

      slots: {

        root: 'relative flex rounded-lg',

        spotlight: 'absolute inset-0 rounded-[inherit] pointer-events-none bg-default/90',

        container: 'relative flex flex-col flex-1 lg:grid gap-x-8 gap-y-4 p-4 sm:p-6',

        wrapper: 'flex flex-col flex-1 items-start',

        header: 'mb-4',

        body: 'flex-1',

        footer: 'pt-4 mt-auto',

        leading: 'inline-flex items-center mb-2.5',

        leadingIcon: 'size-5 shrink-0 text-primary',

        title: 'text-base text-pretty font-semibold text-highlighted',

        description: 'text-[15px] text-pretty'

      },

      variants: {

        orientation: {

          horizontal: {

            container: 'lg:grid-cols-2 lg:items-center'

          },

          vertical: {

            container: ''

          }

        },

        reverse: {

          true: {

            wrapper: 'order-last'

          }

        },

        variant: {

          solid: {

            root: 'bg-inverted text-inverted',

            title: 'text-inverted',

            description: 'text-dimmed'

          },

          outline: {

            root: 'bg-default ring ring-default',

            description: 'text-muted'

          },

          soft: {

            root: 'bg-elevated/50',

            description: 'text-toned'

          },

          subtle: {

            root: 'bg-elevated/50 ring ring-default',

            description: 'text-toned'

          },

          ghost: {

            description: 'text-muted'

          },

          naked: {

            container: 'p-0 sm:p-0',

            description: 'text-muted'

          }

        },

        to: {

          true: {

            root: [

              'has-focus-visible:ring-2 has-focus-visible:ring-primary',

              'transition'

            ]

          }

        },

        title: {

          true: {

            description: 'mt-1'

          }

        },

        highlight: {

          true: {

            root: 'ring-2'

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

        spotlight: {

          true: {

            root: '[--spotlight-size:400px] before:absolute before:-inset-px before:pointer-events-none before:rounded-[inherit] before:bg-[radial-gradient(var(--spotlight-size)_var(--spotlight-size)_at_calc(var(--spotlight-x,0px))_calc(var(--spotlight-y,0px)),var(--spotlight-color),transparent_70%)]'

          }

        },

        spotlightColor: {

          primary: '',

          secondary: '',

          success: '',

          info: '',

          warning: '',

          error: '',

          neutral: ''

        }

      },

      compoundVariants: [

        {

          variant: 'solid',

          to: true,

          class: {

            root: 'hover:bg-inverted/90'

          }

        },

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

            root: 'hover:bg-elevated'

          }

        },

        {

          variant: 'subtle',

          to: true,

          highlight: false,

          class: {

            root: 'hover:ring-accented'

          }

        },

        {

          variant: 'ghost',

          to: true,

          class: {

            root: 'hover:bg-elevated/50'

          }

        },

        {

          highlightColor: 'primary',

          highlight: true,

          class: {

            root: 'ring-primary'

          }

        },

        {

          highlightColor: 'neutral',

          highlight: true,

          class: {

            root: 'ring-inverted'

          }

        },

        {

          spotlightColor: 'primary',

          spotlight: true,

          class: {

            root: '[--spotlight-color:var(--ui-primary)]'

          }

        },

        {

          spotlightColor: 'secondary',

          spotlight: true,

          class: {

            root: '[--spotlight-color:var(--ui-secondary)]'

          }

        },

        {

          spotlightColor: 'success',

          spotlight: true,

          class: {

            root: '[--spotlight-color:var(--ui-success)]'

          }

        },

        {

          spotlightColor: 'info',

          spotlight: true,

          class: {

            root: '[--spotlight-color:var(--ui-info)]'

          }

        },

        {

          spotlightColor: 'warning',

          spotlight: true,

          class: {

            root: '[--spotlight-color:var(--ui-warning)]'

          }

        },

        {

          spotlightColor: 'error',

          spotlight: true,

          class: {

            root: '[--spotlight-color:var(--ui-error)]'

          }

        },

        {

          spotlightColor: 'neutral',

          spotlight: true,

          class: {

            root: '[--spotlight-color:var(--ui-bg-inverted)]'

          }

        }

      ],

      defaultVariants: {

        variant: 'outline',

        highlightColor: 'primary',

        spotlightColor: 'primary'

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

        pageCard: {

          slots: {

            root: 'relative flex rounded-lg',

            spotlight: 'absolute inset-0 rounded-[inherit] pointer-events-none bg-default/90',

            container: 'relative flex flex-col flex-1 lg:grid gap-x-8 gap-y-4 p-4 sm:p-6',

            wrapper: 'flex flex-col flex-1 items-start',

            header: 'mb-4',

            body: 'flex-1',

            footer: 'pt-4 mt-auto',

            leading: 'inline-flex items-center mb-2.5',

            leadingIcon: 'size-5 shrink-0 text-primary',

            title: 'text-base text-pretty font-semibold text-highlighted',

            description: 'text-[15px] text-pretty'

          },

          variants: {

            orientation: {

              horizontal: {

                container: 'lg:grid-cols-2 lg:items-center'

              },

              vertical: {

                container: ''

              }

            },

            reverse: {

              true: {

                wrapper: 'order-last'

              }

            },

            variant: {

              solid: {

                root: 'bg-inverted text-inverted',

                title: 'text-inverted',

                description: 'text-dimmed'

              },

              outline: {

                root: 'bg-default ring ring-default',

                description: 'text-muted'

              },

              soft: {

                root: 'bg-elevated/50',

                description: 'text-toned'

              },

              subtle: {

                root: 'bg-elevated/50 ring ring-default',

                description: 'text-toned'

              },

              ghost: {

                description: 'text-muted'

              },

              naked: {

                container: 'p-0 sm:p-0',

                description: 'text-muted'

              }

            },

            to: {

              true: {

                root: [

                  'has-focus-visible:ring-2 has-focus-visible:ring-primary',

                  'transition'

                ]

              }

            },

            title: {

              true: {

                description: 'mt-1'

              }

            },

            highlight: {

              true: {

                root: 'ring-2'

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

            spotlight: {

              true: {

                root: '[--spotlight-size:400px] before:absolute before:-inset-px before:pointer-events-none before:rounded-[inherit] before:bg-[radial-gradient(var(--spotlight-size)_var(--spotlight-size)_at_calc(var(--spotlight-x,0px))_calc(var(--spotlight-y,0px)),var(--spotlight-color),transparent_70%)]'

              }

            },

            spotlightColor: {

              primary: '',

              secondary: '',

              success: '',

              info: '',

              warning: '',

              error: '',

              neutral: ''

            }

          },

          compoundVariants: [

            {

              variant: 'solid',

              to: true,

              class: {

                root: 'hover:bg-inverted/90'

              }

            },

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

                root: 'hover:bg-elevated'

              }

            },

            {

              variant: 'subtle',

              to: true,

              highlight: false,

              class: {

                root: 'hover:ring-accented'

              }

            },

            {

              variant: 'ghost',

              to: true,

              class: {

                root: 'hover:bg-elevated/50'

              }

            },

            {

              highlightColor: 'primary',

              highlight: true,

              class: {

                root: 'ring-primary'

              }

            },

            {

              highlightColor: 'neutral',

              highlight: true,

              class: {

                root: 'ring-inverted'

              }

            },

            {

              spotlightColor: 'primary',

              spotlight: true,

              class: {

                root: '[--spotlight-color:var(--ui-primary)]'

              }

            },

            {

              spotlightColor: 'secondary',

              spotlight: true,

              class: {

                root: '[--spotlight-color:var(--ui-secondary)]'

              }

            },

            {

              spotlightColor: 'success',

              spotlight: true,

              class: {

                root: '[--spotlight-color:var(--ui-success)]'

              }

            },

            {

              spotlightColor: 'info',

              spotlight: true,

              class: {

                root: '[--spotlight-color:var(--ui-info)]'

              }

            },

            {

              spotlightColor: 'warning',

              spotlight: true,

              class: {

                root: '[--spotlight-color:var(--ui-warning)]'

              }

            },

            {

              spotlightColor: 'error',

              spotlight: true,

              class: {

                root: '[--spotlight-color:var(--ui-error)]'

              }

            },

            {

              spotlightColor: 'neutral',

              spotlight: true,

              class: {

                root: '[--spotlight-color:var(--ui-bg-inverted)]'

              }

            }

          ],

          defaultVariants: {

            variant: 'outline',

            highlightColor: 'primary',

            spotlightColor: 'primary'

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

[`60b43`](https://github.com/nuxt/ui/commit/60b430c3187f755a8ae21b64021c63bf9447420b) — fix: handle `reverse` prop under lg screens ([#5545](https://github.com/nuxt/ui/issues/5545))

[`47d93`](https://github.com/nuxt/ui/commit/47d93d31d99e893d71cf4e2e78265d54d2e561a2) — fix: allow tab focus

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`30295`](https://github.com/nuxt/ui/commit/30295684653f89b811e75e7a79a9684814c68ec1) — fix: improve keyboard accessibility ([#4733](https://github.com/nuxt/ui/issues/4733))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[PageBody](https://ui.nuxt.com/docs/components/page-body)

[

The main content of your page.

](https://ui.nuxt.com/docs/components/page-body)[

PageColumns

A responsive multi-column layout system for organizing content side-by-side.

](https://ui.nuxt.com/docs/components/page-columns)