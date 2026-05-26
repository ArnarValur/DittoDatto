# Accordion

> Create expandable content sections for better information organization.

## Usage

Use the `accordion` and `accordion-item` components to display an [Accordion](/docs/components/accordion) in your content.

<code-preview className="[&>div]:*:my-0">
<accordion :defaultValue="["1"]">
<accordion-item icon="i-lucide-circle-help" label="Is Nuxt UI free to use?">

Yes! Nuxt UI is completely free and open source under the MIT license. All 100+ components are available to everyone.

</accordion-item>

<accordion-item icon="i-lucide-circle-help" label="Can I use Nuxt UI with Vue without Nuxt?">

Yes! While optimized for Nuxt, Nuxt UI works perfectly with standalone Vue projects via our Vite plugin. You can follow the [installation guide](/docs/getting-started/installation/vue) to get started.

</accordion-item>

<accordion-item icon="i-lucide-circle-help" label="Is Nuxt UI production-ready?">

Yes! Nuxt UI is used in production by thousands of applications with extensive tests, regular updates, and active maintenance.

</accordion-item>
</accordion>

<template v-slot:code="">

```mdc
::accordion
---
defaultValue:
  - '1'
---

::accordion-item{label="Is Nuxt UI free to use?" icon="i-lucide-circle-help"}
Yes! Nuxt UI is completely free and open source under the MIT license. All 100+ components are available to everyone.
::

::accordion-item{label="Can I use Nuxt UI with Vue without Nuxt?" icon="i-lucide-circle-help"}
Yes! While optimized for Nuxt, Nuxt UI works perfectly with standalone Vue projects via our Vite plugin. You can follow the [installation guide](/docs/getting-started/installation/vue) to get started.
::

::accordion-item{label="Is Nuxt UI production-ready?" icon="i-lucide-circle-help"}
Yes! Nuxt UI is used in production by thousands of applications with extensive tests, regular updates, and active maintenance.
::

::
```

</template>
</code-preview>

## API

### Props

```ts
/**
 * Props for the ProseAccordion component
 */
interface ProseAccordionProps {
  /**
   * The element or component this component should render as.
   */
  as?: any;
  items?: AccordionItem[] | undefined;
  /**
   * The icon displayed on the right side of the trigger.
   */
  trailingIcon?: any;
  /**
   * The key used to get the label from the item.
   * @default "\"label\""
   */
  labelKey?: GetItemKeys<AccordionItem> | undefined;
  ui?: { root?: ClassNameValue; item?: ClassNameValue; header?: ClassNameValue; trigger?: ClassNameValue; content?: ClassNameValue; body?: ClassNameValue; leadingIcon?: ClassNameValue; trailingIcon?: ClassNameValue; label?: ClassNameValue; } | undefined;
  /**
   * When type is "single", allows closing content when clicking trigger for an open item.
   * When type is "multiple", this prop has no effect.
   * @default "true"
   */
  collapsible?: boolean | undefined;
  /**
   * The default active value of the item(s).
   * 
   * Use when you do not need to control the state of the item(s).
   */
  defaultValue?: string | string[] | undefined;
  /**
   * The controlled value of the active item(s).
   * 
   * Use this when you need to control the state of the items. Can be binded with `v-model`
   */
  modelValue?: string | string[] | undefined;
  /**
   * Determines whether a "single" or "multiple" items can be selected at a time.
   * 
   * This prop will overwrite the inferred type from `modelValue` and `defaultValue`.
   * @default "\"single\""
   */
  type?: SingleOrMultipleType | undefined;
  /**
   * When `true`, prevents the user from interacting with the accordion and all its items
   */
  disabled?: boolean | undefined;
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
 * Slots for the Accordion component
 */
interface AccordionSlots {
  leading(): any;
  default(): any;
  trailing(): any;
  content(): any;
  body(): any;
}
```

## Theme

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      accordion: {
        slots: {
          root: 'my-5',
          trigger: 'text-base'
        }
      }
    }
  }
})
```

## Changelog

<component-changelog prefix="prose">



</component-changelog>
