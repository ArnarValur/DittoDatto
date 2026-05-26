---
title: "Vue FormField Component"
source: "https://ui.nuxt.com/docs/components/form-field"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A wrapper for form elements that provides validation and error handling."
tags:
---
## FormField

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/FormField.vue)

A wrapper for form elements that provides validation and error handling.

## Usage

Wrap any form component with a FormField. Used in a [Form](https://ui.nuxt.com/docs/components/form), it provides validation and error handling.

### Label

Use the `label` prop to set the label for the form control.

```
<template>

  <UFormField label="Email">

    <UInput placeholder="Enter your email" />

  </UFormField>

</template>
```

The label `for` attribute and the form control are associated with a unique `id` if not provided.

When using the `required` prop, an asterisk is added next to the label.

```
<template>

  <UFormField label="Email" required>

    <UInput placeholder="Enter your email" />

  </UFormField>

</template>
```

### Description

Use the `description` prop to provide additional information below the label.

### Hint

Use the `hint` prop to display a hint message next to the label.

Optional

```
<template>

  <UFormField label="Email" hint="Optional">

    <UInput placeholder="Enter your email" />

  </UFormField>

</template>
```

### Help

Use the `help` prop to display a help message below the form control.

Please enter a valid email address.

```
<template>

  <UFormField label="Email" help="Please enter a valid email address.">

    <UInput placeholder="Enter your email" class="w-full" />

  </UFormField>

</template>
```

### Error

Use the `error` prop to display an error message below the form control. When used together with the `help` prop, the `error` prop takes precedence.

When used inside a [Form](https://ui.nuxt.com/docs/components/form), this is automatically set when a validation error occurs.

```
<template>

  <UFormField label="Email" error="Please enter a valid email address.">

    <UInput placeholder="Enter your email" class="w-full" />

  </UFormField>

</template>
```

This sets the `color` to `error` on the form control. You can change it globally in your `app.config.ts`.

### Size

Use the `size` prop to change the size of the FormField, the `size` is proxied to the form control.

### Orientation 4.3+

Use the `orientation` prop to change the layout of the FormField. Defaults to `vertical`.

Please enter a valid email address.

```
<template>

  <UFormField

    orientation="horizontal"

    label="Email"

    help="Please enter a valid email address."

    class="w-72"

  >

    <UInput placeholder="Enter your email" class="w-full" />

  </UFormField>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `name` |  | ` string`  The name of the FormField. Also used to match form errors. |
| `errorPattern` |  | ` RegExp`  A regular expression to match form error names. |
| `label` |  | ` string` |
| `description` |  | ` string` |
| `help` |  | ` string` |
| `error` | `undefined` | ` string \| false \| true` |
| `hint` |  | ` string` |
| `size` | `'md'` | ` "md" \| "xs" \| "sm" \| "lg" \| "xl"` |
| `required` |  | `boolean` |
| `eagerValidation` |  | `boolean`  If true, validation on input will be active immediately instead of waiting for a blur event. |
| `validateOnInputDelay` | `` `300` `` | ` number`  Delay in milliseconds before validating the form on input events. |
| `orientation` | `'vertical'` | ` "vertical" \| "horizontal"`  The orientation of the form field. |
| `ui` |  | ` { root?: ClassNameValue; wrapper?: ClassNameValue; labelWrapper?: ClassNameValue; label?: ClassNameValue; container?: ClassNameValue; description?: ClassNameValue; error?: ClassNameValue; hint?: ClassNameValue; help?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `label` | `{ label?: string \| undefined; }` |
| `hint` | `{ hint?: string \| undefined; }` |
| `description` | `{ description?: string \| undefined; }` |
| `help` | `{ help?: string \| undefined; }` |
| `error` | `{ error?: string \| boolean \| undefined; }` |
| `default` | `{ error?: string \| boolean \| undefined; }` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    formField: {

      slots: {

        root: '',

        wrapper: '',

        labelWrapper: 'flex content-center items-center justify-between gap-1',

        label: 'block font-medium text-default',

        container: 'relative',

        description: 'text-muted',

        error: 'mt-2 text-error',

        hint: 'text-muted',

        help: 'mt-2 text-muted'

      },

      variants: {

        size: {

          xs: {

            root: 'text-xs'

          },

          sm: {

            root: 'text-xs'

          },

          md: {

            root: 'text-sm'

          },

          lg: {

            root: 'text-sm'

          },

          xl: {

            root: 'text-base'

          }

        },

        required: {

          true: {

            label: "after:content-['*'] after:ms-0.5 after:text-error"

          }

        },

        orientation: {

          vertical: {

            container: 'mt-1'

          },

          horizontal: {

            root: 'flex justify-between place-items-baseline gap-2'

          }

        }

      },

      defaultVariants: {

        size: 'md',

        orientation: 'vertical'

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

        formField: {

          slots: {

            root: '',

            wrapper: '',

            labelWrapper: 'flex content-center items-center justify-between gap-1',

            label: 'block font-medium text-default',

            container: 'relative',

            description: 'text-muted',

            error: 'mt-2 text-error',

            hint: 'text-muted',

            help: 'mt-2 text-muted'

          },

          variants: {

            size: {

              xs: {

                root: 'text-xs'

              },

              sm: {

                root: 'text-xs'

              },

              md: {

                root: 'text-sm'

              },

              lg: {

                root: 'text-sm'

              },

              xl: {

                root: 'text-base'

              }

            },

            required: {

              true: {

                label: "after:content-['*'] after:ms-0.5 after:text-error"

              }

            },

            orientation: {

              vertical: {

                container: 'mt-1'

              },

              horizontal: {

                root: 'flex justify-between place-items-baseline gap-2'

              }

            }

          },

          defaultVariants: {

            size: 'md',

            orientation: 'vertical'

          }

        }

      }

    })

  ]

})
```

## Changelog

[`b74ec`](https://github.com/nuxt/ui/commit/b74ec6ef9f22709a487782a09f1cf686dc02b469) — feat: add `orientation` prop ([#5632](https://github.com/nuxt/ui/issues/5632))

[`6b7fe`](https://github.com/nuxt/ui/commit/6b7fe25935fb61d858a47df1228fb500247d1637) — fix: hide error if error prop is false ([#5599](https://github.com/nuxt/ui/issues/5599))

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`77a55`](https://github.com/nuxt/ui/commit/77a554eb422e243fd43a6105df22568ef333a0b4) — fix: improve nested form validation handling ([#5024](https://github.com/nuxt/ui/issues/5024))

[`ec2bc`](https://github.com/nuxt/ui/commit/ec2bc0a89d3b0854b6ccd6384d1a5fd78be8b726) — feat: export form errors injection key ([#4808](https://github.com/nuxt/ui/issues/4808))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`c64c4`](https://github.com/nuxt/ui/commit/c64c4cdea0bef3321b361455e43b7ff1422b0b2a) — fix: resolve minor accessibility and rendering issues ([#4515](https://github.com/nuxt/ui/issues/4515))

[`a4d0c`](https://github.com/nuxt/ui/commit/a4d0ca739675745229ae819ffd20baaa00aef447) — fix: improve `error` type with boolean

[`127e0`](https://github.com/nuxt/ui/commit/127e06ae83c1ec145dadffcab357907b7b06bc98) — chore: update all non-major dependencies (v3) ([#4443](https://github.com/nuxt/ui/issues/4443))

[`459a0`](https://github.com/nuxt/ui/commit/459a0410ab729fde60865e84632b36903465f57e) — fix: use `div` for `error` and `help` slots

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`20c33`](https://github.com/nuxt/ui/commit/20c33920d005332db3c83f33a8c54c7c227ce0a0) — fix: add `help` to `aria-describedby` attribute ([#3691](https://github.com/nuxt/ui/issues/3691))

[`02184`](https://github.com/nuxt/ui/commit/02184b016a8450c03ef916c0eaedd86996379518) — chore: improve TSDoc ([#3619](https://github.com/nuxt/ui/issues/3619))[Form](https://ui.nuxt.com/docs/components/form)

[

A form component with built-in validation and submission handling.

](https://ui.nuxt.com/docs/components/form)[

Input

An input element to enter text.

](https://ui.nuxt.com/docs/components/input)