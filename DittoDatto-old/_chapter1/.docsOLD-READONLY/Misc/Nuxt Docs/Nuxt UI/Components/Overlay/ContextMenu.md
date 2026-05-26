---
title: "Vue ContextMenu Component"
source: "https://ui.nuxt.com/docs/components/context-menu"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A menu to display actions when right-clicking on an element."
tags:
---
## Usage

Use anything you like in the default slot of the ContextMenu, and right-click on it to display the menu.

Right click here

```
<script setup lang="ts">

import type { ContextMenuItem } from '@nuxt/ui'

const items = ref<ContextMenuItem[][]>([

  [

    {

      label: 'Appearance',

      children: [

        {

          label: 'System',

          icon: 'i-lucide-monitor'

        },

        {

          label: 'Light',

          icon: 'i-lucide-sun'

        },

        {

          label: 'Dark',

          icon: 'i-lucide-moon'

        }

      ]

    }

  ],

  [

    {

      label: 'Show Sidebar',

      kbds: ['meta', 's']

    },

    {

      label: 'Show Toolbar',

      kbds: ['shift', 'meta', 'd']

    },

    {

      label: 'Collapse Pinned Tabs',

      disabled: true

    }

  ],

  [

    {

      label: 'Refresh the Page'

    },

    {

      label: 'Clear Cookies and Refresh'

    },

    {

      label: 'Clear Cache and Refresh'

    },

    {

      type: 'separator'

    },

    {

      label: 'Developer',

      children: [

        [

          {

            label: 'View Source',

            kbds: ['meta', 'shift', 'u']

          },

          {

            label: 'Developer Tools',

            kbds: ['option', 'meta', 'i']

          },

          {

            label: 'Inspect Elements',

            kbds: ['option', 'meta', 'c']

          }

        ],

        [

          {

            label: 'JavaScript Console',

            kbds: ['option', 'meta', 'j']

          }

        ]

      ]

    }

  ]

])

</script>

<template>

  <UContextMenu :items="items">

    <div

      class="flex items-center justify-center rounded-md border border-dashed border-accented text-sm aspect-video w-72"

    >

      Right click here

    </div>

  </UContextMenu>

</template>
```

### Items

Use the `items` prop as an array of objects with the following properties:

- `label?: string`
- `icon?: string`
- `avatar?: AvatarProps`
- `kbds?: string[] | KbdProps[]`
- [`type?: "link" | "label" | "separator" | "checkbox"`](https://ui.nuxt.com/docs/components/#with-checkbox-items)
- [`color?: "error" | "primary" | "secondary" | "success" | "info" | "warning" | "neutral"`](https://ui.nuxt.com/docs/components/#with-color-items)
- [`checked?: boolean`](https://ui.nuxt.com/docs/components/#with-checkbox-items)
- `disabled?: boolean`
- [`slot?: string`](https://ui.nuxt.com/docs/components/#with-custom-slot)
- `onSelect?: (e: Event) => void`
- [`onUpdateChecked?: (checked: boolean) => void`](https://ui.nuxt.com/docs/components/#with-checkbox-items)
- `children?: ContextMenuItem[] | ContextMenuItem[][]`
- `class?: any`
- `ui?: { item?: ClassNameValue, label?: ClassNameValue, separator?: ClassNameValue, itemLeadingIcon?: ClassNameValue, itemLeadingAvatarSize?: ClassNameValue, itemLeadingAvatar?: ClassNameValue, itemLabel?: ClassNameValue, itemLabelExternalIcon?: ClassNameValue, itemTrailing?: ClassNameValue, itemTrailingIcon?: ClassNameValue, itemTrailingKbds?: ClassNameValue, itemTrailingKbdsSize?: ClassNameValue }`

You can pass any property from the [Link](https://ui.nuxt.com/docs/components/link#props) component such as `to`, `target`, etc.

Right click here

```
<script setup lang="ts">

import type { ContextMenuItem } from '@nuxt/ui'

const items = ref<ContextMenuItem[][]>([

  [

    {

      label: 'Appearance',

      children: [

        {

          label: 'System',

          icon: 'i-lucide-monitor'

        },

        {

          label: 'Light',

          icon: 'i-lucide-sun'

        },

        {

          label: 'Dark',

          icon: 'i-lucide-moon'

        }

      ]

    }

  ],

  [

    {

      label: 'Show Sidebar',

      kbds: ['meta', 's']

    },

    {

      label: 'Show Toolbar',

      kbds: ['shift', 'meta', 'd']

    },

    {

      label: 'Collapse Pinned Tabs',

      disabled: true

    }

  ],

  [

    {

      label: 'Refresh the Page'

    },

    {

      label: 'Clear Cookies and Refresh'

    },

    {

      label: 'Clear Cache and Refresh'

    },

    {

      type: 'separator'

    },

    {

      label: 'Developer',

      children: [

        [

          {

            label: 'View Source',

            kbds: ['meta', 'shift', 'u']

          },

          {

            label: 'Developer Tools',

            kbds: ['option', 'meta', 'i']

          },

          {

            label: 'Inspect Elements',

            kbds: ['option', 'meta', 'c']

          }

        ],

        [

          {

            label: 'JavaScript Console',

            kbds: ['option', 'meta', 'j']

          }

        ]

      ]

    }

  ]

])

</script>

<template>

  <UContextMenu

    :items="items"

    :ui="{

      content: 'w-48'

    }"

  >

    <div

      class="flex items-center justify-center rounded-md border border-dashed border-accented text-sm aspect-video w-72"

    >

      Right click here

    </div>

  </UContextMenu>

</template>
```

You can also pass an array of arrays to the `items` prop to create separated groups of items.

Each item can take a `children` array of objects with the same properties as the `items` prop to create a nested menu which can be controlled using the `open`, `defaultOpen` and `content` properties.

### Size

Use the `size` prop to change the size of the ContextMenu.

Right click here

### Modal

Use the `modal` prop to control whether the ContextMenu blocks interaction with outside content. Defaults to `true`.

Right click here

### Disabled

Use the `disabled` prop to disable the ContextMenu.

Right click here

## Examples

### With checkbox items

You can use the `type` property with `checkbox` and use the `checked` / `onUpdateChecked` properties to control the checked state of the item.

Right click here

```
<script setup lang="ts">

import type { ContextMenuItem } from '@nuxt/ui'

const showSidebar = ref(true)

const showToolbar = ref(false)

const items = computed<ContextMenuItem[]>(() => [{

  label: 'View',

  type: 'label' as const

}, {

  type: 'separator' as const

}, {

  label: 'Show Sidebar',

  type: 'checkbox' as const,

  checked: showSidebar.value,

  onUpdateChecked(checked: boolean) {

    showSidebar.value = checked

  },

  onSelect(e: Event) {

    e.preventDefault()

  }

}, {

  label: 'Show Toolbar',

  type: 'checkbox' as const,

  checked: showToolbar.value,

  onUpdateChecked(checked: boolean) {

    showToolbar.value = checked

  }

}, {

  label: 'Collapse Pinned Tabs',

  type: 'checkbox' as const,

  disabled: true

}])

</script>

<template>

  <UContextMenu :items="items" :ui="{ content: 'w-48' }">

    <div class="flex items-center justify-center rounded-md border border-dashed border-accented text-sm aspect-video w-72">

      Right click here

    </div>

  </UContextMenu>

</template>
```

To ensure reactivity for the `checked` state of items, it's recommended to wrap your `items` array inside a `computed`.

### With color items

You can use the `color` property to highlight certain items with a color.

Right click here

### With custom slot

Use the `slot` property to customize a specific item.

You will have access to the following slots:

- `#{{ item.slot }}`
- `#{{ item.slot }}-leading`
- `#{{ item.slot }}-label`
- `#{{ item.slot }}-trailing`

Right click here

You can also use the `#item`, `#item-leading`, `#item-label` and `#item-trailing` slots to customize all items.

### Extract shortcuts

Use the [extractShortcuts](https://ui.nuxt.com/docs/composables/extract-shortcuts) utility to automatically define shortcuts from menu items with a `kbds` property. It recursively extracts shortcuts and returns an object compatible with [defineShortcuts](https://ui.nuxt.com/docs/composables/define-shortcuts).

```
<script setup lang="ts">

const items = [

  [{

    label: 'Show Sidebar',

    kbds: ['meta', 'S'],

    onSelect() {

      console.log('Show Sidebar clicked')

    }

  }, {

    label: 'Show Toolbar',

    kbds: ['shift', 'meta', 'D'],

    onSelect() {

      console.log('Show Toolbar clicked')

    }

  }, {

    label: 'Collapse Pinned Tabs',

    disabled: true

  }], [{

    label: 'Refresh the Page'

  }, {

    label: 'Clear Cookies and Refresh'

  }, {

    label: 'Clear Cache and Refresh'

  }, {

    type: 'separator' as const

  }, {

    label: 'Developer',

    children: [[{

      label: 'View Source',

      kbds: ['option', 'meta', 'U'],

      onSelect() {

        console.log('View Source clicked')

      }

    }, {

      label: 'Developer Tools',

      kbds: ['option', 'meta', 'I'],

      onSelect() {

        console.log('Developer Tools clicked')

      }

    }], [{

      label: 'Inspect Elements',

      kbds: ['option', 'meta', 'C'],

      onSelect() {

        console.log('Inspect Elements clicked')

      }

    }], [{

      label: 'JavaScript Console',

      kbds: ['option', 'meta', 'J'],

      onSelect() {

        console.log('JavaScript Console clicked')

      }

    }]]

  }]

]

defineShortcuts(extractShortcuts(items))

</script>
```

In this example, Ctrl S, ⇧ Ctrl D, ⌥ Ctrl U, ⌥ Ctrl I, ⌥ Ctrl C and ⌥ Ctrl J would trigger the `select` function of the corresponding item.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `size` | `'md'` | ` "sm" \| "md" \| "xs" \| "lg" \| "xl"` |
| `items` |  | ` T` |
| `checkedIcon` | `appConfig.ui.icons.check` | `any`  The icon displayed when an item is checked. |
| `loadingIcon` | `appConfig.ui.icons.loading` | `any`  The icon displayed when an item is loading. |
| `externalIcon` | `true` | `any`  The icon displayed when the item is an external link. Set to `false` to hide the external icon. |
| `content` |  | ` ContextMenuContentProps & Partial<EmitsToProps<MenuContentEmits>>` |
| `portal` | `true` | ` string \| false \| true \| HTMLElement` |
| `labelKey` | `'label'` | ` keyof Extract<NestedItem<T>, object> \| DotPathKeys<Extract<NestedItem<T>, object>>`  The key used to get the label from the item. |
| `descriptionKey` | `'description'` | ` keyof Extract<NestedItem<T>, object> \| DotPathKeys<Extract<NestedItem<T>, object>>`  The key used to get the description from the item. |
| `disabled` |  | `boolean` |
| `modal` | `true` | `boolean` |
| `pressOpenDelay` | `700` | ` number` |
| `ui` |  | ` { content?: ClassNameValue; viewport?: ClassNameValue; group?: ClassNameValue; label?: ClassNameValue; separator?: ClassNameValue; item?: ClassNameValue; itemLeadingIcon?: ClassNameValue; itemLeadingAvatar?: ClassNameValue; itemLeadingAvatarSize?: ClassNameValue; itemTrailing?: ClassNameValue; itemTrailingIcon?: ClassNameValue; itemTrailingKbds?: ClassNameValue; itemTrailingKbdsSize?: ClassNameValue; itemWrapper?: ClassNameValue; itemLabel?: ClassNameValue; itemDescription?: ClassNameValue; itemLabelExternalIcon?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{}` |
| `item` | `{ item: NestedItem<T>; active?: boolean \| undefined; index: number; ui: object; }` |
| `item-leading` | `{ item: NestedItem<T>; active?: boolean \| undefined; index: number; ui: object; }` |
| `item-label` | `{ item: NestedItem<T>; active?: boolean \| undefined; index: number; }` |
| `item-description` | `{ item: NestedItem<T>; active?: boolean \| undefined; index: number; }` |
| `item-trailing` | `{ item: NestedItem<T>; active?: boolean \| undefined; index: number; ui: object; }` |
| `content-top` | `{ sub: boolean; }` |
| `content-bottom` | `{ sub: boolean; }` |

### Emits

| Event | Type |
| --- | --- |
| `update:open` | `[payload: boolean]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    contextMenu: {

      slots: {

        content: 'min-w-32 bg-default shadow-lg rounded-md ring ring-default overflow-hidden data-[state=open]:animate-[scale-in_100ms_ease-out] data-[state=closed]:animate-[scale-out_100ms_ease-in] origin-(--reka-context-menu-content-transform-origin) flex flex-col',

        viewport: 'relative divide-y divide-default scroll-py-1 overflow-y-auto flex-1',

        group: 'p-1 isolate',

        label: 'w-full flex items-center font-semibold text-highlighted',

        separator: '-mx-1 my-1 h-px bg-border',

        item: 'group relative w-full flex items-start select-none outline-none before:absolute before:z-[-1] before:inset-px before:rounded-md data-disabled:cursor-not-allowed data-disabled:opacity-75',

        itemLeadingIcon: 'shrink-0',

        itemLeadingAvatar: 'shrink-0',

        itemLeadingAvatarSize: '',

        itemTrailing: 'ms-auto inline-flex gap-1.5 items-center',

        itemTrailingIcon: 'shrink-0',

        itemTrailingKbds: 'hidden lg:inline-flex items-center shrink-0',

        itemTrailingKbdsSize: '',

        itemWrapper: 'flex-1 flex flex-col text-start min-w-0',

        itemLabel: 'truncate',

        itemDescription: 'truncate text-muted',

        itemLabelExternalIcon: 'inline-block size-3 align-top text-dimmed'

      },

      variants: {

        color: {

          primary: '',

          secondary: '',

          success: '',

          info: '',

          warning: '',

          error: '',

          neutral: ''

        },

        active: {

          true: {

            item: 'text-highlighted before:bg-elevated',

            itemLeadingIcon: 'text-default'

          },

          false: {

            item: [

              'text-default data-highlighted:text-highlighted data-[state=open]:text-highlighted data-highlighted:before:bg-elevated/50 data-[state=open]:before:bg-elevated/50',

              'transition-colors before:transition-colors'

            ],

            itemLeadingIcon: [

              'text-dimmed group-data-highlighted:text-default group-data-[state=open]:text-default',

              'transition-colors'

            ]

          }

        },

        loading: {

          true: {

            itemLeadingIcon: 'animate-spin'

          }

        },

        size: {

          xs: {

            label: 'p-1 text-xs gap-1',

            item: 'p-1 text-xs gap-1',

            itemLeadingIcon: 'size-4',

            itemLeadingAvatarSize: '3xs',

            itemTrailingIcon: 'size-4',

            itemTrailingKbds: 'gap-0.5',

            itemTrailingKbdsSize: 'sm'

          },

          sm: {

            label: 'p-1.5 text-xs gap-1.5',

            item: 'p-1.5 text-xs gap-1.5',

            itemLeadingIcon: 'size-4',

            itemLeadingAvatarSize: '3xs',

            itemTrailingIcon: 'size-4',

            itemTrailingKbds: 'gap-0.5',

            itemTrailingKbdsSize: 'sm'

          },

          md: {

            label: 'p-1.5 text-sm gap-1.5',

            item: 'p-1.5 text-sm gap-1.5',

            itemLeadingIcon: 'size-5',

            itemLeadingAvatarSize: '2xs',

            itemTrailingIcon: 'size-5',

            itemTrailingKbds: 'gap-0.5',

            itemTrailingKbdsSize: 'md'

          },

          lg: {

            label: 'p-2 text-sm gap-2',

            item: 'p-2 text-sm gap-2',

            itemLeadingIcon: 'size-5',

            itemLeadingAvatarSize: '2xs',

            itemTrailingIcon: 'size-5',

            itemTrailingKbds: 'gap-1',

            itemTrailingKbdsSize: 'md'

          },

          xl: {

            label: 'p-2 text-base gap-2',

            item: 'p-2 text-base gap-2',

            itemLeadingIcon: 'size-6',

            itemLeadingAvatarSize: 'xs',

            itemTrailingIcon: 'size-6',

            itemTrailingKbds: 'gap-1',

            itemTrailingKbdsSize: 'lg'

          }

        }

      },

      compoundVariants: [

        {

          color: 'primary',

          active: false,

          class: {

            item: 'text-primary data-highlighted:text-primary data-highlighted:before:bg-primary/10 data-[state=open]:before:bg-primary/10',

            itemLeadingIcon: 'text-primary/75 group-data-highlighted:text-primary group-data-[state=open]:text-primary'

          }

        },

        {

          color: 'primary',

          active: true,

          class: {

            item: 'text-primary before:bg-primary/10',

            itemLeadingIcon: 'text-primary'

          }

        }

      ],

      defaultVariants: {

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

        contextMenu: {

          slots: {

            content: 'min-w-32 bg-default shadow-lg rounded-md ring ring-default overflow-hidden data-[state=open]:animate-[scale-in_100ms_ease-out] data-[state=closed]:animate-[scale-out_100ms_ease-in] origin-(--reka-context-menu-content-transform-origin) flex flex-col',

            viewport: 'relative divide-y divide-default scroll-py-1 overflow-y-auto flex-1',

            group: 'p-1 isolate',

            label: 'w-full flex items-center font-semibold text-highlighted',

            separator: '-mx-1 my-1 h-px bg-border',

            item: 'group relative w-full flex items-start select-none outline-none before:absolute before:z-[-1] before:inset-px before:rounded-md data-disabled:cursor-not-allowed data-disabled:opacity-75',

            itemLeadingIcon: 'shrink-0',

            itemLeadingAvatar: 'shrink-0',

            itemLeadingAvatarSize: '',

            itemTrailing: 'ms-auto inline-flex gap-1.5 items-center',

            itemTrailingIcon: 'shrink-0',

            itemTrailingKbds: 'hidden lg:inline-flex items-center shrink-0',

            itemTrailingKbdsSize: '',

            itemWrapper: 'flex-1 flex flex-col text-start min-w-0',

            itemLabel: 'truncate',

            itemDescription: 'truncate text-muted',

            itemLabelExternalIcon: 'inline-block size-3 align-top text-dimmed'

          },

          variants: {

            color: {

              primary: '',

              secondary: '',

              success: '',

              info: '',

              warning: '',

              error: '',

              neutral: ''

            },

            active: {

              true: {

                item: 'text-highlighted before:bg-elevated',

                itemLeadingIcon: 'text-default'

              },

              false: {

                item: [

                  'text-default data-highlighted:text-highlighted data-[state=open]:text-highlighted data-highlighted:before:bg-elevated/50 data-[state=open]:before:bg-elevated/50',

                  'transition-colors before:transition-colors'

                ],

                itemLeadingIcon: [

                  'text-dimmed group-data-highlighted:text-default group-data-[state=open]:text-default',

                  'transition-colors'

                ]

              }

            },

            loading: {

              true: {

                itemLeadingIcon: 'animate-spin'

              }

            },

            size: {

              xs: {

                label: 'p-1 text-xs gap-1',

                item: 'p-1 text-xs gap-1',

                itemLeadingIcon: 'size-4',

                itemLeadingAvatarSize: '3xs',

                itemTrailingIcon: 'size-4',

                itemTrailingKbds: 'gap-0.5',

                itemTrailingKbdsSize: 'sm'

              },

              sm: {

                label: 'p-1.5 text-xs gap-1.5',

                item: 'p-1.5 text-xs gap-1.5',

                itemLeadingIcon: 'size-4',

                itemLeadingAvatarSize: '3xs',

                itemTrailingIcon: 'size-4',

                itemTrailingKbds: 'gap-0.5',

                itemTrailingKbdsSize: 'sm'

              },

              md: {

                label: 'p-1.5 text-sm gap-1.5',

                item: 'p-1.5 text-sm gap-1.5',

                itemLeadingIcon: 'size-5',

                itemLeadingAvatarSize: '2xs',

                itemTrailingIcon: 'size-5',

                itemTrailingKbds: 'gap-0.5',

                itemTrailingKbdsSize: 'md'

              },

              lg: {

                label: 'p-2 text-sm gap-2',

                item: 'p-2 text-sm gap-2',

                itemLeadingIcon: 'size-5',

                itemLeadingAvatarSize: '2xs',

                itemTrailingIcon: 'size-5',

                itemTrailingKbds: 'gap-1',

                itemTrailingKbdsSize: 'md'

              },

              xl: {

                label: 'p-2 text-base gap-2',

                item: 'p-2 text-base gap-2',

                itemLeadingIcon: 'size-6',

                itemLeadingAvatarSize: 'xs',

                itemTrailingIcon: 'size-6',

                itemTrailingKbds: 'gap-1',

                itemTrailingKbdsSize: 'lg'

              }

            }

          },

          compoundVariants: [

            {

              color: 'primary',

              active: false,

              class: {

                item: 'text-primary data-highlighted:text-primary data-highlighted:before:bg-primary/10 data-[state=open]:before:bg-primary/10',

                itemLeadingIcon: 'text-primary/75 group-data-highlighted:text-primary group-data-[state=open]:text-primary'

              }

            },

            {

              color: 'primary',

              active: true,

              class: {

                item: 'text-primary before:bg-primary/10',

                itemLeadingIcon: 'text-primary'

              }

            }

          ],

          defaultVariants: {

            size: 'md'

          }

        }

      }

    })

  ]

})
```

Some colors in `compoundVariants` are omitted for readability. Check out the source code on GitHub.

## Changelog

[`b09e6`](https://github.com/nuxt/ui/commit/b09e6bc339e1f116e622f67a0e0e250806b80547) — feat: expose `sub` prop on content slots ([#5609](https://github.com/nuxt/ui/issues/5609))

[`9d136`](https://github.com/nuxt/ui/commit/9d13653156f0644d7859ad499c0a77ae341207b4) — fix: ensure items truncate work

[`ab503`](https://github.com/nuxt/ui/commit/ab5032d8f28656f68420cdd9cd604748bf190309) — fix: allow item content class override

[`70cf0`](https://github.com/nuxt/ui/commit/70cf05f5103776eadbee5e5bcae7d2bb30543d4a) — feat: handle `description` in items ([#5193](https://github.com/nuxt/ui/issues/5193))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`84f87`](https://github.com/nuxt/ui/commit/84f87a5953b508d74662dd3e81715ee86e75d71f) — feat: add global event handlers and checkbox example ([#5195](https://github.com/nuxt/ui/issues/5195))

[`3173b`](https://github.com/nuxt/ui/commit/3173bee38ce9e518076848999f14374600069d35) — fix: proxySlots reactivity ([#4969](https://github.com/nuxt/ui/issues/4969))

[`11a03`](https://github.com/nuxt/ui/commit/11a03201ed8454f37e911db4a14b00f74104932a) — fix: dot notation type support for `labelKey` and `valueKey` ([#4933](https://github.com/nuxt/ui/issues/4933))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`dcf34`](https://github.com/nuxt/ui/commit/dcf34a7ac236b96b1302ec2eae155b8f2d3784ef) — fix: wrap groups in a viewport

[`b9adc`](https://github.com/nuxt/ui/commit/b9adc83e787db02507e6e7bb1aabc684eccc197b) — feat: add `ui` field in items ([#4060](https://github.com/nuxt/ui/issues/4060))

[`1a463`](https://github.com/nuxt/ui/commit/1a463946681e152aa18372118d0fef4a7d8055a5) — feat: add new `content-top` and `content-bottom` slots ([#3886](https://github.com/nuxt/ui/issues/3886))

[`29fa4`](https://github.com/nuxt/ui/commit/29fa46276d6bf69b5b87880c476c6f778c2820bf) — feat: add global `portal` prop ([#3688](https://github.com/nuxt/ui/issues/3688))

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`01d8d`](https://github.com/nuxt/ui/commit/01d8dc72adb0b32ad68bb4a98bf24b17f435a89c) — fix: respect `transform-origin` in popper content ([#3919](https://github.com/nuxt/ui/issues/3919))

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`b9983`](https://github.com/nuxt/ui/commit/b9983549a4b743724ea3ef99cc4a243f5ca41e53) — fix: improve generic types ([#3331](https://github.com/nuxt/ui/issues/3331))

[`5dec0`](https://github.com/nuxt/ui/commit/5dec0e16e28549b8833aaab17a87fada63d6598c) — feat: handle events in `content` prop

[`764c4`](https://github.com/nuxt/ui/commit/764c41a0c60dd1c12d39a86af9f5f11b9e6cdc8c) — fix: remove `any` from `proxySlots` ([#3623](https://github.com/nuxt/ui/issues/3623))

[`ef861`](https://github.com/nuxt/ui/commit/ef86108f14da23fa292afe016517eac95c34bf76) — chore: add eol in script tag to fix syntax highlight[Tabs](https://ui.nuxt.com/docs/components/tabs)

[

A set of tab panels that are displayed one at a time.

](https://ui.nuxt.com/docs/components/tabs)[

Drawer

A drawer that smoothly slides in & out of the screen.

](https://ui.nuxt.com/docs/components/drawer)