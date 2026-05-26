---
title: "Vue PinInput Component"
source: "https://ui.nuxt.com/docs/components/pin-input"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "An input element to enter a pin."
tags:
---
## PinInput

[PinInput](https://reka-ui.com/docs/components/pin-input) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/PinInput.vue)

An input element to enter a pin.

## Usage

Use the `v-model` directive to control the value of the PinInput.

```
<script setup lang="ts">

const value = ref([])

</script>

<template>

  <UPinInput v-model="value" />

</template>
```

Use the `default-value` prop to set the initial value when you do not need to control its state.

```
<template>

  <UPinInput :default-value="['1', '2', '3']" />

</template>
```

### Type

Use the `type` prop to change the input type. Defaults to `text`.

```
<template>

  <UPinInput type="number" />

</template>
```

When `type` is set to `number`, it will only accept numeric characters.

### Mask

Use the `mask` prop to treat the input like a password.

```
<template>

  <UPinInput mask :default-value="['1', '2', '3', '4', '5']" />

</template>
```

### OTP

Use the `otp` prop to enable One-Time Password functionality. When enabled, mobile devices can automatically detect and fill OTP codes from SMS messages or clipboard content, with autocomplete support.

```
<template>

  <UPinInput otp />

</template>
```

### Length

Use the `length` prop to change the amount of inputs.

```
<template>

  <UPinInput :length="6" />

</template>
```

### Placeholder

Use the `placeholder` prop to set a placeholder text.

```
<template>

  <UPinInput placeholder="○" />

</template>
```

### Color

Use the `color` prop to change the ring color when the PinInput is focused.

```
<template>

  <UPinInput color="neutral" highlight placeholder="○" />

</template>
```

The `highlight` prop is used here to show the focus state. It's used internally when a validation error occurs.

### Variant

Use the `variant` prop to change the variant of the PinInput.

```
<template>

  <UPinInput color="neutral" variant="subtle" placeholder="○" />

</template>
```

### Size

Use the `size` prop to change the size of the PinInput.

```
<template>

  <UPinInput size="xl" placeholder="○" />

</template>
```

### Disabled

Use the `disabled` prop to disable the PinInput.

```
<template>

  <UPinInput disabled placeholder="○" />

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `color` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `variant` | `'outline'` | ` "outline" \| "soft" \| "subtle" \| "ghost" \| "none"` |
| `size` | `'md'` | ` "md" \| "xs" \| "sm" \| "lg" \| "xl"` |
| `length` | `5` | ` string \| number`  The number of input fields. |
| `autofocus` |  | `boolean` |
| `autofocusDelay` | `0` | ` number` |
| `highlight` |  | `boolean` |
| `defaultValue` |  | ` PinInputValue<T>`  The default value of the pin inputs when it is initially rendered. Use when you do not need to control its checked state. |
| `disabled` |  | `boolean`  When `true`, prevents the user from interacting with the pin input |
| `id` |  | ` string`  Id of the element |
| `mask` |  | `boolean`  When `true`, pin inputs will be treated as password. |
| `modelValue` |  | ` null \| PinInputValue<T>`  The controlled checked state of the pin input. Can be binded as `v-model`. |
| `name` |  | ` string`  The name of the field. Submitted with its owning form as part of a name/value pair. |
| `otp` |  | `boolean`  When `true`, mobile devices will autodetect the OTP from messages or clipboard, and enable the autocomplete field. |
| `placeholder` |  | ` string`  The placeholder character to use for empty pin-inputs. |
| `required` |  | `boolean`  When `true`, indicates that the user must set the value before the owning form can be submitted. |
| `type` | `'text'` | ` T`  Input type for the inputs. |
| `ui` |  | ` { root?: ClassNameValue; base?: ClassNameValue; }` |

### Emits

| Event | Type |
| --- | --- |
| `update:modelValue` | `[value: PinInputValue<T>]` |
| `complete` | `[value: PinInputValue<T>]` |
| `change` | `[event: Event]` |
| `blur` | `[event: Event]` |

### Expose

When accessing the component via a template ref, you can use the following:

| Name | Type |
| --- | --- |
| `inputsRef` | `Ref<ComponentPublicInstance[]>` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    pinInput: {

      slots: {

        root: 'relative inline-flex items-center gap-1.5',

        base: [

          'rounded-md border-0 placeholder:text-dimmed text-center focus:outline-none disabled:cursor-not-allowed disabled:opacity-75',

          'transition-colors'

        ]

      },

      variants: {

        size: {

          xs: {

            base: 'size-6 text-xs'

          },

          sm: {

            base: 'size-7 text-xs'

          },

          md: {

            base: 'size-8 text-sm'

          },

          lg: {

            base: 'size-9 text-sm'

          },

          xl: {

            base: 'size-10 text-base'

          }

        },

        variant: {

          outline: 'text-highlighted bg-default ring ring-inset ring-accented',

          soft: 'text-highlighted bg-elevated/50 hover:bg-elevated focus:bg-elevated disabled:bg-elevated/50',

          subtle: 'text-highlighted bg-elevated ring ring-inset ring-accented',

          ghost: 'text-highlighted bg-transparent hover:bg-elevated focus:bg-elevated disabled:bg-transparent dark:disabled:bg-transparent',

          none: 'text-highlighted bg-transparent'

        },

        color: {

          primary: '',

          secondary: '',

          success: '',

          info: '',

          warning: '',

          error: '',

          neutral: ''

        },

        highlight: {

          true: ''

        }

      },

      compoundVariants: [

        {

          color: 'primary',

          variant: [

            'outline',

            'subtle'

          ],

          class: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-primary'

        },

        {

          color: 'primary',

          highlight: true,

          class: 'ring ring-inset ring-primary'

        },

        {

          color: 'neutral',

          variant: [

            'outline',

            'subtle'

          ],

          class: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-inverted'

        },

        {

          color: 'neutral',

          highlight: true,

          class: 'ring ring-inset ring-inverted'

        }

      ],

      defaultVariants: {

        size: 'md',

        color: 'primary',

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

        pinInput: {

          slots: {

            root: 'relative inline-flex items-center gap-1.5',

            base: [

              'rounded-md border-0 placeholder:text-dimmed text-center focus:outline-none disabled:cursor-not-allowed disabled:opacity-75',

              'transition-colors'

            ]

          },

          variants: {

            size: {

              xs: {

                base: 'size-6 text-xs'

              },

              sm: {

                base: 'size-7 text-xs'

              },

              md: {

                base: 'size-8 text-sm'

              },

              lg: {

                base: 'size-9 text-sm'

              },

              xl: {

                base: 'size-10 text-base'

              }

            },

            variant: {

              outline: 'text-highlighted bg-default ring ring-inset ring-accented',

              soft: 'text-highlighted bg-elevated/50 hover:bg-elevated focus:bg-elevated disabled:bg-elevated/50',

              subtle: 'text-highlighted bg-elevated ring ring-inset ring-accented',

              ghost: 'text-highlighted bg-transparent hover:bg-elevated focus:bg-elevated disabled:bg-transparent dark:disabled:bg-transparent',

              none: 'text-highlighted bg-transparent'

            },

            color: {

              primary: '',

              secondary: '',

              success: '',

              info: '',

              warning: '',

              error: '',

              neutral: ''

            },

            highlight: {

              true: ''

            }

          },

          compoundVariants: [

            {

              color: 'primary',

              variant: [

                'outline',

                'subtle'

              ],

              class: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-primary'

            },

            {

              color: 'primary',

              highlight: true,

              class: 'ring ring-inset ring-primary'

            },

            {

              color: 'neutral',

              variant: [

                'outline',

                'subtle'

              ],

              class: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-inverted'

            },

            {

              color: 'neutral',

              highlight: true,

              class: 'ring ring-inset ring-inverted'

            }

          ],

          defaultVariants: {

            size: 'md',

            color: 'primary',

            variant: 'outline'

          }

        }

      }

    })

  ]

})
```

Some colors in `compoundVariants` are omitted for readability. Check out the source code on GitHub.

## Changelog

[`48c12`](https://github.com/nuxt/ui/commit/48c1286605dc609957c01681cd59b1904a7944a0) — chore: update vue-tsc to ^3.2.1 (v4) ([#5738](https://github.com/nuxt/ui/issues/5738))

[`4a752`](https://github.com/nuxt/ui/commit/4a752fb1214c3bfd7f9730c8785b7e7071eaf278) — chore: update dependency reka-ui to v2.6.1 (v4) ([#5569](https://github.com/nuxt/ui/issues/5569))

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`7133f`](https://github.com/nuxt/ui/commit/7133f501e4346ba6990c437cfa16af05b886c884) — fix: broken types for `update:model-value` event ([#4853](https://github.com/nuxt/ui/issues/4853))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`ee484`](https://github.com/nuxt/ui/commit/ee48446b4fcb440cf820ae0b9ecbe3ba089fcf00) — chore: update dependency reka-ui to v2.4.1 (v3) ([#4586](https://github.com/nuxt/ui/issues/4586))

[`f7613`](https://github.com/nuxt/ui/commit/f761369888c49fd0ee0f028dcf3c55dd5fbd2cae) — chore: update dependency reka-ui to ^2.3.0 (v3) ([#4234](https://github.com/nuxt/ui/issues/4234))

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`4d817`](https://github.com/nuxt/ui/commit/4d8179ba08bc69f28a541fa6d6cf3519db322662) — chore: clean functions order

[`04566`](https://github.com/nuxt/ui/commit/0456670dac1153340220603c8c116e3b71f72ae7) — feat: add `autofocus` / `autofocus-delay` props

[`ef861`](https://github.com/nuxt/ui/commit/ef86108f14da23fa292afe016517eac95c34bf76) — chore: add eol in script tag to fix syntax highlight[InputTime](https://ui.nuxt.com/docs/components/input-time)

[

An input for selecting a time.

](https://ui.nuxt.com/docs/components/input-time)[

RadioGroup

A set of radio buttons to select a single option from a list.

](https://ui.nuxt.com/docs/components/radio-group)