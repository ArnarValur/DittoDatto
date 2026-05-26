---
title: "Vue InputTags Component"
source: "https://ui.nuxt.com/docs/components/input-tags"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "An input element that displays interactive tags."
tags:
---
## InputTags

[InputTags](https://reka-ui.com/docs/components/tags-input) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/InputTags.vue)

An input element that displays interactive tags.

## Usage

Use the `v-model` directive to control the value of the InputTags.

Vue

```
<script setup lang="ts">

const value = ref(['Vue'])

</script>

<template>

  <UInputTags v-model="value" />

</template>
```

Use the `default-value` prop to set the initial value when you do not need to control its state.

Vue

```
<template>

  <UInputTags :default-value="['Vue']" />

</template>
```

### Placeholder

Use the `placeholder` prop to set a placeholder text.

```
<template>

  <UInputTags placeholder="Enter tags..." />

</template>
```

### Max Length

Use the `max-length` prop to set the maximum number of characters allowed in a tag.

```
<template>

  <UInputTags :max-length="4" />

</template>
```

### Color

Use the `color` prop to change the ring color when the InputTags is focused.

Vue

```
<script setup lang="ts">

const value = ref(['Vue'])

</script>

<template>

  <UInputTags v-model="value" color="neutral" highlight />

</template>
```

The `highlight` prop is used here to show the focus state. It's used internally when a validation error occurs.

### Variants

Use the `variant` prop to change the appearance of the InputTags.

Vue

```
<script setup lang="ts">

const value = ref(['Vue'])

</script>

<template>

  <UInputTags v-model="value" variant="subtle" color="neutral" />

</template>
```

### Sizes

Use the `size` prop to adjust the size of the InputTags.

Vue

```
<script setup lang="ts">

const value = ref(['Vue'])

</script>

<template>

  <UInputTags v-model="value" size="xl" />

</template>
```

### Icon

Use the `icon` prop to show an [Icon](https://ui.nuxt.com/docs/components/icon) inside the InputTags.

Vue

```
<script setup lang="ts">

const value = ref(['Vue'])

</script>

<template>

  <UInputTags v-model="value" icon="i-lucide-search" size="md" variant="outline" />

</template>
```

Use the `leading` and `trailing` props to set the icon position or the `leading-icon` and `trailing-icon` props to set a different icon for each position.

Use the `avatar` prop to show an [Avatar](https://ui.nuxt.com/docs/components/avatar) inside the InputTags.

Vue

```
<script setup lang="ts">

const value = ref(['Vue'])

</script>

<template>

  <UInputTags

    v-model="value"

    :avatar="{

      src: 'https://github.com/vuejs.png'

    }"

    size="md"

    variant="outline"

  />

</template>
```

### Delete Icon

Use the `delete-icon` prop to customize the delete [Icon](https://ui.nuxt.com/docs/components/icon) in the tags. Defaults to `i-lucide-x`.

Vue

```
<script setup lang="ts">

const value = ref(['Vue'])

</script>

<template>

  <UInputTags v-model="value" delete-icon="i-lucide-trash" />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.close` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.close` key.

Use the `loading` prop to show a loading icon on the InputTags.

Vue

```
<script setup lang="ts">

const value = ref(['Vue'])

</script>

<template>

  <UInputTags v-model="value" loading />

</template>
```

Use the `loading-icon` prop to customize the loading icon. Defaults to `i-lucide-loader-circle`.

Vue

```
<script setup lang="ts">

const value = ref(['Vue'])

</script>

<template>

  <UInputTags v-model="value" loading loading-icon="i-lucide-loader" />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.loading` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.loading` key.

### Disabled

Use the `disabled` prop to disable the InputTags.

Vue

```
<script setup lang="ts">

const value = ref(['Vue'])

</script>

<template>

  <UInputTags v-model="value" disabled />

</template>
```

## Examples

### Within a FormField

You can use the InputTags within a [FormField](https://ui.nuxt.com/docs/components/form-field) component to display a label, help text, required indicator, etc.

Vue

```
<script setup lang="ts">

const tags = ref(['Vue'])

</script>

<template>

  <UFormField label="Tags" required>

    <UInputTags v-model="tags" placeholder="Enter tags..." />

  </UFormField>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `placeholder` |  | ` string`  The placeholder text when the input is empty. |
| `maxLength` |  | ` number`  The maximum number of character allowed. |
| `color` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `variant` | `'outline'` | ` "outline" \| "soft" \| "subtle" \| "ghost" \| "none"` |
| `size` | `'md'` | ` "xs" \| "sm" \| "md" \| "lg" \| "xl"` |
| `autofocus` |  | `boolean` |
| `autofocusDelay` | `0` | ` number` |
| `deleteIcon` | `appConfig.ui.icons.close` | `any`  The icon displayed to delete a tag. |
| `highlight` |  | `boolean`  Highlight the ring color like a focus state. |
| `modelValue` |  | ` null \| T[]`  The controlled value of the tags input. Can be bind as `v-model`. |
| `defaultValue` |  | ` T[]`  The value of the tags that should be added. Use when you do not need to control the state of the tags input |
| `addOnPaste` |  | `boolean`  When `true`, allow adding tags on paste. Work in conjunction with delimiter prop. |
| `addOnTab` |  | `boolean`  When `true` allow adding tags on tab keydown |
| `addOnBlur` |  | `boolean`  When `true` allow adding tags blur input |
| `duplicate` |  | `boolean`  When `true`, allow duplicated tags. |
| `disabled` |  | `boolean`  When `true`, prevents the user from interacting with the tags input. |
| `delimiter` |  | ` string \| RegExp`  The character or regular expression to trigger the addition of a new tag. Also used to split tags for `@paste` event |
| `max` |  | ` number`  Maximum number of tags. |
| `id` |  | ` string` |
| `convertValue` |  | ` (value: string): T`  Convert the input value to the desired type. Mandatory when using objects as values and using `TagsInputInput` |
| `displayValue` |  | ` (value: T): string`  Display the value of the tag. Useful when you want to apply modifications to the value like adding a suffix or when using object as values |
| `name` |  | ` string`  The name of the field. Submitted with its owning form as part of a name/value pair. |
| `required` |  | `boolean`  When `true`, indicates that the user must set the value before the owning form can be submitted. |
| `icon` |  | `any`  Display an icon based on the `leading` and `trailing` props. |
| `avatar` |  | ` AvatarProps`  Display an avatar on the left side. |
| `leading` |  | `boolean`  When `true`, the icon will be displayed on the left side. |
| `leadingIcon` |  | `any`  Display an icon on the left side. |
| `trailing` |  | `boolean`  When `true`, the icon will be displayed on the right side. |
| `trailingIcon` |  | `any`  Display an icon on the right side. |
| `loading` |  | `boolean`  When `true`, the loading icon will be displayed. |
| `loadingIcon` | `appConfig.ui.icons.loading` | `any`  The icon when the `loading` prop is `true`. |
| `list` |  | ` string` |
| `readonly` |  | ` false \| true \| "true" \| "false"` |
| `autocomplete` |  | ` "on" \| "off" \| string & {}` |
| `ui` |  | ` { root?: ClassNameValue; base?: ClassNameValue; leading?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; trailing?: ClassNameValue; trailingIcon?: ClassNameValue; item?: ClassNameValue; itemText?: ClassNameValue; itemDelete?: ClassNameValue; itemDeleteIcon?: ClassNameValue; input?: ClassNameValue; }` |

This component also supports all native `<input>` HTML attributes.

### Slots

| Slot | Type |
| --- | --- |
| `leading` | `{ ui: object; }` |
| `default` | `{ ui: object; }` |
| `trailing` | `{ ui: object; }` |
| `item-text` | `{ item: T; index: number; ui: object; }` |
| `item-delete` | `{ item: T; index: number; ui: object; }` |

### Emits

| Event | Type |
| --- | --- |
| `change` | `[event: Event]` |
| `blur` | `[event: FocusEvent]` |
| `focus` | `[event: FocusEvent]` |
| `update:modelValue` | `[payload: T[]]` |
| `invalid` | `[payload: T]` |
| `addTag` | `[payload: T]` |
| `removeTag` | `[payload: T]` |

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

    inputTags: {

      slots: {

        root: [

          'relative inline-flex items-center',

          'flex-wrap'

        ],

        base: [

          'rounded-md',

          'transition-colors'

        ],

        leading: 'absolute inset-y-0 start-0 flex items-center',

        leadingIcon: 'shrink-0 text-dimmed',

        leadingAvatar: 'shrink-0',

        leadingAvatarSize: '',

        trailing: 'absolute inset-y-0 end-0 flex items-center',

        trailingIcon: 'shrink-0 text-dimmed',

        item: 'px-1.5 py-0.5 rounded-sm font-medium inline-flex items-center gap-0.5 ring ring-inset ring-accented bg-elevated text-default data-disabled:cursor-not-allowed data-disabled:opacity-75 wrap-anywhere data-[state="active"]:bg-accented',

        itemText: '',

        itemDelete: [

          'inline-flex items-center rounded-xs text-dimmed hover:text-default hover:bg-accented/75 disabled:pointer-events-none',

          'transition-colors'

        ],

        itemDeleteIcon: 'shrink-0',

        input: 'flex-1 border-0 bg-transparent placeholder:text-dimmed focus:outline-none disabled:cursor-not-allowed disabled:opacity-75'

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

        size: {

          xs: {

            base: 'px-2 py-1 text-xs gap-1',

            leading: 'ps-2',

            trailing: 'pe-2',

            leadingIcon: 'size-4',

            leadingAvatarSize: '3xs',

            trailingIcon: 'size-4',

            item: 'text-[10px]/3',

            itemDeleteIcon: 'size-3'

          },

          sm: {

            base: 'px-2.5 py-1.5 text-xs gap-1.5',

            leading: 'ps-2.5',

            trailing: 'pe-2.5',

            leadingIcon: 'size-4',

            leadingAvatarSize: '3xs',

            trailingIcon: 'size-4',

            item: 'text-[10px]/3',

            itemDeleteIcon: 'size-3'

          },

          md: {

            base: 'px-2.5 py-1.5 text-sm gap-1.5',

            leading: 'ps-2.5',

            trailing: 'pe-2.5',

            leadingIcon: 'size-5',

            leadingAvatarSize: '2xs',

            trailingIcon: 'size-5',

            item: 'text-xs',

            itemDeleteIcon: 'size-3.5'

          },

          lg: {

            base: 'px-3 py-2 text-sm gap-2',

            leading: 'ps-3',

            trailing: 'pe-3',

            leadingIcon: 'size-5',

            leadingAvatarSize: '2xs',

            trailingIcon: 'size-5',

            item: 'text-xs',

            itemDeleteIcon: 'size-3.5'

          },

          xl: {

            base: 'px-3 py-2 text-base gap-2',

            leading: 'ps-3',

            trailing: 'pe-3',

            leadingIcon: 'size-6',

            leadingAvatarSize: 'xs',

            trailingIcon: 'size-6',

            item: 'text-sm',

            itemDeleteIcon: 'size-4'

          }

        },

        variant: {

          outline: 'text-highlighted bg-default ring ring-inset ring-accented',

          soft: 'text-highlighted bg-elevated/50 hover:bg-elevated has-focus:bg-elevated disabled:bg-elevated/50',

          subtle: 'text-highlighted bg-elevated ring ring-inset ring-accented',

          ghost: 'text-highlighted bg-transparent hover:bg-elevated has-focus:bg-elevated disabled:bg-transparent dark:disabled:bg-transparent',

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

        leading: {

          true: ''

        },

        trailing: {

          true: ''

        },

        loading: {

          true: ''

        },

        highlight: {

          true: ''

        },

        type: {

          file: 'file:me-1.5 file:font-medium file:text-muted file:outline-none'

        }

      },

      compoundVariants: [

        {

          color: 'primary',

          variant: [

            'outline',

            'subtle'

          ],

          class: 'has-focus-visible:ring-2 has-focus-visible:ring-inset has-focus-visible:ring-primary'

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

          class: 'has-focus-visible:ring-2 has-focus-visible:ring-inset has-focus-visible:ring-inverted'

        },

        {

          color: 'neutral',

          highlight: true,

          class: 'ring ring-inset ring-inverted'

        },

        {

          leading: true,

          size: 'xs',

          class: 'ps-7'

        },

        {

          leading: true,

          size: 'sm',

          class: 'ps-8'

        },

        {

          leading: true,

          size: 'md',

          class: 'ps-9'

        },

        {

          leading: true,

          size: 'lg',

          class: 'ps-10'

        },

        {

          leading: true,

          size: 'xl',

          class: 'ps-11'

        },

        {

          trailing: true,

          size: 'xs',

          class: 'pe-7'

        },

        {

          trailing: true,

          size: 'sm',

          class: 'pe-8'

        },

        {

          trailing: true,

          size: 'md',

          class: 'pe-9'

        },

        {

          trailing: true,

          size: 'lg',

          class: 'pe-10'

        },

        {

          trailing: true,

          size: 'xl',

          class: 'pe-11'

        },

        {

          loading: true,

          leading: true,

          class: {

            leadingIcon: 'animate-spin'

          }

        },

        {

          loading: true,

          leading: false,

          trailing: true,

          class: {

            trailingIcon: 'animate-spin'

          }

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

        inputTags: {

          slots: {

            root: [

              'relative inline-flex items-center',

              'flex-wrap'

            ],

            base: [

              'rounded-md',

              'transition-colors'

            ],

            leading: 'absolute inset-y-0 start-0 flex items-center',

            leadingIcon: 'shrink-0 text-dimmed',

            leadingAvatar: 'shrink-0',

            leadingAvatarSize: '',

            trailing: 'absolute inset-y-0 end-0 flex items-center',

            trailingIcon: 'shrink-0 text-dimmed',

            item: 'px-1.5 py-0.5 rounded-sm font-medium inline-flex items-center gap-0.5 ring ring-inset ring-accented bg-elevated text-default data-disabled:cursor-not-allowed data-disabled:opacity-75 wrap-anywhere data-[state="active"]:bg-accented',

            itemText: '',

            itemDelete: [

              'inline-flex items-center rounded-xs text-dimmed hover:text-default hover:bg-accented/75 disabled:pointer-events-none',

              'transition-colors'

            ],

            itemDeleteIcon: 'shrink-0',

            input: 'flex-1 border-0 bg-transparent placeholder:text-dimmed focus:outline-none disabled:cursor-not-allowed disabled:opacity-75'

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

            size: {

              xs: {

                base: 'px-2 py-1 text-xs gap-1',

                leading: 'ps-2',

                trailing: 'pe-2',

                leadingIcon: 'size-4',

                leadingAvatarSize: '3xs',

                trailingIcon: 'size-4',

                item: 'text-[10px]/3',

                itemDeleteIcon: 'size-3'

              },

              sm: {

                base: 'px-2.5 py-1.5 text-xs gap-1.5',

                leading: 'ps-2.5',

                trailing: 'pe-2.5',

                leadingIcon: 'size-4',

                leadingAvatarSize: '3xs',

                trailingIcon: 'size-4',

                item: 'text-[10px]/3',

                itemDeleteIcon: 'size-3'

              },

              md: {

                base: 'px-2.5 py-1.5 text-sm gap-1.5',

                leading: 'ps-2.5',

                trailing: 'pe-2.5',

                leadingIcon: 'size-5',

                leadingAvatarSize: '2xs',

                trailingIcon: 'size-5',

                item: 'text-xs',

                itemDeleteIcon: 'size-3.5'

              },

              lg: {

                base: 'px-3 py-2 text-sm gap-2',

                leading: 'ps-3',

                trailing: 'pe-3',

                leadingIcon: 'size-5',

                leadingAvatarSize: '2xs',

                trailingIcon: 'size-5',

                item: 'text-xs',

                itemDeleteIcon: 'size-3.5'

              },

              xl: {

                base: 'px-3 py-2 text-base gap-2',

                leading: 'ps-3',

                trailing: 'pe-3',

                leadingIcon: 'size-6',

                leadingAvatarSize: 'xs',

                trailingIcon: 'size-6',

                item: 'text-sm',

                itemDeleteIcon: 'size-4'

              }

            },

            variant: {

              outline: 'text-highlighted bg-default ring ring-inset ring-accented',

              soft: 'text-highlighted bg-elevated/50 hover:bg-elevated has-focus:bg-elevated disabled:bg-elevated/50',

              subtle: 'text-highlighted bg-elevated ring ring-inset ring-accented',

              ghost: 'text-highlighted bg-transparent hover:bg-elevated has-focus:bg-elevated disabled:bg-transparent dark:disabled:bg-transparent',

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

            leading: {

              true: ''

            },

            trailing: {

              true: ''

            },

            loading: {

              true: ''

            },

            highlight: {

              true: ''

            },

            type: {

              file: 'file:me-1.5 file:font-medium file:text-muted file:outline-none'

            }

          },

          compoundVariants: [

            {

              color: 'primary',

              variant: [

                'outline',

                'subtle'

              ],

              class: 'has-focus-visible:ring-2 has-focus-visible:ring-inset has-focus-visible:ring-primary'

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

              class: 'has-focus-visible:ring-2 has-focus-visible:ring-inset has-focus-visible:ring-inverted'

            },

            {

              color: 'neutral',

              highlight: true,

              class: 'ring ring-inset ring-inverted'

            },

            {

              leading: true,

              size: 'xs',

              class: 'ps-7'

            },

            {

              leading: true,

              size: 'sm',

              class: 'ps-8'

            },

            {

              leading: true,

              size: 'md',

              class: 'ps-9'

            },

            {

              leading: true,

              size: 'lg',

              class: 'ps-10'

            },

            {

              leading: true,

              size: 'xl',

              class: 'ps-11'

            },

            {

              trailing: true,

              size: 'xs',

              class: 'pe-7'

            },

            {

              trailing: true,

              size: 'sm',

              class: 'pe-8'

            },

            {

              trailing: true,

              size: 'md',

              class: 'pe-9'

            },

            {

              trailing: true,

              size: 'lg',

              class: 'pe-10'

            },

            {

              trailing: true,

              size: 'xl',

              class: 'pe-11'

            },

            {

              loading: true,

              leading: true,

              class: {

                leadingIcon: 'animate-spin'

              }

            },

            {

              loading: true,

              leading: false,

              trailing: true,

              class: {

                trailingIcon: 'animate-spin'

              }

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

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`fda3c`](https://github.com/nuxt/ui/commit/fda3c98ab798f045e6e3d781ec482ebe5f360c4e) — fix: clean html attributes extend

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`fce2d`](https://github.com/nuxt/ui/commit/fce2df4e0660d0bdb3cdd4fb3041416824cbe893) — fix!: consistent exposed refs ([#5385](https://github.com/nuxt/ui/issues/5385))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`3fd26`](https://github.com/nuxt/ui/commit/3fd261410aa4f775008eb5e8132352bb378faae5) — fix: add blur and focus event handlers on input ([#5007](https://github.com/nuxt/ui/issues/5007))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`a0963`](https://github.com/nuxt/ui/commit/a0963eba8254d2ecf02cd1ee87cee7f73c4b2bc4) — feat!: rename from `ButtonGroup` ([#4596](https://github.com/nuxt/ui/issues/4596))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`b96a1`](https://github.com/nuxt/ui/commit/b96a1ccbabd07d5f7dfc85bd03714629bb2ce2e7) — feat: add `max-length` prop

[`8781a`](https://github.com/nuxt/ui/commit/8781a079096def0d3bae5b8d896db0df6ce37e23) — fix: extend emits interface

[`54bb2`](https://github.com/nuxt/ui/commit/54bb2282c58d3bf5a7dde4cdee687c68efd934a0) — feat: new component ([#4261](https://github.com/nuxt/ui/issues/4261))[InputNumber](https://ui.nuxt.com/docs/components/input-number)

[

An input for numerical values with a customizable range.

](https://ui.nuxt.com/docs/components/input-number)[

InputTime

An input for selecting a time.

](https://ui.nuxt.com/docs/components/input-time)