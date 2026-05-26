---
title: "Vue Textarea Component"
source: "https://ui.nuxt.com/docs/components/textarea"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A textarea element to input multi-line text."
tags:
---
## Textarea

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Textarea.vue)

A textarea element to input multi-line text.

## Usage

Use the `v-model` directive to control the value of the Textarea.

```
<script setup lang="ts">

const value = ref('')

</script>

<template>

  <UTextarea v-model="value" />

</template>
```

### Rows

Use the `rows` prop to set the number of rows. Defaults to `3`.

```
<template>

  <UTextarea :rows="12" />

</template>
```

### Placeholder

Use the `placeholder` prop to set a placeholder text.

```
<template>

  <UTextarea placeholder="Type something..." />

</template>
```

### Autoresize

Use the `autoresize` prop to enable autoresizing the height of the Textarea.

```
<script setup lang="ts">

const value = ref('This is a long text that will autoresize the height of the Textarea.')

</script>

<template>

  <UTextarea v-model="value" autoresize />

</template>
```

Use the `maxrows` prop to set the maximum number of rows when autoresizing. If set to `0`, the Textarea will grow indefinitely.

```
<script setup lang="ts">

const value = ref('This is a long text that will autoresize the height of the Textarea with a maximum of 4 rows.')

</script>

<template>

  <UTextarea v-model="value" :maxrows="4" autoresize />

</template>
```

### Color

Use the `color` prop to change the ring color when the Textarea is focused.

```
<template>

  <UTextarea color="neutral" highlight placeholder="Type something..." />

</template>
```

The `highlight` prop is used here to show the focus state. It's used internally when a validation error occurs.

### Variant

Use the `variant` prop to change the variant of the Textarea.

```
<template>

  <UTextarea color="neutral" variant="subtle" placeholder="Type something..." />

</template>
```

### Size

Use the `size` prop to change the size of the Textarea.

```
<template>

  <UTextarea size="xl" placeholder="Type something..." />

</template>
```

### Icon

Use the `icon` prop to show an [Icon](https://ui.nuxt.com/docs/components/icon) inside the Textarea.

```
<template>

  <UTextarea icon="i-lucide-search" size="md" variant="outline" placeholder="Search..." :rows="1" />

</template>
```

Use the `leading` and `trailing` props to set the icon position or the `leading-icon` and `trailing-icon` props to set a different icon for each position.

```
<template>

  <UTextarea trailing-icon="i-lucide-at-sign" placeholder="Enter your email" size="md" :rows="1" />

</template>
```

Use the `avatar` prop to show an [Avatar](https://ui.nuxt.com/docs/components/avatar) inside the Textarea.

```
<template>

  <UTextarea

    :avatar="{

      src: 'https://github.com/nuxt.png'

    }"

    size="md"

    variant="outline"

    placeholder="Search..."

    :rows="1"

  />

</template>
```

Use the `loading` prop to show a loading icon on the Textarea.

```
<template>

  <UTextarea loading placeholder="Search..." :rows="1" />

</template>
```

Use the `loading-icon` prop to customize the loading icon. Defaults to `i-lucide-loader-circle`.

```
<template>

  <UTextarea loading loading-icon="i-lucide-loader" placeholder="Search..." :rows="1" />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.loading` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.loading` key.

### Disabled

Use the `disabled` prop to disable the Textarea.

```
<template>

  <UTextarea disabled placeholder="Type something..." />

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `id` |  | ` string` |
| `name` |  | ` string` |
| `placeholder` |  | ` string`  The placeholder text when the textarea is empty. |
| `color` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `variant` | `'outline'` | ` "outline" \| "soft" \| "subtle" \| "ghost" \| "none"` |
| `size` | `'md'` | ` "xs" \| "sm" \| "md" \| "lg" \| "xl"` |
| `required` |  | `boolean` |
| `autofocus` |  | `boolean` |
| `autofocusDelay` | `0` | ` number` |
| `autoresize` |  | `boolean` |
| `autoresizeDelay` | `0` | ` number` |
| `disabled` |  | `boolean` |
| `rows` | `3` | ` number` |
| `maxrows` | `0` | ` number` |
| `highlight` |  | `boolean`  Highlight the ring color like a focus state. |
| `modelValue` |  | ` T` |
| `defaultValue` |  | ` T` |
| `modelModifiers` |  | ` ModelModifiers<T>` |
| `icon` |  | `any`  Display an icon based on the `leading` and `trailing` props. |
| `avatar` |  | ` AvatarProps`  Display an avatar on the left side. |
| `leading` |  | `boolean`  When `true`, the icon will be displayed on the left side. |
| `leadingIcon` |  | `any`  Display an icon on the left side. |
| `trailing` |  | `boolean`  When `true`, the icon will be displayed on the right side. |
| `trailingIcon` |  | `any`  Display an icon on the right side. |
| `loading` |  | `boolean`  When `true`, the loading icon will be displayed. |
| `loadingIcon` | `appConfig.ui.icons.loading` | `any`  The icon when the `loading` prop is `true`. |
| `autocomplete` |  | ` string` |
| `cols` |  | ` string \| number` |
| `dirname` |  | ` string` |
| `maxlength` |  | ` string \| number` |
| `minlength` |  | ` string \| number` |
| `readonly` |  | ` false \| true \| "true" \| "false"` |
| `wrap` |  | ` string` |
| `ui` |  | ` { root?: ClassNameValue; base?: ClassNameValue; leading?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; trailing?: ClassNameValue; trailingIcon?: ClassNameValue; }` |

This component also supports all native `<textarea>` HTML attributes.

### Slots

| Slot | Type |
| --- | --- |
| `leading` | `{ ui: object; }` |
| `default` | `{ ui: object; }` |
| `trailing` | `{ ui: object; }` |

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
| `textareaRef` | `Ref<HTMLTextAreaElement \| null>` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    textarea: {

      slots: {

        root: 'relative inline-flex items-center',

        base: [

          'w-full rounded-md border-0 appearance-none placeholder:text-dimmed focus:outline-none disabled:cursor-not-allowed disabled:opacity-75',

          'transition-colors'

        ],

        leading: 'absolute start-0 flex items-start',

        leadingIcon: 'shrink-0 text-dimmed',

        leadingAvatar: 'shrink-0',

        leadingAvatarSize: '',

        trailing: 'absolute end-0 flex items-start',

        trailingIcon: 'shrink-0 text-dimmed'

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

            leading: 'ps-2 inset-y-1',

            trailing: 'pe-2 inset-y-1',

            leadingIcon: 'size-4',

            leadingAvatarSize: '3xs',

            trailingIcon: 'size-4'

          },

          sm: {

            base: 'px-2.5 py-1.5 text-xs gap-1.5',

            leading: 'ps-2.5 inset-y-1.5',

            trailing: 'pe-2.5 inset-y-1.5',

            leadingIcon: 'size-4',

            leadingAvatarSize: '3xs',

            trailingIcon: 'size-4'

          },

          md: {

            base: 'px-2.5 py-1.5 text-sm gap-1.5',

            leading: 'ps-2.5 inset-y-1.5',

            trailing: 'pe-2.5 inset-y-1.5',

            leadingIcon: 'size-5',

            leadingAvatarSize: '2xs',

            trailingIcon: 'size-5'

          },

          lg: {

            base: 'px-3 py-2 text-sm gap-2',

            leading: 'ps-3 inset-y-2',

            trailing: 'pe-3 inset-y-2',

            leadingIcon: 'size-5',

            leadingAvatarSize: '2xs',

            trailingIcon: 'size-5'

          },

          xl: {

            base: 'px-3 py-2 text-base gap-2',

            leading: 'ps-3 inset-y-2',

            trailing: 'pe-3 inset-y-2',

            leadingIcon: 'size-6',

            leadingAvatarSize: 'xs',

            trailingIcon: 'size-6'

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

        },

        autoresize: {

          true: {

            base: 'resize-none'

          }

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

        textarea: {

          slots: {

            root: 'relative inline-flex items-center',

            base: [

              'w-full rounded-md border-0 appearance-none placeholder:text-dimmed focus:outline-none disabled:cursor-not-allowed disabled:opacity-75',

              'transition-colors'

            ],

            leading: 'absolute start-0 flex items-start',

            leadingIcon: 'shrink-0 text-dimmed',

            leadingAvatar: 'shrink-0',

            leadingAvatarSize: '',

            trailing: 'absolute end-0 flex items-start',

            trailingIcon: 'shrink-0 text-dimmed'

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

                leading: 'ps-2 inset-y-1',

                trailing: 'pe-2 inset-y-1',

                leadingIcon: 'size-4',

                leadingAvatarSize: '3xs',

                trailingIcon: 'size-4'

              },

              sm: {

                base: 'px-2.5 py-1.5 text-xs gap-1.5',

                leading: 'ps-2.5 inset-y-1.5',

                trailing: 'pe-2.5 inset-y-1.5',

                leadingIcon: 'size-4',

                leadingAvatarSize: '3xs',

                trailingIcon: 'size-4'

              },

              md: {

                base: 'px-2.5 py-1.5 text-sm gap-1.5',

                leading: 'ps-2.5 inset-y-1.5',

                trailing: 'pe-2.5 inset-y-1.5',

                leadingIcon: 'size-5',

                leadingAvatarSize: '2xs',

                trailingIcon: 'size-5'

              },

              lg: {

                base: 'px-3 py-2 text-sm gap-2',

                leading: 'ps-3 inset-y-2',

                trailing: 'pe-3 inset-y-2',

                leadingIcon: 'size-5',

                leadingAvatarSize: '2xs',

                trailingIcon: 'size-5'

              },

              xl: {

                base: 'px-3 py-2 text-base gap-2',

                leading: 'ps-3 inset-y-2',

                trailing: 'pe-3 inset-y-2',

                leadingIcon: 'size-6',

                leadingAvatarSize: 'xs',

                trailingIcon: 'size-6'

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

            },

            autoresize: {

              true: {

                base: 'resize-none'

              }

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

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`fce2d`](https://github.com/nuxt/ui/commit/fce2df4e0660d0bdb3cdd4fb3041416824cbe893) — fix!: consistent exposed refs ([#5385](https://github.com/nuxt/ui/issues/5385))

[`5c347`](https://github.com/nuxt/ui/commit/5c347af8a3fee7b079171f3e69b68d87adb9a83a) — fix: make `modelModifiers` generic ([#5361](https://github.com/nuxt/ui/issues/5361))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`83b03`](https://github.com/nuxt/ui/commit/83b0306a30835a385049200c5de804c51577c64c) — feat!: rename `nullify` modifier to `nullable` and add `optional` ([#4838](https://github.com/nuxt/ui/issues/4838))

[`7133f`](https://github.com/nuxt/ui/commit/7133f501e4346ba6990c437cfa16af05b886c884) — fix: broken types for `update:model-value` event ([#4853](https://github.com/nuxt/ui/issues/4853))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`6f2ce`](https://github.com/nuxt/ui/commit/6f2ce5c610e1247e70b6e2072059cf6ecbe82711) — refactor: unite syntax for emits declaration ([#4512](https://github.com/nuxt/ui/issues/4512))

[`fb9e7`](https://github.com/nuxt/ui/commit/fb9e7bb85602ecec1f83cd148dffbfb5e99d5714) — feat: add `default-value` prop ([#4404](https://github.com/nuxt/ui/issues/4404))

[`f7613`](https://github.com/nuxt/ui/commit/f761369888c49fd0ee0f028dcf3c55dd5fbd2cae) — chore: update dependency reka-ui to ^2.3.0 (v3) ([#4234](https://github.com/nuxt/ui/issues/4234))

[`6aab6`](https://github.com/nuxt/ui/commit/6aab62ec30e266c5f0da0cd24aefbb7c53f447ac) — fix: missing imports ([#4207](https://github.com/nuxt/ui/issues/4207))

[`3243f`](https://github.com/nuxt/ui/commit/3243fb88f71c5475824bfdc4d7c4f303b2d6790b) — fix: define model modifiers types ([#4195](https://github.com/nuxt/ui/issues/4195))

[`2e4c3`](https://github.com/nuxt/ui/commit/2e4c3082a1e66fa597086dc3431fec37fa29ef62) — fix: handle inside button group

[`3c8d6`](https://github.com/nuxt/ui/commit/3c8d6cd01dfafed5844c376f52adbdda0c814420) — fix: handle generic types

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`619b6`](https://github.com/nuxt/ui/commit/619b6f2a0e78f2d0f2bb4cc86422deb34462c2bd) — chore: put back styles

[`f6ff1`](https://github.com/nuxt/ui/commit/f6ff157bc4107ff8b512528ac56e83d4cfac7c59) — chore: apply same styles as Input

[`ffafd`](https://github.com/nuxt/ui/commit/ffafd81e1ed25074430668c792e5e1c6afc22bd0) — feat: add `resize-none` class with `autoresize` prop

[`cb193`](https://github.com/nuxt/ui/commit/cb193f1d25b5c73ca03dcf10864800350dd1c290) — feat: add `icon`, `loading`, etc. props to match Input

[`06414`](https://github.com/nuxt/ui/commit/06414d344b151ad6e1a3225a9f5f1f76d58d319c) — feat: add `autoresize-delay` prop

[`4d817`](https://github.com/nuxt/ui/commit/4d8179ba08bc69f28a541fa6d6cf3519db322662) — chore: clean functions order[Switch](https://ui.nuxt.com/docs/components/switch)

[

A control that toggles between two states.

](https://ui.nuxt.com/docs/components/switch)[

Accordion

A stacked set of collapsible panels.

](https://ui.nuxt.com/docs/components/accordion)