# FieldGroup

> Group related fields together for comprehensive API documentation.

## Usage

Group fields together in a list.

<code-preview>
<field-group className="my-0">
<field name="analytics" type="boolean">

Default to `false` - Enables analytics for your project (coming soon).

</field>

<field name="blob" type="boolean">

Default to `false` - Enables blob storage to store static assets, such as images, videos and more.

</field>

<field name="cache" type="boolean">

Default to `false` - Enables cache storage to cache your server route responses or functions using Nitro's `cachedEventHandler` and `cachedFunction`

</field>

<field name="database" type="boolean">

Default to `false` - Enables SQL database to store your application's data.

</field>
</field-group>

<template v-slot:code="">

```mdc
::field-group
  ::field{name="analytics" type="boolean"}
    Default to `false` - Enables analytics for your project (coming soon).
  ::

  ::field{name="blob" type="boolean"}
    Default to `false` - Enables blob storage to store static assets, such as images, videos and more.
  ::

  ::field{name="cache" type="boolean"}
    Default to `false` - Enables cache storage to cache your server route responses or functions using Nitro's `cachedEventHandler` and `cachedFunction`
  ::

  ::field{name="database" type="boolean"}
    Default to `false` - Enables SQL database to store your application's data.
  ::
::
```

</template>
</code-preview>

## API

### Props

```ts
/**
 * Props for the ProseFieldGroup component
 */
interface ProseFieldGroupProps {
  /**
   * The element or component this component should render as.
   */
  as?: any;
  size?: "md" | "xs" | "sm" | "lg" | "xl" | undefined;
  /**
   * The orientation the buttons are laid out.
   * @default "\"horizontal\""
   */
  orientation?: "horizontal" | "vertical" | undefined;
  ui?: {} | undefined;
}
```

### Slots

```ts
/**
 * Slots for the FieldGroup component
 */
interface FieldGroupSlots {
  default(): any;
}
```

## Theme

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      fieldGroup: {
        base: 'my-5 divide-y divide-default *:not-last:pb-5'
      }
    }
  }
})
```

## Changelog

<component-changelog prefix="prose">



</component-changelog>
