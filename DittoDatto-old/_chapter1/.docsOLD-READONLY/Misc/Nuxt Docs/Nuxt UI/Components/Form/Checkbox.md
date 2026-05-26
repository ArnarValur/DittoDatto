---
title: "Vue Checkbox Component"
source: "https://ui.nuxt.com/docs/components/checkbox"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "An input element to toggle between checked and unchecked states."
tags:
---
## Checkbox

[Checkbox](https://reka-ui.com/docs/components/checkbox) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Checkbox.vue)

An input element to toggle between checked and unchecked states.

## Usage

Use the `v-model` directive to control the checked state of the Checkbox.

```
<script setup lang="ts">

const value = ref(true)

</script>

<template>

  <UCheckbox v-model="value" />

</template>
```

Use the `default-value` prop to set the initial value when you do not need to control its state.

```
<template>

  <UCheckbox default-value />

</template>
```

### Indeterminate

Use the `indeterminate` value in the `v-model` directive or `default-value` prop to set the Checkbox to an [indeterminate state](https://developer.mozilla.org/en-US/docs/Web/HTML/Element/input/checkbox#indeterminate_state_checkboxes).

```
<template>

  <UCheckbox default-value="indeterminate" />

</template>
```

### Indeterminate Icon

Use the `indeterminate-icon` prop to customize the indeterminate icon. Defaults to `i-lucide-minus`.

```
<template>

  <UCheckbox default-value="indeterminate" indeterminate-icon="i-lucide-plus" />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.minus` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.minus` key.

### Label

Use the `label` prop to set the label of the Checkbox.

```
<template>

  <UCheckbox label="Check me" />

</template>
```

When using the `required` prop, an asterisk is added next to the label.

```
<template>

  <UCheckbox required label="Check me" />

</template>
```

### Description

Use the `description` prop to set the description of the Checkbox.

This is a checkbox.

```
<template>

  <UCheckbox label="Check me" description="This is a checkbox." />

</template>
```

### Icon

Use the `icon` prop to set the icon of the Checkbox when it is checked. Defaults to `i-lucide-check`.

```
<template>

  <UCheckbox icon="i-lucide-heart" default-value label="Check me" />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.check` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.check` key.

### Color

Use the `color` prop to change the color of the Checkbox.

```
<template>

  <UCheckbox color="neutral" default-value label="Check me" />

</template>
```

### Variant

Use the `variant` prop to change the variant of the Checkbox.

```
<template>

  <UCheckbox color="primary" variant="card" default-value label="Check me" />

</template>
```

### Size

Use the `size` prop to change the size of the Checkbox.

```
<template>

  <UCheckbox size="xl" variant="list" default-value label="Check me" />

</template>
```

### Indicator

Use the `indicator` prop to change the position or hide the indicator. Defaults to `start`.

```
<template>

  <UCheckbox indicator="end" variant="card" default-value label="Check me" />

</template>
```

### Disabled

Use the `disabled` prop to disable the Checkbox.

```
<template>

  <UCheckbox disabled label="Check me" />

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `label` |  | ` string` |
| `description` |  | ` string` |
| `color` | `'primary'` | ` "error" \| "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "neutral"` |
| `variant` | `'list'` | ` "card" \| "list"` |
| `size` | `'md'` | ` "md" \| "xs" \| "sm" \| "lg" \| "xl"` |
| `indicator` | `'start'` | ` "start" \| "end" \| "hidden"`  Position of the indicator. |
| `icon` | `appConfig.ui.icons.check` | `any`  The icon displayed when checked. |
| `indeterminateIcon` | `appConfig.ui.icons.minus` | `any`  The icon displayed when the checkbox is indeterminate. |
| `disabled` |  | `boolean`  When `true`, prevents the user from interacting with the checkbox |
| `name` |  | ` string`  The name of the field. Submitted with its owning form as part of a name/value pair. |
| `required` |  | `boolean`  When `true`, indicates that the user must set the value before the owning form can be submitted. |
| `id` |  | ` string`  Id of the element |
| `defaultValue` |  | `boolean \| "indeterminate"`  The value of the checkbox when it is initially rendered. Use when you do not need to control its value. |
| `value` | `"on"` | ` null \| string \| number \| bigint \| Record<string, any>`  The value given as data when submitted with a `name`. |
| `autofocus` |  | ` false \| true \| "true" \| "false"` |
| `modelValue` | `undefined` | `boolean \| "indeterminate"` |
| `ui` |  | ` { root?: ClassNameValue; container?: ClassNameValue; base?: ClassNameValue; indicator?: ClassNameValue; icon?: ClassNameValue; wrapper?: ClassNameValue; label?: ClassNameValue; description?: ClassNameValue; }` |

This component also supports all native `<button>` HTML attributes.

### Slots

| Slot | Type |
| --- | --- |
| `label` | `{ label?: string \| undefined; }` |
| `description` | `{ description?: string \| undefined; }` |

### Emits

| Event | Type |
| --- | --- |
| `change` | `[event: Event]` |
| `update:modelValue` | `[value: boolean \| "indeterminate"]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    checkbox: {

      slots: {

        root: 'relative flex items-start',

        container: 'flex items-center',

        base: 'rounded-sm ring ring-inset ring-accented overflow-hidden focus-visible:outline-2 focus-visible:outline-offset-2',

        indicator: 'flex items-center justify-center size-full text-inverted',

        icon: 'shrink-0 size-full',

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

            root: ''

          },

          card: {

            root: 'border border-muted rounded-lg'

          }

        },

        indicator: {

          start: {

            root: 'flex-row',

            wrapper: 'ms-2'

          },

          end: {

            root: 'flex-row-reverse',

            wrapper: 'me-2'

          },

          hidden: {

            base: 'sr-only',

            wrapper: 'text-center'

          }

        },

        size: {

          xs: {

            base: 'size-3',

            container: 'h-4',

            wrapper: 'text-xs'

          },

          sm: {

            base: 'size-3.5',

            container: 'h-4',

            wrapper: 'text-xs'

          },

          md: {

            base: 'size-4',

            container: 'h-5',

            wrapper: 'text-sm'

          },

          lg: {

            base: 'size-4.5',

            container: 'h-5',

            wrapper: 'text-sm'

          },

          xl: {

            base: 'size-5',

            container: 'h-6',

            wrapper: 'text-base'

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

        },

        checked: {

          true: ''

        }

      },

      compoundVariants: [

        {

          size: 'xs',

          variant: 'card',

          class: {

            root: 'p-2.5'

          }

        },

        {

          size: 'sm',

          variant: 'card',

          class: {

            root: 'p-3'

          }

        },

        {

          size: 'md',

          variant: 'card',

          class: {

            root: 'p-3.5'

          }

        },

        {

          size: 'lg',

          variant: 'card',

          class: {

            root: 'p-4'

          }

        },

        {

          size: 'xl',

          variant: 'card',

          class: {

            root: 'p-4.5'

          }

        },

        {

          color: 'primary',

          variant: 'card',

          class: {

            root: 'has-data-[state=checked]:border-primary'

          }

        },

        {

          color: 'neutral',

          variant: 'card',

          class: {

            root: 'has-data-[state=checked]:border-inverted'

          }

        },

        {

          variant: 'card',

          disabled: true,

          class: {

            root: 'cursor-not-allowed'

          }

        }

      ],

      defaultVariants: {

        size: 'md',

        color: 'primary',

        variant: 'list',

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

        checkbox: {

          slots: {

            root: 'relative flex items-start',

            container: 'flex items-center',

            base: 'rounded-sm ring ring-inset ring-accented overflow-hidden focus-visible:outline-2 focus-visible:outline-offset-2',

            indicator: 'flex items-center justify-center size-full text-inverted',

            icon: 'shrink-0 size-full',

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

                root: ''

              },

              card: {

                root: 'border border-muted rounded-lg'

              }

            },

            indicator: {

              start: {

                root: 'flex-row',

                wrapper: 'ms-2'

              },

              end: {

                root: 'flex-row-reverse',

                wrapper: 'me-2'

              },

              hidden: {

                base: 'sr-only',

                wrapper: 'text-center'

              }

            },

            size: {

              xs: {

                base: 'size-3',

                container: 'h-4',

                wrapper: 'text-xs'

              },

              sm: {

                base: 'size-3.5',

                container: 'h-4',

                wrapper: 'text-xs'

              },

              md: {

                base: 'size-4',

                container: 'h-5',

                wrapper: 'text-sm'

              },

              lg: {

                base: 'size-4.5',

                container: 'h-5',

                wrapper: 'text-sm'

              },

              xl: {

                base: 'size-5',

                container: 'h-6',

                wrapper: 'text-base'

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

            },

            checked: {

              true: ''

            }

          },

          compoundVariants: [

            {

              size: 'xs',

              variant: 'card',

              class: {

                root: 'p-2.5'

              }

            },

            {

              size: 'sm',

              variant: 'card',

              class: {

                root: 'p-3'

              }

            },

            {

              size: 'md',

              variant: 'card',

              class: {

                root: 'p-3.5'

              }

            },

            {

              size: 'lg',

              variant: 'card',

              class: {

                root: 'p-4'

              }

            },

            {

              size: 'xl',

              variant: 'card',

              class: {

                root: 'p-4.5'

              }

            },

            {

              color: 'primary',

              variant: 'card',

              class: {

                root: 'has-data-[state=checked]:border-primary'

              }

            },

            {

              color: 'neutral',

              variant: 'card',

              class: {

                root: 'has-data-[state=checked]:border-inverted'

              }

            },

            {

              variant: 'card',

              disabled: true,

              class: {

                root: 'cursor-not-allowed'

              }

            }

          ],

          defaultVariants: {

            size: 'md',

            color: 'primary',

            variant: 'list',

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

[`ddd8f`](https://github.com/nuxt/ui/commit/ddd8faf5ff3a8ba03f77ad377b67f649f8fcd077) — fix: consistent disabled styles

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`fda3c`](https://github.com/nuxt/ui/commit/fda3c98ab798f045e6e3d781ec482ebe5f360c4e) — fix: clean html attributes extend

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`7133f`](https://github.com/nuxt/ui/commit/7133f501e4346ba6990c437cfa16af05b886c884) — fix: broken types for `update:model-value` event ([#4853](https://github.com/nuxt/ui/issues/4853))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`f2fd7`](https://github.com/nuxt/ui/commit/f2fd778c0a604f2d65aec9f3fe2d54b6d4e8c3a2) — fix: render correct element without `variant`

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`9c3d5`](https://github.com/nuxt/ui/commit/9c3d53a02d6254f6b5c90e5fed826b8aefcdb042) — feat: new component ([#3862](https://github.com/nuxt/ui/issues/3862))

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))[Skeleton](https://ui.nuxt.com/docs/components/skeleton)

[

A placeholder to show while content is loading.

](https://ui.nuxt.com/docs/components/skeleton)[

CheckboxGroup

A set of checklist buttons to select multiple option from a list.

](https://ui.nuxt.com/docs/components/checkbox-group)