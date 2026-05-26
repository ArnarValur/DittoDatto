---
title: "Vue ScrollArea Component"
source: "https://ui.nuxt.com/docs/components/scroll-area"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A flexible scroll container with virtualization support."
tags:
---
A flexible scroll container with virtualization support.

## Usage

The ScrollArea component creates scrollable containers with optional virtualization for large lists.

```
<script setup lang="ts">

const heights = [320, 480, 640, 800]

// Pseudo-random height selection with longer cycle to avoid alignment patterns

function getHeight(index: number) {

  const seed = (index * 11 + 7) % 17

  return heights[seed % heights.length]!

}

const items = Array.from({ length: 1000 }).map((_, index) => {

  const height = getHeight(index)

  return {

    id: index,

    title: \`Item ${index + 1}\`,

    src: \`https://picsum.photos/640/${height}?v=${index}\`,

    width: 640,

    height

  }

})

</script>

<template>

  <UScrollArea

    v-slot="{ item, index }"

    :items="items"

    orientation="vertical"

    :virtualize="{

      gap: 16,

      lanes: 3,

      estimateSize: 480

    }"

    class="w-full h-128 p-4"

  >

    <img

      :src="item.src"

      :alt="item.title"

      :width="item.width"

      :height="item.height"

      :loading="index > 8 ? 'lazy' : 'eager'"

      class="rounded-md size-full object-cover"

    >

  </UScrollArea>

</template>
```

### Items

Use the `items` prop as an array and render each item using the default slot:

```
<script setup lang="ts">

const items = Array.from({ length: 30 }, (_, i) => ({

  id: i + 1,

  title: \`Item ${i + 1}\`,

  description: \`Description for item ${i + 1}\`

}))

</script>

<template>

  <UScrollArea

    v-slot="{ item, index }"

    :items="items"

    class="w-full h-96"

  >

    <UPageCard

      v-bind="item"

      :variant="index % 2 === 0 ? 'soft' : 'outline'"

      class="rounded-none"

    />

  </UScrollArea>

</template>
```

You can also use the default slot without the `items` prop to render custom scrollable content directly.

### Orientation

Use the `orientation` prop to change the scroll direction. Defaults to `vertical`.

```
<script setup lang="ts">

defineProps<{

  orientation?: 'vertical' | 'horizontal'

}>()

const items = Array.from({ length: 30 }, (_, i) => ({

  id: i + 1,

  title: \`Item ${i + 1}\`,

  description: \`Description for item ${i + 1}\`

}))

</script>

<template>

  <UScrollArea

    v-slot="{ item, index }"

    :items="items"

    :orientation="orientation"

    class="w-full data-[orientation=vertical]:h-96"

  >

    <UPageCard

      v-bind="item"

      :variant="index % 2 === 0 ? 'soft' : 'outline'"

      class="rounded-none"

    />

  </UScrollArea>

</template>
```

### Virtualize

Use the `virtualize` prop to render only the items currently in view, significantly boosting performance when working with large datasets.

When virtualization is **enabled**, customize spacing via the `virtualize` prop options like `gap`, `paddingStart`, and `paddingEnd`. Otherwise, use the `ui` prop to apply classes like `gap p-4` on the `viewport` slot.

```
<script setup lang="ts">

defineProps<{

  orientation?: 'vertical' | 'horizontal'

}>()

const items = computed(() => Array.from({ length: 1000 }, (_, i) => ({

  id: i + 1,

  title: \`Item ${i + 1}\`,

  description: \`Description for item ${i + 1}\`

})))

</script>

<template>

  <UScrollArea

    v-slot="{ item, index }"

    :items="items"

    :orientation="orientation"

    virtualize

    class="w-full data-[orientation=vertical]:h-96 data-[orientation=horizontal]:h-24.5"

  >

    <UPageCard

      v-bind="item"

      :variant="index % 2 === 0 ? 'soft' : 'outline'"

      class="rounded-none"

    />

  </UScrollArea>

</template>
```

## Examples

### As masonry layout

Use the `virtualize` prop with `lanes`, `gap`, and `estimateSize` options to create Pinterest-style masonry layouts with variable height items.

```
<script setup lang="ts">

withDefaults(defineProps<{

  orientation?: 'vertical' | 'horizontal'

  lanes?: number

  gap?: number

}>(), {

  orientation: 'vertical',

  lanes: 3,

  gap: 16

})

const heights = [320, 480, 640, 800]

function getHeight(index: number) {

  const seed = (index * 11 + 7) % 17

  return heights[seed % heights.length]!

}

const items = Array.from({ length: 1000 }).map((_, index) => {

  const height = getHeight(index)

  return {

    id: index,

    title: \`Item ${index + 1}\`,

    src: \`https://picsum.photos/640/${height}?v=${index}\`,

    width: 640,

    height

  }

})

</script>

<template>

  <UScrollArea

    v-slot="{ item }"

    :items="items"

    :orientation="orientation"

    :virtualize="{

      gap,

      lanes,

      estimateSize: 480

    }"

    class="w-full h-128 p-4"

  >

    <img

      :src="item.src"

      :alt="item.title"

      :width="item.width"

      :height="item.height"

      loading="lazy"

      class="rounded-md size-full object-cover"

    >

  </UScrollArea>

</template>
```

For optimal performance, set `estimateSize` close to your average item height. Increasing `overscan` improves scrolling smoothness but renders more off-screen items.

### With responsive lanes

You can use the [`useWindowSize`](https://vueuse.org/core/useWindowSize/) (for viewport-based) or [`useElementSize`](https://vueuse.org/core/useElementSize/) (for container-based) composables to make the `lanes` reactive.

```
<script setup lang="ts">

const items = Array.from({ length: 1000 }).map((_, index) => ({

  id: index,

  title: \`Item ${index + 1}\`,

  src: \`https://picsum.photos/640/480?v=${index}\`,

  width: 640,

  height: 480

}))

const scrollArea = useTemplateRef('scrollArea')

const { width } = useElementSize(() => scrollArea.value?.$el)

const lanes = computed(() => Math.max(1, Math.min(4, Math.floor(width.value / 200))))

</script>

<template>

  <UScrollArea

    ref="scrollArea"

    v-slot="{ item }"

    :items="items"

    :virtualize="{

      lanes,

      estimateSize: 148,

      gap: 16

    }"

    class="w-full h-96 p-4"

  >

    <img

      :src="item.src"

      :alt="item.title"

      :width="item.width"

      :height="item.height"

      loading="lazy"

      class="rounded-md size-full object-cover"

    >

  </UScrollArea>

</template>
```

### With programmatic scroll

You can use the exposed `virtualizer` to programmatically control scroll position.

```
<script setup lang="ts">

const items = computed(() => Array.from({ length: 1000 }, (_, i) => ({

  id: i + 1,

  title: \`Item ${i + 1}\`

})))

const scrollArea = useTemplateRef('scrollArea')

const targetIndex = ref(500)

function scrollToTop() {

  scrollArea.value?.virtualizer?.scrollToIndex(0, { align: 'start', behavior: 'smooth' })

}

function scrollToBottom() {

  scrollArea.value?.virtualizer?.scrollToIndex(items.value.length - 1, { align: 'end', behavior: 'smooth' })

}

function scrollToItem(index: number) {

  scrollArea.value?.virtualizer?.scrollToIndex(index - 1, { align: 'center', behavior: 'smooth' })

}

</script>

<template>

  <div class="w-full">

    <UScrollArea

      v-slot="{ item, index }"

      ref="scrollArea"

      :items="items"

      :virtualize="{ estimateSize: 72 }"

      class="h-96 w-full"

    >

      <UPageCard

        v-bind="item"

        :variant="index % 2 === 0 ? 'soft' : 'outline'"

        class="rounded-none isolate"

        :class="[index === (targetIndex - 1) && 'bg-primary']"

      />

    </UScrollArea>

    <UFieldGroup size="sm" class="px-4 py-3 border-t border-muted w-full">

      <UButton icon="i-lucide-arrow-up-to-line" color="neutral" variant="outline" @click="scrollToTop">

        Top

      </UButton>

      <UButton icon="i-lucide-arrow-down-to-line" color="neutral" variant="outline" @click="scrollToBottom">

        Bottom

      </UButton>

      <UButton icon="i-lucide-navigation" color="neutral" variant="outline" @click="scrollToItem(targetIndex || 500)">

        Go to {{ targetIndex || 500 }}

      </UButton>

    </UFieldGroup>

  </div>

</template>
```

### With infinite scroll

You can use the [`useInfiniteScroll`](https://vueuse.org/core/useInfiniteScroll/) composable to load more data as the user scrolls.

```
<script setup lang="ts">

import { useInfiniteScroll } from '@vueuse/core'

type User = {

  id: number

  firstName: string

  lastName: string

  username: string

  email: string

  image: string

}

type UserResponse = {

  users: User[]

  total: number

  skip: number

  limit: number

}

const skip = ref(0)

const { data, status, execute } = await useFetch(

  'https://dummyjson.com/users?limit=10&select=firstName,lastName,username,email,image',

  {

    key: 'scroll-area-users-infinite-scroll',

    params: { skip },

    transform: (data?: UserResponse) => {

      return data?.users

    },

    lazy: true,

    immediate: false

  }

)

const users = ref<User[]>([])

watch(data, () => {

  users.value = [...users.value, ...(data.value || [])]

})

execute()

const scrollArea = useTemplateRef('scrollArea')

onMounted(() => {

  useInfiniteScroll(

    scrollArea.value?.$el,

    () => {

      skip.value += 10

    },

    {

      distance: 200,

      canLoadMore: () => {

        return status.value !== 'pending'

      }

    }

  )

})

</script>

<template>

  <UScrollArea

    ref="scrollArea"

    v-slot="{ item }"

    :items="users"

    :virtualize="{ estimateSize: 88 }"

    class="h-96 w-full"

  >

    <UPageCard orientation="horizontal" class="rounded-none">

      <UUser

        :name="\`${item.firstName} ${item.lastName}\`"

        :description="item.email"

        :avatar="{ src: item.image, alt: item.firstName, loading: 'lazy' }"

        size="lg"

      />

    </UPageCard>

  </UScrollArea>

  <UProgress

    v-if="status === 'pending'"

    indeterminate

    size="xs"

    class="absolute top-0 inset-x-0 z-1"

    :ui="{ base: 'bg-default' }"

  />

</template>
```

### With default slot

You can use the default slot without the `items` prop to render custom scrollable content directly.

```
<template>

  <UScrollArea class="h-96 w-full" :ui="{ viewport: 'gap-4 p-4' }">

    <UPageCard title="Section 1" description="Custom content without using the items prop." />

    <UPageCard title="Section 2" description="Custom content without using the items prop." />

    <UPageCard title="Section 3" description="Custom content without using the items prop." />

    <UPageCard title="Section 4" description="Custom content without using the items prop." />

    <UPageCard title="Section 5" description="Custom content without using the items prop." />

    <UPageCard title="Section 6" description="Custom content without using the items prop." />

  </UScrollArea>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `orientation` | `'vertical'` | ` "vertical" \| "horizontal"`  The scroll direction. |
| `items` |  | ` T[]`  Array of items to render. |
| `virtualize` | `false` | `boolean \| ScrollAreaVirtualizeOptions`  Enable virtualization for large lists.  - [https://tanstack.com/virtual/latest/docs/api/virtualizer#options](https://tanstack.com/virtual/latest/docs/api/virtualizer#options) |
| `ui` |  | ` { root?: ClassNameValue; viewport?: ClassNameValue; item?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `Record<string, never> \| { item: T; index: number; virtualItem?: VirtualItem \| undefined; }` |

### Emits

| Event | Type |
| --- | --- |
| `scroll` | `[isScrolling: boolean]` |

### Expose

You can access the typed component instance using [`useTemplateRef`](https://vuejs.org/api/composition-api-helpers.html#usetemplateref).

```
<script setup lang="ts">

const scrollArea = useTemplateRef('scrollArea')

// Scroll to a specific item

function scrollToItem(index: number) {

  scrollArea.value?.virtualizer?.scrollToIndex(index, { align: 'center' })

}

</script>

<template>

  <UScrollArea ref="scrollArea" :items="items" virtualize />

</template>
```

This will give you access to the following:

| Name | Type | Description |
| --- | --- | --- |
| `$el` | `HTMLElement` | The root element of the component. |
| `virtualizer` | `Ref<Virtualizer> \| undefined` | The [TanStack Virtual](https://tanstack.com/virtual/latest/docs/api/virtualizer) virtualizer instance (`undefined` if virtualization is disabled). |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    scrollArea: {

      slots: {

        root: 'relative',

        viewport: 'relative flex',

        item: ''

      },

      variants: {

        orientation: {

          vertical: {

            root: 'overflow-y-auto overflow-x-hidden',

            viewport: 'flex-col',

            item: ''

          },

          horizontal: {

            root: 'overflow-x-auto overflow-y-hidden',

            viewport: 'flex-row',

            item: ''

          }

        }

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

        scrollArea: {

          slots: {

            root: 'relative',

            viewport: 'relative flex',

            item: ''

          },

          variants: {

            orientation: {

              vertical: {

                root: 'overflow-y-auto overflow-x-hidden',

                viewport: 'flex-col',

                item: ''

              },

              horizontal: {

                root: 'overflow-x-auto overflow-y-hidden',

                viewport: 'flex-row',

                item: ''

              }

            }

          }

        }

      }

    })

  ]

})
```

## Changelog

[`effbb`](https://github.com/nuxt/ui/commit/effbb18bfef7a835fa529e864e82b01ca313ea34) — feat: new component ([#5245](https://github.com/nuxt/ui/issues/5245))[Marquee](https://ui.nuxt.com/docs/components/marquee)

[

A component to create infinite scrolling content.

](https://ui.nuxt.com/docs/components/marquee)[

Table

A responsive table element to display data in rows and columns.

](https://ui.nuxt.com/docs/components/table)