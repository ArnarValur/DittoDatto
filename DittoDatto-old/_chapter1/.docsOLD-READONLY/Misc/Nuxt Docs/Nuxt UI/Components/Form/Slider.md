---
title: "Vue Slider Component"
source: "https://ui.nuxt.com/docs/components/slider"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "An input to select a numeric value within a range."
tags:
---
## Slider

[Slider](https://reka-ui.com/docs/components/slider) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Slider.vue)

An input to select a numeric value within a range.

## Usage

Use the `v-model` directive to control the value of the Slider.

```
<script setup lang="ts">

const value = ref(50)

</script>

<template>

  <USlider v-model="value" />

</template>
```

Use the `default-value` prop to set the initial value when you do not need to control its state.

```
<template>

  <USlider :default-value="50" />

</template>
```

### Min / Max

Use the `min` and `max` props to set the minimum and maximum values of the Slider. Defaults to `0` and `100`.

```
<template>

  <USlider :min="0" :max="50" :default-value="50" />

</template>
```

### Step

Use the `step` prop to set the increment value of the Slider. Defaults to `1`.

```
<template>

  <USlider :step="10" :default-value="50" />

</template>
```

### Multiple

Use the `v-model` directive or the `default-value` prop with an array of values to create a range Slider.

```
<script setup lang="ts">

const value = ref([

  25,

  75

])

</script>

<template>

  <USlider v-model="value" />

</template>
```

Use the `min-steps-between-thumbs` prop to limit the minimum distance between the thumbs.

```
<script setup lang="ts">

const value = ref([

  25,

  50,

  75

])

</script>

<template>

  <USlider v-model="value" :min-steps-between-thumbs="10" />

</template>
```

### Orientation

Use the `orientation` prop to change the orientation of the Slider. Defaults to `horizontal`.

```
<template>

  <USlider orientation="vertical" :default-value="50" class="h-48" />

</template>
```

### Color

Use the `color` prop to change the color of the Slider.

```
<template>

  <USlider color="neutral" :default-value="50" />

</template>
```

### Size

Use the `size` prop to change the size of the Slider.

```
<template>

  <USlider size="xl" :default-value="50" />

</template>
```

Use the `tooltip` prop to display a [Tooltip](https://ui.nuxt.com/docs/components/tooltip) around the Slider thumbs with the current value. You can set it to `true` for default behavior or pass an object to customize it with any property from the [Tooltip](https://ui.nuxt.com/docs/components/tooltip#props) component.

```
<template>

  <USlider :default-value="50" tooltip />

</template>
```

### Disabled

Use the `disabled` prop to disable the Slider.

```
<template>

  <USlider disabled :default-value="50" />

</template>
```

### Inverted

Use the `inverted` prop to visually invert the Slider.

```
<template>

  <USlider inverted :default-value="25" />

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `size` | `'md'` | ` "xs" \| "sm" \| "md" \| "lg" \| "xl"` |
| `color` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `orientation` | `'horizontal'` | ` "horizontal" \| "vertical"`  The orientation of the slider. |
| `tooltip` | `false` | `boolean \| TooltipProps`  Display a tooltip around the slider thumbs with the current value.`{ disableClosingTrigger: true }` |
| `defaultValue` |  | ` number \| number[]`  The value of the slider when initially rendered. Use when you do not need to control the state of the slider. |
| `name` |  | ` string`  The name of the field. Submitted with its owning form as part of a name/value pair. |
| `disabled` |  | `boolean`  When `true`, prevents the user from interacting with the slider. |
| `inverted` |  | `boolean`  Whether the slider is visually inverted. |
| `min` | `0` | ` number`  The minimum value for the range. |
| `max` | `100` | ` number`  The maximum value for the range. |
| `step` | `1` | ` number`  The stepping interval. |
| `minStepsBetweenThumbs` |  | ` number`  The minimum permitted steps between multiple thumbs. |
| `modelValue` |  | ` T` |
| `ui` |  | ` { root?: ClassNameValue; track?: ClassNameValue; range?: ClassNameValue; thumb?: ClassNameValue; }` |

### Emits

| Event | Type |
| --- | --- |
| `change` | `[event: Event]` |
| `update:modelValue` | `[value: T \| undefined]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    slider: {

      slots: {

        root: 'relative flex items-center select-none touch-none',

        track: 'relative bg-accented overflow-hidden rounded-full grow',

        range: 'absolute rounded-full',

        thumb: 'rounded-full bg-default ring-2 focus-visible:outline-2 focus-visible:outline-offset-2'

      },

      variants: {

        color: {

          primary: {

            range: 'bg-primary',

            thumb: 'ring-primary focus-visible:outline-primary/50'

          },

          secondary: {

            range: 'bg-secondary',

            thumb: 'ring-secondary focus-visible:outline-secondary/50'

          },

          success: {

            range: 'bg-success',

            thumb: 'ring-success focus-visible:outline-success/50'

          },

          info: {

            range: 'bg-info',

            thumb: 'ring-info focus-visible:outline-info/50'

          },

          warning: {

            range: 'bg-warning',

            thumb: 'ring-warning focus-visible:outline-warning/50'

          },

          error: {

            range: 'bg-error',

            thumb: 'ring-error focus-visible:outline-error/50'

          },

          neutral: {

            range: 'bg-inverted',

            thumb: 'ring-inverted focus-visible:outline-inverted/50'

          }

        },

        size: {

          xs: {

            thumb: 'size-3'

          },

          sm: {

            thumb: 'size-3.5'

          },

          md: {

            thumb: 'size-4'

          },

          lg: {

            thumb: 'size-4.5'

          },

          xl: {

            thumb: 'size-5'

          }

        },

        orientation: {

          horizontal: {

            root: 'w-full',

            range: 'h-full'

          },

          vertical: {

            root: 'flex-col h-full',

            range: 'w-full'

          }

        },

        disabled: {

          true: {

            root: 'opacity-75 cursor-not-allowed'

          }

        }

      },

      compoundVariants: [

        {

          orientation: 'horizontal',

          size: 'xs',

          class: {

            track: 'h-[6px]'

          }

        },

        {

          orientation: 'horizontal',

          size: 'sm',

          class: {

            track: 'h-[7px]'

          }

        },

        {

          orientation: 'horizontal',

          size: 'md',

          class: {

            track: 'h-[8px]'

          }

        },

        {

          orientation: 'horizontal',

          size: 'lg',

          class: {

            track: 'h-[9px]'

          }

        },

        {

          orientation: 'horizontal',

          size: 'xl',

          class: {

            track: 'h-[10px]'

          }

        },

        {

          orientation: 'vertical',

          size: 'xs',

          class: {

            track: 'w-[6px]'

          }

        },

        {

          orientation: 'vertical',

          size: 'sm',

          class: {

            track: 'w-[7px]'

          }

        },

        {

          orientation: 'vertical',

          size: 'md',

          class: {

            track: 'w-[8px]'

          }

        },

        {

          orientation: 'vertical',

          size: 'lg',

          class: {

            track: 'w-[9px]'

          }

        },

        {

          orientation: 'vertical',

          size: 'xl',

          class: {

            track: 'w-[10px]'

          }

        }

      ],

      defaultVariants: {

        size: 'md',

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

        slider: {

          slots: {

            root: 'relative flex items-center select-none touch-none',

            track: 'relative bg-accented overflow-hidden rounded-full grow',

            range: 'absolute rounded-full',

            thumb: 'rounded-full bg-default ring-2 focus-visible:outline-2 focus-visible:outline-offset-2'

          },

          variants: {

            color: {

              primary: {

                range: 'bg-primary',

                thumb: 'ring-primary focus-visible:outline-primary/50'

              },

              secondary: {

                range: 'bg-secondary',

                thumb: 'ring-secondary focus-visible:outline-secondary/50'

              },

              success: {

                range: 'bg-success',

                thumb: 'ring-success focus-visible:outline-success/50'

              },

              info: {

                range: 'bg-info',

                thumb: 'ring-info focus-visible:outline-info/50'

              },

              warning: {

                range: 'bg-warning',

                thumb: 'ring-warning focus-visible:outline-warning/50'

              },

              error: {

                range: 'bg-error',

                thumb: 'ring-error focus-visible:outline-error/50'

              },

              neutral: {

                range: 'bg-inverted',

                thumb: 'ring-inverted focus-visible:outline-inverted/50'

              }

            },

            size: {

              xs: {

                thumb: 'size-3'

              },

              sm: {

                thumb: 'size-3.5'

              },

              md: {

                thumb: 'size-4'

              },

              lg: {

                thumb: 'size-4.5'

              },

              xl: {

                thumb: 'size-5'

              }

            },

            orientation: {

              horizontal: {

                root: 'w-full',

                range: 'h-full'

              },

              vertical: {

                root: 'flex-col h-full',

                range: 'w-full'

              }

            },

            disabled: {

              true: {

                root: 'opacity-75 cursor-not-allowed'

              }

            }

          },

          compoundVariants: [

            {

              orientation: 'horizontal',

              size: 'xs',

              class: {

                track: 'h-[6px]'

              }

            },

            {

              orientation: 'horizontal',

              size: 'sm',

              class: {

                track: 'h-[7px]'

              }

            },

            {

              orientation: 'horizontal',

              size: 'md',

              class: {

                track: 'h-[8px]'

              }

            },

            {

              orientation: 'horizontal',

              size: 'lg',

              class: {

                track: 'h-[9px]'

              }

            },

            {

              orientation: 'horizontal',

              size: 'xl',

              class: {

                track: 'h-[10px]'

              }

            },

            {

              orientation: 'vertical',

              size: 'xs',

              class: {

                track: 'w-[6px]'

              }

            },

            {

              orientation: 'vertical',

              size: 'sm',

              class: {

                track: 'w-[7px]'

              }

            },

            {

              orientation: 'vertical',

              size: 'md',

              class: {

                track: 'w-[8px]'

              }

            },

            {

              orientation: 'vertical',

              size: 'lg',

              class: {

                track: 'w-[9px]'

              }

            },

            {

              orientation: 'vertical',

              size: 'xl',

              class: {

                track: 'w-[10px]'

              }

            }

          ],

          defaultVariants: {

            size: 'md',

            color: 'primary'

          }

        }

      }

    })

  ]

})
```

## Changelog

[`55646`](https://github.com/nuxt/ui/commit/55646eaeab1598ad53b95baa2c8acb15f798482b) — feat: add `valueKey` prop ([#5905](https://github.com/nuxt/ui/issues/5905))

[`f99ec`](https://github.com/nuxt/ui/commit/f99ec46a353253db81aacae63f3d36dadff91786) — fix: add `aria-label` to thumb ([#5313](https://github.com/nuxt/ui/issues/5313))

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`7133f`](https://github.com/nuxt/ui/commit/7133f501e4346ba6990c437cfa16af05b886c884) — fix: broken types for `update:model-value` event ([#4853](https://github.com/nuxt/ui/issues/4853))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`6f2ce`](https://github.com/nuxt/ui/commit/6f2ce5c610e1247e70b6e2072059cf6ecbe82711) — refactor: unite syntax for emits declaration ([#4512](https://github.com/nuxt/ui/issues/4512))

[`d7a4d`](https://github.com/nuxt/ui/commit/d7a4d029b77d2dfa0b8efcd2755d482fa5e31fd3) — fix: handle generic types

[`d140a`](https://github.com/nuxt/ui/commit/d140acc608c6ae11c0a0531fe443588776ea7807) — feat: handle `tooltip` around thumbs

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))