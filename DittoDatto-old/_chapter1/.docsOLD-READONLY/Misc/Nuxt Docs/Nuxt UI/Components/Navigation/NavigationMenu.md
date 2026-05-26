---
title: "Vue NavigationMenu Component"
source: "https://ui.nuxt.com/docs/components/navigation-menu"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A list of links that can be displayed horizontally or vertically."
tags:
---
## Usage

Use the NavigationMenu component to display a list of links horizontally or vertically.

```
<script setup lang="ts">

import type { NavigationMenuItem } from '@nuxt/ui'

const items = ref<NavigationMenuItem[]>([

  {

    label: 'Guide',

    icon: 'i-lucide-book-open',

    to: '/docs/getting-started',

    children: [

      {

        label: 'Introduction',

        description: 'Fully styled and customizable components for Nuxt.',

        icon: 'i-lucide-house'

      },

      {

        label: 'Installation',

        description: 'Learn how to install and configure Nuxt UI in your application.',

        icon: 'i-lucide-cloud-download'

      },

      {

        label: 'Icons',

        icon: 'i-lucide-smile',

        description: 'You have nothing to do, @nuxt/icon will handle it automatically.'

      },

      {

        label: 'Colors',

        icon: 'i-lucide-swatch-book',

        description: 'Choose a primary and a neutral color from your Tailwind CSS theme.'

      },

      {

        label: 'Theme',

        icon: 'i-lucide-cog',

        description: 'You can customize components by using the \`class\` / \`ui\` props or in your app.config.ts.'

      }

    ]

  },

  {

    label: 'Composables',

    icon: 'i-lucide-database',

    to: '/docs/composables',

    children: [

      {

        label: 'defineShortcuts',

        icon: 'i-lucide-file-text',

        description: 'Define shortcuts for your application.',

        to: '/docs/composables/define-shortcuts'

      },

      {

        label: 'useOverlay',

        icon: 'i-lucide-file-text',

        description: 'Display a modal/slideover within your application.',

        to: '/docs/composables/use-overlay'

      },

      {

        label: 'useToast',

        icon: 'i-lucide-file-text',

        description: 'Display a toast within your application.',

        to: '/docs/composables/use-toast'

      }

    ]

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    to: '/docs/components',

    active: true,

    children: [

      {

        label: 'Link',

        icon: 'i-lucide-file-text',

        description: 'Use NuxtLink with superpowers.',

        to: '/docs/components/link'

      },

      {

        label: 'Modal',

        icon: 'i-lucide-file-text',

        description: 'Display a modal within your application.',

        to: '/docs/components/modal'

      },

      {

        label: 'NavigationMenu',

        icon: 'i-lucide-file-text',

        description: 'Display a list of links.',

        to: '/docs/components/navigation-menu'

      },

      {

        label: 'Pagination',

        icon: 'i-lucide-file-text',

        description: 'Display a list of pages.',

        to: '/docs/components/pagination'

      },

      {

        label: 'Popover',

        icon: 'i-lucide-file-text',

        description: 'Display a non-modal dialog that floats around a trigger element.',

        to: '/docs/components/popover'

      },

      {

        label: 'Progress',

        icon: 'i-lucide-file-text',

        description: 'Show a horizontal bar to indicate task progression.',

        to: '/docs/components/progress'

      }

    ]

  },

  {

    label: 'GitHub',

    icon: 'i-simple-icons-github',

    badge: '6k',

    to: 'https://github.com/nuxt/ui',

    target: '_blank'

  },

  {

    label: 'Help',

    icon: 'i-lucide-circle-help',

    disabled: true

  }

])

</script>

<template>

  <UNavigationMenu :items="items" />

</template>
```

### Items

Use the `items` prop as an array of objects with the following properties:

- `label?: string`
- `icon?: string`
- `avatar?: AvatarProps`
- `badge?: string | number | BadgeProps`
- `tooltip?: TooltipProps`
- `trailingIcon?: string`
- `type?: 'label' | 'trigger' | 'link'`
- `defaultOpen?: boolean`
- `open?: boolean`
- `value?: string`
- `disabled?: boolean`
- [`slot?: string`](https://ui.nuxt.com/docs/components/#with-custom-slot)
- `onSelect?: (e: Event) => void`
- `children?: NavigationMenuChildItem[]`
- `class?: any`
- `ui?: { linkLeadingAvatarSize?: ClassNameValue, linkLeadingAvatar?: ClassNameValue, linkLeadingIcon?: ClassNameValue, linkLabel?: ClassNameValue, linkLabelExternalIcon?: ClassNameValue, linkTrailing?: ClassNameValue, linkTrailingBadgeSize?: ClassNameValue, linkTrailingBadge?: ClassNameValue, linkTrailingIcon?: ClassNameValue, label?: ClassNameValue, link?: ClassNameValue, content?: ClassNameValue, childList?: ClassNameValue, childLabel?: ClassNameValue, childItem?: ClassNameValue, childLink?: ClassNameValue, childLinkIcon?: ClassNameValue, childLinkWrapper?: ClassNameValue, childLinkLabel?: ClassNameValue, childLinkLabelExternalIcon?: ClassNameValue, childLinkDescription?: ClassNameValue }`

You can pass any property from the [Link](https://ui.nuxt.com/docs/components/link#props) component such as `to`, `target`, etc.

```
<script setup lang="ts">

import type { NavigationMenuItem } from '@nuxt/ui'

const items = ref<NavigationMenuItem[]>([

  {

    label: 'Guide',

    icon: 'i-lucide-book-open',

    to: '/docs/getting-started',

    children: [

      {

        label: 'Introduction',

        description: 'Fully styled and customizable components for Nuxt.',

        icon: 'i-lucide-house'

      },

      {

        label: 'Installation',

        description: 'Learn how to install and configure Nuxt UI in your application.',

        icon: 'i-lucide-cloud-download'

      },

      {

        label: 'Icons',

        icon: 'i-lucide-smile',

        description: 'You have nothing to do, @nuxt/icon will handle it automatically.'

      },

      {

        label: 'Colors',

        icon: 'i-lucide-swatch-book',

        description: 'Choose a primary and a neutral color from your Tailwind CSS theme.'

      },

      {

        label: 'Theme',

        icon: 'i-lucide-cog',

        description: 'You can customize components by using the \`class\` / \`ui\` props or in your app.config.ts.'

      }

    ]

  },

  {

    label: 'Composables',

    icon: 'i-lucide-database',

    to: '/docs/composables',

    children: [

      {

        label: 'defineShortcuts',

        icon: 'i-lucide-file-text',

        description: 'Define shortcuts for your application.',

        to: '/docs/composables/define-shortcuts'

      },

      {

        label: 'useOverlay',

        icon: 'i-lucide-file-text',

        description: 'Display a modal/slideover within your application.',

        to: '/docs/composables/use-overlay'

      },

      {

        label: 'useToast',

        icon: 'i-lucide-file-text',

        description: 'Display a toast within your application.',

        to: '/docs/composables/use-toast'

      }

    ]

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    to: '/docs/components',

    active: true,

    children: [

      {

        label: 'Link',

        icon: 'i-lucide-file-text',

        description: 'Use NuxtLink with superpowers.',

        to: '/docs/components/link'

      },

      {

        label: 'Modal',

        icon: 'i-lucide-file-text',

        description: 'Display a modal within your application.',

        to: '/docs/components/modal'

      },

      {

        label: 'NavigationMenu',

        icon: 'i-lucide-file-text',

        description: 'Display a list of links.',

        to: '/docs/components/navigation-menu'

      },

      {

        label: 'Pagination',

        icon: 'i-lucide-file-text',

        description: 'Display a list of pages.',

        to: '/docs/components/pagination'

      },

      {

        label: 'Popover',

        icon: 'i-lucide-file-text',

        description: 'Display a non-modal dialog that floats around a trigger element.',

        to: '/docs/components/popover'

      },

      {

        label: 'Progress',

        icon: 'i-lucide-file-text',

        description: 'Show a horizontal bar to indicate task progression.',

        to: '/docs/components/progress'

      }

    ]

  },

  {

    label: 'GitHub',

    icon: 'i-simple-icons-github',

    badge: '6k',

    to: 'https://github.com/nuxt/ui',

    target: '_blank'

  },

  {

    label: 'Help',

    icon: 'i-lucide-circle-help',

    disabled: true

  }

])

</script>

<template>

  <UNavigationMenu :items="items" class="w-full justify-center" />

</template>
```

You can also pass an array of arrays to the `items` prop to display groups of items.

Each item can take a `children` array of objects with the following properties to create submenus:
- `label: string`
- `description?: string`
- `icon?: string`
- `onSelect?: (e: Event) => void`
- `class?: any`

### Orientation

Use the `orientation` prop to change the orientation of the NavigationMenu.

When orientation is `vertical`, an [Accordion](https://ui.nuxt.com/docs/components/accordion) component is used to display each group. You can control the open state of each item using the `open` and `defaultOpen` properties and change the behavior using the [`collapsible`](https://ui.nuxt.com/docs/components/accordion#collapsible) and [`type`](https://ui.nuxt.com/docs/components/accordion#multiple) props.

```
<script setup lang="ts">

import type { NavigationMenuItem } from '@nuxt/ui'

const items = ref<NavigationMenuItem[][]>([

  [

    {

      label: 'Links',

      type: 'label'

    },

    {

      label: 'Guide',

      icon: 'i-lucide-book-open',

      children: [

        {

          label: 'Introduction',

          description: 'Fully styled and customizable components for Nuxt.',

          icon: 'i-lucide-house'

        },

        {

          label: 'Installation',

          description: 'Learn how to install and configure Nuxt UI in your application.',

          icon: 'i-lucide-cloud-download'

        },

        {

          label: 'Icons',

          icon: 'i-lucide-smile',

          description: 'You have nothing to do, @nuxt/icon will handle it automatically.'

        },

        {

          label: 'Colors',

          icon: 'i-lucide-swatch-book',

          description: 'Choose a primary and a neutral color from your Tailwind CSS theme.'

        },

        {

          label: 'Theme',

          icon: 'i-lucide-cog',

          description: 'You can customize components by using the \`class\` / \`ui\` props or in your app.config.ts.'

        }

      ]

    },

    {

      label: 'Composables',

      icon: 'i-lucide-database',

      children: [

        {

          label: 'defineShortcuts',

          icon: 'i-lucide-file-text',

          description: 'Define shortcuts for your application.',

          to: '/docs/composables/define-shortcuts'

        },

        {

          label: 'useOverlay',

          icon: 'i-lucide-file-text',

          description: 'Display a modal/slideover within your application.',

          to: '/docs/composables/use-overlay'

        },

        {

          label: 'useToast',

          icon: 'i-lucide-file-text',

          description: 'Display a toast within your application.',

          to: '/docs/composables/use-toast'

        }

      ]

    },

    {

      label: 'Components',

      icon: 'i-lucide-box',

      to: '/docs/components',

      active: true,

      defaultOpen: true,

      children: [

        {

          label: 'Link',

          icon: 'i-lucide-file-text',

          description: 'Use NuxtLink with superpowers.',

          to: '/docs/components/link'

        },

        {

          label: 'Modal',

          icon: 'i-lucide-file-text',

          description: 'Display a modal within your application.',

          to: '/docs/components/modal'

        },

        {

          label: 'NavigationMenu',

          icon: 'i-lucide-file-text',

          description: 'Display a list of links.',

          to: '/docs/components/navigation-menu'

        },

        {

          label: 'Pagination',

          icon: 'i-lucide-file-text',

          description: 'Display a list of pages.',

          to: '/docs/components/pagination'

        },

        {

          label: 'Popover',

          icon: 'i-lucide-file-text',

          description: 'Display a non-modal dialog that floats around a trigger element.',

          to: '/docs/components/popover'

        },

        {

          label: 'Progress',

          icon: 'i-lucide-file-text',

          description: 'Show a horizontal bar to indicate task progression.',

          to: '/docs/components/progress'

        }

      ]

    }

  ],

  [

    {

      label: 'GitHub',

      icon: 'i-simple-icons-github',

      badge: '6k',

      to: 'https://github.com/nuxt/ui',

      target: '_blank'

    },

    {

      label: 'Help',

      icon: 'i-lucide-circle-help',

      disabled: true

    }

  ]

])

</script>

<template>

  <UNavigationMenu orientation="vertical" :items="items" class="data-[orientation=vertical]:w-48" />

</template>
```

Groups will be spaced when orientation is `horizontal` and separated when orientation is `vertical`.

### Collapsed

In `vertical` orientation, use the `collapsed` prop to collapse the NavigationMenu, this can be useful in a sidebar for example.

You can use the [`tooltip`](https://ui.nuxt.com/docs/components/#with-tooltip-in-items) and [`popover`](https://ui.nuxt.com/docs/components/#with-popover-in-items) props to display more information on the collapsed items.

```
<script setup lang="ts">

import type { NavigationMenuItem } from '@nuxt/ui'

const items = ref<NavigationMenuItem[][]>([

  [

    {

      label: 'Links',

      type: 'label'

    },

    {

      label: 'Guide',

      icon: 'i-lucide-book-open',

      children: [

        {

          label: 'Introduction',

          description: 'Fully styled and customizable components for Nuxt.',

          icon: 'i-lucide-house'

        },

        {

          label: 'Installation',

          description: 'Learn how to install and configure Nuxt UI in your application.',

          icon: 'i-lucide-cloud-download'

        },

        {

          label: 'Icons',

          icon: 'i-lucide-smile',

          description: 'You have nothing to do, @nuxt/icon will handle it automatically.'

        },

        {

          label: 'Colors',

          icon: 'i-lucide-swatch-book',

          description: 'Choose a primary and a neutral color from your Tailwind CSS theme.'

        },

        {

          label: 'Theme',

          icon: 'i-lucide-cog',

          description: 'You can customize components by using the \`class\` / \`ui\` props or in your app.config.ts.'

        }

      ]

    },

    {

      label: 'Composables',

      icon: 'i-lucide-database',

      children: [

        {

          label: 'defineShortcuts',

          icon: 'i-lucide-file-text',

          description: 'Define shortcuts for your application.',

          to: '/docs/composables/define-shortcuts'

        },

        {

          label: 'useOverlay',

          icon: 'i-lucide-file-text',

          description: 'Display a modal/slideover within your application.',

          to: '/docs/composables/use-overlay'

        },

        {

          label: 'useToast',

          icon: 'i-lucide-file-text',

          description: 'Display a toast within your application.',

          to: '/docs/composables/use-toast'

        }

      ]

    },

    {

      label: 'Components',

      icon: 'i-lucide-box',

      to: '/docs/components',

      active: true,

      children: [

        {

          label: 'Link',

          icon: 'i-lucide-file-text',

          description: 'Use NuxtLink with superpowers.',

          to: '/docs/components/link'

        },

        {

          label: 'Modal',

          icon: 'i-lucide-file-text',

          description: 'Display a modal within your application.',

          to: '/docs/components/modal'

        },

        {

          label: 'NavigationMenu',

          icon: 'i-lucide-file-text',

          description: 'Display a list of links.',

          to: '/docs/components/navigation-menu'

        },

        {

          label: 'Pagination',

          icon: 'i-lucide-file-text',

          description: 'Display a list of pages.',

          to: '/docs/components/pagination'

        },

        {

          label: 'Popover',

          icon: 'i-lucide-file-text',

          description: 'Display a non-modal dialog that floats around a trigger element.',

          to: '/docs/components/popover'

        },

        {

          label: 'Progress',

          icon: 'i-lucide-file-text',

          description: 'Show a horizontal bar to indicate task progression.',

          to: '/docs/components/progress'

        }

      ]

    }

  ],

  [

    {

      label: 'GitHub',

      icon: 'i-simple-icons-github',

      badge: '6k',

      to: 'https://github.com/nuxt/ui',

      target: '_blank'

    },

    {

      label: 'Help',

      icon: 'i-lucide-circle-help',

      disabled: true

    }

  ]

])

</script>

<template>

  <UNavigationMenu collapsed orientation="vertical" :items="items" />

</template>
```

### Highlight

Use the `highlight` prop to display a highlighted border for the active item.

Use the `highlight-color` prop to change the color of the border. It defaults to the `color` prop.

```
<script setup lang="ts">

import type { NavigationMenuItem } from '@nuxt/ui'

const items = ref<NavigationMenuItem[][]>([

  [

    {

      label: 'Guide',

      icon: 'i-lucide-book-open',

      children: [

        {

          label: 'Introduction',

          description: 'Fully styled and customizable components for Nuxt.',

          icon: 'i-lucide-house'

        },

        {

          label: 'Installation',

          description: 'Learn how to install and configure Nuxt UI in your application.',

          icon: 'i-lucide-cloud-download'

        },

        {

          label: 'Icons',

          icon: 'i-lucide-smile',

          description: 'You have nothing to do, @nuxt/icon will handle it automatically.'

        },

        {

          label: 'Colors',

          icon: 'i-lucide-swatch-book',

          description: 'Choose a primary and a neutral color from your Tailwind CSS theme.'

        },

        {

          label: 'Theme',

          icon: 'i-lucide-cog',

          description:

            'You can customize components by using the \`class\` / \`ui\` props or in your app.config.ts.'

        }

      ]

    },

    {

      label: 'Composables',

      icon: 'i-lucide-database',

      children: [

        {

          label: 'defineShortcuts',

          icon: 'i-lucide-file-text',

          description: 'Define shortcuts for your application.',

          to: '/docs/composables/define-shortcuts'

        },

        {

          label: 'useOverlay',

          icon: 'i-lucide-file-text',

          description: 'Display a modal/slideover within your application.',

          to: '/docs/composables/use-overlay'

        },

        {

          label: 'useToast',

          icon: 'i-lucide-file-text',

          description: 'Display a toast within your application.',

          to: '/docs/composables/use-toast'

        }

      ]

    },

    {

      label: 'Components',

      icon: 'i-lucide-box',

      to: '/docs/components',

      active: true,

      defaultOpen: true,

      children: [

        {

          label: 'Link',

          icon: 'i-lucide-file-text',

          description: 'Use NuxtLink with superpowers.',

          to: '/docs/components/link'

        },

        {

          label: 'Modal',

          icon: 'i-lucide-file-text',

          description: 'Display a modal within your application.',

          to: '/docs/components/modal'

        },

        {

          label: 'NavigationMenu',

          icon: 'i-lucide-file-text',

          description: 'Display a list of links.',

          to: '/docs/components/navigation-menu'

        },

        {

          label: 'Pagination',

          icon: 'i-lucide-file-text',

          description: 'Display a list of pages.',

          to: '/docs/components/pagination'

        },

        {

          label: 'Popover',

          icon: 'i-lucide-file-text',

          description: 'Display a non-modal dialog that floats around a trigger element.',

          to: '/docs/components/popover'

        },

        {

          label: 'Progress',

          icon: 'i-lucide-file-text',

          description: 'Show a horizontal bar to indicate task progression.',

          to: '/docs/components/progress'

        }

      ]

    }

  ],

  [

    {

      label: 'GitHub',

      icon: 'i-simple-icons-github',

      badge: '6k',

      to: 'https://github.com/nuxt/ui',

      target: '_blank'

    },

    {

      label: 'Help',

      icon: 'i-lucide-circle-help',

      disabled: true

    }

  ]

])

</script>

<template>

  <UNavigationMenu

    highlight

    highlight-color="primary"

    orientation="horizontal"

    :items="items"

    class="data-[orientation=horizontal]:border-b border-default data-[orientation=horizontal]:w-full data-[orientation=vertical]:w-48"

  />

</template>
```

In this example, the `border-b` class is applied to display a border in `horizontal` orientation, this is not done by default to let you have a clean slate to work with.

### Color

Use the `color` prop to change the color of the NavigationMenu.

### Variant

Use the `variant` prop to change the variant of the NavigationMenu.

The `highlight` prop changes the `pill` variant active item style. Try it out to see the difference.

### Trailing Icon

Use the `trailing-icon` prop to customize the trailing [Icon](https://ui.nuxt.com/docs/components/icon) of each item. Defaults to `i-lucide-chevron-down`. This icon is only displayed when an item has children.

You can also set an icon for a specific item by using the `trailingIcon` property in the item object.

```
<script setup lang="ts">

import type { NavigationMenuItem } from '@nuxt/ui'

const items = ref<NavigationMenuItem[]>([

  {

    label: 'Guide',

    icon: 'i-lucide-book-open',

    to: '/docs/getting-started',

    children: [

      {

        label: 'Introduction',

        description: 'Fully styled and customizable components for Nuxt.',

        icon: 'i-lucide-house'

      },

      {

        label: 'Installation',

        description: 'Learn how to install and configure Nuxt UI in your application.',

        icon: 'i-lucide-cloud-download'

      },

      {

        label: 'Icons',

        icon: 'i-lucide-smile',

        description: 'You have nothing to do, @nuxt/icon will handle it automatically.'

      },

      {

        label: 'Colors',

        icon: 'i-lucide-swatch-book',

        description: 'Choose a primary and a neutral color from your Tailwind CSS theme.'

      },

      {

        label: 'Theme',

        icon: 'i-lucide-cog',

        description: 'You can customize components by using the \`class\` / \`ui\` props or in your app.config.ts.'

      }

    ]

  },

  {

    label: 'Composables',

    icon: 'i-lucide-database',

    to: '/docs/composables',

    children: [

      {

        label: 'defineShortcuts',

        icon: 'i-lucide-file-text',

        description: 'Define shortcuts for your application.',

        to: '/docs/composables/define-shortcuts'

      },

      {

        label: 'useOverlay',

        icon: 'i-lucide-file-text',

        description: 'Display a modal/slideover within your application.',

        to: '/docs/composables/use-overlay'

      },

      {

        label: 'useToast',

        icon: 'i-lucide-file-text',

        description: 'Display a toast within your application.',

        to: '/docs/composables/use-toast'

      }

    ]

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    to: '/docs/components',

    active: true,

    children: [

      {

        label: 'Link',

        icon: 'i-lucide-file-text',

        description: 'Use NuxtLink with superpowers.',

        to: '/docs/components/link'

      },

      {

        label: 'Modal',

        icon: 'i-lucide-file-text',

        description: 'Display a modal within your application.',

        to: '/docs/components/modal'

      },

      {

        label: 'NavigationMenu',

        icon: 'i-lucide-file-text',

        description: 'Display a list of links.',

        to: '/docs/components/navigation-menu'

      },

      {

        label: 'Pagination',

        icon: 'i-lucide-file-text',

        description: 'Display a list of pages.',

        to: '/docs/components/pagination'

      },

      {

        label: 'Popover',

        icon: 'i-lucide-file-text',

        description: 'Display a non-modal dialog that floats around a trigger element.',

        to: '/docs/components/popover'

      },

      {

        label: 'Progress',

        icon: 'i-lucide-file-text',

        description: 'Show a horizontal bar to indicate task progression.',

        to: '/docs/components/progress'

      }

    ]

  }

])

</script>

<template>

  <UNavigationMenu trailing-icon="i-lucide-arrow-down" :items="items" class="w-full justify-center" />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.chevronDown` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.chevronDown` key.

### Arrow

Use the `arrow` prop to display an arrow on the NavigationMenu content when items have children.

```
<script setup lang="ts">

import type { NavigationMenuItem } from '@nuxt/ui'

const items = ref<NavigationMenuItem[]>([

  {

    label: 'Guide',

    icon: 'i-lucide-book-open',

    to: '/docs/getting-started',

    children: [

      {

        label: 'Introduction',

        description: 'Fully styled and customizable components for Nuxt.',

        icon: 'i-lucide-house'

      },

      {

        label: 'Installation',

        description: 'Learn how to install and configure Nuxt UI in your application.',

        icon: 'i-lucide-cloud-download'

      },

      {

        label: 'Icons',

        icon: 'i-lucide-smile',

        description: 'You have nothing to do, @nuxt/icon will handle it automatically.'

      },

      {

        label: 'Colors',

        icon: 'i-lucide-swatch-book',

        description: 'Choose a primary and a neutral color from your Tailwind CSS theme.'

      },

      {

        label: 'Theme',

        icon: 'i-lucide-cog',

        description: 'You can customize components by using the \`class\` / \`ui\` props or in your app.config.ts.'

      }

    ]

  },

  {

    label: 'Composables',

    icon: 'i-lucide-database',

    to: '/docs/composables',

    children: [

      {

        label: 'defineShortcuts',

        icon: 'i-lucide-file-text',

        description: 'Define shortcuts for your application.',

        to: '/docs/composables/define-shortcuts'

      },

      {

        label: 'useOverlay',

        icon: 'i-lucide-file-text',

        description: 'Display a modal/slideover within your application.',

        to: '/docs/composables/use-overlay'

      },

      {

        label: 'useToast',

        icon: 'i-lucide-file-text',

        description: 'Display a toast within your application.',

        to: '/docs/composables/use-toast'

      }

    ]

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    to: '/docs/components',

    active: true,

    children: [

      {

        label: 'Link',

        icon: 'i-lucide-file-text',

        description: 'Use NuxtLink with superpowers.',

        to: '/docs/components/link'

      },

      {

        label: 'Modal',

        icon: 'i-lucide-file-text',

        description: 'Display a modal within your application.',

        to: '/docs/components/modal'

      },

      {

        label: 'NavigationMenu',

        icon: 'i-lucide-file-text',

        description: 'Display a list of links.',

        to: '/docs/components/navigation-menu'

      },

      {

        label: 'Pagination',

        icon: 'i-lucide-file-text',

        description: 'Display a list of pages.',

        to: '/docs/components/pagination'

      },

      {

        label: 'Popover',

        icon: 'i-lucide-file-text',

        description: 'Display a non-modal dialog that floats around a trigger element.',

        to: '/docs/components/popover'

      },

      {

        label: 'Progress',

        icon: 'i-lucide-file-text',

        description: 'Show a horizontal bar to indicate task progression.',

        to: '/docs/components/progress'

      }

    ]

  }

])

</script>

<template>

  <UNavigationMenu arrow :items="items" class="w-full justify-center" />

</template>
```

The arrow is animated to follow the active item.

### Content Orientation

Use the `content-orientation` prop to change the orientation of the content.

This prop only works when `orientation` is `horizontal`.

```
<script setup lang="ts">

import type { NavigationMenuItem } from '@nuxt/ui'

const items = ref<NavigationMenuItem[]>([

  {

    label: 'Guide',

    icon: 'i-lucide-book-open',

    to: '/docs/getting-started',

    children: [

      {

        label: 'Introduction',

        description: 'Fully styled and customizable components for Nuxt.',

        icon: 'i-lucide-house'

      },

      {

        label: 'Installation',

        description: 'Learn how to install and configure Nuxt UI in your application.',

        icon: 'i-lucide-cloud-download'

      },

      {

        label: 'Icons',

        icon: 'i-lucide-smile',

        description: 'You have nothing to do, @nuxt/icon will handle it automatically.'

      }

    ]

  },

  {

    label: 'Composables',

    icon: 'i-lucide-database',

    to: '/docs/composables',

    children: [

      {

        label: 'defineShortcuts',

        icon: 'i-lucide-file-text',

        description: 'Define shortcuts for your application.',

        to: '/docs/composables/define-shortcuts'

      },

      {

        label: 'useOverlay',

        icon: 'i-lucide-file-text',

        description: 'Display a modal/slideover within your application.',

        to: '/docs/composables/use-overlay'

      },

      {

        label: 'useToast',

        icon: 'i-lucide-file-text',

        description: 'Display a toast within your application.',

        to: '/docs/composables/use-toast'

      }

    ]

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    to: '/docs/components',

    active: true,

    children: [

      {

        label: 'Link',

        icon: 'i-lucide-file-text',

        description: 'Use NuxtLink with superpowers.',

        to: '/docs/components/link'

      },

      {

        label: 'Modal',

        icon: 'i-lucide-file-text',

        description: 'Display a modal within your application.',

        to: '/docs/components/modal'

      },

      {

        label: 'NavigationMenu',

        icon: 'i-lucide-file-text',

        description: 'Display a list of links.',

        to: '/docs/components/navigation-menu'

      },

      {

        label: 'Pagination',

        icon: 'i-lucide-file-text',

        description: 'Display a list of pages.',

        to: '/docs/components/pagination'

      }

    ]

  }

])

</script>

<template>

  <UNavigationMenu arrow content-orientation="vertical" :items="items" class="w-full justify-center" />

</template>
```

### Unmount

Use the `unmount-on-hide` prop to control the content unmounting behavior. Defaults to `true`.

```
<script setup lang="ts">

import type { NavigationMenuItem } from '@nuxt/ui'

const items = ref<NavigationMenuItem[]>([

  {

    label: 'Guide',

    icon: 'i-lucide-book-open',

    to: '/docs/getting-started',

    children: [

      {

        label: 'Introduction',

        description: 'Fully styled and customizable components for Nuxt.',

        icon: 'i-lucide-house'

      },

      {

        label: 'Installation',

        description: 'Learn how to install and configure Nuxt UI in your application.',

        icon: 'i-lucide-cloud-download'

      },

      {

        label: 'Icons',

        icon: 'i-lucide-smile',

        description: 'You have nothing to do, @nuxt/icon will handle it automatically.'

      },

      {

        label: 'Colors',

        icon: 'i-lucide-swatch-book',

        description: 'Choose a primary and a neutral color from your Tailwind CSS theme.'

      },

      {

        label: 'Theme',

        icon: 'i-lucide-cog',

        description: 'You can customize components by using the \`class\` / \`ui\` props or in your app.config.ts.'

      }

    ]

  },

  {

    label: 'Composables',

    icon: 'i-lucide-database',

    to: '/docs/composables',

    children: [

      {

        label: 'defineShortcuts',

        icon: 'i-lucide-file-text',

        description: 'Define shortcuts for your application.',

        to: '/docs/composables/define-shortcuts'

      },

      {

        label: 'useOverlay',

        icon: 'i-lucide-file-text',

        description: 'Display a modal/slideover within your application.',

        to: '/docs/composables/use-overlay'

      },

      {

        label: 'useToast',

        icon: 'i-lucide-file-text',

        description: 'Display a toast within your application.',

        to: '/docs/composables/use-toast'

      }

    ]

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    to: '/docs/components',

    active: true,

    children: [

      {

        label: 'Link',

        icon: 'i-lucide-file-text',

        description: 'Use NuxtLink with superpowers.',

        to: '/docs/components/link'

      },

      {

        label: 'Modal',

        icon: 'i-lucide-file-text',

        description: 'Display a modal within your application.',

        to: '/docs/components/modal'

      },

      {

        label: 'NavigationMenu',

        icon: 'i-lucide-file-text',

        description: 'Display a list of links.',

        to: '/docs/components/navigation-menu'

      },

      {

        label: 'Pagination',

        icon: 'i-lucide-file-text',

        description: 'Display a list of pages.',

        to: '/docs/components/pagination'

      },

      {

        label: 'Popover',

        icon: 'i-lucide-file-text',

        description: 'Display a non-modal dialog that floats around a trigger element.',

        to: '/docs/components/popover'

      },

      {

        label: 'Progress',

        icon: 'i-lucide-file-text',

        description: 'Show a horizontal bar to indicate task progression.',

        to: '/docs/components/progress'

      }

    ]

  }

])

</script>

<template>

  <UNavigationMenu :unmount-on-hide="false" :items="items" class="w-full justify-center" />

</template>
```

You can inspect the DOM to see each item's content being rendered.

## Examples

When orientation is `vertical` and the menu is `collapsed`, you can set the `tooltip` prop to `true` to display a [Tooltip](https://ui.nuxt.com/docs/components/tooltip) around items with their label but you can also use the `tooltip` property on each item to override the default tooltip.

You can pass any property from the [Tooltip](https://ui.nuxt.com/docs/components/tooltip) component globally or on each item.

```
<script setup lang="ts">

import type { NavigationMenuItem } from '@nuxt/ui'

const items = ref<NavigationMenuItem[][]>([

  [

    {

      label: 'Links',

      type: 'label'

    },

    {

      label: 'Guide',

      icon: 'i-lucide-book-open',

      children: [

        {

          label: 'Introduction',

          description: 'Fully styled and customizable components for Nuxt.',

          icon: 'i-lucide-house'

        },

        {

          label: 'Installation',

          description: 'Learn how to install and configure Nuxt UI in your application.',

          icon: 'i-lucide-cloud-download'

        },

        {

          label: 'Icons',

          icon: 'i-lucide-smile',

          description: 'You have nothing to do, @nuxt/icon will handle it automatically.'

        },

        {

          label: 'Colors',

          icon: 'i-lucide-swatch-book',

          description: 'Choose a primary and a neutral color from your Tailwind CSS theme.'

        },

        {

          label: 'Theme',

          icon: 'i-lucide-cog',

          description: 'You can customize components by using the \`class\` / \`ui\` props or in your app.config.ts.'

        }

      ]

    },

    {

      label: 'Composables',

      icon: 'i-lucide-database',

      children: [

        {

          label: 'defineShortcuts',

          icon: 'i-lucide-file-text',

          description: 'Define shortcuts for your application.',

          to: '/docs/composables/define-shortcuts'

        },

        {

          label: 'useOverlay',

          icon: 'i-lucide-file-text',

          description: 'Display a modal/slideover within your application.',

          to: '/docs/composables/use-overlay'

        },

        {

          label: 'useToast',

          icon: 'i-lucide-file-text',

          description: 'Display a toast within your application.',

          to: '/docs/composables/use-toast'

        }

      ]

    },

    {

      label: 'Components',

      icon: 'i-lucide-box',

      to: '/docs/components',

      active: true,

      children: [

        {

          label: 'Link',

          icon: 'i-lucide-file-text',

          description: 'Use NuxtLink with superpowers.',

          to: '/docs/components/link'

        },

        {

          label: 'Modal',

          icon: 'i-lucide-file-text',

          description: 'Display a modal within your application.',

          to: '/docs/components/modal'

        },

        {

          label: 'NavigationMenu',

          icon: 'i-lucide-file-text',

          description: 'Display a list of links.',

          to: '/docs/components/navigation-menu'

        },

        {

          label: 'Pagination',

          icon: 'i-lucide-file-text',

          description: 'Display a list of pages.',

          to: '/docs/components/pagination'

        },

        {

          label: 'Popover',

          icon: 'i-lucide-file-text',

          description: 'Display a non-modal dialog that floats around a trigger element.',

          to: '/docs/components/popover'

        },

        {

          label: 'Progress',

          icon: 'i-lucide-file-text',

          description: 'Show a horizontal bar to indicate task progression.',

          to: '/docs/components/progress'

        }

      ]

    }

  ],

  [

    {

      label: 'GitHub',

      icon: 'i-simple-icons-github',

      badge: '6k',

      to: 'https://github.com/nuxt/ui',

      target: '_blank',

      tooltip: {

        text: 'Open on GitHub',

        kbds: [

          '6k'

        ]

      }

    },

    {

      label: 'Help',

      icon: 'i-lucide-circle-help',

      disabled: true

    }

  ]

])

</script>

<template>

  <UNavigationMenu tooltip collapsed orientation="vertical" :items="items" />

</template>
```

### With popover in items

When orientation is `vertical` and the menu is `collapsed`, you can set the `popover` prop to `true` to display a [Popover](https://ui.nuxt.com/docs/components/popover) around items with their children but you can also use the `popover` property on each item to override the default popover.

You can pass any property from the [Popover](https://ui.nuxt.com/docs/components/popover) component globally or on each item.

```
<script setup lang="ts">

import type { NavigationMenuItem } from '@nuxt/ui'

const items = ref<NavigationMenuItem[][]>([

  [

    {

      label: 'Links',

      type: 'label'

    },

    {

      label: 'Guide',

      icon: 'i-lucide-book-open',

      children: [

        {

          label: 'Introduction',

          description: 'Fully styled and customizable components for Nuxt.',

          icon: 'i-lucide-house'

        },

        {

          label: 'Installation',

          description: 'Learn how to install and configure Nuxt UI in your application.',

          icon: 'i-lucide-cloud-download'

        },

        {

          label: 'Icons',

          icon: 'i-lucide-smile',

          description: 'You have nothing to do, @nuxt/icon will handle it automatically.'

        },

        {

          label: 'Colors',

          icon: 'i-lucide-swatch-book',

          description: 'Choose a primary and a neutral color from your Tailwind CSS theme.'

        },

        {

          label: 'Theme',

          icon: 'i-lucide-cog',

          description: 'You can customize components by using the \`class\` / \`ui\` props or in your app.config.ts.'

        }

      ]

    },

    {

      label: 'Composables',

      icon: 'i-lucide-database',

      popover: {

        mode: 'click'

      },

      children: [

        {

          label: 'defineShortcuts',

          icon: 'i-lucide-file-text',

          description: 'Define shortcuts for your application.',

          to: '/docs/composables/define-shortcuts'

        },

        {

          label: 'useOverlay',

          icon: 'i-lucide-file-text',

          description: 'Display a modal/slideover within your application.',

          to: '/docs/composables/use-overlay'

        },

        {

          label: 'useToast',

          icon: 'i-lucide-file-text',

          description: 'Display a toast within your application.',

          to: '/docs/composables/use-toast'

        }

      ]

    },

    {

      label: 'Components',

      icon: 'i-lucide-box',

      to: '/docs/components',

      active: true,

      children: [

        {

          label: 'Link',

          icon: 'i-lucide-file-text',

          description: 'Use NuxtLink with superpowers.',

          to: '/docs/components/link'

        },

        {

          label: 'Modal',

          icon: 'i-lucide-file-text',

          description: 'Display a modal within your application.',

          to: '/docs/components/modal'

        },

        {

          label: 'NavigationMenu',

          icon: 'i-lucide-file-text',

          description: 'Display a list of links.',

          to: '/docs/components/navigation-menu'

        },

        {

          label: 'Pagination',

          icon: 'i-lucide-file-text',

          description: 'Display a list of pages.',

          to: '/docs/components/pagination'

        },

        {

          label: 'Popover',

          icon: 'i-lucide-file-text',

          description: 'Display a non-modal dialog that floats around a trigger element.',

          to: '/docs/components/popover'

        },

        {

          label: 'Progress',

          icon: 'i-lucide-file-text',

          description: 'Show a horizontal bar to indicate task progression.',

          to: '/docs/components/progress'

        }

      ]

    }

  ],

  [

    {

      label: 'GitHub',

      icon: 'i-simple-icons-github',

      badge: '6k',

      to: 'https://github.com/nuxt/ui',

      target: '_blank',

      tooltip: {

        text: 'Open on GitHub',

        kbds: [

          '6k'

        ]

      }

    },

    {

      label: 'Help',

      icon: 'i-lucide-circle-help',

      disabled: true

    }

  ]

])

</script>

<template>

  <UNavigationMenu popover collapsed orientation="vertical" :items="items" />

</template>
```

You can use the `#content` slot to customize the content of the popover in the `vertical` orientation.

### Control active item

You can control the active item(s) by using the `default-value` prop or the `v-model` directive with the `value` of the item. If no `value` is provided, it defaults to `item-${index}` for top-level items or `item-${level}-${index}` for nested items.

```
<script setup lang="ts">

import type { NavigationMenuItem } from '@nuxt/ui'

const items: NavigationMenuItem[] = [

  {

    label: 'Guide',

    icon: 'i-lucide-book-open',

    children: [

      {

        label: 'Introduction',

        description: 'Fully styled and customizable components for Nuxt.',

        icon: 'i-lucide-house'

      },

      {

        label: 'Installation',

        description: 'Learn how to install and configure Nuxt UI in your application.',

        icon: 'i-lucide-cloud-download'

      },

      {

        label: 'Icons',

        icon: 'i-lucide-smile',

        description: 'You have nothing to do, @nuxt/icon will handle it automatically.'

      },

      {

        label: 'Colors',

        icon: 'i-lucide-swatch-book',

        description: 'Choose a primary and a neutral color from your Tailwind CSS theme.'

      },

      {

        label: 'Theme',

        icon: 'i-lucide-cog',

        description: 'You can customize components by using the \`class\` / \`ui\` props or in your app.config.ts.'

      }

    ]

  },

  {

    label: 'Composables',

    icon: 'i-lucide-database',

    children: [

      {

        label: 'defineShortcuts',

        icon: 'i-lucide-file-text',

        description: 'Define shortcuts for your application.'

      },

      {

        label: 'useOverlay',

        icon: 'i-lucide-file-text',

        description: 'Display a modal/slideover within your application.'

      },

      {

        label: 'useToast',

        icon: 'i-lucide-file-text',

        description: 'Display a toast within your application.'

      }

    ]

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    children: [

      {

        label: 'Link',

        icon: 'i-lucide-file-text',

        description: 'Use NuxtLink with superpowers.'

      },

      {

        label: 'Modal',

        icon: 'i-lucide-file-text',

        description: 'Display a modal within your application.'

      },

      {

        label: 'NavigationMenu',

        icon: 'i-lucide-file-text',

        description: 'Display a list of links.'

      },

      {

        label: 'Pagination',

        icon: 'i-lucide-file-text',

        description: 'Display a list of pages.'

      },

      {

        label: 'Popover',

        icon: 'i-lucide-file-text',

        description: 'Display a non-modal dialog that floats around a trigger element.'

      },

      {

        label: 'Progress',

        icon: 'i-lucide-file-text',

        description: 'Show a horizontal bar to indicate task progression.'

      }

    ]

  }

]

const active = ref()

defineShortcuts({

  1: () => {

    active.value = 'item-0'

  },

  2: () => {

    active.value = 'item-1'

  },

  3: () => {

    active.value = 'item-2'

  }

})

</script>

<template>

  <UNavigationMenu v-model="active" :items="items" class="w-full justify-center" />

</template>
```

Use the `value-key` prop to change the key used to match items when a `v-model` or `default-value` is provided.

In this example, leveraging [`defineShortcuts`](https://ui.nuxt.com/docs/composables/define-shortcuts), you can switch the active item by pressing 1, 2, or 3.

### With custom slot

Use the `slot` property to customize a specific item.

You will have access to the following slots:

- `#{{ item.slot }}`
- `#{{ item.slot }}-leading`
- `#{{ item.slot }}-label`
- `#{{ item.slot }}-trailing`
- `#{{ item.slot }}-content`

```
<script setup lang="ts">

import type { NavigationMenuItem, DropdownMenuItem } from '@nuxt/ui'

const items = [

  {

    label: 'Guide',

    icon: 'i-lucide-book-open',

    to: '/docs/getting-started'

  },

  {

    label: 'Composables',

    icon: 'i-lucide-database',

    to: '/docs/composables',

    class: 'hidden'

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    to: '/docs/components',

    class: 'hidden'

  },

  {

    slot: 'more' as const,

    as: 'span',

    class: 'p-0',

    content: {

      align: 'start' as const

    },

    items: [

      {

        label: 'Composables',

        icon: 'i-lucide-database',

        to: '/docs/composables'

      },

      {

        label: 'Components',

        icon: 'i-lucide-box',

        to: '/docs/components'

      }

    ] satisfies DropdownMenuItem[]

  },

  {

    label: 'GitHub',

    icon: 'i-simple-icons-github',

    to: 'https://github.com/nuxt/ui',

    target: '_blank',

    slot: 'github' as const

  }

] satisfies NavigationMenuItem[]

</script>

<template>

  <UNavigationMenu :items="items" class="w-full justify-center">

    <template #more="{ item }">

      <UDropdownMenu :content="item.content" :items="item.items">

        <UButton icon="i-lucide-ellipsis" color="neutral" variant="link" />

      </UDropdownMenu>

    </template>

    <template #github-trailing>

      <UBadge label="6k+" color="neutral" variant="subtle" size="sm" />

    </template>

  </UNavigationMenu>

</template>
```

You can also use the `#item`, `#item-leading`, `#item-label`, `#item-trailing` and `#item-content` slots to customize all items.

### With content slot

Use the `#item-content` slot or the `slot` property (`#{{ item.slot }}-content`) to customize the content of a specific item.

```
<script setup lang="ts">

import type { NavigationMenuItem } from '@nuxt/ui'

const items = [

  {

    label: 'Docs',

    icon: 'i-lucide-book-open',

    slot: 'docs' as const,

    children: [

      {

        label: 'Icons',

        description: 'You have nothing to do, @nuxt/icon will handle it automatically.'

      },

      {

        label: 'Colors',

        description: 'Choose a primary and a neutral color from your Tailwind CSS theme.'

      },

      {

        label: 'Theme',

        description: 'You can customize components by using the \`class\` / \`ui\` props or in your app.config.ts.'

      }

    ]

  },

  {

    label: 'Components',

    icon: 'i-lucide-box',

    slot: 'components' as const,

    children: [

      {

        label: 'Link',

        description: 'Use NuxtLink with superpowers.'

      },

      {

        label: 'Modal',

        description: 'Display a modal within your application.'

      },

      {

        label: 'NavigationMenu',

        description: 'Display a list of links.'

      },

      {

        label: 'Pagination',

        description: 'Display a list of pages.'

      },

      {

        label: 'Popover',

        description: 'Display a non-modal dialog that floats around a trigger element.'

      },

      {

        label: 'Progress',

        description: 'Show a horizontal bar to indicate task progression.'

      }

    ]

  },

  {

    label: 'GitHub',

    icon: 'i-simple-icons-github'

  }

] satisfies NavigationMenuItem[]

</script>

<template>

  <UNavigationMenu

    :items="items"

    :ui="{

      viewport: 'sm:w-(--reka-navigation-menu-viewport-width)',

      content: 'sm:w-auto',

      childList: 'sm:w-96',

      childLinkDescription: 'text-balance line-clamp-2'

    }"

    class="w-full justify-center"

  >

    <template #docs-content="{ item }">

      <ul class="grid gap-2 p-4 lg:w-[500px] lg:grid-cols-[minmax(0,.75fr)_minmax(0,1fr)]">

        <li class="row-span-3">

          <Placeholder class="size-full min-h-48" />

        </li>

        <li v-for="child in item.children" :key="child.label">

          <ULink class="text-sm text-left rounded-md p-3 transition-colors hover:bg-elevated/50">

            <p class="font-medium text-highlighted">

              {{ child.label }}

            </p>

            <p class="text-muted line-clamp-2">

              {{ child.description }}

            </p>

          </ULink>

        </li>

      </ul>

    </template>

  </UNavigationMenu>

</template>
```

In this example, we add the `sm:w-(--reka-navigation-menu-viewport-width)` class on the `viewport` to have a dynamic width. This requires to set a width on the content's first child.

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `type` | `'multiple'` | ` K`  Determines whether a "single" or "multiple" items can be selected at a time.  Only works when `orientation` is `vertical`. |
| `modelValue` |  | ` NavigationMenuModelValue<K, O>`  The controlled value of the active item(s).  - In horizontal orientation: always `string` - In vertical orientation with `type="single"`: `string` - In vertical orientation with `type="multiple"`: `string[]`  Use this when you need to control the state of the items. Can be binded with `v-model` |
| `defaultValue` |  | ` NavigationMenuModelValue<K, O>`  The default active value of the item(s).  - In horizontal orientation: always `string` - In vertical orientation with `type="single"`: `string` - In vertical orientation with `type="multiple"`: `string[]`  Use when you do not need to control the state of the item(s). |
| `trailingIcon` | `appConfig.ui.icons.chevronDown` | `any` |
| `externalIcon` | `true` | `any`  The icon displayed when the item is an external link. Set to `false` to hide the external icon. |
| `items` |  | ` T` |
| `color` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `variant` | `'pill'` | ` "pill" \| "link"` |
| `orientation` | `'horizontal'` | ` O` |
| `collapsed` | `false` | `boolean` |
| `tooltip` | `false` | `boolean \| TooltipProps`  Display a tooltip on the items when the menu is collapsed with the label of the item.`{ delayDuration: 0, content: { side: 'right' } }` |
| `popover` | `false` | `boolean \| PopoverProps<PopoverMode>`  Display a popover on the items when the menu is collapsed with the children list.`{ mode: 'hover', content: { side: 'right', align: 'start', alignOffset: 2 } }` |
| `highlight` |  | `boolean`  Display a line next to the active item. |
| `highlightColor` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `content` |  | ` NavigationMenuContentProps & Partial<EmitsToProps<DismissableLayerEmits>>` |
| `contentOrientation` | `'horizontal'` | ` "horizontal" \| "vertical"`  The orientation of the content. Only works when `orientation` is `horizontal`. |
| `arrow` | `false` | `boolean` |
| `valueKey` | `'value'` | ` keyof Extract<NestedItem<T>, object> \| DotPathKeys<Extract<NestedItem<T>, object>>`  The key used to get the value from the item. |
| `labelKey` | `'label'` | ` keyof Extract<NestedItem<T>, object> \| DotPathKeys<Extract<NestedItem<T>, object>>`  The key used to get the label from the item. |
| `delayDuration` | `0` | ` number`  The duration from when the pointer enters the trigger until the tooltip gets opened. |
| `disableClickTrigger` | `false` | `boolean` |
| `disableHoverTrigger` | `false` | `boolean` |
| `skipDelayDuration` | `300` | ` number`  How much time a user has to enter another trigger without incurring a delay again. |
| `disablePointerLeaveClose` | `false` | `boolean` |
| `unmountOnHide` | `true` | `boolean`  When `true`, the element will be unmounted on closed state. |
| `disabled` | `false` | `boolean`  When `true`, prevents the user from interacting with the accordion and all its items |
| `collapsible` | `true` | `boolean`  When type is "single", allows closing content when clicking trigger for an open item. When type is "multiple", this prop has no effect. |
| `ui` |  | ` { root?: ClassNameValue; list?: ClassNameValue; label?: ClassNameValue; item?: ClassNameValue; link?: ClassNameValue; linkLeadingIcon?: ClassNameValue; linkLeadingAvatar?: ClassNameValue; linkLeadingAvatarSize?: ClassNameValue; linkTrailing?: ClassNameValue; linkTrailingBadge?: ClassNameValue; linkTrailingBadgeSize?: ClassNameValue; linkTrailingIcon?: ClassNameValue; linkLabel?: ClassNameValue; linkLabelExternalIcon?: ClassNameValue; childList?: ClassNameValue; childLabel?: ClassNameValue; childItem?: ClassNameValue; childLink?: ClassNameValue; childLinkWrapper?: ClassNameValue; childLinkIcon?: ClassNameValue; childLinkLabel?: ClassNameValue; childLinkLabelExternalIcon?: ClassNameValue; childLinkDescription?: ClassNameValue; separator?: ClassNameValue; viewportWrapper?: ClassNameValue; viewport?: ClassNameValue; content?: ClassNameValue; indicator?: ClassNameValue; arrow?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `item` | `{ item: NestedItem<T>; index: number; active?: boolean \| undefined; ui: object; }` |
| `item-leading` | `{ item: NestedItem<T>; index: number; active?: boolean \| undefined; ui: object; }` |
| `item-label` | `{ item: NestedItem<T>; index: number; active?: boolean \| undefined; }` |
| `item-trailing` | `{ item: NestedItem<T>; index: number; active?: boolean \| undefined; ui: object; }` |
| `item-content` | `{ item: NestedItem<T>; index: number; active?: boolean \| undefined; ui: object; }` |
| `list-leading` | `{}` |
| `list-trailing` | `{}` |

### Emits

| Event | Type |
| --- | --- |
| `update:modelValue` | `[value: NavigationMenuModelValue<K, O> \| undefined]` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    navigationMenu: {

      slots: {

        root: 'relative flex gap-1.5 [&>div]:min-w-0',

        list: 'isolate min-w-0',

        label: 'w-full flex items-center gap-1.5 font-semibold text-xs/5 text-highlighted px-2.5 py-1.5',

        item: 'min-w-0',

        link: 'group relative w-full flex items-center gap-1.5 font-medium text-sm before:absolute before:z-[-1] before:rounded-md focus:outline-none focus-visible:outline-none dark:focus-visible:outline-none focus-visible:before:ring-inset focus-visible:before:ring-2',

        linkLeadingIcon: 'shrink-0 size-5',

        linkLeadingAvatar: 'shrink-0',

        linkLeadingAvatarSize: '2xs',

        linkTrailing: 'group ms-auto inline-flex gap-1.5 items-center',

        linkTrailingBadge: 'shrink-0',

        linkTrailingBadgeSize: 'sm',

        linkTrailingIcon: 'size-5 transform shrink-0 group-data-[state=open]:rotate-180 transition-transform duration-200',

        linkLabel: 'truncate',

        linkLabelExternalIcon: 'inline-block size-3 align-top text-dimmed',

        childList: 'isolate',

        childLabel: 'text-xs text-highlighted',

        childItem: '',

        childLink: 'group relative size-full flex items-start text-start text-sm before:absolute before:z-[-1] before:rounded-md focus:outline-none focus-visible:outline-none dark:focus-visible:outline-none focus-visible:before:ring-inset focus-visible:before:ring-2',

        childLinkWrapper: 'min-w-0',

        childLinkIcon: 'size-5 shrink-0',

        childLinkLabel: 'truncate',

        childLinkLabelExternalIcon: 'inline-block size-3 align-top text-dimmed',

        childLinkDescription: 'text-muted',

        separator: 'px-2 h-px bg-border',

        viewportWrapper: 'absolute top-full left-0 flex w-full',

        viewport: 'relative overflow-hidden bg-default shadow-lg rounded-md ring ring-default h-(--reka-navigation-menu-viewport-height) w-full transition-[width,height,left] duration-200 origin-[top_center] data-[state=open]:animate-[scale-in_100ms_ease-out] data-[state=closed]:animate-[scale-out_100ms_ease-in] z-[1]',

        content: '',

        indicator: 'absolute data-[state=visible]:animate-[fade-in_100ms_ease-out] data-[state=hidden]:animate-[fade-out_100ms_ease-in] data-[state=hidden]:opacity-0 bottom-0 z-[2] w-(--reka-navigation-menu-indicator-size) translate-x-(--reka-navigation-menu-indicator-position) flex h-2.5 items-end justify-center overflow-hidden transition-[translate,width] duration-200',

        arrow: 'relative top-[50%] size-2.5 rotate-45 border border-default bg-default z-[1] rounded-xs'

      },

      variants: {

        color: {

          primary: {

            link: 'focus-visible:before:ring-primary',

            childLink: 'focus-visible:before:ring-primary'

          },

          secondary: {

            link: 'focus-visible:before:ring-secondary',

            childLink: 'focus-visible:before:ring-secondary'

          },

          success: {

            link: 'focus-visible:before:ring-success',

            childLink: 'focus-visible:before:ring-success'

          },

          info: {

            link: 'focus-visible:before:ring-info',

            childLink: 'focus-visible:before:ring-info'

          },

          warning: {

            link: 'focus-visible:before:ring-warning',

            childLink: 'focus-visible:before:ring-warning'

          },

          error: {

            link: 'focus-visible:before:ring-error',

            childLink: 'focus-visible:before:ring-error'

          },

          neutral: {

            link: 'focus-visible:before:ring-inverted',

            childLink: 'focus-visible:before:ring-inverted'

          }

        },

        highlightColor: {

          primary: '',

          secondary: '',

          success: '',

          info: '',

          warning: '',

          error: '',

          neutral: ''

        },

        variant: {

          pill: '',

          link: ''

        },

        orientation: {

          horizontal: {

            root: 'items-center justify-between',

            list: 'flex items-center',

            item: 'py-2',

            link: 'px-2.5 py-1.5 before:inset-x-px before:inset-y-0',

            childList: 'grid p-2',

            childLink: 'px-3 py-2 gap-2 before:inset-x-px before:inset-y-0',

            childLinkLabel: 'font-medium',

            content: 'absolute top-0 left-0 w-full max-h-[70vh] overflow-y-auto'

          },

          vertical: {

            root: 'flex-col',

            link: 'flex-row px-2.5 py-1.5 before:inset-y-px before:inset-x-0',

            childLabel: 'px-1.5 py-0.5',

            childLink: 'p-1.5 gap-1.5 before:inset-y-px before:inset-x-0'

          }

        },

        contentOrientation: {

          horizontal: {

            viewportWrapper: 'justify-center',

            content: 'data-[motion=from-start]:animate-[enter-from-left_200ms_ease] data-[motion=from-end]:animate-[enter-from-right_200ms_ease] data-[motion=to-start]:animate-[exit-to-left_200ms_ease] data-[motion=to-end]:animate-[exit-to-right_200ms_ease]'

          },

          vertical: {

            viewport: 'sm:w-(--reka-navigation-menu-viewport-width) left-(--reka-navigation-menu-viewport-left)'

          }

        },

        active: {

          true: {

            childLink: 'before:bg-elevated text-highlighted',

            childLinkIcon: 'text-default'

          },

          false: {

            link: 'text-muted',

            linkLeadingIcon: 'text-dimmed',

            childLink: [

              'hover:before:bg-elevated/50 text-default hover:text-highlighted',

              'transition-colors before:transition-colors'

            ],

            childLinkIcon: [

              'text-dimmed group-hover:text-default',

              'transition-colors'

            ]

          }

        },

        disabled: {

          true: {

            link: 'cursor-not-allowed opacity-75'

          }

        },

        highlight: {

          true: ''

        },

        level: {

          true: ''

        },

        collapsed: {

          true: ''

        }

      },

      compoundVariants: [

        {

          orientation: 'horizontal',

          contentOrientation: 'horizontal',

          class: {

            childList: 'grid-cols-2 gap-2'

          }

        },

        {

          orientation: 'horizontal',

          contentOrientation: 'vertical',

          class: {

            childList: 'gap-1',

            content: 'w-60'

          }

        },

        {

          orientation: 'vertical',

          collapsed: false,

          class: {

            childList: 'ms-5 border-s border-default',

            childItem: 'ps-1.5 -ms-px',

            content: 'data-[state=open]:animate-[collapsible-down_200ms_ease-out] data-[state=closed]:animate-[collapsible-up_200ms_ease-out] overflow-hidden'

          }

        },

        {

          orientation: 'vertical',

          collapsed: true,

          class: {

            link: 'px-1.5',

            linkLabel: 'hidden',

            linkTrailing: 'hidden',

            content: 'shadow-sm rounded-sm min-h-6 p-1'

          }

        },

        {

          orientation: 'horizontal',

          highlight: true,

          class: {

            link: [

              'after:absolute after:-bottom-2 after:inset-x-2.5 after:block after:h-px after:rounded-full',

              'after:transition-colors'

            ]

          }

        },

        {

          orientation: 'vertical',

          highlight: true,

          level: true,

          class: {

            link: [

              'after:absolute after:-start-1.5 after:inset-y-0.5 after:block after:w-px after:rounded-full',

              'after:transition-colors'

            ]

          }

        },

        {

          disabled: false,

          active: false,

          variant: 'pill',

          class: {

            link: [

              'hover:text-highlighted hover:before:bg-elevated/50',

              'transition-colors before:transition-colors'

            ],

            linkLeadingIcon: [

              'group-hover:text-default',

              'transition-colors'

            ]

          }

        },

        {

          disabled: false,

          active: false,

          variant: 'pill',

          orientation: 'horizontal',

          class: {

            link: 'data-[state=open]:text-highlighted',

            linkLeadingIcon: 'group-data-[state=open]:text-default'

          }

        },

        {

          disabled: false,

          variant: 'pill',

          highlight: true,

          orientation: 'horizontal',

          class: {

            link: 'data-[state=open]:before:bg-elevated/50'

          }

        },

        {

          disabled: false,

          variant: 'pill',

          highlight: false,

          active: false,

          orientation: 'horizontal',

          class: {

            link: 'data-[state=open]:before:bg-elevated/50'

          }

        },

        {

          color: 'primary',

          variant: 'pill',

          active: true,

          class: {

            link: 'text-primary',

            linkLeadingIcon: 'text-primary group-data-[state=open]:text-primary'

          }

        },

        {

          color: 'neutral',

          variant: 'pill',

          active: true,

          class: {

            link: 'text-highlighted',

            linkLeadingIcon: 'text-highlighted group-data-[state=open]:text-highlighted'

          }

        },

        {

          variant: 'pill',

          active: true,

          highlight: false,

          class: {

            link: 'before:bg-elevated'

          }

        },

        {

          variant: 'pill',

          active: true,

          highlight: true,

          disabled: false,

          class: {

            link: [

              'hover:before:bg-elevated/50',

              'before:transition-colors'

            ]

          }

        },

        {

          disabled: false,

          active: false,

          variant: 'link',

          class: {

            link: [

              'hover:text-highlighted',

              'transition-colors'

            ],

            linkLeadingIcon: [

              'group-hover:text-default',

              'transition-colors'

            ]

          }

        },

        {

          disabled: false,

          active: false,

          variant: 'link',

          orientation: 'horizontal',

          class: {

            link: 'data-[state=open]:text-highlighted',

            linkLeadingIcon: 'group-data-[state=open]:text-default'

          }

        },

        {

          color: 'primary',

          variant: 'link',

          active: true,

          class: {

            link: 'text-primary',

            linkLeadingIcon: 'text-primary group-data-[state=open]:text-primary'

          }

        },

        {

          color: 'neutral',

          variant: 'link',

          active: true,

          class: {

            link: 'text-highlighted',

            linkLeadingIcon: 'text-highlighted group-data-[state=open]:text-highlighted'

          }

        },

        {

          highlightColor: 'primary',

          highlight: true,

          level: true,

          active: true,

          class: {

            link: 'after:bg-primary'

          }

        },

        {

          highlightColor: 'neutral',

          highlight: true,

          level: true,

          active: true,

          class: {

            link: 'after:bg-inverted'

          }

        }

      ],

      defaultVariants: {

        color: 'primary',

        highlightColor: 'primary',

        variant: 'pill'

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

        navigationMenu: {

          slots: {

            root: 'relative flex gap-1.5 [&>div]:min-w-0',

            list: 'isolate min-w-0',

            label: 'w-full flex items-center gap-1.5 font-semibold text-xs/5 text-highlighted px-2.5 py-1.5',

            item: 'min-w-0',

            link: 'group relative w-full flex items-center gap-1.5 font-medium text-sm before:absolute before:z-[-1] before:rounded-md focus:outline-none focus-visible:outline-none dark:focus-visible:outline-none focus-visible:before:ring-inset focus-visible:before:ring-2',

            linkLeadingIcon: 'shrink-0 size-5',

            linkLeadingAvatar: 'shrink-0',

            linkLeadingAvatarSize: '2xs',

            linkTrailing: 'group ms-auto inline-flex gap-1.5 items-center',

            linkTrailingBadge: 'shrink-0',

            linkTrailingBadgeSize: 'sm',

            linkTrailingIcon: 'size-5 transform shrink-0 group-data-[state=open]:rotate-180 transition-transform duration-200',

            linkLabel: 'truncate',

            linkLabelExternalIcon: 'inline-block size-3 align-top text-dimmed',

            childList: 'isolate',

            childLabel: 'text-xs text-highlighted',

            childItem: '',

            childLink: 'group relative size-full flex items-start text-start text-sm before:absolute before:z-[-1] before:rounded-md focus:outline-none focus-visible:outline-none dark:focus-visible:outline-none focus-visible:before:ring-inset focus-visible:before:ring-2',

            childLinkWrapper: 'min-w-0',

            childLinkIcon: 'size-5 shrink-0',

            childLinkLabel: 'truncate',

            childLinkLabelExternalIcon: 'inline-block size-3 align-top text-dimmed',

            childLinkDescription: 'text-muted',

            separator: 'px-2 h-px bg-border',

            viewportWrapper: 'absolute top-full left-0 flex w-full',

            viewport: 'relative overflow-hidden bg-default shadow-lg rounded-md ring ring-default h-(--reka-navigation-menu-viewport-height) w-full transition-[width,height,left] duration-200 origin-[top_center] data-[state=open]:animate-[scale-in_100ms_ease-out] data-[state=closed]:animate-[scale-out_100ms_ease-in] z-[1]',

            content: '',

            indicator: 'absolute data-[state=visible]:animate-[fade-in_100ms_ease-out] data-[state=hidden]:animate-[fade-out_100ms_ease-in] data-[state=hidden]:opacity-0 bottom-0 z-[2] w-(--reka-navigation-menu-indicator-size) translate-x-(--reka-navigation-menu-indicator-position) flex h-2.5 items-end justify-center overflow-hidden transition-[translate,width] duration-200',

            arrow: 'relative top-[50%] size-2.5 rotate-45 border border-default bg-default z-[1] rounded-xs'

          },

          variants: {

            color: {

              primary: {

                link: 'focus-visible:before:ring-primary',

                childLink: 'focus-visible:before:ring-primary'

              },

              secondary: {

                link: 'focus-visible:before:ring-secondary',

                childLink: 'focus-visible:before:ring-secondary'

              },

              success: {

                link: 'focus-visible:before:ring-success',

                childLink: 'focus-visible:before:ring-success'

              },

              info: {

                link: 'focus-visible:before:ring-info',

                childLink: 'focus-visible:before:ring-info'

              },

              warning: {

                link: 'focus-visible:before:ring-warning',

                childLink: 'focus-visible:before:ring-warning'

              },

              error: {

                link: 'focus-visible:before:ring-error',

                childLink: 'focus-visible:before:ring-error'

              },

              neutral: {

                link: 'focus-visible:before:ring-inverted',

                childLink: 'focus-visible:before:ring-inverted'

              }

            },

            highlightColor: {

              primary: '',

              secondary: '',

              success: '',

              info: '',

              warning: '',

              error: '',

              neutral: ''

            },

            variant: {

              pill: '',

              link: ''

            },

            orientation: {

              horizontal: {

                root: 'items-center justify-between',

                list: 'flex items-center',

                item: 'py-2',

                link: 'px-2.5 py-1.5 before:inset-x-px before:inset-y-0',

                childList: 'grid p-2',

                childLink: 'px-3 py-2 gap-2 before:inset-x-px before:inset-y-0',

                childLinkLabel: 'font-medium',

                content: 'absolute top-0 left-0 w-full max-h-[70vh] overflow-y-auto'

              },

              vertical: {

                root: 'flex-col',

                link: 'flex-row px-2.5 py-1.5 before:inset-y-px before:inset-x-0',

                childLabel: 'px-1.5 py-0.5',

                childLink: 'p-1.5 gap-1.5 before:inset-y-px before:inset-x-0'

              }

            },

            contentOrientation: {

              horizontal: {

                viewportWrapper: 'justify-center',

                content: 'data-[motion=from-start]:animate-[enter-from-left_200ms_ease] data-[motion=from-end]:animate-[enter-from-right_200ms_ease] data-[motion=to-start]:animate-[exit-to-left_200ms_ease] data-[motion=to-end]:animate-[exit-to-right_200ms_ease]'

              },

              vertical: {

                viewport: 'sm:w-(--reka-navigation-menu-viewport-width) left-(--reka-navigation-menu-viewport-left)'

              }

            },

            active: {

              true: {

                childLink: 'before:bg-elevated text-highlighted',

                childLinkIcon: 'text-default'

              },

              false: {

                link: 'text-muted',

                linkLeadingIcon: 'text-dimmed',

                childLink: [

                  'hover:before:bg-elevated/50 text-default hover:text-highlighted',

                  'transition-colors before:transition-colors'

                ],

                childLinkIcon: [

                  'text-dimmed group-hover:text-default',

                  'transition-colors'

                ]

              }

            },

            disabled: {

              true: {

                link: 'cursor-not-allowed opacity-75'

              }

            },

            highlight: {

              true: ''

            },

            level: {

              true: ''

            },

            collapsed: {

              true: ''

            }

          },

          compoundVariants: [

            {

              orientation: 'horizontal',

              contentOrientation: 'horizontal',

              class: {

                childList: 'grid-cols-2 gap-2'

              }

            },

            {

              orientation: 'horizontal',

              contentOrientation: 'vertical',

              class: {

                childList: 'gap-1',

                content: 'w-60'

              }

            },

            {

              orientation: 'vertical',

              collapsed: false,

              class: {

                childList: 'ms-5 border-s border-default',

                childItem: 'ps-1.5 -ms-px',

                content: 'data-[state=open]:animate-[collapsible-down_200ms_ease-out] data-[state=closed]:animate-[collapsible-up_200ms_ease-out] overflow-hidden'

              }

            },

            {

              orientation: 'vertical',

              collapsed: true,

              class: {

                link: 'px-1.5',

                linkLabel: 'hidden',

                linkTrailing: 'hidden',

                content: 'shadow-sm rounded-sm min-h-6 p-1'

              }

            },

            {

              orientation: 'horizontal',

              highlight: true,

              class: {

                link: [

                  'after:absolute after:-bottom-2 after:inset-x-2.5 after:block after:h-px after:rounded-full',

                  'after:transition-colors'

                ]

              }

            },

            {

              orientation: 'vertical',

              highlight: true,

              level: true,

              class: {

                link: [

                  'after:absolute after:-start-1.5 after:inset-y-0.5 after:block after:w-px after:rounded-full',

                  'after:transition-colors'

                ]

              }

            },

            {

              disabled: false,

              active: false,

              variant: 'pill',

              class: {

                link: [

                  'hover:text-highlighted hover:before:bg-elevated/50',

                  'transition-colors before:transition-colors'

                ],

                linkLeadingIcon: [

                  'group-hover:text-default',

                  'transition-colors'

                ]

              }

            },

            {

              disabled: false,

              active: false,

              variant: 'pill',

              orientation: 'horizontal',

              class: {

                link: 'data-[state=open]:text-highlighted',

                linkLeadingIcon: 'group-data-[state=open]:text-default'

              }

            },

            {

              disabled: false,

              variant: 'pill',

              highlight: true,

              orientation: 'horizontal',

              class: {

                link: 'data-[state=open]:before:bg-elevated/50'

              }

            },

            {

              disabled: false,

              variant: 'pill',

              highlight: false,

              active: false,

              orientation: 'horizontal',

              class: {

                link: 'data-[state=open]:before:bg-elevated/50'

              }

            },

            {

              color: 'primary',

              variant: 'pill',

              active: true,

              class: {

                link: 'text-primary',

                linkLeadingIcon: 'text-primary group-data-[state=open]:text-primary'

              }

            },

            {

              color: 'neutral',

              variant: 'pill',

              active: true,

              class: {

                link: 'text-highlighted',

                linkLeadingIcon: 'text-highlighted group-data-[state=open]:text-highlighted'

              }

            },

            {

              variant: 'pill',

              active: true,

              highlight: false,

              class: {

                link: 'before:bg-elevated'

              }

            },

            {

              variant: 'pill',

              active: true,

              highlight: true,

              disabled: false,

              class: {

                link: [

                  'hover:before:bg-elevated/50',

                  'before:transition-colors'

                ]

              }

            },

            {

              disabled: false,

              active: false,

              variant: 'link',

              class: {

                link: [

                  'hover:text-highlighted',

                  'transition-colors'

                ],

                linkLeadingIcon: [

                  'group-hover:text-default',

                  'transition-colors'

                ]

              }

            },

            {

              disabled: false,

              active: false,

              variant: 'link',

              orientation: 'horizontal',

              class: {

                link: 'data-[state=open]:text-highlighted',

                linkLeadingIcon: 'group-data-[state=open]:text-default'

              }

            },

            {

              color: 'primary',

              variant: 'link',

              active: true,

              class: {

                link: 'text-primary',

                linkLeadingIcon: 'text-primary group-data-[state=open]:text-primary'

              }

            },

            {

              color: 'neutral',

              variant: 'link',

              active: true,

              class: {

                link: 'text-highlighted',

                linkLeadingIcon: 'text-highlighted group-data-[state=open]:text-highlighted'

              }

            },

            {

              highlightColor: 'primary',

              highlight: true,

              level: true,

              active: true,

              class: {

                link: 'after:bg-primary'

              }

            },

            {

              highlightColor: 'neutral',

              highlight: true,

              level: true,

              active: true,

              class: {

                link: 'after:bg-inverted'

              }

            }

          ],

          defaultVariants: {

            color: 'primary',

            highlightColor: 'primary',

            variant: 'pill'

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

[`f0040`](https://github.com/nuxt/ui/commit/f004031feb5d48bb0d90f1a0844d1be1ebc19a42) — fix: hide label and trailing with css when collapsed

[`cffaa`](https://github.com/nuxt/ui/commit/cffaaaa717277d5a6d1aea6bbb38e00c5ed5ec23) — fix: proxy `modelValue` / `defaultValue` in vertical orientation

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`e5c11`](https://github.com/nuxt/ui/commit/e5c11e6696e8fdfa2f4ed4f01157e230d1c25561) — fix: ensure proper badge display

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`84f87`](https://github.com/nuxt/ui/commit/84f87a5953b508d74662dd3e81715ee86e75d71f) — feat: add global event handlers and checkbox example ([#5195](https://github.com/nuxt/ui/issues/5195))

[`f2420`](https://github.com/nuxt/ui/commit/f24204f1054c7738193f813ac8918e874d153e85) — fix: display trailing slot when badge not undefined

[`11a03`](https://github.com/nuxt/ui/commit/11a03201ed8454f37e911db4a14b00f74104932a) — fix: dot notation type support for `labelKey` and `valueKey` ([#4933](https://github.com/nuxt/ui/issues/4933))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`b2289`](https://github.com/nuxt/ui/commit/b22891abe68c40d4a33fbbcedac93e3a6be9951f) — fix: display badge when not undefined

[`836f7`](https://github.com/nuxt/ui/commit/836f74849be7a91004be7734d45c50535b9f5973) — fix: proxy fallthrough attributes

[`2fa8d`](https://github.com/nuxt/ui/commit/2fa8db64ddf4c92a19e73774143518d87d001b72) — fix: nested accordion context at every level ([#4363](https://github.com/nuxt/ui/issues/4363))

[`62bc7`](https://github.com/nuxt/ui/commit/62bc7b25a2d205d8dffb47a109196f91ff3e823a) — fix: set content `max-height` in `horizontal` orientation

[`9cf9f`](https://github.com/nuxt/ui/commit/9cf9f25f4424447691e03e9034155d1541badd43) — feat: add `trigger` type in items

[`02363`](https://github.com/nuxt/ui/commit/02363994d66d3c2d11b9913f31167fa25f5c5de2) — fix: remove `font-medium` in popover children

[`f2682`](https://github.com/nuxt/ui/commit/f2682fd2ae8abb7807977727fc22ef34cb5752e5) — feat: add `tooltip` and `popover` props

[`1e2a1`](https://github.com/nuxt/ui/commit/1e2a10b4bdebaef12316ac60f98a956dad21c1ec) — feat: handle `vertical` orientation with Accordion instead of Collapsible

[`44f53`](https://github.com/nuxt/ui/commit/44f536fd0034facb3550d910fae71d4f9442ed19) — fix: only display `tooltip` when collapsed

[`d0be5`](https://github.com/nuxt/ui/commit/d0be59946bfe30c79a6f75476385ab8538aa51b8) — fix: incorrect hover when disabled and active

[`3c78e`](https://github.com/nuxt/ui/commit/3c78e2fd983f19b5cec65b4a94a8a8b14e548e5e) — fix!: revert new `collapsible` field

[`0905b`](https://github.com/nuxt/ui/commit/0905b2b3d5e99ac78740a15d7a1afa1263ac7491) — chore: move back `item.class` on link

[`b9adc`](https://github.com/nuxt/ui/commit/b9adc83e787db02507e6e7bb1aabc684eccc197b) — feat: add `ui` field in items ([#4060](https://github.com/nuxt/ui/issues/4060))

[`0dc46`](https://github.com/nuxt/ui/commit/0dc4678c68e4b500be49c38336dc75b73843e38d) — fix: arrow position conflict ([#4137](https://github.com/nuxt/ui/issues/4137))

[`2be60`](https://github.com/nuxt/ui/commit/2be60cddfe10fd1e2466900fd53e21ee0c877227) — feat: add `collapsible` field in items

[`46c29`](https://github.com/nuxt/ui/commit/46c2987ebfd30b2b071a96a745b7270e852e96de) — feat: handle `tooltip` in items

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`aebf0`](https://github.com/nuxt/ui/commit/aebf0b3dca50c51c093cb6abf16c4fd995fc1b39) — fix: remove `sm:w-auto` from content slot

[`1a463`](https://github.com/nuxt/ui/commit/1a463946681e152aa18372118d0fef4a7d8055a5) — feat: add new `content-top` and `content-bottom` slots ([#3886](https://github.com/nuxt/ui/issues/3886))

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`af1bf`](https://github.com/nuxt/ui/commit/af1bf1bbde49ff076ed0942a7a66bb53e1a10249) — chore: remove slots types in `createReusableTemplate`

[`abe08`](https://github.com/nuxt/ui/commit/abe0859691e06564f68335bd82dcd121e976408e) — fix: add `sm:w-auto` content slot

[`b9983`](https://github.com/nuxt/ui/commit/b9983549a4b743724ea3ef99cc4a243f5ca41e53) — fix: improve generic types ([#3331](https://github.com/nuxt/ui/issues/3331))

[`0095d`](https://github.com/nuxt/ui/commit/0095d8916bf361c0c89972e2f86b79850510c6a9) — fix: add `z-index` on viewport

[`5dec0`](https://github.com/nuxt/ui/commit/5dec0e16e28549b8833aaab17a87fada63d6598c) — feat: handle events in `content` prop

[`ef861`](https://github.com/nuxt/ui/commit/ef86108f14da23fa292afe016517eac95c34bf76) — chore: add eol in script tag to fix syntax highlight