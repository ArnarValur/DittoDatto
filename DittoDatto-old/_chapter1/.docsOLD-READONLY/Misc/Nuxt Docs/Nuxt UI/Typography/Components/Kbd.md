# Kbd

> Display keyboard shortcuts and key combinations with proper styling.

## Usage

Use the `kbd` component to display a [Kbd](/docs/components/kbd) in your content.

<code-preview className="[&>div]:*:my-0">
<kbd value="meta">



</kbd>

 <kbd value="K">



</kbd>



<template v-slot:code="">

```mdc
:kbd{value="meta"} :kbd{value="K"}
```

</template>
</code-preview>

## API

### Props

```ts
/**
 * Props for the ProseKbd component
 */
interface ProseKbdProps {
  /**
   * The element or component this component should render as.
   * @default "\"kbd\""
   */
  as?: any;
  value?: string | undefined;
  color?: "error" | "primary" | "secondary" | "success" | "info" | "warning" | "neutral" | undefined;
  variant?: "outline" | "soft" | "subtle" | "solid" | undefined;
  size?: "sm" | "md" | "lg" | undefined;
}
```

## Theme

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      kbd: {
        base: 'align-text-top'
      }
    }
  }
})
```

## Changelog

<component-changelog prefix="prose">



</component-changelog>
