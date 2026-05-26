# CardGroup

> Organize multiple cards in responsive grid layouts for better content presentation.

## Usage

Wrap your `card` components with the `card-group` component to group them together in a grid layout.

<code-preview>
<card-group className="w-full,my-0">
<card icon="i-simple-icons-github" target="_blank" title="Dashboard" to="https://github.com/nuxt-ui-templates/dashboard">

A dashboard with multi-column layout.

</card>

<card icon="i-simple-icons-github" target="_blank" title="SaaS" to="https://github.com/nuxt-ui-templates/saas">

A template with landing, pricing, docs and blog.

</card>

<card icon="i-simple-icons-github" target="_blank" title="Docs" to="https://github.com/nuxt-ui-templates/docs">

A documentation with `@nuxt/content`.

</card>

<card icon="i-simple-icons-github" target="_blank" title="Landing" to="https://github.com/nuxt-ui-templates/landing">

A landing page you can use as starting point.

</card>
</card-group>

<template v-slot:code="">

```mdc
::card-group

::card
---
title: Dashboard
icon: i-simple-icons-github
to: https://github.com/nuxt-ui-templates/dashboard
target: _blank
---
A dashboard with multi-column layout.
::

::card
---
title: SaaS
icon: i-simple-icons-github
to: https://github.com/nuxt-ui-templates/saas
target: _blank
---
A template with landing, pricing, docs and blog.
::

::card
---
title: Docs
icon: i-simple-icons-github
to: https://github.com/nuxt-ui-templates/docs
target: _blank
---
A documentation with `@nuxt/content`.
::

::card
---
title: Landing
icon: i-simple-icons-github
to: https://github.com/nuxt-ui-templates/landing
target: _blank
---
A landing page you can use as starting point.
::

::
```

</template>
</code-preview>

## API

### Slots

```ts
/**
 * Slots for the CardGroup component
 */
interface CardGroupSlots {
  default(): any;
}
```

## Theme

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      cardGroup: {
        base: 'grid grid-cols-1 sm:grid-cols-2 gap-5 my-5 *:my-0'
      }
    }
  }
})
```

## Changelog

<component-changelog prefix="prose">



</component-changelog>
