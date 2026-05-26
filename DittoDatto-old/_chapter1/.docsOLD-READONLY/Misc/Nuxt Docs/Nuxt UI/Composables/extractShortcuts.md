---
title: Vue extractShortcuts Composable
source: https://ui.nuxt.com/docs/composables/extract-shortcuts
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: A utility to extract keyboard shortcuts from menu items.
tags:
  - Nuxt
  - Nuxt-UI
---
## Usage

Use the auto-imported `extractShortcuts` utility to define keyboard shortcuts from menu items. It extracts shortcuts from components like [DropdownMenu](https://ui.nuxt.com/docs/components/dropdown-menu), [ContextMenu](https://ui.nuxt.com/docs/components/context-menu) or [CommandPalette](https://ui.nuxt.com/docs/components/command-palette) where items have `kbds` defined.

```
<script setup lang="ts">

const items = [{

  label: 'Save',

  icon: 'i-lucide-file-down',

  kbds: ['meta', 'S'],

  onSelect() {

    save()

  }

}, {

  label: 'Copy',

  icon: 'i-lucide-copy',

  kbds: ['meta', 'C'],

  onSelect() {

    copy()

  }

}]

defineShortcuts(extractShortcuts(items))

</script>
```

Learn more about keyboard shortcuts in the **defineShortcuts** composable documentation.

## API

`extractShortcuts(items: any[] | any[][], separator?: '_' | '-'): ShortcutsConfig`

Extracts keyboard shortcuts from an array of menu items and returns a configuration object compatible with `defineShortcuts`.

#### Parameters

**Returns:** A `ShortcutsConfig` object that can be passed directly to `defineShortcuts`.

## Examples

### With nested items

The utility recursively traverses `children` and `items` properties to extract shortcuts from nested menu structures.

### With key sequences

Use the `separator` parameter to create key sequences instead of key combinations.[extendLocale](https://ui.nuxt.com/docs/composables/extend-locale)

[

A utility to extend an existing locale with custom translations.

](https://ui.nuxt.com/docs/composables/extend-locale)[

useOverlay

A composable to programmatically control overlays.

](https://ui.nuxt.com/docs/composables/use-overlay)