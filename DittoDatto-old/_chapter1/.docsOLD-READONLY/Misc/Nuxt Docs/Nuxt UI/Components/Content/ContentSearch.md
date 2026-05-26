---
title: "Vue ContentSearch Component"
source: "https://ui.nuxt.com/docs/components/content-search"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A ready to use CommandPalette to add to your documentation."
tags:
---
## ContentSearch

[CommandPalette](https://ui.nuxt.com/docs/components/command-palette) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/content/ContentSearch.vue)

A ready to use CommandPalette to add to your documentation.

This component is only available when the `@nuxt/content` module is installed.

## Usage

The ContentSearch component extends the [CommandPalette](https://ui.nuxt.com/docs/components/command-palette) component, so you can pass any property such as `icon`, `placeholder`, etc.

Use the `files` and `navigation` props with the `files` and `navigation` values you fetched using the `queryCollectionSearchSections` and `queryCollectionNavigation` composables from `@nuxt/content`.

You can open the CommandPalette by pressing Ctrl K, by using the [ContentSearchButton](https://ui.nuxt.com/docs/components/content-search-button) component or by using the `useContentSearch` composable: `const { open } = useContentSearch()`.

### Shortcut

Use the `shortcut` prop to change the shortcut used in [defineShortcuts](https://ui.nuxt.com/docs/composables/define-shortcuts) to open the ContentSearch component. Defaults to `meta_k` (Ctrl K).

app.vue

```
<template>

  <UApp>

    <ClientOnly>

      <LazyUContentSearch

        v-model:search-term="searchTerm"

        shortcut="meta_k"

        :files="files"

        :navigation="navigation"

        :fuse="{ resultLimit: 42 }"

      />

    </ClientOnly>

  </UApp>

</template>
```

### Color Mode

By default, a group of commands will be added to the command palette so you can switch between light and dark mode. This will only take effect if the `colorMode` is not forced in a specific page which can be achieved through `definePageMeta`:

pages/index.vue

```
<script setup lang="ts">

definePageMeta({

  colorMode: 'dark'

})

</script>
```

You can disable this behavior by setting the `color-mode` prop to `false`:

app.vue

```
<template>

  <UApp>

    <ClientOnly>

      <LazyUContentSearch

        v-model:search-term="searchTerm"

        :color-mode="false"

        :files="files"

        :navigation="navigation"

        :fuse="{ resultLimit: 42 }"

      />

    </ClientOnly>

  </UApp>

</template>
```

## Examples

### Within app.vue

Use the ContentSearch component in your `app.vue` or in a layout:

app.vue

```
<script setup lang="ts">

const { data: navigation } = await useAsyncData('navigation', () => queryCollectionNavigation('content'))

const { data: files } = useLazyAsyncData('search', () => queryCollectionSearchSections('content'), {

  server: false

})

const links = [{

  label: 'Docs',

  icon: 'i-lucide-book',

  to: '/docs/getting-started'

}, {

  label: 'Components',

  icon: 'i-lucide-box',

  to: '/docs/components'

}, {

  label: 'Showcase',

  icon: 'i-lucide-presentation',

  to: '/showcase'

}]

const searchTerm = ref('')

</script>

<template>

  <UApp>

    <ClientOnly>

      <LazyUContentSearch

        v-model:search-term="searchTerm"

        :files="files"

        shortcut="meta_k"

        :navigation="navigation"

        :links="links"

        :fuse="{ resultLimit: 42 }"

      />

    </ClientOnly>

  </UApp>

</template>
```

It is recommended to wrap the `ContentSearch` component in a [ClientOnly](https://nuxt.com/docs/api/components/client-only) component so it's not rendered on the server.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `size` | `'md'` | ` "sm" \| "md" \| "xs" \| "lg" \| "xl"` |
| `icon` | `appConfig.ui.icons.search` | `any`  The icon displayed in the input. |
| `placeholder` | `t('commandPalette.placeholder')` | ` string`  The placeholder text for the input. |
| `autofocus` | `true` | `boolean`  Automatically focus the input when component is mounted. |
| `loading` |  | `boolean `  When `true`, the loading icon will be displayed. |
| `loadingIcon` | `appConfig.ui.icons.loading` | `any`  The icon when the `loading` prop is `true`. |
| `close` | `true` | `boolean \| Omit<ButtonProps, LinkPropsKeys>`  Display a close button in the input (useful when inside a Modal for example).`{ size: 'md', color: 'neutral', variant: 'ghost' }` |
| `closeIcon` | `appConfig.ui.icons.close` | `any`  The icon displayed in the close button. |
| `shortcut` | `'meta_k'` | ` string`  Keyboard shortcut to open the search (used by [`defineShortcuts`](https://ui.nuxt.com/docs/composables/define-shortcuts)) |
| `links` |  | ` T[]`  Links group displayed as the first group in the command palette. |
| `navigation` |  | ` ContentNavigationItem[]` |
| `groups` |  | ` CommandPaletteGroup<ContentSearchItem>[]` |
| `files` |  | ` ContentSearchFile[]` |
| `fuse` | `{ fuseOptions: { includeMatches: true } }` | ` n<T>`  Options for [useFuse](https://vueuse.org/integrations/useFuse) passed to the [CommandPalette](https://ui.nuxt.com/docs/components/command-palette). |
| `colorMode` | `true` | `boolean `  When `true`, the theme command will be added to the groups. |
| `title` |  | ` string` |
| `description` |  | ` string` |
| `overlay` | `true` | `boolean `  Render an overlay behind the modal. |
| `transition` | `true` | `boolean `  Animate the modal when opening or closing. |
| `content` |  | ` DialogContentProps & Partial<EmitsToProps<DialogContentImplEmits>>`  The content of the modal. |
| `dismissible` | `true` | `boolean `  When `false`, the modal will not close when clicking outside or pressing escape. |
| `fullscreen` | `false` | `boolean `  When `true`, the modal will take up the full screen. |
| `modal` |  | `boolean `  The modality of the dialog When set to `true`,   interaction with outside elements will be disabled and only dialog content will be visible to screen readers. |
| `portal` | `true` | ` string \| false \| true \| HTMLElement`  Render the modal in a portal. |
| `searchTerm` | `''` | ` string` |
| `ui` |  | ` { modal?: ClassNameValue; input?: ClassNameValue; } & { root?: ClassNameValue; input?: ClassNameValue; close?: ClassNameValue; back?: ClassNameValue; content?: ClassNameValue; footer?: ClassNameValue; viewport?: ClassNameValue; group?: ClassNameValue; empty?: ClassNameValue; label?: ClassNameValue; item?: ClassNameValue; itemLeadingIcon?: ClassNameValue; itemLeadingAvatar?: ClassNameValue; itemLeadingAvatarSize?: ClassNameValue; itemLeadingChip?: ClassNameValue; itemLeadingChipSize?: ClassNameValue; itemTrailing?: ClassNameValue; itemTrailingIcon?: ClassNameValue; itemTrailingHighlightedIcon?: ClassNameValue; itemTrailingKbds?: ClassNameValue; itemTrailingKbdsSize?: ClassNameValue; itemWrapper?: ClassNameValue; itemLabel?: ClassNameValue; itemDescription?: ClassNameValue; itemLabelBase?: ClassNameValue; itemLabelPrefix?: ClassNameValue; itemLabelSuffix?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `empty` | `{ searchTerm?: string \| undefined; }` |
| `footer` | `{ ui: { root: (props?: Record<string, any> \| undefined) => string; input: (props?: Record<string, any> \| undefined) => string; close: (props?: Record<string, any> \| undefined) => string; back: (props?: Record<string, any> \| undefined) => string; content: (props?: Record<string, any> \| undefined) => string; footer: (props?: Record<string, any> \| undefined) => string; viewport: (props?: Record<string, any> \| undefined) => string; group: (props?: Record<string, any> \| undefined) => string; empty: (props?: Record<string, any> \| undefined) => string; label: (props?: Record<string, any> \| undefined) => string; item: (props?: Record<string, any> \| undefined) => string; itemLeadingIcon: (props?: Record<string, any> \| undefined) => string; itemLeadingAvatar: (props?: Record<string, any> \| undefined) => string; itemLeadingAvatarSize: (props?: Record<string, any> \| undefined) => string; itemLeadingChip: (props?: Record<string, any> \| undefined) => string; itemLeadingChipSize: (props?: Record<string, any> \| undefined) => string; itemTrailing: (props?: Record<string, any> \| undefined) => string; itemTrailingIcon: (props?: Record<string, any> \| undefined) => string; itemTrailingHighlightedIcon: (props?: Record<string, any> \| undefined) => string; itemTrailingKbds: (props?: Record<string, any> \| undefined) => string; itemTrailingKbdsSize: (props?: Record<string, any> \| undefined) => string; itemWrapper: (props?: Record<string, any> \| undefined) => string; itemLabel: (props?: Record<string, any> \| undefined) => string; itemDescription: (props?: Record<string, any> \| undefined) => string; itemLabelBase: (props?: Record<string, any> \| undefined) => string; itemLabelPrefix: (props?: Record<string, any> \| undefined) => string; itemLabelSuffix: (props?: Record<string, any> \| undefined) => string; }; }` |
| `back` | `{ ui: { root: (props?: Record<string, any> \| undefined) => string; input: (props?: Record<string, any> \| undefined) => string; close: (props?: Record<string, any> \| undefined) => string; back: (props?: Record<string, any> \| undefined) => string; content: (props?: Record<string, any> \| undefined) => string; footer: (props?: Record<string, any> \| undefined) => string; viewport: (props?: Record<string, any> \| undefined) => string; group: (props?: Record<string, any> \| undefined) => string; empty: (props?: Record<string, any> \| undefined) => string; label: (props?: Record<string, any> \| undefined) => string; item: (props?: Record<string, any> \| undefined) => string; itemLeadingIcon: (props?: Record<string, any> \| undefined) => string; itemLeadingAvatar: (props?: Record<string, any> \| undefined) => string; itemLeadingAvatarSize: (props?: Record<string, any> \| undefined) => string; itemLeadingChip: (props?: Record<string, any> \| undefined) => string; itemLeadingChipSize: (props?: Record<string, any> \| undefined) => string; itemTrailing: (props?: Record<string, any> \| undefined) => string; itemTrailingIcon: (props?: Record<string, any> \| undefined) => string; itemTrailingHighlightedIcon: (props?: Record<string, any> \| undefined) => string; itemTrailingKbds: (props?: Record<string, any> \| undefined) => string; itemTrailingKbdsSize: (props?: Record<string, any> \| undefined) => string; itemWrapper: (props?: Record<string, any> \| undefined) => string; itemLabel: (props?: Record<string, any> \| undefined) => string; itemDescription: (props?: Record<string, any> \| undefined) => string; itemLabelBase: (props?: Record<string, any> \| undefined) => string; itemLabelPrefix: (props?: Record<string, any> \| undefined) => string; itemLabelSuffix: (props?: Record<string, any> \| undefined) => string; }; }` |
| `close` | `{ ui: { root: (props?: Record<string, any> \| undefined) => string; input: (props?: Record<string, any> \| undefined) => string; close: (props?: Record<string, any> \| undefined) => string; back: (props?: Record<string, any> \| undefined) => string; content: (props?: Record<string, any> \| undefined) => string; footer: (props?: Record<string, any> \| undefined) => string; viewport: (props?: Record<string, any> \| undefined) => string; group: (props?: Record<string, any> \| undefined) => string; empty: (props?: Record<string, any> \| undefined) => string; label: (props?: Record<string, any> \| undefined) => string; item: (props?: Record<string, any> \| undefined) => string; itemLeadingIcon: (props?: Record<string, any> \| undefined) => string; itemLeadingAvatar: (props?: Record<string, any> \| undefined) => string; itemLeadingAvatarSize: (props?: Record<string, any> \| undefined) => string; itemLeadingChip: (props?: Record<string, any> \| undefined) => string; itemLeadingChipSize: (props?: Record<string, any> \| undefined) => string; itemTrailing: (props?: Record<string, any> \| undefined) => string; itemTrailingIcon: (props?: Record<string, any> \| undefined) => string; itemTrailingHighlightedIcon: (props?: Record<string, any> \| undefined) => string; itemTrailingKbds: (props?: Record<string, any> \| undefined) => string; itemTrailingKbdsSize: (props?: Record<string, any> \| undefined) => string; itemWrapper: (props?: Record<string, any> \| undefined) => string; itemLabel: (props?: Record<string, any> \| undefined) => string; itemDescription: (props?: Record<string, any> \| undefined) => string; itemLabelBase: (props?: Record<string, any> \| undefined) => string; itemLabelPrefix: (props?: Record<string, any> \| undefined) => string; itemLabelSuffix: (props?: Record<string, any> \| undefined) => string; }; }` |
| `item` | `{ item: ContentSearchItem; index: number; ui: { root: (props?: Record<string, any> \| undefined) => string; input: (props?: Record<string, any> \| undefined) => string; close: (props?: Record<string, any> \| undefined) => string; back: (props?: Record<string, any> \| undefined) => string; content: (props?: Record<string, any> \| undefined) => string; footer: (props?: Record<string, any> \| undefined) => string; viewport: (props?: Record<string, any> \| undefined) => string; group: (props?: Record<string, any> \| undefined) => string; empty: (props?: Record<string, any> \| undefined) => string; label: (props?: Record<string, any> \| undefined) => string; item: (props?: Record<string, any> \| undefined) => string; itemLeadingIcon: (props?: Record<string, any> \| undefined) => string; itemLeadingAvatar: (props?: Record<string, any> \| undefined) => string; itemLeadingAvatarSize: (props?: Record<string, any> \| undefined) => string; itemLeadingChip: (props?: Record<string, any> \| undefined) => string; itemLeadingChipSize: (props?: Record<string, any> \| undefined) => string; itemTrailing: (props?: Record<string, any> \| undefined) => string; itemTrailingIcon: (props?: Record<string, any> \| undefined) => string; itemTrailingHighlightedIcon: (props?: Record<string, any> \| undefined) => string; itemTrailingKbds: (props?: Record<string, any> \| undefined) => string; itemTrailingKbdsSize: (props?: Record<string, any> \| undefined) => string; itemWrapper: (props?: Record<string, any> \| undefined) => string; itemLabel: (props?: Record<string, any> \| undefined) => string; itemDescription: (props?: Record<string, any> \| undefined) => string; itemLabelBase: (props?: Record<string, any> \| undefined) => string; itemLabelPrefix: (props?: Record<string, any> \| undefined) => string; itemLabelSuffix: (props?: Record<string, any> \| undefined) => string; }; }` |
| `item-leading` | `{ item: ContentSearchItem; index: number; ui: { root: (props?: Record<string, any> \| undefined) => string; input: (props?: Record<string, any> \| undefined) => string; close: (props?: Record<string, any> \| undefined) => string; back: (props?: Record<string, any> \| undefined) => string; content: (props?: Record<string, any> \| undefined) => string; footer: (props?: Record<string, any> \| undefined) => string; viewport: (props?: Record<string, any> \| undefined) => string; group: (props?: Record<string, any> \| undefined) => string; empty: (props?: Record<string, any> \| undefined) => string; label: (props?: Record<string, any> \| undefined) => string; item: (props?: Record<string, any> \| undefined) => string; itemLeadingIcon: (props?: Record<string, any> \| undefined) => string; itemLeadingAvatar: (props?: Record<string, any> \| undefined) => string; itemLeadingAvatarSize: (props?: Record<string, any> \| undefined) => string; itemLeadingChip: (props?: Record<string, any> \| undefined) => string; itemLeadingChipSize: (props?: Record<string, any> \| undefined) => string; itemTrailing: (props?: Record<string, any> \| undefined) => string; itemTrailingIcon: (props?: Record<string, any> \| undefined) => string; itemTrailingHighlightedIcon: (props?: Record<string, any> \| undefined) => string; itemTrailingKbds: (props?: Record<string, any> \| undefined) => string; itemTrailingKbdsSize: (props?: Record<string, any> \| undefined) => string; itemWrapper: (props?: Record<string, any> \| undefined) => string; itemLabel: (props?: Record<string, any> \| undefined) => string; itemDescription: (props?: Record<string, any> \| undefined) => string; itemLabelBase: (props?: Record<string, any> \| undefined) => string; itemLabelPrefix: (props?: Record<string, any> \| undefined) => string; itemLabelSuffix: (props?: Record<string, any> \| undefined) => string; }; }` |
| `item-label` | `{ item: ContentSearchItem; index: number; ui: { root: (props?: Record<string, any> \| undefined) => string; input: (props?: Record<string, any> \| undefined) => string; close: (props?: Record<string, any> \| undefined) => string; back: (props?: Record<string, any> \| undefined) => string; content: (props?: Record<string, any> \| undefined) => string; footer: (props?: Record<string, any> \| undefined) => string; viewport: (props?: Record<string, any> \| undefined) => string; group: (props?: Record<string, any> \| undefined) => string; empty: (props?: Record<string, any> \| undefined) => string; label: (props?: Record<string, any> \| undefined) => string; item: (props?: Record<string, any> \| undefined) => string; itemLeadingIcon: (props?: Record<string, any> \| undefined) => string; itemLeadingAvatar: (props?: Record<string, any> \| undefined) => string; itemLeadingAvatarSize: (props?: Record<string, any> \| undefined) => string; itemLeadingChip: (props?: Record<string, any> \| undefined) => string; itemLeadingChipSize: (props?: Record<string, any> \| undefined) => string; itemTrailing: (props?: Record<string, any> \| undefined) => string; itemTrailingIcon: (props?: Record<string, any> \| undefined) => string; itemTrailingHighlightedIcon: (props?: Record<string, any> \| undefined) => string; itemTrailingKbds: (props?: Record<string, any> \| undefined) => string; itemTrailingKbdsSize: (props?: Record<string, any> \| undefined) => string; itemWrapper: (props?: Record<string, any> \| undefined) => string; itemLabel: (props?: Record<string, any> \| undefined) => string; itemDescription: (props?: Record<string, any> \| undefined) => string; itemLabelBase: (props?: Record<string, any> \| undefined) => string; itemLabelPrefix: (props?: Record<string, any> \| undefined) => string; itemLabelSuffix: (props?: Record<string, any> \| undefined) => string; }; }` |
| `item-description` | `{ item: ContentSearchItem; index: number; ui: { root: (props?: Record<string, any> \| undefined) => string; input: (props?: Record<string, any> \| undefined) => string; close: (props?: Record<string, any> \| undefined) => string; back: (props?: Record<string, any> \| undefined) => string; content: (props?: Record<string, any> \| undefined) => string; footer: (props?: Record<string, any> \| undefined) => string; viewport: (props?: Record<string, any> \| undefined) => string; group: (props?: Record<string, any> \| undefined) => string; empty: (props?: Record<string, any> \| undefined) => string; label: (props?: Record<string, any> \| undefined) => string; item: (props?: Record<string, any> \| undefined) => string; itemLeadingIcon: (props?: Record<string, any> \| undefined) => string; itemLeadingAvatar: (props?: Record<string, any> \| undefined) => string; itemLeadingAvatarSize: (props?: Record<string, any> \| undefined) => string; itemLeadingChip: (props?: Record<string, any> \| undefined) => string; itemLeadingChipSize: (props?: Record<string, any> \| undefined) => string; itemTrailing: (props?: Record<string, any> \| undefined) => string; itemTrailingIcon: (props?: Record<string, any> \| undefined) => string; itemTrailingHighlightedIcon: (props?: Record<string, any> \| undefined) => string; itemTrailingKbds: (props?: Record<string, any> \| undefined) => string; itemTrailingKbdsSize: (props?: Record<string, any> \| undefined) => string; itemWrapper: (props?: Record<string, any> \| undefined) => string; itemLabel: (props?: Record<string, any> \| undefined) => string; itemDescription: (props?: Record<string, any> \| undefined) => string; itemLabelBase: (props?: Record<string, any> \| undefined) => string; itemLabelPrefix: (props?: Record<string, any> \| undefined) => string; itemLabelSuffix: (props?: Record<string, any> \| undefined) => string; }; }` |
| `item-trailing` | `{ item: ContentSearchItem; index: number; ui: { root: (props?: Record<string, any> \| undefined) => string; input: (props?: Record<string, any> \| undefined) => string; close: (props?: Record<string, any> \| undefined) => string; back: (props?: Record<string, any> \| undefined) => string; content: (props?: Record<string, any> \| undefined) => string; footer: (props?: Record<string, any> \| undefined) => string; viewport: (props?: Record<string, any> \| undefined) => string; group: (props?: Record<string, any> \| undefined) => string; empty: (props?: Record<string, any> \| undefined) => string; label: (props?: Record<string, any> \| undefined) => string; item: (props?: Record<string, any> \| undefined) => string; itemLeadingIcon: (props?: Record<string, any> \| undefined) => string; itemLeadingAvatar: (props?: Record<string, any> \| undefined) => string; itemLeadingAvatarSize: (props?: Record<string, any> \| undefined) => string; itemLeadingChip: (props?: Record<string, any> \| undefined) => string; itemLeadingChipSize: (props?: Record<string, any> \| undefined) => string; itemTrailing: (props?: Record<string, any> \| undefined) => string; itemTrailingIcon: (props?: Record<string, any> \| undefined) => string; itemTrailingHighlightedIcon: (props?: Record<string, any> \| undefined) => string; itemTrailingKbds: (props?: Record<string, any> \| undefined) => string; itemTrailingKbdsSize: (props?: Record<string, any> \| undefined) => string; itemWrapper: (props?: Record<string, any> \| undefined) => string; itemLabel: (props?: Record<string, any> \| undefined) => string; itemDescription: (props?: Record<string, any> \| undefined) => string; itemLabelBase: (props?: Record<string, any> \| undefined) => string; itemLabelPrefix: (props?: Record<string, any> \| undefined) => string; itemLabelSuffix: (props?: Record<string, any> \| undefined) => string; }; }` |
| `content` | `{ close: () => void; }` |

### Emits

| Event | Type |
| --- | --- |
| `update:searchTerm` | `[value: string]` |

### Expose

When accessing the component via a template ref, you can use the following:

| Name | Type |
| --- | --- |
| `commandPaletteRef` | `Ref<InstanceType<typeof UCommandPalette> \| null>` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    contentSearch: {

      slots: {

        modal: '',

        input: ''

      },

      variants: {

        fullscreen: {

          false: {

            modal: 'sm:max-w-3xl h-full sm:h-[28rem]'

          }

        },

        size: {

          xs: {

            input: '[&>input]:text-sm'

          },

          sm: {

            input: '[&>input]:text-sm'

          },

          md: {

            input: '[&>input]:text-base/5'

          },

          lg: {

            input: '[&>input]:text-base/5'

          },

          xl: {

            input: '[&>input]:text-lg'

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

        contentSearch: {

          slots: {

            modal: '',

            input: ''

          },

          variants: {

            fullscreen: {

              false: {

                modal: 'sm:max-w-3xl h-full sm:h-[28rem]'

              }

            },

            size: {

              xs: {

                input: '[&>input]:text-sm'

              },

              sm: {

                input: '[&>input]:text-sm'

              },

              md: {

                input: '[&>input]:text-base/5'

              },

              lg: {

                input: '[&>input]:text-base/5'

              },

              xl: {

                input: '[&>input]:text-lg'

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

[`3ae04`](https://github.com/nuxt/ui/commit/3ae04c64aa489d1ff9f3bc5a47e211629788764a) — feat: add `size` prop ([#5878](https://github.com/nuxt/ui/issues/5878))

[`184ea`](https://github.com/nuxt/ui/commit/184eaab1cd5f4f4943b509ea1a3efb1b6f6d7f91) — chore: reduce type verbosity by omitting link props from action buttons

[`70317`](https://github.com/nuxt/ui/commit/70317e55da0cf9760777eae4429a1ebe3a754b96) — fix: set full height on mobile to prevent jump

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`e751b`](https://github.com/nuxt/ui/commit/e751b37497a4a585b70b5fc80225e988e750ebf5) — fix: improve performances and filtering logic ([#5433](https://github.com/nuxt/ui/issues/5433))

[`fce2d`](https://github.com/nuxt/ui/commit/fce2df4e0660d0bdb3cdd4fb3041416824cbe893) — fix!: consistent exposed refs ([#5385](https://github.com/nuxt/ui/issues/5385))

[`8a259`](https://github.com/nuxt/ui/commit/8a259e4cc978cc17912b0506dcf47ed4d2d15bb7) — fix: de-duplicate description and suffix

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`095a0`](https://github.com/nuxt/ui/commit/095a0c1eec7c28e140202f260031fc6c57daef3a) — fix: proxy modal props to support fullscreen

[`3173b`](https://github.com/nuxt/ui/commit/3173bee38ce9e518076848999f14374600069d35) — fix: proxySlots reactivity ([#4969](https://github.com/nuxt/ui/issues/4969))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`946c2`](https://github.com/nuxt/ui/commit/946c2ec8875af2c3fc74862b2c29d08dfb4cf6e2) — fix: make `ui.modal` work

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components