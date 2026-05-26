---
title: "Vue SelectMenu Component"
source: "https://ui.nuxt.com/docs/components/select-menu"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "An advanced searchable select element."
tags:
---
## Usage

Use the `v-model` directive to control the value of the SelectMenu or the `default-value` prop to set the initial value when you do not need to control its state.

Use this over a [`Select`](https://ui.nuxt.com/docs/components/select) to take advantage of Reka UI's [`Combobox`](https://reka-ui.com/docs/components/combobox) component that offers search capabilities and multiple selection.

This component is similar to the [`InputMenu`](https://ui.nuxt.com/docs/components/input-menu) but it's using a Select instead of an Input with the search inside the menu.

### Items

Use the `items` prop as an array of strings, numbers or booleans:

You can also pass an array of objects with the following properties:

- `label?: string`
- [`type?: "label" | "separator" | "item"`](https://ui.nuxt.com/docs/components/#with-items-type)
- [`icon?: string`](https://ui.nuxt.com/docs/components/#with-icons-in-items)
- [`avatar?: AvatarProps`](https://ui.nuxt.com/docs/components/#with-avatar-in-items)
- [`chip?: ChipProps`](https://ui.nuxt.com/docs/components/#with-chip-in-items)
- `disabled?: boolean`
- `onSelect?: (e: Event) => void`
- `class?: any`
- `ui?: { label?: ClassNameValue, separator?: ClassNameValue, item?: ClassNameValue, itemLeadingIcon?: ClassNameValue, itemLeadingAvatarSize?: ClassNameValue, itemLeadingAvatar?: ClassNameValue, itemLeadingChipSize?: ClassNameValue, itemLeadingChip?: ClassNameValue, itemLabel?: ClassNameValue, itemTrailing?: ClassNameValue, itemTrailingIcon?: ClassNameValue }`

You can also pass an array of arrays to the `items` prop to display separated groups of items.

### Value Key

You can choose to bind a single property of the object rather than the whole object by using the `value-key` prop. Defaults to `undefined`.

Use the `by` prop to compare objects by a field instead of reference when the `model-value` is an object.

### Multiple

Use the `multiple` prop to allow multiple selections, the selected items will be separated by a comma in the trigger.

### Placeholder

Use the `placeholder` prop to set a placeholder text.

### Search Input

Use the `search-input` prop to customize or hide the search input (with `false` value).

You can pass any property from the [Input](https://ui.nuxt.com/docs/components/input) component to customize it.

You can set the `search-input` prop to `false` to hide the search input.

Use the `content` prop to control how the SelectMenu content is rendered, like its `align` or `side` for example.

### Arrow

Use the `arrow` prop to display an arrow on the SelectMenu.

### Color

Use the `color` prop to change the ring color when the SelectMenu is focused.

The `highlight` prop is used here to show the focus state. It's used internally when a validation error occurs.

### Variant

Use the `variant` prop to change the variant of the SelectMenu.

### Size

Use the `size` prop to change the size of the SelectMenu.

### Icon

Use the `icon` prop to show an [Icon](https://ui.nuxt.com/docs/components/icon) inside the SelectMenu.

### Trailing Icon

Use the `trailing-icon` prop to customize the trailing [Icon](https://ui.nuxt.com/docs/components/icon). Defaults to `i-lucide-chevron-down`.

You can customize this icon globally in your `app.config.ts` under `ui.icons.chevronDown` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.chevronDown` key.

### Selected Icon

Use the `selected-icon` prop to customize the icon when an item is selected. Defaults to `i-lucide-check`.

You can customize this icon globally in your `app.config.ts` under `ui.icons.check` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.check` key.

### Clear 4.4+

Use the `clear` prop to display a clear button when a value is selected.

### Clear Icon 4.4+

Use the `clear-icon` prop to customize the clear button [Icon](https://ui.nuxt.com/docs/components/icon). Defaults to `i-lucide-x`.

You can customize this icon globally in your `app.config.ts` under `ui.icons.close` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.close` key.

Use the `avatar` prop to display an [Avatar](https://ui.nuxt.com/docs/components/avatar) inside the SelectMenu.

Use the `loading` prop to show a loading icon on the SelectMenu.

Use the `loading-icon` prop to customize the loading icon. Defaults to `i-lucide-loader-circle`.

You can customize this icon globally in your `app.config.ts` under `ui.icons.loading` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.loading` key.

### Disabled

Use the `disabled` prop to disable the SelectMenu.

## Examples

### With items type

You can use the `type` property with `separator` to display a separator between items or `label` to display a label.

### With icon in items

You can use the `icon` property to display an [Icon](https://ui.nuxt.com/docs/components/icon) inside the items.

You can also use the `#leading` slot to display the selected icon.

You can use the `avatar` property to display an [Avatar](https://ui.nuxt.com/docs/components/avatar) inside the items.

You can also use the `#leading` slot to display the selected avatar.

### With chip in items

You can use the `chip` property to display a [Chip](https://ui.nuxt.com/docs/components/chip) inside the items.

In this example, the `#leading` slot is used to display the selected chip.

### Control open state

You can control the open state by using the `default-open` prop or the `v-model:open` directive.

In this example, leveraging [`defineShortcuts`](https://ui.nuxt.com/docs/composables/define-shortcuts), you can toggle the SelectMenu by pressing O.

Use the `v-model:search-term` directive to control the search term.

### With rotating icon

Here is an example with a rotating icon that indicates the open state of the SelectMenu.

### With create item

Use the `create-item` prop to enable users to add custom values that aren't in the predefined options.

The create option shows when no match is found by default. Set it to `always` to show it even when similar values exist.

Use the `@create` event to handle the creation of the item. You will receive the event and the item as arguments.

### With fetched items

You can fetch items from an API and use them in the SelectMenu.

### With ignore filter

Set the `ignore-filter` prop to `true` to disable the internal search and use your own search logic.

This example uses [`refDebounced`](https://vueuse.org/shared/refDebounced/#refdebounced) to debounce the API calls.

### With filter fields

Use the `filter-fields` prop with an array of fields to filter on. Defaults to `[labelKey]`.

### With virtualization 4.1+

Use the `virtualize` prop to enable virtualization for large lists as a boolean or an object with options like `{ estimateSize: 32, overscan: 12 }`.

When enabled, all groups are flattened into a single list due to a limitation of Reka UI.

### With infinite scroll 4.4+

You can use the [`useInfiniteScroll`](https://vueuse.org/core/useInfiniteScroll/) composable to load more data as the user scrolls.

```
<script setup lang="ts">

import { useInfiniteScroll } from '@vueuse/core'

type User = {

  firstName: string

}

type UserResponse = {

  users: User[]

  total: number

  skip: number

  limit: number

}

const skip = ref(0)

const { data, status, execute } = await useFetch(

  'https://dummyjson.com/users?limit=10&select=firstName',

  {

    key: 'select-menu-users-infinite-scroll',

    params: { skip },

    transform: (data?: UserResponse) => {

      return data?.users.map((user) => user.firstName)

    },

    lazy: true,

    immediate: false

  }

)

const users = ref<string[]>([])

watch(data, () => {

  users.value = [...users.value, ...(data.value || [])]

})

execute()

const selectMenu = useTemplateRef('selectMenu')

onMounted(() => {

  useInfiniteScroll(

    () => selectMenu.value?.viewportRef,

    () => {

      skip.value += 10

    },

    {

      canLoadMore: () => {

        return status.value !== 'pending'

      }

    }

  )

})

</script>

<template>

  <USelectMenu ref="selectMenu" placeholder="Select user" :items="users" />

</template>
```

### With full content width

You can expand the content to the full width of its items by adding the `min-w-fit` class on the `ui.content` slot.

You can also change the content width globally in your `app.config.ts`:

### As a CountryPicker

This example demonstrates using the SelectMenu as a country picker with lazy loading - countries are only fetched when the menu is opened.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `id` |  | ` string` |
| `placeholder` |  | ` string`  The placeholder text when the select is empty. |
| `searchInput` | `true` | `boolean \| InputProps<AcceptableValue>`  Whether to display the search input or not. Can be an object to pass additional props to the input.`{ placeholder: 'Search...', variant: 'none' }` |
| `color` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `variant` | `'outline'` | ` "outline" \| "soft" \| "subtle" \| "ghost" \| "none"` |
| `size` | `'md'` | ` "sm" \| "md" \| "xs" \| "lg" \| "xl"` |
| `required` |  | `boolean` |
| `trailingIcon` | `appConfig.ui.icons.chevronDown` | `any` |
| `selectedIcon` | `appConfig.ui.icons.check` | `any`  The icon displayed when an item is selected. |
| `clear` | `false` | `boolean \| Partial<Omit<ButtonProps, LinkPropsKeys>>`  Display a clear button to reset the model value. Can be an object to pass additional props to the Button. |
| `clearIcon` | `appConfig.ui.icons.close` | `any`  The icon displayed in the clear button. |
| `content` | `{ side: 'bottom', sideOffset: 8, collisionPadding: 8, position: 'popper' }` | ` Omit<ComboboxContentProps, "asChild" \| "as" \| "forceMount"> & Partial<EmitsToProps<DismissableLayerEmits>>` |
| `arrow` | `false` | `boolean \| Omit<ComboboxArrowProps, "asChild" \| "as">` |
| `portal` | `true` | ` string \| false \| true \| HTMLElement` |
| `virtualize` | `false` | `boolean \| { overscan?: number ; estimateSize?: number \| ((index: number) => number) \| undefined; } \| undefined`  Enable virtualization for large lists. Note: when enabled, all groups are flattened into a single list due to a limitation of Reka UI ([https://github.com/unovue/reka-ui/issues/1885](https://github.com/unovue/reka-ui/issues/1885)). |
| `valueKey` | `undefined` | ` VK`  When `items` is an array of objects, select the field to use as the value instead of the object itself. |
| `labelKey` | `'label'` | ` keyof Extract<NestedItem<T>, object> \| DotPathKeys<Extract<NestedItem<T>, object>>`  When `items` is an array of objects, select the field to use as the label. |
| `descriptionKey` | `'description'` | ` keyof Extract<NestedItem<T>, object> \| DotPathKeys<Extract<NestedItem<T>, object>>`  When `items` is an array of objects, select the field to use as the description. |
| `items` |  | ` T` |
| `defaultValue` |  | ` GetModelValue<T, VK, M>` |
| `modelValue` |  | ` GetModelValue<T, VK, M>` |
| `modelModifiers` |  | ` Omit<ModelModifiers<GetModelValue<T, VK, M>>, "lazy">` |
| `multiple` |  | ` M`  Whether multiple options can be selected or not. |
| `highlight` |  | `boolean`  Highlight the ring color like a focus state. |
| `createItem` | `false` | `boolean \| "always" \| { position?: "top" \| "bottom" ; when?: "always" \| "empty" \| undefined; } \| undefined`  Determines if custom user input that does not exist in options can be added. |
| `filterFields` | `[labelKey]` | ` string[]`  Fields to filter items by. |
| `ignoreFilter` | `false` | `boolean`  When `true`, disable the default filters, useful for custom filtering (useAsyncData, useFetch, etc.). |
| `autofocus` |  | `boolean ` |
| `autofocusDelay` | `0` | ` number` |
| `disabled` |  | `boolean `  When `true`, prevents the user from interacting with listbox |
| `open` |  | `boolean `  The controlled open state of the Combobox. Can be binded with with `v-model:open`. |
| `defaultOpen` |  | `boolean `  The open state of the combobox when it is initially rendered.   Use when you do not need to control its open state. |
| `name` |  | ` string`  The name of the field. Submitted with its owning form as part of a name/value pair. |
| `resetSearchTermOnBlur` | `true` | `boolean `  Whether to reset the searchTerm when the Combobox input blurred |
| `resetSearchTermOnSelect` | `true` | `boolean `  Whether to reset the searchTerm when the Combobox value is selected |
| `resetModelValueOnClear` | `true` | `boolean `  When `true` the `modelValue` will be reset to `null` (or `[]` if `multiple`) |
| `highlightOnHover` |  | `boolean `  When `true`, hover over item will trigger highlight |
| `by` |  | ` string \| (a: T, b: T): boolean`  Use this to compare objects by a particular field, or pass your own comparison function for complete control over how objects are compared. |
| `icon` |  | `any`  Display an icon based on the `leading` and `trailing` props. |
| `avatar` |  | ` AvatarProps`  Display an avatar on the left side. |
| `leading` |  | `boolean `  When `true`, the icon will be displayed on the left side. |
| `leadingIcon` |  | `any`  Display an icon on the left side. |
| `trailing` |  | `boolean `  When `true`, the icon will be displayed on the right side. |
| `loading` |  | `boolean `  When `true`, the loading icon will be displayed. |
| `loadingIcon` | `appConfig.ui.icons.loading` | `any`  The icon when the `loading` prop is `true`. |
| `searchTerm` | `''` | ` string` |
| `ui` |  | ` { base?: ClassNameValue; leading?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; trailing?: ClassNameValue; trailingIcon?: ClassNameValue; value?: ClassNameValue; placeholder?: ClassNameValue; arrow?: ClassNameValue; content?: ClassNameValue; viewport?: ClassNameValue; group?: ClassNameValue; empty?: ClassNameValue; label?: ClassNameValue; separator?: ClassNameValue; item?: ClassNameValue; itemLeadingIcon?: ClassNameValue; itemLeadingAvatar?: ClassNameValue; itemLeadingAvatarSize?: ClassNameValue; itemLeadingChip?: ClassNameValue; itemLeadingChipSize?: ClassNameValue; itemTrailing?: ClassNameValue; itemTrailingIcon?: ClassNameValue; itemWrapper?: ClassNameValue; itemLabel?: ClassNameValue; itemDescription?: ClassNameValue; input?: ClassNameValue; focusScope?: ClassNameValue; trailingClear?: ClassNameValue; }` |

This component also supports all native `<button>` HTML attributes.

### Slots

| Slot | Type |
| --- | --- |
| `leading` | `{ modelValue?: GetModelValue<T, VK, M> \| undefined; open: boolean; ui: object; }` |
| `default` | `{ modelValue?: GetModelValue<T, VK, M> \| undefined; open: boolean; ui: object; }` |
| `trailing` | `{ modelValue?: GetModelValue<T, VK, M> \| undefined; open: boolean; ui: object; }` |
| `empty` | `{ searchTerm?: string \| undefined; }` |
| `item` | `{ item: NestedItem<T>; index: number; ui: object; }` |
| `item-leading` | `{ item: NestedItem<T>; index: number; ui: object; }` |
| `item-label` | `{ item: NestedItem<T>; index: number; }` |
| `item-description` | `{ item: NestedItem<T>; index: number; }` |
| `item-trailing` | `{ item: NestedItem<T>; index: number; ui: object; }` |
| `content-top` | `{}` |
| `content-bottom` | `{} ` |
| `create-item-label` | `{ item: string; }` |

### Emits

| Event | Type |
| --- | --- |
| `update:open` | `[value: boolean]` |
| `change` | `[event: Event]` |
| `blur` | `[event: FocusEvent]` |
| `focus` | `[event: FocusEvent]` |
| `create` | `[item: string]` |
| `clear` | `[]` |
| `highlight` | `[payload: { ref: HTMLElement; value: GetModelValue<T, VK, M>; } \| undefined]` |
| `update:modelValue` | `[value: GetModelValue<T, VK, M>]` |
| `update:searchTerm` | `[value: string]` |

### Expose

When accessing the component via a template ref, you can use the following:

| Name | Type |
| --- | --- |
| `triggerRef` | `Ref<HTMLButtonElement \| null>` |
| `viewportRef` | `Ref<HTMLDivElement \| null>` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    selectMenu: {

      slots: {

        base: [

          'relative group rounded-md inline-flex items-center focus:outline-none disabled:cursor-not-allowed disabled:opacity-75',

          'transition-colors'

        ],

        leading: 'absolute inset-y-0 start-0 flex items-center',

        leadingIcon: 'shrink-0 text-dimmed',

        leadingAvatar: 'shrink-0',

        leadingAvatarSize: '',

        trailing: 'absolute inset-y-0 end-0 flex items-center',

        trailingIcon: 'shrink-0 text-dimmed',

        value: 'truncate pointer-events-none',

        placeholder: 'truncate text-dimmed',

        arrow: 'fill-default',

        content: [

          'max-h-60 w-(--reka-select-trigger-width) bg-default shadow-lg rounded-md ring ring-default overflow-hidden data-[state=open]:animate-[scale-in_100ms_ease-out] data-[state=closed]:animate-[scale-out_100ms_ease-in] origin-(--reka-select-content-transform-origin) pointer-events-auto flex flex-col',

          'origin-(--reka-combobox-content-transform-origin) w-(--reka-combobox-trigger-width)'

        ],

        viewport: 'relative scroll-py-1 overflow-y-auto flex-1',

        group: 'p-1 isolate',

        empty: 'text-center text-muted',

        label: 'font-semibold text-highlighted',

        separator: '-mx-1 my-1 h-px bg-border',

        item: [

          'group relative w-full flex items-start select-none outline-none before:absolute before:z-[-1] before:inset-px before:rounded-md data-disabled:cursor-not-allowed data-disabled:opacity-75 text-default data-highlighted:not-data-disabled:text-highlighted data-highlighted:not-data-disabled:before:bg-elevated/50',

          'transition-colors before:transition-colors'

        ],

        itemLeadingIcon: [

          'shrink-0 text-dimmed group-data-highlighted:not-group-data-disabled:text-default',

          'transition-colors'

        ],

        itemLeadingAvatar: 'shrink-0',

        itemLeadingAvatarSize: '',

        itemLeadingChip: 'shrink-0',

        itemLeadingChipSize: '',

        itemTrailing: 'ms-auto inline-flex gap-1.5 items-center',

        itemTrailingIcon: 'shrink-0',

        itemWrapper: 'flex-1 flex flex-col min-w-0',

        itemLabel: 'truncate',

        itemDescription: 'truncate text-muted',

        input: 'border-b border-default',

        focusScope: 'flex flex-col min-h-0',

        trailingClear: 'p-0'

      },

      variants: {

        fieldGroup: {

          horizontal: 'not-only:first:rounded-e-none not-only:last:rounded-s-none not-last:not-first:rounded-none focus-visible:z-[1]',

          vertical: 'not-only:first:rounded-b-none not-only:last:rounded-t-none not-last:not-first:rounded-none focus-visible:z-[1]'

        },

        size: {

          xs: {

            base: 'px-2 py-1 text-xs gap-1',

            leading: 'ps-2',

            trailing: 'pe-2',

            leadingIcon: 'size-4',

            leadingAvatarSize: '3xs',

            trailingIcon: 'size-4',

            label: 'p-1 text-[10px]/3 gap-1',

            item: 'p-1 text-xs gap-1',

            itemLeadingIcon: 'size-4',

            itemLeadingAvatarSize: '3xs',

            itemLeadingChip: 'size-4',

            itemLeadingChipSize: 'sm',

            itemTrailingIcon: 'size-4',

            empty: 'p-1 text-xs'

          },

          sm: {

            base: 'px-2.5 py-1.5 text-xs gap-1.5',

            leading: 'ps-2.5',

            trailing: 'pe-2.5',

            leadingIcon: 'size-4',

            leadingAvatarSize: '3xs',

            trailingIcon: 'size-4',

            label: 'p-1.5 text-[10px]/3 gap-1.5',

            item: 'p-1.5 text-xs gap-1.5',

            itemLeadingIcon: 'size-4',

            itemLeadingAvatarSize: '3xs',

            itemLeadingChip: 'size-4',

            itemLeadingChipSize: 'sm',

            itemTrailingIcon: 'size-4',

            empty: 'p-1.5 text-xs'

          },

          md: {

            base: 'px-2.5 py-1.5 text-sm gap-1.5',

            leading: 'ps-2.5',

            trailing: 'pe-2.5',

            leadingIcon: 'size-5',

            leadingAvatarSize: '2xs',

            trailingIcon: 'size-5',

            label: 'p-1.5 text-xs gap-1.5',

            item: 'p-1.5 text-sm gap-1.5',

            itemLeadingIcon: 'size-5',

            itemLeadingAvatarSize: '2xs',

            itemLeadingChip: 'size-5',

            itemLeadingChipSize: 'md',

            itemTrailingIcon: 'size-5',

            empty: 'p-1.5 text-sm'

          },

          lg: {

            base: 'px-3 py-2 text-sm gap-2',

            leading: 'ps-3',

            trailing: 'pe-3',

            leadingIcon: 'size-5',

            leadingAvatarSize: '2xs',

            trailingIcon: 'size-5',

            label: 'p-2 text-xs gap-2',

            item: 'p-2 text-sm gap-2',

            itemLeadingIcon: 'size-5',

            itemLeadingAvatarSize: '2xs',

            itemLeadingChip: 'size-5',

            itemLeadingChipSize: 'md',

            itemTrailingIcon: 'size-5',

            empty: 'p-2 text-sm'

          },

          xl: {

            base: 'px-3 py-2 text-base gap-2',

            leading: 'ps-3',

            trailing: 'pe-3',

            leadingIcon: 'size-6',

            leadingAvatarSize: 'xs',

            trailingIcon: 'size-6',

            label: 'p-2 text-sm gap-2',

            item: 'p-2 text-base gap-2',

            itemLeadingIcon: 'size-6',

            itemLeadingAvatarSize: 'xs',

            itemLeadingChip: 'size-6',

            itemLeadingChipSize: 'lg',

            itemTrailingIcon: 'size-6',

            empty: 'p-2 text-base'

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

        virtualize: {

          true: {

            viewport: 'p-1 isolate'

          },

          false: {

            viewport: 'divide-y divide-default'

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

        selectMenu: {

          slots: {

            base: [

              'relative group rounded-md inline-flex items-center focus:outline-none disabled:cursor-not-allowed disabled:opacity-75',

              'transition-colors'

            ],

            leading: 'absolute inset-y-0 start-0 flex items-center',

            leadingIcon: 'shrink-0 text-dimmed',

            leadingAvatar: 'shrink-0',

            leadingAvatarSize: '',

            trailing: 'absolute inset-y-0 end-0 flex items-center',

            trailingIcon: 'shrink-0 text-dimmed',

            value: 'truncate pointer-events-none',

            placeholder: 'truncate text-dimmed',

            arrow: 'fill-default',

            content: [

              'max-h-60 w-(--reka-select-trigger-width) bg-default shadow-lg rounded-md ring ring-default overflow-hidden data-[state=open]:animate-[scale-in_100ms_ease-out] data-[state=closed]:animate-[scale-out_100ms_ease-in] origin-(--reka-select-content-transform-origin) pointer-events-auto flex flex-col',

              'origin-(--reka-combobox-content-transform-origin) w-(--reka-combobox-trigger-width)'

            ],

            viewport: 'relative scroll-py-1 overflow-y-auto flex-1',

            group: 'p-1 isolate',

            empty: 'text-center text-muted',

            label: 'font-semibold text-highlighted',

            separator: '-mx-1 my-1 h-px bg-border',

            item: [

              'group relative w-full flex items-start select-none outline-none before:absolute before:z-[-1] before:inset-px before:rounded-md data-disabled:cursor-not-allowed data-disabled:opacity-75 text-default data-highlighted:not-data-disabled:text-highlighted data-highlighted:not-data-disabled:before:bg-elevated/50',

              'transition-colors before:transition-colors'

            ],

            itemLeadingIcon: [

              'shrink-0 text-dimmed group-data-highlighted:not-group-data-disabled:text-default',

              'transition-colors'

            ],

            itemLeadingAvatar: 'shrink-0',

            itemLeadingAvatarSize: '',

            itemLeadingChip: 'shrink-0',

            itemLeadingChipSize: '',

            itemTrailing: 'ms-auto inline-flex gap-1.5 items-center',

            itemTrailingIcon: 'shrink-0',

            itemWrapper: 'flex-1 flex flex-col min-w-0',

            itemLabel: 'truncate',

            itemDescription: 'truncate text-muted',

            input: 'border-b border-default',

            focusScope: 'flex flex-col min-h-0',

            trailingClear: 'p-0'

          },

          variants: {

            fieldGroup: {

              horizontal: 'not-only:first:rounded-e-none not-only:last:rounded-s-none not-last:not-first:rounded-none focus-visible:z-[1]',

              vertical: 'not-only:first:rounded-b-none not-only:last:rounded-t-none not-last:not-first:rounded-none focus-visible:z-[1]'

            },

            size: {

              xs: {

                base: 'px-2 py-1 text-xs gap-1',

                leading: 'ps-2',

                trailing: 'pe-2',

                leadingIcon: 'size-4',

                leadingAvatarSize: '3xs',

                trailingIcon: 'size-4',

                label: 'p-1 text-[10px]/3 gap-1',

                item: 'p-1 text-xs gap-1',

                itemLeadingIcon: 'size-4',

                itemLeadingAvatarSize: '3xs',

                itemLeadingChip: 'size-4',

                itemLeadingChipSize: 'sm',

                itemTrailingIcon: 'size-4',

                empty: 'p-1 text-xs'

              },

              sm: {

                base: 'px-2.5 py-1.5 text-xs gap-1.5',

                leading: 'ps-2.5',

                trailing: 'pe-2.5',

                leadingIcon: 'size-4',

                leadingAvatarSize: '3xs',

                trailingIcon: 'size-4',

                label: 'p-1.5 text-[10px]/3 gap-1.5',

                item: 'p-1.5 text-xs gap-1.5',

                itemLeadingIcon: 'size-4',

                itemLeadingAvatarSize: '3xs',

                itemLeadingChip: 'size-4',

                itemLeadingChipSize: 'sm',

                itemTrailingIcon: 'size-4',

                empty: 'p-1.5 text-xs'

              },

              md: {

                base: 'px-2.5 py-1.5 text-sm gap-1.5',

                leading: 'ps-2.5',

                trailing: 'pe-2.5',

                leadingIcon: 'size-5',

                leadingAvatarSize: '2xs',

                trailingIcon: 'size-5',

                label: 'p-1.5 text-xs gap-1.5',

                item: 'p-1.5 text-sm gap-1.5',

                itemLeadingIcon: 'size-5',

                itemLeadingAvatarSize: '2xs',

                itemLeadingChip: 'size-5',

                itemLeadingChipSize: 'md',

                itemTrailingIcon: 'size-5',

                empty: 'p-1.5 text-sm'

              },

              lg: {

                base: 'px-3 py-2 text-sm gap-2',

                leading: 'ps-3',

                trailing: 'pe-3',

                leadingIcon: 'size-5',

                leadingAvatarSize: '2xs',

                trailingIcon: 'size-5',

                label: 'p-2 text-xs gap-2',

                item: 'p-2 text-sm gap-2',

                itemLeadingIcon: 'size-5',

                itemLeadingAvatarSize: '2xs',

                itemLeadingChip: 'size-5',

                itemLeadingChipSize: 'md',

                itemTrailingIcon: 'size-5',

                empty: 'p-2 text-sm'

              },

              xl: {

                base: 'px-3 py-2 text-base gap-2',

                leading: 'ps-3',

                trailing: 'pe-3',

                leadingIcon: 'size-6',

                leadingAvatarSize: 'xs',

                trailingIcon: 'size-6',

                label: 'p-2 text-sm gap-2',

                item: 'p-2 text-base gap-2',

                itemLeadingIcon: 'size-6',

                itemLeadingAvatarSize: 'xs',

                itemLeadingChip: 'size-6',

                itemLeadingChipSize: 'lg',

                itemTrailingIcon: 'size-6',

                empty: 'p-2 text-base'

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

            virtualize: {

              true: {

                viewport: 'p-1 isolate'

              },

              false: {

                viewport: 'divide-y divide-default'

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

[`36cd5`](https://github.com/nuxt/ui/commit/36cd5e5eb579f422793a1ddc195a9f71227be8c8) — feat: add `by` prop ([#5906](https://github.com/nuxt/ui/issues/5906))

[`f4a94`](https://github.com/nuxt/ui/commit/f4a945cc59bc9bf143bb05986cba3cb1b73a3aa7) — feat: expose `viewportRef` for infinite scroll ([#5836](https://github.com/nuxt/ui/issues/5836))

[`d51b4`](https://github.com/nuxt/ui/commit/d51b424d9e306c25fc7dc32857011ffaffe56d7e) — feat: handle virtualizer `estimateSize` as function ([#5748](https://github.com/nuxt/ui/issues/5748))

[`ec6b8`](https://github.com/nuxt/ui/commit/ec6b8ecb037ef5c241283c8ac47a3b63364bebab) — feat: add `clear` prop ([#5643](https://github.com/nuxt/ui/issues/5643))

[`a92ee`](https://github.com/nuxt/ui/commit/a92ee7b58bb667dc9c3ddd89e1c0fb2ea08f7eaa) — feat: add `modelModifiers` prop ([#5559](https://github.com/nuxt/ui/issues/5559))

[`418c8`](https://github.com/nuxt/ui/commit/418c87bc5b8aeaceb903f6b20d98d8da63590eb5) — fix: prevent change event when selecting create item

[`56ae8`](https://github.com/nuxt/ui/commit/56ae8e7199b8d5e3b5a169bd63c767724abfb582) — fix: calc virtualizer estimateSize based on item description

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`fda3c`](https://github.com/nuxt/ui/commit/fda3c98ab798f045e6e3d781ec482ebe5f360c4e) — fix: clean html attributes extend

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`fce2d`](https://github.com/nuxt/ui/commit/fce2df4e0660d0bdb3cdd4fb3041416824cbe893) — fix!: consistent exposed refs ([#5385](https://github.com/nuxt/ui/issues/5385))

[`70cf0`](https://github.com/nuxt/ui/commit/70cf05f5103776eadbee5e5bcae7d2bb30543d4a) — feat: handle `description` in items ([#5193](https://github.com/nuxt/ui/issues/5193))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`63074`](https://github.com/nuxt/ui/commit/63074d62151924e19a71c4f7e89c5abfd0b5fad1) — fix: enrich reusable template item prop

[`84f87`](https://github.com/nuxt/ui/commit/84f87a5953b508d74662dd3e81715ee86e75d71f) — feat: add global event handlers and checkbox example ([#5195](https://github.com/nuxt/ui/issues/5195))

[`c744d`](https://github.com/nuxt/ui/commit/c744d6ff82424365acc9f5489a5352e5e552b5f6) — feat: implement virtualization ([#5162](https://github.com/nuxt/ui/issues/5162))

[`788d2`](https://github.com/nuxt/ui/commit/788d2deb53b2a96c8d87828629b3d5d5ec5187d6) — fix: standardize naming for type interfaces ([#4990](https://github.com/nuxt/ui/issues/4990))

[`11a03`](https://github.com/nuxt/ui/commit/11a03201ed8454f37e911db4a14b00f74104932a) — fix: dot notation type support for `labelKey` and `valueKey` ([#4933](https://github.com/nuxt/ui/issues/4933))

[`7133f`](https://github.com/nuxt/ui/commit/7133f501e4346ba6990c437cfa16af05b886c884) — fix: broken types for `update:model-value` event ([#4853](https://github.com/nuxt/ui/issues/4853))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`55dbc`](https://github.com/nuxt/ui/commit/55dbcd20a882e8c72bba975d0633a744284faa19) — fix: handle focus via label inside a FormField ([#4696](https://github.com/nuxt/ui/issues/4696))

[`34ca8`](https://github.com/nuxt/ui/commit/34ca811ff095ac4cfecc3fc7128cc4703e3b3dbb) — fix: add display value fallback when no items found ([#4689](https://github.com/nuxt/ui/issues/4689))

[`a0963`](https://github.com/nuxt/ui/commit/a0963eba8254d2ecf02cd1ee87cee7f73c4b2bc4) — feat!: rename from `ButtonGroup` ([#4596](https://github.com/nuxt/ui/issues/4596))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`4d423`](https://github.com/nuxt/ui/commit/4d4234d2f8d0180f6a0241d3b4cbc8677ffa52ff) — fix: improve display value without `valueKey`

[`48870`](https://github.com/nuxt/ui/commit/488707e1483caee1dc3b4d8d7261df4282cac6b9) — fix: filter null items in search

[`c92f9`](https://github.com/nuxt/ui/commit/c92f908b8d3861feebf7659dc69ee763bacbe0cf) — fix: only filter non-null fields

[`b0364`](https://github.com/nuxt/ui/commit/b0364b96b73b9e543781a35962c03b5a983352c4) — fix: dynamic input size

[`7a2bd`](https://github.com/nuxt/ui/commit/7a2bd4e6179373902ba6f285903ea896fd1d378f) — feat: expose trigger refs

[`1a4de`](https://github.com/nuxt/ui/commit/1a4de49c1665c9ef65279315be0393d6272447b9) — feat: handle dynamic `autofocus`

[`483e4`](https://github.com/nuxt/ui/commit/483e473e3f5681cc97c3766ea47283dc95f76345) — fix: prevent empty string display when multiple

[`7df7e`](https://github.com/nuxt/ui/commit/7df7ee336a925d7ee07f866551dad9350785c9fc) — fix: display falsy values

[`f95ab`](https://github.com/nuxt/ui/commit/f95abf8d1d7b9149e400d7dc6f96f93f5154da7a) — fix: manual viewport to display scrollbars

[`b9adc`](https://github.com/nuxt/ui/commit/b9adc83e787db02507e6e7bb1aabc684eccc197b) — feat: add `ui` field in items ([#4060](https://github.com/nuxt/ui/issues/4060))

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`1a463`](https://github.com/nuxt/ui/commit/1a463946681e152aa18372118d0fef4a7d8055a5) — feat: add new `content-top` and `content-bottom` slots ([#3886](https://github.com/nuxt/ui/issues/3886))

[`9ca21`](https://github.com/nuxt/ui/commit/9ca213bd3340492d7503a34bd142e1f79a697050) — fix: remove `valueKey` string case

[`29fa4`](https://github.com/nuxt/ui/commit/29fa46276d6bf69b5b87880c476c6f778c2820bf) — feat: add global `portal` prop ([#3688](https://github.com/nuxt/ui/issues/3688))

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`01d8d`](https://github.com/nuxt/ui/commit/01d8dc72adb0b32ad68bb4a98bf24b17f435a89c) — fix: respect `transform-origin` in popper content ([#3919](https://github.com/nuxt/ui/issues/3919))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`8435a`](https://github.com/nuxt/ui/commit/8435a0fe1622eb5b6863b6e4751c9d2d1be36db9) — fix: prevent `disabled` items to be selected

[`cea88`](https://github.com/nuxt/ui/commit/cea881abdc139b39df89b503cf2ab872f4246c8f) — feat: handle `resetSearchTermOnSelect`

[`52a97`](https://github.com/nuxt/ui/commit/52a97e2df7903f91e3134931eb0d6bd4c528f71f) — fix: support arbitrary `value` ([#3779](https://github.com/nuxt/ui/issues/3779))

[`f25fe`](https://github.com/nuxt/ui/commit/f25fed58e988b304e79cdb536d544d257395cf89) — fix: correctly call `onSelect` events ([#3735](https://github.com/nuxt/ui/issues/3735))

[`94b6e`](https://github.com/nuxt/ui/commit/94b6e520f5ccf011204e953421fcc5b44b637e51) — fix: empty search results

[`b9983`](https://github.com/nuxt/ui/commit/b9983549a4b743724ea3ef99cc4a243f5ca41e53) — fix: improve generic types ([#3331](https://github.com/nuxt/ui/issues/3331))

[`5dec0`](https://github.com/nuxt/ui/commit/5dec0e16e28549b8833aaab17a87fada63d6598c) — feat: handle events in `content` prop[Select](https://ui.nuxt.com/docs/components/select)

[

A select element to choose from a list of options.

](https://ui.nuxt.com/docs/components/select)[

Slider

An input to select a numeric value within a range.

](https://ui.nuxt.com/docs/components/slider)