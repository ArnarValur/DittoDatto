---
title: "Vue Timeline Component"
source: "https://ui.nuxt.com/docs/components/timeline"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A component that displays a sequence of events with dates, titles, icons or avatars."
tags:
---
## Timeline

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Timeline.vue)

A component that displays a sequence of events with dates, titles, icons or avatars.

## Usage

Use the Timeline component to display a list of items in a timeline.

```
<script setup lang="ts">

import type { TimelineItem } from '@nuxt/ui'

const items = ref<TimelineItem[]>([

  {

    date: 'Mar 15, 2025',

    title: 'Project Kickoff',

    description: 'Kicked off the project with team alignment. Set up project milestones and allocated resources.',

    icon: 'i-lucide-rocket'

  },

  {

    date: 'Mar 22 2025',

    title: 'Design Phase',

    description: 'User research and design workshops. Created wireframes and prototypes for user testing.',

    icon: 'i-lucide-palette'

  },

  {

    date: 'Mar 29 2025',

    title: 'Development Sprint',

    description: 'Frontend and backend development. Implemented core features and integrated with APIs.',

    icon: 'i-lucide-code'

  },

  {

    date: 'Apr 5 2025',

    title: 'Testing & Deployment',

    description: 'QA testing and performance optimization. Deployed the application to production.',

    icon: 'i-lucide-check-circle'

  }

])

</script>

<template>

  <UTimeline :items="items" />

</template>
```

### Items

Use the `items` prop as an array of objects with the following properties:

- `date?: string`
- `title?: string`
- `description?: AvatarProps`
- `icon?: string`
- `avatar?: AvatarProps`
- `value?: string | number`
- [`slot?: string`](https://ui.nuxt.com/docs/components/#with-custom-slot)
- `class?: any`
- `ui?: { item?: ClassNameValue, container?: ClassNameValue, indicator?: ClassNameValue, separator?: ClassNameValue, wrapper?: ClassNameValue, date?: ClassNameValue, title?: ClassNameValue, description?: ClassNameValue }`

```
<script setup lang="ts">

import type { TimelineItem } from '@nuxt/ui'

const items = ref<TimelineItem[]>([

  {

    date: 'Mar 15, 2025',

    title: 'Project Kickoff',

    description: 'Kicked off the project with team alignment. Set up project milestones and allocated resources.',

    icon: 'i-lucide-rocket'

  },

  {

    date: 'Mar 22 2025',

    title: 'Design Phase',

    description: 'User research and design workshops. Created wireframes and prototypes for user testing.',

    icon: 'i-lucide-palette'

  },

  {

    date: 'Mar 29 2025',

    title: 'Development Sprint',

    description: 'Frontend and backend development. Implemented core features and integrated with APIs.',

    icon: 'i-lucide-code'

  },

  {

    date: 'Apr 5 2025',

    title: 'Testing & Deployment',

    description: 'QA testing and performance optimization. Deployed the application to production.',

    icon: 'i-lucide-check-circle'

  }

])

</script>

<template>

  <UTimeline :default-value="2" :items="items" class="w-96" />

</template>
```

### Color

Use the `color` prop to change the color of the active items in a Timeline.

```
<script setup lang="ts">

import type { TimelineItem } from '@nuxt/ui'

const items = ref<TimelineItem[]>([

  {

    date: 'Mar 15, 2025',

    title: 'Project Kickoff',

    description: 'Kicked off the project with team alignment. Set up project milestones and allocated resources.',

    icon: 'i-lucide-rocket'

  },

  {

    date: 'Mar 22 2025',

    title: 'Design Phase',

    description: 'User research and design workshops. Created wireframes and prototypes for user testing.',

    icon: 'i-lucide-palette'

  },

  {

    date: 'Mar 29 2025',

    title: 'Development Sprint',

    description: 'Frontend and backend development. Implemented core features and integrated with APIs.',

    icon: 'i-lucide-code'

  },

  {

    date: 'Apr 5 2025',

    title: 'Testing & Deployment',

    description: 'QA testing and performance optimization. Deployed the application to production.',

    icon: 'i-lucide-check-circle'

  }

])

</script>

<template>

  <UTimeline color="neutral" :default-value="2" :items="items" class="w-96" />

</template>
```

### Size

Use the `size` prop to change the size of the Timeline.

```
<script setup lang="ts">

import type { TimelineItem } from '@nuxt/ui'

const items = ref<TimelineItem[]>([

  {

    date: 'Mar 15, 2025',

    title: 'Project Kickoff',

    description: 'Kicked off the project with team alignment. Set up project milestones and allocated resources.',

    icon: 'i-lucide-rocket'

  },

  {

    date: 'Mar 22 2025',

    title: 'Design Phase',

    description: 'User research and design workshops. Created wireframes and prototypes for user testing.',

    icon: 'i-lucide-palette'

  },

  {

    date: 'Mar 29 2025',

    title: 'Development Sprint',

    description: 'Frontend and backend development. Implemented core features and integrated with APIs.',

    icon: 'i-lucide-code'

  },

  {

    date: 'Apr 5 2025',

    title: 'Testing & Deployment',

    description: 'QA testing and performance optimization. Deployed the application to production.',

    icon: 'i-lucide-check-circle'

  }

])

</script>

<template>

  <UTimeline size="xs" :default-value="2" :items="items" class="w-96" />

</template>
```

### Orientation

Use the `orientation` prop to change the orientation of the Timeline. Defaults to `vertical`.

Mar 15, 2025

Project Kickoff

Kicked off the project with team alignment.

Mar 22 2025

Design Phase

User research and design workshops.

Mar 29 2025

Development Sprint

Frontend and backend development.

Apr 5 2025

Testing & Deployment

QA testing and performance optimization.

```
<script setup lang="ts">

import type { TimelineItem } from '@nuxt/ui'

const items = ref<TimelineItem[]>([

  {

    date: 'Mar 15, 2025',

    title: 'Project Kickoff',

    description: 'Kicked off the project with team alignment.',

    icon: 'i-lucide-rocket'

  },

  {

    date: 'Mar 22 2025',

    title: 'Design Phase',

    description: 'User research and design workshops.',

    icon: 'i-lucide-palette'

  },

  {

    date: 'Mar 29 2025',

    title: 'Development Sprint',

    description: 'Frontend and backend development.',

    icon: 'i-lucide-code'

  },

  {

    date: 'Apr 5 2025',

    title: 'Testing & Deployment',

    description: 'QA testing and performance optimization.',

    icon: 'i-lucide-check-circle'

  }

])

</script>

<template>

  <UTimeline orientation="horizontal" :default-value="2" :items="items" class="w-full" />

</template>
```

### Reverse

Use the reverse prop to reverse the direction of the Timeline.

```
<script setup lang="ts">

import type { TimelineItem } from '@nuxt/ui'

const items = ref<TimelineItem[]>([

  {

    date: 'Mar 15, 2025',

    title: 'Project Kickoff',

    description: 'Kicked off the project with team alignment.',

    icon: 'i-lucide-rocket'

  },

  {

    date: 'Mar 22 2025',

    title: 'Design Phase',

    description: 'User research and design workshops.',

    icon: 'i-lucide-palette'

  },

  {

    date: 'Mar 29 2025',

    title: 'Development Sprint',

    description: 'Frontend and backend development.',

    icon: 'i-lucide-code'

  },

  {

    date: 'Apr 5 2025',

    title: 'Testing & Deployment',

    description: 'QA testing and performance optimization.',

    icon: 'i-lucide-check-circle'

  }

])

</script>

<template>

  <UTimeline reverse v-model="value" orientation="vertical" :items="items" class="w-full" />

</template>
```

## Examples

### Control active item

You can control the active item by using the `default-value` prop or the `v-model` directive with the `value` of the item. If no `value` is provided, it defaults to the index.

```
<script setup lang="ts">

import type { TimelineItem } from '@nuxt/ui'

const items: TimelineItem[] = [

  {

    date: 'Mar 15, 2025',

    title: 'Project Kickoff',

    description:

      'Kicked off the project with team alignment. Set up project milestones and allocated resources.',

    icon: 'i-lucide-rocket',

    value: 'kickoff'

  },

  {

    date: 'Mar 22, 2025',

    title: 'Design Phase',

    description:

      'User research and design workshops. Created wireframes and prototypes for user testing.',

    icon: 'i-lucide-palette',

    value: 'design'

  },

  {

    date: 'Mar 29, 2025',

    title: 'Development Sprint',

    description:

      'Frontend and backend development. Implemented core features and integrated with APIs.',

    icon: 'i-lucide-code',

    value: 'development'

  },

  {

    date: 'Apr 5, 2025',

    title: 'Testing & Deployment',

    description: 'QA testing and performance optimization. Deployed the application to production.',

    icon: 'i-lucide-check-circle',

    value: 'deployment'

  }

]

const active = ref(0)

// Note: This is for demonstration purposes only. Don't do this at home.

onMounted(() => {

  setInterval(() => {

    active.value = (active.value + 1) % items.length

  }, 2000)

})

</script>

<template>

  <UTimeline v-model="active" :items="items" class="w-96" />

</template>
```

Use the `value-key` prop to change the key used to match items when a `v-model` or `default-value` is provided.

### With select event

You can add a `@select` listener to make items clickable.

The handler function receives the `Event` and `TimelineItem` as the first and second arguments respectively.

```
<script setup lang="ts">

import type { TimelineItem } from '@nuxt/ui'

const items: TimelineItem[] = [

  {

    date: 'Mar 15, 2025',

    title: 'Project Kickoff',

    description:

      'Kicked off the project with team alignment. Set up project milestones and allocated resources.',

    icon: 'i-lucide-rocket',

    value: 'kickoff'

  },

  {

    date: 'Mar 22, 2025',

    title: 'Design Phase',

    description:

      'User research and design workshops. Created wireframes and prototypes for user testing.',

    icon: 'i-lucide-palette',

    value: 'design'

  },

  {

    date: 'Mar 29, 2025',

    title: 'Development Sprint',

    description:

      'Frontend and backend development. Implemented core features and integrated with APIs.',

    icon: 'i-lucide-code',

    value: 'development'

  },

  {

    date: 'Apr 5, 2025',

    title: 'Testing & Deployment',

    description: 'QA testing and performance optimization. Deployed the application to production.',

    icon: 'i-lucide-check-circle',

    value: 'deployment'

  }

]

const active = ref<string | number>('kickoff')

function onSelect(_e: Event, item: TimelineItem) {

  if (item.value) {

    active.value = item.value

  }

}

</script>

<template>

  <UTimeline v-model="active" :items="items" class="w-96" @select="onSelect" />

</template>
```

### With alternating layout

Use the `ui` prop to create a Timeline with alternating layout.

```
<script setup lang="ts">

import type { TimelineItem } from '@nuxt/ui'

const items: TimelineItem[] = [

  {

    date: 'Mar 15, 2025',

    title: 'Project Kickoff',

    icon: 'i-lucide-rocket',

    value: 'kickoff'

  },

  {

    date: 'Mar 22, 2025',

    title: 'Design Phase',

    icon: 'i-lucide-palette',

    value: 'design'

  },

  {

    date: 'Mar 29, 2025',

    title: 'Development Sprint',

    icon: 'i-lucide-code',

    value: 'development'

  },

  {

    date: 'Apr 5, 2025',

    title: 'Testing & Deployment',

    icon: 'i-lucide-check-circle',

    value: 'deployment'

  }

]

</script>

<template>

  <UTimeline

    :items="items"

    :default-value="2"

    :ui="{ item: 'even:flex-row-reverse even:-translate-x-[calc(100%-2rem)] even:text-right' }"

    class="translate-x-[calc(50%-1rem)]"

  />

</template>
```

### With custom slot

Use the `slot` property to customize a specific item.

You will have access to the following slots:

- `#{{ item.slot }}-indicator`
- `#{{ item.slot }}-date`
- `#{{ item.slot }}-title`
- `#{{ item.slot }}-description`

```
<script setup lang="ts">

import type { TimelineItem } from '@nuxt/ui'

const items = [

  {

    date: 'Mar 15, 2025',

    title: 'Project Kickoff',

    subtitle: 'Project Initiation',

    description:

      'Kicked off the project with team alignment. Set up project milestones and allocated resources.',

    icon: 'i-lucide-rocket',

    value: 'kickoff'

  },

  {

    date: 'Mar 22, 2025',

    title: 'Design Phase',

    description:

      'User research and design workshops. Created wireframes and prototypes for user testing.',

    icon: 'i-lucide-palette',

    value: 'design'

  },

  {

    date: 'Mar 29, 2025',

    title: 'Development Sprint',

    description:

      'Frontend and backend development. Implemented core features and integrated with APIs.',

    icon: 'i-lucide-code',

    value: 'development',

    slot: 'development' as const,

    developers: [

      {

        src: 'https://github.com/J-Michalek.png'

      },

      {

        src: 'https://github.com/benjamincanac.png'

      }

    ]

  },

  {

    date: 'Apr 5, 2025',

    title: 'Testing & Deployment',

    description: 'QA testing and performance optimization. Deployed the application to production.',

    icon: 'i-lucide-check-circle',

    value: 'deployment'

  }

] satisfies TimelineItem[]

</script>

<template>

  <UTimeline :items="items" :default-value="2" class="w-96">

    <template #development-title="{ item }">

      <div class="flex items-center gap-1">

        <span>{{ item.title }}</span>

        <UAvatarGroup size="2xs">

          <UAvatar v-for="(developer, index) of item.developers" :key="index" v-bind="developer" />

        </UAvatarGroup>

      </div>

    </template>

  </UTimeline>

</template>
```

### With slots

Use the available slots to create a more complex Timeline.

```
<script lang="ts" setup>

import type { TimelineItem } from '@nuxt/ui'

import { useTimeAgo } from '@vueuse/core'

const items = [

  {

    username: 'J-Michalek',

    date: '2025-05-24T14:58:55Z',

    action: 'opened this',

    avatar: {

      src: 'https://github.com/J-Michalek.png'

    }

  },

  {

    username: 'J-Michalek',

    date: '2025-05-26T19:30:14+02:00',

    action: 'marked this pull request as ready for review',

    icon: 'i-lucide-check-circle'

  },

  {

    username: 'benjamincanac',

    date: '2025-05-27T11:01:20Z',

    action: 'commented on this',

    description:

      "I've made a few changes, let me know what you think! Basically I updated the design, removed unnecessary divs, used Avatar component for the indicator since it supports icon already.",

    avatar: {

      src: 'https://github.com/benjamincanac.png'

    }

  },

  {

    username: 'J-Michalek',

    date: '2025-05-27T11:01:20Z',

    action: 'commented on this',

    description: 'Looks great! Good job on cleaning it up.',

    avatar: {

      src: 'https://github.com/J-Michalek.png'

    }

  },

  {

    username: 'benjamincanac',

    date: '2025-05-27T11:01:20Z',

    action: 'merged this',

    icon: 'i-lucide-git-merge'

  }

] satisfies TimelineItem[]

</script>

<template>

  <UTimeline

    :items="items"

    size="xs"

    :ui="{

      date: 'float-end ms-1',

      description: 'px-3 py-2 ring ring-default mt-2 rounded-md text-default'

    }"

    class="w-96"

  >

    <template #title="{ item }">

      <span>{{ item.username }}</span>

      <span class="font-normal text-muted">&nbsp;{{ item.action }}</span>

    </template>

    <template #date="{ item }">

      {{ useTimeAgo(new Date(item.date)) }}

    </template>

  </UTimeline>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `items` |  | `T[]` |
| `size` | `'md'` | ` "3xs" \| "2xs" \| "xs" \| "sm" \| "md" \| "lg" \| "xl" \| "2xl" \| "3xl"` |
| `color` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `orientation` | `'vertical'` | ` "horizontal" \| "vertical"`  The orientation of the Timeline. |
| `valueKey` | `'value'` | ` keyof Extract<NestedItem<T>, object> \| DotPathKeys<Extract<NestedItem<T>, object>>`  The key used to get the value from the item. |
| `defaultValue` |  | ` string \| number` |
| `reverse` |  | `boolean` |
| `modelValue` |  | ` string \| number` |
| `ui` |  | ` { root?: ClassNameValue; item?: ClassNameValue; container?: ClassNameValue; indicator?: ClassNameValue; separator?: ClassNameValue; wrapper?: ClassNameValue; date?: ClassNameValue; title?: ClassNameValue; description?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `indicator` | `{ item: T; }` |
| `wrapper` | `{ item: T; }` |
| `date` | `{ item: T; }` |
| `title` | `{ item: T; }` |
| `description` | `{ item: T; }` |

### Emits

| Event | Type |
| --- | --- |
| `select` | `[event: Event, item: T]` |
| `update:modelValue` | `[value: string \| number \| undefined]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    timeline: {

      slots: {

        root: 'flex gap-1.5',

        item: 'group relative flex flex-1 gap-3',

        container: 'relative flex items-center gap-1.5',

        indicator: 'group-data-[state=completed]:text-inverted group-data-[state=active]:text-inverted text-muted',

        separator: 'flex-1 rounded-full bg-elevated',

        wrapper: 'w-full',

        date: 'text-dimmed text-xs/5',

        title: 'font-medium text-highlighted text-sm',

        description: 'text-muted text-wrap text-sm'

      },

      variants: {

        orientation: {

          horizontal: {

            root: 'flex-row w-full',

            item: 'flex-col',

            separator: 'h-0.5'

          },

          vertical: {

            root: 'flex-col',

            container: 'flex-col',

            separator: 'w-0.5'

          }

        },

        color: {

          primary: {

            indicator: 'group-data-[state=completed]:bg-primary group-data-[state=active]:bg-primary'

          },

          secondary: {

            indicator: 'group-data-[state=completed]:bg-secondary group-data-[state=active]:bg-secondary'

          },

          success: {

            indicator: 'group-data-[state=completed]:bg-success group-data-[state=active]:bg-success'

          },

          info: {

            indicator: 'group-data-[state=completed]:bg-info group-data-[state=active]:bg-info'

          },

          warning: {

            indicator: 'group-data-[state=completed]:bg-warning group-data-[state=active]:bg-warning'

          },

          error: {

            indicator: 'group-data-[state=completed]:bg-error group-data-[state=active]:bg-error'

          },

          neutral: {

            indicator: 'group-data-[state=completed]:bg-inverted group-data-[state=active]:bg-inverted'

          }

        },

        size: {

          '3xs': '',

          '2xs': '',

          xs: '',

          sm: '',

          md: '',

          lg: '',

          xl: '',

          '2xl': '',

          '3xl': ''

        },

        reverse: {

          true: ''

        }

      },

      compoundVariants: [

        {

          color: 'primary',

          reverse: false,

          class: {

            separator: 'group-data-[state=completed]:bg-primary'

          }

        },

        {

          color: 'primary',

          reverse: true,

          class: {

            separator: 'group-data-[state=active]:bg-primary group-data-[state=completed]:bg-primary'

          }

        },

        {

          color: 'neutral',

          reverse: false,

          class: {

            separator: 'group-data-[state=completed]:bg-inverted'

          }

        },

        {

          color: 'neutral',

          reverse: true,

          class: {

            separator: 'group-data-[state=active]:bg-inverted group-data-[state=completed]:bg-inverted'

          }

        },

        {

          orientation: 'horizontal',

          size: '3xs',

          class: {

            wrapper: 'pe-4.5'

          }

        },

        {

          orientation: 'horizontal',

          size: '2xs',

          class: {

            wrapper: 'pe-5'

          }

        },

        {

          orientation: 'horizontal',

          size: 'xs',

          class: {

            wrapper: 'pe-5.5'

          }

        },

        {

          orientation: 'horizontal',

          size: 'sm',

          class: {

            wrapper: 'pe-6'

          }

        },

        {

          orientation: 'horizontal',

          size: 'md',

          class: {

            wrapper: 'pe-6.5'

          }

        },

        {

          orientation: 'horizontal',

          size: 'lg',

          class: {

            wrapper: 'pe-7'

          }

        },

        {

          orientation: 'horizontal',

          size: 'xl',

          class: {

            wrapper: 'pe-7.5'

          }

        },

        {

          orientation: 'horizontal',

          size: '2xl',

          class: {

            wrapper: 'pe-8'

          }

        },

        {

          orientation: 'horizontal',

          size: '3xl',

          class: {

            wrapper: 'pe-8.5'

          }

        },

        {

          orientation: 'vertical',

          size: '3xs',

          class: {

            wrapper: '-mt-0.5 pb-4.5'

          }

        },

        {

          orientation: 'vertical',

          size: '2xs',

          class: {

            wrapper: 'pb-5'

          }

        },

        {

          orientation: 'vertical',

          size: 'xs',

          class: {

            wrapper: 'mt-0.5 pb-5.5'

          }

        },

        {

          orientation: 'vertical',

          size: 'sm',

          class: {

            wrapper: 'mt-1 pb-6'

          }

        },

        {

          orientation: 'vertical',

          size: 'md',

          class: {

            wrapper: 'mt-1.5 pb-6.5'

          }

        },

        {

          orientation: 'vertical',

          size: 'lg',

          class: {

            wrapper: 'mt-2 pb-7'

          }

        },

        {

          orientation: 'vertical',

          size: 'xl',

          class: {

            wrapper: 'mt-2.5 pb-7.5'

          }

        },

        {

          orientation: 'vertical',

          size: '2xl',

          class: {

            wrapper: 'mt-3 pb-8'

          }

        },

        {

          orientation: 'vertical',

          size: '3xl',

          class: {

            wrapper: 'mt-3.5 pb-8.5'

          }

        }

      ],

      defaultVariants: {

        size: 'md',

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

        timeline: {

          slots: {

            root: 'flex gap-1.5',

            item: 'group relative flex flex-1 gap-3',

            container: 'relative flex items-center gap-1.5',

            indicator: 'group-data-[state=completed]:text-inverted group-data-[state=active]:text-inverted text-muted',

            separator: 'flex-1 rounded-full bg-elevated',

            wrapper: 'w-full',

            date: 'text-dimmed text-xs/5',

            title: 'font-medium text-highlighted text-sm',

            description: 'text-muted text-wrap text-sm'

          },

          variants: {

            orientation: {

              horizontal: {

                root: 'flex-row w-full',

                item: 'flex-col',

                separator: 'h-0.5'

              },

              vertical: {

                root: 'flex-col',

                container: 'flex-col',

                separator: 'w-0.5'

              }

            },

            color: {

              primary: {

                indicator: 'group-data-[state=completed]:bg-primary group-data-[state=active]:bg-primary'

              },

              secondary: {

                indicator: 'group-data-[state=completed]:bg-secondary group-data-[state=active]:bg-secondary'

              },

              success: {

                indicator: 'group-data-[state=completed]:bg-success group-data-[state=active]:bg-success'

              },

              info: {

                indicator: 'group-data-[state=completed]:bg-info group-data-[state=active]:bg-info'

              },

              warning: {

                indicator: 'group-data-[state=completed]:bg-warning group-data-[state=active]:bg-warning'

              },

              error: {

                indicator: 'group-data-[state=completed]:bg-error group-data-[state=active]:bg-error'

              },

              neutral: {

                indicator: 'group-data-[state=completed]:bg-inverted group-data-[state=active]:bg-inverted'

              }

            },

            size: {

              '3xs': '',

              '2xs': '',

              xs: '',

              sm: '',

              md: '',

              lg: '',

              xl: '',

              '2xl': '',

              '3xl': ''

            },

            reverse: {

              true: ''

            }

          },

          compoundVariants: [

            {

              color: 'primary',

              reverse: false,

              class: {

                separator: 'group-data-[state=completed]:bg-primary'

              }

            },

            {

              color: 'primary',

              reverse: true,

              class: {

                separator: 'group-data-[state=active]:bg-primary group-data-[state=completed]:bg-primary'

              }

            },

            {

              color: 'neutral',

              reverse: false,

              class: {

                separator: 'group-data-[state=completed]:bg-inverted'

              }

            },

            {

              color: 'neutral',

              reverse: true,

              class: {

                separator: 'group-data-[state=active]:bg-inverted group-data-[state=completed]:bg-inverted'

              }

            },

            {

              orientation: 'horizontal',

              size: '3xs',

              class: {

                wrapper: 'pe-4.5'

              }

            },

            {

              orientation: 'horizontal',

              size: '2xs',

              class: {

                wrapper: 'pe-5'

              }

            },

            {

              orientation: 'horizontal',

              size: 'xs',

              class: {

                wrapper: 'pe-5.5'

              }

            },

            {

              orientation: 'horizontal',

              size: 'sm',

              class: {

                wrapper: 'pe-6'

              }

            },

            {

              orientation: 'horizontal',

              size: 'md',

              class: {

                wrapper: 'pe-6.5'

              }

            },

            {

              orientation: 'horizontal',

              size: 'lg',

              class: {

                wrapper: 'pe-7'

              }

            },

            {

              orientation: 'horizontal',

              size: 'xl',

              class: {

                wrapper: 'pe-7.5'

              }

            },

            {

              orientation: 'horizontal',

              size: '2xl',

              class: {

                wrapper: 'pe-8'

              }

            },

            {

              orientation: 'horizontal',

              size: '3xl',

              class: {

                wrapper: 'pe-8.5'

              }

            },

            {

              orientation: 'vertical',

              size: '3xs',

              class: {

                wrapper: '-mt-0.5 pb-4.5'

              }

            },

            {

              orientation: 'vertical',

              size: '2xs',

              class: {

                wrapper: 'pb-5'

              }

            },

            {

              orientation: 'vertical',

              size: 'xs',

              class: {

                wrapper: 'mt-0.5 pb-5.5'

              }

            },

            {

              orientation: 'vertical',

              size: 'sm',

              class: {

                wrapper: 'mt-1 pb-6'

              }

            },

            {

              orientation: 'vertical',

              size: 'md',

              class: {

                wrapper: 'mt-1.5 pb-6.5'

              }

            },

            {

              orientation: 'vertical',

              size: 'lg',

              class: {

                wrapper: 'mt-2 pb-7'

              }

            },

            {

              orientation: 'vertical',

              size: 'xl',

              class: {

                wrapper: 'mt-2.5 pb-7.5'

              }

            },

            {

              orientation: 'vertical',

              size: '2xl',

              class: {

                wrapper: 'mt-3 pb-8'

              }

            },

            {

              orientation: 'vertical',

              size: '3xl',

              class: {

                wrapper: 'mt-3.5 pb-8.5'

              }

            }

          ],

          defaultVariants: {

            size: 'md',

            color: 'primary'

          }

        }

      }

    })

  ]

})
```

Some colors in `compoundVariants` are omitted for readability. Check out the source code on GitHub.

## Changelog

[`8e431`](https://github.com/nuxt/ui/commit/8e431be00fb09c139a6ecf250aabab90244b5430) — feat: add `select` event ([#5826](https://github.com/nuxt/ui/issues/5826))

[`55646`](https://github.com/nuxt/ui/commit/55646eaeab1598ad53b95baa2c8acb15f798482b) — feat: add `valueKey` prop ([#5905](https://github.com/nuxt/ui/issues/5905))

[`8610d`](https://github.com/nuxt/ui/commit/8610d4d9ef063965e58bde7c3c017c90d64b4a35) — feat: add wrapper slot and fix dynamic slot conditions ([#5868](https://github.com/nuxt/ui/issues/5868))

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`5170c`](https://github.com/nuxt/ui/commit/5170cfd7eb44a25c64673cf12979f9ca1049695f) — feat: add `reverse` prop ([#4316](https://github.com/nuxt/ui/issues/4316))

[`80177`](https://github.com/nuxt/ui/commit/80177679f2aa0d7f0e39e639a02d527a06e6172c) — feat: new component ([#4215](https://github.com/nuxt/ui/issues/4215))[Table](https://ui.nuxt.com/docs/components/table)

[

A responsive table element to display data in rows and columns.

](https://ui.nuxt.com/docs/components/table)[

Tree

A tree view component to display and interact with hierarchical data structures.

](https://ui.nuxt.com/docs/components/tree)