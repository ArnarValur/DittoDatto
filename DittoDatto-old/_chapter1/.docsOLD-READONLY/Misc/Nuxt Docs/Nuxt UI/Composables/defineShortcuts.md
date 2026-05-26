---
title: "Vue defineShortcuts Composable"
source: "https://ui.nuxt.com/docs/composables/define-shortcuts"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A composable to define keyboard shortcuts in your app."
tags:
---
## defineShortcuts

A composable to define keyboard shortcuts in your app.

## Usage

Use the auto-imported `defineShortcuts` composable to define keyboard shortcuts.

```
<script setup lang="ts">

const open = ref(false)

defineShortcuts({

  meta_k: () => {

    open.value = !open.value

  }

})

</script>
```

- Shortcuts are automatically adjusted for non-macOS platforms, converting `meta` to `ctrl`.
- The composable uses VueUse's [`useEventListener`](https://vueuse.org/core/useEventListener/) to handle keydown events.
- For a complete list of available shortcut keys, refer to the [`KeyboardEvent.key`](https://developer.mozilla.org/en-US/docs/Web/API/UI_Events/Keyboard_event_key_values) API documentation. Note that the key should be written in lowercase.

Learn how to display shortcuts in components in the **Kbd** component documentation.

## API

`defineShortcuts(config: ShortcutsConfig, options?: ShortcutsOptions): void`

Define keyboard shortcuts for your application.

#### Parameters

config

ShortcutsConfig

An object where keys are shortcut definitions and values are either handler functions or shortcut configuration objects.

options

ShortcutsOptions

Optional configuration for the shortcuts behavior.

#### Shortcut definition

Shortcuts are defined using the following format:

- Single key: `'a'`, `'b'`, `'1'`, `'?'`, etc.
- Key combinations: Use `_` to separate keys, e.g., `'meta_k'`, `'ctrl_shift_f'`
- Key sequences: Use `-` to define a sequence, e.g., `'g-d'`

#### Modifiers

- `meta`: Represents `⌘ Command` on macOS and `Ctrl` on other platforms
- `ctrl`: Represents `Ctrl` on all platforms
- `shift`: Used for alphabetic keys when Shift is required

#### Special keys

- `escape`: Triggers on Esc key
- `enter`: Triggers on Enter key
- `arrowleft`, `arrowright`, `arrowup`, `arrowdown`: Trigger on respective arrow keys

#### Shortcut configuration

Each shortcut can be defined as a function or an object with the following properties:

`interface ShortcutConfig { handler: () => void; usingInput?: boolean | string }`

#### Parameters

handler

() => void

Function to be executed when the shortcut is triggered.

usingInput

boolean | string

Controls when the shortcut should trigger based on input focus:
- `false` (default): Shortcut only triggers when no input is focused
- `true`: Shortcut triggers even when any input is focused
- `string`: Shortcut only triggers when the specified input (by name) is focused

## Examples

### Basic usage

### With input focus handling

The `usingInput` option allows you to specify that a shortcut should only trigger when a specific input is focused.

```
<template>

  <UInput v-model="query" name="queryInput" />

</template>

<script setup lang="ts">

const query = ref('')

defineShortcuts({

  enter: {

    usingInput: 'queryInput',

    handler: () => performSearch()

  },

  escape: {

    usingInput: true,

    handler: () => clearSearch()

  }

})

</script>
```

Use the `extractShortcuts` utility to automatically define shortcuts from menu items.

Learn more about the **extractShortcuts** utility.[defineLocale](https://ui.nuxt.com/docs/composables/define-locale)

[

A utility to create a custom locale for your app.

](https://ui.nuxt.com/docs/composables/define-locale)[

extendLocale

A utility to extend an existing locale with custom translations.

](https://ui.nuxt.com/docs/composables/extend-locale)