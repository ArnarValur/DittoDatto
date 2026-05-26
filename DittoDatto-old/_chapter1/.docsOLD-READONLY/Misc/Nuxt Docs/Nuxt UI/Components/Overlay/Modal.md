---
title: "Vue Modal Component"
source: "https://ui.nuxt.com/docs/components/modal"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A dialog window that can be used to display a message or request user input."
tags:
---
## Modal

[Dialog](https://reka-ui.com/docs/components/dialog) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Modal.vue)

A dialog window that can be used to display a message or request user input.

## Usage

Use a [Button](https://ui.nuxt.com/docs/components/button) or any other component in the default slot of the Modal.

Then, use the `#content` slot to add the content displayed when the Modal is open.

```
<template>

  <UModal>

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #content>

      <Placeholder class="h-48 m-4" />

    </template>

  </UModal>

</template>
```

You can also use the `#header`, `#body` and `#footer` slots to customize the Modal's content.

Use the `title` prop to set the title of the Modal's header.

```
<template>

  <UModal title="Modal with title">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #body>

      <Placeholder class="h-48" />

    </template>

  </UModal>

</template>
```

### Description

Use the `description` prop to set the description of the Modal's header.

```
<template>

  <UModal

    title="Modal with description"

    description="Lorem ipsum dolor sit amet, consectetur adipiscing elit."

  >

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #body>

      <Placeholder class="h-48" />

    </template>

  </UModal>

</template>
```

### Close

Use the `close` prop to customize or hide the close button (with `false` value) displayed in the Modal's header.

You can pass any property from the [Button](https://ui.nuxt.com/docs/components/button) component to customize it.

```
<template>

  <UModal

    title="Modal with close button"

    :close="{

      color: 'primary',

      variant: 'outline',

      class: 'rounded-full'

    }"

  >

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #body>

      <Placeholder class="h-48" />

    </template>

  </UModal>

</template>
```

The close button is not displayed if the `#content` slot is used as it's a part of the header.

### Close Icon

Use the `close-icon` prop to customize the close button [Icon](https://ui.nuxt.com/docs/components/icon). Defaults to `i-lucide-x`.

```
<template>

  <UModal title="Modal with close button" close-icon="i-lucide-arrow-right">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #body>

      <Placeholder class="h-48" />

    </template>

  </UModal>

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.close` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.close` key.

### Transition

Use the `transition` prop to control whether the Modal is animated or not. Defaults to `true`.

```
<template>

  <UModal :transition="false" title="Modal without transition">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #body>

      <Placeholder class="h-48" />

    </template>

  </UModal>

</template>
```

### Overlay

Use the `overlay` prop to control whether the Modal has an overlay or not. Defaults to `true`.

```
<template>

  <UModal :overlay="false" title="Modal without overlay">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #body>

      <Placeholder class="h-48" />

    </template>

  </UModal>

</template>
```

### Modal

Use the `modal` prop to control whether the Modal blocks interaction with outside content. Defaults to `true`.

When `modal` is set to `false`, the overlay is automatically disabled and outside content becomes interactive.

```
<template>

  <UModal :modal="false" title="Modal interactive">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #body>

      <Placeholder class="h-48" />

    </template>

  </UModal>

</template>
```

### Dismissible

Use the `dismissible` prop to control whether the Modal is dismissible when clicking outside of it or pressing escape. Defaults to `true`.

A `close:prevent` event will be emitted when the user tries to close it.

You can combine `modal: false` with `dismissible: false` to make the Modal's background interactive without closing it.

```
<template>

  <UModal :dismissible="false" title="Modal non-dismissible">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #body>

      <Placeholder class="h-48" />

    </template>

  </UModal>

</template>
```

### Scrollable 4.2+

Use the `scrollable` prop to make the Modal's content scrollable within the overlay.

As the overlay is needed for scrolling, `modal: false` is not compatible and `overlay: false` only removes the background.

```
<template>

  <UModal scrollable title="Modal scrollable">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #body>

      <Placeholder class="h-full" />

    </template>

  </UModal>

</template>
```

### Fullscreen

Use the `fullscreen` prop to make the Modal fullscreen.

```
<template>

  <UModal fullscreen title="Modal fullscreen">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #body>

      <Placeholder class="h-full" />

    </template>

  </UModal>

</template>
```

## Examples

### Control open state

You can control the open state by using the `default-open` prop or the `v-model:open` directive.

```
<script setup lang="ts">

const open = ref(false)

defineShortcuts({

  o: () => open.value = !open.value

})

</script>

<template>

  <UModal v-model:open="open">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #content>

      <Placeholder class="h-48 m-4" />

    </template>

  </UModal>

</template>
```

In this example, leveraging [`defineShortcuts`](https://ui.nuxt.com/docs/composables/define-shortcuts), you can toggle the Modal by pressing O.

This allows you to move the trigger outside of the Modal or remove it entirely.

### Programmatic usage

You can use the [`useOverlay`](https://ui.nuxt.com/docs/composables/use-overlay) composable to open a Modal programmatically.

Make sure to wrap your app with the [`App`](https://ui.nuxt.com/docs/components/app) component which uses the [`OverlayProvider`](https://github.com/nuxt/ui/blob/v4/src/runtime/components/OverlayProvider.vue) component.

First, create a modal component that will be opened programmatically:

ModalExample.vue

```
<script setup lang="ts">

defineProps<{

  count: number

}>()

const emit = defineEmits<{ close: [boolean] }>()

</script>

<template>

  <UModal

    :close="{ onClick: () => emit('close', false) }"

    :title="\`This modal was opened programmatically ${count} times\`"

  >

    <template #footer>

      <div class="flex gap-2">

        <UButton color="neutral" label="Dismiss" @click="emit('close', false)" />

        <UButton label="Success" @click="emit('close', true)" />

      </div>

    </template>

  </UModal>

</template>
```

We are emitting a `close` event when the modal is closed or dismissed here. You can emit any data through the `close` event, however, the event must be emitted in order to capture the return value.

Then, use it in your app:

```
<script setup lang="ts">

import { LazyModalExample } from '#components'

const count = ref(0)

const toast = useToast()

const overlay = useOverlay()

const modal = overlay.create(LazyModalExample)

async function open() {

  const instance = modal.open({

    count: count.value

  })

  const shouldIncrement = await instance.result

  if (shouldIncrement) {

    count.value++

    toast.add({

      title: \`Success: ${shouldIncrement}\`,

      color: 'success',

      id: 'modal-success'

    })

    // Update the count

    modal.patch({

      count: count.value

    })

    return

  }

  toast.add({

    title: \`Dismissed: ${shouldIncrement}\`,

    color: 'error',

    id: 'modal-dismiss'

  })

}

</script>

<template>

  <UButton label="Open" color="neutral" variant="subtle" @click="open" />

</template>
```

You can close the modal within the modal component by emitting `emit('close')`.

You can nest modals within each other.

Use the `#footer` slot to add content after the Modal's body.

### With command palette

You can use a [CommandPalette](https://ui.nuxt.com/docs/components/command-palette) component inside the Modal's content.

```
<script setup lang="ts">

const searchTerm = ref('')

const { data: users, status } = await useFetch('https://jsonplaceholder.typicode.com/users', {

  key: 'command-palette-users',

  params: { q: searchTerm },

  transform: (data: { id: number, name: string, email: string }[]) => {

    return data?.map(user => ({ id: user.id, label: user.name, suffix: user.email, avatar: { src: \`https://i.pravatar.cc/120?img=${user.id}\` } })) || []

  },

  lazy: true

})

const groups = computed(() => [{

  id: 'users',

  label: searchTerm.value ? \`Users matching “${searchTerm.value}”...\` : 'Users',

  items: users.value || [],

  ignoreFilter: true

}])

</script>

<template>

  <UModal>

    <UButton

      label="Search users..."

      color="neutral"

      variant="subtle"

      icon="i-lucide-search"

    />

    <template #content>

      <UCommandPalette

        v-model:search-term="searchTerm"

        :loading="status === 'pending'"

        :groups="groups"

        placeholder="Search users..."

        class="h-80"

      />

    </template>

  </UModal>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `title` |  | ` string` |
| `description` |  | ` string` |
| `content` |  | ` DialogContentProps & Partial<EmitsToProps<DialogContentImplEmits>>`  The content of the modal. |
| `overlay` | `true` | `boolean`  Render an overlay behind the modal. |
| `scrollable` | `false` | `boolean`  When `true`, enables scrollable overlay mode where content scrolls within the overlay. |
| `transition` | `true` | `boolean`  Animate the modal when opening or closing. |
| `fullscreen` | `false` | `boolean `  When `true`, the modal will take up the full screen. |
| `portal` | `true` | ` string \| false \| true \| HTMLElement`  Render the modal in a portal. |
| `close` | `true` | `boolean \| Omit<ButtonProps, LinkPropsKeys>`  Display a close button to dismiss the modal.`{ size: 'md', color: 'neutral', variant: 'ghost' }` |
| `closeIcon` | `appConfig.ui.icons.close` | `any`  The icon displayed in the close button. |
| `dismissible` | `true` | `boolean `  When `false`, the modal will not close when clicking outside or pressing escape. |
| `open` |  | `boolean `  The controlled open state of the dialog. Can be binded as `v-model:open`. |
| `defaultOpen` |  | `boolean `  The open state of the dialog when it is initially rendered. Use when you do not need to control its open state. |
| `modal` | `true` | `boolean `  The modality of the dialog When set to `true`,   interaction with outside elements will be disabled and only dialog content will be visible to screen readers. |
| `ui` |  | ` { overlay?: ClassNameValue; content?: ClassNameValue; header?: ClassNameValue; wrapper?: ClassNameValue; body?: ClassNameValue; footer?: ClassNameValue; title?: ClassNameValue; description?: ClassNameValue; close?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{ open: boolean; }` |
| `content` | `{ close: () => void; }` |
| `header` | `{ close: () => void; }` |
| `title` | `{}` |
| `description` | `{}` |
| `actions` | `{}` |
| `close` | `{ ui: object; }` |
| `body` | `{ close: () => void; }` |
| `footer` | `{ close: () => void; }` |

### Emits

| Event | Type |
| --- | --- |
| `after:leave` | `[]` |
| `after:enter` | `[]` |
| `close:prevent` | `[]` |
| `update:open` | `[value: boolean]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    modal: {

      slots: {

        overlay: 'fixed inset-0',

        content: 'bg-default divide-y divide-default flex flex-col focus:outline-none',

        header: 'flex items-center gap-1.5 p-4 sm:px-6 min-h-16',

        wrapper: '',

        body: 'flex-1 p-4 sm:p-6',

        footer: 'flex items-center gap-1.5 p-4 sm:px-6',

        title: 'text-highlighted font-semibold',

        description: 'mt-1 text-muted text-sm',

        close: 'absolute top-4 end-4'

      },

      variants: {

        transition: {

          true: {

            overlay: 'data-[state=open]:animate-[fade-in_200ms_ease-out] data-[state=closed]:animate-[fade-out_200ms_ease-in]',

            content: 'data-[state=open]:animate-[scale-in_200ms_ease-out] data-[state=closed]:animate-[scale-out_200ms_ease-in]'

          }

        },

        fullscreen: {

          true: {

            content: 'inset-0'

          },

          false: {

            content: 'w-[calc(100vw-2rem)] max-w-lg rounded-lg shadow-lg ring ring-default'

          }

        },

        overlay: {

          true: {

            overlay: 'bg-elevated/75'

          }

        },

        scrollable: {

          true: {

            overlay: 'overflow-y-auto',

            content: 'relative'

          },

          false: {

            content: 'fixed',

            body: 'overflow-y-auto'

          }

        }

      },

      compoundVariants: [

        {

          scrollable: true,

          fullscreen: false,

          class: {

            overlay: 'grid place-items-center p-4 sm:py-8'

          }

        },

        {

          scrollable: false,

          fullscreen: false,

          class: {

            content: 'top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 max-h-[calc(100dvh-2rem)] sm:max-h-[calc(100dvh-4rem)] overflow-hidden'

          }

        }

      ]

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

        modal: {

          slots: {

            overlay: 'fixed inset-0',

            content: 'bg-default divide-y divide-default flex flex-col focus:outline-none',

            header: 'flex items-center gap-1.5 p-4 sm:px-6 min-h-16',

            wrapper: '',

            body: 'flex-1 p-4 sm:p-6',

            footer: 'flex items-center gap-1.5 p-4 sm:px-6',

            title: 'text-highlighted font-semibold',

            description: 'mt-1 text-muted text-sm',

            close: 'absolute top-4 end-4'

          },

          variants: {

            transition: {

              true: {

                overlay: 'data-[state=open]:animate-[fade-in_200ms_ease-out] data-[state=closed]:animate-[fade-out_200ms_ease-in]',

                content: 'data-[state=open]:animate-[scale-in_200ms_ease-out] data-[state=closed]:animate-[scale-out_200ms_ease-in]'

              }

            },

            fullscreen: {

              true: {

                content: 'inset-0'

              },

              false: {

                content: 'w-[calc(100vw-2rem)] max-w-lg rounded-lg shadow-lg ring ring-default'

              }

            },

            overlay: {

              true: {

                overlay: 'bg-elevated/75'

              }

            },

            scrollable: {

              true: {

                overlay: 'overflow-y-auto',

                content: 'relative'

              },

              false: {

                content: 'fixed',

                body: 'overflow-y-auto'

              }

            }

          },

          compoundVariants: [

            {

              scrollable: true,

              fullscreen: false,

              class: {

                overlay: 'grid place-items-center p-4 sm:py-8'

              }

            },

            {

              scrollable: false,

              fullscreen: false,

              class: {

                content: 'top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 max-h-[calc(100dvh-2rem)] sm:max-h-[calc(100dvh-4rem)] overflow-hidden'

              }

            }

          ]

        }

      }

    })

  ]

})
```

## Changelog

[`184ea`](https://github.com/nuxt/ui/commit/184eaab1cd5f4f4943b509ea1a3efb1b6f6d7f91) — chore: reduce type verbosity by omitting link props from action buttons

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`24089`](https://github.com/nuxt/ui/commit/240897eaf6ee1b89bea3145b83458136513a451d) — feat: add `scrollable` prop ([#5306](https://github.com/nuxt/ui/issues/5306))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`80994`](https://github.com/nuxt/ui/commit/80994401c6ca8ce29226104bef83c98f09585854) — fix: remove close autofocus prevent ([#5191](https://github.com/nuxt/ui/issues/5191))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`81569`](https://github.com/nuxt/ui/commit/81569713e9da9d5531ecdf4614660b84c686fa81) — feat: add `actions` slot ([#4358](https://github.com/nuxt/ui/issues/4358))

[`c3adc`](https://github.com/nuxt/ui/commit/c3adc381c90dad7152e27fc303ee678efc7c4c94) — fix: prevent scrollbars overflow ([#4368](https://github.com/nuxt/ui/issues/4368))

[`be41a`](https://github.com/nuxt/ui/commit/be41aed1f3d3476801e1840dbb8766926bc93c05) — fix: remove default `md` size on buttons ([#4357](https://github.com/nuxt/ui/issues/4357))

[`150b3`](https://github.com/nuxt/ui/commit/150b334b1d242c6dc132193e23359c03e6f35666) — fix: don't emit `close:prevent` on `closeAutoFocus`

[`5835e`](https://github.com/nuxt/ui/commit/5835eb5f0f835b5f03646dec78f85b2f556a109b) — feat: add `close` method in slots ([#4219](https://github.com/nuxt/ui/issues/4219))

[`d9e9f`](https://github.com/nuxt/ui/commit/d9e9fea35e4b22d68324c9e85b3aa221a7987d0f) — feat: add `after:enter` event ([#4187](https://github.com/nuxt/ui/issues/4187))

[`f4864`](https://github.com/nuxt/ui/commit/f4864233812eac0ed37e0a2d076a95c285a22c01) — feat: add `close:prevent` event ([#3958](https://github.com/nuxt/ui/issues/3958))

[`29fa4`](https://github.com/nuxt/ui/commit/29fa46276d6bf69b5b87880c476c6f778c2820bf) — feat: add global `portal` prop ([#3688](https://github.com/nuxt/ui/issues/3688))

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`b9983`](https://github.com/nuxt/ui/commit/b9983549a4b743724ea3ef99cc4a243f5ca41e53) — fix: improve generic types ([#3331](https://github.com/nuxt/ui/issues/3331))

[`5dec0`](https://github.com/nuxt/ui/commit/5dec0e16e28549b8833aaab17a87fada63d6598c) — feat: handle events in `content` prop

[`f4c41`](https://github.com/nuxt/ui/commit/f4c417d9ef5409b52084bdf9d8cbccee3139709f) — fix: prevent unnecessary close instantiation