---
title: "Vue Toast Component"
source: "https://ui.nuxt.com/docs/components/toast"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A succinct message to provide information or feedback to the user."
tags:
---
## Toast

[Toast](https://reka-ui.com/docs/components/toast) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Toast.vue)

A succinct message to provide information or feedback to the user.

## Usage

Use the [useToast](https://ui.nuxt.com/docs/composables/use-toast) composable to display a toast in your application.

```
<script setup lang="ts">

const toast = useToast()

function addToCalendar() {

  const eventDate = new Date(Date.now() + Math.random() * 31536000000)

  const formattedDate = eventDate.toLocaleDateString('en-US', {

    month: 'short',

    day: 'numeric',

    year: 'numeric'

  })

  toast.add({

    title: 'Event added to calendar',

    description: \`This event is scheduled for ${formattedDate}.\`,

    icon: 'i-lucide-calendar-days'

  })

}

</script>

<template>

  <UButton

    label="Add to calendar"

    color="neutral"

    variant="outline"

    icon="i-lucide-plus"

    @click="addToCalendar"

  />

</template>
```

Make sure to wrap your app with the [`App`](https://ui.nuxt.com/docs/components/app) component which uses our [`Toaster`](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Toaster.vue) component which uses the [`ToastProvider`](https://reka-ui.com/docs/components/toast#provider) component from Reka UI.

You can check the `App` component `toaster` prop to see how to configure the Toaster globally.

Pass a `title` field to the `toast.add` method to display a title.

```
<script setup lang="ts">

const props = defineProps<{

  title: string

}>()

const toast = useToast()

function showToast() {

  toast.add(props)

}

</script>

<template>

  <UButton label="Show toast" color="neutral" variant="outline" @click="showToast" />

</template>
```

### Description

Pass a `description` field to the `toast.add` method to display a description.

```
<script setup lang="ts">

const props = defineProps<{

  title: string

  description: string

}>()

const toast = useToast()

function showToast() {

  toast.add(props)

}

</script>

<template>

  <UButton label="Show toast" color="neutral" variant="outline" @click="showToast" />

</template>
```

### Icon

Pass an `icon` field to the `toast.add` method to display an [Icon](https://ui.nuxt.com/docs/components/icon).

```
<script setup lang="ts">

const props = defineProps<{

  icon: string

}>()

const toast = useToast()

function showToast() {

  toast.add({

    title: 'Uh oh! Something went wrong.',

    description: 'There was a problem with your request.',

    icon: props.icon

  })

}

</script>

<template>

  <UButton label="Show toast" color="neutral" variant="outline" @click="showToast" />

</template>
```

Pass an `avatar` field to the `toast.add` method to display an [Avatar](https://ui.nuxt.com/docs/components/avatar).

```
<script setup lang="ts">

import type { AvatarProps } from '@nuxt/ui'

const props = defineProps<{

  avatar: AvatarProps

}>()

const toast = useToast()

function showToast() {

  toast.add({

    title: 'User invited',

    description: 'benjamincanac was invited to the team.',

    avatar: props.avatar

  })

}

</script>

<template>

  <UButton label="Invite user" color="neutral" variant="outline" @click="showToast" />

</template>
```

### Color

Pass a `color` field to the `toast.add` method to change the color of the Toast.

```
<script setup lang="ts">

import type { ToastProps } from '@nuxt/ui'

const props = defineProps<{

  color: ToastProps['color']

}>()

const toast = useToast()

function showToast() {

  toast.add({

    title: 'Uh oh! Something went wrong.',

    description: 'There was a problem with your request.',

    icon: 'i-lucide-wifi',

    color: props.color

  })

}

</script>

<template>

  <UButton label="Show toast" color="neutral" variant="outline" @click="showToast" />

</template>
```

### Close

Pass a `close` field to customize or hide the close [Button](https://ui.nuxt.com/docs/components/button) (with `false` value).

```
<script setup lang="ts">

const toast = useToast()

function showToast() {

  toast.add({

    title: 'Uh oh! Something went wrong.',

    description: 'There was a problem with your request.',

    icon: 'i-lucide-wifi',

    close: {

      color: 'primary',

      variant: 'outline',

      class: 'rounded-full'

    }

  })

}

</script>

<template>

  <UButton label="Show toast" color="neutral" variant="outline" @click="showToast" />

</template>
```

### Close Icon

Pass a `closeIcon` field to customize the close button [Icon](https://ui.nuxt.com/docs/components/icon). Default to `i-lucide-x`.

```
<script setup lang="ts">

const props = defineProps<{

  closeIcon: string

}>()

const toast = useToast()

function showToast() {

  toast.add({

    title: 'Uh oh! Something went wrong.',

    description: 'There was a problem with your request.',

    closeIcon: props.closeIcon

  })

}

</script>

<template>

  <UButton label="Show toast" color="neutral" variant="outline" @click="showToast" />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.close` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.close` key.

### Actions

Pass an `actions` field to add some [Button](https://ui.nuxt.com/docs/components/button) actions to the Toast.

```
<script setup lang="ts">

const toast = useToast()

const props = defineProps<{

  description: string

}>()

function showToast() {

  toast.add({

    title: 'Uh oh! Something went wrong.',

    description: props.description,

    actions: [{

      icon: 'i-lucide-refresh-cw',

      label: 'Retry',

      color: 'neutral',

      variant: 'outline',

      onClick: (e) => {

        e?.stopPropagation()

      }

    }]

  })

}

</script>

<template>

  <UButton label="Show toast" color="neutral" variant="outline" @click="showToast" />

</template>
```

### Progress

Pass a `progress` field to customize or hide the [Progress](https://ui.nuxt.com/docs/components/progress) bar (with `false` value).

The Progress bar inherits the Toast color by default, but you can override it using the `progress.color` field.

```
<script setup lang="ts">

const toast = useToast()

function showToast() {

  toast.add({

    title: 'Uh oh! Something went wrong.',

    description: 'There was a problem with your request.',

    icon: 'i-lucide-wifi',

    progress: false

  })

}

</script>

<template>

  <UButton label="Show toast" color="neutral" variant="outline" @click="showToast" />

</template>
```

### Orientation

Pass an `orientation` field to the `toast.add` method to change the orientation of the Toast.

```
<script setup lang="ts">

const toast = useToast()

const props = defineProps<{

  orientation: 'horizontal' | 'vertical'

}>()

function showToast() {

  toast.add({

    title: 'Uh oh! Something went wrong.',

    orientation: props.orientation,

    actions: [{

      icon: 'i-lucide-refresh-cw',

      label: 'Retry',

      color: 'neutral',

      variant: 'outline',

      onClick: (e) => {

        e?.stopPropagation()

      }

    }]

  })

}

</script>

<template>

  <UButton label="Show toast" color="neutral" variant="outline" @click="showToast" />

</template>
```

## Examples

Nuxt UI provides an **App** component that wraps your app to provide global configurations.

### Change global position

Change the `toaster.position` prop on the [App](https://ui.nuxt.com/docs/components/app#props) component to change the position of the toasts.

app.vue

```
<script setup lang="ts">

const toaster = { position: 'bottom-right' }

</script>

<template>

  <UApp :toaster="toaster">

    <NuxtPage />

  </UApp>

</template>
```

```
<script setup lang="ts">

const toast = useToast()

function addToCalendar() {

  const eventDate = new Date(Date.now() + Math.random() * 31536000000)

  const formattedDate = eventDate.toLocaleDateString('en-US', {

    month: 'short',

    day: 'numeric',

    year: 'numeric'

  })

  toast.add({

    title: 'Event added to calendar',

    description: \`This event is scheduled for ${formattedDate}.\`,

    icon: 'i-lucide-calendar-days'

  })

}

</script>

<template>

  <UButton

    label="Add to calendar"

    color="neutral"

    variant="outline"

    icon="i-lucide-plus"

    @click="addToCalendar"

  />

</template>
```

In this example, we use the `AppConfig` to configure the `position` prop of the `Toaster` component globally.

### Change global duration

Change the `toaster.duration` prop on the [App](https://ui.nuxt.com/docs/components/app#props) component to change the duration of the toasts.

app.vue

```
<script setup lang="ts">

const toaster = { duration: 5000 }

</script>

<template>

  <UApp :toaster="toaster">

    <NuxtPage />

  </UApp>

</template>
```

```
<script setup lang="ts">

const toast = useToast()

function addToCalendar() {

  const eventDate = new Date(Date.now() + Math.random() * 31536000000)

  const formattedDate = eventDate.toLocaleDateString('en-US', {

    month: 'short',

    day: 'numeric',

    year: 'numeric'

  })

  toast.add({

    title: 'Event added to calendar',

    description: \`This event is scheduled for ${formattedDate}.\`,

    icon: 'i-lucide-calendar-days'

  })

}

</script>

<template>

  <UButton

    label="Add to calendar"

    color="neutral"

    variant="outline"

    icon="i-lucide-plus"

    @click="addToCalendar"

  />

</template>
```

In this example, we use the `AppConfig` to configure the `duration` prop of the `Toaster` component globally.

### Change global max 4.1+

Change the `toaster.max` prop on the [App](https://ui.nuxt.com/docs/components/app#props) component to change the max number of toasts displayed at once.

app.vue

```
<script setup lang="ts">

const toaster = { max: 3 }

</script>

<template>

  <UApp :toaster="toaster">

    <NuxtPage />

  </UApp>

</template>
```

```
<script setup lang="ts">

const toast = useToast()

function addToCalendar() {

  const eventDate = new Date(Date.now() + Math.random() * 31536000000)

  const formattedDate = eventDate.toLocaleDateString('en-US', {

    month: 'short',

    day: 'numeric',

    year: 'numeric'

  })

  toast.add({

    title: 'Event added to calendar',

    description: \`This event is scheduled for ${formattedDate}.\`,

    icon: 'i-lucide-calendar-days'

  })

}

</script>

<template>

  <UButton

    label="Add to calendar"

    color="neutral"

    variant="outline"

    icon="i-lucide-plus"

    @click="addToCalendar"

  />

</template>
```

In this example, we use the `AppConfig` to configure the `max` prop of the `Toaster` component globally.

### Stacked toasts

Set the `toaster.expand` prop to `false` on the [App](https://ui.nuxt.com/docs/components/app#props) component to display stacked toasts (inspired by [Sonner](https://sonner.emilkowal.ski/)).

app.vue

```
<script setup lang="ts">

const toaster = { expand: true }

</script>

<template>

  <UApp :toaster="toaster">

    <NuxtPage />

  </UApp>

</template>
```

You can hover over the toasts to expand them. This will also pause the timer of the toasts.

```
<script setup lang="ts">

const toast = useToast()

function addToCalendar() {

  const eventDate = new Date(Date.now() + Math.random() * 31536000000)

  const formattedDate = eventDate.toLocaleDateString('en-US', {

    month: 'short',

    day: 'numeric',

    year: 'numeric'

  })

  toast.add({

    title: 'Event added to calendar',

    description: \`This event is scheduled for ${formattedDate}.\`,

    icon: 'i-lucide-calendar-days'

  })

}

</script>

<template>

  <UButton

    label="Add to calendar"

    color="neutral"

    variant="outline"

    icon="i-lucide-plus"

    @click="addToCalendar"

  />

</template>
```

In this example, we use the `AppConfig` to configure the `expand` prop of the `Toaster` component globally.

### With callback

Pass an `onUpdateOpen` field to execute a callback when the toast is closed (either by expiration or user dismissal).

```
<script setup lang="ts">

const toast = useToast()

function showToast() {

  toast.add({

    'title': 'Uploading file...',

    'description': 'Your file is being uploaded.',

    'icon': 'i-lucide-cloud-upload',

    'duration': 3000,

    'onUpdate:open': (open) => {

      if (!open) {

        toast.add({

          title: 'File uploaded!',

          description: 'Your file has been successfully uploaded.',

          icon: 'i-lucide-check',

          color: 'success'

        })

      }

    }

  })

}

</script>

<template>

  <UButton label="Show toast" color="neutral" variant="outline" @click="showToast" />

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'li'` | `any`  The element or component this component should render as. |
| `title` |  | ` string \| VNode<RendererNode, RendererElement, { [key: string]: any; }> \| (): VNode<RendererNode, RendererElement, { [key: string]: any; }>` |
| `description` |  | ` string \| VNode<RendererNode, RendererElement, { [key: string]: any; }> \| (): VNode<RendererNode, RendererElement, { [key: string]: any; }>` |
| `icon` |  | `any` |
| `avatar` |  | ` AvatarProps` |
| `color` | `'primary'` | ` "error" \| "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "neutral"` |
| `orientation` | `'vertical'` | ` "vertical" \| "horizontal"`  The orientation between the content and the actions. |
| `close` | `true` | `boolean \| Omit<ButtonProps, LinkPropsKeys>`  Display a close button to dismiss the toast.`{ size: 'md', color: 'neutral', variant: 'link' }` |
| `closeIcon` | `appConfig.ui.icons.close` | `any`  The icon displayed in the close button. |
| `actions` |  | ` ButtonProps[]`  Display a list of actions:  - under the title and description when orientation is `vertical` - next to the close button when orientation is `horizontal` `{ size: 'xs' }` |
| `progress` | `true` | `boolean \| Pick<ProgressProps, "color" \| "ui">`  Display a progress bar showing the toast's remaining duration.`{ size: 'sm' }` |
| `defaultOpen` |  | `boolean`  The open state of the dialog when it is initially rendered. Use when you do not need to control its open state. |
| `open` |  | `boolean`  The controlled open state of the dialog. Can be bind as `v-model:open`. |
| `type` |  | ` "foreground" \| "background"`  Control the sensitivity of the toast for accessibility purposes.  For toasts that are the result of a user action, choose `foreground`. Toasts generated from background tasks should use `background`. |
| `duration` |  | ` number`  Time in milliseconds that toast should remain visible for. Overrides value given to `ToastProvider`. |
| `ui` |  | ` { root?: ClassNameValue; wrapper?: ClassNameValue; title?: ClassNameValue; description?: ClassNameValue; icon?: ClassNameValue; avatar?: ClassNameValue; avatarSize?: ClassNameValue; actions?: ClassNameValue; progress?: ClassNameValue; close?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `leading` | `{ ui: object; }` |
| `title` | `{}` |
| `description` | `{}` |
| `actions` | `{}` |
| `close` | `{ ui: object; }` |

### Emits

| Event | Type |
| --- | --- |
| `pause` | `[]` |
| `escapeKeyDown` | `[event: KeyboardEvent]` |
| `resume` | `[]` |
| `swipeStart` | `[event: SwipeEvent]` |
| `swipeMove` | `[event: SwipeEvent]` |
| `swipeCancel` | `[event: SwipeEvent]` |
| `swipeEnd` | `[event: SwipeEvent]` |
| `update:open` | `[value: boolean]` |

### Expose

When accessing the component via a template ref, you can use the following:

| Name | Type |
| --- | --- |
| `height` | `Ref<number>` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    toast: {

      slots: {

        root: 'relative group overflow-hidden bg-default shadow-lg rounded-lg ring ring-default p-4 flex gap-2.5 focus:outline-none',

        wrapper: 'w-0 flex-1 flex flex-col',

        title: 'text-sm font-medium text-highlighted',

        description: 'text-sm text-muted',

        icon: 'shrink-0 size-5',

        avatar: 'shrink-0',

        avatarSize: '2xl',

        actions: 'flex gap-1.5 shrink-0',

        progress: 'absolute inset-x-0 bottom-0',

        close: 'p-0'

      },

      variants: {

        color: {

          primary: {

            root: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-primary',

            icon: 'text-primary'

          },

          secondary: {

            root: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-secondary',

            icon: 'text-secondary'

          },

          success: {

            root: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-success',

            icon: 'text-success'

          },

          info: {

            root: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-info',

            icon: 'text-info'

          },

          warning: {

            root: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-warning',

            icon: 'text-warning'

          },

          error: {

            root: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-error',

            icon: 'text-error'

          },

          neutral: {

            root: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-inverted',

            icon: 'text-highlighted'

          }

        },

        orientation: {

          horizontal: {

            root: 'items-center',

            actions: 'items-center'

          },

          vertical: {

            root: 'items-start',

            actions: 'items-start mt-2.5'

          }

        },

        title: {

          true: {

            description: 'mt-1'

          }

        }

      },

      defaultVariants: {

        color: 'primary'

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

        toast: {

          slots: {

            root: 'relative group overflow-hidden bg-default shadow-lg rounded-lg ring ring-default p-4 flex gap-2.5 focus:outline-none',

            wrapper: 'w-0 flex-1 flex flex-col',

            title: 'text-sm font-medium text-highlighted',

            description: 'text-sm text-muted',

            icon: 'shrink-0 size-5',

            avatar: 'shrink-0',

            avatarSize: '2xl',

            actions: 'flex gap-1.5 shrink-0',

            progress: 'absolute inset-x-0 bottom-0',

            close: 'p-0'

          },

          variants: {

            color: {

              primary: {

                root: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-primary',

                icon: 'text-primary'

              },

              secondary: {

                root: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-secondary',

                icon: 'text-secondary'

              },

              success: {

                root: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-success',

                icon: 'text-success'

              },

              info: {

                root: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-info',

                icon: 'text-info'

              },

              warning: {

                root: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-warning',

                icon: 'text-warning'

              },

              error: {

                root: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-error',

                icon: 'text-error'

              },

              neutral: {

                root: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-inverted',

                icon: 'text-highlighted'

              }

            },

            orientation: {

              horizontal: {

                root: 'items-center',

                actions: 'items-center'

              },

              vertical: {

                root: 'items-start',

                actions: 'items-start mt-2.5'

              }

            },

            title: {

              true: {

                description: 'mt-1'

              }

            }

          },

          defaultVariants: {

            color: 'primary'

          }

        }

      }

    })

  ]

})
```

## Changelog

[`184ea`](https://github.com/nuxt/ui/commit/184eaab1cd5f4f4943b509ea1a3efb1b6f6d7f91) — chore: reduce type verbosity by omitting link props from action buttons

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`fce2d`](https://github.com/nuxt/ui/commit/fce2df4e0660d0bdb3cdd4fb3041416824cbe893) — fix!: consistent exposed refs ([#5385](https://github.com/nuxt/ui/issues/5385))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`a8af8`](https://github.com/nuxt/ui/commit/a8af85c14bc24b0065b74c506873e4381495d8d9) — fix: add type for progress `ui` prop ([#4677](https://github.com/nuxt/ui/issues/4677))

[`ec569`](https://github.com/nuxt/ui/commit/ec569e427ba0a05ae29c4453fff3a60801966e37) — feat: progress bar with Progress component

[`1d052`](https://github.com/nuxt/ui/commit/1d052ec5654cc7c518e07060761a18db81420097) — fix: only show progress when open

[`be41a`](https://github.com/nuxt/ui/commit/be41aed1f3d3476801e1840dbb8766926bc93c05) — fix: remove default `md` size on buttons ([#4357](https://github.com/nuxt/ui/issues/4357))

[`3bf5a`](https://github.com/nuxt/ui/commit/3bf5acb683f0ad09735b2417d265d6fcfd901b11) — fix: calc height on next tick

[`92632`](https://github.com/nuxt/ui/commit/92632e969eaa11521a166e50e346753929b7f523) — feat: add `progress` prop to hide progress bar ([#4125](https://github.com/nuxt/ui/issues/4125))

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`50863`](https://github.com/nuxt/ui/commit/50863635d653c8083772046ddc5b828fba7047d0) — fix: display actions when using slots

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`b9983`](https://github.com/nuxt/ui/commit/b9983549a4b743724ea3ef99cc4a243f5ca41e53) — fix: improve generic types ([#3331](https://github.com/nuxt/ui/issues/3331))

[`f4c41`](https://github.com/nuxt/ui/commit/f4c417d9ef5409b52084bdf9d8cbccee3139709f) — fix: prevent unnecessary close instantiation[Slideover](https://ui.nuxt.com/docs/components/slideover)

[

A dialog that slides in from any side of the screen.

](https://ui.nuxt.com/docs/components/slideover)[

Tooltip

A popup that reveals information when hovering over an element.

](https://ui.nuxt.com/docs/components/tooltip)