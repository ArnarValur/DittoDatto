---
title: "Vue Accordion Component"
source: "https://ui.nuxt.com/docs/components/accordion"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A stacked set of collapsible panels."
tags:
---
## Accordion

[Accordion](https://reka-ui.com/docs/components/accordion) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Accordion.vue)

A stacked set of collapsible panels.

## Usage

Use the Accordion component to display a list of collapsible items.

```
<script setup lang="ts">

import type { AccordionItem } from '@nuxt/ui'

const items = ref<AccordionItem[]>([

  {

    label: 'Is Nuxt UI free to use?',

    content: 'Yes! Nuxt UI is completely free and open source under the MIT license. All 125+ components are available to everyone.'

  },

  {

    label: 'Can I use Nuxt UI with Vue without Nuxt?',

    content: 'Yes! While optimized for Nuxt, Nuxt UI works perfectly with standalone Vue projects via our Vite plugin. You can follow the [installation guide](/docs/getting-started/installation/vue) to get started.'

  },

  {

    label: 'Is Nuxt UI production-ready?',

    content: 'Yes! Nuxt UI is used in production by thousands of applications with extensive tests, regular updates, and active maintenance.'

  }

])

</script>

<template>

  <UAccordion :items="items" />

</template>
```

### Items

Use the `items` prop as an array of objects with the following properties:

- `label?: string`
- `icon?: string`
- `trailingIcon?: string`
- `content?: string`
- `value?: string`
- `disabled?: boolean`
- [`slot?: string`](https://ui.nuxt.com/docs/components/#with-custom-slot)
- `class?: any`
- `ui?: { item?: ClassNameValue, header?: ClassNameValue, trigger?: ClassNameValue, leadingIcon?: ClassNameValue, label?: ClassNameValue, trailingIcon?: ClassNameValue, content?: ClassNameValue, body?: ClassNameValue }`

```
<script setup lang="ts">

import type { AccordionItem } from '@nuxt/ui'

const items = ref<AccordionItem[]>([

  {

    label: 'Icons',

    icon: 'i-lucide-smile',

    content: 'You have nothing to do, @nuxt/icon will handle it automatically.'

  },

  {

    label: 'Colors',

    icon: 'i-lucide-swatch-book',

    content: 'Choose a primary and a neutral color from your Tailwind CSS theme.'

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    content: 'You can customize components by using the \`class\` / \`ui\` props or in your app.config.ts.'

  }

])

</script>

<template>

  <UAccordion :items="items" />

</template>
```

### Multiple

Set the `type` prop to `multiple` to allow multiple items to be active at the same time. Defaults to `single`.

```
<script setup lang="ts">

import type { AccordionItem } from '@nuxt/ui'

const items = ref<AccordionItem[]>([

  {

    label: 'Icons',

    icon: 'i-lucide-smile',

    content: 'You have nothing to do, @nuxt/icon will handle it automatically.'

  },

  {

    label: 'Colors',

    icon: 'i-lucide-swatch-book',

    content: 'Choose a primary and a neutral color from your Tailwind CSS theme.'

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    content: 'You can customize components by using the \`class\` / \`ui\` props or in your app.config.ts.'

  }

])

</script>

<template>

  <UAccordion type="multiple" :items="items" />

</template>
```

### Collapsible

When `type` is `single`, you can set the `collapsible` prop to `false` to prevent the active item from collapsing.

```
<script setup lang="ts">

import type { AccordionItem } from '@nuxt/ui'

const items = ref<AccordionItem[]>([

  {

    label: 'Icons',

    icon: 'i-lucide-smile',

    content: 'You have nothing to do, @nuxt/icon will handle it automatically.'

  },

  {

    label: 'Colors',

    icon: 'i-lucide-swatch-book',

    content: 'Choose a primary and a neutral color from your Tailwind CSS theme.'

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    content: 'You can customize components by using the \`class\` / \`ui\` props or in your app.config.ts.'

  }

])

</script>

<template>

  <UAccordion :collapsible="false" :items="items" />

</template>
```

### Unmount

Use the `unmount-on-hide` prop to prevent the content from being unmounted when the accordion is collapsed. Defaults to `true`.

```
<script setup lang="ts">

import type { AccordionItem } from '@nuxt/ui'

const items = ref<AccordionItem[]>([

  {

    label: 'Icons',

    icon: 'i-lucide-smile',

    content: 'You have nothing to do, @nuxt/icon will handle it automatically.'

  },

  {

    label: 'Colors',

    icon: 'i-lucide-swatch-book',

    content: 'Choose a primary and a neutral color from your Tailwind CSS theme.'

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    content: 'You can customize components by using the \`class\` / \`ui\` props or in your app.config.ts.'

  }

])

</script>

<template>

  <UAccordion :unmount-on-hide="false" :items="items" />

</template>
```

You can inspect the DOM to see each item's content being rendered.

### Disabled

Use the `disabled` property to disable the Accordion.

You can also disable a specific item by using the `disabled` property in the item object.

```
<script setup lang="ts">

import type { AccordionItem } from '@nuxt/ui'

const items = ref<AccordionItem[]>([

  {

    label: 'Icons',

    icon: 'i-lucide-smile',

    content: 'You have nothing to do, @nuxt/icon will handle it automatically.'

  },

  {

    label: 'Colors',

    icon: 'i-lucide-swatch-book',

    content: 'Choose a primary and a neutral color from your Tailwind CSS theme.',

    disabled: true

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    content: 'You can customize components by using the \`class\` / \`ui\` props or in your app.config.ts.'

  }

])

</script>

<template>

  <UAccordion disabled :items="items" />

</template>
```

### Trailing Icon

Use the `trailing-icon` prop to customize the trailing [Icon](https://ui.nuxt.com/docs/components/icon) of each item. Defaults to `i-lucide-chevron-down`.

You can also set an icon for a specific item by using the `trailingIcon` property in the item object.

```
<script setup lang="ts">

import type { AccordionItem } from '@nuxt/ui'

const items = ref<AccordionItem[]>([

  {

    label: 'Icons',

    icon: 'i-lucide-smile',

    content: 'You have nothing to do, @nuxt/icon will handle it automatically.',

    trailingIcon: 'i-lucide-plus'

  },

  {

    label: 'Colors',

    icon: 'i-lucide-swatch-book',

    content: 'Choose a primary and a neutral color from your Tailwind CSS theme.'

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    content: 'You can customize components by using the \`class\` / \`ui\` props or in your app.config.ts.'

  }

])

</script>

<template>

  <UAccordion trailing-icon="i-lucide-arrow-down" :items="items" />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.chevronDown` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.chevronDown` key.

## Examples

### Control active item(s)

You can control the active item by using the `default-value` prop or the `v-model` directive with the `value` of the item. If no `value` is provided, it defaults to the index **as a string**.

```
<script setup lang="ts">

import type { AccordionItem } from '@nuxt/ui'

const items: AccordionItem[] = [

  {

    label: 'Icons',

    icon: 'i-lucide-smile',

    content: 'You have nothing to do, @nuxt/icon will handle it automatically.'

  },

  {

    label: 'Colors',

    icon: 'i-lucide-swatch-book',

    content: 'Choose a primary and a neutral color from your Tailwind CSS theme.'

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    content: 'You can customize components by using the \`class\` / \`ui\` props or in your app.config.ts.'

  }

]

const active = ref('0')

// Note: This is for demonstration purposes only. Don't do this at home.

onMounted(() => {

  setInterval(() => {

    active.value = String((Number(active.value) + 1) % items.length)

  }, 2000)

})

</script>

<template>

  <UAccordion v-model="active" :items="items" />

</template>
```

Use the `value-key` prop to change the key used to match items when a `v-model` or `default-value` is provided.

### With drag and drop

Use the [`useSortable`](https://vueuse.org/integrations/useSortable/) composable from [`@vueuse/integrations`](https://vueuse.org/integrations/README.html) to enable drag and drop functionality on the Accordion. This integration wraps [Sortable.js](https://sortablejs.github.io/Sortable/) to provide a seamless drag and drop experience.

```
<script setup lang="ts">

import type { AccordionItem } from '@nuxt/ui'

import { useSortable } from '@vueuse/integrations/useSortable'

const items = shallowRef<AccordionItem[]>([

  {

    label: 'Icons',

    icon: 'i-lucide-smile',

    content: 'You have nothing to do, @nuxt/icon will handle it automatically.'

  },

  {

    label: 'Colors',

    icon: 'i-lucide-swatch-book',

    content: 'Choose a primary and a neutral color from your Tailwind CSS theme.'

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    content: 'You can customize components by using the \`class\` / \`ui\` props or in your app.config.ts.'

  }

])

const accordion = useTemplateRef<HTMLElement>('accordion')

useSortable(accordion, items, {

  animation: 150

})

</script>

<template>

  <UAccordion ref="accordion" :items="items" />

</template>
```

### With body slot

Use the `#body` slot to customize the body of each item.

```
<script setup lang="ts">

import type { AccordionItem } from '@nuxt/ui'

const items: AccordionItem[] = [

  {

    label: 'Icons',

    icon: 'i-lucide-smile'

  },

  {

    label: 'Colors',

    icon: 'i-lucide-swatch-book'

  },

  {

    label: 'Components',

    icon: 'i-lucide-box'

  }

]

</script>

<template>

  <UAccordion :items="items">

    <template #body="{ item }">

      This is the {{ item.label }} panel.

    </template>

  </UAccordion>

</template>
```

The `#body` slot includes some pre-defined styles, use the [`#content` slot](https://ui.nuxt.com/docs/components/#with-content-slot) if you want to start from scratch.

### With content slot

Use the `#content` slot to customize the content of each item.

```
<script setup lang="ts">

import type { AccordionItem } from '@nuxt/ui'

const items: AccordionItem[] = [

  {

    label: 'Icons',

    icon: 'i-lucide-smile'

  },

  {

    label: 'Colors',

    icon: 'i-lucide-swatch-book'

  },

  {

    label: 'Components',

    icon: 'i-lucide-box'

  }

]

</script>

<template>

  <UAccordion :items="items">

    <template #content="{ item }">

      <p class="pb-3.5 text-sm text-muted">

        This is the {{ item.label }} panel.

      </p>

    </template>

  </UAccordion>

</template>
```

### With custom slot

Use the `slot` property to customize a specific item.

You will have access to the following slots:

- `#{{ item.slot }}`
- `#{{ item.slot }}-body`

```
<script setup lang="ts">

import type { AccordionItem } from '@nuxt/ui'

const items = [

  {

    label: 'Icons',

    icon: 'i-lucide-smile',

    content: 'You have nothing to do, @nuxt/icon will handle it automatically.'

  },

  {

    label: 'Colors',

    icon: 'i-lucide-swatch-book',

    slot: 'colors' as const,

    content: 'Choose a primary and a neutral color from your Tailwind CSS theme.'

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    content: 'You can customize components by using the \`class\` / \`ui\` props or in your app.config.ts.'

  }

] satisfies AccordionItem[]

</script>

<template>

  <UAccordion :items="items">

    <template #colors="{ item }">

      <p class="text-sm pb-3.5 text-primary">

        {{ item.content }}

      </p>

    </template>

  </UAccordion>

</template>
```

### With markdown content

You can use the [MDC](https://github.com/nuxt-modules/mdc?tab=readme-ov-file#mdc) component from `@nuxtjs/mdc` to render markdown in the accordion items.

```
<script setup lang="ts">

const items = [

  {

    label: 'Is Nuxt UI free to use?',

    icon: 'i-lucide-circle-help',

    content: 'Yes! Nuxt UI is completely free and open source under the MIT license. All 125+ components are available to everyone.'

  },

  {

    label: 'Can I use Nuxt UI with Vue without Nuxt?',

    icon: 'i-lucide-circle-help',

    content: 'Yes! While optimized for Nuxt, Nuxt UI works perfectly with standalone Vue projects via our Vite plugin. You can follow the [installation guide](/docs/getting-started/installation/vue) to get started.'

  },

  {

    label: 'Will Nuxt UI work with other CSS frameworks like UnoCSS?',

    icon: 'i-lucide-circle-help',

    content: 'No. Nuxt UI is designed exclusively for Tailwind CSS. UnoCSS support would require significant architecture changes due to different class naming conventions.'

  },

  {

    label: 'How does Nuxt UI handle accessibility?',

    icon: 'i-lucide-circle-help',

    content: 'Through [Reka UI](https://reka-ui.com/docs/overview/accessibility) integration, Nuxt UI provides automatic ARIA attributes, keyboard navigation, focus management, and screen reader support. While offering a strong foundation, testing in your specific use case remains important.'

  },

  {

    label: 'How is Nuxt UI tested?',

    icon: 'i-lucide-circle-help',

    content: 'Nuxt UI ensures reliability with 1000+ Vitest tests covering core functionality and accessibility.'

  },

  {

    label: 'Is Nuxt UI production-ready?',

    icon: 'i-lucide-circle-help',

    content: 'Yes! Nuxt UI is used in production by thousands of applications with extensive tests, regular updates, and active maintenance.'

  }

]

</script>

<template>

  <UAccordion

    type="multiple"

    :items="items"

    :unmount-on-hide="false"

    :default-value="['3']"

    :ui="{

      trigger: 'text-base',

      body: 'text-base text-muted'

    }"

  >

    <template #body="{ item }">

      <MDC :value="item.content" unwrap="p" />

    </template>

  </UAccordion>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `items` |  | ` T[]` |
| `trailingIcon` | `appConfig.ui.icons.chevronDown` | `any`  The icon displayed on the right side of the trigger. |
| `valueKey` | `'value'` | ` keyof Extract<NestedItem<T>, object> \| DotPathKeys<Extract<NestedItem<T>, object>>`  The key used to get the value from the item. |
| `labelKey` | `'label'` | ` keyof Extract<NestedItem<T>, object> \| DotPathKeys<Extract<NestedItem<T>, object>>`  The key used to get the label from the item. |
| `collapsible` | `true` | `boolean`  When type is "single", allows closing content when clicking trigger for an open item. When type is "multiple", this prop has no effect. |
| `defaultValue` |  | ` string \| string[]`  The default active value of the item(s).  Use when you do not need to control the state of the item(s). |
| `modelValue` |  | ` string \| string[]`  The controlled value of the active item(s).  Use this when you need to control the state of the items. Can be binded with `v-model` |
| `type` | `'single'` | ` "single" \| "multiple"`  Determines whether a "single" or "multiple" items can be selected at a time.  This prop will overwrite the inferred type from `modelValue` and `defaultValue`. |
| `disabled` | `false` | `boolean`  When `true`, prevents the user from interacting with the accordion and all its items |
| `unmountOnHide` | `true` | `boolean`  When `true`, the element will be unmounted on closed state. |
| `ui` |  | ` { root?: ClassNameValue; item?: ClassNameValue; header?: ClassNameValue; trigger?: ClassNameValue; content?: ClassNameValue; body?: ClassNameValue; leadingIcon?: ClassNameValue; trailingIcon?: ClassNameValue; label?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `leading` | `{ item: T; index: number; open: boolean; ui: object; }` |
| `default` | `{ item: T; index: number; open: boolean; }` |
| `trailing` | `{ item: T; index: number; open: boolean; ui: object; }` |
| `content` | `{ item: T; index: number; open: boolean; ui: object; }` |
| `body` | `{ item: T; index: number; open: boolean; ui: object; }` |

### Emits

| Event | Type |
| --- | --- |
| `update:modelValue` | `[value: string \| string[] \| undefined]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    accordion: {

      slots: {

        root: 'w-full',

        item: 'border-b border-default last:border-b-0',

        header: 'flex',

        trigger: 'group flex-1 flex items-center gap-1.5 font-medium text-sm py-3.5 focus-visible:outline-primary min-w-0',

        content: 'data-[state=open]:animate-[accordion-down_200ms_ease-out] data-[state=closed]:animate-[accordion-up_200ms_ease-out] overflow-hidden focus:outline-none',

        body: 'text-sm pb-3.5',

        leadingIcon: 'shrink-0 size-5',

        trailingIcon: 'shrink-0 size-5 ms-auto group-data-[state=open]:rotate-180 transition-transform duration-200',

        label: 'text-start break-words'

      },

      variants: {

        disabled: {

          true: {

            trigger: 'cursor-not-allowed opacity-75'

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

        accordion: {

          slots: {

            root: 'w-full',

            item: 'border-b border-default last:border-b-0',

            header: 'flex',

            trigger: 'group flex-1 flex items-center gap-1.5 font-medium text-sm py-3.5 focus-visible:outline-primary min-w-0',

            content: 'data-[state=open]:animate-[accordion-down_200ms_ease-out] data-[state=closed]:animate-[accordion-up_200ms_ease-out] overflow-hidden focus:outline-none',

            body: 'text-sm pb-3.5',

            leadingIcon: 'shrink-0 size-5',

            trailingIcon: 'shrink-0 size-5 ms-auto group-data-[state=open]:rotate-180 transition-transform duration-200',

            label: 'text-start break-words'

          },

          variants: {

            disabled: {

              true: {

                trigger: 'cursor-not-allowed opacity-75'

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

[`55646`](https://github.com/nuxt/ui/commit/55646eaeab1598ad53b95baa2c8acb15f798482b) — feat: add `valueKey` prop ([#5905](https://github.com/nuxt/ui/issues/5905))

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`11a03`](https://github.com/nuxt/ui/commit/11a03201ed8454f37e911db4a14b00f74104932a) — fix: dot notation type support for `labelKey` and `valueKey` ([#4933](https://github.com/nuxt/ui/issues/4933))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`b9adc`](https://github.com/nuxt/ui/commit/b9adc83e787db02507e6e7bb1aabc684eccc197b) — feat: add `ui` field in items ([#4060](https://github.com/nuxt/ui/issues/4060))

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`8dd9d`](https://github.com/nuxt/ui/commit/8dd9d08209e47a7d9a5654db4fb936b4cbcfc021) — fix: improve dynamic slots ([#3857](https://github.com/nuxt/ui/issues/3857))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`b9983`](https://github.com/nuxt/ui/commit/b9983549a4b743724ea3ef99cc4a243f5ca41e53) — fix: improve generic types ([#3331](https://github.com/nuxt/ui/issues/3331))

[`ef861`](https://github.com/nuxt/ui/commit/ef86108f14da23fa292afe016517eac95c34bf76) — chore: add eol in script tag to fix syntax highlight[Textarea](https://ui.nuxt.com/docs/components/textarea)

[

A textarea element to input multi-line text.

](https://ui.nuxt.com/docs/components/textarea)[

Carousel

A carousel with motion and swipe built using Embla.

](https://ui.nuxt.com/docs/components/carousel)