---
title: "Vue InputNumber Component"
source: "https://ui.nuxt.com/docs/components/input-number"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "An input for numerical values with a customizable range."
tags:
---
## InputNumber

[NumberField](https://www.reka-ui.com/docs/components/number-field) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/InputNumber.vue)

An input for numerical values with a customizable range.

## Usage

Use the `v-model` directive to control the value of the InputNumber.

```
<script setup lang="ts">

const value = ref(5)

</script>

<template>

  <UInputNumber v-model="value" />

</template>
```

Use the `default-value` prop to set the initial value when you do not need to control its state.

```
<template>

  <UInputNumber :default-value="5" />

</template>
```

This component relies on the [`@internationalized/number`](https://react-spectrum.adobe.com/internationalized/number/index.html) package which provides utilities for formatting and parsing numbers across locales and numbering systems.

### Min / Max

Use the `min` and `max` props to set the minimum and maximum values of the InputNumber.

```
<script setup lang="ts">

const value = ref(5)

</script>

<template>

  <UInputNumber v-model="value" :min="0" :max="10" />

</template>
```

### Step

Use the `step` prop to set the step value of the InputNumber.

```
<script setup lang="ts">

const value = ref(5)

</script>

<template>

  <UInputNumber v-model="value" :step="2" />

</template>
```

### Orientation

Use the `orientation` prop to change the orientation of the InputNumber.

```
<script setup lang="ts">

const value = ref(5)

</script>

<template>

  <UInputNumber v-model="value" orientation="vertical" />

</template>
```

### Placeholder

Use the `placeholder` prop to set a placeholder text.

```
<template>

  <UInputNumber placeholder="Enter a number" />

</template>
```

### Color

Use the `color` prop to change the ring color when the InputNumber is focused.

```
<script setup lang="ts">

const value = ref(5)

</script>

<template>

  <UInputNumber v-model="value" color="neutral" highlight />

</template>
```

### Variant

Use the `variant` prop to change the variant of the InputNumber.

```
<script setup lang="ts">

const value = ref(5)

</script>

<template>

  <UInputNumber v-model="value" variant="subtle" color="neutral" />

</template>
```

### Size

Use the `size` prop to change the size of the InputNumber.

```
<script setup lang="ts">

const value = ref(5)

</script>

<template>

  <UInputNumber v-model="value" size="xl" />

</template>
```

### Disabled

Use the `disabled` prop to disable the InputNumber.

```
<script setup lang="ts">

const value = ref(5)

</script>

<template>

  <UInputNumber v-model="value" disabled />

</template>
```

### Increment / Decrement

Use the `increment` and `decrement` props to customize the increment and decrement buttons with any [Button](https://ui.nuxt.com/docs/components/button) props. Defaults to `{ variant: 'link' }`.

```
<script setup lang="ts">

const value = ref(5)

</script>

<template>

  <UInputNumber

    v-model="value"

    :increment="{

      color: 'neutral',

      variant: 'solid',

      size: 'xs'

    }"

    :decrement="{

      color: 'neutral',

      variant: 'solid',

      size: 'xs'

    }"

  />

</template>
```

### Increment / Decrement Icons

Use the `increment-icon` and `decrement-icon` props to customize the buttons [Icon](https://ui.nuxt.com/docs/components/icon). Defaults to `i-lucide-plus` / `i-lucide-minus`.

```
<script setup lang="ts">

const value = ref(5)

</script>

<template>

  <UInputNumber

    v-model="value"

    increment-icon="i-lucide-arrow-right"

    decrement-icon="i-lucide-arrow-left"

  />

</template>
```

## Examples

### With decimal format

Use the `format-options` prop to customize the format of the value.

```
<script setup lang="ts">

const value = ref(5)

</script>

<template>

  <UInputNumber

    v-model="value"

    :format-options="{

      signDisplay: 'exceptZero',

      minimumFractionDigits: 1

    }"

  />

</template>
```

### With percentage format

Use the `format-options` prop with `style: 'percent'` to customize the format of the value.

```
<script setup lang="ts">

const value = ref(0.05)

</script>

<template>

  <UInputNumber

    v-model="value"

    :step="0.01"

    :format-options="{

      style: 'percent'

    }"

  />

</template>
```

### With currency format

Use the `format-options` prop with `style: 'currency'` to customize the format of the value.

```
<script setup lang="ts">

const value = ref(1500)

</script>

<template>

  <UInputNumber

    v-model="value"

    :format-options="{

      style: 'currency',

      currency: 'EUR',

      currencyDisplay: 'code',

      currencySign: 'accounting'

    }"

  />

</template>
```

### Without buttons

You can use the `increment` and `decrement` props to control visibility of the buttons.

```
<script setup lang="ts">

const value = ref(5)

</script>

<template>

  <UInputNumber

    v-model="value"

    :increment="false"

    :decrement="false"

  />

</template>
```

### Within a FormField

You can use the InputNumber within a [FormField](https://ui.nuxt.com/docs/components/form-field) component to display a label, help text, required indicator, etc.

Specify number of attempts

```
<script setup lang="ts">

const retries = ref(0)

</script>

<template>

  <UFormField label="Retries" help="Specify number of attempts" required>

    <UInputNumber v-model="retries" placeholder="Enter retries" />

  </UFormField>

</template>
```

### With slots

Use the `#increment` and `#decrement` slots to customize the buttons.

```
<script setup lang="ts">

const value = ref(5)

</script>

<template>

  <UInputNumber v-model="value">

    <template #decrement>

      <UButton size="xs" icon="i-lucide-minus" />

    </template>

    <template #increment>

      <UButton size="xs" icon="i-lucide-plus" />

    </template>

  </UInputNumber>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `placeholder` |  | ` string`  The placeholder text when the input is empty. |
| `color` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `variant` | `'outline'` | ` "outline" \| "soft" \| "subtle" \| "ghost" \| "none"` |
| `size` | `'md'` | ` "xs" \| "sm" \| "md" \| "lg" \| "xl"` |
| `highlight` |  | `boolean`  Highlight the ring color like a focus state. |
| `orientation` | `'horizontal'` | ` "horizontal" \| "vertical"`  The orientation of the input number. |
| `increment` | `true` | `boolean \| Omit<ButtonProps, LinkPropsKeys>`  Configure the increment button. The `color` and `size` are inherited. |
| `incrementIcon` | `appConfig.ui.icons.plus` | `any`  The icon displayed to increment the value. |
| `incrementDisabled` |  | `boolean`  Disable the increment button. |
| `decrement` | `true` | `boolean \| Omit<ButtonProps, LinkPropsKeys>`  Configure the decrement button. The `color` and `size` are inherited. |
| `decrementIcon` | `appConfig.ui.icons.minus` | `any`  The icon displayed to decrement the value. |
| `decrementDisabled` |  | `boolean`  Disable the decrement button. |
| `autofocus` |  | `boolean` |
| `autofocusDelay` |  | ` number` |
| `modelModifiers` |  | ` Pick<ModelModifiers<T>, "optional">` |
| `modelValue` |  | ` null \| number` |
| `defaultValue` |  | ` number` |
| `min` |  | ` number`  The smallest value allowed for the input. |
| `max` |  | ` number`  The largest value allowed for the input. |
| `step` |  | ` number`  The amount that the input value changes with each increment or decrement "tick". |
| `stepSnapping` |  | `boolean`  When `false`, prevents the value from snapping to the nearest increment of the step value |
| `disabled` |  | `boolean`  When `true`, prevents the user from interacting with the Number Field. |
| `required` |  | `boolean`  When `true`, indicates that the user must set the value before the owning form can be submitted. |
| `id` |  | ` string`  Id of the element |
| `name` |  | ` string`  The name of the field. Submitted with its owning form as part of a name/value pair. |
| `formatOptions` |  | ` Intl.NumberFormatOptions`  Formatting options for the value displayed in the number field. This also affects what characters are allowed to be typed by the user. |
| `disableWheelChange` |  | `boolean`  When `true`, prevents the value from changing on wheel scroll. |
| `invertWheelChange` |  | `boolean`  When `true`, inverts the direction of the wheel change. |
| `readonly` |  | `boolean`  When `true`, the Number Field is read-only. |
| `list` |  | ` string` |
| `autocomplete` |  | ` "on" \| "off" \| string & {}` |
| `ui` |  | ` { root?: ClassNameValue; base?: ClassNameValue; increment?: ClassNameValue; decrement?: ClassNameValue; }` |

This component also supports all native `<input>` HTML attributes.

### Slots

| Slot | Type |
| --- | --- |
| `increment` | `{}` |
| `decrement` | `{}` |

### Emits

| Event | Type |
| --- | --- |
| `update:modelValue` | `[value: T]` |
| `blur` | `[event: FocusEvent]` |
| `change` | `[event: Event]` |

### Expose

When accessing the component via a template ref, you can use the following:

| Name | Type |
| --- | --- |
| `inputRef` | `Ref<HTMLInputElement \| null>` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    inputNumber: {

      slots: {

        root: 'relative inline-flex items-center',

        base: [

          'w-full rounded-md border-0 placeholder:text-dimmed focus:outline-none disabled:cursor-not-allowed disabled:opacity-75',

          'transition-colors'

        ],

        increment: 'absolute flex items-center',

        decrement: 'absolute flex items-center'

      },

      variants: {

        fieldGroup: {

          horizontal: {

            root: 'group has-focus-visible:z-[1]',

            base: 'group-not-only:group-first:rounded-e-none group-not-only:group-last:rounded-s-none group-not-last:group-not-first:rounded-none'

          },

          vertical: {

            root: 'group has-focus-visible:z-[1]',

            base: 'group-not-only:group-first:rounded-b-none group-not-only:group-last:rounded-t-none group-not-last:group-not-first:rounded-none'

          }

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

        size: {

          xs: 'px-2 py-1 text-xs gap-1',

          sm: 'px-2.5 py-1.5 text-xs gap-1.5',

          md: 'px-2.5 py-1.5 text-sm gap-1.5',

          lg: 'px-3 py-2 text-sm gap-2',

          xl: 'px-3 py-2 text-base gap-2'

        },

        variant: {

          outline: 'text-highlighted bg-default ring ring-inset ring-accented',

          soft: 'text-highlighted bg-elevated/50 hover:bg-elevated focus:bg-elevated disabled:bg-elevated/50',

          subtle: 'text-highlighted bg-elevated ring ring-inset ring-accented',

          ghost: 'text-highlighted bg-transparent hover:bg-elevated focus:bg-elevated disabled:bg-transparent dark:disabled:bg-transparent',

          none: 'text-highlighted bg-transparent'

        },

        disabled: {

          true: {

            increment: 'opacity-75 cursor-not-allowed',

            decrement: 'opacity-75 cursor-not-allowed'

          }

        },

        orientation: {

          horizontal: {

            base: 'text-center',

            increment: 'inset-y-0 end-0 pe-1',

            decrement: 'inset-y-0 start-0 ps-1'

          },

          vertical: {

            increment: 'top-0 end-0 pe-1 [&>button]:py-0 scale-80',

            decrement: 'bottom-0 end-0 pe-1 [&>button]:py-0 scale-80'

          }

        },

        highlight: {

          true: ''

        },

        increment: {

          false: ''

        },

        decrement: {

          false: ''

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

        },

        {

          orientation: 'horizontal',

          decrement: false,

          class: 'text-start'

        },

        {

          decrement: true,

          size: 'xs',

          class: 'ps-7'

        },

        {

          decrement: true,

          size: 'sm',

          class: 'ps-8'

        },

        {

          decrement: true,

          size: 'md',

          class: 'ps-9'

        },

        {

          decrement: true,

          size: 'lg',

          class: 'ps-10'

        },

        {

          decrement: true,

          size: 'xl',

          class: 'ps-11'

        },

        {

          increment: true,

          size: 'xs',

          class: 'pe-7'

        },

        {

          increment: true,

          size: 'sm',

          class: 'pe-8'

        },

        {

          increment: true,

          size: 'md',

          class: 'pe-9'

        },

        {

          increment: true,

          size: 'lg',

          class: 'pe-10'

        },

        {

          increment: true,

          size: 'xl',

          class: 'pe-11'

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

        inputNumber: {

          slots: {

            root: 'relative inline-flex items-center',

            base: [

              'w-full rounded-md border-0 placeholder:text-dimmed focus:outline-none disabled:cursor-not-allowed disabled:opacity-75',

              'transition-colors'

            ],

            increment: 'absolute flex items-center',

            decrement: 'absolute flex items-center'

          },

          variants: {

            fieldGroup: {

              horizontal: {

                root: 'group has-focus-visible:z-[1]',

                base: 'group-not-only:group-first:rounded-e-none group-not-only:group-last:rounded-s-none group-not-last:group-not-first:rounded-none'

              },

              vertical: {

                root: 'group has-focus-visible:z-[1]',

                base: 'group-not-only:group-first:rounded-b-none group-not-only:group-last:rounded-t-none group-not-last:group-not-first:rounded-none'

              }

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

            size: {

              xs: 'px-2 py-1 text-xs gap-1',

              sm: 'px-2.5 py-1.5 text-xs gap-1.5',

              md: 'px-2.5 py-1.5 text-sm gap-1.5',

              lg: 'px-3 py-2 text-sm gap-2',

              xl: 'px-3 py-2 text-base gap-2'

            },

            variant: {

              outline: 'text-highlighted bg-default ring ring-inset ring-accented',

              soft: 'text-highlighted bg-elevated/50 hover:bg-elevated focus:bg-elevated disabled:bg-elevated/50',

              subtle: 'text-highlighted bg-elevated ring ring-inset ring-accented',

              ghost: 'text-highlighted bg-transparent hover:bg-elevated focus:bg-elevated disabled:bg-transparent dark:disabled:bg-transparent',

              none: 'text-highlighted bg-transparent'

            },

            disabled: {

              true: {

                increment: 'opacity-75 cursor-not-allowed',

                decrement: 'opacity-75 cursor-not-allowed'

              }

            },

            orientation: {

              horizontal: {

                base: 'text-center',

                increment: 'inset-y-0 end-0 pe-1',

                decrement: 'inset-y-0 start-0 ps-1'

              },

              vertical: {

                increment: 'top-0 end-0 pe-1 [&>button]:py-0 scale-80',

                decrement: 'bottom-0 end-0 pe-1 [&>button]:py-0 scale-80'

              }

            },

            highlight: {

              true: ''

            },

            increment: {

              false: ''

            },

            decrement: {

              false: ''

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

            },

            {

              orientation: 'horizontal',

              decrement: false,

              class: 'text-start'

            },

            {

              decrement: true,

              size: 'xs',

              class: 'ps-7'

            },

            {

              decrement: true,

              size: 'sm',

              class: 'ps-8'

            },

            {

              decrement: true,

              size: 'md',

              class: 'ps-9'

            },

            {

              decrement: true,

              size: 'lg',

              class: 'ps-10'

            },

            {

              decrement: true,

              size: 'xl',

              class: 'ps-11'

            },

            {

              increment: true,

              size: 'xs',

              class: 'pe-7'

            },

            {

              increment: true,

              size: 'sm',

              class: 'pe-8'

            },

            {

              increment: true,

              size: 'md',

              class: 'pe-9'

            },

            {

              increment: true,

              size: 'lg',

              class: 'pe-10'

            },

            {

              increment: true,

              size: 'xl',

              class: 'pe-11'

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

[`55646`](https://github.com/nuxt/ui/commit/55646eaeab1598ad53b95baa2c8acb15f798482b) — feat: add `valueKey` prop ([#5905](https://github.com/nuxt/ui/issues/5905))

[`184ea`](https://github.com/nuxt/ui/commit/184eaab1cd5f4f4943b509ea1a3efb1b6f6d7f91) — chore: reduce type verbosity by omitting link props from action buttons

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`a6efa`](https://github.com/nuxt/ui/commit/a6efa7a48cc33fa83efa96f7b41f6049e6816786) — fix: remove `locale` / `dir` props proxy ([#5432](https://github.com/nuxt/ui/issues/5432))

[`fda3c`](https://github.com/nuxt/ui/commit/fda3c98ab798f045e6e3d781ec482ebe5f360c4e) — fix: clean html attributes extend

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`fce2d`](https://github.com/nuxt/ui/commit/fce2df4e0660d0bdb3cdd4fb3041416824cbe893) — fix!: consistent exposed refs ([#5385](https://github.com/nuxt/ui/issues/5385))

[`5c347`](https://github.com/nuxt/ui/commit/5c347af8a3fee7b079171f3e69b68d87adb9a83a) — fix: make `modelModifiers` generic ([#5361](https://github.com/nuxt/ui/issues/5361))

[`18589`](https://github.com/nuxt/ui/commit/1858908d80237d1af858af054212a02ccdb8f9ad) — feat: handle `increment` / `decrement` as booleans ([#4805](https://github.com/nuxt/ui/issues/4805))

[`11a03`](https://github.com/nuxt/ui/commit/11a03201ed8454f37e911db4a14b00f74104932a) — fix: dot notation type support for `labelKey` and `valueKey` ([#4933](https://github.com/nuxt/ui/issues/4933))

[`83b03`](https://github.com/nuxt/ui/commit/83b0306a30835a385049200c5de804c51577c64c) — feat!: rename `nullify` modifier to `nullable` and add `optional` ([#4838](https://github.com/nuxt/ui/issues/4838))

[`7133f`](https://github.com/nuxt/ui/commit/7133f501e4346ba6990c437cfa16af05b886c884) — fix: broken types for `update:model-value` event ([#4853](https://github.com/nuxt/ui/issues/4853))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`a0963`](https://github.com/nuxt/ui/commit/a0963eba8254d2ecf02cd1ee87cee7f73c4b2bc4) — feat!: rename from `ButtonGroup` ([#4596](https://github.com/nuxt/ui/issues/4596))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`ee484`](https://github.com/nuxt/ui/commit/ee48446b4fcb440cf820ae0b9ecbe3ba089fcf00) — chore: update dependency reka-ui to v2.4.1 (v3) ([#4586](https://github.com/nuxt/ui/issues/4586))

[`6f2ce`](https://github.com/nuxt/ui/commit/6f2ce5c610e1247e70b6e2072059cf6ecbe82711) — refactor: unite syntax for emits declaration ([#4512](https://github.com/nuxt/ui/issues/4512))

[`f7613`](https://github.com/nuxt/ui/commit/f761369888c49fd0ee0f028dcf3c55dd5fbd2cae) — chore: update dependency reka-ui to ^2.3.0 (v3) ([#4234](https://github.com/nuxt/ui/issues/4234))

[`2e4c3`](https://github.com/nuxt/ui/commit/2e4c3082a1e66fa597086dc3431fec37fa29ef62) — fix: handle inside button group

[`c7fba`](https://github.com/nuxt/ui/commit/c7fba2e0ebfb7153f3bfb727165d653bbd3dbe54) — feat: add `increment-disabled` / `decrement-disabled` props ([#4141](https://github.com/nuxt/ui/issues/4141))

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`4d817`](https://github.com/nuxt/ui/commit/4d8179ba08bc69f28a541fa6d6cf3519db322662) — chore: clean functions order

[`f5e62`](https://github.com/nuxt/ui/commit/f5e62849c9313063396ab0e3a9b7d22d98ef69bc) — feat: add support for `stepSnapping` & `disableWheelChange` props ([#3731](https://github.com/nuxt/ui/issues/3731))