---
title: "Vue InputTime Component"
source: "https://ui.nuxt.com/docs/components/input-time"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "An input for selecting a time."
tags:
---
## InputTime

[TimeField](https://reka-ui.com/docs/components/time-field) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/InputTime.vue)

An input for selecting a time.

## Usage

Use the `v-model` directive to control the selected date.

```
<script setup lang="ts">

import { Time } from '@internationalized/date'

const value = shallowRef(new Time(12, 30, 0))

</script>

<template>

  <UInputTime v-model="value" />

</template>
```

Use the `default-value` prop to set the initial value when you do not need to control its state.

```
<script setup lang="ts">

import { Time } from '@internationalized/date'

const defaultValue = shallowRef(new Time(12, 30, 0))

</script>

<template>

  <UInputTime :default-value="defaultValue" />

</template>
```

This component uses the `@internationalized/date` package for locale-aware formatting. The time format is determined by the `locale` prop of the App component.

This component uses the `@internationalized/date` package for locale-aware formatting. The time format is determined by the `locale` prop of the App component.

### Hour Cycle

Use the `hour-cycle` prop to change the hour cycle of the InputTime. Defaults to `12`.

```
<script setup lang="ts">

import { Time } from '@internationalized/date'

const defaultValue = shallowRef(new Time(16, 30, 0))

</script>

<template>

  <UInputTime :hour-cycle="24" :default-value="defaultValue" />

</template>
```

### Color

Use the `color` prop to change the color of the InputTime.

```
<template>

  <UInputTime color="neutral" highlight />

</template>
```

The `highlight` prop is used here to show the focus state. It's used internally when a validation error occurs.

### Variant

Use the `variant` prop to change the variant of the InputTime.

```
<template>

  <UInputTime variant="subtle" />

</template>
```

### Size

Use the `size` prop to change the size of the InputTime.

```
<template>

  <UInputTime size="xl" />

</template>
```

### Icon

Use the `icon` prop to show an [Icon](https://ui.nuxt.com/docs/components/icon) inside the InputTime.

```
<template>

  <UInputTime icon="i-lucide-clock" />

</template>
```

Use the `leading` and `trailing` props to set the icon position or the `leading-icon` and `trailing-icon` props to set a different icon for each position.

Use the `avatar` prop to show an [Avatar](https://ui.nuxt.com/docs/components/avatar) inside the InputTime.

```
<template>

  <UInputTime

    :avatar="{

      src: 'https://github.com/vuejs.png'

    }"

    size="md"

    variant="outline"

  />

</template>
```

### Disabled

Use the `disabled` prop to disable the InputTime.

```
<template>

  <UInputTime disabled />

</template>
```

## Examples

### Within a FormField

You can use the InputTime within a [FormField](https://ui.nuxt.com/docs/components/form-field) component to display a label, help text, required indicator, etc.

Specify the time

```
<script setup lang="ts">

import { Time } from '@internationalized/date'

const time = shallowRef(new Time(12, 30, 0))

</script>

<template>

  <UFormField label="Time" help="Specify the time" required>

    <UInputTime v-model="time" />

  </UFormField>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `color` | `'primary'` | ` "error" \| "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "neutral"` |
| `variant` | `'outline'` | ` "outline" \| "soft" \| "subtle" \| "ghost" \| "none"` |
| `size` | `'md'` | ` "xs" \| "sm" \| "md" \| "lg" \| "xl"` |
| `highlight` |  | `boolean`  Highlight the ring color like a focus state. |
| `autofocus` |  | `boolean` |
| `autofocusDelay` | `0` | ` number` |
| `defaultValue` |  | `Time \| CalendarDateTime \| ZonedDateTime` |
| `defaultPlaceholder` |  | `Time \| CalendarDateTime \| ZonedDateTime` |
| `placeholder` |  | `Time \| CalendarDateTime \| ZonedDateTime` |
| `modelValue` |  | `null \| Time \| CalendarDateTime \| ZonedDateTime` |
| `hourCycle` |  | ` 12 \| 24`  The hour cycle used for formatting times. Defaults to the local preference |
| `step` |  | ` DateStep`  The stepping interval for the time fields. Defaults to `1`. |
| `granularity` |  | ` "hour" \| "minute" \| "second"`  The granularity to use for formatting times. Defaults to minute if a Time is provided, otherwise defaults to minute. The field will render segments for each part of the date up to and including the specified granularity |
| `hideTimeZone` |  | `boolean`  Whether or not to hide the time zone segment of the field |
| `maxValue` |  | `Time \| CalendarDateTime \| ZonedDateTime` |
| `minValue` |  | `Time \| CalendarDateTime \| ZonedDateTime` |
| `disabled` |  | `boolean`  Whether or not the time field is disabled |
| `readonly` |  | `boolean`  Whether or not the time field is readonly |
| `id` |  | ` string`  Id of the element |
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
| `ui` |  | ` { base?: ClassNameValue; leading?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; trailing?: ClassNameValue; trailingIcon?: ClassNameValue; segment?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `leading` | `{ ui: object; }` |
| `default` | `{ ui: object; }` |
| `trailing` | `{ ui: object; }` |

### Emits

| Event | Type |
| --- | --- |
| `blur` | `[event: FocusEvent]` |
| `change` | `[event: Event]` |
| `focus` | `[event: FocusEvent]` |
| `update:modelValue` | `[date: TimeValue \| undefined]` |
| `update:placeholder` | `[date: TimeValue]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    inputTime: {

      slots: {

        base: [

          'group relative inline-flex items-center rounded-md select-none',

          'transition-colors'

        ],

        leading: 'absolute inset-y-0 start-0 flex items-center',

        leadingIcon: 'shrink-0 text-dimmed',

        leadingAvatar: 'shrink-0',

        leadingAvatarSize: '',

        trailing: 'absolute inset-y-0 end-0 flex items-center',

        trailingIcon: 'shrink-0 text-dimmed',

        segment: [

          'rounded text-center outline-hidden data-placeholder:text-dimmed data-[segment=literal]:text-muted data-invalid:text-error data-disabled:cursor-not-allowed data-disabled:opacity-75',

          'transition-colors'

        ]

      },

      variants: {

        fieldGroup: {

          horizontal: 'not-only:first:rounded-e-none not-only:last:rounded-s-none not-last:not-first:rounded-none focus-visible:z-[1]',

          vertical: 'not-only:first:rounded-b-none not-only:last:rounded-t-none not-last:not-first:rounded-none focus-visible:z-[1]'

        },

        size: {

          xs: {

            base: [

              'px-2 py-1 text-xs gap-1',

              'gap-0.25'

            ],

            leading: 'ps-2',

            trailing: 'pe-2',

            leadingIcon: 'size-4',

            leadingAvatarSize: '3xs',

            trailingIcon: 'size-4',

            segment: 'not-data-[segment=literal]:w-6'

          },

          sm: {

            base: [

              'px-2.5 py-1.5 text-xs gap-1.5',

              'gap-0.5'

            ],

            leading: 'ps-2.5',

            trailing: 'pe-2.5',

            leadingIcon: 'size-4',

            leadingAvatarSize: '3xs',

            trailingIcon: 'size-4',

            segment: 'not-data-[segment=literal]:w-6'

          },

          md: {

            base: [

              'px-2.5 py-1.5 text-sm gap-1.5',

              'gap-0.5'

            ],

            leading: 'ps-2.5',

            trailing: 'pe-2.5',

            leadingIcon: 'size-5',

            leadingAvatarSize: '2xs',

            trailingIcon: 'size-5',

            segment: 'not-data-[segment=literal]:w-7'

          },

          lg: {

            base: [

              'px-3 py-2 text-sm gap-2',

              'gap-0.75'

            ],

            leading: 'ps-3',

            trailing: 'pe-3',

            leadingIcon: 'size-5',

            leadingAvatarSize: '2xs',

            trailingIcon: 'size-5',

            segment: 'not-data-[segment=literal]:w-7'

          },

          xl: {

            base: [

              'px-3 py-2 text-base gap-2',

              'gap-0.75'

            ],

            leading: 'ps-3',

            trailing: 'pe-3',

            leadingIcon: 'size-6',

            leadingAvatarSize: 'xs',

            trailingIcon: 'size-6',

            segment: 'not-data-[segment=literal]:w-8'

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

        }

      },

      compoundVariants: [

        {

          variant: 'outline',

          class: {

            segment: 'focus:bg-elevated'

          }

        },

        {

          variant: 'soft',

          class: {

            segment: 'focus:bg-accented/50 group-hover:focus:bg-accented'

          }

        },

        {

          variant: 'subtle',

          class: {

            segment: 'focus:bg-accented'

          }

        },

        {

          variant: 'ghost',

          class: {

            segment: 'focus:bg-elevated group-hover:focus:bg-accented'

          }

        },

        {

          variant: 'none',

          class: {

            segment: 'focus:bg-elevated'

          }

        },

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

        inputTime: {

          slots: {

            base: [

              'group relative inline-flex items-center rounded-md select-none',

              'transition-colors'

            ],

            leading: 'absolute inset-y-0 start-0 flex items-center',

            leadingIcon: 'shrink-0 text-dimmed',

            leadingAvatar: 'shrink-0',

            leadingAvatarSize: '',

            trailing: 'absolute inset-y-0 end-0 flex items-center',

            trailingIcon: 'shrink-0 text-dimmed',

            segment: [

              'rounded text-center outline-hidden data-placeholder:text-dimmed data-[segment=literal]:text-muted data-invalid:text-error data-disabled:cursor-not-allowed data-disabled:opacity-75',

              'transition-colors'

            ]

          },

          variants: {

            fieldGroup: {

              horizontal: 'not-only:first:rounded-e-none not-only:last:rounded-s-none not-last:not-first:rounded-none focus-visible:z-[1]',

              vertical: 'not-only:first:rounded-b-none not-only:last:rounded-t-none not-last:not-first:rounded-none focus-visible:z-[1]'

            },

            size: {

              xs: {

                base: [

                  'px-2 py-1 text-xs gap-1',

                  'gap-0.25'

                ],

                leading: 'ps-2',

                trailing: 'pe-2',

                leadingIcon: 'size-4',

                leadingAvatarSize: '3xs',

                trailingIcon: 'size-4',

                segment: 'not-data-[segment=literal]:w-6'

              },

              sm: {

                base: [

                  'px-2.5 py-1.5 text-xs gap-1.5',

                  'gap-0.5'

                ],

                leading: 'ps-2.5',

                trailing: 'pe-2.5',

                leadingIcon: 'size-4',

                leadingAvatarSize: '3xs',

                trailingIcon: 'size-4',

                segment: 'not-data-[segment=literal]:w-6'

              },

              md: {

                base: [

                  'px-2.5 py-1.5 text-sm gap-1.5',

                  'gap-0.5'

                ],

                leading: 'ps-2.5',

                trailing: 'pe-2.5',

                leadingIcon: 'size-5',

                leadingAvatarSize: '2xs',

                trailingIcon: 'size-5',

                segment: 'not-data-[segment=literal]:w-7'

              },

              lg: {

                base: [

                  'px-3 py-2 text-sm gap-2',

                  'gap-0.75'

                ],

                leading: 'ps-3',

                trailing: 'pe-3',

                leadingIcon: 'size-5',

                leadingAvatarSize: '2xs',

                trailingIcon: 'size-5',

                segment: 'not-data-[segment=literal]:w-7'

              },

              xl: {

                base: [

                  'px-3 py-2 text-base gap-2',

                  'gap-0.75'

                ],

                leading: 'ps-3',

                trailing: 'pe-3',

                leadingIcon: 'size-6',

                leadingAvatarSize: 'xs',

                trailingIcon: 'size-6',

                segment: 'not-data-[segment=literal]:w-8'

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

            }

          },

          compoundVariants: [

            {

              variant: 'outline',

              class: {

                segment: 'focus:bg-elevated'

              }

            },

            {

              variant: 'soft',

              class: {

                segment: 'focus:bg-accented/50 group-hover:focus:bg-accented'

              }

            },

            {

              variant: 'subtle',

              class: {

                segment: 'focus:bg-accented'

              }

            },

            {

              variant: 'ghost',

              class: {

                segment: 'focus:bg-elevated group-hover:focus:bg-accented'

              }

            },

            {

              variant: 'none',

              class: {

                segment: 'focus:bg-elevated'

              }

            },

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

[`cb3ce`](https://github.com/nuxt/ui/commit/cb3cec2a0bc7eb4e1d63f9b8d768276b03b898f9) — fix: add missing field group variant ([#5596](https://github.com/nuxt/ui/issues/5596))

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`a6efa`](https://github.com/nuxt/ui/commit/a6efa7a48cc33fa83efa96f7b41f6049e6816786) — fix: remove `locale` / `dir` props proxy ([#5432](https://github.com/nuxt/ui/issues/5432))

[`dabc4`](https://github.com/nuxt/ui/commit/dabc4f85ab83307fa9ccb0ae70eb30523837ea46) — feat: new component ([#5387](https://github.com/nuxt/ui/issues/5387))

[`93625`](https://github.com/nuxt/ui/commit/936253feae6b4b616465e655bb68992a73cf7217) — feat: new component ([#5302](https://github.com/nuxt/ui/issues/5302))[InputTags](https://ui.nuxt.com/docs/components/input-tags)

[

An input element that displays interactive tags.

](https://ui.nuxt.com/docs/components/input-tags)[

PinInput

An input element to enter a pin.

](https://ui.nuxt.com/docs/components/pin-input)