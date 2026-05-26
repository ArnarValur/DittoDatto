**---
title: "Vue EditorEmojiMenu Component"
source: "https://ui.nuxt.com/docs/components/editor-emoji-menu"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "An emoji picker menu that displays emoji suggestions when typing the : character in the editor."
tags:
---
## Usage

The EditorEmojiMenu component displays a menu of emoji suggestions when typing the `:` character in the editor and inserts the selected emoji. It works alongside the `@tiptap/extension-emoji` package to provide emoji support.

It uses the `useEditorMenu` composable built on top of TipTap's [Suggestion](https://tiptap.dev/docs/editor/api/utilities/suggestion) utility to filter items as you type and support keyboard navigation (arrow keys, enter to select, escape to close).

The `@tiptap/extension-emoji` package is not installed by default, you need to install it separately.

Learn more about the Emoji extension in the TipTap documentation.

### Items

Use the `items` prop as an array of objects with the following properties:

- `name: string`
- `emoji: string`
- `shortcodes?: string[]`
- `tags?: string[]`
- `group?: string`
- `fallbackImage?: string`

Type: to see a custom emoji set.

You can also install the `@tiptap/extension-emoji` extension to use a comprehensive set with over 1800 emojis.

```
<script setup lang="ts">

import type { EditorEmojiMenuItem } from '@nuxt/ui'

import { Emoji } from '@tiptap/extension-emoji'

const value = ref(\`Type : to see a custom emoji set.

You can also install the \\`@tiptap/extension-emoji\\` extension to use a comprehensive set with over 1800 emojis.\`)

const items: EditorEmojiMenuItem[] = [{

  name: 'smile',

  emoji: '😄',

  shortcodes: ['smile'],

  tags: ['happy', 'joy', 'pleased']

}, {

  name: 'heart',

  emoji: '❤️',

  shortcodes: ['heart'],

  tags: ['love', 'like']

}, {

  name: 'thumbsup',

  emoji: '👍',

  shortcodes: ['thumbsup', '+1'],

  tags: ['approve', 'ok']

}, {

  name: 'fire',

  emoji: '🔥',

  shortcodes: ['fire'],

  tags: ['hot', 'burn']

}, {

  name: 'rocket',

  emoji: '🚀',

  shortcodes: ['rocket'],

  tags: ['ship', 'launch']

}, {

  name: 'eyes',

  emoji: '👀',

  shortcodes: ['eyes'],

  tags: ['look', 'watch']

}, {

  name: 'tada',

  emoji: '🎉',

  shortcodes: ['tada'],

  tags: ['party', 'celebration']

}, {

  name: 'thinking',

  emoji: '🤔',

  shortcodes: ['thinking'],

  tags: ['hmm', 'think', 'consider']

}]

</script>

<template>

  <UEditor

    v-slot="{ editor }"

    v-model="value"

    :extensions="[Emoji]"

    content-type="markdown"

    placeholder="Type : to add emojis..."

    class="w-full min-h-26"

  >

    <UEditorEmojiMenu :editor="editor" :items="items" />

  </UEditor>

</template>
```

You can also pass an array of arrays to the `items` prop to create separated groups of items.

### Char

Use the `char` prop to change the trigger character. Defaults to `:`.

### Options

Use the `options` prop to customize the positioning behavior using [Floating UI options](https://floating-ui.com/docs/computeposition#options).

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `size` | `'md'` | ` "xs" \| "md" \| "sm" \| "lg" \| "xl"` |
| `items` |  | ` T[] \| T[][]` |
| `editor` |  | `Editor` |
| `char` | `':'` | ` string`  The trigger character (e.g., '/', '@', ':') |
| `pluginKey` | `'emojiMenu'` | ` string` |
| `filterFields` | `["name", "shortcodes", "tags"]` | ` string[]`  Fields to filter items by. |
| `limit` | `42` | ` number`  Maximum number of items to display |
| `options` | `{ strategy: 'absolute', placement: 'bottom-start', offset: 8, shift: { padding: 8 } }` | ` FloatingUIOptions`  - [https://floating-ui.com/docs/computePosition#options](https://floating-ui.com/docs/computePosition#options) |
| `appendTo` |  | ` HTMLElement \| (): HTMLElement`  The DOM element to append the menu to. Default is the editor's parent element.  Sometimes the menu needs to be appended to a different DOM context due to accessibility, clipping, or z-index issues. |
| `ui` |  | ` { content?: ClassNameValue; viewport?: ClassNameValue; group?: ClassNameValue; label?: ClassNameValue; separator?: ClassNameValue; item?: ClassNameValue; itemLeadingIcon?: ClassNameValue; itemLeadingAvatar?: ClassNameValue; itemLeadingAvatarSize?: ClassNameValue; itemWrapper?: ClassNameValue; itemLabel?: ClassNameValue; itemDescription?: ClassNameValue; itemLabelExternalIcon?: ClassNameValue; }` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    editorEmojiMenu: {

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

        editorEmojiMenu: {

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
```**