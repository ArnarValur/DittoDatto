---
title: "defineNuxtComponent · Nuxt Utils v4"
source: "https://nuxt.com/docs/4.x/api/utils/define-nuxt-component"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## defineNuxtComponent

[Source](https://github.com/nuxt/nuxt/blob/main/packages/nuxt/src/app/composables/component.ts)

defineNuxtComponent() is a helper function for defining type safe components with Options API.

`defineNuxtComponent()` is a helper function for defining type safe Vue components using options API similar to [`defineComponent()`](https://vuejs.org/api/general#definecomponent). `defineNuxtComponent()` wrapper also adds support for `asyncData` and `head` component options.

Using `<script setup lang="ts">` is the recommended way of declaring Vue components in Nuxt.

Read more in Docs > Getting Started > Data Fetching.

## asyncData()

If you choose not to use `setup()` in your app, you can use the `asyncData()` method within your component definition:

app/pages/index.vue

```
<script lang="ts">

export default defineNuxtComponent({

  asyncData () {

    return {

      data: {

        greetings: 'hello world!',

      },

    }

  },

})

</script>
```

## head()

If you choose not to use `setup()` in your app, you can use the `head()` method within your component definition:

app/pages/index.vue

```
<script lang="ts">

export default defineNuxtComponent({

  head (nuxtApp) {

    return {

      title: 'My site',

    }

  },

})

</script>
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/3.utils/define-nuxt-component.md)[defineLazyHydrationComponent](https://nuxt.com/docs/4.x/api/utils/define-lazy-hydration-component)

[

Define a lazy hydration component with a specific strategy.

](https://nuxt.com/docs/4.x/api/utils/define-lazy-hydration-component)[

defineNuxtPlugin

defineNuxtPlugin() is a helper function for creating Nuxt plugins.

](https://nuxt.com/docs/4.x/api/utils/define-nuxt-plugin)