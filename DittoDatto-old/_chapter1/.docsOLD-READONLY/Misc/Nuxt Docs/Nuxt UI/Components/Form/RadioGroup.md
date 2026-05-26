---
title: "Vue RadioGroup Component"
source: "https://ui.nuxt.com/docs/components/radio-group"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A set of radio buttons to select a single option from a list."
tags:
---
## RadioGroup

[RadioGroup](https://reka-ui.com/docs/components/radio-group) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/RadioGroup.vue)

A set of radio buttons to select a single option from a list.

## Usage

Use the `v-model` directive to control the value of the RadioGroup or the `default-value` prop to set the initial value when you do not need to control its state.

```
<script setup lang="ts">

const items = ref(['System', 'Light', 'Dark'])

const value = ref('System')

</script>

<template>

  <URadioGroup v-model="value" :items="items" />

</template>
```

### Items

Use the `items` prop as an array of strings or numbers:

```
<script setup lang="ts">

const items = ref(['System', 'Light', 'Dark'])

const value = ref('System')

</script>

<template>

  <URadioGroup v-model="value" :items="items" />

</template>
```

You can also pass an array of objects with the following properties:

- `label?: string`
- `description?: string`
- [`value?: string`](https://ui.nuxt.com/docs/components/#value-key)
- `disabled?: boolean`
- `class?: any`
- `ui?: { item?: ClassNameValue, container?: ClassNameValue, base?: ClassNameValue, 'indicator'?: ClassNameValue, wrapper?: ClassNameValue, label?: ClassNameValue, description?: ClassNameValue }`

```
<script setup lang="ts">

import type { RadioGroupItem } from '@nuxt/ui'

const items = ref<RadioGroupItem[]>([

  {

    label: 'System',

    description: 'This is the first option.',

    value: 'system'

  },

  {

    label: 'Light',

    description: 'This is the second option.',

    value: 'light'

  },

  {

    label: 'Dark',

    description: 'This is the third option.',

    value: 'dark'

  }

])

const value = ref('system')

</script>

<template>

  <URadioGroup v-model="value" :items="items" />

</template>
```

### Value Key

You can change the property that is used to set the value by using the `value-key` prop. Defaults to `value`.

```
<script setup lang="ts">

import type { RadioGroupItem } from '@nuxt/ui'

const items = ref<RadioGroupItem[]>([

  {

    label: 'System',

    description: 'This is the first option.',

    id: 'system'

  },

  {

    label: 'Light',

    description: 'This is the second option.',

    id: 'light'

  },

  {

    label: 'Dark',

    description: 'This is the third option.',

    id: 'dark'

  }

])

const value = ref('light')

</script>

<template>

  <URadioGroup v-model="value" value-key="id" :items="items" />

</template>
```

### Legend

Use the `legend` prop to set the legend of the RadioGroup.

```
<script setup lang="ts">

const items = ref(['System', 'Light', 'Dark'])

</script>

<template>

  <URadioGroup legend="Theme" default-value="System" :items="items" />

</template>
```

### Color

Use the `color` prop to change the color of the RadioGroup.

```
<script setup lang="ts">

const items = ref(['System', 'Light', 'Dark'])

</script>

<template>

  <URadioGroup color="neutral" default-value="System" :items="items" />

</template>
```

### Variant

Use the `variant` prop to change the variant of the RadioGroup.

```
<script setup lang="ts">

import type { RadioGroupItem } from '@nuxt/ui'

const items = ref<RadioGroupItem[]>([

  {

    label: 'Pro',

    value: 'pro',

    description: 'Tailored for indie hackers, freelancers and solo founders.'

  },

  {

    label: 'Startup',

    value: 'startup',

    description: 'Best suited for small teams, startups and agencies.'

  },

  {

    label: 'Enterprise',

    value: 'enterprise',

    description: 'Ideal for larger teams and organizations.'

  }

])

</script>

<template>

  <URadioGroup color="primary" variant="table" default-value="pro" :items="items" />

</template>
```

### Size

Use the `size` prop to change the size of the RadioGroup.

```
<script setup lang="ts">

const items = ref(['System', 'Light', 'Dark'])

</script>

<template>

  <URadioGroup size="xl" variant="list" default-value="System" :items="items" />

</template>
```

### Orientation

Use the `orientation` prop to change the orientation of the RadioGroup. Defaults to `vertical`.

```
<script setup lang="ts">

const items = ref(['System', 'Light', 'Dark'])

</script>

<template>

  <URadioGroup orientation="horizontal" variant="list" default-value="System" :items="items" />

</template>
```

### Indicator

Use the `indicator` prop to change the position or hide the indicator. Defaults to `start`.

```
<script setup lang="ts">

const items = ref(['System', 'Light', 'Dark'])

</script>

<template>

  <URadioGroup indicator="end" variant="card" default-value="System" :items="items" />

</template>
```

### Disabled

Use the `disabled` prop to disable the RadioGroup.

```
<script setup lang="ts">

const items = ref(['System', 'Light', 'Dark'])

</script>

<template>

  <URadioGroup disabled default-value="System" :items="items" />

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `legend` |  | ` string` |
| `valueKey` | `'value'` | ` VK`  When `items` is an array of objects, select the field to use as the value. |
| `labelKey` | `'label'` | ` keyof Extract<NestedItem<T>, object> \| DotPathKeys<Extract<NestedItem<T>, object>>`  When `items` is an array of objects, select the field to use as the label. |
| `descriptionKey` | `'description'` | ` keyof Extract<NestedItem<T>, object> \| DotPathKeys<Extract<NestedItem<T>, object>>`  When `items` is an array of objects, select the field to use as the description. |
| `items` |  | ` T` |
| `modelValue` |  | ` GetItemValue<T, VK, NestedItem<T>>`  The controlled value of the RadioGroup. Can be bind as `v-model`. |
| `defaultValue` |  | ` GetItemValue<T, VK, NestedItem<T>>`  The value of the RadioGroup when initially rendered. Use when you do not need to control the state of the RadioGroup. |
| `size` | `'md'` | ` "xs" \| "sm" \| "md" \| "lg" \| "xl"` |
| `variant` | `'list'` | ` "card" \| "list" \| "table"` |
| `color` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `orientation` | `'vertical'` | ` "horizontal" \| "vertical"`  The orientation the radio buttons are laid out. |
| `indicator` | `'start'` | ` "start" \| "end" \| "hidden"`  Position of the indicator. |
| `disabled` |  | `boolean`  When `true`, prevents the user from interacting with radio items. |
| `loop` |  | `boolean` |
| `name` |  | ` string`  The name of the field. Submitted with its owning form as part of a name/value pair. |
| `required` |  | `boolean`  When `true`, indicates that the user must set the value before the owning form can be submitted. |
| `ui` |  | ` { root?: ClassNameValue; fieldset?: ClassNameValue; legend?: ClassNameValue; item?: ClassNameValue; container?: ClassNameValue; base?: ClassNameValue; indicator?: ClassNameValue; wrapper?: ClassNameValue; label?: ClassNameValue; description?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `legend` | `{}` |
| `label` | `{ item: Exclude<T[number] & { id: string; }, AcceptableValue>; modelValue?: AcceptableValue \| undefined; }` |
| `description` | `{ item: Exclude<T[number] & { id: string; }, AcceptableValue>; modelValue?: AcceptableValue \| undefined; }` |

### Emits

| Event | Type |
| --- | --- |
| `update:modelValue` | `[value: GetItemValue<T, VK, NestedItem<T>>]` |
| `change` | `[event: Event]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    radioGroup: {

      slots: {

        root: 'relative',

        fieldset: 'flex gap-x-2',

        legend: 'mb-1 block font-medium text-default',

        item: 'flex items-start',

        container: 'flex items-center',

        base: 'rounded-full ring ring-inset ring-accented overflow-hidden focus-visible:outline-2 focus-visible:outline-offset-2',

        indicator: 'flex items-center justify-center size-full after:bg-default after:rounded-full',

        wrapper: 'w-full',

        label: 'block font-medium text-default',

        description: 'text-muted'

      },

      variants: {

        color: {

          primary: {

            base: 'focus-visible:outline-primary',

            indicator: 'bg-primary'

          },

          secondary: {

            base: 'focus-visible:outline-secondary',

            indicator: 'bg-secondary'

          },

          success: {

            base: 'focus-visible:outline-success',

            indicator: 'bg-success'

          },

          info: {

            base: 'focus-visible:outline-info',

            indicator: 'bg-info'

          },

          warning: {

            base: 'focus-visible:outline-warning',

            indicator: 'bg-warning'

          },

          error: {

            base: 'focus-visible:outline-error',

            indicator: 'bg-error'

          },

          neutral: {

            base: 'focus-visible:outline-inverted',

            indicator: 'bg-inverted'

          }

        },

        variant: {

          list: {

            item: ''

          },

          card: {

            item: 'border border-muted rounded-lg'

          },

          table: {

            item: 'border border-muted'

          }

        },

        orientation: {

          horizontal: {

            fieldset: 'flex-row'

          },

          vertical: {

            fieldset: 'flex-col'

          }

        },

        indicator: {

          start: {

            item: 'flex-row',

            wrapper: 'ms-2'

          },

          end: {

            item: 'flex-row-reverse',

            wrapper: 'me-2'

          },

          hidden: {

            base: 'sr-only',

            wrapper: 'text-center'

          }

        },

        size: {

          xs: {

            fieldset: 'gap-y-0.5',

            legend: 'text-xs',

            base: 'size-3',

            item: 'text-xs',

            container: 'h-4',

            indicator: 'after:size-1'

          },

          sm: {

            fieldset: 'gap-y-0.5',

            legend: 'text-xs',

            base: 'size-3.5',

            item: 'text-xs',

            container: 'h-4',

            indicator: 'after:size-1'

          },

          md: {

            fieldset: 'gap-y-1',

            legend: 'text-sm',

            base: 'size-4',

            item: 'text-sm',

            container: 'h-5',

            indicator: 'after:size-1.5'

          },

          lg: {

            fieldset: 'gap-y-1',

            legend: 'text-sm',

            base: 'size-4.5',

            item: 'text-sm',

            container: 'h-5',

            indicator: 'after:size-1.5'

          },

          xl: {

            fieldset: 'gap-y-1.5',

            legend: 'text-base',

            base: 'size-5',

            item: 'text-base',

            container: 'h-6',

            indicator: 'after:size-2'

          }

        },

        disabled: {

          true: {

            item: 'opacity-75',

            base: 'cursor-not-allowed',

            label: 'cursor-not-allowed',

            description: 'cursor-not-allowed'

          }

        },

        required: {

          true: {

            legend: "after:content-['*'] after:ms-0.5 after:text-error"

          }

        }

      },

      compoundVariants: [

        {

          size: 'xs',

          variant: [

            'card',

            'table'

          ],

          class: {

            item: 'p-2.5'

          }

        },

        {

          size: 'sm',

          variant: [

            'card',

            'table'

          ],

          class: {

            item: 'p-3'

          }

        },

        {

          size: 'md',

          variant: [

            'card',

            'table'

          ],

          class: {

            item: 'p-3.5'

          }

        },

        {

          size: 'lg',

          variant: [

            'card',

            'table'

          ],

          class: {

            item: 'p-4'

          }

        },

        {

          size: 'xl',

          variant: [

            'card',

            'table'

          ],

          class: {

            item: 'p-4.5'

          }

        },

        {

          orientation: 'horizontal',

          variant: 'table',

          class: {

            item: 'first-of-type:rounded-s-lg last-of-type:rounded-e-lg',

            fieldset: 'gap-0 -space-x-px'

          }

        },

        {

          orientation: 'vertical',

          variant: 'table',

          class: {

            item: 'first-of-type:rounded-t-lg last-of-type:rounded-b-lg',

            fieldset: 'gap-0 -space-y-px'

          }

        },

        {

          color: 'primary',

          variant: 'card',

          class: {

            item: 'has-data-[state=checked]:border-primary'

          }

        },

        {

          color: 'neutral',

          variant: 'card',

          class: {

            item: 'has-data-[state=checked]:border-inverted'

          }

        },

        {

          color: 'primary',

          variant: 'table',

          class: {

            item: 'has-data-[state=checked]:bg-primary/10 has-data-[state=checked]:border-primary/50 has-data-[state=checked]:z-[1]'

          }

        },

        {

          color: 'neutral',

          variant: 'table',

          class: {

            item: 'has-data-[state=checked]:bg-elevated has-data-[state=checked]:border-inverted/50 has-data-[state=checked]:z-[1]'

          }

        },

        {

          variant: [

            'card',

            'table'

          ],

          disabled: true,

          class: {

            item: 'cursor-not-allowed'

          }

        }

      ],

      defaultVariants: {

        size: 'md',

        color: 'primary',

        variant: 'list',

        orientation: 'vertical',

        indicator: 'start'

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

        radioGroup: {

          slots: {

            root: 'relative',

            fieldset: 'flex gap-x-2',

            legend: 'mb-1 block font-medium text-default',

            item: 'flex items-start',

            container: 'flex items-center',

            base: 'rounded-full ring ring-inset ring-accented overflow-hidden focus-visible:outline-2 focus-visible:outline-offset-2',

            indicator: 'flex items-center justify-center size-full after:bg-default after:rounded-full',

            wrapper: 'w-full',

            label: 'block font-medium text-default',

            description: 'text-muted'

          },

          variants: {

            color: {

              primary: {

                base: 'focus-visible:outline-primary',

                indicator: 'bg-primary'

              },

              secondary: {

                base: 'focus-visible:outline-secondary',

                indicator: 'bg-secondary'

              },

              success: {

                base: 'focus-visible:outline-success',

                indicator: 'bg-success'

              },

              info: {

                base: 'focus-visible:outline-info',

                indicator: 'bg-info'

              },

              warning: {

                base: 'focus-visible:outline-warning',

                indicator: 'bg-warning'

              },

              error: {

                base: 'focus-visible:outline-error',

                indicator: 'bg-error'

              },

              neutral: {

                base: 'focus-visible:outline-inverted',

                indicator: 'bg-inverted'

              }

            },

            variant: {

              list: {

                item: ''

              },

              card: {

                item: 'border border-muted rounded-lg'

              },

              table: {

                item: 'border border-muted'

              }

            },

            orientation: {

              horizontal: {

                fieldset: 'flex-row'

              },

              vertical: {

                fieldset: 'flex-col'

              }

            },

            indicator: {

              start: {

                item: 'flex-row',

                wrapper: 'ms-2'

              },

              end: {

                item: 'flex-row-reverse',

                wrapper: 'me-2'

              },

              hidden: {

                base: 'sr-only',

                wrapper: 'text-center'

              }

            },

            size: {

              xs: {

                fieldset: 'gap-y-0.5',

                legend: 'text-xs',

                base: 'size-3',

                item: 'text-xs',

                container: 'h-4',

                indicator: 'after:size-1'

              },

              sm: {

                fieldset: 'gap-y-0.5',

                legend: 'text-xs',

                base: 'size-3.5',

                item: 'text-xs',

                container: 'h-4',

                indicator: 'after:size-1'

              },

              md: {

                fieldset: 'gap-y-1',

                legend: 'text-sm',

                base: 'size-4',

                item: 'text-sm',

                container: 'h-5',

                indicator: 'after:size-1.5'

              },

              lg: {

                fieldset: 'gap-y-1',

                legend: 'text-sm',

                base: 'size-4.5',

                item: 'text-sm',

                container: 'h-5',

                indicator: 'after:size-1.5'

              },

              xl: {

                fieldset: 'gap-y-1.5',

                legend: 'text-base',

                base: 'size-5',

                item: 'text-base',

                container: 'h-6',

                indicator: 'after:size-2'

              }

            },

            disabled: {

              true: {

                item: 'opacity-75',

                base: 'cursor-not-allowed',

                label: 'cursor-not-allowed',

                description: 'cursor-not-allowed'

              }

            },

            required: {

              true: {

                legend: "after:content-['*'] after:ms-0.5 after:text-error"

              }

            }

          },

          compoundVariants: [

            {

              size: 'xs',

              variant: [

                'card',

                'table'

              ],

              class: {

                item: 'p-2.5'

              }

            },

            {

              size: 'sm',

              variant: [

                'card',

                'table'

              ],

              class: {

                item: 'p-3'

              }

            },

            {

              size: 'md',

              variant: [

                'card',

                'table'

              ],

              class: {

                item: 'p-3.5'

              }

            },

            {

              size: 'lg',

              variant: [

                'card',

                'table'

              ],

              class: {

                item: 'p-4'

              }

            },

            {

              size: 'xl',

              variant: [

                'card',

                'table'

              ],

              class: {

                item: 'p-4.5'

              }

            },

            {

              orientation: 'horizontal',

              variant: 'table',

              class: {

                item: 'first-of-type:rounded-s-lg last-of-type:rounded-e-lg',

                fieldset: 'gap-0 -space-x-px'

              }

            },

            {

              orientation: 'vertical',

              variant: 'table',

              class: {

                item: 'first-of-type:rounded-t-lg last-of-type:rounded-b-lg',

                fieldset: 'gap-0 -space-y-px'

              }

            },

            {

              color: 'primary',

              variant: 'card',

              class: {

                item: 'has-data-[state=checked]:border-primary'

              }

            },

            {

              color: 'neutral',

              variant: 'card',

              class: {

                item: 'has-data-[state=checked]:border-inverted'

              }

            },

            {

              color: 'primary',

              variant: 'table',

              class: {

                item: 'has-data-[state=checked]:bg-primary/10 has-data-[state=checked]:border-primary/50 has-data-[state=checked]:z-[1]'

              }

            },

            {

              color: 'neutral',

              variant: 'table',

              class: {

                item: 'has-data-[state=checked]:bg-elevated has-data-[state=checked]:border-inverted/50 has-data-[state=checked]:z-[1]'

              }

            },

            {

              variant: [

                'card',

                'table'

              ],

              disabled: true,

              class: {

                item: 'cursor-not-allowed'

              }

            }

          ],

          defaultVariants: {

            size: 'md',

            color: 'primary',

            variant: 'list',

            orientation: 'vertical',

            indicator: 'start'

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

[`ddd8f`](https://github.com/nuxt/ui/commit/ddd8faf5ff3a8ba03f77ad377b67f649f8fcd077) — fix: consistent disabled styles

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`4cb06`](https://github.com/nuxt/ui/commit/4cb0638a0a321f2ea440711e931cf1336dc83e18) — fix: update `update:modelValue` emit type ([#5349](https://github.com/nuxt/ui/issues/5349))

[`788d2`](https://github.com/nuxt/ui/commit/788d2deb53b2a96c8d87828629b3d5d5ec5187d6) — fix: standardize naming for type interfaces ([#4990](https://github.com/nuxt/ui/issues/4990))

[`11a03`](https://github.com/nuxt/ui/commit/11a03201ed8454f37e911db4a14b00f74104932a) — fix: dot notation type support for `labelKey` and `valueKey` ([#4933](https://github.com/nuxt/ui/issues/4933))

[`7133f`](https://github.com/nuxt/ui/commit/7133f501e4346ba6990c437cfa16af05b886c884) — fix: broken types for `update:model-value` event ([#4853](https://github.com/nuxt/ui/issues/4853))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`bb993`](https://github.com/nuxt/ui/commit/bb99345f5b3074febe6d261dc29110bc00b29f01) — fix: improve type safety for normalizeItem function ([#4535](https://github.com/nuxt/ui/issues/4535))

[`43d28`](https://github.com/nuxt/ui/commit/43d281f6d1d8b0017ed61d929c5e311fb5b03447) — fix: variant `table` borders in RTL mode ([#4192](https://github.com/nuxt/ui/issues/4192))

[`f2fd7`](https://github.com/nuxt/ui/commit/f2fd778c0a604f2d65aec9f3fe2d54b6d4e8c3a2) — fix: render correct element without `variant`

[`b9adc`](https://github.com/nuxt/ui/commit/b9adc83e787db02507e6e7bb1aabc684eccc197b) — feat: add `ui` field in items ([#4060](https://github.com/nuxt/ui/issues/4060))

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`19577`](https://github.com/nuxt/ui/commit/195773ec7dac12ccc3a0a67867751e8ca634cc04) — fix: improve items `value` field type ([#3995](https://github.com/nuxt/ui/issues/3995))

[`9c3d5`](https://github.com/nuxt/ui/commit/9c3d53a02d6254f6b5c90e5fed826b8aefcdb042) — feat: new component ([#3862](https://github.com/nuxt/ui/issues/3862))

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`4d138`](https://github.com/nuxt/ui/commit/4d138ad6719a074f5f994006d12745ca05bec9c4) — feat: add `card` and `table` variants ([#3178](https://github.com/nuxt/ui/issues/3178))

[`b9983`](https://github.com/nuxt/ui/commit/b9983549a4b743724ea3ef99cc4a243f5ca41e53) — fix: improve generic types ([#3331](https://github.com/nuxt/ui/issues/3331))

[`fe0bd`](https://github.com/nuxt/ui/commit/fe0bd83d11b0dfa53b58d423bc917f8e21d73444) — fix: handle `disabled` on items[PinInput](https://ui.nuxt.com/docs/components/pin-input)

[

An input element to enter a pin.

](https://ui.nuxt.com/docs/components/pin-input)[

Select

A select element to choose from a list of options.

](https://ui.nuxt.com/docs/components/select)v