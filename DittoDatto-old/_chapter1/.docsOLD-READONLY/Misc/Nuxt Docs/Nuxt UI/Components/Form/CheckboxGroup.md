---
title: "Vue CheckboxGroup Component"
source: "https://ui.nuxt.com/docs/components/checkbox-group"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A set of checklist buttons to select multiple option from a list."
tags:
---
## CheckboxGroup

[CheckboxGroup](https://reka-ui.com/docs/components/checkbox#group-root) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/CheckboxGroup.vue)

A set of checklist buttons to select multiple option from a list.

## Usage

Use the `v-model` directive to control the value of the CheckboxGroup or the `default-value` prop to set the initial value when you do not need to control its state.

```
<script setup lang="ts">

const items = ref(['System', 'Light', 'Dark'])

const value = ref(['System'])

</script>

<template>

  <UCheckboxGroup v-model="value" :items="items" />

</template>
```

### Items

Use the `items` prop as an array of strings or numbers:

```
<script setup lang="ts">

const items = ref(['System', 'Light', 'Dark'])

const value = ref(['System'])

</script>

<template>

  <UCheckboxGroup v-model="value" :items="items" />

</template>
```

You can also pass an array of objects with the following properties:

- `label?: string`
- `description?: string`
- [`value?: string`](https://ui.nuxt.com/docs/components/#value-key)
- `disabled?: boolean`
- `class?: any`
- `ui?: { item?: ClassNameValue, container?: ClassNameValue, base?: ClassNameValue, 'indicator'?: ClassNameValue, icon?: ClassNameValue, wrapper?: ClassNameValue, label?: ClassNameValue, description?: ClassNameValue }`

```
<script setup lang="ts">

import type { CheckboxGroupItem } from '@nuxt/ui'

const items = ref<CheckboxGroupItem[]>([

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

const value = ref([

  'system'

])

</script>

<template>

  <UCheckboxGroup v-model="value" :items="items" />

</template>
```

### Value Key

You can change the property that is used to set the value by using the `value-key` prop. Defaults to `value`.

```
<script setup lang="ts">

import type { CheckboxGroupItem } from '@nuxt/ui'

const items = ref<CheckboxGroupItem[]>([

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

const value = ref([

  'light'

])

</script>

<template>

  <UCheckboxGroup v-model="value" value-key="id" :items="items" />

</template>
```

### Legend

Use the `legend` prop to set the legend of the CheckboxGroup.

```
<script setup lang="ts">

const items = ref(['System', 'Light', 'Dark'])

</script>

<template>

  <UCheckboxGroup legend="Theme" :default-value="['System']" :items="items" />

</template>
```

### Color

Use the `color` prop to change the color of the CheckboxGroup.

```
<script setup lang="ts">

const items = ref(['System', 'Light', 'Dark'])

</script>

<template>

  <UCheckboxGroup color="neutral" :default-value="['System']" :items="items" />

</template>
```

### Variant

Use the `variant` prop to change the variant of the CheckboxGroup.

```
<script setup lang="ts">

const items = ref(['System', 'Light', 'Dark'])

</script>

<template>

  <UCheckboxGroup color="primary" variant="card" :default-value="['System']" :items="items" />

</template>
```

### Size

Use the `size` prop to change the size of the CheckboxGroup.

```
<script setup lang="ts">

const items = ref(['System', 'Light', 'Dark'])

</script>

<template>

  <UCheckboxGroup size="xl" variant="list" :default-value="['System']" :items="items" />

</template>
```

### Orientation

Use the `orientation` prop to change the orientation of the CheckboxGroup. Defaults to `vertical`.

```
<script setup lang="ts">

const items = ref(['System', 'Light', 'Dark'])

</script>

<template>

  <UCheckboxGroup

    orientation="horizontal"

    variant="list"

    :default-value="['System']"

    :items="items"

  />

</template>
```

### Indicator

Use the `indicator` prop to change the position or hide the indicator. Defaults to `start`.

```
<script setup lang="ts">

const items = ref(['System', 'Light', 'Dark'])

</script>

<template>

  <UCheckboxGroup indicator="end" variant="card" :default-value="['System']" :items="items" />

</template>
```

### Disabled

Use the `disabled` prop to disable the CheckboxGroup.

```
<script setup lang="ts">

const items = ref(['System', 'Light', 'Dark'])

</script>

<template>

  <UCheckboxGroup disabled :default-value="['System']" :items="items" />

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
| `modelValue` |  | ` GetItemValue<T, VK, NestedItem<T>>[]`  The controlled value of the CheckboxGroup. Can be bind as `v-model`. |
| `defaultValue` |  | ` GetItemValue<T, VK, NestedItem<T>>[]`  The value of the CheckboxGroup when initially rendered. Use when you do not need to control the state of the CheckboxGroup. |
| `size` | `'md'` | ` "xs" \| "sm" \| "md" \| "lg" \| "xl"` |
| `variant` | `'list'` | ` "table" \| "list" \| "card"` |
| `orientation` | `'vertical'` | ` "horizontal" \| "vertical"`  The orientation the checkbox buttons are laid out. |
| `disabled` |  | `boolean`  When `true`, prevents the user from interacting with the checkboxes |
| `loop` | `false` | `boolean` |
| `name` |  | ` string`  The name of the field. Submitted with its owning form as part of a name/value pair. |
| `required` |  | `boolean`  When `true`, indicates that the user must set the value before the owning form can be submitted. |
| `color` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `indicator` | `'start'` | ` "start" \| "end" \| "hidden"`  Position of the indicator. |
| `icon` | `appConfig.ui.icons.check` | `any`  The icon displayed when checked. |
| `ui` |  | ` { root?: ClassNameValue; fieldset?: ClassNameValue; legend?: ClassNameValue; item?: ClassNameValue; } & { root?: ClassNameValue; container?: ClassNameValue; base?: ClassNameValue; indicator?: ClassNameValue; icon?: ClassNameValue; wrapper?: ClassNameValue; label?: ClassNameValue; description?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `legend` | `{}` |
| `label` | `{ item: T[number] & { id: string; }; }` |
| `description` | `{ item: T[number] & { id: string; }; }` |

### Emits

| Event | Type |
| --- | --- |
| `update:modelValue` | `[value: GetItemValue<T, VK, NestedItem<T>>[]]` |
| `change` | `[event: Event]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    checkboxGroup: {

      slots: {

        root: 'relative',

        fieldset: 'flex gap-x-2',

        legend: 'mb-1 block font-medium text-default',

        item: ''

      },

      variants: {

        orientation: {

          horizontal: {

            fieldset: 'flex-row'

          },

          vertical: {

            fieldset: 'flex-col'

          }

        },

        color: {

          primary: {},

          secondary: {},

          success: {},

          info: {},

          warning: {},

          error: {},

          neutral: {}

        },

        variant: {

          list: {},

          card: {},

          table: {

            item: 'border border-muted'

          }

        },

        size: {

          xs: {

            fieldset: 'gap-y-0.5',

            legend: 'text-xs'

          },

          sm: {

            fieldset: 'gap-y-0.5',

            legend: 'text-xs'

          },

          md: {

            fieldset: 'gap-y-1',

            legend: 'text-sm'

          },

          lg: {

            fieldset: 'gap-y-1',

            legend: 'text-sm'

          },

          xl: {

            fieldset: 'gap-y-1.5',

            legend: 'text-base'

          }

        },

        required: {

          true: {

            legend: "after:content-['*'] after:ms-0.5 after:text-error"

          }

        },

        disabled: {

          true: {}

        }

      },

      compoundVariants: [

        {

          size: 'xs',

          variant: 'table',

          class: {

            item: 'p-2.5'

          }

        },

        {

          size: 'sm',

          variant: 'table',

          class: {

            item: 'p-3'

          }

        },

        {

          size: 'md',

          variant: 'table',

          class: {

            item: 'p-3.5'

          }

        },

        {

          size: 'lg',

          variant: 'table',

          class: {

            item: 'p-4'

          }

        },

        {

          size: 'xl',

          variant: 'table',

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

          variant: 'table',

          disabled: true,

          class: {

            item: 'cursor-not-allowed'

          }

        }

      ],

      defaultVariants: {

        size: 'md',

        variant: 'list',

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

        checkboxGroup: {

          slots: {

            root: 'relative',

            fieldset: 'flex gap-x-2',

            legend: 'mb-1 block font-medium text-default',

            item: ''

          },

          variants: {

            orientation: {

              horizontal: {

                fieldset: 'flex-row'

              },

              vertical: {

                fieldset: 'flex-col'

              }

            },

            color: {

              primary: {},

              secondary: {},

              success: {},

              info: {},

              warning: {},

              error: {},

              neutral: {}

            },

            variant: {

              list: {},

              card: {},

              table: {

                item: 'border border-muted'

              }

            },

            size: {

              xs: {

                fieldset: 'gap-y-0.5',

                legend: 'text-xs'

              },

              sm: {

                fieldset: 'gap-y-0.5',

                legend: 'text-xs'

              },

              md: {

                fieldset: 'gap-y-1',

                legend: 'text-sm'

              },

              lg: {

                fieldset: 'gap-y-1',

                legend: 'text-sm'

              },

              xl: {

                fieldset: 'gap-y-1.5',

                legend: 'text-base'

              }

            },

            required: {

              true: {

                legend: "after:content-['*'] after:ms-0.5 after:text-error"

              }

            },

            disabled: {

              true: {}

            }

          },

          compoundVariants: [

            {

              size: 'xs',

              variant: 'table',

              class: {

                item: 'p-2.5'

              }

            },

            {

              size: 'sm',

              variant: 'table',

              class: {

                item: 'p-3'

              }

            },

            {

              size: 'md',

              variant: 'table',

              class: {

                item: 'p-3.5'

              }

            },

            {

              size: 'lg',

              variant: 'table',

              class: {

                item: 'p-4'

              }

            },

            {

              size: 'xl',

              variant: 'table',

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

              variant: 'table',

              disabled: true,

              class: {

                item: 'cursor-not-allowed'

              }

            }

          ],

          defaultVariants: {

            size: 'md',

            variant: 'list',

            color: 'primary'

          }

        }

      }

    })

  ]

})
```

Some colors in `compoundVariants` are omitted for readability. Check out the source code on GitHub.

## Changelog

[`64d2e`](https://github.com/nuxt/ui/commit/64d2e887f94f71b0d3db87c75dc04a082d551ff7) — fix: update `update:modelValue` emit type ([#5927](https://github.com/nuxt/ui/issues/5927))

[`55646`](https://github.com/nuxt/ui/commit/55646eaeab1598ad53b95baa2c8acb15f798482b) — feat: add `valueKey` prop ([#5905](https://github.com/nuxt/ui/issues/5905))

[`ddd8f`](https://github.com/nuxt/ui/commit/ddd8faf5ff3a8ba03f77ad377b67f649f8fcd077) — fix: consistent disabled styles

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`ffa5b`](https://github.com/nuxt/ui/commit/ffa5b23f80ac517b0556d7763bb364025282bacf) — fix: proxy generic to emits

[`788d2`](https://github.com/nuxt/ui/commit/788d2deb53b2a96c8d87828629b3d5d5ec5187d6) — fix: standardize naming for type interfaces ([#4990](https://github.com/nuxt/ui/issues/4990))

[`3173b`](https://github.com/nuxt/ui/commit/3173bee38ce9e518076848999f14374600069d35) — fix: proxySlots reactivity ([#4969](https://github.com/nuxt/ui/issues/4969))

[`11a03`](https://github.com/nuxt/ui/commit/11a03201ed8454f37e911db4a14b00f74104932a) — fix: dot notation type support for `labelKey` and `valueKey` ([#4933](https://github.com/nuxt/ui/issues/4933))

[`7133f`](https://github.com/nuxt/ui/commit/7133f501e4346ba6990c437cfa16af05b886c884) — fix: broken types for `update:model-value` event ([#4853](https://github.com/nuxt/ui/issues/4853))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`43d28`](https://github.com/nuxt/ui/commit/43d281f6d1d8b0017ed61d929c5e311fb5b03447) — fix: variant `table` borders in RTL mode ([#4192](https://github.com/nuxt/ui/issues/4192))

[`b9adc`](https://github.com/nuxt/ui/commit/b9adc83e787db02507e6e7bb1aabc684eccc197b) — feat: add `ui` field in items ([#4060](https://github.com/nuxt/ui/issues/4060))

[`1b6ab`](https://github.com/nuxt/ui/commit/1b6ab271ea3875a7c77ffe9367c7c341083dd53c) — feat: add `table` variant ([#3997](https://github.com/nuxt/ui/issues/3997))

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`7551a`](https://github.com/nuxt/ui/commit/7551a85ad2d92b59e2909396affb862403d5b27a) — fix: relative `UCheckbox` import

[`bc061`](https://github.com/nuxt/ui/commit/bc061852822edd2dfb832a46dd6388123ec5771e) — fix: proxy slots & `ui` prop

[`9c3d5`](https://github.com/nuxt/ui/commit/9c3d53a02d6254f6b5c90e5fed826b8aefcdb042) — feat: new component ([#3862](https://github.com/nuxt/ui/issues/3862))[Checkbox](https://ui.nuxt.com/docs/components/checkbox)

[

An input element to toggle between checked and unchecked states.

](https://ui.nuxt.com/docs/components/checkbox)[

ColorPicker

A component to select a color.

](https://ui.nuxt.com/docs/components/color-picker)