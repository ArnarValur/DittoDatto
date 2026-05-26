---
title: "Vue Link Component"
source: "https://ui.nuxt.com/docs/components/link"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A wrapper around <NuxtLink> with extra props."
tags:
---
## Link

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Link.vue)

A wrapper around with extra props.

## Usage

The Link component is a wrapper around [`<NuxtLink>`](https://nuxt.com/docs/api/components/nuxt-link) using the [`custom`](https://router.vuejs.org/api/interfaces/RouterLinkProps.html#Properties-custom) prop. It provides a few extra props:

- `inactive-class` prop to set a class when the link is inactive, `active-class` is used when active.
- `exact` prop to style with `active-class` when the link is active and the route is exactly the same as the current route.
- `exact-query` and `exact-hash` props to style with `active-class` when the link is active and the query or hash is exactly the same as the current query or hash.
	- use `exact-query="partial"` to style with `active-class` when the link is active and the query partially match the current query.

The incentive behind this is to provide the same API as NuxtLink back in Nuxt 2 / Vue 2. You can read more about it in the Vue Router [migration from Vue 2](https://router.vuejs.org/guide/migration/#removal-of-the-exact-prop-in-router-link) guide.

It is used by the [`Breadcrumb`](https://ui.nuxt.com/docs/components/breadcrumb), [`Button`](https://ui.nuxt.com/docs/components/button), [`ContextMenu`](https://ui.nuxt.com/docs/components/context-menu), [`DropdownMenu`](https://ui.nuxt.com/docs/components/dropdown-menu) and [`NavigationMenu`](https://ui.nuxt.com/docs/components/navigation-menu) components.

### Tag

The `Link` components renders an `<a>` tag when a `to` prop is provided, otherwise it renders a `<button>` tag. You can use the `as` prop to change fallback tag.

```
<template>

  <ULink as="button">Link</ULink>

</template>
```

You can inspect the rendered HTML by changing the `to` prop.

### Style

By default, the link has default active and inactive styles, check out the [#theme](https://ui.nuxt.com/docs/components/#theme) section.

[Link](https://ui.nuxt.com/docs/components/link)

```
<template>

  <ULink to="/docs/components/link">Link</ULink>

</template>
```

Try changing the `to` prop to see the active and inactive states.

You can override this behavior by using the `raw` prop and provide your own styles using `class`, `active-class` and `inactive-class`.

[Link](https://ui.nuxt.com/docs/components/link)

```
<template>

  <ULink raw to="/docs/components/link" active-class="font-bold" inactive-class="text-muted">Link</ULink>

</template>
```

## IntelliSense

If you're using VSCode and wish to get autocompletion for the classes `active-class` and `inactive-class`, you can add the following settings to your `.vscode/settings.json`:

.vscode/settings.json

```json
{

  "tailwindCSS.classAttributes": [

    "active-class",

    "inactive-class"

  ]

}
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'button'` | `any`  The element or component this component should render as when not a link. |
| `type` | `'button'` | ` "reset" \| "submit" \| "button"`  The type of the button when not a link. |
| `disabled` |  | `boolean` |
| `active` | `undefined` | `boolean`  Force the link to be active independent of the current route. |
| `exact` |  | `boolean`  Will only be active if the current route is an exact match. |
| `exactQuery` |  | `boolean \| "partial"`  Allows controlling how the current route query sets the link as active. |
| `exactHash` |  | `boolean`  Will only be active if the current route hash is an exact match. |
| `inactiveClass` |  | ` string`  The class to apply when the link is inactive. |
| `raw` |  | `boolean `  When `true`, only styles from `class`, `activeClass`, and `inactiveClass` will be applied. |
| `to` |  | ` string \| kt \| Tt` |
| `href` |  | ` string \| kt \| Tt`  An alias for `to`. If used with `to`, `href` will be ignored |
| `external` |  | `boolean `  Forces the link to be considered as external (true) or internal (false). This is helpful to handle edge-cases |
| `target` |  | ` null \| string & {} \| "_blank" \| "_parent" \| "_self" \| "_top"`  Where to display the linked URL, as the name for a browsing context. |
| `rel` |  | ` null \| "noopener" \| "noreferrer" \| "nofollow" \| "sponsored" \| "ugc" \| string & {}`  A rel attribute value to apply on the link. Defaults to "noopener noreferrer" for external links. |
| `noRel` |  | `boolean `  If set to true, no rel attribute will be added to the link |
| `prefetchedClass` |  | ` string`  A class to apply to links that have been prefetched. |
| `prefetch` |  | `boolean `  When enabled will prefetch middleware, layouts and payloads of links in the viewport. |
| `prefetchOn` |  | ` "visibility" \| "interaction" \| Partial<{ visibility: boolean; interaction: boolean; }>`  Allows controlling when to prefetch links. By default, prefetch is triggered only on visibility. |
| `noPrefetch` |  | `boolean `  Escape hatch to disable `prefetch` attribute. |
| `trailingSlash` |  | ` "remove" \| "append"`  An option to either add or remove trailing slashes in the `href` for this specific link. Overrides the global `trailingSlash` option if provided. |
| `activeClass` |  | ` string`  Class to apply when the link is active |
| `exactActiveClass` |  | ` string`  Class to apply when the link is exact active |
| `ariaCurrentValue` | `'page'` | ` "step" \| "page" \| "true" \| "false" \| "location" \| "date" \| "time"`  Value passed to the attribute `aria-current` when the link is exact active. |
| `viewTransition` |  | `boolean `  Pass the returned promise of `router.push()` to `document.startViewTransition()` if supported. |
| `replace` |  | `boolean `  Calls `router.replace` instead of `router.push`. |
| `name` |  | ` string` |
| `autofocus` |  | ` false \| true \| "true" \| "false"` |
| `form` |  | ` string` |
| `formaction` |  | ` string` |
| `formenctype` |  | ` string` |
| `formmethod` |  | ` string` |
| `formnovalidate` |  | ` false \| true \| "true" \| "false"` |
| `formtarget` |  | ` string` |
| `referrerpolicy` |  | ` "" \| "no-referrer" \| "no-referrer-when-downgrade" \| "origin" \| "origin-when-cross-origin" \| "same-origin" \| "strict-origin" \| "strict-origin-when-cross-origin" \| "unsafe-url"` |
| `download` |  | `any` |
| `hreflang` |  | ` string` |
| `media` |  | ` string` |
| `ping` |  | ` string` |

This component also supports all native `<a>` HTML attributes.

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{ active: boolean; }` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    link: {

      base: 'focus-visible:outline-primary',

      variants: {

        active: {

          true: 'text-primary',

          false: 'text-muted'

        },

        disabled: {

          true: 'cursor-not-allowed opacity-75'

        }

      },

      compoundVariants: [

        {

          active: false,

          disabled: false,

          class: [

            'hover:text-default',

            'transition-colors'

          ]

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

        link: {

          base: 'focus-visible:outline-primary',

          variants: {

            active: {

              true: 'text-primary',

              false: 'text-muted'

            },

            disabled: {

              true: 'cursor-not-allowed opacity-75'

            }

          },

          compoundVariants: [

            {

              active: false,

              disabled: false,

              class: [

                'hover:text-default',

                'transition-colors'

              ]

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

[`da8da`](https://github.com/nuxt/ui/commit/da8daaade66e065aec5dc2fc6f3946dd1636a405) — fix: define NuxtLinkProps instead of importing from `#app` ([#5491](https://github.com/nuxt/ui/issues/5491))

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`9debc`](https://github.com/nuxt/ui/commit/9debce737cc779229713cd19b03e6167dfd3ea8e) — fix: merge `active-class` / `inactive-class` with app config ([#4446](https://github.com/nuxt/ui/issues/4446))

[`67da9`](https://github.com/nuxt/ui/commit/67da90a2f638124f640c4271d3376c5ff3fab6a1) — fix: consistent behavior between nuxt, vue and inertia ([#4134](https://github.com/nuxt/ui/issues/4134))

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`c531d`](https://github.com/nuxt/ui/commit/c531d0248be7863980a1f676643c2dea8301c009) — fix: handle `aria-current` like `NuxtLink` / `RouterLink`