---
title: "Vue Tabs Component"
source: "https://ui.nuxt.com/docs/components/tabs"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A set of tab panels that are displayed one at a time."
tags:
---
## Tabs

[Tabs](https://reka-ui.com/docs/components/tabs) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Tabs.vue)

A set of tab panels that are displayed one at a time.

## Usage

Use the Tabs component to display a list of items in a tabs.

```
<script setup lang="ts">

const items = [

  {

    label: 'Account',

    icon: 'i-lucide-user',

    slot: 'account'

  },

  {

    label: 'Password',

    icon: 'i-lucide-lock',

    slot: 'password'

  }

]

const state = reactive({

  name: 'Benjamin Canac',

  username: 'benjamincanac',

  currentPassword: '',

  newPassword: '',

  confirmPassword: ''

})

</script>

<template>

  <UTabs :items="items">

    <template #account>

      <UForm :state="state" class="flex flex-col gap-4">

        <UFormField label="Name" name="name">

          <UInput v-model="state.name" class="w-full" />

        </UFormField>

        <UFormField label="Username" name="username">

          <UInput v-model="state.username" class="w-full" />

        </UFormField>

      </UForm>

    </template>

    <template #password>

      <UForm :state="state" class="flex flex-col gap-4">

        <UFormField label="Current Password" name="current" required>

          <UInput v-model="state.currentPassword" type="password" required class="w-full" />

        </UFormField>

        <UFormField label="New Password" name="new" required>

          <UInput v-model="state.newPassword" type="password" required class="w-full" />

        </UFormField>

        <UFormField label="Confirm Password" name="confirm" required>

          <UInput v-model="state.confirmPassword" type="password" required class="w-full" />

        </UFormField>

      </UForm>

    </template>

  </UTabs>

</template>
```

### Items

Use the `items` prop as an array of objects with the following properties:

- `label?: string`
- `icon?: string`
- `avatar?: AvatarProps`
- `badge?: string | number | BadgeProps`
- `content?: string`
- `value?: string | number`
- `disabled?: boolean`
- [`slot?: string`](https://ui.nuxt.com/docs/components/#with-custom-slot)
- `class?: any`
- `ui?: { trigger?: ClassNameValue, leadingIcon?: ClassNameValue, leadingAvatar?: ClassNameValue, leadingAvatarSize?: ClassNameValue, label?: ClassNameValue, trailingBadge?: ClassNameValue, trailingBadgeSize?: ClassNameValue, content?: ClassNameValue }`

```
<script setup lang="ts">

import type { TabsItem } from '@nuxt/ui'

const items = ref<TabsItem[]>([

  {

    label: 'Account',

    icon: 'i-lucide-user',

    content: 'This is the account content.'

  },

  {

    label: 'Password',

    icon: 'i-lucide-lock',

    content: 'This is the password content.'

  }

])

</script>

<template>

  <UTabs :items="items" class="w-full" />

</template>
```

Set the `content` prop to `false` to turn the Tabs into a toggle-only control without displaying any content. Defaults to `true`.

```
<script setup lang="ts">

import type { TabsItem } from '@nuxt/ui'

const items = ref<TabsItem[]>([

  {

    label: 'Account',

    icon: 'i-lucide-user',

    content: 'This is the account content.'

  },

  {

    label: 'Password',

    icon: 'i-lucide-lock',

    content: 'This is the password content.'

  }

])

</script>

<template>

  <UTabs :content="false" :items="items" class="w-full" />

</template>
```

### Unmount

Use the `unmount-on-hide` prop to prevent the content from being unmounted when the Tabs is collapsed. Defaults to `true`.

```
<script setup lang="ts">

import type { TabsItem } from '@nuxt/ui'

const items = ref<TabsItem[]>([

  {

    label: 'Account',

    icon: 'i-lucide-user',

    content: 'This is the account content.'

  },

  {

    label: 'Password',

    icon: 'i-lucide-lock',

    content: 'This is the password content.'

  }

])

</script>

<template>

  <UTabs :unmount-on-hide="false" :items="items" class="w-full" />

</template>
```

You can inspect the DOM to see each item's content being rendered.

### Color

Use the `color` prop to change the color of the Tabs.

```
<script setup lang="ts">

import type { TabsItem } from '@nuxt/ui'

const items = ref<TabsItem[]>([

  {

    label: 'Account'

  },

  {

    label: 'Password'

  }

])

</script>

<template>

  <UTabs color="neutral" :content="false" :items="items" class="w-full" />

</template>
```

### Variant

Use the `variant` prop to change the variant of the Tabs.

```
<script setup lang="ts">

import type { TabsItem } from '@nuxt/ui'

const items = ref<TabsItem[]>([

  {

    label: 'Account'

  },

  {

    label: 'Password'

  }

])

</script>

<template>

  <UTabs color="neutral" variant="link" :content="false" :items="items" class="w-full" />

</template>
```

### Size

Use the `size` prop to change the size of the Tabs.

```
<script setup lang="ts">

import type { TabsItem } from '@nuxt/ui'

const items = ref<TabsItem[]>([

  {

    label: 'Account'

  },

  {

    label: 'Password'

  }

])

</script>

<template>

  <UTabs size="md" variant="pill" :content="false" :items="items" class="w-full" />

</template>
```

### Orientation

Use the `orientation` prop to change the orientation of the Tabs. Defaults to `horizontal`.

```
<script setup lang="ts">

import type { TabsItem } from '@nuxt/ui'

const items = ref<TabsItem[]>([

  {

    label: 'Account'

  },

  {

    label: 'Password'

  }

])

</script>

<template>

  <UTabs orientation="vertical" variant="pill" :content="false" :items="items" class="w-full" />

</template>
```

## Examples

### Control active item

You can control the active item by using the `default-value` prop or the `v-model` directive with the `value` of the item. If no `value` is provided, it defaults to the index **as a string**.

```
<script setup lang="ts">

import type { TabsItem } from '@nuxt/ui'

const items: TabsItem[] = [

  {

    label: 'Account',

    icon: 'i-lucide-user'

  },

  {

    label: 'Password',

    icon: 'i-lucide-lock'

  }

]

const active = ref('0')

// Note: This is for demonstration purposes only. Don't do this at home.

onMounted(() => {

  setInterval(() => {

    active.value = String((Number(active.value) + 1) % items.length)

  }, 2000)

})

</script>

<template>

  <UTabs v-model="active" :content="false" :items="items" class="w-full" />

</template>
```

Use the `value-key` prop to change the key used to match items when a `v-model` or `default-value` is provided.

### With route query

You can control the active item by a URL query parameter, using `route.query.tab` as the `value` of the item.

```
<script setup lang="ts">

import type { TabsItem } from '@nuxt/ui'

const route = useRoute()

const router = useRouter()

const items: TabsItem[] = [

  {

    label: 'Account',

    icon: 'i-lucide-user',

    value: 'account'

  },

  {

    label: 'Password',

    icon: 'i-lucide-lock',

    value: 'password'

  }

]

const active = computed({

  get() {

    return (route.query.tab as string) || 'account'

  },

  set(tab) {

    // Hash is specified here to prevent the page from scrolling to the top

    router.push({

      path: '/docs/components/tabs',

      query: { tab },

      hash: '#with-route-query'

    })

  }

})

</script>

<template>

  <UTabs v-model="active" :content="false" :items="items" class="w-full" />

</template>
```

### With content slot

Use the `#content` slot to customize the content of each item.

```
<script setup lang="ts">

import type { TabsItem } from '@nuxt/ui'

const items: TabsItem[] = [

  {

    label: 'Account',

    icon: 'i-lucide-user'

  },

  {

    label: 'Password',

    icon: 'i-lucide-lock'

  }

]

</script>

<template>

  <UTabs :items="items" class="w-full">

    <template #content="{ item }">

      <p>This is the {{ item.label }} tab.</p>

    </template>

  </UTabs>

</template>
```

### With custom slot

Use the `slot` property to customize a specific item.

You will have access to the following slots:

- `#{{ item.slot }}`

```
<script setup lang="ts">

import type { TabsItem } from '@nuxt/ui'

const items = [

  {

    label: 'Account',

    description: 'Make changes to your account here. Click save when you\'re done.',

    icon: 'i-lucide-user',

    slot: 'account' as const

  },

  {

    label: 'Password',

    description: 'Change your password here. After saving, you\'ll be logged out.',

    icon: 'i-lucide-lock',

    slot: 'password' as const

  }

] satisfies TabsItem[]

const state = reactive({

  name: 'Benjamin Canac',

  username: 'benjamincanac',

  currentPassword: '',

  newPassword: '',

  confirmPassword: ''

})

</script>

<template>

  <UTabs :items="items" variant="link" :ui="{ trigger: 'grow' }" class="gap-4 w-full">

    <template #account="{ item }">

      <p class="text-muted mb-4">

        {{ item.description }}

      </p>

      <UForm :state="state" class="flex flex-col gap-4">

        <UFormField label="Name" name="name">

          <UInput v-model="state.name" class="w-full" />

        </UFormField>

        <UFormField label="Username" name="username">

          <UInput v-model="state.username" class="w-full" />

        </UFormField>

        <UButton label="Save changes" type="submit" variant="soft" class="self-end" />

      </UForm>

    </template>

    <template #password="{ item }">

      <p class="text-muted mb-4">

        {{ item.description }}

      </p>

      <UForm :state="state" class="flex flex-col gap-4">

        <UFormField label="Current Password" name="current" required>

          <UInput v-model="state.currentPassword" type="password" required class="w-full" />

        </UFormField>

        <UFormField label="New Password" name="new" required>

          <UInput v-model="state.newPassword" type="password" required class="w-full" />

        </UFormField>

        <UFormField label="Confirm Password" name="confirm" required>

          <UInput v-model="state.confirmPassword" type="password" required class="w-full" />

        </UFormField>

        <UButton label="Change password" type="submit" variant="soft" class="self-end" />

      </UForm>

    </template>

  </UTabs>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `items` |  | ` T[]` |
| `color` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `variant` | `'pill'` | ` "pill" \| "link"` |
| `size` | `'md'` | ` "sm" \| "xs" \| "md" \| "lg" \| "xl"` |
| `orientation` | `'horizontal'` | ` "horizontal" \| "vertical"`  The orientation of the tabs. |
| `content` | `true` | `boolean`  The content of the tabs, can be disabled to prevent rendering the content. |
| `valueKey` | `'value'` | ` keyof Extract<NestedItem<T>, object> \| DotPathKeys<Extract<NestedItem<T>, object>>`  The key used to get the value from the item. |
| `labelKey` | `'label'` | ` keyof Extract<NestedItem<T>, object> \| DotPathKeys<Extract<NestedItem<T>, object>>`  The key used to get the label from the item. |
| `defaultValue` | `'0'` | ` string \| number`  The value of the tab that should be active when initially rendered. Use when you do not need to control the state of the tabs |
| `modelValue` |  | ` string \| number`  The controlled value of the tab to activate. Can be bind as `v-model`. |
| `activationMode` | `automatic` | ` "automatic" \| "manual"`  Whether a tab is activated automatically (on focus) or manually (on click). |
| `unmountOnHide` | `true` | `boolean`  When `true`, the element will be unmounted on closed state. |
| `ui` |  | ` { root?: ClassNameValue; list?: ClassNameValue; indicator?: ClassNameValue; trigger?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; label?: ClassNameValue; trailingBadge?: ClassNameValue; trailingBadgeSize?: ClassNameValue; content?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `leading` | `{ item: T; index: number; ui: object; }` |
| `default` | `{ item: T; index: number; }` |
| `trailing` | `{ item: T; index: number; ui: object; }` |
| `content` | `{ item: T; index: number; ui: object; }` |
| `list-leading` | `{}` |
| `list-trailing` | `{}` |

### Emits

| Event | Type |
| --- | --- |
| `update:modelValue` | `[payload: string \| number]` |

### Expose

When accessing the component via a template ref, you can use the following:

| Name | Type |
| --- | --- |
| `triggersRef` | `Ref<ComponentPublicInstance[]>` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    tabs: {

      slots: {

        root: 'flex items-center gap-2',

        list: 'relative flex p-1 group',

        indicator: 'absolute transition-[translate,width] duration-200',

        trigger: [

          'group relative inline-flex items-center min-w-0 data-[state=inactive]:text-muted hover:data-[state=inactive]:not-disabled:text-default font-medium rounded-md disabled:cursor-not-allowed disabled:opacity-75',

          'transition-colors'

        ],

        leadingIcon: 'shrink-0',

        leadingAvatar: 'shrink-0',

        leadingAvatarSize: '',

        label: 'truncate',

        trailingBadge: 'shrink-0',

        trailingBadgeSize: 'sm',

        content: 'focus:outline-none w-full'

      },

      variants: {

        color: {

          primary: '',

          secondary: '',

          success: '',

          info: '',

          warning: '',

          error: '',

          neutral: ''

        },

        variant: {

          pill: {

            list: 'bg-elevated rounded-lg',

            trigger: 'grow',

            indicator: 'rounded-md shadow-xs'

          },

          link: {

            list: 'border-default',

            indicator: 'rounded-full',

            trigger: 'focus:outline-none'

          }

        },

        orientation: {

          horizontal: {

            root: 'flex-col',

            list: 'w-full',

            indicator: 'left-0 w-(--reka-tabs-indicator-size) translate-x-(--reka-tabs-indicator-position)',

            trigger: 'justify-center'

          },

          vertical: {

            list: 'flex-col',

            indicator: 'top-0 h-(--reka-tabs-indicator-size) translate-y-(--reka-tabs-indicator-position)'

          }

        },

        size: {

          xs: {

            trigger: 'px-2 py-1 text-xs gap-1',

            leadingIcon: 'size-4',

            leadingAvatarSize: '3xs'

          },

          sm: {

            trigger: 'px-2.5 py-1.5 text-xs gap-1.5',

            leadingIcon: 'size-4',

            leadingAvatarSize: '3xs'

          },

          md: {

            trigger: 'px-3 py-1.5 text-sm gap-1.5',

            leadingIcon: 'size-5',

            leadingAvatarSize: '2xs'

          },

          lg: {

            trigger: 'px-3 py-2 text-sm gap-2',

            leadingIcon: 'size-5',

            leadingAvatarSize: '2xs'

          },

          xl: {

            trigger: 'px-3 py-2 text-base gap-2',

            leadingIcon: 'size-6',

            leadingAvatarSize: 'xs'

          }

        }

      },

      compoundVariants: [

        {

          orientation: 'horizontal',

          variant: 'pill',

          class: {

            indicator: 'inset-y-1'

          }

        },

        {

          orientation: 'horizontal',

          variant: 'link',

          class: {

            list: 'border-b -mb-px',

            indicator: '-bottom-px h-px'

          }

        },

        {

          orientation: 'vertical',

          variant: 'pill',

          class: {

            indicator: 'inset-x-1',

            list: 'items-center'

          }

        },

        {

          orientation: 'vertical',

          variant: 'link',

          class: {

            list: 'border-s -ms-px',

            indicator: '-start-px w-px'

          }

        },

        {

          color: 'primary',

          variant: 'pill',

          class: {

            indicator: 'bg-primary',

            trigger: 'data-[state=active]:text-inverted focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary'

          }

        },

        {

          color: 'neutral',

          variant: 'pill',

          class: {

            indicator: 'bg-inverted',

            trigger: 'data-[state=active]:text-inverted focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-inverted'

          }

        },

        {

          color: 'primary',

          variant: 'link',

          class: {

            indicator: 'bg-primary',

            trigger: 'data-[state=active]:text-primary focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-primary'

          }

        },

        {

          color: 'neutral',

          variant: 'link',

          class: {

            indicator: 'bg-inverted',

            trigger: 'data-[state=active]:text-highlighted focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-inverted'

          }

        }

      ],

      defaultVariants: {

        color: 'primary',

        variant: 'pill',

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

        tabs: {

          slots: {

            root: 'flex items-center gap-2',

            list: 'relative flex p-1 group',

            indicator: 'absolute transition-[translate,width] duration-200',

            trigger: [

              'group relative inline-flex items-center min-w-0 data-[state=inactive]:text-muted hover:data-[state=inactive]:not-disabled:text-default font-medium rounded-md disabled:cursor-not-allowed disabled:opacity-75',

              'transition-colors'

            ],

            leadingIcon: 'shrink-0',

            leadingAvatar: 'shrink-0',

            leadingAvatarSize: '',

            label: 'truncate',

            trailingBadge: 'shrink-0',

            trailingBadgeSize: 'sm',

            content: 'focus:outline-none w-full'

          },

          variants: {

            color: {

              primary: '',

              secondary: '',

              success: '',

              info: '',

              warning: '',

              error: '',

              neutral: ''

            },

            variant: {

              pill: {

                list: 'bg-elevated rounded-lg',

                trigger: 'grow',

                indicator: 'rounded-md shadow-xs'

              },

              link: {

                list: 'border-default',

                indicator: 'rounded-full',

                trigger: 'focus:outline-none'

              }

            },

            orientation: {

              horizontal: {

                root: 'flex-col',

                list: 'w-full',

                indicator: 'left-0 w-(--reka-tabs-indicator-size) translate-x-(--reka-tabs-indicator-position)',

                trigger: 'justify-center'

              },

              vertical: {

                list: 'flex-col',

                indicator: 'top-0 h-(--reka-tabs-indicator-size) translate-y-(--reka-tabs-indicator-position)'

              }

            },

            size: {

              xs: {

                trigger: 'px-2 py-1 text-xs gap-1',

                leadingIcon: 'size-4',

                leadingAvatarSize: '3xs'

              },

              sm: {

                trigger: 'px-2.5 py-1.5 text-xs gap-1.5',

                leadingIcon: 'size-4',

                leadingAvatarSize: '3xs'

              },

              md: {

                trigger: 'px-3 py-1.5 text-sm gap-1.5',

                leadingIcon: 'size-5',

                leadingAvatarSize: '2xs'

              },

              lg: {

                trigger: 'px-3 py-2 text-sm gap-2',

                leadingIcon: 'size-5',

                leadingAvatarSize: '2xs'

              },

              xl: {

                trigger: 'px-3 py-2 text-base gap-2',

                leadingIcon: 'size-6',

                leadingAvatarSize: 'xs'

              }

            }

          },

          compoundVariants: [

            {

              orientation: 'horizontal',

              variant: 'pill',

              class: {

                indicator: 'inset-y-1'

              }

            },

            {

              orientation: 'horizontal',

              variant: 'link',

              class: {

                list: 'border-b -mb-px',

                indicator: '-bottom-px h-px'

              }

            },

            {

              orientation: 'vertical',

              variant: 'pill',

              class: {

                indicator: 'inset-x-1',

                list: 'items-center'

              }

            },

            {

              orientation: 'vertical',

              variant: 'link',

              class: {

                list: 'border-s -ms-px',

                indicator: '-start-px w-px'

              }

            },

            {

              color: 'primary',

              variant: 'pill',

              class: {

                indicator: 'bg-primary',

                trigger: 'data-[state=active]:text-inverted focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary'

              }

            },

            {

              color: 'neutral',

              variant: 'pill',

              class: {

                indicator: 'bg-inverted',

                trigger: 'data-[state=active]:text-inverted focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-inverted'

              }

            },

            {

              color: 'primary',

              variant: 'link',

              class: {

                indicator: 'bg-primary',

                trigger: 'data-[state=active]:text-primary focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-primary'

              }

            },

            {

              color: 'neutral',

              variant: 'link',

              class: {

                indicator: 'bg-inverted',

                trigger: 'data-[state=active]:text-highlighted focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-inverted'

              }

            }

          ],

          defaultVariants: {

            color: 'primary',

            variant: 'pill',

            size: 'md'

          }

        }

      }

    })

  ]

})
```

Some colors in `compoundVariants` are omitted for readability. Check out the source code on GitHub.

## Changelog

[`55646`](https://github.com/nuxt/ui/commit/55646eaeab1598ad53b95baa2c8acb15f798482b) — feat: add `valueKey` prop ([#5905](https://github.com/nuxt/ui/issues/5905))

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`e5c11`](https://github.com/nuxt/ui/commit/e5c11e6696e8fdfa2f4ed4f01157e230d1c25561) — fix: ensure proper badge display

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`340fc`](https://github.com/nuxt/ui/commit/340fc4837eb7cff44b5693d73865ea98d41a3ab6) — fix: use nullish coalescing on item value

[`11a03`](https://github.com/nuxt/ui/commit/11a03201ed8454f37e911db4a14b00f74104932a) — fix: dot notation type support for `labelKey` and `valueKey` ([#4933](https://github.com/nuxt/ui/issues/4933))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`fbec2`](https://github.com/nuxt/ui/commit/fbec29c1b7b874ca7c93652abe8bb40b4b9d8ef6) — fix: add missing Badge import ([#4594](https://github.com/nuxt/ui/issues/4594))

[`b2289`](https://github.com/nuxt/ui/commit/b22891abe68c40d4a33fbbcedac93e3a6be9951f) — fix: display badge when not undefined

[`62ab0`](https://github.com/nuxt/ui/commit/62ab01655ca8494a2856477f9724ea27d541e9ff) — feat: add badge on items ([#4553](https://github.com/nuxt/ui/issues/4553))

[`7a2bd`](https://github.com/nuxt/ui/commit/7a2bd4e6179373902ba6f285903ea896fd1d378f) — feat: expose trigger refs

[`b9adc`](https://github.com/nuxt/ui/commit/b9adc83e787db02507e6e7bb1aabc684eccc197b) — feat: add `ui` field in items ([#4060](https://github.com/nuxt/ui/issues/4060))

[`999a0`](https://github.com/nuxt/ui/commit/999a0f84671fad20fa3dc50c6774af2e0200b32e) — fix: set `focus:outline-none` with `link` variant

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`06e56`](https://github.com/nuxt/ui/commit/06e5689da80b36205d0548d5d6b58510938e4a6e) — fix: prevent trigger truncate without parent width

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`3447a`](https://github.com/nuxt/ui/commit/3447a062b636a469089d6e9bdcfcb3dce9063ee5) — feat: add `list-leading` and `list-trailing` slots ([#3837](https://github.com/nuxt/ui/issues/3837))

[`b9983`](https://github.com/nuxt/ui/commit/b9983549a4b743724ea3ef99cc4a243f5ca41e53) — fix: improve generic types ([#3331](https://github.com/nuxt/ui/issues/3331))

[`1769d`](https://github.com/nuxt/ui/commit/1769d5ed6ea46b1f7eafdc48cb6456512229f98b) — fix: remove `focus:outline-hidden` class

[`ef861`](https://github.com/nuxt/ui/commit/ef86108f14da23fa292afe016517eac95c34bf76) — chore: add eol in script tag to fix syntax highlight