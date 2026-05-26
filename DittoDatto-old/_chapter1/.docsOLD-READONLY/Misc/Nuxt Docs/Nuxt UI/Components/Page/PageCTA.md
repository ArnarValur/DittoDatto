---
title: "Vue PageCTA Component"
source: "https://ui.nuxt.com/docs/components/page-cta"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A call to action section to display in your pages."
tags:
---
## PageCTA

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/PageCTA.vue)

A call to action section to display in your pages.

## Usage

The PageCTA component provides a flexible way to display a call to action in your pages with an illustration in the default slot.

## Trusted and supported by our amazing community

Preview the latest Tailwind CSS and get started with Nuxt UI.

![Illustration](https://picsum.photos/640/616)

Use it inside a [PageSection](https://ui.nuxt.com/docs/components/page-section) component or directly in your page:

```
<template>

  <UPageHero />

  <UPageCTA class="rounded-none" />

  <UPageSection />

  <UPageSection :ui="{ container: 'px-0' }">

    <UPageCTA class="rounded-none sm:rounded-xl" />

  </UPageSection>

  <UPageSection />

</template>
```

Use `px-0` and `rounded-none` classes to make the CTA fill the edge of the page on mobile.

Use the `title` prop to set the title of the CTA.

```
<template>

  <UPageCTA title="Trusted and supported by our amazing community" />

</template>
```

### Description

Use the `description` prop to set the description of the CTA.

### Links

Use the `links` prop to display a list of [Button](https://ui.nuxt.com/docs/components/button) under the description.

### Variant

Use the `variant` prop to change the style of the CTA.

You can apply the `light` or `dark` class to the `links` slot when using the `solid` variant to reverse the colors.

### Orientation

Use the `orientation` prop to change the orientation with the default slot. Defaults to `vertical`.

### Reverse

Use the `reverse` prop to reverse the orientation of the default slot.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `title` |  | ` string` |
| `description` |  | ` string` |
| `orientation` | `'vertical'` | ` "vertical" \| "horizontal"`  The orientation of the page cta. |
| `reverse` | `false` | `boolean`  Reverse the order of the default slot. |
| `variant` | `'outline'` | ` "outline" \| "solid" \| "soft" \| "subtle" \| "naked"` |
| `links` |  | ` ButtonProps[]`  Display a list of Button under the description.`{ size: 'lg' }` |
| `ui` |  | ` { root?: ClassNameValue; container?: ClassNameValue; wrapper?: ClassNameValue; header?: ClassNameValue; title?: ClassNameValue; description?: ClassNameValue; body?: ClassNameValue; footer?: ClassNameValue; links?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `top` | `{}` |
| `header` | `{}` |
| `title` | `{}` |
| `description` | `{} ` |
| `body` | `{} ` |
| `footer` | `{} ` |
| `links` | `{} ` |
| `default` | `{} ` |
| `bottom` | `{} ` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    pageCTA: {

      slots: {

        root: 'relative isolate rounded-xl overflow-hidden',

        container: 'flex flex-col lg:grid px-6 py-12 sm:px-12 sm:py-24 lg:px-16 lg:py-24 gap-8 sm:gap-16',

        wrapper: '',

        header: '',

        title: 'text-3xl sm:text-4xl text-pretty tracking-tight font-bold text-highlighted',

        description: 'text-base sm:text-lg text-muted',

        body: 'mt-8',

        footer: 'mt-8',

        links: 'flex flex-wrap gap-x-6 gap-y-3'

      },

      variants: {

        orientation: {

          horizontal: {

            container: 'lg:grid-cols-2 lg:items-center',

            description: 'text-pretty'

          },

          vertical: {

            container: '',

            title: 'text-center',

            description: 'text-center text-balance',

            links: 'justify-center'

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

          naked: {

            description: 'text-muted'

          }

        },

        title: {

          true: {

            description: 'mt-6'

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

        pageCTA: {

          slots: {

            root: 'relative isolate rounded-xl overflow-hidden',

            container: 'flex flex-col lg:grid px-6 py-12 sm:px-12 sm:py-24 lg:px-16 lg:py-24 gap-8 sm:gap-16',

            wrapper: '',

            header: '',

            title: 'text-3xl sm:text-4xl text-pretty tracking-tight font-bold text-highlighted',

            description: 'text-base sm:text-lg text-muted',

            body: 'mt-8',

            footer: 'mt-8',

            links: 'flex flex-wrap gap-x-6 gap-y-3'

          },

          variants: {

            orientation: {

              horizontal: {

                container: 'lg:grid-cols-2 lg:items-center',

                description: 'text-pretty'

              },

              vertical: {

                container: '',

                title: 'text-center',

                description: 'text-center text-balance',

                links: 'justify-center'

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

              naked: {

                description: 'text-muted'

              }

            },

            title: {

              true: {

                description: 'mt-6'

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

[`60b43`](https://github.com/nuxt/ui/commit/60b430c3187f755a8ae21b64021c63bf9447420b) — fix: handle `reverse` prop under lg screens ([#5545](https://github.com/nuxt/ui/issues/5545))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[PageColumns](https://ui.nuxt.com/docs/components/page-columns)

[

A responsive multi-column layout system for organizing content side-by-side.

](https://ui.nuxt.com/docs/components/page-columns)[

PageFeature

A component to showcase key features of your application.

](https://ui.nuxt.com/docs/components/page-feature)