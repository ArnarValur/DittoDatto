---
title: "Vue Switch Component"
source: "https://ui.nuxt.com/docs/components/switch"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A control that toggles between two states."
tags:
---
## Switch

[Switch](https://reka-ui.com/docs/components/switch) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Switch.vue)

A control that toggles between two states.

## Usage

Use the `v-model` directive to control the checked state of the Switch.

```
<script setup lang="ts">

const value = ref(true)

</script>

<template>

  <USwitch v-model="value" />

</template>
```

Use the `default-value` prop to set the initial value when you do not need to control its state.

```
<template>

  <USwitch default-value />

</template>
```

### Label

Use the `label` prop to set the label of the Switch.

```
<template>

  <USwitch label="Check me" />

</template>
```

When using the `required` prop, an asterisk is added next to the label.

```
<template>

  <USwitch required label="Check me" />

</template>
```

### Description

Use the `description` prop to set the description of the Switch.

This is a checkbox.

```
<template>

  <USwitch label="Check me" description="This is a checkbox." />

</template>
```

### Icon

Use the `checked-icon` and `unchecked-icon` props to set the icons of the Switch when checked and unchecked.

```
<template>

  <USwitch

    unchecked-icon="i-lucide-x"

    checked-icon="i-lucide-check"

    default-value

    label="Check me"

  />

</template>
```

Use the `loading` prop to show a loading icon on the Switch.

```
<template>

  <USwitch loading default-value label="Check me" />

</template>
```

Use the `loading-icon` prop to customize the loading icon. Defaults to `i-lucide-loader-circle`.

```
<template>

  <USwitch loading loading-icon="i-lucide-loader" default-value label="Check me" />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.loading` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.loading` key.

### Color

Use the `color` prop to change the color of the Switch.

```
<template>

  <USwitch color="neutral" default-value label="Check me" />

</template>
```

### Size

Use the `size` prop to change the size of the Switch.

```
<template>

  <USwitch size="xl" default-value label="Check me" />

</template>
```

### Disabled

Use the `disabled` prop to disable the Switch.

```
<template>

  <USwitch disabled label="Check me" />

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `color` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `size` | `'md'` | ` "xs" \| "sm" \| "md" \| "lg" \| "xl"` |
| `loading` |  | `boolean`  When `true`, the loading icon will be displayed. |
| `loadingIcon` | `appConfig.ui.icons.loading` | `any`  The icon when the `loading` prop is `true`. |
| `checkedIcon` |  | `any`  Display an icon when the switch is checked. |
| `uncheckedIcon` |  | `any`  Display an icon when the switch is unchecked. |
| `label` |  | ` string` |
| `description` |  | ` string` |
| `defaultValue` |  | `boolean`  The state of the switch when it is initially rendered. Use when you do not need to control its state. |
| `disabled` |  | `boolean`  When `true`, prevents the user from interacting with the switch. |
| `value` |  | ` string`  The value given as data when submitted with a `name`. |
| `id` |  | ` string` |
| `name` |  | ` string`  The name of the field. Submitted with its owning form as part of a name/value pair. |
| `required` |  | `boolean `  When `true`, indicates that the user must set the value before the owning form can be submitted. |
| `autofocus` |  | ` false \| true \| "true" \| "false"` |
| `modelValue` | `undefined` | `boolean ` |
| `ui` |  | ` { root?: ClassNameValue; base?: ClassNameValue; container?: ClassNameValue; thumb?: ClassNameValue; icon?: ClassNameValue; wrapper?: ClassNameValue; label?: ClassNameValue; description?: ClassNameValue; }` |

This component also supports all native `<button>` HTML attributes.

### Slots

| Slot | Type |
| --- | --- |
| `label` | `{ label?: string \| undefined; }` |
| `description` | `{ description?: string \| undefined; }` |

### Emits

| Event | Type |
| --- | --- |
| `update:modelValue` | `[value: boolean]` |
| `change` | `[event: Event]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    switch: {

      slots: {

        root: 'relative flex items-start',

        base: [

          'inline-flex items-center shrink-0 rounded-full border-2 border-transparent focus-visible:outline-2 focus-visible:outline-offset-2 data-[state=unchecked]:bg-accented',

          'transition-[background] duration-200'

        ],

        container: 'flex items-center',

        thumb: 'group pointer-events-none rounded-full bg-default shadow-lg ring-0 transition-transform duration-200 data-[state=unchecked]:translate-x-0 data-[state=unchecked]:rtl:-translate-x-0 flex items-center justify-center',

        icon: [

          'absolute shrink-0 group-data-[state=unchecked]:text-dimmed opacity-0 size-10/12',

          'transition-[color,opacity] duration-200'

        ],

        wrapper: 'ms-2',

        label: 'block font-medium text-default',

        description: 'text-muted'

      },

      variants: {

        color: {

          primary: {

            base: 'data-[state=checked]:bg-primary focus-visible:outline-primary',

            icon: 'group-data-[state=checked]:text-primary'

          },

          secondary: {

            base: 'data-[state=checked]:bg-secondary focus-visible:outline-secondary',

            icon: 'group-data-[state=checked]:text-secondary'

          },

          success: {

            base: 'data-[state=checked]:bg-success focus-visible:outline-success',

            icon: 'group-data-[state=checked]:text-success'

          },

          info: {

            base: 'data-[state=checked]:bg-info focus-visible:outline-info',

            icon: 'group-data-[state=checked]:text-info'

          },

          warning: {

            base: 'data-[state=checked]:bg-warning focus-visible:outline-warning',

            icon: 'group-data-[state=checked]:text-warning'

          },

          error: {

            base: 'data-[state=checked]:bg-error focus-visible:outline-error',

            icon: 'group-data-[state=checked]:text-error'

          },

          neutral: {

            base: 'data-[state=checked]:bg-inverted focus-visible:outline-inverted',

            icon: 'group-data-[state=checked]:text-highlighted'

          }

        },

        size: {

          xs: {

            base: 'w-7',

            container: 'h-4',

            thumb: 'size-3 data-[state=checked]:translate-x-3 data-[state=checked]:rtl:-translate-x-3',

            wrapper: 'text-xs'

          },

          sm: {

            base: 'w-8',

            container: 'h-4',

            thumb: 'size-3.5 data-[state=checked]:translate-x-3.5 data-[state=checked]:rtl:-translate-x-3.5',

            wrapper: 'text-xs'

          },

          md: {

            base: 'w-9',

            container: 'h-5',

            thumb: 'size-4 data-[state=checked]:translate-x-4 data-[state=checked]:rtl:-translate-x-4',

            wrapper: 'text-sm'

          },

          lg: {

            base: 'w-10',

            container: 'h-5',

            thumb: 'size-4.5 data-[state=checked]:translate-x-4.5 data-[state=checked]:rtl:-translate-x-4.5',

            wrapper: 'text-sm'

          },

          xl: {

            base: 'w-11',

            container: 'h-6',

            thumb: 'size-5 data-[state=checked]:translate-x-5 data-[state=checked]:rtl:-translate-x-5',

            wrapper: 'text-base'

          }

        },

        checked: {

          true: {

            icon: 'group-data-[state=checked]:opacity-100'

          }

        },

        unchecked: {

          true: {

            icon: 'group-data-[state=unchecked]:opacity-100'

          }

        },

        loading: {

          true: {

            icon: 'animate-spin'

          }

        },

        required: {

          true: {

            label: "after:content-['*'] after:ms-0.5 after:text-error"

          }

        },

        disabled: {

          true: {

            root: 'opacity-75',

            base: 'cursor-not-allowed',

            label: 'cursor-not-allowed',

            description: 'cursor-not-allowed'

          }

        }

      },

      defaultVariants: {

        color: 'primary',

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

        switch: {

          slots: {

            root: 'relative flex items-start',

            base: [

              'inline-flex items-center shrink-0 rounded-full border-2 border-transparent focus-visible:outline-2 focus-visible:outline-offset-2 data-[state=unchecked]:bg-accented',

              'transition-[background] duration-200'

            ],

            container: 'flex items-center',

            thumb: 'group pointer-events-none rounded-full bg-default shadow-lg ring-0 transition-transform duration-200 data-[state=unchecked]:translate-x-0 data-[state=unchecked]:rtl:-translate-x-0 flex items-center justify-center',

            icon: [

              'absolute shrink-0 group-data-[state=unchecked]:text-dimmed opacity-0 size-10/12',

              'transition-[color,opacity] duration-200'

            ],

            wrapper: 'ms-2',

            label: 'block font-medium text-default',

            description: 'text-muted'

          },

          variants: {

            color: {

              primary: {

                base: 'data-[state=checked]:bg-primary focus-visible:outline-primary',

                icon: 'group-data-[state=checked]:text-primary'

              },

              secondary: {

                base: 'data-[state=checked]:bg-secondary focus-visible:outline-secondary',

                icon: 'group-data-[state=checked]:text-secondary'

              },

              success: {

                base: 'data-[state=checked]:bg-success focus-visible:outline-success',

                icon: 'group-data-[state=checked]:text-success'

              },

              info: {

                base: 'data-[state=checked]:bg-info focus-visible:outline-info',

                icon: 'group-data-[state=checked]:text-info'

              },

              warning: {

                base: 'data-[state=checked]:bg-warning focus-visible:outline-warning',

                icon: 'group-data-[state=checked]:text-warning'

              },

              error: {

                base: 'data-[state=checked]:bg-error focus-visible:outline-error',

                icon: 'group-data-[state=checked]:text-error'

              },

              neutral: {

                base: 'data-[state=checked]:bg-inverted focus-visible:outline-inverted',

                icon: 'group-data-[state=checked]:text-highlighted'

              }

            },

            size: {

              xs: {

                base: 'w-7',

                container: 'h-4',

                thumb: 'size-3 data-[state=checked]:translate-x-3 data-[state=checked]:rtl:-translate-x-3',

                wrapper: 'text-xs'

              },

              sm: {

                base: 'w-8',

                container: 'h-4',

                thumb: 'size-3.5 data-[state=checked]:translate-x-3.5 data-[state=checked]:rtl:-translate-x-3.5',

                wrapper: 'text-xs'

              },

              md: {

                base: 'w-9',

                container: 'h-5',

                thumb: 'size-4 data-[state=checked]:translate-x-4 data-[state=checked]:rtl:-translate-x-4',

                wrapper: 'text-sm'

              },

              lg: {

                base: 'w-10',

                container: 'h-5',

                thumb: 'size-4.5 data-[state=checked]:translate-x-4.5 data-[state=checked]:rtl:-translate-x-4.5',

                wrapper: 'text-sm'

              },

              xl: {

                base: 'w-11',

                container: 'h-6',

                thumb: 'size-5 data-[state=checked]:translate-x-5 data-[state=checked]:rtl:-translate-x-5',

                wrapper: 'text-base'

              }

            },

            checked: {

              true: {

                icon: 'group-data-[state=checked]:opacity-100'

              }

            },

            unchecked: {

              true: {

                icon: 'group-data-[state=unchecked]:opacity-100'

              }

            },

            loading: {

              true: {

                icon: 'animate-spin'

              }

            },

            required: {

              true: {

                label: "after:content-['*'] after:ms-0.5 after:text-error"

              }

            },

            disabled: {

              true: {

                root: 'opacity-75',

                base: 'cursor-not-allowed',

                label: 'cursor-not-allowed',

                description: 'cursor-not-allowed'

              }

            }

          },

          defaultVariants: {

            color: 'primary',

            size: 'md'

          }

        }

      }

    })

  ]

})
```

## Changelog

[`ddd8f`](https://github.com/nuxt/ui/commit/ddd8faf5ff3a8ba03f77ad377b67f649f8fcd077) — fix: consistent disabled styles

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`fda3c`](https://github.com/nuxt/ui/commit/fda3c98ab798f045e6e3d781ec482ebe5f360c4e) — fix: clean html attributes extend

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`7133f`](https://github.com/nuxt/ui/commit/7133f501e4346ba6990c437cfa16af05b886c884) — fix: broken types for `update:model-value` event ([#4853](https://github.com/nuxt/ui/issues/4853))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`68787`](https://github.com/nuxt/ui/commit/68787b26fdf2bd5f9d9e812e5bfddb19abe45d1d) — fix: prevent transition on focus outline[Slider](https://ui.nuxt.com/docs/components/slider)

[

An input to select a numeric value within a range.

](https://ui.nuxt.com/docs/components/slider)[

Textarea

A textarea element to input multi-line text.

](https://ui.nuxt.com/docs/components/textarea)