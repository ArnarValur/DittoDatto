# Tabs

> Organize related content in interactive tabbed interfaces.

## Usage

Use the `tabs` and `tabs-item` components to display [Tabs](/docs/components/tabs) in your content.

<code-preview className="[&>div]:*:my-0">
<tabs className="w-full">
<tabs-item icon="i-lucide-code" label="Code">

```mdc
::callout
Lorem velit voluptate ex reprehenderit ullamco et culpa.
::
```

</tabs-item>

<tabs-item icon="i-lucide-eye" label="Preview">
<callout>

Lorem velit voluptate ex reprehenderit ullamco et culpa.

</callout>
</tabs-item>
</tabs>

<template v-slot:code="">

```mdc
::tabs

:::tabs-item{label="Code" icon="i-lucide-code"}

```mdc
::callout
Lorem velit voluptate ex reprehenderit ullamco et culpa.
::
```

:::

:::tabs-item{label="Preview" icon="i-lucide-eye"}

::callout
Lorem velit voluptate ex reprehenderit ullamco et culpa.
::

:::

::
```

</template>
</code-preview>

## API

### Props

```ts
/**
 * Props for the ProseTabs component
 */
interface ProseTabsProps {
  /**
   * The element or component this component should render as.
   */
  as?: any;
  items?: TabsItem[] | undefined;
  color?: "primary" | "secondary" | "success" | "info" | "warning" | "error" | "neutral" | undefined;
  variant?: "pill" | "link" | undefined;
  size?: "sm" | "xs" | "md" | "lg" | "xl" | undefined;
  /**
   * The orientation of the tabs.
   * @default "\"horizontal\""
   */
  orientation?: DataOrientation | undefined;
  /**
   * The content of the tabs, can be disabled to prevent rendering the content.
   * @default "true"
   */
  content?: boolean | undefined;
  /**
   * The key used to get the label from the item.
   * @default "\"label\""
   */
  labelKey?: GetItemKeys<TabsItem> | undefined;
  ui?: { root?: ClassNameValue; list?: ClassNameValue; indicator?: ClassNameValue; trigger?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; label?: ClassNameValue; trailingBadge?: ClassNameValue; trailingBadgeSize?: ClassNameValue; content?: ClassNameValue; } | undefined;
  /**
   * The value of the tab that should be active when initially rendered. Use when you do not need to control the state of the tabs
   * @default "\"0\""
   */
  defaultValue?: string | number | undefined;
  /**
   * The controlled value of the tab to activate. Can be bind as `v-model`.
   */
  modelValue?: string | number | undefined;
  /**
   * Whether a tab is activated automatically (on focus) or manually (on click).
   */
  activationMode?: "automatic" | "manual" | undefined;
  /**
   * When `true`, the element will be unmounted on closed state.
   * @default "true"
   */
  unmountOnHide?: boolean | undefined;
}
```

### Slots

```ts
/**
 * Slots for the Tabs component
 */
interface TabsSlots {
  leading(): any;
  default(): any;
  trailing(): any;
  content(): any;
  list-leading(): any;
  list-trailing(): any;
}
```

## Theme

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      tabs: {
        slots: {
          root: 'my-5 gap-4'
        }
      }
    }
  }
})
```

## Changelog

<component-changelog prefix="prose">



</component-changelog>
