---
title: "Vue EditorDragHandle Component"
source: "https://ui.nuxt.com/docs/components/editor-drag-handle"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A draggable handle for reordering and selecting blocks in the editor."
tags:
---
## EditorDragHandle

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/EditorDragHandle.vue)

A draggable handle for reordering and selecting blocks in the editor.

## Usage

The EditorDragHandle component provides drag-and-drop functionality for reordering editor blocks using the `@tiptap/extension-drag-handle-vue-3` package.

It extends the [Button](https://ui.nuxt.com/docs/components/button) component, so you can pass any property such as `color`, `variant`, `size`, etc.

## Drag Handle

Hover over the left side of this block to see the drag handle appear and reorder blocks.

```
<script setup lang="ts">

const value = ref(\`# Drag Handle

Hover over the left side of this block to see the drag handle appear and reorder blocks.\`)

</script>

<template>

  <UEditor v-slot="{ editor }" v-model="value" content-type="markdown" class="w-full min-h-21">

    <UEditorDragHandle :editor="editor" />

  </UEditor>

</template>
```

Learn more about the Drag Handle extension in the TipTap documentation.

### Icon

Use the `icon` prop to customize the drag handle icon.

```
<template>

  <UEditor v-slot="{ editor }">

    <UEditorDragHandle :editor="editor" icon="i-lucide-move" />

  </UEditor>

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.drag` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.drag` key.

### Options

Use the `options` prop to customize the positioning behavior using [Floating UI options](https://floating-ui.com/docs/computeposition#options).

The offset is automatically calculated to center the handle for small blocks and align it to the top for taller blocks.

```
<template>

  <UEditor v-slot="{ editor }">

    <UEditorDragHandle

      :editor="editor"

      :options="{

        placement: 'left'

      }"

    />

  </UEditor>

</template>
```

## Examples

Use the default slot to add a [DropdownMenu](https://ui.nuxt.com/docs/components/dropdown-menu) with block-level actions like duplicate, delete, move up/down, or transform blocks into different types.

Listen to the `@node-change` event to track the currently hovered node and its position, then use `editor.chain().setMeta('lockDragHandle', open).run()` to lock the handle position while the menu is open.

```
<script setup lang="ts">

import { upperFirst } from 'scule'

import type { DropdownMenuItem } from '@nuxt/ui'

import { mapEditorItems } from '@nuxt/ui/utils/editor'

import type { Editor, JSONContent } from '@tiptap/vue-3'

const value = ref(\`Hover over the left side to see both drag handle and menu button.

Click the menu to see block actions. Try duplicating or deleting a block.\`)

const selectedNode = ref<{ node: JSONContent, pos: number }>()

const items = (editor: Editor): DropdownMenuItem[][] => {

  if (!selectedNode.value?.node?.type) {

    return []

  }

  return mapEditorItems(editor, [[

    {

      type: 'label',

      label: upperFirst(selectedNode.value.node.type)

    },

    {

      label: 'Turn into',

      icon: 'i-lucide-repeat-2',

      children: [

        { kind: 'paragraph', label: 'Paragraph', icon: 'i-lucide-type' },

        { kind: 'heading', level: 1, label: 'Heading 1', icon: 'i-lucide-heading-1' },

        { kind: 'heading', level: 2, label: 'Heading 2', icon: 'i-lucide-heading-2' },

        { kind: 'heading', level: 3, label: 'Heading 3', icon: 'i-lucide-heading-3' },

        { kind: 'heading', level: 4, label: 'Heading 4', icon: 'i-lucide-heading-4' },

        { kind: 'bulletList', label: 'Bullet List', icon: 'i-lucide-list' },

        { kind: 'orderedList', label: 'Ordered List', icon: 'i-lucide-list-ordered' },

        { kind: 'blockquote', label: 'Blockquote', icon: 'i-lucide-text-quote' },

        { kind: 'codeBlock', label: 'Code Block', icon: 'i-lucide-square-code' }

      ]

    },

    {

      kind: 'clearFormatting',

      pos: selectedNode.value?.pos,

      label: 'Reset formatting',

      icon: 'i-lucide-rotate-ccw'

    }

  ], [

    {

      kind: 'duplicate',

      pos: selectedNode.value?.pos,

      label: 'Duplicate',

      icon: 'i-lucide-copy'

    },

    {

      label: 'Copy to clipboard',

      icon: 'i-lucide-clipboard',

      onSelect: async () => {

        if (!selectedNode.value) return

        const pos = selectedNode.value.pos

        const node = editor.state.doc.nodeAt(pos)

        if (node) {

          await navigator.clipboard.writeText(node.textContent)

        }

      }

    }

  ], [

    {

      kind: 'moveUp',

      pos: selectedNode.value?.pos,

      label: 'Move up',

      icon: 'i-lucide-arrow-up'

    },

    {

      kind: 'moveDown',

      pos: selectedNode.value?.pos,

      label: 'Move down',

      icon: 'i-lucide-arrow-down'

    }

  ], [

    {

      kind: 'delete',

      pos: selectedNode.value?.pos,

      label: 'Delete',

      icon: 'i-lucide-trash'

    }

  ]]) as DropdownMenuItem[][]

}

</script>

<template>

  <UEditor

    v-slot="{ editor }"

    v-model="value"

    content-type="markdown"

    class="w-full min-h-19"

  >

    <UEditorDragHandle v-slot="{ ui }" :editor="editor" @node-change="selectedNode = $event">

      <UDropdownMenu

        v-slot="{ open }"

        :modal="false"

        :items="items(editor)"

        :content="{ side: 'left' }"

        :ui="{ content: 'w-48', label: 'text-xs' }"

        @update:open="editor.chain().setMeta('lockDragHandle', $event).run()"

      >

        <UButton

          icon="i-lucide-grip-vertical"

          color="neutral"

          variant="ghost"

          active-variant="soft"

          size="sm"

          :active="open"

          :class="ui.handle()"

        />

      </UDropdownMenu>

    </UEditorDragHandle>

  </UEditor>

</template>
```

This example uses the `mapEditorItems` utility from `@nuxt/ui/utils/editor` to automatically map handler kinds (like `duplicate`, `delete`, `moveUp`, etc.) to their corresponding editor commands with proper state management.

Use the default slot to add a [Button](https://ui.nuxt.com/docs/components/button) next to the drag handle to open the [EditorSuggestionMenu](https://ui.nuxt.com/docs/components/editor-suggestion-menu).

Call the `onClick` slot function to get the current node position, then use `handlers.suggestion?.execute(editor, { pos: node?.pos }).run()` to insert new blocks at that position.

```
<script setup lang="ts">

import type { EditorSuggestionMenuItem } from '@nuxt/ui'

const value = ref(\`Click the plus button to open the suggestion menu and add new blocks.

The button appears when hovering over blocks.\`)

const suggestionItems: EditorSuggestionMenuItem[][] = [[{

  kind: 'heading',

  level: 1,

  label: 'Heading 1',

  icon: 'i-lucide-heading-1'

}, {

  kind: 'heading',

  level: 2,

  label: 'Heading 2',

  icon: 'i-lucide-heading-2'

}, {

  kind: 'bulletList',

  label: 'Bullet List',

  icon: 'i-lucide-list'

}, {

  kind: 'blockquote',

  label: 'Blockquote',

  icon: 'i-lucide-text-quote'

}]]

</script>

<template>

  <UEditor

    v-slot="{ editor, handlers }"

    v-model="value"

    content-type="markdown"

    class="w-full min-h-35"

    :ui="{ base: 'p-8 sm:px-16' }"

  >

    <UEditorDragHandle v-slot="{ ui, onClick }" :editor="editor">

      <UButton

        icon="i-lucide-plus"

        color="neutral"

        variant="ghost"

        size="sm"

        :class="ui.handle()"

        @click="(e) => {

          e.stopPropagation()

          const selected = onClick()

          handlers.suggestion?.execute(editor, { pos: selected?.pos }).run()

        }"

      />

      <UButton

        icon="i-lucide-grip-vertical"

        color="neutral"

        variant="ghost"

        size="sm"

        :class="ui.handle()"

      />

    </UEditorDragHandle>

    <UEditorSuggestionMenu :editor="editor" :items="suggestionItems" />

  </UEditor>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'button'` | `any`  The element or component this component should render as when not a link. |
| `editor` |  | `Editor` |
| `icon` | `appConfig.ui.icons.drag` | `any` |
| `color` | `'neutral'` | ` "error" \| "neutral" \| "primary" \| "secondary" \| "success" \| "info" \| "warning"` |
| `variant` | `'ghost'` | ` "ghost" \| "solid" \| "outline" \| "soft" \| "subtle" \| "link"` |
| `options` | `{ strategy: 'absolute', placement: 'left-start' }` | ` FloatingUIOptions`  The options for positioning the drag handle. Those are passed to Floating UI and include options for the placement, offset, flip, shift, size, autoPlacement, hide, and inline middleware.  - [https://floating-ui.com/docs/computePosition#options](https://floating-ui.com/docs/computePosition#options) |
| `pluginKey` |  | ` string \| PluginKey<any>` |
| `nestedOptions` |  | ` NormalizedNestedOptions` |
| `onElementDragStart` |  | ` (e: DragEvent): void` |
| `onElementDragEnd` |  | ` (e: DragEvent): void` |
| `getReferencedVirtualElement` |  | ` (): VirtualElement \| null` |
| `nested` |  | `boolean \| NestedOptions`  Enable drag handles for nested content (list items, blockquotes, etc.).  When enabled, the drag handle will appear for nested blocks, not just top-level blocks. A rule-based scoring system determines which node to target based on cursor position and configured rules. |
| `autofocus` |  | ` false \| true \| "true" \| "false"` |
| `disabled` |  | `boolean` |
| `name` |  | ` string` |
| `type` | `'button'` | ` "reset" \| "submit" \| "button"`  The type of the button when not a link. |
| `label` |  | ` string` |
| `activeColor` |  | ` "error" \| "neutral" \| "primary" \| "secondary" \| "success" \| "info" \| "warning"` |
| `activeVariant` |  | ` "ghost" \| "solid" \| "outline" \| "soft" \| "subtle" \| "link"` |
| `size` | `'sm'` | ` "sm" \| "xs" \| "md" \| "lg" \| "xl"` |
| `square` |  | `boolean`  Render the button with equal padding on all sides. |
| `block` |  | `boolean`  Render the button full width. |
| `loadingAuto` |  | `boolean`  Set loading state automatically based on the `@click` promise state |
| `avatar` |  | ` AvatarProps`  Display an avatar on the left side. |
| `leading` |  | `boolean`  When `true`, the icon will be displayed on the left side. |
| `leadingIcon` |  | `any`  Display an icon on the left side. |
| `trailing` |  | `boolean`  When `true`, the icon will be displayed on the right side. |
| `trailingIcon` |  | `any`  Display an icon on the right side. |
| `loading` |  | `boolean`  When `true`, the loading icon will be displayed. |
| `loadingIcon` | `appConfig.ui.icons.loading` | `any`  The icon when the `loading` prop is `true`. |
| `ui` |  | ` { root?: ClassNameValue; handle?: ClassNameValue; } & { base?: ClassNameValue; label?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; trailingIcon?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{ ui: object; }` |

### Emits

| Event | Type |
| --- | --- |
| `nodeChange` | `[{ node: JSONContent; pos: number; }]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    editorDragHandle: {

      slots: {

        root: 'hidden sm:flex items-center justify-center transition-all duration-200 ease-out',

        handle: 'cursor-grab px-1'

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

        editorDragHandle: {

          slots: {

            root: 'hidden sm:flex items-center justify-center transition-all duration-200 ease-out',

            handle: 'cursor-grab px-1'

          }

        }

      }

    })

  ]

})
```

## Changelog

[`1b850`](https://github.com/nuxt/ui/commit/1b850bbd65e665d44ff2b0f656ea945021d34a12) — fix: add missing `UButton` import

[`38765`](https://github.com/nuxt/ui/commit/38765c367de004993290a2e9dca5f2ab1579b284) — feat: new component ([#5407](https://github.com/nuxt/ui/issues/5407))[Editor](https://ui.nuxt.com/docs/components/editor)

[

A rich text editor component based on TipTap with support for markdown, HTML, and JSON content types.

](https://ui.nuxt.com/docs/components/editor)[

EditorEmojiMenu

An emoji picker menu that displays emoji suggestions when typing the: character in the editor.

](https://ui.nuxt.com/docs/components/editor-emoji-menu)