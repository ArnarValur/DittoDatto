---
title: "Vue CommandPalette Component"
source: "https://ui.nuxt.com/docs/components/command-palette"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A command palette with full-text search powered by Fuse.js for efficient fuzzy matching."
tags:
---
## Usage

Use the `v-model` directive to control the value of the CommandPalette or the `default-value` prop to set the initial value when you do not need to control its state.

```
<script setup lang="ts">

import type { CommandPaletteGroup } from '@nuxt/ui'

const groups = ref<CommandPaletteGroup[]>([

  {

    id: 'users',

    label: 'Users',

    items: [

      {

        label: 'Benjamin Canac',

        suffix: 'benjamincanac',

        avatar: {

          src: 'https://github.com/benjamincanac.png'

        }

      },

      {

        label: 'Romain Hamel',

        suffix: 'romhml',

        avatar: {

          src: 'https://github.com/romhml.png'

        }

      },

      {

        label: 'Sébastien Chopin',

        suffix: 'atinux',

        avatar: {

          src: 'https://github.com/atinux.png'

        }

      },

      {

        label: 'Hugo Richard',

        suffix: 'HugoRCD',

        avatar: {

          src: 'https://github.com/HugoRCD.png'

        }

      },

      {

        label: 'Sandro Circi',

        suffix: 'sandros94',

        avatar: {

          src: 'https://github.com/sandros94.png'

        }

      },

      {

        label: 'Daniel Roe',

        suffix: 'danielroe',

        avatar: {

          src: 'https://github.com/danielroe.png'

        }

      },

      {

        label: 'Jakub Michálek',

        suffix: 'J-Michalek',

        avatar: {

          src: 'https://github.com/J-Michalek.png'

        }

      },

      {

        label: 'Eugen Istoc',

        suffix: 'genu',

        avatar: {

          src: 'https://github.com/genu.png'

        }

      }

    ]

  }

])

const value = ref({})

</script>

<template>

  <UCommandPalette v-model="value" :groups="groups" class="flex-1 h-80" />

</template>
```

You can also use the `@update:model-value` event to listen to the selected item(s).

### Groups

The CommandPalette component filters groups and ranks matching commands by relevance as users type. It provides dynamic, instant search results for efficient command discovery. Use the `groups` prop as an array of objects with the following properties:

- `id: string`
- `label?: string`
- `slot?: string`
- `items?: CommandPaletteItem[]`
- [`ignoreFilter?: boolean`](https://ui.nuxt.com/docs/components/#with-ignore-filter)
- [`postFilter?: (searchTerm: string, items: T[]) => T[]`](https://ui.nuxt.com/docs/components/#with-post-filtered-items)
- `highlightedIcon?: string`

Each group contains an `items` array of objects that define the commands. Each item can have the following properties:

- `prefix?: string`
- `label?: string`
- `suffix?: string`
- `icon?: string`
- `avatar?: AvatarProps`
- `chip?: ChipProps`
- `kbds?: string[] | KbdProps[]`
- `active?: boolean`
- `loading?: boolean`
- `disabled?: boolean`
- [`slot?: string`](https://ui.nuxt.com/docs/components/#with-custom-slot)
- `placeholder?: string`
- `children?: CommandPaletteItem[]`
- `onSelect?: (e: Event) => void`
- `class?: any`
- `ui?: { item?: ClassNameValue, itemLeadingIcon?: ClassNameValue, itemLeadingAvatarSize?: ClassNameValue, itemLeadingAvatar?: ClassNameValue, itemLeadingChipSize?: ClassNameValue, itemLeadingChip?: ClassNameValue, itemLabel?: ClassNameValue, itemLabelPrefix?: ClassNameValue, itemLabelBase?: ClassNameValue, itemLabelSuffix?: ClassNameValue, itemTrailing?: ClassNameValue, itemTrailingKbds?: ClassNameValue, itemTrailingKbdsSize?: ClassNameValue, itemTrailingHighlightedIcon?: ClassNameValue, itemTrailingIcon?: ClassNameValue }`

You can pass any property from the [Link](https://ui.nuxt.com/docs/components/link#props) component such as `to`, `target`, etc.

```
<script setup lang="ts">

import type { CommandPaletteGroup } from '@nuxt/ui'

const groups = ref<CommandPaletteGroup[]>([

  {

    id: 'users',

    label: 'Users',

    items: [

      {

        label: 'Benjamin Canac',

        suffix: 'benjamincanac',

        avatar: {

          src: 'https://github.com/benjamincanac.png'

        }

      },

      {

        label: 'Romain Hamel',

        suffix: 'romhml',

        avatar: {

          src: 'https://github.com/romhml.png'

        }

      },

      {

        label: 'Sébastien Chopin',

        suffix: 'atinux',

        avatar: {

          src: 'https://github.com/atinux.png'

        }

      },

      {

        label: 'Hugo Richard',

        suffix: 'HugoRCD',

        avatar: {

          src: 'https://github.com/HugoRCD.png'

        }

      },

      {

        label: 'Sandro Circi',

        suffix: 'sandros94',

        avatar: {

          src: 'https://github.com/sandros94.png'

        }

      },

      {

        label: 'Daniel Roe',

        suffix: 'danielroe',

        avatar: {

          src: 'https://github.com/danielroe.png'

        }

      },

      {

        label: 'Jakub Michálek',

        suffix: 'J-Michalek',

        avatar: {

          src: 'https://github.com/J-Michalek.png'

        }

      },

      {

        label: 'Eugen Istoc',

        suffix: 'genu',

        avatar: {

          src: 'https://github.com/genu.png'

        }

      }

    ]

  }

])

const value = ref({})

</script>

<template>

  <UCommandPalette v-model="value" :groups="groups" class="flex-1" />

</template>
```

Each item can take a `children` array of objects with the following properties to create submenus:

### Multiple

Use the `multiple` prop to allow multiple selections.

```
<script setup lang="ts">

import type { CommandPaletteGroup } from '@nuxt/ui'

const groups = ref<CommandPaletteGroup[]>([

  {

    id: 'users',

    label: 'Users',

    items: [

      {

        label: 'Benjamin Canac',

        suffix: 'benjamincanac',

        avatar: {

          src: 'https://github.com/benjamincanac.png'

        }

      },

      {

        label: 'Romain Hamel',

        suffix: 'romhml',

        avatar: {

          src: 'https://github.com/romhml.png'

        }

      },

      {

        label: 'Sébastien Chopin',

        suffix: 'atinux',

        avatar: {

          src: 'https://github.com/atinux.png'

        }

      },

      {

        label: 'Hugo Richard',

        suffix: 'HugoRCD',

        avatar: {

          src: 'https://github.com/HugoRCD.png'

        }

      },

      {

        label: 'Sandro Circi',

        suffix: 'sandros94',

        avatar: {

          src: 'https://github.com/sandros94.png'

        }

      },

      {

        label: 'Daniel Roe',

        suffix: 'danielroe',

        avatar: {

          src: 'https://github.com/danielroe.png'

        }

      },

      {

        label: 'Jakub Michálek',

        suffix: 'J-Michalek',

        avatar: {

          src: 'https://github.com/J-Michalek.png'

        }

      },

      {

        label: 'Eugen Istoc',

        suffix: 'genu',

        avatar: {

          src: 'https://github.com/genu.png'

        }

      }

    ]

  }

])

const value = ref([])

</script>

<template>

  <UCommandPalette multiple v-model="value" :groups="groups" class="flex-1" />

</template>
```

### Placeholder

Use the `placeholder` prop to change the placeholder text.

```
<script setup lang="ts">

import type { CommandPaletteGroup } from '@nuxt/ui'

const groups = ref<CommandPaletteGroup[]>([

  {

    id: 'apps',

    items: [

      {

        label: 'Calendar',

        icon: 'i-lucide-calendar'

      },

      {

        label: 'Music',

        icon: 'i-lucide-music'

      },

      {

        label: 'Maps',

        icon: 'i-lucide-map'

      }

    ]

  }

])

</script>

<template>

  <UCommandPalette placeholder="Search an app..." :groups="groups" class="flex-1" />

</template>
```

### Size 4.4+

Use the `size` prop to change the size of the CommandPalette.

```
<script setup lang="ts">

import type { CommandPaletteGroup } from '@nuxt/ui'

const groups = ref<CommandPaletteGroup[]>([

  {

    id: 'apps',

    items: [

      {

        label: 'Calendar',

        icon: 'i-lucide-calendar'

      },

      {

        label: 'Music',

        icon: 'i-lucide-music'

      },

      {

        label: 'Maps',

        icon: 'i-lucide-map'

      }

    ]

  }

])

</script>

<template>

  <UCommandPalette size="xl" :groups="groups" class="flex-1" />

</template>
```

### Icon

Use the `icon` prop to customize the input [Icon](https://ui.nuxt.com/docs/components/icon). Defaults to `i-lucide-search`.

```
<script setup lang="ts">

import type { CommandPaletteGroup } from '@nuxt/ui'

const groups = ref<CommandPaletteGroup[]>([

  {

    id: 'apps',

    items: [

      {

        label: 'Calendar',

        icon: 'i-lucide-calendar'

      },

      {

        label: 'Music',

        icon: 'i-lucide-music'

      },

      {

        label: 'Maps',

        icon: 'i-lucide-map'

      }

    ]

  }

])

</script>

<template>

  <UCommandPalette icon="i-lucide-box" :groups="groups" class="flex-1" />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.search` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.search` key.

### Selected Icon

Use the `selected-icon` prop to customize the selected item [Icon](https://ui.nuxt.com/docs/components/icon). Defaults to `i-lucide-check`.

```
<script setup lang="ts">

import type { CommandPaletteGroup } from '@nuxt/ui'

const groups = ref<CommandPaletteGroup[]>([

  {

    id: 'users',

    label: 'Users',

    items: [

      {

        label: 'Benjamin Canac',

        suffix: 'benjamincanac',

        avatar: {

          src: 'https://github.com/benjamincanac.png'

        }

      },

      {

        label: 'Romain Hamel',

        suffix: 'romhml',

        avatar: {

          src: 'https://github.com/romhml.png'

        }

      },

      {

        label: 'Sébastien Chopin',

        suffix: 'atinux',

        avatar: {

          src: 'https://github.com/atinux.png'

        }

      },

      {

        label: 'Hugo Richard',

        suffix: 'HugoRCD',

        avatar: {

          src: 'https://github.com/HugoRCD.png'

        }

      },

      {

        label: 'Sandro Circi',

        suffix: 'sandros94',

        avatar: {

          src: 'https://github.com/sandros94.png'

        }

      },

      {

        label: 'Daniel Roe',

        suffix: 'danielroe',

        avatar: {

          src: 'https://github.com/danielroe.png'

        }

      },

      {

        label: 'Jakub Michálek',

        suffix: 'J-Michalek',

        avatar: {

          src: 'https://github.com/J-Michalek.png'

        }

      },

      {

        label: 'Eugen Istoc',

        suffix: 'genu',

        avatar: {

          src: 'https://github.com/genu.png'

        }

      }

    ]

  }

])

const value = ref([

  {

    label: 'Benjamin Canac',

    suffix: 'benjamincanac',

    avatar: {

      src: 'https://github.com/benjamincanac.png'

    }

  }

])

</script>

<template>

  <UCommandPalette multiple v-model="value" selected-icon="i-lucide-circle-check" :groups="groups" class="flex-1" />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.check` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.check` key.

### Trailing Icon

Use the `trailing-icon` prop to customize the trailing [Icon](https://ui.nuxt.com/docs/components/icon) when an item has children. Defaults to `i-lucide-chevron-right`.

You can customize this icon globally in your `app.config.ts` under `ui.icons.chevronRight` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.chevronRight` key.

Use the `loading` prop to show a loading icon on the CommandPalette.

```
<script setup lang="ts">

import type { CommandPaletteGroup } from '@nuxt/ui'

const groups = ref<CommandPaletteGroup[]>([

  {

    id: 'apps',

    items: [

      {

        label: 'Calendar',

        icon: 'i-lucide-calendar'

      },

      {

        label: 'Music',

        icon: 'i-lucide-music'

      },

      {

        label: 'Maps',

        icon: 'i-lucide-map'

      }

    ]

  }

])

</script>

<template>

  <UCommandPalette loading :groups="groups" class="flex-1" />

</template>
```

Use the `loading-icon` prop to customize the loading icon. Defaults to `i-lucide-loader-circle`.

```
<script setup lang="ts">

import type { CommandPaletteGroup } from '@nuxt/ui'

const groups = ref<CommandPaletteGroup[]>([

  {

    id: 'apps',

    items: [

      {

        label: 'Calendar',

        icon: 'i-lucide-calendar'

      },

      {

        label: 'Music',

        icon: 'i-lucide-music'

      },

      {

        label: 'Maps',

        icon: 'i-lucide-map'

      }

    ]

  }

])

</script>

<template>

  <UCommandPalette loading loading-icon="i-lucide-loader" :groups="groups" class="flex-1" />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.loading` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.loading` key.

### Close

Use the `close` prop to display a [Button](https://ui.nuxt.com/docs/components/button) to dismiss the CommandPalette.

An `update:open` event will be emitted when the close button is clicked.

```
<script setup lang="ts">

import type { CommandPaletteGroup } from '@nuxt/ui'

const groups = ref<CommandPaletteGroup[]>([

  {

    id: 'apps',

    items: [

      {

        label: 'Calendar',

        icon: 'i-lucide-calendar'

      },

      {

        label: 'Music',

        icon: 'i-lucide-music'

      },

      {

        label: 'Maps',

        icon: 'i-lucide-map'

      }

    ]

  }

])

</script>

<template>

  <UCommandPalette close :groups="groups" class="flex-1" />

</template>
```

You can pass any property from the [Button](https://ui.nuxt.com/docs/components/button) component to customize it.

```
<script setup lang="ts">

import type { CommandPaletteGroup } from '@nuxt/ui'

const groups = ref<CommandPaletteGroup[]>([

  {

    id: 'apps',

    items: [

      {

        label: 'Calendar',

        icon: 'i-lucide-calendar'

      },

      {

        label: 'Music',

        icon: 'i-lucide-music'

      },

      {

        label: 'Maps',

        icon: 'i-lucide-map'

      }

    ]

  }

])

</script>

<template>

  <UCommandPalette

    :close="{

      color: 'primary',

      variant: 'outline',

      class: 'rounded-full'

    }"

    :groups="groups"

    class="flex-1"

  />

</template>
```

### Close Icon

Use the `close-icon` prop to customize the close button [Icon](https://ui.nuxt.com/docs/components/icon). Defaults to `i-lucide-x`.

```
<script setup lang="ts">

import type { CommandPaletteGroup } from '@nuxt/ui'

const groups = ref<CommandPaletteGroup[]>([

  {

    id: 'apps',

    items: [

      {

        label: 'Calendar',

        icon: 'i-lucide-calendar'

      },

      {

        label: 'Music',

        icon: 'i-lucide-music'

      },

      {

        label: 'Maps',

        icon: 'i-lucide-map'

      }

    ]

  }

])

</script>

<template>

  <UCommandPalette close close-icon="i-lucide-arrow-right" :groups="groups" class="flex-1" />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.close` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.close` key.

### Back

Use the `back` prop to customize or hide the back button (with `false` value) displayed when navigating into a submenu.

You can pass any property from the [Button](https://ui.nuxt.com/docs/components/button) component to customize it.

### Back Icon

Use the `back-icon` prop to customize the back button [Icon](https://ui.nuxt.com/docs/components/icon). Defaults to `i-lucide-arrow-left`.

You can customize this icon globally in your `app.config.ts` under `ui.icons.arrowLeft` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.arrowLeft` key.

### Disabled

Use the `disabled` prop to disable the CommandPalette.

```
<script setup lang="ts">

import type { CommandPaletteGroup } from '@nuxt/ui'

const groups = ref<CommandPaletteGroup[]>([

  {

    id: 'apps',

    items: [

      {

        label: 'Calendar',

        icon: 'i-lucide-calendar'

      },

      {

        label: 'Music',

        icon: 'i-lucide-music'

      },

      {

        label: 'Maps',

        icon: 'i-lucide-map'

      }

    ]

  }

])

</script>

<template>

  <UCommandPalette disabled :groups="groups" class="flex-1" />

</template>
```

## Examples

### Control selected item(s)

You can control the selected item(s) by using the `default-value` prop or the `v-model` directive, by using the `onSelect` field on each item or by using the `@update:model-value` event.

```
<script setup lang="ts">

const toast = useToast()

const groups = ref([

  {

    id: 'users',

    label: 'Users',

    items: [

      {

        label: 'Benjamin Canac',

        suffix: 'benjamincanac',

        to: 'https://github.com/benjamincanac',

        target: '_blank',

        avatar: {

          src: 'https://github.com/benjamincanac.png'

        }

      },

      {

        label: 'Romain Hamel',

        suffix: 'romhml',

        to: 'https://github.com/romhml',

        target: '_blank',

        avatar: {

          src: 'https://github.com/romhml.png'

        }

      },

      {

        label: 'Sébastien Chopin',

        suffix: 'atinux',

        to: 'https://github.com/atinux',

        target: '_blank',

        avatar: {

          src: 'https://github.com/atinux.png'

        }

      },

      {

        label: 'Hugo Richard',

        suffix: 'HugoRCD',

        to: 'https://github.com/HugoRCD',

        target: '_blank',

        avatar: {

          src: 'https://github.com/HugoRCD.png'

        }

      },

      {

        label: 'Sandro Circi',

        suffix: 'sandros94',

        to: 'https://github.com/sandros94',

        target: '_blank',

        avatar: {

          src: 'https://github.com/sandros94.png'

        }

      },

      {

        label: 'Daniel Roe',

        suffix: 'danielroe',

        to: 'https://github.com/danielroe',

        target: '_blank',

        avatar: {

          src: 'https://github.com/danielroe.png'

        }

      },

      {

        label: 'Jakub Michálek',

        suffix: 'J-Michalek',

        to: 'https://github.com/J-Michalek',

        target: '_blank',

        avatar: {

          src: 'https://github.com/J-Michalek.png'

        }

      },

      {

        label: 'Eugen Istoc',

        suffix: 'genu',

        to: 'https://github.com/genu',

        target: '_blank',

        avatar: {

          src: 'https://github.com/genu.png'

        }

      }

    ]

  },

  {

    id: 'actions',

    items: [

      {

        label: 'Add new file',

        suffix: 'Create a new file in the current directory or workspace.',

        icon: 'i-lucide-file-plus',

        kbds: [

          'meta',

          'N'

        ],

        onSelect() {

          toast.add({ title: 'Add new file' })

        }

      },

      {

        label: 'Add new folder',

        suffix: 'Create a new folder in the current directory or workspace.',

        icon: 'i-lucide-folder-plus',

        kbds: [

          'meta',

          'F'

        ],

        onSelect() {

          toast.add({ title: 'Add new folder' })

        }

      },

      {

        label: 'Add hashtag',

        suffix: 'Add a hashtag to the current item.',

        icon: 'i-lucide-hash',

        kbds: [

          'meta',

          'H'

        ],

        onSelect() {

          toast.add({ title: 'Add hashtag' })

        }

      },

      {

        label: 'Add label',

        suffix: 'Add a label to the current item.',

        icon: 'i-lucide-tag',

        kbds: [

          'meta',

          'L'

        ],

        onSelect() {

          toast.add({ title: 'Add label' })

        }

      }

    ]

  }

])

function onSelect(item: any) {

  console.log(item)

}

</script>

<template>

  <UCommandPalette

    :groups="groups"

    class="flex-1 h-80"

    @update:model-value="onSelect"

  />

</template>
```

Use the `value-key` prop to select a field of an item to use as the value instead of the object itself. Use the `by` prop to compare objects by a field instead of reference.

Use the `v-model:search-term` directive to control the search term.

```
<script setup lang="ts">

const users = [

  {

    label: 'Benjamin Canac',

    suffix: 'benjamincanac',

    to: 'https://github.com/benjamincanac',

    target: '_blank',

    avatar: {

      src: 'https://github.com/benjamincanac.png'

    }

  },

  {

    label: 'Romain Hamel',

    suffix: 'romhml',

    to: 'https://github.com/romhml',

    target: '_blank',

    avatar: {

      src: 'https://github.com/romhml.png'

    }

  },

  {

    label: 'Sébastien Chopin',

    suffix: 'atinux',

    to: 'https://github.com/atinux',

    target: '_blank',

    avatar: {

      src: 'https://github.com/atinux.png'

    }

  },

  {

    label: 'Hugo Richard',

    suffix: 'HugoRCD',

    to: 'https://github.com/HugoRCD',

    target: '_blank',

    avatar: {

      src: 'https://github.com/HugoRCD.png'

    }

  },

  {

    label: 'Sandro Circi',

    suffix: 'sandros94',

    to: 'https://github.com/sandros94',

    target: '_blank',

    avatar: {

      src: 'https://github.com/sandros94.png'

    }

  },

  {

    label: 'Daniel Roe',

    suffix: 'danielroe',

    to: 'https://github.com/danielroe',

    target: '_blank',

    avatar: {

      src: 'https://github.com/danielroe.png'

    }

  },

  {

    label: 'Jakub Michálek',

    suffix: 'J-Michalek',

    to: 'https://github.com/J-Michalek',

    target: '_blank',

    avatar: {

      src: 'https://github.com/J-Michalek.png'

    }

  },

  {

    label: 'Eugen Istoc',

    suffix: 'genu',

    to: 'https://github.com/genu',

    target: '_blank',

    avatar: {

      src: 'https://github.com/genu.png'

    }

  }

]

const searchTerm = ref('B')

function onSelect() {

  searchTerm.value = ''

}

</script>

<template>

  <UCommandPalette

    v-model:search-term="searchTerm"

    :groups="[{ id: 'users', items: users }]"

    class="flex-1"

    @update:model-value="onSelect"

  />

</template>
```

This example uses the `@update:model-value` event to reset the search term when an item is selected.

### With children in items

You can create hierarchical menus by using the `children` property in items. When an item has children, it will automatically display a chevron icon and enable navigation into a submenu.

```
<script setup lang="ts">

const toast = useToast()

const groups = [

  {

    id: 'actions',

    label: 'Actions',

    items: [

      {

        label: 'Create new',

        icon: 'i-lucide-plus',

        children: [

          {

            label: 'New file',

            icon: 'i-lucide-file-plus',

            suffix: 'Create a new file in the current directory',

            onSelect(e: Event) {

              e.preventDefault()

              toast.add({ title: 'New file created!' })

            },

            kbds: ['meta', 'N']

          },

          {

            label: 'New folder',

            icon: 'i-lucide-folder-plus',

            suffix: 'Create a new folder in the current directory',

            onSelect(e: Event) {

              e.preventDefault()

              toast.add({ title: 'New folder created!' })

            },

            kbds: ['meta', 'F']

          },

          {

            label: 'New project',

            icon: 'i-lucide-folder-git',

            suffix: 'Create a new project from a template',

            onSelect(e: Event) {

              e.preventDefault()

              toast.add({ title: 'New project created!' })

            },

            kbds: ['meta', 'P']

          }

        ]

      },

      {

        label: 'Share',

        icon: 'i-lucide-share',

        children: [

          {

            label: 'Copy link',

            icon: 'i-lucide-link',

            suffix: 'Copy a link to the current item',

            onSelect(e: Event) {

              e.preventDefault()

              toast.add({ title: 'Link copied to clipboard!' })

            },

            kbds: ['meta', 'L']

          },

          {

            label: 'Share via email',

            icon: 'i-lucide-mail',

            suffix: 'Share the current item via email',

            onSelect(e: Event) {

              e.preventDefault()

              toast.add({ title: 'Share via email dialog opened!' })

            }

          },

          {

            label: 'Share on social',

            icon: 'i-lucide-share-2',

            suffix: 'Share the current item on social media',

            children: [

              {

                label: 'Twitter',

                icon: 'i-simple-icons-twitter',

                onSelect(e: Event) {

                  e.preventDefault()

                  toast.add({ title: 'Shared on Twitter!' })

                }

              },

              {

                label: 'LinkedIn',

                icon: 'i-simple-icons-linkedin',

                onSelect(e: Event) {

                  e.preventDefault()

                  toast.add({ title: 'Shared on LinkedIn!' })

                }

              },

              {

                label: 'Facebook',

                icon: 'i-simple-icons-facebook',

                onSelect(e: Event) {

                  e.preventDefault()

                  toast.add({ title: 'Shared on Facebook!' })

                }

              }

            ]

          }

        ]

      },

      {

        label: 'Settings',

        icon: 'i-lucide-settings',

        children: [

          {

            label: 'General',

            icon: 'i-lucide-sliders',

            suffix: 'Configure general settings',

            onSelect(e: Event) {

              e.preventDefault()

              toast.add({ title: 'General settings opened!' })

            }

          },

          {

            label: 'Appearance',

            icon: 'i-lucide-palette',

            suffix: 'Customize the appearance',

            onSelect(e: Event) {

              e.preventDefault()

              toast.add({ title: 'Appearance settings opened!' })

            }

          },

          {

            label: 'Security',

            icon: 'i-lucide-shield',

            suffix: 'Manage security settings',

            onSelect(e: Event) {

              e.preventDefault()

              toast.add({ title: 'Security settings opened!' })

            }

          }

        ]

      }

    ]

  }

]

</script>

<template>

  <UCommandPalette :groups="groups" class="flex-1" />

</template>
```

When navigating into a submenu:
- The search term is reset
- A back button appears in the input
- You can go back to the previous group by pressing the ⌫ key

### With fetched items

You can fetch items from an API and use them in the CommandPalette.

```
<script setup lang="ts">

const searchTerm = ref('')

const { data: users, status } = await useFetch('https://jsonplaceholder.typicode.com/users', {

  key: 'command-palette-users',

  transform: (data: { id: number, name: string, email: string }[]) => {

    return data?.map(user => ({ id: user.id, label: user.name, suffix: user.email, avatar: { src: \`https://i.pravatar.cc/120?img=${user.id}\` } })) || []

  },

  lazy: true

})

const groups = computed(() => [{

  id: 'users',

  label: searchTerm.value ? \`Users matching “${searchTerm.value}”...\` : 'Users',

  items: users.value || []

}])

</script>

<template>

  <UCommandPalette

    v-model:search-term="searchTerm"

    :loading="status === 'pending'"

    :groups="groups"

    class="flex-1 h-80"

  />

</template>
```

### With ignore filter

You can set the `ignoreFilter` field to `true` on a group to disable the internal search and use your own search logic.

```
<script setup lang="ts">

import { refDebounced } from '@vueuse/core'

const searchTerm = ref('')

const searchTermDebounced = refDebounced(searchTerm, 200)

const { data: users, status } = await useFetch('https://jsonplaceholder.typicode.com/users', {

  params: { q: searchTermDebounced },

  transform: (data: { id: number, name: string, email: string }[]) => {

    return data?.map(user => ({ id: user.id, label: user.name, suffix: user.email, avatar: { src: \`https://i.pravatar.cc/120?img=${user.id}\` } })) || []

  },

  lazy: true

})

const groups = computed(() => [{

  id: 'users',

  label: searchTerm.value ? \`Users matching “${searchTerm.value}”...\` : 'Users',

  items: users.value || [],

  ignoreFilter: true

}])

</script>

<template>

  <UCommandPalette

    v-model:search-term="searchTerm"

    :loading="status === 'pending'"

    :groups="groups"

    class="flex-1 h-80"

  />

</template>
```

This example uses [`refDebounced`](https://vueuse.org/shared/refDebounced/#refdebounced) to debounce the API calls.

### With post-filtered items

You can use the `postFilter` field on a group to filter items after the search happened.

```
<script setup lang="ts">

const items = [

  {

    id: '/',

    label: 'Introduction',

    level: 1

  },

  {

    id: '/docs/getting-started#whats-new-in-v3',

    label: 'What\'s new in v3?',

    level: 2

  },

  {

    id: '/docs/getting-started#reka-ui',

    label: 'Reka UI',

    level: 3

  },

  {

    id: '/docs/getting-started#tailwind-css',

    label: 'Tailwind CSS',

    level: 3

  },

  {

    id: '/docs/getting-started#tailwind-variants',

    label: 'Tailwind Variants',

    level: 3

  },

  {

    id: '/docs/getting-started/installation',

    label: 'Installation',

    level: 1

  }

]

function postFilter(searchTerm: string, items: any[]) {

  // Filter only first level items if no searchTerm

  if (!searchTerm) {

    return items?.filter(item => item.level === 1)

  }

  return items

}

</script>

<template>

  <UCommandPalette :groups="[{ id: 'files', items, postFilter }]" class="flex-1" />

</template>
```

Start typing to see items with higher level appear.

You can use the `fuse` prop to override the options of [useFuse](https://vueuse.org/integrations/useFuse) which defaults to:

```ts
{

  fuseOptions: {

    ignoreLocation: true,

    threshold: 0.1,

    keys: ['label', 'suffix']

  },

  resultLimit: 12,

  matchAllWhenSearchEmpty: true

}
```

The `fuseOptions` are the options of [Fuse.js](https://www.fusejs.io/api/options.html), the `resultLimit` is the maximum number of results to return and the `matchAllWhenSearchEmpty` is a boolean to match all items when the search term is empty.

You can for example set `{ fuseOptions: { includeMatches: true } }` to highlight the search term in the items.

```
<script setup lang="ts">

const { data: users } = await useFetch('https://jsonplaceholder.typicode.com/users', {

  key: 'command-palette-users',

  transform: (data: { id: number, name: string, email: string }[]) => {

    return data?.map(user => ({ id: user.id, label: user.name, suffix: user.email, avatar: { src: \`https://i.pravatar.cc/120?img=${user.id}\` } })) || []

  },

  lazy: true

})

</script>

<template>

  <UCommandPalette

    :groups="[{ id: 'users', items: users || [] }]"

    :fuse="{ fuseOptions: { includeMatches: true } }"

    class="flex-1 h-80"

  />

</template>
```

### With virtualization 4.1+

Use the `virtualize` prop to enable virtualization for large lists as a boolean or an object with options like `{ estimateSize: 32, overscan: 12 }`.

When enabled, all groups are flattened into a single list due to a limitation of Reka UI.

```
<script setup lang="ts">

import type { CommandPaletteItem } from '@nuxt/ui'

const items: CommandPaletteItem[] = Array(1000)

  .fill(0)

  .map((_, value) => ({

    label: \`item-${value}\`,

    value

  }))

const groups = [

  {

    id: 'items',

    items

  }

]

</script>

<template>

  <UCommandPalette

    virtualize

    :fuse="{ resultLimit: 1000 }"

    :groups="groups"

    class="flex-1 h-80"

  />

</template>
```

### Within a Popover

You can use the CommandPalette component inside a [Popover](https://ui.nuxt.com/docs/components/popover) 's content.

```
<script setup lang="ts">

import type { CommandPaletteItem } from '@nuxt/ui'

const items = ref([

  {

    label: 'bug',

    value: 'bug',

    chip: {

      color: 'error'

    }

  },

  {

    label: 'feature',

    value: 'feature',

    chip: {

      color: 'success'

    }

  },

  {

    label: 'enhancement',

    value: 'enhancement',

    chip: {

      color: 'info'

    }

  }

] satisfies CommandPaletteItem[])

const label = ref([])

</script>

<template>

  <UPopover :content="{ side: 'right', align: 'start' }">

    <UButton

      icon="i-lucide-tag"

      label="Select labels"

      color="neutral"

      variant="subtle"

    />

    <template #content>

      <UCommandPalette

        v-model="label"

        multiple

        placeholder="Search labels..."

        :groups="[{ id: 'labels', items }]"

        :ui="{ input: '[&>input]:h-8 [&>input]:text-sm' }"

      />

    </template>

  </UPopover>

</template>
```

You can use the CommandPalette component inside a [Modal](https://ui.nuxt.com/docs/components/modal) 's content.

```
<script setup lang="ts">

const searchTerm = ref('')

const { data: users, status } = await useFetch('https://jsonplaceholder.typicode.com/users', {

  key: 'command-palette-users',

  params: { q: searchTerm },

  transform: (data: { id: number, name: string, email: string }[]) => {

    return data?.map(user => ({ id: user.id, label: user.name, suffix: user.email, avatar: { src: \`https://i.pravatar.cc/120?img=${user.id}\` } })) || []

  },

  lazy: true

})

const groups = computed(() => [{

  id: 'users',

  label: searchTerm.value ? \`Users matching “${searchTerm.value}”...\` : 'Users',

  items: users.value || [],

  ignoreFilter: true

}])

</script>

<template>

  <UModal>

    <UButton

      label="Search users..."

      color="neutral"

      variant="subtle"

      icon="i-lucide-search"

    />

    <template #content>

      <UCommandPalette

        v-model:search-term="searchTerm"

        :loading="status === 'pending'"

        :groups="groups"

        placeholder="Search users..."

        class="h-80"

      />

    </template>

  </UModal>

</template>
```

### Within a Drawer

You can use the CommandPalette component inside a [Drawer](https://ui.nuxt.com/docs/components/drawer) 's content.

```
<script setup lang="ts">

const searchTerm = ref('')

const { data: users, status } = await useFetch('https://jsonplaceholder.typicode.com/users', {

  key: 'command-palette-users',

  params: { q: searchTerm },

  transform: (data: { id: number, name: string, email: string }[]) => {

    return data?.map(user => ({ id: user.id, label: user.name, suffix: user.email, avatar: { src: \`https://i.pravatar.cc/120?img=${user.id}\` } })) || []

  },

  lazy: true

})

const groups = computed(() => [{

  id: 'users',

  label: searchTerm.value ? \`Users matching “${searchTerm.value}”...\` : 'Users',

  items: users.value || [],

  ignoreFilter: true

}])

</script>

<template>

  <UDrawer :handle="false">

    <UButton

      label="Search users..."

      color="neutral"

      variant="subtle"

      icon="i-lucide-search"

    />

    <template #content>

      <UCommandPalette

        v-model:search-term="searchTerm"

        :loading="status === 'pending'"

        :groups="groups"

        placeholder="Search users..."

        class="h-80"

      />

    </template>

  </UDrawer>

</template>
```

### Listen open state

When using the `close` prop, you can listen to the `update:open` event when the button is clicked.

```
<script setup lang="ts">

const open = ref(false)

const users = [

  {

    label: 'Benjamin Canac',

    suffix: 'benjamincanac',

    to: 'https://github.com/benjamincanac',

    target: '_blank',

    avatar: {

      src: 'https://github.com/benjamincanac.png'

    }

  },

  {

    label: 'Romain Hamel',

    suffix: 'romhml',

    to: 'https://github.com/romhml',

    target: '_blank',

    avatar: {

      src: 'https://github.com/romhml.png'

    }

  },

  {

    label: 'Sébastien Chopin',

    suffix: 'atinux',

    to: 'https://github.com/atinux',

    target: '_blank',

    avatar: {

      src: 'https://github.com/atinux.png'

    }

  },

  {

    label: 'Hugo Richard',

    suffix: 'HugoRCD',

    to: 'https://github.com/HugoRCD',

    target: '_blank',

    avatar: {

      src: 'https://github.com/HugoRCD.png'

    }

  },

  {

    label: 'Sandro Circi',

    suffix: 'sandros94',

    to: 'https://github.com/sandros94',

    target: '_blank',

    avatar: {

      src: 'https://github.com/sandros94.png'

    }

  },

  {

    label: 'Daniel Roe',

    suffix: 'danielroe',

    to: 'https://github.com/danielroe',

    target: '_blank',

    avatar: {

      src: 'https://github.com/danielroe.png'

    }

  },

  {

    label: 'Jakub Michálek',

    suffix: 'J-Michalek',

    to: 'https://github.com/J-Michalek',

    target: '_blank',

    avatar: {

      src: 'https://github.com/J-Michalek.png'

    }

  },

  {

    label: 'Eugen Istoc',

    suffix: 'genu',

    to: 'https://github.com/genu',

    target: '_blank',

    avatar: {

      src: 'https://github.com/genu.png'

    }

  }

]

</script>

<template>

  <UModal v-model:open="open">

    <UButton

      label="Search users..."

      color="neutral"

      variant="subtle"

      icon="i-lucide-search"

    />

    <template #content>

      <UCommandPalette close :groups="[{ id: 'users', items: users }]" @update:open="open = $event" />

    </template>

  </UModal>

</template>
```

This can be useful when using the CommandPalette inside a [`Modal`](https://ui.nuxt.com/docs/components/modal) for example.

Use the `#footer` slot to add custom content at the bottom of the CommandPalette, such as keyboard shortcuts help or additional actions.

```
<script setup lang="ts">

const groups = [

  {

    id: 'actions',

    items: [

      {

        label: 'Add new file',

        suffix: 'Create a new file in the current directory',

        icon: 'i-lucide-file-plus',

        kbds: ['meta', 'N']

      },

      {

        label: 'Add new folder',

        suffix: 'Create a new folder in the current directory',

        icon: 'i-lucide-folder-plus',

        kbds: ['meta', 'F']

      },

      {

        label: 'Search files',

        suffix: 'Search across all files in the project',

        icon: 'i-lucide-search',

        kbds: ['meta', 'P']

      },

      {

        label: 'Settings',

        suffix: 'Open application settings',

        icon: 'i-lucide-settings',

        kbds: ['meta', ',']

      }

    ]

  },

  {

    id: 'recent',

    label: 'Recent',

    items: [

      {

        label: 'project.vue',

        suffix: 'components/',

        icon: 'i-vscode-icons-file-type-vue'

      },

      {

        label: 'readme.md',

        suffix: 'docs/',

        icon: 'i-vscode-icons-file-type-markdown'

      },

      {

        label: 'package.json',

        suffix: 'root/',

        icon: 'i-vscode-icons-file-type-node'

      }

    ]

  }

]

</script>

<template>

  <UCommandPalette :groups="groups" class="flex-1 h-80">

    <template #footer>

      <div class="flex items-center justify-between gap-2">

        <UIcon name="i-simple-icons-nuxtdotjs" class="size-5 text-dimmed ml-1" />

        <div class="flex items-center gap-1">

          <UButton color="neutral" variant="ghost" label="Open Command" class="text-dimmed" size="xs">

            <template #trailing>

              <UKbd value="enter" />

            </template>

          </UButton>

          <USeparator orientation="vertical" class="h-4" />

          <UButton color="neutral" variant="ghost" label="Actions" class="text-dimmed" size="xs">

            <template #trailing>

              <UKbd value="meta" />

              <UKbd value="k" />

            </template>

          </UButton>

        </div>

      </div>

    </template>

  </UCommandPalette>

</template>
```

### With custom slot

Use the `slot` property to customize a specific item or group.

You will have access to the following slots:

- `#{{ item.slot }}`
- `#{{ item.slot }}-leading`
- `#{{ item.slot }}-label`
- `#{{ item.slot }}-trailing`
- `#{{ group.slot }}`
- `#{{ group.slot }}-leading`
- `#{{ group.slot }}-label`
- `#{{ group.slot }}-trailing`

```
<script setup lang="ts">

const groups = [

  {

    id: 'settings',

    items: [

      {

        label: 'Profile',

        icon: 'i-lucide-user',

        kbds: ['meta', 'P']

      },

      {

        label: 'Billing',

        icon: 'i-lucide-credit-card',

        kbds: ['meta', 'B'],

        slot: 'billing' as const

      },

      {

        label: 'Notifications',

        icon: 'i-lucide-bell'

      },

      {

        label: 'Security',

        icon: 'i-lucide-lock'

      }

    ]

  },

  {

    id: 'users',

    label: 'Users',

    slot: 'users' as const,

    items: [

      {

        label: 'Benjamin Canac',

        suffix: 'benjamincanac',

        to: 'https://github.com/benjamincanac',

        target: '_blank'

      },

      {

        label: 'Romain Hamel',

        suffix: 'romhml',

        to: 'https://github.com/romhml',

        target: '_blank'

      },

      {

        label: 'Sébastien Chopin',

        suffix: 'atinux',

        to: 'https://github.com/atinux',

        target: '_blank'

      },

      {

        label: 'Hugo Richard',

        suffix: 'HugoRCD',

        to: 'https://github.com/HugoRCD',

        target: '_blank'

      },

      {

        label: 'Sandro Circi',

        suffix: 'sandros94',

        to: 'https://github.com/sandros94',

        target: '_blank'

      },

      {

        label: 'Daniel Roe',

        suffix: 'danielroe',

        to: 'https://github.com/danielroe',

        target: '_blank'

      },

      {

        label: 'Jakub Michálek',

        suffix: 'J-Michalek',

        to: 'https://github.com/J-Michalek',

        target: '_blank'

      },

      {

        label: 'Eugen Istoc',

        suffix: 'genu',

        to: 'https://github.com/genu',

        target: '_blank'

      }

    ]

  }

]

</script>

<template>

  <UCommandPalette :groups="groups" class="flex-1 h-80">

    <template #users-leading="{ item }">

      <UAvatar :src="\`https://github.com/${item.suffix}.png\`" size="2xs" />

    </template>

    <template #billing-label="{ item }">

      <span class="font-medium text-primary">{{ item.label }}</span>

      <UBadge variant="subtle" size="sm">

        50% off

      </UBadge>

    </template>

  </UCommandPalette>

</template>
```

You can also use the `#item`, `#item-leading`, `#item-label` and `#item-trailing` slots to customize all items.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `size` | `'md'` | ` "sm" \| "md" \| "xs" \| "lg" \| "xl"` |
| `icon` | `appConfig.ui.icons.search` | `any`  The icon displayed in the input. |
| `trailingIcon` | `appConfig.ui.icons.search` | `any`  The icon displayed on the right side of the input. |
| `selectedIcon` | `appConfig.ui.icons.check` | `any`  The icon displayed when an item is selected. |
| `childrenIcon` | `appConfig.ui.icons.chevronRight` | `any`  The icon displayed when an item has children. |
| `placeholder` | `t('commandPalette.placeholder')` | ` string`  The placeholder text for the input. |
| `autofocus` | `true` | `boolean`  Automatically focus the input when component is mounted. |
| `close` | `false` | `boolean \| Omit<ButtonProps, LinkPropsKeys>`  Display a close button in the input (useful when inside a Modal for example).`{ size: 'md', color: 'neutral', variant: 'ghost' }` |
| `closeIcon` | `appConfig.ui.icons.close` | `any`  The icon displayed in the close button. |
| `back` | `true` | `boolean \| Omit<ButtonProps, LinkPropsKeys>`  Display a button to navigate back in history.`{ size: 'md', color: 'neutral', variant: 'link' }` |
| `backIcon` | `appConfig.ui.icons.arrowLeft` | `any`  The icon displayed in the back button. |
| `input` | `true` | `boolean \| Omit<InputProps<AcceptableValue>, "modelValue" \| "defaultValue">`  Configure the input or hide it with `false`. |
| `groups` |  | ` G[]` |
| `fuse` | `{ fuseOptions: { ignoreLocation: true, threshold: 0.1, keys: ['label', 'suffix'] }, resultLimit: 12, matchAllWhenSearchEmpty: true }` | ` n<T>`  Options for [useFuse](https://vueuse.org/integrations/useFuse). |
| `virtualize` | `false` | `boolean \| { overscan?: number ; estimateSize?: number \| ((index: number) => number) \| undefined; } \| undefined`  Enable virtualization for large lists. Note: when enabled, all groups are flattened into a single list due to a limitation of Reka UI ([https://github.com/unovue/reka-ui/issues/1885](https://github.com/unovue/reka-ui/issues/1885)). |
| `valueKey` | `undefined` | ` keyof Extract<NestedItem<T>, object> \| DotPathKeys<Extract<NestedItem<T>, object>>`  When `items` is an array of objects, select the field to use as the value instead of the object itself. |
| `labelKey` | `'label'` | ` keyof Extract<NestedItem<T>, object> \| DotPathKeys<Extract<NestedItem<T>, object>>`  The key used to get the label from the item. |
| `descriptionKey` | `'description'` | ` keyof Extract<NestedItem<T>, object> \| DotPathKeys<Extract<NestedItem<T>, object>>`  The key used to get the description from the item. |
| `preserveGroupOrder` | `false` | `boolean`  Whether to preserve the order of groups as defined in the `groups` prop when filtering. When `false`, groups will appear based on item matches. |
| `multiple` |  | `boolean`  Whether multiple options can be selected or not. |
| `disabled` |  | `boolean`  When `true`, prevents the user from interacting with listbox |
| `modelValue` |  | ` null \| string \| number \| bigint \| Record<string, any> \| AcceptableValue[]`  The controlled value of the listbox. Can be binded with with `v-model`. |
| `defaultValue` |  | ` null \| string \| number \| bigint \| Record<string, any> \| AcceptableValue[]`  The value of the listbox when initially rendered. Use when you do not need to control the state of the Listbox |
| `highlightOnHover` | `true` | `boolean`  When `true`, hover over item will trigger highlight |
| `selectionBehavior` | `'toggle'` | ` "replace" \| "toggle"`  How multiple selection should behave in the collection. |
| `by` |  | ` string \| (a: AcceptableValue, b: AcceptableValue): boolean`  Use this to compare objects by a particular field, or pass your own comparison function for complete control over how objects are compared. |
| `loading` |  | `boolean`  When `true`, the loading icon will be displayed. |
| `loadingIcon` | `appConfig.ui.icons.loading` | `any`  The icon when the `loading` prop is `true`. |
| `searchTerm` | `''` | ` string` |
| `ui` |  | ` { root?: ClassNameValue; input?: ClassNameValue; close?: ClassNameValue; back?: ClassNameValue; content?: ClassNameValue; footer?: ClassNameValue; viewport?: ClassNameValue; group?: ClassNameValue; empty?: ClassNameValue; label?: ClassNameValue; item?: ClassNameValue; itemLeadingIcon?: ClassNameValue; itemLeadingAvatar?: ClassNameValue; itemLeadingAvatarSize?: ClassNameValue; itemLeadingChip?: ClassNameValue; itemLeadingChipSize?: ClassNameValue; itemTrailing?: ClassNameValue; itemTrailingIcon?: ClassNameValue; itemTrailingHighlightedIcon?: ClassNameValue; itemTrailingKbds?: ClassNameValue; itemTrailingKbdsSize?: ClassNameValue; itemWrapper?: ClassNameValue; itemLabel?: ClassNameValue; itemDescription?: ClassNameValue; itemLabelBase?: ClassNameValue; itemLabelPrefix?: ClassNameValue; itemLabelSuffix?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `empty` | `{ searchTerm?: string \| undefined; }` |
| `footer` | `{ ui: object; }` |
| `back` | `{ ui: object; }` |
| `close` | `{ ui: object; }` |
| `item` | `{ item: T; index: number; ui: object; }` |
| `item-leading` | `{ item: T; index: number; ui: object; }` |
| `item-label` | `{ item: T; index: number; ui: object; }` |
| `item-description` | `{ item: T; index: number; ui: object; }` |
| `item-trailing` | `{ item: T; index: number; ui: object; }` |

### Emits

| Event | Type |
| --- | --- |
| `update:modelValue` | `[value: T]` |
| `highlight` | `[payload: { ref: HTMLElement; value: T; } \| undefined]` |
| `entryFocus` | `[event: CustomEvent<any>]` |
| `leave` | `[event: Event]` |
| `update:open` | `[value: boolean]` |
| `update:searchTerm` | `[value: string]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    commandPalette: {

      slots: {

        root: 'flex flex-col min-h-0 min-w-0 divide-y divide-default',

        input: '',

        close: '',

        back: 'p-0',

        content: 'relative overflow-hidden flex flex-col',

        footer: 'p-1',

        viewport: 'relative scroll-py-1 overflow-y-auto flex-1 focus:outline-none',

        group: 'p-1 isolate',

        empty: 'text-center text-muted',

        label: 'font-semibold text-highlighted',

        item: 'group relative w-full flex items-start select-none outline-none before:absolute before:z-[-1] before:inset-px before:rounded-md data-disabled:cursor-not-allowed data-disabled:opacity-75',

        itemLeadingIcon: 'shrink-0',

        itemLeadingAvatar: 'shrink-0',

        itemLeadingAvatarSize: '',

        itemLeadingChip: 'shrink-0',

        itemLeadingChipSize: '',

        itemTrailing: 'ms-auto inline-flex items-center',

        itemTrailingIcon: 'shrink-0',

        itemTrailingHighlightedIcon: 'shrink-0 text-dimmed hidden group-data-highlighted:inline-flex',

        itemTrailingKbds: 'hidden lg:inline-flex items-center shrink-0',

        itemTrailingKbdsSize: '',

        itemWrapper: 'flex-1 flex flex-col text-start min-w-0',

        itemLabel: 'truncate space-x-1 text-dimmed',

        itemDescription: 'truncate text-muted',

        itemLabelBase: 'text-highlighted [&>mark]:text-inverted [&>mark]:bg-primary',

        itemLabelPrefix: 'text-default',

        itemLabelSuffix: 'text-dimmed [&>mark]:text-inverted [&>mark]:bg-primary'

      },

      variants: {

        virtualize: {

          true: {

            viewport: 'p-1 isolate'

          },

          false: {

            viewport: 'divide-y divide-default'

          }

        },

        size: {

          xs: {

            input: '[&>input]:h-10',

            empty: 'py-3 text-xs',

            label: 'p-1 text-[10px]/3 gap-1',

            item: 'p-1 text-xs gap-1',

            itemLeadingIcon: 'size-4',

            itemLeadingAvatarSize: '3xs',

            itemLeadingChip: 'size-4',

            itemLeadingChipSize: 'sm',

            itemTrailing: 'gap-1',

            itemTrailingIcon: 'size-4',

            itemTrailingHighlightedIcon: 'size-4',

            itemTrailingKbds: 'gap-0.5',

            itemTrailingKbdsSize: 'sm'

          },

          sm: {

            input: '[&>input]:h-11',

            empty: 'py-4 text-xs',

            label: 'p-1.5 text-[10px]/3 gap-1.5',

            item: 'p-1.5 text-xs gap-1.5',

            itemLeadingIcon: 'size-4',

            itemLeadingAvatarSize: '3xs',

            itemLeadingChip: 'size-4',

            itemLeadingChipSize: 'sm',

            itemTrailing: 'gap-1.5',

            itemTrailingIcon: 'size-4',

            itemTrailingHighlightedIcon: 'size-4',

            itemTrailingKbds: 'gap-0.5',

            itemTrailingKbdsSize: 'sm'

          },

          md: {

            input: '[&>input]:h-12',

            empty: 'py-6 text-sm',

            label: 'p-1.5 text-xs gap-1.5',

            item: 'p-1.5 text-sm gap-1.5',

            itemLeadingIcon: 'size-5',

            itemLeadingAvatarSize: '2xs',

            itemLeadingChip: 'size-5',

            itemLeadingChipSize: 'md',

            itemTrailing: 'gap-1.5',

            itemTrailingIcon: 'size-5',

            itemTrailingHighlightedIcon: 'size-5',

            itemTrailingKbds: 'gap-0.5',

            itemTrailingKbdsSize: 'md'

          },

          lg: {

            input: '[&>input]:h-13',

            empty: 'py-7 text-sm',

            label: 'p-2 text-xs gap-2',

            item: 'p-2 text-sm gap-2',

            itemLeadingIcon: 'size-5',

            itemLeadingAvatarSize: '2xs',

            itemLeadingChip: 'size-5',

            itemLeadingChipSize: 'md',

            itemTrailing: 'gap-2',

            itemTrailingIcon: 'size-5',

            itemTrailingHighlightedIcon: 'size-5',

            itemTrailingKbds: 'gap-0.5',

            itemTrailingKbdsSize: 'md'

          },

          xl: {

            input: '[&>input]:h-14',

            empty: 'py-8 text-base',

            label: 'p-2 text-sm gap-2',

            item: 'p-2 text-base gap-2',

            itemLeadingIcon: 'size-6',

            itemLeadingAvatarSize: 'xs',

            itemLeadingChip: 'size-6',

            itemLeadingChipSize: 'lg',

            itemTrailing: 'gap-2',

            itemTrailingIcon: 'size-6',

            itemTrailingHighlightedIcon: 'size-6',

            itemTrailingKbds: 'gap-0.5',

            itemTrailingKbdsSize: 'lg'

          }

        },

        active: {

          true: {

            item: 'text-highlighted before:bg-elevated',

            itemLeadingIcon: 'text-default'

          },

          false: {

            item: [

              'text-default data-highlighted:not-data-disabled:text-highlighted data-highlighted:not-data-disabled:before:bg-elevated/50',

              'transition-colors before:transition-colors'

            ],

            itemLeadingIcon: [

              'text-dimmed group-data-highlighted:not-group-data-disabled:text-default',

              'transition-colors'

            ]

          }

        },

        loading: {

          true: {

            itemLeadingIcon: 'animate-spin'

          }

        }

      },

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

        commandPalette: {

          slots: {

            root: 'flex flex-col min-h-0 min-w-0 divide-y divide-default',

            input: '',

            close: '',

            back: 'p-0',

            content: 'relative overflow-hidden flex flex-col',

            footer: 'p-1',

            viewport: 'relative scroll-py-1 overflow-y-auto flex-1 focus:outline-none',

            group: 'p-1 isolate',

            empty: 'text-center text-muted',

            label: 'font-semibold text-highlighted',

            item: 'group relative w-full flex items-start select-none outline-none before:absolute before:z-[-1] before:inset-px before:rounded-md data-disabled:cursor-not-allowed data-disabled:opacity-75',

            itemLeadingIcon: 'shrink-0',

            itemLeadingAvatar: 'shrink-0',

            itemLeadingAvatarSize: '',

            itemLeadingChip: 'shrink-0',

            itemLeadingChipSize: '',

            itemTrailing: 'ms-auto inline-flex items-center',

            itemTrailingIcon: 'shrink-0',

            itemTrailingHighlightedIcon: 'shrink-0 text-dimmed hidden group-data-highlighted:inline-flex',

            itemTrailingKbds: 'hidden lg:inline-flex items-center shrink-0',

            itemTrailingKbdsSize: '',

            itemWrapper: 'flex-1 flex flex-col text-start min-w-0',

            itemLabel: 'truncate space-x-1 text-dimmed',

            itemDescription: 'truncate text-muted',

            itemLabelBase: 'text-highlighted [&>mark]:text-inverted [&>mark]:bg-primary',

            itemLabelPrefix: 'text-default',

            itemLabelSuffix: 'text-dimmed [&>mark]:text-inverted [&>mark]:bg-primary'

          },

          variants: {

            virtualize: {

              true: {

                viewport: 'p-1 isolate'

              },

              false: {

                viewport: 'divide-y divide-default'

              }

            },

            size: {

              xs: {

                input: '[&>input]:h-10',

                empty: 'py-3 text-xs',

                label: 'p-1 text-[10px]/3 gap-1',

                item: 'p-1 text-xs gap-1',

                itemLeadingIcon: 'size-4',

                itemLeadingAvatarSize: '3xs',

                itemLeadingChip: 'size-4',

                itemLeadingChipSize: 'sm',

                itemTrailing: 'gap-1',

                itemTrailingIcon: 'size-4',

                itemTrailingHighlightedIcon: 'size-4',

                itemTrailingKbds: 'gap-0.5',

                itemTrailingKbdsSize: 'sm'

              },

              sm: {

                input: '[&>input]:h-11',

                empty: 'py-4 text-xs',

                label: 'p-1.5 text-[10px]/3 gap-1.5',

                item: 'p-1.5 text-xs gap-1.5',

                itemLeadingIcon: 'size-4',

                itemLeadingAvatarSize: '3xs',

                itemLeadingChip: 'size-4',

                itemLeadingChipSize: 'sm',

                itemTrailing: 'gap-1.5',

                itemTrailingIcon: 'size-4',

                itemTrailingHighlightedIcon: 'size-4',

                itemTrailingKbds: 'gap-0.5',

                itemTrailingKbdsSize: 'sm'

              },

              md: {

                input: '[&>input]:h-12',

                empty: 'py-6 text-sm',

                label: 'p-1.5 text-xs gap-1.5',

                item: 'p-1.5 text-sm gap-1.5',

                itemLeadingIcon: 'size-5',

                itemLeadingAvatarSize: '2xs',

                itemLeadingChip: 'size-5',

                itemLeadingChipSize: 'md',

                itemTrailing: 'gap-1.5',

                itemTrailingIcon: 'size-5',

                itemTrailingHighlightedIcon: 'size-5',

                itemTrailingKbds: 'gap-0.5',

                itemTrailingKbdsSize: 'md'

              },

              lg: {

                input: '[&>input]:h-13',

                empty: 'py-7 text-sm',

                label: 'p-2 text-xs gap-2',

                item: 'p-2 text-sm gap-2',

                itemLeadingIcon: 'size-5',

                itemLeadingAvatarSize: '2xs',

                itemLeadingChip: 'size-5',

                itemLeadingChipSize: 'md',

                itemTrailing: 'gap-2',

                itemTrailingIcon: 'size-5',

                itemTrailingHighlightedIcon: 'size-5',

                itemTrailingKbds: 'gap-0.5',

                itemTrailingKbdsSize: 'md'

              },

              xl: {

                input: '[&>input]:h-14',

                empty: 'py-8 text-base',

                label: 'p-2 text-sm gap-2',

                item: 'p-2 text-base gap-2',

                itemLeadingIcon: 'size-6',

                itemLeadingAvatarSize: 'xs',

                itemLeadingChip: 'size-6',

                itemLeadingChipSize: 'lg',

                itemTrailing: 'gap-2',

                itemTrailingIcon: 'size-6',

                itemTrailingHighlightedIcon: 'size-6',

                itemTrailingKbds: 'gap-0.5',

                itemTrailingKbdsSize: 'lg'

              }

            },

            active: {

              true: {

                item: 'text-highlighted before:bg-elevated',

                itemLeadingIcon: 'text-default'

              },

              false: {

                item: [

                  'text-default data-highlighted:not-data-disabled:text-highlighted data-highlighted:not-data-disabled:before:bg-elevated/50',

                  'transition-colors before:transition-colors'

                ],

                itemLeadingIcon: [

                  'text-dimmed group-data-highlighted:not-group-data-disabled:text-default',

                  'transition-colors'

                ]

              }

            },

            loading: {

              true: {

                itemLeadingIcon: 'animate-spin'

              }

            }

          },

          defaultVariants: {

            size: 'md'

          }

        }

      }

    })

  ]

})
```

## Changelog

[`36cd5`](https://github.com/nuxt/ui/commit/36cd5e5eb579f422793a1ddc195a9f71227be8c8) — feat: add `by` prop ([#5906](https://github.com/nuxt/ui/issues/5906))

[`55646`](https://github.com/nuxt/ui/commit/55646eaeab1598ad53b95baa2c8acb15f798482b) — feat: add `valueKey` prop ([#5905](https://github.com/nuxt/ui/issues/5905))

[`3ae04`](https://github.com/nuxt/ui/commit/3ae04c64aa489d1ff9f3bc5a47e211629788764a) — feat: add `size` prop ([#5878](https://github.com/nuxt/ui/issues/5878))

[`d51b4`](https://github.com/nuxt/ui/commit/d51b424d9e306c25fc7dc32857011ffaffe56d7e) — feat: handle virtualizer `estimateSize` as function ([#5748](https://github.com/nuxt/ui/issues/5748))

[`12052`](https://github.com/nuxt/ui/commit/12052e8c9909142406b626d92ecfd787b3b6fe28) — feat: add `input` prop ([#5736](https://github.com/nuxt/ui/issues/5736))

[`3f5bd`](https://github.com/nuxt/ui/commit/3f5bdb3c1688446a89186f2230de373ebd4b14d9) — fix: keyboard selection on link items

[`184ea`](https://github.com/nuxt/ui/commit/184eaab1cd5f4f4943b509ea1a3efb1b6f6d7f91) — chore: reduce type verbosity by omitting link props from action buttons

[`56ae8`](https://github.com/nuxt/ui/commit/56ae8e7199b8d5e3b5a169bd63c767724abfb582) — fix: calc virtualizer estimateSize based on item description

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`e751b`](https://github.com/nuxt/ui/commit/e751b37497a4a585b70b5fc80225e988e750ebf5) — fix: improve performances and filtering logic ([#5433](https://github.com/nuxt/ui/issues/5433))

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`fce2d`](https://github.com/nuxt/ui/commit/fce2df4e0660d0bdb3cdd4fb3041416824cbe893) — fix!: consistent exposed refs ([#5385](https://github.com/nuxt/ui/issues/5385))

[`807cf`](https://github.com/nuxt/ui/commit/807cfb062ee5428719d062c8d1eec8fa9bfd35aa) — chore: update dependency reka-ui to v2.6.0 (v4) ([#5287](https://github.com/nuxt/ui/issues/5287))

[`edda8`](https://github.com/nuxt/ui/commit/edda8a66bc4e51dea073baf60601c2d3f47c1886) — feat!: add `children-icon` prop to use `trailing-icon` in input ([#4397](https://github.com/nuxt/ui/issues/4397))

[`38647`](https://github.com/nuxt/ui/commit/38647a2d4a7c0567ac554c335d21776951b9978d) — feat: preserve group order in search results ([#5197](https://github.com/nuxt/ui/issues/5197))

[`9d136`](https://github.com/nuxt/ui/commit/9d13653156f0644d7859ad499c0a77ae341207b4) — fix: ensure items truncate work

[`70cf0`](https://github.com/nuxt/ui/commit/70cf05f5103776eadbee5e5bcae7d2bb30543d4a) — feat: handle `description` in items ([#5193](https://github.com/nuxt/ui/issues/5193))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`84f87`](https://github.com/nuxt/ui/commit/84f87a5953b508d74662dd3e81715ee86e75d71f) — feat: add global event handlers and checkbox example ([#5195](https://github.com/nuxt/ui/issues/5195))

[`c744d`](https://github.com/nuxt/ui/commit/c744d6ff82424365acc9f5489a5352e5e552b5f6) — feat: implement virtualization ([#5162](https://github.com/nuxt/ui/issues/5162))

[`11a03`](https://github.com/nuxt/ui/commit/11a03201ed8454f37e911db4a14b00f74104932a) — fix: dot notation type support for `labelKey` and `valueKey` ([#4933](https://github.com/nuxt/ui/issues/4933))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`4682d`](https://github.com/nuxt/ui/commit/4682ded891e1434bd8a541f911a9ac7eb3b9296b) — fix: remove `rtl:space-x-reverse` from label ([#4576](https://github.com/nuxt/ui/issues/4576))

[`be41a`](https://github.com/nuxt/ui/commit/be41aed1f3d3476801e1840dbb8766926bc93c05) — fix: remove default `md` size on buttons ([#4357](https://github.com/nuxt/ui/issues/4357))

[`59c26`](https://github.com/nuxt/ui/commit/59c26ec1230375a24fbaf8a630a696ae854700c7) — feat: handle `children` in items ([#4226](https://github.com/nuxt/ui/issues/4226))

[`2ba94`](https://github.com/nuxt/ui/commit/2ba94db09e1ba86020d5d289f1ca1e24ef706299) — fix: add `presentation` role to viewport

[`b9adc`](https://github.com/nuxt/ui/commit/b9adc83e787db02507e6e7bb1aabc684eccc197b) — feat: add `ui` field in items ([#4060](https://github.com/nuxt/ui/issues/4060))

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`d2526`](https://github.com/nuxt/ui/commit/d25265c8b7d34e01af8827d9af5eccb98bf30e9e) — fix: consistent alignement with other components

[`ba534`](https://github.com/nuxt/ui/commit/ba534f18b94383c97b2654d892ee4b8b024b3fab) — fix: prevent hover background on disabled items

[`d227a`](https://github.com/nuxt/ui/commit/d227a105d8d409ea0753153afaecf639ddb80fed) — fix: increase input font size to avoid zoom

[`bc61d`](https://github.com/nuxt/ui/commit/bc61d29cce531715a6279444845f02a002a22af7) — fix: use `group.id` as key

[`06dfb`](https://github.com/nuxt/ui/commit/06dfb963be16a5145c502c6758c7146b0cd3e1c9) — chore: improve `placeholder` tsdoc

[`b9983`](https://github.com/nuxt/ui/commit/b9983549a4b743724ea3ef99cc4a243f5ca41e53) — fix: improve generic types ([#3331](https://github.com/nuxt/ui/issues/3331))

[`ef861`](https://github.com/nuxt/ui/commit/ef86108f14da23fa292afe016517eac95c34bf76) — chore: add eol in script tag to fix syntax highlight