---
title: "Head · Nuxt Kit v4"
source: "https://nuxt.com/docs/4.x/api/kit/head"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## setGlobalHead

Sets global head configuration for your Nuxt application. This utility allows modules to programmatically configure meta tags, links, scripts, and other head elements that will be applied across all pages.

The provided head configuration will be merged with any existing head configuration using deep merging, with your provided values taking precedence.

This is particularly useful for modules that need to inject global meta tags, stylesheets, or scripts into the application head.

### Type

```ts
import type { SerializableHead } from '@unhead/vue/types'

interface AppHeadMetaObject extends SerializableHead {

  charset?: string

  viewport?: string

}

function setGlobalHead (head: AppHeadMetaObject): void
```

### Parameters

#### head

**Type**: `AppHeadMetaObject`

An object containing head configuration. All properties are optional and will be merged with existing configuration:

- `charset`: Character encoding for the document
- `viewport`: Viewport meta tag configuration
- `meta`: Array of meta tag objects
- `link`: Array of link tag objects (stylesheets, icons, etc.)
- `style`: Array of inline style tag objects
- `script`: Array of script tag objects
- `noscript`: Array of noscript tag objects
- `title`: Default page title
- `titleTemplate`: Template for formatting page titles
- `bodyAttrs`: Attributes to add to the `<body>` tag
- `htmlAttrs`: Attributes to add to the `<html>` tag

### Examples

#### Adding Global Meta Tags

```ts
import { defineNuxtModule, setGlobalHead } from '@nuxt/kit'

export default defineNuxtModule({

  setup () {

    setGlobalHead({

      meta: [

        { name: 'theme-color', content: '#ffffff' },

        { name: 'author', content: 'Your Name' },

      ],

    })

  },

})
```

#### Injecting Global Stylesheets

```ts
import { defineNuxtModule, setGlobalHead } from '@nuxt/kit'

export default defineNuxtModule({

  setup () {

    setGlobalHead({

      link: [

        {

          rel: 'stylesheet',

          href: 'https://fonts.googleapis.com/css2?family=Inter:wght@400;700&display=swap',

        },

      ],

    })

  },

})
```

#### Adding Global Scripts

```ts
import { defineNuxtModule, setGlobalHead } from '@nuxt/kit'

export default defineNuxtModule({

  setup () {

    setGlobalHead({

      script: [

        {

          src: 'https://cdn.example.com/analytics.js',

          async: true,

          defer: true,

        },

      ],

    })

  },

})
```

#### Setting HTML Attributes

```ts
import { defineNuxtModule, setGlobalHead } from '@nuxt/kit'

export default defineNuxtModule({

  setup () {

    setGlobalHead({

      htmlAttrs: {

        lang: 'en',

        dir: 'ltr',

      },

      bodyAttrs: {

        class: 'custom-body-class',

      },

    })

  },

})
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/5.kit/9.head.md)[Layout](https://nuxt.com/docs/4.x/api/kit/layout)

[

Nuxt Kit provides a set of utilities to help you work with layouts.

](https://nuxt.com/docs/4.x/api/kit/layout)[

Plugins

Nuxt Kit provides a set of utilities to help you create and use plugins. You can add plugins or plugin templates to your module using these functions.

](https://nuxt.com/docs/4.x/api/kit/plugins)