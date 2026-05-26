---
title: "Vue EditorSuggestionMenu Component"
source: "https://ui.nuxt.com/docs/components/editor-suggestion-menu"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A command menu that displays formatting and action suggestions when typing the / character in the editor."
tags:
---
## Usage

The EditorSuggestionMenu component displays a menu of formatting and action suggestions when typing a trigger character in the editor and executes the corresponding [handler](https://ui.nuxt.com/docs/components/editor#handlers) when an item is selected.

It uses the `useEditorMenu` composable built on top of TipTap's [Suggestion](https://tiptap.dev/docs/editor/api/utilities/suggestion) utility to filter items as you type and support keyboard navigation (arrow keys, enter to select, escape to close).

```
<script setup lang="ts">

import type { EditorSuggestionMenuItem } from '@nuxt/ui'

const value = ref(\`# Suggestion Menu

Type / to open the suggestion menu and browse available formatting commands.\`)

const items: EditorSuggestionMenuItem[][] = [

  [

    {

      type: 'label',

      label: 'Text'

    },

    {

      kind: 'paragraph',

      label: 'Paragraph',

      icon: 'i-lucide-type'

    },

    {

      kind: 'heading',

      level: 1,

      label: 'Heading 1',

      icon: 'i-lucide-heading-1'

    },

    {

      kind: 'heading',

      level: 2,

      label: 'Heading 2',

      icon: 'i-lucide-heading-2'

    },

    {

      kind: 'heading',

      level: 3,

      label: 'Heading 3',

      icon: 'i-lucide-heading-3'

    }

  ],

  [

    {

      type: 'label',

      label: 'Lists'

    },

    {

      kind: 'bulletList',

      label: 'Bullet List',

      icon: 'i-lucide-list'

    },

    {

      kind: 'orderedList',

      label: 'Numbered List',

      icon: 'i-lucide-list-ordered'

    }

  ],

  [

    {

      type: 'label',

      label: 'Insert'

    },

    {

      kind: 'blockquote',

      label: 'Blockquote',

      icon: 'i-lucide-text-quote'

    },

    {

      kind: 'codeBlock',

      label: 'Code Block',

      icon: 'i-lucide-square-code'

    },

    {

      kind: 'horizontalRule',

      label: 'Divider',

      icon: 'i-lucide-separator-horizontal'

    }

  ]

]

// SSR-safe function to append menus to body (avoids z-index issues in docs)

const appendToBody = false ? () => document.body : undefined

</script>

<template>

  <UEditor

    v-slot="{ editor }"

    v-model="value"

    content-type="markdown"

    placeholder="Type / for commands..."

    class="w-full min-h-21"

  >

    <UEditorSuggestionMenu :editor="editor" :items="items" :append-to="appendToBody" />

  </UEditor>

</template>
```

### Items

Use the `items` prop as an array of objects with the following properties:

- [`kind?: "textAlign" | "heading" | "link" | "image" | "blockquote" | "bulletList" | "orderedList" | "taskList" | "codeBlock" | "horizontalRule" | "paragraph" | "clearFormatting" | "duplicate" | "delete" | "moveUp" | "moveDown" | "suggestion" | "mention" | "emoji"`](https://ui.nuxt.com/docs/components/editor#handlers)
- `label?: string`
- `description?: string`
- `icon?: string`
- `type?: "label" | "separator"`
- `disabled?: boolean`

Type / to see a list of commands.

You can customize the items with icons, labels, and descriptions.

```
<script setup lang="ts">

import type { EditorSuggestionMenuItem } from '@nuxt/ui'

const value = ref(\`Type / to see a list of commands.

You can customize the items with icons, labels, and descriptions.\`)

const items: EditorSuggestionMenuItem[][] = [[{

  type: 'label',

  label: 'Text Styles'

}, {

  kind: 'paragraph',

  label: 'Paragraph',

  icon: 'i-lucide-type'

}, {

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

  kind: 'heading',

  level: 3,

  label: 'Heading 3',

  icon: 'i-lucide-heading-3'

}], [{

  type: 'label',

  label: 'Lists'

}, {

  kind: 'bulletList',

  label: 'Bullet List',

  icon: 'i-lucide-list'

}, {

  kind: 'orderedList',

  label: 'Numbered List',

  icon: 'i-lucide-list-ordered'

}], [{

  type: 'label',

  label: 'Blocks'

}, {

  kind: 'blockquote',

  label: 'Blockquote',

  icon: 'i-lucide-text-quote'

}, {

  kind: 'codeBlock',

  label: 'Code Block',

  icon: 'i-lucide-square-code'

}, {

  kind: 'horizontalRule',

  label: 'Divider',

  icon: 'i-lucide-separator-horizontal'

}]]

</script>

<template>

  <UEditor

    v-slot="{ editor }"

    v-model="value"

    content-type="markdown"

    placeholder="Type / for commands..."

    class="w-full min-h-19"

  >

    <UEditorSuggestionMenu :editor="editor" :items="items" />

  </UEditor>

</template>
```

You can also pass an array of arrays to the `items` prop to create separated groups of items.

Use `type: 'label'` for section headers and `type: 'separator'` for visual dividers to organize commands into logical groups for better discoverability.

### Char

Use the `char` prop to change the trigger character. Defaults to `/`.

### Options

Use the `options` prop to customize the positioning behavior using [Floating UI options](https://floating-ui.com/docs/computeposition#options).

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `size` | `'md'` | ` "xs" \| "md" \| "sm" \| "lg" \| "xl"` |
| `items` |  | ` T[] \| T[][]` |
| `editor` |  | `Editor` |
| `char` | `'/'` | ` string`  The trigger character (e.g., '/', '@', ':') |
| `pluginKey` | `'suggestionMenu'` | ` string` |
| `filterFields` | `['label']` | ` string[]`  Fields to filter items by. |
| `limit` | `42` | ` number`  Maximum number of items to display |
| `options` | `{ strategy: 'absolute', placement: 'bottom-start', offset: 8, shift: { padding: 8 } }` | ` FloatingUIOptions`  - [https://floating-ui.com/docs/computePosition#options](https://floating-ui.com/docs/computePosition#options) |
| `appendTo` |  | ` HTMLElement \| (): HTMLElement`  The DOM element to append the menu to. Default is the editor's parent element.  Sometimes the menu needs to be appended to a different DOM context due to accessibility, clipping, or z-index issues. |
| `ui` |  | ` { content?: ClassNameValue; viewport?: ClassNameValue; group?: ClassNameValue; label?: ClassNameValue; separator?: ClassNameValue; item?: ClassNameValue; itemLeadingIcon?: ClassNameValue; itemLeadingAvatar?: ClassNameValue; itemLeadingAvatarSize?: ClassNameValue; itemWrapper?: ClassNameValue; itemLabel?: ClassNameValue; itemDescription?: ClassNameValue; itemLabelExternalIcon?: ClassNameValue; }` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    editorSuggestionMenu: {

      slots: {

        content: 'min-w-48 max-w-60 max-h-96 bg-default shadow-lg rounded-md ring ring-default overflow-hidden data-[state=open]:animate-[scale-in_100ms_ease-out] data-[state=closed]:animate-[scale-out_100ms_ease-in] origin-(--reka-dropdown-menu-content-transform-origin) flex flex-col',

        viewport: 'relative divide-y divide-default scroll-py-1 overflow-y-auto flex-1',

        group: 'p-1 isolate',

        label: 'w-full flex items-center font-semibold text-highlighted',

        separator: '-mx-1 my-1 h-px bg-border',

        item: 'group relative w-full flex items-start select-none outline-none before:absolute before:z-[-1] before:inset-px before:rounded-md data-disabled:cursor-not-allowed data-disabled:opacity-75',

        itemLeadingIcon: 'shrink-0 flex items-center justify-center',

        itemLeadingAvatar: 'shrink-0',

        itemLeadingAvatarSize: '',

        itemWrapper: 'flex-1 flex flex-col text-start min-w-0',

        itemLabel: 'truncate',

        itemDescription: 'truncate text-muted',

        itemLabelExternalIcon: 'inline-block size-3 align-top text-dimmed'

      },

      variants: {

        size: {

          xs: {

            label: 'p-1 text-[10px]/3 gap-1',

            item: 'p-1 text-xs gap-1',

            itemLeadingIcon: 'size-4 text-sm',

            itemLeadingAvatarSize: '3xs'

          },

          sm: {

            label: 'p-1.5 text-[10px]/3 gap-1.5',

            item: 'p-1.5 text-xs gap-1.5',

            itemLeadingIcon: 'size-4 text-sm',

            itemLeadingAvatarSize: '3xs'

          },

          md: {

            label: 'p-1.5 text-xs gap-1.5',

            item: 'p-1.5 text-sm gap-1.5',

            itemLeadingIcon: 'size-5 text-base',

            itemLeadingAvatarSize: '2xs'

          },

          lg: {

            label: 'p-2 text-xs gap-2',

            item: 'p-2 text-sm gap-2',

            itemLeadingIcon: 'size-5 text-base',

            itemLeadingAvatarSize: '2xs'

          },

          xl: {

            label: 'p-2 text-sm gap-2',

            item: 'p-2 text-base gap-2',

            itemLeadingIcon: 'size-6 text-xl',

            itemLeadingAvatarSize: 'xs'

          }

        },

        active: {

          true: {

            item: 'text-highlighted before:bg-elevated/75',

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

        editorSuggestionMenu: {

          slots: {

            content: 'min-w-48 max-w-60 max-h-96 bg-default shadow-lg rounded-md ring ring-default overflow-hidden data-[state=open]:animate-[scale-in_100ms_ease-out] data-[state=closed]:animate-[scale-out_100ms_ease-in] origin-(--reka-dropdown-menu-content-transform-origin) flex flex-col',

            viewport: 'relative divide-y divide-default scroll-py-1 overflow-y-auto flex-1',

            group: 'p-1 isolate',

            label: 'w-full flex items-center font-semibold text-highlighted',

            separator: '-mx-1 my-1 h-px bg-border',

            item: 'group relative w-full flex items-start select-none outline-none before:absolute before:z-[-1] before:inset-px before:rounded-md data-disabled:cursor-not-allowed data-disabled:opacity-75',

            itemLeadingIcon: 'shrink-0 flex items-center justify-center',

            itemLeadingAvatar: 'shrink-0',

            itemLeadingAvatarSize: '',

            itemWrapper: 'flex-1 flex flex-col text-start min-w-0',

            itemLabel: 'truncate',

            itemDescription: 'truncate text-muted',

            itemLabelExternalIcon: 'inline-block size-3 align-top text-dimmed'

          },

          variants: {

            size: {

              xs: {

                label: 'p-1 text-[10px]/3 gap-1',

                item: 'p-1 text-xs gap-1',

                itemLeadingIcon: 'size-4 text-sm',

                itemLeadingAvatarSize: '3xs'

              },

              sm: {

                label: 'p-1.5 text-[10px]/3 gap-1.5',

                item: 'p-1.5 text-xs gap-1.5',

                itemLeadingIcon: 'size-4 text-sm',

                itemLeadingAvatarSize: '3xs'

              },

              md: {

                label: 'p-1.5 text-xs gap-1.5',

                item: 'p-1.5 text-sm gap-1.5',

                itemLeadingIcon: 'size-5 text-base',

                itemLeadingAvatarSize: '2xs'

              },

              lg: {

                label: 'p-2 text-xs gap-2',

                item: 'p-2 text-sm gap-2',

                itemLeadingIcon: 'size-5 text-base',

                itemLeadingAvatarSize: '2xs'

              },

              xl: {

                label: 'p-2 text-sm gap-2',

                item: 'p-2 text-base gap-2',

                itemLeadingIcon: 'size-6 text-xl',

                itemLeadingAvatarSize: 'xs'

              }

            },

            active: {

              true: {

                item: 'text-highlighted before:bg-elevated/75',

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