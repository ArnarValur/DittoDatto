---
title: "Vue Calendar Component"
source: "https://ui.nuxt.com/docs/components/calendar"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A calendar component for selecting single dates, multiple dates or date ranges."
tags:
---
## Calendar

[Calendar](https://reka-ui.com/docs/components/calendar) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Calendar.vue)

A calendar component for selecting single dates, multiple dates or date ranges.

## Usage

Use the `v-model` directive to control the selected date.

February 2022

| 30 | 31 | 1 | 2 | 3 | 4 | 5 |
| --- | --- | --- | --- | --- | --- | --- |
| 6 | 7 | 8 | 9 | 10 | 11 | 12 |
| 13 | 14 | 15 | 16 | 17 | 18 | 19 |
| 20 | 21 | 22 | 23 | 24 | 25 | 26 |
| 27 | 28 | 1 | 2 | 3 | 4 | 5 |
| 6 | 7 | 8 | 9 | 10 | 11 | 12 |

Event Date, February 2022

```
<script setup lang="ts">

import { CalendarDate } from '@internationalized/date'

const value = shallowRef(new CalendarDate(2022, 2, 3))

</script>

<template>

  <UCalendar v-model="value" />

</template>
```

Use the `default-value` prop to set the initial value when you do not need to control its state.

February 2022

| 30 | 31 | 1 | 2 | 3 | 4 | 5 |
| --- | --- | --- | --- | --- | --- | --- |
| 6 | 7 | 8 | 9 | 10 | 11 | 12 |
| 13 | 14 | 15 | 16 | 17 | 18 | 19 |
| 20 | 21 | 22 | 23 | 24 | 25 | 26 |
| 27 | 28 | 1 | 2 | 3 | 4 | 5 |
| 6 | 7 | 8 | 9 | 10 | 11 | 12 |

Event Date, February 2022

```
<script setup lang="ts">

import { CalendarDate } from '@internationalized/date'

const defaultValue = shallowRef(new CalendarDate(2022, 2, 6))

</script>

<template>

  <UCalendar :default-value="defaultValue" />

</template>
```

This component uses the `@internationalized/date` package for locale-aware formatting. The date format is determined by the `locale` prop of the App component.

This component uses the `@internationalized/date` package for locale-aware formatting. The date format is determined by the `locale` prop of the App component.

### Multiple

Use the `multiple` prop to allow multiple selections.

February 2022

| 30 | 31 | 1 | 2 | 3 | 4 | 5 |
| --- | --- | --- | --- | --- | --- | --- |
| 6 | 7 | 8 | 9 | 10 | 11 | 12 |
| 13 | 14 | 15 | 16 | 17 | 18 | 19 |
| 20 | 21 | 22 | 23 | 24 | 25 | 26 |
| 27 | 28 | 1 | 2 | 3 | 4 | 5 |
| 6 | 7 | 8 | 9 | 10 | 11 | 12 |

Event Date, February 2022

```
<script setup lang="ts">

import { CalendarDate } from '@internationalized/date'

const value = shallowRef([

  new CalendarDate(2022, 2, 4),

  new CalendarDate(2022, 2, 6),

  new CalendarDate(2022, 2, 8)

])

</script>

<template>

  <UCalendar multiple v-model="value" />

</template>
```

### Range

Use the `range` prop to select a range of dates.

Event Date, February 2022

February 2022

| 30 | 31 | 1 | 2 | 3 | 4 | 5 |
| --- | --- | --- | --- | --- | --- | --- |
| 6 | 7 | 8 | 9 | 10 | 11 | 12 |
| 13 | 14 | 15 | 16 | 17 | 18 | 19 |
| 20 | 21 | 22 | 23 | 24 | 25 | 26 |
| 27 | 28 | 1 | 2 | 3 | 4 | 5 |
| 6 | 7 | 8 | 9 | 10 | 11 | 12 |

```
<script setup lang="ts">

import { CalendarDate } from '@internationalized/date'

const value = shallowRef({

  start: new CalendarDate(2022, 2, 3),

  end: new CalendarDate(2022, 2, 20)

})

</script>

<template>

  <UCalendar range v-model="value" />

</template>
```

### Color

Use the `color` prop to change the color of the calendar.

January 2026

| 28 | 29 | 30 | 31 | 1 | 2 | 3 |
| --- | --- | --- | --- | --- | --- | --- |
| 4 | 5 | 6 | 7 | 8 | 9 | 10 |
| 11 | 12 | 13 | 14 | 15 | 16 | 17 |
| 18 | 19 | 20 | 21 | 22 | 23 | 24 |
| 25 | 26 | 27 | 28 | 29 | 30 | 31 |
| 1 | 2 | 3 | 4 | 5 | 6 | 7 |

Event Date, January 2026

```
<template>

  <UCalendar color="neutral" />

</template>
```

### Variant

Use the `variant` prop to change the variant of the calendar.

Event Date, February 2022

February 2022

| 30 | 31 | 1 | 2 | 3 | 4 | 5 |
| --- | --- | --- | --- | --- | --- | --- |
| 6 | 7 | 8 | 9 | 10 | 11 | 12 |
| 13 | 14 | 15 | 16 | 17 | 18 | 19 |
| 20 | 21 | 22 | 23 | 24 | 25 | 26 |
| 27 | 28 | 1 | 2 | 3 | 4 | 5 |
| 6 | 7 | 8 | 9 | 10 | 11 | 12 |

```
<template>

  <UCalendar variant="subtle" />

</template>
```

### Size

Use the `size` prop to change the size of the calendar.

January 2026

| 28 | 29 | 30 | 31 | 1 | 2 | 3 |
| --- | --- | --- | --- | --- | --- | --- |
| 4 | 5 | 6 | 7 | 8 | 9 | 10 |
| 11 | 12 | 13 | 14 | 15 | 16 | 17 |
| 18 | 19 | 20 | 21 | 22 | 23 | 24 |
| 25 | 26 | 27 | 28 | 29 | 30 | 31 |
| 1 | 2 | 3 | 4 | 5 | 6 | 7 |

Event Date, January 2026

```
<template>

  <UCalendar size="xl" />

</template>
```

### Disabled

Use the `disabled` prop to disable the calendar.

January 2026

| 28 | 29 | 30 | 31 | 1 | 2 | 3 |
| --- | --- | --- | --- | --- | --- | --- |
| 4 | 5 | 6 | 7 | 8 | 9 | 10 |
| 11 | 12 | 13 | 14 | 15 | 16 | 17 |
| 18 | 19 | 20 | 21 | 22 | 23 | 24 |
| 25 | 26 | 27 | 28 | 29 | 30 | 31 |
| 1 | 2 | 3 | 4 | 5 | 6 | 7 |

Event Date, January 2026

```
<template>

  <UCalendar disabled />

</template>
```

### Number Of Months

Use the `numberOfMonths` prop to change the number of months in the calendar.

January - March 2026

| 28 | 29 | 30 | 31 | 1 | 2 | 3 |
| --- | --- | --- | --- | --- | --- | --- |
| 4 | 5 | 6 | 7 | 8 | 9 | 10 |
| 11 | 12 | 13 | 14 | 15 | 16 | 17 |
| 18 | 19 | 20 | 21 | 22 | 23 | 24 |
| 25 | 26 | 27 | 28 | 29 | 30 | 31 |
| 1 | 2 | 3 | 4 | 5 | 6 | 7 |

| 1 | 2 | 3 | 4 | 5 | 6 | 7 |
| --- | --- | --- | --- | --- | --- | --- |
| 8 | 9 | 10 | 11 | 12 | 13 | 14 |
| 15 | 16 | 17 | 18 | 19 | 20 | 21 |
| 22 | 23 | 24 | 25 | 26 | 27 | 28 |
| 1 | 2 | 3 | 4 | 5 | 6 | 7 |
| 8 | 9 | 10 | 11 | 12 | 13 | 14 |

| 1 | 2 | 3 | 4 | 5 | 6 | 7 |
| --- | --- | --- | --- | --- | --- | --- |
| 8 | 9 | 10 | 11 | 12 | 13 | 14 |
| 15 | 16 | 17 | 18 | 19 | 20 | 21 |
| 22 | 23 | 24 | 25 | 26 | 27 | 28 |
| 29 | 30 | 31 | 1 | 2 | 3 | 4 |
| 5 | 6 | 7 | 8 | 9 | 10 | 11 |

Event Date, January - March 2026

```
<template>

  <UCalendar :number-of-months="3" />

</template>
```

### Month Controls

Use the `month-controls` prop to show the month controls. Defaults to `true`.

January 2026

| 28 | 29 | 30 | 31 | 1 | 2 | 3 |
| --- | --- | --- | --- | --- | --- | --- |
| 4 | 5 | 6 | 7 | 8 | 9 | 10 |
| 11 | 12 | 13 | 14 | 15 | 16 | 17 |
| 18 | 19 | 20 | 21 | 22 | 23 | 24 |
| 25 | 26 | 27 | 28 | 29 | 30 | 31 |
| 1 | 2 | 3 | 4 | 5 | 6 | 7 |

Event Date, January 2026

```
<template>

  <UCalendar :month-controls="false" />

</template>
```

### Year Controls

Use the `year-controls` prop to show the year controls. Defaults to `true`.

January 2026

| 28 | 29 | 30 | 31 | 1 | 2 | 3 |
| --- | --- | --- | --- | --- | --- | --- |
| 4 | 5 | 6 | 7 | 8 | 9 | 10 |
| 11 | 12 | 13 | 14 | 15 | 16 | 17 |
| 18 | 19 | 20 | 21 | 22 | 23 | 24 |
| 25 | 26 | 27 | 28 | 29 | 30 | 31 |
| 1 | 2 | 3 | 4 | 5 | 6 | 7 |

Event Date, January 2026

```
<template>

  <UCalendar :year-controls="false" />

</template>
```

### Fixed Weeks

Use the `fixed-weeks` prop to display the calendar with fixed weeks.

January 2026

| 28 | 29 | 30 | 31 | 1 | 2 | 3 |
| --- | --- | --- | --- | --- | --- | --- |
| 4 | 5 | 6 | 7 | 8 | 9 | 10 |
| 11 | 12 | 13 | 14 | 15 | 16 | 17 |
| 18 | 19 | 20 | 21 | 22 | 23 | 24 |
| 25 | 26 | 27 | 28 | 29 | 30 | 31 |

Event Date, January 2026

```
<template>

  <UCalendar :fixed-weeks="false" />

</template>
```

### Week Numbers 4.4+

Use the `week-numbers` prop to display week numbers in the calendar.

January 2026

| 52 | 28 | 29 | 30 | 31 | 1 | 2 | 3 |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | 4 | 5 | 6 | 7 | 8 | 9 | 10 |
| 2 | 11 | 12 | 13 | 14 | 15 | 16 | 17 |
| 3 | 18 | 19 | 20 | 21 | 22 | 23 | 24 |
| 4 | 25 | 26 | 27 | 28 | 29 | 30 | 31 |
| 5 | 1 | 2 | 3 | 4 | 5 | 6 | 7 |

Event Date, January 2026

```
<template>

  <UCalendar week-numbers />

</template>
```

## Examples

### With chip events

Use the [Chip](https://ui.nuxt.com/docs/components/chip) component to add events to specific days.

January 2022

| 26 | 27 | 28 | 29 | 30 | 31 | 1 |
| --- | --- | --- | --- | --- | --- | --- |
| 2 | 3 | 4 | 5 | 6 | 7 | 8 |
| 9 | 10 | 11 | 12 | 13 | 14 | 15 |
| 16 | 17 | 18 | 19 | 20 | 21 | 22 |
| 23 | 24 | 25 | 26 | 27 | 28 | 29 |
| 30 | 31 | 1 | 2 | 3 | 4 | 5 |

Event Date, January 2022

```
<script setup lang="ts">

import { CalendarDate } from '@internationalized/date'

const modelValue = shallowRef(new CalendarDate(2022, 1, 10))

function getColorByDate(date: Date) {

  const isWeekend = date.getDay() % 6 == 0

  const isDayMeeting = date.getDay() % 3 == 0

  if (isWeekend) {

    return undefined

  }

  if (isDayMeeting) {

    return 'error'

  }

  return 'success'

}

</script>

<template>

  <UCalendar v-model="modelValue">

    <template #day="{ day }">

      <UChip :show="!!getColorByDate(day.toDate('UTC'))" :color="getColorByDate(day.toDate('UTC'))" size="2xs">

        {{ day.day }}

      </UChip>

    </template>

  </UCalendar>

</template>
```

### With disabled dates

Use the `is-date-disabled` prop with a function to mark specific dates as disabled.

Event Date, January 2022

January 2022

| 26 | 27 | 28 | 29 | 30 | 31 | 1 |
| --- | --- | --- | --- | --- | --- | --- |
| 2 | 3 | 4 | 5 | 6 | 7 | 8 |
| 9 | 10 | 11 | 12 | 13 | 14 | 15 |
| 16 | 17 | 18 | 19 | 20 | 21 | 22 |
| 23 | 24 | 25 | 26 | 27 | 28 | 29 |
| 30 | 31 | 1 | 2 | 3 | 4 | 5 |

```
<script setup lang="ts">

import type { DateValue } from '@internationalized/date'

import { CalendarDate } from '@internationalized/date'

const modelValue = shallowRef({

  start: new CalendarDate(2022, 1, 1),

  end: new CalendarDate(2022, 1, 9)

})

const isDateDisabled = (date: DateValue) => {

  return date.day >= 10 && date.day <= 16

}

</script>

<template>

  <UCalendar v-model="modelValue" :is-date-disabled="isDateDisabled" range />

</template>
```

### With unavailable dates

Use the `is-date-unavailable` prop with a function to mark specific dates as unavailable.

Event Date, January 2022

January 2022

| 26 | 27 | 28 | 29 | 30 | 31 | 1 |
| --- | --- | --- | --- | --- | --- | --- |
| 2 | 3 | 4 | 5 | 6 | 7 | 8 |
| 9 | 10 | 11 | 12 | 13 | 14 | 15 |
| 16 | 17 | 18 | 19 | 20 | 21 | 22 |
| 23 | 24 | 25 | 26 | 27 | 28 | 29 |
| 30 | 31 | 1 | 2 | 3 | 4 | 5 |

### With min/max dates

Use the `min-value` and `max-value` props to limit the dates.

September 2023

| 27 | 28 | 29 | 30 | 31 | 1 | 2 |
| --- | --- | --- | --- | --- | --- | --- |
| 3 | 4 | 5 | 6 | 7 | 8 | 9 |
| 10 | 11 | 12 | 13 | 14 | 15 | 16 |
| 17 | 18 | 19 | 20 | 21 | 22 | 23 |
| 24 | 25 | 26 | 27 | 28 | 29 | 30 |
| 1 | 2 | 3 | 4 | 5 | 6 | 7 |

Event Date, September 2023

```
<script setup lang="ts">

import { CalendarDate } from '@internationalized/date'

const modelValue = shallowRef(new CalendarDate(2023, 9, 10))

const minDate = new CalendarDate(2023, 9, 1)

const maxDate = new CalendarDate(2023, 9, 30)

</script>

<template>

  <UCalendar v-model="modelValue" :min-value="minDate" :max-value="maxDate" />

</template>
```

### With other calendar systems

You can use other calenders from `@internationalized/date` to implement a different calendar system.

Tishri 5781

| 24 | 25 | 26 | 27 | 28 | 29 | 1 |
| --- | --- | --- | --- | --- | --- | --- |
| 2 | 3 | 4 | 5 | 6 | 7 | 8 |
| 9 | 10 | 11 | 12 | 13 | 14 | 15 |
| 16 | 17 | 18 | 19 | 20 | 21 | 22 |
| 23 | 24 | 25 | 26 | 27 | 28 | 29 |
| 30 | 1 | 2 | 3 | 4 | 5 | 6 |

Event Date, Tishri 5781

```
<script lang="ts" setup>

import { CalendarDate, HebrewCalendar } from '@internationalized/date'

const hebrewDate = shallowRef(new CalendarDate(new HebrewCalendar(), 5781, 1, 1))

</script>

<template>

  <UCalendar v-model="hebrewDate" />

</template>
```

You can check all the available calendars on `@internationalized/date` docs.

### With external controls

You can control the calendar with external controls by manipulating the date passed in the `v-model`.

April 2025

| 30 | 31 | 1 | 2 | 3 | 4 | 5 |
| --- | --- | --- | --- | --- | --- | --- |
| 6 | 7 | 8 | 9 | 10 | 11 | 12 |
| 13 | 14 | 15 | 16 | 17 | 18 | 19 |
| 20 | 21 | 22 | 23 | 24 | 25 | 26 |
| 27 | 28 | 29 | 30 | 1 | 2 | 3 |
| 4 | 5 | 6 | 7 | 8 | 9 | 10 |

Event Date, April 2025

```
<script setup lang="ts">

import { CalendarDate } from '@internationalized/date'

const date = shallowRef(new CalendarDate(2025, 4, 2))

</script>

<template>

  <div class="flex flex-col gap-4">

    <UCalendar v-model="date" :month-controls="false" :year-controls="false" />

    <div class="flex justify-between gap-4">

      <UButton color="neutral" variant="outline" @click="date = date.subtract({ months: 1 })">

        Prev

      </UButton>

      <UButton color="neutral" variant="outline" @click="date = date.add({ months: 1 })">

        Next

      </UButton>

    </div>

  </div>

</template>
```

### As a DatePicker

Use a [Button](https://ui.nuxt.com/docs/components/button) and a [Popover](https://ui.nuxt.com/docs/components/popover) component to create a date picker.

```
<script setup lang="ts">

import { CalendarDate, DateFormatter, getLocalTimeZone } from '@internationalized/date'

const df = new DateFormatter('en-US', {

  dateStyle: 'medium'

})

const modelValue = shallowRef(new CalendarDate(2022, 1, 10))

</script>

<template>

  <UPopover>

    <UButton color="neutral" variant="subtle" icon="i-lucide-calendar">

      {{ modelValue ? df.format(modelValue.toDate(getLocalTimeZone())) : 'Select a date' }}

    </UButton>

    <template #content>

      <UCalendar v-model="modelValue" class="p-2" />

    </template>

  </UPopover>

</template>
```

### As a DateRangePicker

Use a [Button](https://ui.nuxt.com/docs/components/button) and a [Popover](https://ui.nuxt.com/docs/components/popover) component to create a date range picker.

```
<script setup lang="ts">

import { CalendarDate, DateFormatter, getLocalTimeZone } from '@internationalized/date'

const df = new DateFormatter('en-US', {

  dateStyle: 'medium'

})

const modelValue = shallowRef({

  start: new CalendarDate(2022, 1, 20),

  end: new CalendarDate(2022, 2, 10)

})

</script>

<template>

  <UPopover>

    <UButton color="neutral" variant="subtle" icon="i-lucide-calendar">

      <template v-if="modelValue.start">

        <template v-if="modelValue.end">

          {{ df.format(modelValue.start.toDate(getLocalTimeZone())) }} - {{ df.format(modelValue.end.toDate(getLocalTimeZone())) }}

        </template>

        <template v-else>

          {{ df.format(modelValue.start.toDate(getLocalTimeZone())) }}

        </template>

      </template>

      <template v-else>

        Pick a date

      </template>

    </UButton>

    <template #content>

      <UCalendar v-model="modelValue" class="p-2" :number-of-months="2" range />

    </template>

  </UPopover>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `nextYearIcon` | `appConfig.ui.icons.chevronDoubleRight` | `any`  The icon to use for the next year control. |
| `nextYear` |  | ` Omit<ButtonProps, LinkPropsKeys>`  Configure the next year button.`{ color: 'neutral', variant: 'ghost' }` |
| `nextMonthIcon` | `appConfig.ui.icons.chevronRight` | `any`  The icon to use for the next month control. |
| `nextMonth` |  | ` Omit<ButtonProps, LinkPropsKeys>`  Configure the next month button.`{ color: 'neutral', variant: 'ghost' }` |
| `prevYearIcon` | `appConfig.ui.icons.chevronDoubleLeft` | `any`  The icon to use for the previous year control. |
| `prevYear` |  | ` Omit<ButtonProps, LinkPropsKeys>`  Configure the prev year button.`{ color: 'neutral', variant: 'ghost' }` |
| `prevMonthIcon` | `appConfig.ui.icons.chevronLeft` | `any`  The icon to use for the previous month control. |
| `prevMonth` |  | ` Omit<ButtonProps, LinkPropsKeys>`  Configure the prev month button.`{ color: 'neutral', variant: 'ghost' }` |
| `color` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `variant` | `'solid'` | ` "solid" \| "outline" \| "soft" \| "subtle"` |
| `size` | `'md'` | ` "md" \| "xs" \| "sm" \| "lg" \| "xl"` |
| `range` |  | ` R`  Whether or not a range of dates can be selected |
| `multiple` |  | ` M`  Whether or not multiple dates can be selected |
| `monthControls` | `true` | `boolean`  Show month controls |
| `yearControls` | `true` | `boolean`  Show year controls |
| `defaultValue` |  | `CalendarDate \| CalendarDateTime \| ZonedDateTime \| DateRange \| DateValue[]` |
| `modelValue` |  | `null \| CalendarDate \| CalendarDateTime \| ZonedDateTime \| DateRange \| DateValue[]` |
| `weekNumbers` |  | `boolean` |
| `defaultPlaceholder` |  | `CalendarDate \| CalendarDateTime \| ZonedDateTime` |
| `placeholder` |  | `CalendarDate \| CalendarDateTime \| ZonedDateTime` |
| `allowNonContiguousRanges` |  | `boolean ` |
| `pagedNavigation` |  | `boolean ` |
| `preventDeselect` |  | `boolean `  Whether or not to prevent the user from deselecting a date without selecting another date first |
| `maximumDays` |  | ` number`  The maximum number of days that can be selected in a range |
| `weekStartsOn` |  | ` 0 \| 1 \| 2 \| 4 \| 5 \| 3 \| 6`  The day of the week to start the calendar on |
| `weekdayFormat` |  | ` "narrow" \| "short" \| "long"`  The format to use for the weekday strings provided via the weekdays slot prop |
| `fixedWeeks` | `true` | `boolean `  Whether or not to always display 6 weeks in the calendar |
| `maxValue` |  | `CalendarDate \| CalendarDateTime \| ZonedDateTime` |
| `minValue` |  | `CalendarDate \| CalendarDateTime \| ZonedDateTime` |
| `numberOfMonths` |  | ` number`  The number of months to display at once |
| `disabled` |  | `boolean `  Whether or not the calendar is disabled |
| `readonly` |  | `boolean `  Whether or not the calendar is readonly |
| `initialFocus` |  | `boolean `  If true, the calendar will focus the selected day, today, or the first day of the month depending on what is visible when the calendar is mounted |
| `isDateDisabled` |  | ` (date: DateValue): boolean`  A function that returns whether or not a date is disabled |
| `isDateUnavailable` |  | ` (date: DateValue): boolean` |
| `isDateHighlightable` |  | ` (date: DateValue): boolean`  A function that returns whether or not a date is hightable |
| `nextPage` |  | ` (placeholder: DateValue): DateValue`  A function that returns the next page of the calendar. It receives the current placeholder as an argument inside the component. |
| `prevPage` |  | ` (placeholder: DateValue): DateValue`  A function that returns the previous page of the calendar. It receives the current placeholder as an argument inside the component. |
| `disableDaysOutsideCurrentView` |  | `boolean `  Whether or not to disable days outside the current view. |
| `fixedDate` |  | ` "start" \| "end"`  Which part of the range should be fixed |
| `ui` |  | ` { root?: ClassNameValue; header?: ClassNameValue; body?: ClassNameValue; heading?: ClassNameValue; grid?: ClassNameValue; gridRow?: ClassNameValue; gridWeekDaysRow?: ClassNameValue; gridBody?: ClassNameValue; headCell?: ClassNameValue; headCellWeek?: ClassNameValue; cell?: ClassNameValue; cellTrigger?: ClassNameValue; cellWeek?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `heading` | `{ value: string; }` |
| `day` | `Pick<CalendarCellTriggerProps, "day">` |
| `week-day` | `{ day: string; }` |

### Emits

| Event | Type |
| --- | --- |
| `update:modelValue` | `[date: CalendarModelValue<R, M>]` |
| `update:placeholder` | `[date: DateValue] & [date: DateValue]` |
| `update:validModelValue` | `[date: DateRange]` |
| `update:startValue` | `[date: DateValue \| undefined]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    calendar: {

      slots: {

        root: '',

        header: 'flex items-center justify-between',

        body: 'flex flex-col space-y-4 pt-4 sm:flex-row sm:space-x-4 sm:space-y-0',

        heading: 'text-center font-medium truncate mx-auto',

        grid: 'w-full border-collapse select-none space-y-1 focus:outline-none',

        gridRow: 'grid grid-cols-7 place-items-center',

        gridWeekDaysRow: 'mb-1 grid w-full grid-cols-7',

        gridBody: 'grid',

        headCell: 'rounded-md',

        headCellWeek: 'rounded-md text-muted',

        cell: 'relative text-center',

        cellTrigger: [

          'm-0.5 relative flex items-center justify-center rounded-full whitespace-nowrap focus-visible:ring-2 focus:outline-none data-disabled:text-muted data-unavailable:line-through data-unavailable:text-muted data-unavailable:pointer-events-none data-today:font-semibold data-[outside-view]:text-muted',

          'transition'

        ],

        cellWeek: 'relative text-center text-muted'

      },

      variants: {

        color: {

          primary: {

            headCell: 'text-primary',

            cellTrigger: 'focus-visible:ring-primary'

          },

          secondary: {

            headCell: 'text-secondary',

            cellTrigger: 'focus-visible:ring-secondary'

          },

          success: {

            headCell: 'text-success',

            cellTrigger: 'focus-visible:ring-success'

          },

          info: {

            headCell: 'text-info',

            cellTrigger: 'focus-visible:ring-info'

          },

          warning: {

            headCell: 'text-warning',

            cellTrigger: 'focus-visible:ring-warning'

          },

          error: {

            headCell: 'text-error',

            cellTrigger: 'focus-visible:ring-error'

          },

          neutral: {

            headCell: 'text-highlighted',

            cellTrigger: 'focus-visible:ring-inverted'

          }

        },

        variant: {

          solid: '',

          outline: '',

          soft: '',

          subtle: ''

        },

        size: {

          xs: {

            heading: 'text-xs',

            cell: 'text-xs',

            cellWeek: 'text-xs',

            headCell: 'text-[10px]',

            headCellWeek: 'text-[10px]',

            cellTrigger: 'size-7',

            body: 'space-y-2 pt-2'

          },

          sm: {

            heading: 'text-xs',

            headCell: 'text-xs',

            headCellWeek: 'text-xs',

            cellWeek: 'text-xs',

            cell: 'text-xs',

            cellTrigger: 'size-7'

          },

          md: {

            heading: 'text-sm',

            headCell: 'text-xs',

            headCellWeek: 'text-xs',

            cellWeek: 'text-xs',

            cell: 'text-sm',

            cellTrigger: 'size-8'

          },

          lg: {

            heading: 'text-md',

            headCell: 'text-md',

            headCellWeek: 'text-md',

            cellTrigger: 'size-9 text-md'

          },

          xl: {

            heading: 'text-lg',

            headCell: 'text-lg',

            headCellWeek: 'text-lg',

            cellTrigger: 'size-10 text-lg'

          }

        },

        weekNumbers: {

          true: {

            gridRow: 'grid-cols-8',

            gridWeekDaysRow: 'grid-cols-8 [&>*:first-child]:col-start-2'

          }

        }

      },

      compoundVariants: [

        {

          color: 'primary',

          variant: 'solid',

          class: {

            cellTrigger: 'data-[selected]:bg-primary data-[selected]:text-inverted data-today:not-data-[selected]:text-primary data-[highlighted]:bg-primary/20 hover:not-data-[selected]:bg-primary/20'

          }

        },

        {

          color: 'primary',

          variant: 'outline',

          class: {

            cellTrigger: 'data-[selected]:ring data-[selected]:ring-inset data-[selected]:ring-primary/50 data-[selected]:text-primary data-today:not-data-[selected]:text-primary data-[highlighted]:bg-primary/10 hover:not-data-[selected]:bg-primary/10'

          }

        },

        {

          color: 'primary',

          variant: 'soft',

          class: {

            cellTrigger: 'data-[selected]:bg-primary/10 data-[selected]:text-primary data-today:not-data-[selected]:text-primary data-[highlighted]:bg-primary/20 hover:not-data-[selected]:bg-primary/20'

          }

        },

        {

          color: 'primary',

          variant: 'subtle',

          class: {

            cellTrigger: 'data-[selected]:bg-primary/10 data-[selected]:text-primary data-[selected]:ring data-[selected]:ring-inset data-[selected]:ring-primary/25 data-today:not-data-[selected]:text-primary data-[highlighted]:bg-primary/20 hover:not-data-[selected]:bg-primary/20'

          }

        },

        {

          color: 'neutral',

          variant: 'solid',

          class: {

            cellTrigger: 'data-[selected]:bg-inverted data-[selected]:text-inverted data-today:not-data-[selected]:text-highlighted data-[highlighted]:bg-inverted/20 hover:not-data-[selected]:bg-inverted/10'

          }

        },

        {

          color: 'neutral',

          variant: 'outline',

          class: {

            cellTrigger: 'data-[selected]:ring data-[selected]:ring-inset data-[selected]:ring-accented data-[selected]:text-default data-[selected]:bg-default data-today:not-data-[selected]:text-highlighted data-[highlighted]:bg-inverted/10 hover:not-data-[selected]:bg-inverted/10'

          }

        },

        {

          color: 'neutral',

          variant: 'soft',

          class: {

            cellTrigger: 'data-[selected]:bg-elevated data-[selected]:text-default data-today:not-data-[selected]:text-highlighted data-[highlighted]:bg-inverted/20 hover:not-data-[selected]:bg-inverted/10'

          }

        },

        {

          color: 'neutral',

          variant: 'subtle',

          class: {

            cellTrigger: 'data-[selected]:bg-elevated data-[selected]:text-default data-[selected]:ring data-[selected]:ring-inset data-[selected]:ring-accented data-today:not-data-[selected]:text-highlighted data-[highlighted]:bg-inverted/20 hover:not-data-[selected]:bg-inverted/10'

          }

        }

      ],

      defaultVariants: {

        size: 'md',

        color: 'primary',

        variant: 'solid'

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

        calendar: {

          slots: {

            root: '',

            header: 'flex items-center justify-between',

            body: 'flex flex-col space-y-4 pt-4 sm:flex-row sm:space-x-4 sm:space-y-0',

            heading: 'text-center font-medium truncate mx-auto',

            grid: 'w-full border-collapse select-none space-y-1 focus:outline-none',

            gridRow: 'grid grid-cols-7 place-items-center',

            gridWeekDaysRow: 'mb-1 grid w-full grid-cols-7',

            gridBody: 'grid',

            headCell: 'rounded-md',

            headCellWeek: 'rounded-md text-muted',

            cell: 'relative text-center',

            cellTrigger: [

              'm-0.5 relative flex items-center justify-center rounded-full whitespace-nowrap focus-visible:ring-2 focus:outline-none data-disabled:text-muted data-unavailable:line-through data-unavailable:text-muted data-unavailable:pointer-events-none data-today:font-semibold data-[outside-view]:text-muted',

              'transition'

            ],

            cellWeek: 'relative text-center text-muted'

          },

          variants: {

            color: {

              primary: {

                headCell: 'text-primary',

                cellTrigger: 'focus-visible:ring-primary'

              },

              secondary: {

                headCell: 'text-secondary',

                cellTrigger: 'focus-visible:ring-secondary'

              },

              success: {

                headCell: 'text-success',

                cellTrigger: 'focus-visible:ring-success'

              },

              info: {

                headCell: 'text-info',

                cellTrigger: 'focus-visible:ring-info'

              },

              warning: {

                headCell: 'text-warning',

                cellTrigger: 'focus-visible:ring-warning'

              },

              error: {

                headCell: 'text-error',

                cellTrigger: 'focus-visible:ring-error'

              },

              neutral: {

                headCell: 'text-highlighted',

                cellTrigger: 'focus-visible:ring-inverted'

              }

            },

            variant: {

              solid: '',

              outline: '',

              soft: '',

              subtle: ''

            },

            size: {

              xs: {

                heading: 'text-xs',

                cell: 'text-xs',

                cellWeek: 'text-xs',

                headCell: 'text-[10px]',

                headCellWeek: 'text-[10px]',

                cellTrigger: 'size-7',

                body: 'space-y-2 pt-2'

              },

              sm: {

                heading: 'text-xs',

                headCell: 'text-xs',

                headCellWeek: 'text-xs',

                cellWeek: 'text-xs',

                cell: 'text-xs',

                cellTrigger: 'size-7'

              },

              md: {

                heading: 'text-sm',

                headCell: 'text-xs',

                headCellWeek: 'text-xs',

                cellWeek: 'text-xs',

                cell: 'text-sm',

                cellTrigger: 'size-8'

              },

              lg: {

                heading: 'text-md',

                headCell: 'text-md',

                headCellWeek: 'text-md',

                cellTrigger: 'size-9 text-md'

              },

              xl: {

                heading: 'text-lg',

                headCell: 'text-lg',

                headCellWeek: 'text-lg',

                cellTrigger: 'size-10 text-lg'

              }

            },

            weekNumbers: {

              true: {

                gridRow: 'grid-cols-8',

                gridWeekDaysRow: 'grid-cols-8 [&>*:first-child]:col-start-2'

              }

            }

          },

          compoundVariants: [

            {

              color: 'primary',

              variant: 'solid',

              class: {

                cellTrigger: 'data-[selected]:bg-primary data-[selected]:text-inverted data-today:not-data-[selected]:text-primary data-[highlighted]:bg-primary/20 hover:not-data-[selected]:bg-primary/20'

              }

            },

            {

              color: 'primary',

              variant: 'outline',

              class: {

                cellTrigger: 'data-[selected]:ring data-[selected]:ring-inset data-[selected]:ring-primary/50 data-[selected]:text-primary data-today:not-data-[selected]:text-primary data-[highlighted]:bg-primary/10 hover:not-data-[selected]:bg-primary/10'

              }

            },

            {

              color: 'primary',

              variant: 'soft',

              class: {

                cellTrigger: 'data-[selected]:bg-primary/10 data-[selected]:text-primary data-today:not-data-[selected]:text-primary data-[highlighted]:bg-primary/20 hover:not-data-[selected]:bg-primary/20'

              }

            },

            {

              color: 'primary',

              variant: 'subtle',

              class: {

                cellTrigger: 'data-[selected]:bg-primary/10 data-[selected]:text-primary data-[selected]:ring data-[selected]:ring-inset data-[selected]:ring-primary/25 data-today:not-data-[selected]:text-primary data-[highlighted]:bg-primary/20 hover:not-data-[selected]:bg-primary/20'

              }

            },

            {

              color: 'neutral',

              variant: 'solid',

              class: {

                cellTrigger: 'data-[selected]:bg-inverted data-[selected]:text-inverted data-today:not-data-[selected]:text-highlighted data-[highlighted]:bg-inverted/20 hover:not-data-[selected]:bg-inverted/10'

              }

            },

            {

              color: 'neutral',

              variant: 'outline',

              class: {

                cellTrigger: 'data-[selected]:ring data-[selected]:ring-inset data-[selected]:ring-accented data-[selected]:text-default data-[selected]:bg-default data-today:not-data-[selected]:text-highlighted data-[highlighted]:bg-inverted/10 hover:not-data-[selected]:bg-inverted/10'

              }

            },

            {

              color: 'neutral',

              variant: 'soft',

              class: {

                cellTrigger: 'data-[selected]:bg-elevated data-[selected]:text-default data-today:not-data-[selected]:text-highlighted data-[highlighted]:bg-inverted/20 hover:not-data-[selected]:bg-inverted/10'

              }

            },

            {

              color: 'neutral',

              variant: 'subtle',

              class: {

                cellTrigger: 'data-[selected]:bg-elevated data-[selected]:text-default data-[selected]:ring data-[selected]:ring-inset data-[selected]:ring-accented data-today:not-data-[selected]:text-highlighted data-[highlighted]:bg-inverted/20 hover:not-data-[selected]:bg-inverted/10'

              }

            }

          ],

          defaultVariants: {

            size: 'md',

            color: 'primary',

            variant: 'solid'

          }

        }

      }

    })

  ]

})
```

Some colors in `compoundVariants` are omitted for readability. Check out the source code on GitHub.

## Changelog

[`7a1a7`](https://github.com/nuxt/ui/commit/7a1a71b59289fd96d0e71ecf0cc8897a39ad781b) — feat: add `weekNumbers` prop ([#4555](https://github.com/nuxt/ui/issues/4555))

[`184ea`](https://github.com/nuxt/ui/commit/184eaab1cd5f4f4943b509ea1a3efb1b6f6d7f91) — chore: reduce type verbosity by omitting link props from action buttons

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`a6efa`](https://github.com/nuxt/ui/commit/a6efa7a48cc33fa83efa96f7b41f6049e6816786) — fix: remove `locale` / `dir` props proxy ([#5432](https://github.com/nuxt/ui/issues/5432))

[`bb4f4`](https://github.com/nuxt/ui/commit/bb4f42c38a3023a5b229363bc0b22659ffd8b58c) — feat: add `variant` prop ([#5138](https://github.com/nuxt/ui/issues/5138))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`f7613`](https://github.com/nuxt/ui/commit/f761369888c49fd0ee0f028dcf3c55dd5fbd2cae) — chore: update dependency reka-ui to ^2.3.0 (v3) ([#4234](https://github.com/nuxt/ui/issues/4234))

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`7d51a`](https://github.com/nuxt/ui/commit/7d51a9e479cb6105ea37759c5cd67ff9f7702c49) — fix: wrong color for today date with `neutral` color

[`8dfdd`](https://github.com/nuxt/ui/commit/8dfdd63ce3b3a0e904f7c013c774cf9aaf46b240) — fix: add `place-items-center` to grid row ([#4034](https://github.com/nuxt/ui/issues/4034))

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`b9983`](https://github.com/nuxt/ui/commit/b9983549a4b743724ea3ef99cc4a243f5ca41e53) — fix: improve generic types ([#3331](https://github.com/nuxt/ui/issues/3331))

[`4a2b7`](https://github.com/nuxt/ui/commit/4a2b77d86c28806234002340eda39de4dc78cce0) — feat: allow year and month buttons styling ([#3672](https://github.com/nuxt/ui/issues/3672))

[`a5168`](https://github.com/nuxt/ui/commit/a5168666b7dff08e714d57f497737e7a670f457c) — fix: grey out days outside of displayed month ([#3639](https://github.com/nuxt/ui/issues/3639))