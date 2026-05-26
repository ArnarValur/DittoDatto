---
title: "Vue InputDate Component"
source: "https://ui.nuxt.com/docs/components/input-date"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "An input component for date selection."
tags:
---
## InputDate

[DateField](https://reka-ui.com/docs/components/date-field) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/InputDate.vue)

An input component for date selection.

## Usage

Use the `v-model` directive to control the selected date.

```
<script setup lang="ts">

import { CalendarDate } from '@internationalized/date'

const value = shallowRef(new CalendarDate(2022, 2, 3))

</script>

<template>

  <UInputDate v-model="value" />

</template>
```

Use the `default-value` prop to set the initial value when you do not need to control its state.

```
<script setup lang="ts">

import { CalendarDate } from '@internationalized/date'

const defaultValue = shallowRef(new CalendarDate(2022, 2, 6))

</script>

<template>

  <UInputDate :default-value="defaultValue" />

</template>
```

This component uses the `@internationalized/date` package for locale-aware formatting. The date format is determined by the `locale` prop of the App component.

This component uses the `@internationalized/date` package for locale-aware formatting. The date format is determined by the `locale` prop of the App component.

### Range

Use the `range` prop to select a range of dates.

```
<script setup lang="ts">

import { CalendarDate } from '@internationalized/date'

const value = shallowRef({

  start: new CalendarDate(2022, 2, 3),

  end: new CalendarDate(2022, 2, 20)

})

</script>

<template>

  <UInputDate range v-model="value" />

</template>
```

### Color

Use the `color` prop to change the color of the InputDate.

```
<template>

  <UInputDate color="neutral" highlight />

</template>
```

### Variant

Use the `variant` prop to change the variant of the InputDate.

```
<template>

  <UInputDate variant="subtle" />

</template>
```

### Size

Use the `size` prop to change the size of the InputDate.

```
<template>

  <UInputDate size="xl" />

</template>
```

### Separator Icon

Use the `separator-icon` prop to change the icon of the range separator.

```
<template>

  <UInputDate range separator-icon="i-lucide-arrow-right" />

</template>
```

### Disabled

Use the `disabled` prop to disable the InputDate.

```
<template>

  <UInputDate disabled />

</template>
```

## Examples

### With unavailable dates

Use the `is-date-unavailable` prop with a function to mark specific dates as unavailable.

### With min/max dates

Use the `min-value` and `max-value` props to limit the dates.

```
<script setup lang="ts">

import { CalendarDate } from '@internationalized/date'

const modelValue = shallowRef(new CalendarDate(2023, 9, 10))

const minDate = new CalendarDate(2023, 9, 1)

const maxDate = new CalendarDate(2023, 9, 30)

</script>

<template>

  <UInputDate v-model="modelValue" :min-value="minDate" :max-value="maxDate" />

</template>
```

### As a DatePicker

Use a [Calendar](https://ui.nuxt.com/docs/components/calendar) and a [Popover](https://ui.nuxt.com/docs/components/popover) component to create a date picker.

```
<script setup lang="ts">

import { CalendarDate } from '@internationalized/date'

const inputDate = useTemplateRef('inputDate')

const modelValue = shallowRef(new CalendarDate(2022, 1, 10))

</script>

<template>

  <UInputDate ref="inputDate" v-model="modelValue">

    <template #trailing>

      <UPopover :reference="inputDate?.inputsRef[3]?.$el">

        <UButton

          color="neutral"

          variant="link"

          size="sm"

          icon="i-lucide-calendar"

          aria-label="Select a date"

          class="px-0"

        />

        <template #content>

          <UCalendar v-model="modelValue" class="p-2" />

        </template>

      </UPopover>

    </template>

  </UInputDate>

</template>
```

### As a DateRangePicker

Use a [Calendar](https://ui.nuxt.com/docs/components/calendar) and a [Popover](https://ui.nuxt.com/docs/components/popover) component to create a date range picker.

```
<script setup lang="ts">

import { CalendarDate } from '@internationalized/date'

const inputDate = useTemplateRef('inputDate')

const modelValue = shallowRef({

  start: new CalendarDate(2022, 1, 10),

  end: new CalendarDate(2022, 1, 20)

})

</script>

<template>

  <UInputDate ref="inputDate" v-model="modelValue" range>

    <template #trailing>

      <UPopover :reference="inputDate?.inputsRef[0]?.$el">

        <UButton

          color="neutral"

          variant="link"

          size="sm"

          icon="i-lucide-calendar"

          aria-label="Select a date range"

          class="px-0"

        />

        <template #content>

          <UCalendar v-model="modelValue" class="p-2" :number-of-months="2" range />

        </template>

      </UPopover>

    </template>

  </UInputDate>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `color` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `variant` | `'solid'` | ` "outline" \| "soft" \| "subtle" \| "ghost" \| "none"` |
| `size` | `'md'` | ` "xs" \| "sm" \| "md" \| "lg" \| "xl"` |
| `highlight` |  | `boolean`  Highlight the ring color like a focus state. |
| `autofocus` |  | `boolean` |
| `autofocusDelay` | `0` | ` number` |
| `separatorIcon` | `appConfig.ui.icons.minus` | `any`  The icon to use as a range separator. |
| `range` |  | ` R`  Whether or not a range of dates can be selected |
| `defaultValue` |  | `CalendarDate \| CalendarDateTime \| ZonedDateTime \| DateRange` |
| `modelValue` |  | `null \| CalendarDate \| CalendarDateTime \| ZonedDateTime \| DateRange` |
| `icon` |  | `any`  Display an icon based on the `leading` and `trailing` props. |
| `avatar` |  | ` AvatarProps`  Display an avatar on the left side. |
| `leading` |  | `boolean`  When `true`, the icon will be displayed on the left side. |
| `leadingIcon` |  | `any`  Display an icon on the left side. |
| `trailing` |  | `boolean`  When `true`, the icon will be displayed on the right side. |
| `trailingIcon` |  | `any`  Display an icon on the right side. |
| `loading` |  | `boolean`  When `true`, the loading icon will be displayed. |
| `loadingIcon` | `appConfig.ui.icons.loading` | `any`  The icon when the `loading` prop is `true`. |
| `defaultPlaceholder` |  | `CalendarDate \| CalendarDateTime \| ZonedDateTime` |
| `placeholder` |  | `CalendarDate \| CalendarDateTime \| ZonedDateTime` |
| `hourCycle` |  | ` 12 \| 24`  The hour cycle used for formatting times. Defaults to the local preference |
| `step` |  | ` DateStep`  The stepping interval for the time fields. Defaults to `1`. |
| `granularity` |  | ` "day" \| "hour" \| "minute" \| "second"`  The granularity to use for formatting times. Defaults to day if a CalendarDate is provided, otherwise defaults to minute. The field will render segments for each part of the date up to and including the specified granularity |
| `hideTimeZone` |  | `boolean`  Whether or not to hide the time zone segment of the field |
| `maxValue` |  | `CalendarDate \| CalendarDateTime \| ZonedDateTime` |
| `minValue` |  | `CalendarDate \| CalendarDateTime \| ZonedDateTime` |
| `disabled` |  | `boolean`  Whether or not the date field is disabled |
| `readonly` |  | `boolean`  Whether or not the date field is readonly |
| `isDateUnavailable` |  | ` (date: DateValue): boolean` |
| `id` |  | ` string`  Id of the element |
| `name` |  | ` string`  The name of the field. Submitted with its owning form as part of a name/value pair. |
| `required` |  | `boolean`  When `true`, indicates that the user must set the value before the owning form can be submitted. |
| `ui` |  | ` { base?: ClassNameValue; leading?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; trailing?: ClassNameValue; trailingIcon?: ClassNameValue; segment?: ClassNameValue; separatorIcon?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `leading` | `{ ui: object; }` |
| `default` | `{ ui: object; }` |
| `trailing` | `{ ui: object; }` |
| `separator` | `{ ui: object; }` |

### Emits

| Event | Type |
| --- | --- |
| `update:modelValue` | `[date: InputDateModelValue<R>]` |
| `update:placeholder` | `[date: DateValue] & [date: DateValue]` |
| `change` | `[event: Event]` |
| `blur` | `[event: FocusEvent]` |
| `focus` | `[event: FocusEvent]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    inputDate: {

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

        ],

        separatorIcon: 'shrink-0 size-4 text-muted'

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

            segment: 'data-[segment=day]:w-6 data-[segment=month]:w-6 data-[segment=year]:w-9'

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

            segment: 'data-[segment=day]:w-6 data-[segment=month]:w-6 data-[segment=year]:w-9'

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

            segment: 'data-[segment=day]:w-7 data-[segment=month]:w-7 data-[segment=year]:w-11'

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

            segment: 'data-[segment=day]:w-7 data-[segment=month]:w-7 data-[segment=year]:w-11'

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

            segment: 'data-[segment=day]:w-8 data-[segment=month]:w-8 data-[segment=year]:w-13'

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

        inputDate: {

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

            ],

            separatorIcon: 'shrink-0 size-4 text-muted'

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

                segment: 'data-[segment=day]:w-6 data-[segment=month]:w-6 data-[segment=year]:w-9'

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

                segment: 'data-[segment=day]:w-6 data-[segment=month]:w-6 data-[segment=year]:w-9'

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

                segment: 'data-[segment=day]:w-7 data-[segment=month]:w-7 data-[segment=year]:w-11'

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

                segment: 'data-[segment=day]:w-7 data-[segment=month]:w-7 data-[segment=year]:w-11'

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

                segment: 'data-[segment=day]:w-8 data-[segment=month]:w-8 data-[segment=year]:w-13'

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

[`613ac`](https://github.com/nuxt/ui/commit/613ac9ff446292a3a06ff0f7de58fb515bfd14c2) — chore: usage `SegmentPart` from `reka-ui` ([#5577](https://github.com/nuxt/ui/issues/5577))

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`a6efa`](https://github.com/nuxt/ui/commit/a6efa7a48cc33fa83efa96f7b41f6049e6816786) — fix: remove `locale` / `dir` props proxy ([#5432](https://github.com/nuxt/ui/issues/5432))

[`dabc4`](https://github.com/nuxt/ui/commit/dabc4f85ab83307fa9ccb0ae70eb30523837ea46) — feat: new component ([#5387](https://github.com/nuxt/ui/issues/5387))