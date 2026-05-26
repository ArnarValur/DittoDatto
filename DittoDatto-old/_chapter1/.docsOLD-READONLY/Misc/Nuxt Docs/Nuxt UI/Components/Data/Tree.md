---
title: "Vue Tree Component"
source: "https://ui.nuxt.com/docs/components/tree"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A tree view component to display and interact with hierarchical data structures."
tags:
---
## Tree

[Tree](https://reka-ui.com/docs/components/tree) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Tree.vue)

A tree view component to display and interact with hierarchical data structures.

## Usage

Use the Tree component to display a hierarchical structure of items.

```
<script setup lang="ts">

import type { TreeItem } from '@nuxt/ui'

const items = ref<TreeItem[]>([

  {

    label: 'app/',

    defaultExpanded: true,

    children: [

      {

        label: 'composables/',

        children: [

          {

            label: 'useAuth.ts',

            icon: 'i-vscode-icons-file-type-typescript'

          },

          {

            label: 'useUser.ts',

            icon: 'i-vscode-icons-file-type-typescript'

          }

        ]

      },

      {

        label: 'components/',

        defaultExpanded: true,

        children: [

          {

            label: 'Card.vue',

            icon: 'i-vscode-icons-file-type-vue'

          },

          {

            label: 'Button.vue',

            icon: 'i-vscode-icons-file-type-vue'

          }

        ]

      }

    ]

  },

  {

    label: 'app.vue',

    icon: 'i-vscode-icons-file-type-vue'

  },

  {

    label: 'nuxt.config.ts',

    icon: 'i-vscode-icons-file-type-nuxt'

  }

])

</script>

<template>

  <UTree :items="items" />

</template>
```

### Items

Use the `items` prop as an array of objects with the following properties:

- `icon?: string`
- `label?: string`
- `trailingIcon?: string`
- `defaultExpanded?: boolean`
- `disabled?: boolean`
- `slot?: string`
- `children?: TreeItem[]`
- `onToggle?: (e: TreeItemToggleEvent<TreeItem>) => void`
- `onSelect?: (e: TreeItemSelectEvent<TreeItem>) => void`
- `class?: any`
- `ui?: { item?: ClassNameValue, itemWithChildren?: ClassNameValue, link?: ClassNameValue, linkLeadingIcon?: ClassNameValue, linkLabel?: ClassNameValue, linkTrailing?: ClassNameValue, linkTrailingIcon?: ClassNameValue, listWithChildren?: ClassNameValue }`

A unique identifier is required for each item. The component will use the `label` prop as identifier if no `get-key` is provided. Ideally you should provide a `get-key` function prop to return a unique identifier. Alternatively, you can use the `labelKey` prop to specify which property to use as the unique identifier.

```
<script setup lang="ts">

import type { TreeItem } from '@nuxt/ui'

const items = ref<TreeItem[]>([

  {

    label: 'app/',

    defaultExpanded: true,

    children: [

      {

        label: 'composables/',

        children: [

          {

            label: 'useAuth.ts',

            icon: 'i-vscode-icons-file-type-typescript'

          },

          {

            label: 'useUser.ts',

            icon: 'i-vscode-icons-file-type-typescript'

          }

        ]

      },

      {

        label: 'components/',

        defaultExpanded: true,

        children: [

          {

            label: 'Card.vue',

            icon: 'i-vscode-icons-file-type-vue'

          },

          {

            label: 'Button.vue',

            icon: 'i-vscode-icons-file-type-vue'

          }

        ]

      }

    ]

  },

  {

    label: 'app.vue',

    icon: 'i-vscode-icons-file-type-vue'

  },

  {

    label: 'nuxt.config.ts',

    icon: 'i-vscode-icons-file-type-nuxt'

  }

])

</script>

<template>

  <UTree :items="items" />

</template>
```

### Multiple

Use the `multiple` prop to allow multiple item selections.

```
<script setup lang="ts">

import type { TreeItem } from '@nuxt/ui'

const items = ref<TreeItem[]>([

  {

    label: 'app/',

    defaultExpanded: true,

    children: [

      {

        label: 'composables/',

        children: [

          {

            label: 'useAuth.ts',

            icon: 'i-vscode-icons-file-type-typescript'

          },

          {

            label: 'useUser.ts',

            icon: 'i-vscode-icons-file-type-typescript'

          }

        ]

      },

      {

        label: 'components/',

        defaultExpanded: true,

        children: [

          {

            label: 'Card.vue',

            icon: 'i-vscode-icons-file-type-vue'

          },

          {

            label: 'Button.vue',

            icon: 'i-vscode-icons-file-type-vue'

          }

        ]

      }

    ]

  },

  {

    label: 'app.vue',

    icon: 'i-vscode-icons-file-type-vue'

  },

  {

    label: 'nuxt.config.ts',

    icon: 'i-vscode-icons-file-type-nuxt'

  }

])

</script>

<template>

  <UTree multiple :items="items" />

</template>
```

### Nested 4.1+

Use the `nested` prop to control whether the Tree is rendered with nested structure or as a flat list. Defaults to `true`.

```
<script setup lang="ts">

import type { TreeItem } from '@nuxt/ui'

const items = ref<TreeItem[]>([

  {

    label: 'app/',

    defaultExpanded: true,

    children: [

      {

        label: 'composables/',

        children: [

          {

            label: 'useAuth.ts',

            icon: 'i-vscode-icons-file-type-typescript'

          },

          {

            label: 'useUser.ts',

            icon: 'i-vscode-icons-file-type-typescript'

          }

        ]

      },

      {

        label: 'components/',

        defaultExpanded: true,

        children: [

          {

            label: 'Card.vue',

            icon: 'i-vscode-icons-file-type-vue'

          },

          {

            label: 'Button.vue',

            icon: 'i-vscode-icons-file-type-vue'

          }

        ]

      }

    ]

  },

  {

    label: 'app.vue',

    icon: 'i-vscode-icons-file-type-vue'

  },

  {

    label: 'nuxt.config.ts',

    icon: 'i-vscode-icons-file-type-nuxt'

  }

])

</script>

<template>

  <UTree :nested="false" :items="items" />

</template>
```

When `nested` is `false`, all items are rendered at the same level with indentation to indicate hierarchy. This is useful for virtualization or drag and drop functionality.

### Color

Use the `color` prop to change the color of the Tree.

```
<script setup lang="ts">

import type { TreeItem } from '@nuxt/ui'

const items = ref<TreeItem[]>([

  {

    label: 'app/',

    defaultExpanded: true,

    children: [

      {

        label: 'composables/',

        children: [

          {

            label: 'useAuth.ts',

            icon: 'i-vscode-icons-file-type-typescript'

          },

          {

            label: 'useUser.ts',

            icon: 'i-vscode-icons-file-type-typescript'

          }

        ]

      },

      {

        label: 'components/',

        defaultExpanded: true,

        children: [

          {

            label: 'Card.vue',

            icon: 'i-vscode-icons-file-type-vue'

          },

          {

            label: 'Button.vue',

            icon: 'i-vscode-icons-file-type-vue'

          }

        ]

      }

    ]

  },

  {

    label: 'app.vue',

    icon: 'i-vscode-icons-file-type-vue'

  },

  {

    label: 'nuxt.config.ts',

    icon: 'i-vscode-icons-file-type-nuxt'

  }

])

</script>

<template>

  <UTree color="neutral" :items="items" />

</template>
```

### Size

Use the `size` prop to change the size of the Tree.

```
<script setup lang="ts">

import type { TreeItem } from '@nuxt/ui'

const items = ref<TreeItem[]>([

  {

    label: 'app/',

    defaultExpanded: true,

    children: [

      {

        label: 'composables/',

        children: [

          {

            label: 'useAuth.ts',

            icon: 'i-vscode-icons-file-type-typescript'

          },

          {

            label: 'useUser.ts',

            icon: 'i-vscode-icons-file-type-typescript'

          }

        ]

      },

      {

        label: 'components/',

        defaultExpanded: true,

        children: [

          {

            label: 'Card.vue',

            icon: 'i-vscode-icons-file-type-vue'

          },

          {

            label: 'Button.vue',

            icon: 'i-vscode-icons-file-type-vue'

          }

        ]

      }

    ]

  },

  {

    label: 'app.vue',

    icon: 'i-vscode-icons-file-type-vue'

  },

  {

    label: 'nuxt.config.ts',

    icon: 'i-vscode-icons-file-type-nuxt'

  }

])

</script>

<template>

  <UTree size="xl" :items="items" />

</template>
```

### Trailing Icon

Use the `trailing-icon` prop to customize the trailing [Icon](https://ui.nuxt.com/docs/components/icon) of a parent node. Defaults to `i-lucide-chevron-down`.

If an icon is specified for an item, it will always take precedence over these props.

```
<script setup lang="ts">

import type { TreeItem } from '@nuxt/ui'

const items = ref<TreeItem[]>([

  {

    label: 'app/',

    defaultExpanded: true,

    children: [

      {

        label: 'composables/',

        trailingIcon: 'i-lucide-chevron-down',

        children: [

          {

            label: 'useAuth.ts',

            icon: 'i-vscode-icons-file-type-typescript'

          },

          {

            label: 'useUser.ts',

            icon: 'i-vscode-icons-file-type-typescript'

          }

        ]

      },

      {

        label: 'components/',

        defaultExpanded: true,

        children: [

          {

            label: 'Card.vue',

            icon: 'i-vscode-icons-file-type-vue'

          },

          {

            label: 'Button.vue',

            icon: 'i-vscode-icons-file-type-vue'

          }

        ]

      }

    ]

  },

  {

    label: 'app.vue',

    icon: 'i-vscode-icons-file-type-vue'

  },

  {

    label: 'nuxt.config.ts',

    icon: 'i-vscode-icons-file-type-nuxt'

  }

])

</script>

<template>

  <UTree trailing-icon="i-lucide-arrow-down" :items="items" />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.chevronDown` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.chevronDown` key.

### Expanded Icon

Use the `expanded-icon` and `collapsed-icon` props to customize the icons of a parent node when it is expanded or collapsed. Defaults to `i-lucide-folder-open` and `i-lucide-folder` respectively.

```
<script setup lang="ts">

import type { TreeItem } from '@nuxt/ui'

const items = ref<TreeItem[]>([

  {

    label: 'app/',

    defaultExpanded: true,

    children: [

      {

        label: 'composables/',

        children: [

          {

            label: 'useAuth.ts',

            icon: 'i-vscode-icons-file-type-typescript'

          },

          {

            label: 'useUser.ts',

            icon: 'i-vscode-icons-file-type-typescript'

          }

        ]

      },

      {

        label: 'components/',

        defaultExpanded: true,

        children: [

          {

            label: 'Card.vue',

            icon: 'i-vscode-icons-file-type-vue'

          },

          {

            label: 'Button.vue',

            icon: 'i-vscode-icons-file-type-vue'

          }

        ]

      }

    ]

  },

  {

    label: 'app.vue',

    icon: 'i-vscode-icons-file-type-vue'

  },

  {

    label: 'nuxt.config.ts',

    icon: 'i-vscode-icons-file-type-nuxt'

  }

])

</script>

<template>

  <UTree expanded-icon="i-lucide-book-open" collapsed-icon="i-lucide-book" :items="items" />

</template>
```

You can customize these icons globally in your `app.config.ts` under `ui.icons.folder` and `ui.icons.folderOpen` keys.

You can customize these icons globally in your `vite.config.ts` under `ui.icons.folder` and `ui.icons.folderOpen` keys.

### Disabled

Use the `disabled` prop to prevent any user interaction with the Tree.

```
<script setup lang="ts">

import type { TreeItem } from '@nuxt/ui'

const items = ref<TreeItem[]>([

  {

    label: 'app',

    icon: 'i-lucide-folder',

    defaultExpanded: true,

    children: [

      {

        label: 'composables',

        icon: 'i-lucide-folder',

        children: [

          {

            label: 'useAuth.ts',

            icon: 'i-vscode-icons-file-type-typescript'

          },

          {

            label: 'useUser.ts',

            icon: 'i-vscode-icons-file-type-typescript'

          }

        ]

      },

      {

        label: 'components',

        icon: 'i-lucide-folder',

        children: [

          {

            label: 'Home',

            icon: 'i-lucide-folder',

            children: [

              {

                label: 'Card.vue',

                icon: 'i-vscode-icons-file-type-vue'

              },

              {

                label: 'Button.vue',

                icon: 'i-vscode-icons-file-type-vue'

              }

            ]

          }

        ]

      }

    ]

  },

  {

    label: 'app.vue',

    icon: 'i-vscode-icons-file-type-vue'

  },

  {

    label: 'nuxt.config.ts',

    icon: 'i-vscode-icons-file-type-nuxt'

  }

])

</script>

<template>

  <UTree disabled :items="items" />

</template>
```

You can also disable individual items using `item.disabled`.

## Examples

### Control selected item(s)

You can control the selected item(s) by using the `default-value` prop or the `v-model` directive.

```
<script setup lang="ts">

import type { TreeItem } from '@nuxt/ui'

const items: TreeItem[] = [

  {

    label: 'app/',

    defaultExpanded: true,

    children: [

      {

        label: 'composables/',

        children: [

          { label: 'useAuth.ts', icon: 'i-vscode-icons-file-type-typescript' },

          { label: 'useUser.ts', icon: 'i-vscode-icons-file-type-typescript' }

        ]

      },

      {

        label: 'components/',

        defaultExpanded: true,

        children: [

          { label: 'Card.vue', icon: 'i-vscode-icons-file-type-vue' },

          { label: 'Button.vue', icon: 'i-vscode-icons-file-type-vue' }

        ]

      }

    ]

  },

  { label: 'app.vue', icon: 'i-vscode-icons-file-type-vue' },

  { label: 'nuxt.config.ts', icon: 'i-vscode-icons-file-type-nuxt' }

]

const value = ref()

</script>

<template>

  <UTree v-model="value" :items="items" />

</template>
```

Use the `get-key` prop to change the function used to get the unique key from each item when a `v-model` or `default-value` is provided.

If you want to prevent an item from being selected, you can use the `item.onSelect()` property or the global `select` event:

```
<script setup lang="ts">

import type { TreeItemSelectEvent } from 'reka-ui'

import type { TreeItem } from '@nuxt/ui'

const items: TreeItem[] = [

  {

    label: 'app/',

    defaultExpanded: true,

    onSelect: (e: Event) => {

      e.preventDefault()

    },

    children: [

      {

        label: 'composables/',

        children: [

          { label: 'useAuth.ts', icon: 'i-vscode-icons-file-type-typescript' },

          { label: 'useUser.ts', icon: 'i-vscode-icons-file-type-typescript' }

        ]

      },

      {

        label: 'components/',

        defaultExpanded: true,

        children: [

          { label: 'Card.vue', icon: 'i-vscode-icons-file-type-vue' },

          { label: 'Button.vue', icon: 'i-vscode-icons-file-type-vue' }

        ]

      }

    ]

  },

  { label: 'app.vue', icon: 'i-vscode-icons-file-type-vue' },

  { label: 'nuxt.config.ts', icon: 'i-vscode-icons-file-type-nuxt' }

]

function onSelect(e: TreeItemSelectEvent<TreeItem>) {

  if (e.detail.originalEvent.type === 'click') {

    e.preventDefault()

  }

}

</script>

<template>

  <UTree :items="items" @select="onSelect" />

</template>
```

This lets you expand or collapse a parent item without selecting it.

### Control expanded items

You can control the expanded items by using the `default-expanded` prop or the `v-model` directive.

```
<script setup lang="ts">

import type { TreeItem } from '@nuxt/ui'

const items = [

  {

    label: 'app/',

    id: 'app',

    children: [

      {

        label: 'composables/',

        id: 'app/composables',

        children: [

          { label: 'useAuth.ts', icon: 'i-vscode-icons-file-type-typescript' },

          { label: 'useUser.ts', icon: 'i-vscode-icons-file-type-typescript' }

        ]

      },

      {

        label: 'components/',

        id: 'app/components',

        children: [

          { label: 'Card.vue', icon: 'i-vscode-icons-file-type-vue' },

          { label: 'Button.vue', icon: 'i-vscode-icons-file-type-vue' }

        ]

      }

    ]

  },

  { label: 'app.vue', id: 'app.vue', icon: 'i-vscode-icons-file-type-vue' },

  { label: 'nuxt.config.ts', id: 'nuxt.config.ts', icon: 'i-vscode-icons-file-type-nuxt' }

] satisfies TreeItem[]

const expanded = ref(['app', 'app/composables'])

</script>

<template>

  <UTree v-model:expanded="expanded" :items="items" :get-key="i => i.id" />

</template>
```

If you want to prevent an item from being expanded, you can use the `item.onToggle()` property or the global `toggle` event:

```
<script setup lang="ts">

import type { TreeItemToggleEvent } from 'reka-ui'

import type { TreeItem } from '@nuxt/ui'

const items: TreeItem[] = [

  {

    label: 'app/',

    defaultExpanded: true,

    onToggle: (e: Event) => {

      e.preventDefault()

    },

    children: [

      {

        label: 'composables/',

        children: [

          { label: 'useAuth.ts', icon: 'i-vscode-icons-file-type-typescript' },

          { label: 'useUser.ts', icon: 'i-vscode-icons-file-type-typescript' }

        ]

      },

      {

        label: 'components/',

        defaultExpanded: true,

        children: [

          { label: 'Card.vue', icon: 'i-vscode-icons-file-type-vue' },

          { label: 'Button.vue', icon: 'i-vscode-icons-file-type-vue' }

        ]

      }

    ]

  },

  { label: 'app.vue', icon: 'i-vscode-icons-file-type-vue' },

  { label: 'nuxt.config.ts', icon: 'i-vscode-icons-file-type-nuxt' }

]

function onToggle(e: TreeItemToggleEvent<TreeItem>) {

  if (e.detail.originalEvent.type === 'keydown') {

    e.preventDefault()

  }

}

</script>

<template>

  <UTree :items="items" @toggle="onToggle" />

</template>
```

This lets you select a parent item without expanding or collapsing its children.

### With checkbox in items 4.1+

You can use the `item-leading` slot to add a [Checkbox](https://ui.nuxt.com/docs/components/checkbox) to the items. Use the `multiple`, `propagate-select` and `bubble-select` props to enable multi-selection with parent-child relationship and the `select` and `toggle` events to control the selected and expanded state of the items.

```
<script setup lang="ts">

import type { TreeItemSelectEvent } from 'reka-ui'

import type { TreeItem } from '@nuxt/ui'

const items: TreeItem[] = [

  {

    label: 'app/',

    defaultExpanded: true,

    children: [

      {

        label: 'composables/',

        children: [

          { label: 'useAuth.ts' },

          { label: 'useUser.ts' }

        ]

      },

      {

        label: 'components/',

        defaultExpanded: true,

        children: [

          { label: 'Card.vue' },

          { label: 'Button.vue' }

        ]

      }

    ]

  },

  { label: 'app.vue' },

  { label: 'nuxt.config.ts' }

]

const value = ref<(typeof items)>([])

function onSelect(e: TreeItemSelectEvent<TreeItem>) {

  if (e.detail.originalEvent.type === 'click') {

    e.preventDefault()

  }

}

</script>

<template>

  <UTree

    v-model="value"

    :as="{ link: 'div' }"

    :items="items"

    multiple

    propagate-select

    bubble-select

    @select="onSelect"

  >

    <template #item-leading="{ selected, indeterminate, handleSelect }">

      <UCheckbox

        :model-value="indeterminate ? 'indeterminate' : selected"

        tabindex="-1"

        @change="handleSelect"

        @click.stop

      />

    </template>

  </UTree>

</template>
```

This example uses the `as` prop to change the items from `button` to `div` as the [`Checkbox`](https://ui.nuxt.com/docs/components/checkbox) is also rendered as a `button`.

### With drag and drop 4.1+

Use the [`useSortable`](https://vueuse.org/integrations/useSortable/) composable from [`@vueuse/integrations`](https://vueuse.org/integrations/README.html) to enable drag and drop functionality on the Tree. This integration wraps [Sortable.js](https://sortablejs.github.io/Sortable/) to provide a seamless drag and drop experience.

```
<script setup lang="ts">

import type { TreeItem } from '@nuxt/ui'

import { useSortable } from '@vueuse/integrations/useSortable'

const items = shallowRef<TreeItem[]>([

  {

    label: 'app/',

    defaultExpanded: true,

    children: [

      {

        label: 'composables/',

        children: [

          { label: 'useAuth.ts', icon: 'i-vscode-icons-file-type-typescript' },

          { label: 'useUser.ts', icon: 'i-vscode-icons-file-type-typescript' }

        ]

      },

      {

        label: 'components/',

        defaultExpanded: true,

        children: [

          { label: 'Card.vue', icon: 'i-vscode-icons-file-type-vue' },

          { label: 'Button.vue', icon: 'i-vscode-icons-file-type-vue' }

        ]

      }

    ]

  },

  { label: 'app.vue', icon: 'i-vscode-icons-file-type-vue' },

  { label: 'nuxt.config.ts', icon: 'i-vscode-icons-file-type-nuxt' }

])

function flatten(

  items: TreeItem[],

  parent = items

): { item: TreeItem; parent: TreeItem[]; index: number }[] {

  return items.flatMap((item, index) => [

    { item, parent, index },

    ...(item.children?.length && item.defaultExpanded ? flatten(item.children, item.children) : [])

  ])

}

function moveItem(oldIndex: number, newIndex: number) {

  if (oldIndex === newIndex) return

  const flat = flatten(items.value)

  const source = flat[oldIndex]

  const target = flat[newIndex]

  if (!source || !target) return

  const [moved] = source.parent.splice(source.index, 1)

  if (!moved) return

  const updatedFlat = flatten(items.value)

  const updatedTarget = updatedFlat.find(({ item }) => item === target.item)

  if (!updatedTarget) return

  const insertIndex = oldIndex < newIndex ? updatedTarget.index + 1 : updatedTarget.index

  updatedTarget.parent.splice(insertIndex, 0, moved)

}

const tree = useTemplateRef<HTMLElement>('tree')

useSortable(tree, items, {

  animation: 150,

  ghostClass: 'opacity-50',

  onUpdate: (e: any) => moveItem(e.oldIndex, e.newIndex)

})

</script>

<template>

  <UTree ref="tree" :nested="false" :unmount-on-hide="false" :items="items" />

</template>
```

This example sets the `nested` prop to `false` to have a flat list of items so that the items can be dragged and dropped.

### With virtualization 4.1+

Use the `virtualize` prop to enable virtualization for large lists as a boolean or an object with options like `{ estimateSize: 32, overscan: 12 }`.

When virtualization is enabled, the tree structure is flattened, similar to setting the `nested` prop to `false`.

```
<script setup lang="ts">

import type { TreeItem } from '@nuxt/ui'

const items: TreeItem[] = Array(1000)

  .fill(0)

  .map((_, i) => ({

    label: \`Item ${i + 1}\`,

    children: [

      { label: \`Child ${i + 1}-1\`, icon: 'i-lucide-file' },

      { label: \`Child ${i + 1}-2\`, icon: 'i-lucide-file' }

    ]

  }))

</script>

<template>

  <UTree virtualize :items="items" class="h-80" />

</template>
```

### With custom slot

Use the `slot` property to customize a specific item.

You will have access to the following slots:

- `#{{ item.slot }}-wrapper`
- `#{{ item.slot }}`
- `#{{ item.slot }}-leading`
- `#{{ item.slot }}-label`
- `#{{ item.slot }}-trailing`

```
<script setup lang="ts">

import type { TreeItem } from '@nuxt/ui'

const items = [

  {

    label: 'app/',

    slot: 'app' as const,

    defaultExpanded: true,

    children: [

      {

        label: 'composables/',

        children: [

          { label: 'useAuth.ts', icon: 'i-vscode-icons-file-type-typescript' },

          { label: 'useUser.ts', icon: 'i-vscode-icons-file-type-typescript' }

        ]

      },

      {

        label: 'components/',

        defaultExpanded: true,

        children: [

          { label: 'Card.vue', icon: 'i-vscode-icons-file-type-vue' },

          { label: 'Button.vue', icon: 'i-vscode-icons-file-type-vue' }

        ]

      }

    ]

  },

  { label: 'app.vue', icon: 'i-vscode-icons-file-type-vue' },

  { label: 'nuxt.config.ts', icon: 'i-vscode-icons-file-type-nuxt' }

] satisfies TreeItem[]

</script>

<template>

  <UTree :items="items">

    <template #app="{ item }">

      <p class="italic font-bold">

        {{ item.label }}

      </p>

    </template>

  </UTree>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'ul'` | `any`  The element or component this component should render as. |
| `color` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `size` | `'md'` | ` "md" \| "xs" \| "sm" \| "lg" \| "xl"` |
| `getKey` |  | ` (val: T[number]): string`  This function is passed the index of each item and should return a unique key for that item |
| `labelKey` | `'label'` | ` keyof Extract<NestedItem<T>, object> \| DotPathKeys<Extract<NestedItem<T>, object>>`  The key used to get the label from the item. |
| `trailingIcon` | `appConfig.ui.icons.chevronDown` | `any`  The icon displayed on the right side of a parent node. |
| `expandedIcon` | `appConfig.ui.icons.folderOpen` | `any`  The icon displayed when a parent node is expanded. |
| `collapsedIcon` | `appConfig.ui.icons.folder` | `any`  The icon displayed when a parent node is collapsed. |
| `items` |  | ` T` |
| `modelValue` |  | ` M extends true ? T[number][] : T[number]`  The controlled value of the Tree. Can be bind as `v-model`. |
| `defaultValue` |  | ` M extends true ? T[number][] : T[number]`  The value of the Tree when initially rendered. Use when you do not need to control the state of the Tree. |
| `multiple` |  | ` M`  Whether multiple options can be selected or not. |
| `nested` | `true` | `boolean`  Use nested DOM structure (children inside parents) vs flattened structure (all items at same level). When `virtualize` is enabled, this is automatically set to `false`. |
| `virtualize` | `false` | `boolean \| { overscan?: number ; estimateSize?: number \| ((index: number) => number) \| undefined; } \| undefined`  Enable virtualization for large lists. Note: when enabled, the tree structure is flattened like if `nested` was set to `false`. |
| `onSelect` |  | ` (e: SelectEvent$3<T[number]>, item: T[number]): void` |
| `onToggle` |  | ` (e: ToggleEvent<T[number]>, item: T[number]): void` |
| `expanded` |  | ` string[]`  The controlled value of the expanded item. Can be binded with with `v-model`. |
| `defaultExpanded` |  | ` string[]`  The value of the expanded tree when initially rendered. Use when you do not need to control the state of the expanded tree |
| `selectionBehavior` |  | ` "replace" \| "toggle"`  How multiple selection should behave in the collection. |
| `propagateSelect` |  | `boolean`  When `true`, selecting parent will select the descendants. |
| `disabled` |  | `boolean`  When `true`, prevents the user from interacting with tree |
| `bubbleSelect` |  | `boolean`  When `true`, selecting children will update the parent state. |
| `ui` |  | ` { root?: ClassNameValue; item?: ClassNameValue; listWithChildren?: ClassNameValue; itemWithChildren?: ClassNameValue; link?: ClassNameValue; linkLeadingIcon?: ClassNameValue; linkLabel?: ClassNameValue; linkTrailing?: ClassNameValue; linkTrailingIcon?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `item-wrapper` | `{ item: T[number]; index: number; level: number; expanded: boolean; selected: boolean; indeterminate: boolean \| undefined; handleSelect: () => void; handleToggle: () => void; ui: object; }` |
| `item` | `{ item: T[number]; index: number; level: number; expanded: boolean; selected: boolean; indeterminate: boolean \| undefined; handleSelect: () => void; handleToggle: () => void; ui: object; }` |
| `item-leading` | `{ item: T[number]; index: number; level: number; expanded: boolean; selected: boolean; indeterminate: boolean \| undefined; handleSelect: () => void; handleToggle: () => void; ui: object; }` |
| `item-label` | `{ item: T[number]; index: number; level: number; expanded: boolean; selected: boolean; indeterminate: boolean \| undefined; handleSelect: () => void; handleToggle: () => void; ui: object; }` |
| `item-trailing` | `{ item: T[number]; index: number; level: number; expanded: boolean; selected: boolean; indeterminate: boolean \| undefined; handleSelect: () => void; handleToggle: () => void; ui: object; }` |

### Emits

| Event | Type |
| --- | --- |
| `update:modelValue` | `[val: M extends true ? T[number][] : T[number]]` |
| `update:expanded` | `[val: string[]]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    tree: {

      slots: {

        root: 'relative isolate',

        item: 'w-full',

        listWithChildren: 'border-s border-default',

        itemWithChildren: 'ps-1.5 -ms-px',

        link: 'relative group w-full flex items-center text-sm select-none before:absolute before:inset-y-px before:inset-x-0 before:z-[-1] before:rounded-md focus:outline-none focus-visible:outline-none focus-visible:before:ring-inset focus-visible:before:ring-2',

        linkLeadingIcon: 'shrink-0 relative',

        linkLabel: 'truncate',

        linkTrailing: 'ms-auto inline-flex gap-1.5 items-center',

        linkTrailingIcon: 'shrink-0 transform transition-transform duration-200 group-data-expanded:rotate-180'

      },

      variants: {

        virtualize: {

          true: {

            root: 'overflow-y-auto'

          }

        },

        color: {

          primary: {

            link: 'focus-visible:before:ring-primary'

          },

          secondary: {

            link: 'focus-visible:before:ring-secondary'

          },

          success: {

            link: 'focus-visible:before:ring-success'

          },

          info: {

            link: 'focus-visible:before:ring-info'

          },

          warning: {

            link: 'focus-visible:before:ring-warning'

          },

          error: {

            link: 'focus-visible:before:ring-error'

          },

          neutral: {

            link: 'focus-visible:before:ring-inverted'

          }

        },

        size: {

          xs: {

            listWithChildren: 'ms-4',

            link: 'px-2 py-1 text-xs gap-1',

            linkLeadingIcon: 'size-4',

            linkTrailingIcon: 'size-4'

          },

          sm: {

            listWithChildren: 'ms-4.5',

            link: 'px-2.5 py-1.5 text-xs gap-1.5',

            linkLeadingIcon: 'size-4',

            linkTrailingIcon: 'size-4'

          },

          md: {

            listWithChildren: 'ms-5',

            link: 'px-2.5 py-1.5 text-sm gap-1.5',

            linkLeadingIcon: 'size-5',

            linkTrailingIcon: 'size-5'

          },

          lg: {

            listWithChildren: 'ms-5.5',

            link: 'px-3 py-2 text-sm gap-2',

            linkLeadingIcon: 'size-5',

            linkTrailingIcon: 'size-5'

          },

          xl: {

            listWithChildren: 'ms-6',

            link: 'px-3 py-2 text-base gap-2',

            linkLeadingIcon: 'size-6',

            linkTrailingIcon: 'size-6'

          }

        },

        selected: {

          true: {

            link: 'before:bg-elevated'

          }

        },

        disabled: {

          true: {

            link: 'cursor-not-allowed opacity-75'

          }

        }

      },

      compoundVariants: [

        {

          color: 'primary',

          selected: true,

          class: {

            link: 'text-primary'

          }

        },

        {

          color: 'neutral',

          selected: true,

          class: {

            link: 'text-highlighted'

          }

        },

        {

          selected: false,

          disabled: false,

          class: {

            link: [

              'hover:text-highlighted hover:before:bg-elevated/50',

              'transition-colors before:transition-colors'

            ]

          }

        }

      ],

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

        tree: {

          slots: {

            root: 'relative isolate',

            item: 'w-full',

            listWithChildren: 'border-s border-default',

            itemWithChildren: 'ps-1.5 -ms-px',

            link: 'relative group w-full flex items-center text-sm select-none before:absolute before:inset-y-px before:inset-x-0 before:z-[-1] before:rounded-md focus:outline-none focus-visible:outline-none focus-visible:before:ring-inset focus-visible:before:ring-2',

            linkLeadingIcon: 'shrink-0 relative',

            linkLabel: 'truncate',

            linkTrailing: 'ms-auto inline-flex gap-1.5 items-center',

            linkTrailingIcon: 'shrink-0 transform transition-transform duration-200 group-data-expanded:rotate-180'

          },

          variants: {

            virtualize: {

              true: {

                root: 'overflow-y-auto'

              }

            },

            color: {

              primary: {

                link: 'focus-visible:before:ring-primary'

              },

              secondary: {

                link: 'focus-visible:before:ring-secondary'

              },

              success: {

                link: 'focus-visible:before:ring-success'

              },

              info: {

                link: 'focus-visible:before:ring-info'

              },

              warning: {

                link: 'focus-visible:before:ring-warning'

              },

              error: {

                link: 'focus-visible:before:ring-error'

              },

              neutral: {

                link: 'focus-visible:before:ring-inverted'

              }

            },

            size: {

              xs: {

                listWithChildren: 'ms-4',

                link: 'px-2 py-1 text-xs gap-1',

                linkLeadingIcon: 'size-4',

                linkTrailingIcon: 'size-4'

              },

              sm: {

                listWithChildren: 'ms-4.5',

                link: 'px-2.5 py-1.5 text-xs gap-1.5',

                linkLeadingIcon: 'size-4',

                linkTrailingIcon: 'size-4'

              },

              md: {

                listWithChildren: 'ms-5',

                link: 'px-2.5 py-1.5 text-sm gap-1.5',

                linkLeadingIcon: 'size-5',

                linkTrailingIcon: 'size-5'

              },

              lg: {

                listWithChildren: 'ms-5.5',

                link: 'px-3 py-2 text-sm gap-2',

                linkLeadingIcon: 'size-5',

                linkTrailingIcon: 'size-5'

              },

              xl: {

                listWithChildren: 'ms-6',

                link: 'px-3 py-2 text-base gap-2',

                linkLeadingIcon: 'size-6',

                linkTrailingIcon: 'size-6'

              }

            },

            selected: {

              true: {

                link: 'before:bg-elevated'

              }

            },

            disabled: {

              true: {

                link: 'cursor-not-allowed opacity-75'

              }

            }

          },

          compoundVariants: [

            {

              color: 'primary',

              selected: true,

              class: {

                link: 'text-primary'

              }

            },

            {

              color: 'neutral',

              selected: true,

              class: {

                link: 'text-highlighted'

              }

            },

            {

              selected: false,

              disabled: false,

              class: {

                link: [

                  'hover:text-highlighted hover:before:bg-elevated/50',

                  'transition-colors before:transition-colors'

                ]

              }

            }

          ],

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

Some colors in `compoundVariants` are omitted for readability. Check out the source code on GitHub.

## Changelog

[`d51b4`](https://github.com/nuxt/ui/commit/d51b424d9e306c25fc7dc32857011ffaffe56d7e) — feat: handle virtualizer `estimateSize` as function ([#5748](https://github.com/nuxt/ui/issues/5748))

[`56ae8`](https://github.com/nuxt/ui/commit/56ae8e7199b8d5e3b5a169bd63c767724abfb582) — fix: calc virtualizer estimateSize based on item description

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`fce2d`](https://github.com/nuxt/ui/commit/fce2df4e0660d0bdb3cdd4fb3041416824cbe893) — fix!: consistent exposed refs ([#5385](https://github.com/nuxt/ui/issues/5385))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`fcf61`](https://github.com/nuxt/ui/commit/fcf61173abf40b0a956d699363b5ac31991fc4d9) — feat: expose `$el` for drag and drop example ([#5239](https://github.com/nuxt/ui/issues/5239))

[`84f87`](https://github.com/nuxt/ui/commit/84f87a5953b508d74662dd3e81715ee86e75d71f) — feat: add global event handlers and checkbox example ([#5195](https://github.com/nuxt/ui/issues/5195))

[`70aaf`](https://github.com/nuxt/ui/commit/70aaf4a3aa00b77804d6783601736b0f6a3c075e) — fix: restore item wrapper with `presentation` role

[`c8b01`](https://github.com/nuxt/ui/commit/c8b01c9026e0920e9a1dc68f265b5e681665038b) — feat: provide additional slot props ([#5194](https://github.com/nuxt/ui/issues/5194))

[`c744d`](https://github.com/nuxt/ui/commit/c744d6ff82424365acc9f5489a5352e5e552b5f6) — feat: implement virtualization ([#5162](https://github.com/nuxt/ui/issues/5162))

[`240ff`](https://github.com/nuxt/ui/commit/240ff4266d2ac7a1c60ad271eb95aad77d842f65) — fix: remove `value-key` in favor of `get-key` ([#4999](https://github.com/nuxt/ui/issues/4999))

[`117b4`](https://github.com/nuxt/ui/commit/117b4b36acae3f91f6e9a57ff772c62a1930f56a) — fix: improve accessibility ([#4945](https://github.com/nuxt/ui/issues/4945))

[`11a03`](https://github.com/nuxt/ui/commit/11a03201ed8454f37e911db4a14b00f74104932a) — fix: dot notation type support for `labelKey` and `valueKey` ([#4933](https://github.com/nuxt/ui/issues/4933))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`411d9`](https://github.com/nuxt/ui/commit/411d93710a13a364340609c3219419dab36332cc) — feat: add `item-wrapper` slot ([#4521](https://github.com/nuxt/ui/issues/4521))

[`fc24e`](https://github.com/nuxt/ui/commit/fc24e03cc4b0d38dd4f64d739eeaf18de5e744e0) — fix: add type to button elements for accessibility ([#4493](https://github.com/nuxt/ui/issues/4493))

[`836f7`](https://github.com/nuxt/ui/commit/836f74849be7a91004be7734d45c50535b9f5973) — fix: proxy fallthrough attributes

[`f7613`](https://github.com/nuxt/ui/commit/f761369888c49fd0ee0f028dcf3c55dd5fbd2cae) — chore: update dependency reka-ui to ^2.3.0 (v3) ([#4234](https://github.com/nuxt/ui/issues/4234))

[`0905b`](https://github.com/nuxt/ui/commit/0905b2b3d5e99ac78740a15d7a1afa1263ac7491) — chore: move back `item.class` on link

[`b9adc`](https://github.com/nuxt/ui/commit/b9adc83e787db02507e6e7bb1aabc684eccc197b) — feat: add `ui` field in items ([#4060](https://github.com/nuxt/ui/issues/4060))

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`3deed`](https://github.com/nuxt/ui/commit/3deed4c271cad4adc2a4c47d5dd02e95a14ce11a) — fix: simplify reusable template types ([#3836](https://github.com/nuxt/ui/issues/3836))

[`b9983`](https://github.com/nuxt/ui/commit/b9983549a4b743724ea3ef99cc4a243f5ca41e53) — fix: improve generic types ([#3331](https://github.com/nuxt/ui/issues/3331))

[`ef861`](https://github.com/nuxt/ui/commit/ef86108f14da23fa292afe016517eac95c34bf76) — chore: add eol in script tag to fix syntax highlight[Timeline](https://ui.nuxt.com/docs/components/timeline)

[

A component that displays a sequence of events with dates, titles, icons or avatars.

](https://ui.nuxt.com/docs/components/timeline)[

User

Display user information with name, description and avatar.

](https://ui.nuxt.com/docs/components/user)