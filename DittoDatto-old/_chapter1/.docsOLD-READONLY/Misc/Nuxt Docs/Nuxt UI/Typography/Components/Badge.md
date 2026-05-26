# Badge

> Display version numbers, status labels, and tags within your content.

## Usage

Use markdown in the default slot of the `badge` component to display a [Badge](/docs/components/badge) in your content.

<code-preview>
<badge>

**v4.0.0**

</badge>

<template v-slot:code="">

```mdc
::badge
**v4.0.0**
::
```

</template>
</code-preview>

## API

### Slots

```ts
/**
 * Slots for the Badge component
 */
interface BadgeSlots {
  leading(): any;
  default(): any;
  trailing(): any;
}
```

## Theme

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      badge: {
        base: 'rounded-full'
      }
    }
  }
})
```

## Changelog

<component-changelog prefix="prose">



</component-changelog>
