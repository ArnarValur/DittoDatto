---
title: "Vue Empty Component"
source: "https://ui.nuxt.com/docs/components/empty"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A component to display an empty state."
tags:
---
## Empty

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Empty.vue)

A component to display an empty state.

## Usage

## No projects found

It looks like you haven't added any projects. Create one to get started.

Use the `title` prop to set the title of the empty state.

## No projects found

```
<template>

  <UEmpty title="No projects found" />

</template>
```

### Description

Use the `description` prop to set the description of the empty state.

## No projects found

It looks like you haven't added any projects. Create one to get started.

```
<template>

  <UEmpty

    title="No projects found"

    description="It looks like you haven't added any projects. Create one to get started."

  />

</template>
```

### Icon

Use the `icon` prop to set the icon of the empty state.

## No projects found

It looks like you haven't added any projects. Create one to get started.

```
<template>

  <UEmpty

    icon="i-lucide-file"

    title="No projects found"

    description="It looks like you haven't added any projects. Create one to get started."

  />

</template>
```

Use the `avatar` prop to set the avatar of the empty state.

## No projects found

It looks like you haven't added any projects. Create one to get started.

```
<template>

  <UEmpty

    :avatar="{

      src: 'https://github.com/nuxt.png'

    }"

    title="No projects found"

    description="It looks like you haven't added any projects. Create one to get started."

  />

</template>
```

### Actions

Use the `actions` prop to add some [Button](https://ui.nuxt.com/docs/components/button) actions to the empty state.

## No projects found

It looks like you haven't added any projects. Create one to get started.

```
<template>

  <UEmpty

    icon="i-lucide-file"

    title="No projects found"

    description="It looks like you haven't added any projects. Create one to get started."

    :actions="[

      {

        icon: 'i-lucide-plus',

        label: 'Create new'

      },

      {

        icon: 'i-lucide-refresh-cw',

        label: 'Refresh',

        color: 'neutral',

        variant: 'subtle'

      }

    ]"

  />

</template>
```

### Variant

Use the `variant` prop to change the variant of the empty state.

## No notifications

You're all caught up. New notifications will appear here.

```
<template>

  <UEmpty

    variant="naked"

    icon="i-lucide-bell"

    title="No notifications"

    description="You're all caught up. New notifications will appear here."

    :actions="[

      {

        icon: 'i-lucide-refresh-cw',

        label: 'Refresh',

        color: 'neutral',

        variant: 'subtle'

      }

    ]"

  />

</template>
```

### Size

Use the `size` prop to change the size of the empty state.

## No notifications

You're all caught up. New notifications will appear here.

```
<template>

  <UEmpty

    size="xl"

    icon="i-lucide-bell"

    title="No notifications"

    description="You're all caught up. New notifications will appear here."

    :actions="[

      {

        icon: 'i-lucide-refresh-cw',

        label: 'Refresh',

        color: 'neutral',

        variant: 'subtle'

      }

    ]"

  />

</template>
```

## Examples

### With slots

Use the available slots to create a more complex empty state.

## No team members

Invite your team to collaborate on this project.

```
<script setup lang="ts">

import type { UserProps } from '@nuxt/ui'

const members: UserProps[] = [

  {

    name: 'Daniel Roe',

    description: 'danielroe',

    to: 'https://github.com/danielroe',

    target: '_blank',

    avatar: {

      src: 'https://github.com/danielroe.png',

      alt: 'danielroe'

    }

  },

  {

    name: 'Pooya Parsa',

    description: 'pi0',

    to: 'https://github.com/pi0',

    target: '_blank',

    avatar: {

      src: 'https://github.com/pi0.png',

      alt: 'pi0'

    }

  },

  {

    name: 'Sébastien Chopin',

    description: 'atinux',

    to: 'https://github.com/atinux',

    target: '_blank',

    avatar: {

      src: 'https://github.com/atinux.png',

      alt: 'atinux'

    }

  },

  {

    name: 'Benjamin Canac',

    description: 'benjamincanac',

    to: 'https://github.com/benjamincanac',

    target: '_blank',

    avatar: {

      src: 'https://github.com/benjamincanac.png',

      alt: 'benjamincanac'

    }

  }

]

</script>

<template>

  <UEmpty

    title="No team members"

    description="Invite your team to collaborate on this project."

    variant="naked"

    :actions="[{

      label: 'Invite members',

      icon: 'i-lucide-user-plus',

      color: 'neutral'

    }]"

  >

    <template #leading>

      <UAvatarGroup size="xl">

        <UAvatar src="https://github.com/nuxt.png" alt="Nuxt" />

        <UAvatar src="https://github.com/unjs.png" alt="Unjs" />

      </UAvatarGroup>

    </template>

    <template #footer>

      <USeparator class="my-4" />

      <div class="grid grid-cols-2 gap-4">

        <UPageCard

          v-for="(member, index) in members"

          :key="index"

          :to="member.to"

          :ui="{ container: 'sm:p-4' }"

        >

          <UUser

            :avatar="member.avatar"

            :name="member.name"

            :description="member.description"

            :ui="{ name: 'truncate' }"

          />

        </UPageCard>

      </div>

    </template>

  </UEmpty>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `icon` |  | `any`  The icon displayed above the title. |
| `avatar` |  | ` AvatarProps` |
| `title` |  | ` string` |
| `description` |  | ` string` |
| `actions` |  | ` ButtonProps[]`  Display a list of Button in the body. |
| `variant` | `'outline'` | ` "outline" \| "solid" \| "soft" \| "subtle" \| "naked"` |
| `size` | `'md'` | ` "md" \| "xs" \| "sm" \| "lg" \| "xl"` |
| `ui` |  | ` { root?: ClassNameValue; header?: ClassNameValue; avatar?: ClassNameValue; title?: ClassNameValue; description?: ClassNameValue; body?: ClassNameValue; actions?: ClassNameValue; footer?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `header` | `{}` |
| `leading` | `{ ui: object; }` |
| `title` | `{}` |
| `description` | `{}` |
| `body` | `{}` |
| `actions` | `{}` |
| `footer` | `{}` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    empty: {

      slots: {

        root: 'relative flex flex-col items-center justify-center gap-4 rounded-lg p-4 sm:p-6 lg:p-8 min-w-0',

        header: 'flex flex-col items-center gap-2 max-w-sm text-center',

        avatar: 'shrink-0 mb-2',

        title: 'text-highlighted text-pretty font-medium',

        description: 'text-balance text-center',

        body: 'flex flex-col items-center gap-4 max-w-sm',

        actions: 'flex flex-wrap justify-center gap-2 shrink-0',

        footer: 'flex flex-col items-center gap-2 max-w-sm'

      },

      variants: {

        size: {

          xs: {

            avatar: 'size-8 text-base',

            title: 'text-sm',

            description: 'text-xs'

          },

          sm: {

            avatar: 'size-9 text-lg',

            title: 'text-sm',

            description: 'text-xs'

          },

          md: {

            avatar: 'size-10 text-xl',

            title: 'text-base',

            description: 'text-sm'

          },

          lg: {

            avatar: 'size-11 text-[22px]',

            title: 'text-base',

            description: 'text-sm'

          },

          xl: {

            avatar: 'size-12 text-2xl',

            title: 'text-lg',

            description: 'text-base'

          }

        },

        variant: {

          solid: {

            root: 'bg-inverted',

            title: 'text-inverted',

            description: 'text-dimmed'

          },

          outline: {

            root: 'bg-default ring ring-default',

            description: 'text-muted'

          },

          soft: {

            root: 'bg-elevated/50',

            description: 'text-toned'

          },

          subtle: {

            root: 'bg-elevated/50 ring ring-default',

            description: 'text-toned'

          },

          naked: {

            description: 'text-muted'

          }

        }

      },

      defaultVariants: {

        variant: 'outline',

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

        empty: {

          slots: {

            root: 'relative flex flex-col items-center justify-center gap-4 rounded-lg p-4 sm:p-6 lg:p-8 min-w-0',

            header: 'flex flex-col items-center gap-2 max-w-sm text-center',

            avatar: 'shrink-0 mb-2',

            title: 'text-highlighted text-pretty font-medium',

            description: 'text-balance text-center',

            body: 'flex flex-col items-center gap-4 max-w-sm',

            actions: 'flex flex-wrap justify-center gap-2 shrink-0',

            footer: 'flex flex-col items-center gap-2 max-w-sm'

          },

          variants: {

            size: {

              xs: {

                avatar: 'size-8 text-base',

                title: 'text-sm',

                description: 'text-xs'

              },

              sm: {

                avatar: 'size-9 text-lg',

                title: 'text-sm',

                description: 'text-xs'

              },

              md: {

                avatar: 'size-10 text-xl',

                title: 'text-base',

                description: 'text-sm'

              },

              lg: {

                avatar: 'size-11 text-[22px]',

                title: 'text-base',

                description: 'text-sm'

              },

              xl: {

                avatar: 'size-12 text-2xl',

                title: 'text-lg',

                description: 'text-base'

              }

            },

            variant: {

              solid: {

                root: 'bg-inverted',

                title: 'text-inverted',

                description: 'text-dimmed'

              },

              outline: {

                root: 'bg-default ring ring-default',

                description: 'text-muted'

              },

              soft: {

                root: 'bg-elevated/50',

                description: 'text-toned'

              },

              subtle: {

                root: 'bg-elevated/50 ring ring-default',

                description: 'text-toned'

              },

              naked: {

                description: 'text-muted'

              }

            }

          },

          defaultVariants: {

            variant: 'outline',

            size: 'md'

          }

        }

      }

    })

  ]

})
```

## Changelog

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`6a6de`](https://github.com/nuxt/ui/commit/6a6de8d763852f110ca1444d4d41e9002f0002ea) — feat: new component ([#5200](https://github.com/nuxt/ui/issues/5200))[Carousel](https://ui.nuxt.com/docs/components/carousel)

[

A carousel with motion and swipe built using Embla.

](https://ui.nuxt.com/docs/components/carousel)[

Marquee

A component to create infinite scrolling content.

](https://ui.nuxt.com/docs/components/marquee)