---
title: "Vue Card Component"
source: "https://ui.nuxt.com/docs/components/card"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "Display content in a card with a header, body and footer."
tags:
---
## Usage

Use the `header`, `default` and `footer` slots to add content to the Card.

### Variant

Use the `variant` prop to change the variant of the Card.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `variant` | `'outline'` | ` "solid" \| "outline" \| "soft" \| "subtle"` |
| `ui` |  | ` { root?: ClassNameValue; header?: ClassNameValue; body?: ClassNameValue; footer?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `header` | `{}` |
| `default` | `{}` |
| `footer` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    card: {

      slots: {

        root: 'rounded-lg overflow-hidden',

        header: 'p-4 sm:px-6',

        body: 'p-4 sm:p-6',

        footer: 'p-4 sm:px-6'

      },

      variants: {

        variant: {

          solid: {

            root: 'bg-inverted text-inverted'

          },

          outline: {

            root: 'bg-default ring ring-default divide-y divide-default'

          },

          soft: {

            root: 'bg-elevated/50 divide-y divide-default'

          },

          subtle: {

            root: 'bg-elevated/50 ring ring-default divide-y divide-default'

          }

        }

      },

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

        card: {

          slots: {

            root: 'rounded-lg overflow-hidden',

            header: 'p-4 sm:px-6',

            body: 'p-4 sm:p-6',

            footer: 'p-4 sm:px-6'

          },

          variants: {

            variant: {

              solid: {

                root: 'bg-inverted text-inverted'

              },

              outline: {

                root: 'bg-default ring ring-default divide-y divide-default'

              },

              soft: {

                root: 'bg-elevated/50 divide-y divide-default'

              },

              subtle: {

                root: 'bg-elevated/50 ring ring-default divide-y divide-default'

              }

            }

          },

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

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`c3adc`](https://github.com/nuxt/ui/commit/c3adc381c90dad7152e27fc303ee678efc7c4c94) — fix: prevent scrollbars overflow ([#4368](https://github.com/nuxt/ui/issues/4368))

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))[Calendar](https://ui.nuxt.com/docs/components/calendar)

[

A calendar component for selecting single dates, multiple dates or date ranges.

](https://ui.nuxt.com/docs/components/calendar)[

Chip

An indicator of a numeric value or a state.

](https://ui.nuxt.com/docs/components/chip)