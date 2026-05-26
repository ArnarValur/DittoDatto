---
title: "Vue useToast Composable"
source: "https://ui.nuxt.com/docs/composables/use-toast"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A composable to display toast notifications in your app."
tags:
---
## useToast

A composable to display toast notifications in your app.

## Usage

Use the auto-imported `useToast` composable to display [Toast](https://ui.nuxt.com/docs/components/toast) notifications.

```
<script setup lang="ts">

const toast = useToast()

</script>
```

- The `useToast` composable uses Nuxt's `useState` to manage the toast state, ensuring reactivity across your application.
- A maximum of 5 toasts are displayed at a time. When adding a new toast that would exceed this limit, the oldest toast is automatically removed.
- When removing a toast, there's a 200ms delay before it's actually removed from the state, allowing for exit animations.

Make sure to wrap your app with the [`App`](https://ui.nuxt.com/docs/components/app) component which uses our [`Toaster`](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Toaster.vue) component which uses the [`ToastProvider`](https://reka-ui.com/docs/components/toast#provider) component from Reka UI.

Learn how to customize the appearance and behavior of toasts in the **Toast** component documentation.

## API

`useToast()`

The `useToast` composable provides methods to manage toast notifications globally.

### add()

`add(toast: Partial<Toast>): Toast`

Adds a new toast notification.

#### Parameters

toast

Partial<Toast>

A partial `Toast` object with the following properties:

**Returns:** The complete `Toast` object that was added.

```
<script setup lang="ts">

const toast = useToast()

function showToast() {

  toast.add({

    title: 'Success',

    description: 'Your action was completed successfully.',

    color: 'success'

  })

}

</script>
```

### update()

`update(id: string | number, toast: Partial<Toast>): void`

Updates an existing toast notification.

#### Parameters

id

string | number

The unique identifier of the toast to update.

toast

Partial<Toast>

A partial `Toast` object with the properties to update.

```
<script setup lang="ts">

const toast = useToast()

function updateToast(id: string | number) {

  toast.update(id, {

    title: 'Updated Toast',

    description: 'This toast has been updated.'

  })

}

</script>
```

### remove()

`remove(id: string | number): void`

Removes a toast notification.

#### Parameters

id

string | number

The unique identifier of the toast to remove.

```
<script setup lang="ts">

const toast = useToast()

function removeToast(id: string | number) {

  toast.remove(id)

}

</script>
```

### clear()

`clear(): void`

Removes all toast notifications.

```
<script setup lang="ts">

const toast = useToast()

function clearAllToasts() {

  toast.clear()

}

</script>w
```

### toasts

`toasts: Ref<Toast[]>`

A reactive array containing all current toast notifications.

```
<script setup lang="ts">

const { toasts } = useToast()

</script>

<template>

  <div>

    <pre>{{ toasts }}</pre>

  </div>

</template>
```[useOverlay](https://ui.nuxt.com/docs/composables/use-overlay)

[

A composable to programmatically control overlays.

](https://ui.nuxt.com/docs/composables/use-overlay)