---
title: "Vue ColorPicker Component"
source: "https://ui.nuxt.com/docs/components/color-picker"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A component to select a color."
tags:
---
## ColorPicker

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/ColorPicker.vue)

A component to select a color.

## Usage

Use the `v-model` directive to control the value of the ColorPicker.

```
<script setup lang="ts">

const value = ref('#00C16A')

</script>

<template>

  <UColorPicker v-model="value" />

</template>
```

Use the `default-value` prop to set the initial value when you do not need to control its state.

```
<template>

  <UColorPicker default-value="#00BCD4" />

</template>
```

### RGB Format

Use the `format` prop to set `rgb` value of the ColorPicker.

```
<script setup lang="ts">

const value = ref('rgb(0, 193, 106)')

</script>

<template>

  <UColorPicker format="rgb" v-model="value" />

</template>
```

### HSL Format

Use the `format` prop to set `hsl` value of the ColorPicker.

```
<script setup lang="ts">

const value = ref('hsl(153, 100%, 37.8%)')

</script>

<template>

  <UColorPicker format="hsl" v-model="value" />

</template>
```

### CMYK Format

Use the `format` prop to set `cmyk` value of the ColorPicker.

```
<script setup lang="ts">

const value = ref('cmyk(100%, 0%, 45.08%, 24.31%)')

</script>

<template>

  <UColorPicker format="cmyk" v-model="value" />

</template>
```

### CIELab Format

Use the `format` prop to set `lab` value of the ColorPicker.

```
<script setup lang="ts">

const value = ref('lab(68.88% -60.41% 32.55%)')

</script>

<template>

  <UColorPicker format="lab" v-model="value" />

</template>
```

### Throttle

Use the `throttle` prop to set the throttle value of the ColorPicker.

```
<script setup lang="ts">

const value = ref('#00C16A')

</script>

<template>

  <UColorPicker :throttle="100" v-model="value" />

</template>
```

### Size

Use the `size` prop to set the size of the ColorPicker.

```
<template>

  <UColorPicker size="xl" />

</template>
```

### Disabled

Use the `disabled` prop to disable the ColorPicker.

```
<template>

  <UColorPicker disabled />

</template>
```

## Examples

### As a Color chooser

Use a [Button](https://ui.nuxt.com/docs/components/button) and a [Popover](https://ui.nuxt.com/docs/components/popover) component to create a color chooser.

```
<script setup lang="ts">

const color = ref('#00C16A')

const chip = computed(() => ({ backgroundColor: color.value }))

</script>

<template>

  <UPopover>

    <UButton label="Choose color" color="neutral" variant="outline">

      <template #leading>

        <span :style="chip" class="size-3 rounded-full" />

      </template>

    </UButton>

    <template #content>

      <UColorPicker v-model="color" class="p-2" />

    </template>

  </UPopover>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `throttle` | `50` | ` number`  Throttle time in ms for the color picker |
| `disabled` |  | `boolean`  Disable the color picker |
| `defaultValue` | `'#FFFFFF'` | ` string`  The default value of the color picker |
| `format` | `'hex'` | ` "hex" \| "rgb" \| "hsl" \| "cmyk" \| "lab"`  Format of the color |
| `size` | `'md'` | ` "xs" \| "sm" \| "md" \| "lg" \| "xl"` |
| `modelValue` |  | ` string` |
| `ui` |  | ` { root?: ClassNameValue; picker?: ClassNameValue; selector?: ClassNameValue; selectorBackground?: ClassNameValue; selectorThumb?: ClassNameValue; track?: ClassNameValue; trackThumb?: ClassNameValue; }` |

### Emits

| Event | Type |
| --- | --- |
| `update:modelValue` | `[value: string \| undefined]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    colorPicker: {

      slots: {

        root: 'data-[disabled]:opacity-75',

        picker: 'flex gap-4',

        selector: 'rounded-md touch-none',

        selectorBackground: 'w-full h-full relative rounded-md',

        selectorThumb: '-translate-y-1/2 -translate-x-1/2 absolute size-4 ring-2 ring-white rounded-full cursor-pointer data-[disabled]:cursor-not-allowed',

        track: 'w-[8px] relative rounded-md touch-none',

        trackThumb: 'absolute transform -translate-y-1/2 -translate-x-[4px] rtl:translate-x-[4px] size-4 rounded-full ring-2 ring-white cursor-pointer data-[disabled]:cursor-not-allowed'

      },

      variants: {

        size: {

          xs: {

            selector: 'w-38 h-38',

            track: 'h-38'

          },

          sm: {

            selector: 'w-40 h-40',

            track: 'h-40'

          },

          md: {

            selector: 'w-42 h-42',

            track: 'h-42'

          },

          lg: {

            selector: 'w-44 h-44',

            track: 'h-44'

          },

          xl: {

            selector: 'w-46 h-46',

            track: 'h-46'

          }

        }

      },

      compoundVariants: [],

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

        colorPicker: {

          slots: {

            root: 'data-[disabled]:opacity-75',

            picker: 'flex gap-4',

            selector: 'rounded-md touch-none',

            selectorBackground: 'w-full h-full relative rounded-md',

            selectorThumb: '-translate-y-1/2 -translate-x-1/2 absolute size-4 ring-2 ring-white rounded-full cursor-pointer data-[disabled]:cursor-not-allowed',

            track: 'w-[8px] relative rounded-md touch-none',

            trackThumb: 'absolute transform -translate-y-1/2 -translate-x-[4px] rtl:translate-x-[4px] size-4 rounded-full ring-2 ring-white cursor-pointer data-[disabled]:cursor-not-allowed'

          },

          variants: {

            size: {

              xs: {

                selector: 'w-38 h-38',

                track: 'h-38'

              },

              sm: {

                selector: 'w-40 h-40',

                track: 'h-40'

              },

              md: {

                selector: 'w-42 h-42',

                track: 'h-42'

              },

              lg: {

                selector: 'w-44 h-44',

                track: 'h-44'

              },

              xl: {

                selector: 'w-46 h-46',

                track: 'h-46'

              }

            }

          },

          compoundVariants: [],

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

[`d8960`](https://github.com/nuxt/ui/commit/d8960248362f7d615e1d9d5980217887efd29438) — chore: update vueuse monorepo to v14 (v4) (major) ([#5335](https://github.com/nuxt/ui/issues/5335))

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`7fca5`](https://github.com/nuxt/ui/commit/7fca5d754e600f6b830a9ea0eca3f98c51e6dd6b) — feat: add `theme.prefix` option ([#5341](https://github.com/nuxt/ui/issues/5341))

[`7133f`](https://github.com/nuxt/ui/commit/7133f501e4346ba6990c437cfa16af05b886c884) — fix: broken types for `update:model-value` event ([#4853](https://github.com/nuxt/ui/issues/4853))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`6b6ec`](https://github.com/nuxt/ui/commit/6b6ec8cb2c79cab558114e8c1838880dde9ab93e) — fix: update color conversion logic ([#4550](https://github.com/nuxt/ui/issues/4550))

[`cc20a`](https://github.com/nuxt/ui/commit/cc20a26f07268d19119ab4c7c254033143bb63f4) — fix: make thumb touch draggable ([#4101](https://github.com/nuxt/ui/issues/4101))

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`ef861`](https://github.com/nuxt/ui/commit/ef86108f14da23fa292afe016517eac95c34bf76) — chore: add eol in script tag to fix syntax highlight[CheckboxGroup](https://ui.nuxt.com/docs/components/checkbox-group)

[

A set of checklist buttons to select multiple option from a list.

](https://ui.nuxt.com/docs/components/checkbox-group)[

FileUpload

An input element to upload files.

](https://ui.nuxt.com/docs/components/file-upload)