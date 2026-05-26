---
title: "Vue Drawer Component"
source: "https://ui.nuxt.com/docs/components/drawer"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A drawer that smoothly slides in & out of the screen."
tags:
---
## Drawer

[Drawer](https://github.com/unovue/vaul-vue) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Drawer.vue)

A drawer that smoothly slides in & out of the screen.

## Usage

Use a [Button](https://ui.nuxt.com/docs/components/button) or any other component in the default slot of the Drawer.

Then, use the `#content` slot to add the content displayed when the Drawer is open.

```
<template>

  <UDrawer>

    <UButton label="Open" color="neutral" variant="subtle" trailing-icon="i-lucide-chevron-up" />

    <template #content>

      <Placeholder class="h-48 m-4" />

    </template>

  </UDrawer>

</template>
```

You can also use the `#header`, `#body` and `#footer` slots to customize the Drawer's content.

Use the `title` prop to set the title of the Drawer's header.

```
<template>

  <UDrawer title="Drawer with title">

    <UButton label="Open" color="neutral" variant="subtle" trailing-icon="i-lucide-chevron-up" />

    <template #body>

      <Placeholder class="h-48" />

    </template>

  </UDrawer>

</template>
```

### Description

Use the `description` prop to set the description of the Drawer's header.

```
<template>

  <UDrawer

    title="Drawer with description"

    description="Lorem ipsum dolor sit amet, consectetur adipiscing elit."

  >

    <UButton label="Open" color="neutral" variant="subtle" trailing-icon="i-lucide-chevron-up" />

    <template #body>

      <Placeholder class="h-48" />

    </template>

  </UDrawer>

</template>
```

### Direction

Use the `direction` prop to control the direction of the Drawer. Defaults to `bottom`.

```
<template>

  <UDrawer direction="right">

    <UButton label="Open" color="neutral" variant="subtle" trailing-icon="i-lucide-chevron-up" />

    <template #content>

      <Placeholder class="min-w-96 min-h-96 size-full m-4" />

    </template>

  </UDrawer>

</template>
```

### Inset

Use the `inset` prop to inset the Drawer from the edges.

```
<template>

  <UDrawer direction="right" inset>

    <UButton label="Open" color="neutral" variant="subtle" trailing-icon="i-lucide-chevron-up" />

    <template #content>

      <Placeholder class="min-w-96 min-h-96 size-full m-4" />

    </template>

  </UDrawer>

</template>
```

### Handle

Use the `handle` prop to control whether the Drawer has a handle or not. Defaults to `true`.

```
<template>

  <UDrawer :handle="false">

    <UButton label="Open" color="neutral" variant="subtle" trailing-icon="i-lucide-chevron-up" />

    <template #content>

      <Placeholder class="h-48 m-4" />

    </template>

  </UDrawer>

</template>
```

### Handle Only

Use the `handle-only` prop to only allow the Drawer to be dragged by the handle.

```
<template>

  <UDrawer handle-only>

    <UButton label="Open" color="neutral" variant="subtle" trailing-icon="i-lucide-chevron-up" />

    <template #content>

      <Placeholder class="h-48 m-4" />

    </template>

  </UDrawer>

</template>
```

### Overlay

Use the `overlay` prop to control whether the Drawer has an overlay or not. Defaults to `true`.

```
<template>

  <UDrawer :overlay="false">

    <UButton label="Open" color="neutral" variant="subtle" trailing-icon="i-lucide-chevron-up" />

    <template #content>

      <Placeholder class="h-48 m-4" />

    </template>

  </UDrawer>

</template>
```

### Modal

Use the `modal` prop to control whether the Drawer blocks interaction with outside content. Defaults to `true`.

When `modal` is set to `false`, the overlay is automatically disabled and outside content becomes interactive.

```
<template>

  <UDrawer :modal="false">

    <UButton label="Open" color="neutral" variant="subtle" trailing-icon="i-lucide-chevron-up" />

    <template #content>

      <Placeholder class="h-48 m-4" />

    </template>

  </UDrawer>

</template>
```

### Dismissible

Use the `dismissible` prop to control whether the Drawer is dismissible when clicking outside of it or pressing escape. Defaults to `true`.

A `close:prevent` event will be emitted when the user tries to close it.

You can combine `modal: false` with `dismissible: false` to make the Drawer's background interactive without closing it.

```
<script setup lang="ts">

const open = ref(false)

</script>

<template>

  <UDrawer v-model:open="open" :dismissible="false" :modal="false" :handle="false">

    <UButton label="Open" color="neutral" variant="subtle" trailing-icon="i-lucide-chevron-up" />

    <template #body>

      <div class="flex items-center justify-between gap-4 mb-4">

        <h2 class="text-highlighted font-semibold">Drawer non-dismissible</h2>

        <UButton color="neutral" variant="ghost" icon="i-lucide-x" @click="open = false" />

      </div>

      <Placeholder class="size-full min-h-48" />

    </template>

  </UDrawer>

</template>
```

### Scale Background

Use the `should-scale-background` prop to scale the background when the Drawer is open, creating a visual depth effect. You can set the `set-background-color-on-scale` prop to `false` to prevent changing the background color.

```
<template>

  <UDrawer should-scale-background set-background-color-on-scale>

    <UButton label="Open" color="neutral" variant="subtle" trailing-icon="i-lucide-chevron-up" />

    <template #content>

      <Placeholder class="h-48 m-4" />

    </template>

  </UDrawer>

</template>
```

Make sure to add the `data-vaul-drawer-wrapper` directive to a parent element of your app to make this work.

app.vue

```
<template>

  <UApp>

    <div class="bg-default" data-vaul-drawer-wrapper>

      <NuxtLayout>

        <NuxtPage />

      </NuxtLayout>

    </div>

  </UApp>

</template>
```

nuxt.config.ts

```ts
export default defineNuxtConfig({

  app: {

    rootAttrs: {

      'data-vaul-drawer-wrapper': '',

      'class': 'bg-default'

    }

  }

})
```

## Examples

### Control open state

You can control the open state by using the `default-open` prop or the `v-model:open` directive.

```
<script setup lang="ts">

const open = ref(false)

defineShortcuts({

  o: () => (open.value = !open.value)

})

</script>

<template>

  <UDrawer v-model:open="open">

    <UButton label="Open" color="neutral" variant="subtle" trailing-icon="i-lucide-chevron-up" />

    <template #content>

      <Placeholder class="h-48 m-4" />

    </template>

  </UDrawer>

</template>
```

In this example, leveraging [`defineShortcuts`](https://ui.nuxt.com/docs/composables/define-shortcuts), you can toggle the Drawer by pressing O.

This allows you to move the trigger outside of the Drawer or remove it entirely.

### Responsive drawer

You can render a [Modal](https://ui.nuxt.com/docs/components/modal) component on desktop and a Drawer on mobile for example.

```
<script lang="ts" setup>

import { createReusableTemplate, useMediaQuery } from '@vueuse/core'

const [DefineFormTemplate, ReuseFormTemplate] = createReusableTemplate()

const isDesktop = useMediaQuery('(min-width: 768px)')

const open = ref(false)

const state = reactive({

  email: undefined

})

const title = 'Edit profile'

const description = "Make changes to your profile here. Click save when you're done."

</script>

<template>

  <DefineFormTemplate>

    <UForm :state="state" class="space-y-4">

      <UFormField label="Email" name="email" required>

        <UInput v-model="state.email" placeholder="shadcn@example.com" required />

      </UFormField>

      <UButton label="Save changes" type="submit" />

    </UForm>

  </DefineFormTemplate>

  <UModal v-if="isDesktop" v-model:open="open" :title="title" :description="description">

    <UButton label="Edit profile" color="neutral" variant="outline" />

    <template #body>

      <ReuseFormTemplate />

    </template>

  </UModal>

  <UDrawer v-else v-model:open="open" :title="title" :description="description">

    <UButton label="Edit profile" color="neutral" variant="outline" />

    <template #body>

      <ReuseFormTemplate />

    </template>

  </UDrawer>

</template>
```

### Nested drawers

You can nest drawers within each other by using the `nested` prop.

Use the `#footer` slot to add content after the Drawer's body.

### With command palette

You can use a [CommandPalette](https://ui.nuxt.com/docs/components/command-palette) component inside the Drawer's content.

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

  <UDrawer :handle="false">

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

  </UDrawer>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `title` |  | ` string` |
| `description` |  | ` string` |
| `inset` | `false` | `boolean`  Whether to inset the drawer from the edges. |
| `content` |  | ` DialogContentProps & Partial<EmitsToProps<DialogContentImplEmits>>`  The content of the drawer. |
| `overlay` | `true` | `boolean`  Render an overlay behind the drawer. |
| `handle` | `true` | `boolean`  Render a handle on the drawer. |
| `portal` | `true` | ` string \| false \| true \| HTMLElement`  Render the drawer in a portal. |
| `nested` | `false` | `boolean`  Whether the drawer is nested in another drawer. |
| `modal` | `true` | `boolean`  When `false` it allows to interact with elements outside of the drawer without closing it. |
| `open` |  | `boolean ` |
| `activeSnapPoint` |  | ` null \| string \| number` |
| `closeThreshold` |  | ` number`  Number between 0 and 1 that determines when the drawer should be closed. Example: threshold of 0.5 would close the drawer if the user swiped for 50% of the height of the drawer or more. |
| `shouldScaleBackground` |  | `boolean ` |
| `setBackgroundColorOnScale` |  | `boolean `  When `false` we don't change body's background color when the drawer is open. |
| `scrollLockTimeout` |  | ` number`  Duration for which the drawer is not draggable after scrolling content inside of the drawer. |
| `fixed` |  | `boolean `  When `true`, don't move the drawer upwards if there's space, but rather only change it's height so it's fully scrollable when the keyboard is open |
| `dismissible` | `true` | `boolean `  When `false` dragging, clicking outside, pressing esc, etc. will not close the drawer. Use this in combination with the `open` prop, otherwise you won't be able to open/close the drawer. |
| `defaultOpen` |  | `boolean `  Opened by default, skips initial enter animation. Still reacts to `open` state changes |
| `direction` | `'bottom'` | ` "left" \| "right" \| "bottom" \| "top"`  Direction of the drawer. Can be `top` or `bottom`, `left`, `right`. |
| `noBodyStyles` |  | `boolean `  When `true` the `body` doesn't get any styles assigned from Vaul |
| `handleOnly` |  | `boolean `  When `true` only allows the drawer to be dragged by the `<Drawer.Handle />` component. |
| `preventScrollRestoration` |  | `boolean ` |
| `snapPoints` |  | ` (string \| number)[]`  Array of numbers from 0 to 100 that corresponds to % of the screen a given snap point should take up. Should go from least visible. Example `[0.2, 0.5, 0.8]`. You can also use px values, which doesn't take screen height into account. |
| `ui` |  | ` { overlay?: ClassNameValue; content?: ClassNameValue; handle?: ClassNameValue; container?: ClassNameValue; header?: ClassNameValue; title?: ClassNameValue; description?: ClassNameValue; body?: ClassNameValue; footer?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{}` |
| `content` | `{}` |
| `header` | `{}` |
| `title` | `{}` |
| `description` | `{}` |
| `body` | `{} ` |
| `footer` | `{} ` |

### Emits

| Event | Type |
| --- | --- |
| `update:open` | `[open: boolean]` |
| `close` | `[]` |
| `drag` | `[percentageDragged: number]` |
| `close:prevent` | `[]` |
| `release` | `[open: boolean]` |
| `update:activeSnapPoint` | `[val: string \| number]` |
| `animationEnd` | `[open: boolean]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    drawer: {

      slots: {

        overlay: 'fixed inset-0 bg-elevated/75',

        content: 'fixed bg-default ring ring-default flex focus:outline-none',

        handle: [

          'shrink-0 !bg-accented',

          'transition-opacity'

        ],

        container: 'w-full flex flex-col gap-4 p-4 overflow-y-auto',

        header: '',

        title: 'text-highlighted font-semibold',

        description: 'mt-1 text-muted text-sm',

        body: 'flex-1',

        footer: 'flex flex-col gap-1.5'

      },

      variants: {

        direction: {

          top: {

            content: 'mb-24 flex-col-reverse',

            handle: 'mb-4'

          },

          right: {

            content: 'flex-row',

            handle: '!ml-4'

          },

          bottom: {

            content: 'mt-24 flex-col',

            handle: 'mt-4'

          },

          left: {

            content: 'flex-row-reverse',

            handle: '!mr-4'

          }

        },

        inset: {

          true: {

            content: 'rounded-lg after:hidden overflow-hidden [--initial-transform:calc(100%+1.5rem)]'

          }

        },

        snapPoints: {

          true: ''

        }

      },

      compoundVariants: [

        {

          direction: [

            'top',

            'bottom'

          ],

          class: {

            content: 'h-auto max-h-[96%]',

            handle: '!w-12 !h-1.5 mx-auto'

          }

        },

        {

          direction: [

            'top',

            'bottom'

          ],

          snapPoints: true,

          class: {

            content: 'h-full'

          }

        },

        {

          direction: [

            'right',

            'left'

          ],

          class: {

            content: 'w-auto max-w-[calc(100%-2rem)]',

            handle: '!h-12 !w-1.5 mt-auto mb-auto'

          }

        },

        {

          direction: [

            'right',

            'left'

          ],

          snapPoints: true,

          class: {

            content: 'w-full'

          }

        },

        {

          direction: 'top',

          inset: true,

          class: {

            content: 'inset-x-4 top-4'

          }

        },

        {

          direction: 'top',

          inset: false,

          class: {

            content: 'inset-x-0 top-0 rounded-b-lg'

          }

        },

        {

          direction: 'bottom',

          inset: true,

          class: {

            content: 'inset-x-4 bottom-4'

          }

        },

        {

          direction: 'bottom',

          inset: false,

          class: {

            content: 'inset-x-0 bottom-0 rounded-t-lg'

          }

        },

        {

          direction: 'left',

          inset: true,

          class: {

            content: 'inset-y-4 left-4'

          }

        },

        {

          direction: 'left',

          inset: false,

          class: {

            content: 'inset-y-0 left-0 rounded-r-lg'

          }

        },

        {

          direction: 'right',

          inset: true,

          class: {

            content: 'inset-y-4 right-4'

          }

        },

        {

          direction: 'right',

          inset: false,

          class: {

            content: 'inset-y-0 right-0 rounded-l-lg'

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

        drawer: {

          slots: {

            overlay: 'fixed inset-0 bg-elevated/75',

            content: 'fixed bg-default ring ring-default flex focus:outline-none',

            handle: [

              'shrink-0 !bg-accented',

              'transition-opacity'

            ],

            container: 'w-full flex flex-col gap-4 p-4 overflow-y-auto',

            header: '',

            title: 'text-highlighted font-semibold',

            description: 'mt-1 text-muted text-sm',

            body: 'flex-1',

            footer: 'flex flex-col gap-1.5'

          },

          variants: {

            direction: {

              top: {

                content: 'mb-24 flex-col-reverse',

                handle: 'mb-4'

              },

              right: {

                content: 'flex-row',

                handle: '!ml-4'

              },

              bottom: {

                content: 'mt-24 flex-col',

                handle: 'mt-4'

              },

              left: {

                content: 'flex-row-reverse',

                handle: '!mr-4'

              }

            },

            inset: {

              true: {

                content: 'rounded-lg after:hidden overflow-hidden [--initial-transform:calc(100%+1.5rem)]'

              }

            },

            snapPoints: {

              true: ''

            }

          },

          compoundVariants: [

            {

              direction: [

                'top',

                'bottom'

              ],

              class: {

                content: 'h-auto max-h-[96%]',

                handle: '!w-12 !h-1.5 mx-auto'

              }

            },

            {

              direction: [

                'top',

                'bottom'

              ],

              snapPoints: true,

              class: {

                content: 'h-full'

              }

            },

            {

              direction: [

                'right',

                'left'

              ],

              class: {

                content: 'w-auto max-w-[calc(100%-2rem)]',

                handle: '!h-12 !w-1.5 mt-auto mb-auto'

              }

            },

            {

              direction: [

                'right',

                'left'

              ],

              snapPoints: true,

              class: {

                content: 'w-full'

              }

            },

            {

              direction: 'top',

              inset: true,

              class: {

                content: 'inset-x-4 top-4'

              }

            },

            {

              direction: 'top',

              inset: false,

              class: {

                content: 'inset-x-0 top-0 rounded-b-lg'

              }

            },

            {

              direction: 'bottom',

              inset: true,

              class: {

                content: 'inset-x-4 bottom-4'

              }

            },

            {

              direction: 'bottom',

              inset: false,

              class: {

                content: 'inset-x-0 bottom-0 rounded-t-lg'

              }

            },

            {

              direction: 'left',

              inset: true,

              class: {

                content: 'inset-y-4 left-4'

              }

            },

            {

              direction: 'left',

              inset: false,

              class: {

                content: 'inset-y-0 left-0 rounded-r-lg'

              }

            },

            {

              direction: 'right',

              inset: true,

              class: {

                content: 'inset-y-4 right-4'

              }

            },

            {

              direction: 'right',

              inset: false,

              class: {

                content: 'inset-y-0 right-0 rounded-l-lg'

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

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`80994`](https://github.com/nuxt/ui/commit/80994401c6ca8ce29226104bef83c98f09585854) — fix: remove close autofocus prevent ([#5191](https://github.com/nuxt/ui/issues/5191))

[`b1457`](https://github.com/nuxt/ui/commit/b1457685b8a5a73e8390748524a2437df27b46b4) — fix: use full height/width for snapPoints ([#5041](https://github.com/nuxt/ui/issues/5041))

[`2abdc`](https://github.com/nuxt/ui/commit/2abdc217823b5371766d51a8ea5a570011b68051) — fix: prevent unwanted close when dismissible is false ([#5085](https://github.com/nuxt/ui/issues/5085))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`9da15`](https://github.com/nuxt/ui/commit/9da1527f628a206a9697b32b1ec9f82df5f7c9c7) — fix: improve closing animation with `inset` prop ([#4676](https://github.com/nuxt/ui/issues/4676))

[`e2695`](https://github.com/nuxt/ui/commit/e2695ee7e42777df5403755ded1053f76dae5aaf) — feat: add `nested` prop

[`c3adc`](https://github.com/nuxt/ui/commit/c3adc381c90dad7152e27fc303ee678efc7c4c94) — fix: prevent scrollbars overflow ([#4368](https://github.com/nuxt/ui/issues/4368))

[`41087`](https://github.com/nuxt/ui/commit/41087d4c9569eb00c04bd748e055cd151c2f762c) — fix: improve title & description accessibility

[`29fa4`](https://github.com/nuxt/ui/commit/29fa46276d6bf69b5b87880c476c6f778c2820bf) — feat: add global `portal` prop ([#3688](https://github.com/nuxt/ui/issues/3688))

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`f7604`](https://github.com/nuxt/ui/commit/f7604e565f717001a4d4c2974cf23559a3f01c21) — fix: remove `fadeFromIndex` prop proxy

[`31be5`](https://github.com/nuxt/ui/commit/31be5f656ec7bd1e217423266cfaefca5c5581dc) — chore: put back `shrink-0` on handle

[`f4017`](https://github.com/nuxt/ui/commit/f401766e26cc7b6568dc827debc2a9896176252e) — chore: update `vaul-vue`

[`5dec0`](https://github.com/nuxt/ui/commit/5dec0e16e28549b8833aaab17a87fada63d6598c) — feat: handle events in `content` prop