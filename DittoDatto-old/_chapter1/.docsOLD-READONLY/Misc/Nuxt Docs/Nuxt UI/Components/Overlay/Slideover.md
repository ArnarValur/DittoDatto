---
title: "Vue Slideover Component"
source: "https://ui.nuxt.com/docs/components/slideover"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A dialog that slides in from any side of the screen."
tags:
---
## Slideover

[Dialog](https://reka-ui.com/docs/components/dialog) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Slideover.vue)

A dialog that slides in from any side of the screen.

## Usage

Use a [Button](https://ui.nuxt.com/docs/components/button) or any other component in the default slot of the Slideover.

Then, use the `#content` slot to add the content displayed when the Slideover is open.

```
<template>

  <USlideover>

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #content>

      <Placeholder class="h-full m-4" />

    </template>

  </USlideover>

</template>
```

You can also use the `#header`, `#body` and `#footer` slots to customize the Slideover's content.

Use the `title` prop to set the title of the Slideover's header.

```
<template>

  <USlideover title="Slideover with title">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #body>

      <Placeholder class="h-full" />

    </template>

  </USlideover>

</template>
```

### Description

Use the `description` prop to set the description of the Slideover's header.

```
<template>

  <USlideover

    title="Slideover with description"

    description="Lorem ipsum dolor sit amet, consectetur adipiscing elit."

  >

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #body>

      <Placeholder class="h-full" />

    </template>

  </USlideover>

</template>
```

### Close

Use the `close` prop to customize or hide the close button (with `false` value) displayed in the Slideover's header.

You can pass any property from the [Button](https://ui.nuxt.com/docs/components/button) component to customize it.

```
<template>

  <USlideover

    title="Slideover with close button"

    :close="{

      color: 'primary',

      variant: 'outline',

      class: 'rounded-full'

    }"

  >

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #body>

      <Placeholder class="h-full" />

    </template>

  </USlideover>

</template>
```

The close button is not displayed if the `#content` slot is used as it's a part of the header.

### Close Icon

Use the `close-icon` prop to customize the close button [Icon](https://ui.nuxt.com/docs/components/icon). Defaults to `i-lucide-x`.

```
<template>

  <USlideover title="Slideover with close button" close-icon="i-lucide-arrow-right">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #body>

      <Placeholder class="h-full" />

    </template>

  </USlideover>

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.close` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.close` key.

### Side

Use the `side` prop to set the side of the screen where the Slideover will slide in from. Defaults to `right`.

```
<template>

  <USlideover side="left" title="Slideover with side">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #body>

      <Placeholder class="h-full min-h-48" />

    </template>

  </USlideover>

</template>
```

### Inset 4.3+

Use the `inset` prop to inset the Slideover from the edges.

```
<template>

  <USlideover side="right" inset title="Slideover with inset">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #body>

      <Placeholder class="min-w-96 min-h-96 size-full" />

    </template>

  </USlideover>

</template>
```

### Transition

Use the `transition` prop to control whether the Slideover is animated or not. Defaults to `true`.

```
<template>

  <USlideover :transition="false" title="Slideover without transition">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #body>

      <Placeholder class="h-full" />

    </template>

  </USlideover>

</template>
```

### Overlay

Use the `overlay` prop to control whether the Slideover has an overlay or not. Defaults to `true`.

```
<template>

  <USlideover :overlay="false" title="Slideover without overlay">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #body>

      <Placeholder class="h-full" />

    </template>

  </USlideover>

</template>
```

### Modal

Use the `modal` prop to control whether the Slideover blocks interaction with outside content. Defaults to `true`.

When `modal` is set to `false`, the overlay is automatically disabled and outside content becomes interactive.

```
<template>

  <USlideover :modal="false" title="Slideover interactive">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #body>

      <Placeholder class="h-full" />

    </template>

  </USlideover>

</template>
```

### Dismissible

Use the `dismissible` prop to control whether the Slideover is dismissible when clicking outside of it or pressing escape. Defaults to `true`.

A `close:prevent` event will be emitted when the user tries to close it.

You can combine `modal: false` with `dismissible: false` to make the Slideover's background interactive without closing it.

```
<template>

  <USlideover :dismissible="false" title="Slideover non-dismissible">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #body>

      <Placeholder class="h-full" />

    </template>

  </USlideover>

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

  <USlideover v-model:open="open">

    <UButton label="Open" color="neutral" variant="subtle" />

    <template #content>

      <Placeholder class="h-full m-4" />

    </template>

  </USlideover>

</template>
```

In this example, leveraging [`defineShortcuts`](https://ui.nuxt.com/docs/composables/define-shortcuts), you can toggle the Slideover by pressing O.

This allows you to move the trigger outside of the Slideover or remove it entirely.

### Programmatic usage

You can use the [`useOverlay`](https://ui.nuxt.com/docs/composables/use-overlay) composable to open a Slideover programmatically.

Make sure to wrap your app with the [`App`](https://ui.nuxt.com/docs/components/app) component which uses the [`OverlayProvider`](https://github.com/nuxt/ui/blob/v4/src/runtime/components/OverlayProvider.vue) component.

First, create a slideover component that will be opened programmatically:

SlideoverExample.vue

```
<script setup lang="ts">

defineProps<{

  count: number

}>()

const emit = defineEmits<{ close: [boolean] }>()

</script>

<template>

  <USlideover

    :close="{ onClick: () => emit('close', false) }"

    :description="\`This slideover was opened programmatically ${count} times\`"

  >

    <template #body>

      <Placeholder class="h-full" />

    </template>

    <template #footer>

      <div class="flex gap-2">

        <UButton color="neutral" label="Dismiss" @click="emit('close', false)" />

        <UButton label="Success" @click="emit('close', true)" />

      </div>

    </template>

  </USlideover>

</template>
```

We are emitting a `close` event when the slideover is closed or dismissed here. You can emit any data through the `close` event, however, the event must be emitted in order to capture the return value.

Then, use it in your app:

```
<script setup lang="ts">

import { LazySlideoverExample } from '#components'

const count = ref(0)

const toast = useToast()

const overlay = useOverlay()

const slideover = overlay.create(LazySlideoverExample)

async function open() {

  const instance = slideover.open({

    count: count.value

  })

  const shouldIncrement = await instance.result

  if (shouldIncrement) {

    count.value++

    toast.add({

      title: \`Success: ${shouldIncrement}\`,

      color: 'success',

      id: 'slideover-success'

    })

    // Update the count

    slideover.patch({

      count: count.value

    })

    return

  }

  toast.add({

    title: \`Dismissed: ${shouldIncrement}\`,

    color: 'error',

    id: 'slideover-dismiss'

  })

}

</script>

<template>

  <UButton label="Open" color="neutral" variant="subtle" @click="open" />

</template>
```

You can close the slideover within the slideover component by emitting `emit('close')`.

### Nested slideovers

You can nest slideovers within each other.

Use the `#footer` slot to add content after the Slideover's body.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `title` |  | ` string` |
| `description` |  | ` string` |
| `content` |  | ` DialogContentProps & Partial<EmitsToProps<DialogContentImplEmits>>`  The content of the slideover. |
| `overlay` | `true` | `boolean`  Render an overlay behind the slideover. |
| `transition` | `true` | `boolean`  Animate the slideover when opening or closing. |
| `side` | `'right'` | ` "right" \| "top" \| "bottom" \| "left"`  The side of the slideover. |
| `inset` | `false` | `boolean`  Whether to inset the slideover from the edges. |
| `portal` | `true` | ` string \| false \| true \| HTMLElement`  Render the slideover in a portal. |
| `close` | `true` | `boolean \| Omit<ButtonProps, LinkPropsKeys>`  Display a close button to dismiss the slideover.`{ size: 'md', color: 'neutral', variant: 'ghost' }` |
| `closeIcon` | `appConfig.ui.icons.close` | `any`  The icon displayed in the close button. |
| `dismissible` | `true` | `boolean`  When `false`, the slideover will not close when clicking outside or pressing escape. |
| `open` |  | `boolean`  The controlled open state of the dialog. Can be binded as `v-model:open`. |
| `defaultOpen` |  | `boolean`  The open state of the dialog when it is initially rendered. Use when you do not need to control its open state. |
| `modal` | `true` | `boolean`  The modality of the dialog When set to `true`,   interaction with outside elements will be disabled and only dialog content will be visible to screen readers. |
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

    slideover: {

      slots: {

        overlay: 'fixed inset-0 bg-elevated/75',

        content: 'fixed bg-default divide-y divide-default sm:ring ring-default sm:shadow-lg flex flex-col focus:outline-none',

        header: 'flex items-center gap-1.5 p-4 sm:px-6 min-h-16',

        wrapper: '',

        body: 'flex-1 overflow-y-auto p-4 sm:p-6',

        footer: 'flex items-center gap-1.5 p-4 sm:px-6',

        title: 'text-highlighted font-semibold',

        description: 'mt-1 text-muted text-sm',

        close: 'absolute top-4 end-4'

      },

      variants: {

        side: {

          top: {

            content: ''

          },

          right: {

            content: 'max-w-md'

          },

          bottom: {

            content: ''

          },

          left: {

            content: 'max-w-md'

          }

        },

        inset: {

          true: {

            content: 'rounded-lg'

          }

        },

        transition: {

          true: {

            overlay: 'data-[state=open]:animate-[fade-in_200ms_ease-out] data-[state=closed]:animate-[fade-out_200ms_ease-in]'

          }

        }

      },

      compoundVariants: [

        {

          side: 'top',

          inset: true,

          class: {

            content: 'max-h-[calc(100%-2rem)] inset-x-4 top-4'

          }

        },

        {

          side: 'top',

          inset: false,

          class: {

            content: 'max-h-full inset-x-0 top-0'

          }

        },

        {

          side: 'right',

          inset: true,

          class: {

            content: 'w-[calc(100%-2rem)] inset-y-4 right-4'

          }

        },

        {

          side: 'right',

          inset: false,

          class: {

            content: 'w-full inset-y-0 right-0'

          }

        },

        {

          side: 'bottom',

          inset: true,

          class: {

            content: 'max-h-[calc(100%-2rem)] inset-x-4 bottom-4'

          }

        },

        {

          side: 'bottom',

          inset: false,

          class: {

            content: 'max-h-full inset-x-0 bottom-0'

          }

        },

        {

          side: 'left',

          inset: true,

          class: {

            content: 'w-[calc(100%-2rem)] inset-y-4 left-4'

          }

        },

        {

          side: 'left',

          inset: false,

          class: {

            content: 'w-full inset-y-0 left-0'

          }

        },

        {

          transition: true,

          side: 'top',

          class: {

            content: 'data-[state=open]:animate-[slide-in-from-top_200ms_ease-in-out] data-[state=closed]:animate-[slide-out-to-top_200ms_ease-in-out]'

          }

        },

        {

          transition: true,

          side: 'right',

          class: {

            content: 'data-[state=open]:animate-[slide-in-from-right_200ms_ease-in-out] data-[state=closed]:animate-[slide-out-to-right_200ms_ease-in-out]'

          }

        },

        {

          transition: true,

          side: 'bottom',

          class: {

            content: 'data-[state=open]:animate-[slide-in-from-bottom_200ms_ease-in-out] data-[state=closed]:animate-[slide-out-to-bottom_200ms_ease-in-out]'

          }

        },

        {

          transition: true,

          side: 'left',

          class: {

            content: 'data-[state=open]:animate-[slide-in-from-left_200ms_ease-in-out] data-[state=closed]:animate-[slide-out-to-left_200ms_ease-in-out]'

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

        slideover: {

          slots: {

            overlay: 'fixed inset-0 bg-elevated/75',

            content: 'fixed bg-default divide-y divide-default sm:ring ring-default sm:shadow-lg flex flex-col focus:outline-none',

            header: 'flex items-center gap-1.5 p-4 sm:px-6 min-h-16',

            wrapper: '',

            body: 'flex-1 overflow-y-auto p-4 sm:p-6',

            footer: 'flex items-center gap-1.5 p-4 sm:px-6',

            title: 'text-highlighted font-semibold',

            description: 'mt-1 text-muted text-sm',

            close: 'absolute top-4 end-4'

          },

          variants: {

            side: {

              top: {

                content: ''

              },

              right: {

                content: 'max-w-md'

              },

              bottom: {

                content: ''

              },

              left: {

                content: 'max-w-md'

              }

            },

            inset: {

              true: {

                content: 'rounded-lg'

              }

            },

            transition: {

              true: {

                overlay: 'data-[state=open]:animate-[fade-in_200ms_ease-out] data-[state=closed]:animate-[fade-out_200ms_ease-in]'

              }

            }

          },

          compoundVariants: [

            {

              side: 'top',

              inset: true,

              class: {

                content: 'max-h-[calc(100%-2rem)] inset-x-4 top-4'

              }

            },

            {

              side: 'top',

              inset: false,

              class: {

                content: 'max-h-full inset-x-0 top-0'

              }

            },

            {

              side: 'right',

              inset: true,

              class: {

                content: 'w-[calc(100%-2rem)] inset-y-4 right-4'

              }

            },

            {

              side: 'right',

              inset: false,

              class: {

                content: 'w-full inset-y-0 right-0'

              }

            },

            {

              side: 'bottom',

              inset: true,

              class: {

                content: 'max-h-[calc(100%-2rem)] inset-x-4 bottom-4'

              }

            },

            {

              side: 'bottom',

              inset: false,

              class: {

                content: 'max-h-full inset-x-0 bottom-0'

              }

            },

            {

              side: 'left',

              inset: true,

              class: {

                content: 'w-[calc(100%-2rem)] inset-y-4 left-4'

              }

            },

            {

              side: 'left',

              inset: false,

              class: {

                content: 'w-full inset-y-0 left-0'

              }

            },

            {

              transition: true,

              side: 'top',

              class: {

                content: 'data-[state=open]:animate-[slide-in-from-top_200ms_ease-in-out] data-[state=closed]:animate-[slide-out-to-top_200ms_ease-in-out]'

              }

            },

            {

              transition: true,

              side: 'right',

              class: {

                content: 'data-[state=open]:animate-[slide-in-from-right_200ms_ease-in-out] data-[state=closed]:animate-[slide-out-to-right_200ms_ease-in-out]'

              }

            },

            {

              transition: true,

              side: 'bottom',

              class: {

                content: 'data-[state=open]:animate-[slide-in-from-bottom_200ms_ease-in-out] data-[state=closed]:animate-[slide-out-to-bottom_200ms_ease-in-out]'

              }

            },

            {

              transition: true,

              side: 'left',

              class: {

                content: 'data-[state=open]:animate-[slide-in-from-left_200ms_ease-in-out] data-[state=closed]:animate-[slide-out-to-left_200ms_ease-in-out]'

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

[`05bd9`](https://github.com/nuxt/ui/commit/05bd995f63c80486cb7b04792cd1fab9910da5e7) — feat: add `inset` prop

[`184ea`](https://github.com/nuxt/ui/commit/184eaab1cd5f4f4943b509ea1a3efb1b6f6d7f91) — chore: reduce type verbosity by omitting link props from action buttons

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`80994`](https://github.com/nuxt/ui/commit/80994401c6ca8ce29226104bef83c98f09585854) — fix: remove close autofocus prevent ([#5191](https://github.com/nuxt/ui/issues/5191))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`81569`](https://github.com/nuxt/ui/commit/81569713e9da9d5531ecdf4614660b84c686fa81) — feat: add `actions` slot ([#4358](https://github.com/nuxt/ui/issues/4358))

[`be41a`](https://github.com/nuxt/ui/commit/be41aed1f3d3476801e1840dbb8766926bc93c05) — fix: remove default `md` size on buttons ([#4357](https://github.com/nuxt/ui/issues/4357))

[`150b3`](https://github.com/nuxt/ui/commit/150b334b1d242c6dc132193e23359c03e6f35666) — fix: don't emit `close:prevent` on `closeAutoFocus`

[`5835e`](https://github.com/nuxt/ui/commit/5835eb5f0f835b5f03646dec78f85b2f556a109b) — feat: add `close` method in slots ([#4219](https://github.com/nuxt/ui/issues/4219))

[`d9e9f`](https://github.com/nuxt/ui/commit/d9e9fea35e4b22d68324c9e85b3aa221a7987d0f) — feat: add `after:enter` event ([#4187](https://github.com/nuxt/ui/issues/4187))

[`f4864`](https://github.com/nuxt/ui/commit/f4864233812eac0ed37e0a2d076a95c285a22c01) — feat: add `close:prevent` event ([#3958](https://github.com/nuxt/ui/issues/3958))

[`29fa4`](https://github.com/nuxt/ui/commit/29fa46276d6bf69b5b87880c476c6f778c2820bf) — feat: add global `portal` prop ([#3688](https://github.com/nuxt/ui/issues/3688))

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`b9983`](https://github.com/nuxt/ui/commit/b9983549a4b743724ea3ef99cc4a243f5ca41e53) — fix: improve generic types ([#3331](https://github.com/nuxt/ui/issues/3331))

[`5dec0`](https://github.com/nuxt/ui/commit/5dec0e16e28549b8833aaab17a87fada63d6598c) — feat: handle events in `content` prop

[`f4c41`](https://github.com/nuxt/ui/commit/f4c417d9ef5409b52084bdf9d8cbccee3139709f) — fix: prevent unnecessary close instantiation[Popover](https://ui.nuxt.com/docs/components/popover)

[

A non-modal dialog that floats around a trigger element.

](https://ui.nuxt.com/docs/components/popover)[

Toast

A succinct message to provide information or feedback to the user.

](https://ui.nuxt.com/docs/components/toast)