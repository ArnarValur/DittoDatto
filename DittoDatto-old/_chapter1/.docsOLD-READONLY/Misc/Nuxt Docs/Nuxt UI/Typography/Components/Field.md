# Field

> Document API parameters, props, and configuration options clearly.

## Usage

A field, prop or parameter to display in your content.

<code-preview>
<field :required="true" className="w-full" name="name" required="true" type="string">

The `description` can be set as prop or in the default slot with full **markdown** support.

</field>

<template v-slot:code="">

```mdc
::field{name="name" type="string" required}
The `description` can be set as prop or in the default slot with full **markdown** support.
::
```

</template>
</code-preview>

## API

### Props

```ts
/**
 * Props for the ProseField component
 */
interface ProseFieldProps {
  /**
   * The element or component this component should render as.
   */
  as?: any;
  /**
   * The name of the field.
   */
  name?: string | undefined;
  /**
   * Expected type of the field's value
   */
  type?: string | undefined;
  /**
   * Description of the field
   */
  description?: string | undefined;
  /**
   * Indicate whether the field is required
   */
  required?: boolean | undefined;
  ui?: { root?: ClassNameValue; container?: ClassNameValue; name?: ClassNameValue; wrapper?: ClassNameValue; required?: ClassNameValue; type?: ClassNameValue; description?: ClassNameValue; } | undefined;
}
```

### Slots

```ts
/**
 * Slots for the Field component
 */
interface FieldSlots {
  default(): any;
}
```

## Theme

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      field: {
        slots: {
          root: 'my-5',
          container: 'flex items-center gap-3 font-mono text-sm',
          name: 'font-semibold text-primary',
          wrapper: 'flex-1 flex items-center gap-1.5 text-xs',
          required: 'rounded-sm bg-error/10 text-error px-1.5 py-0.5',
          type: 'rounded-sm bg-elevated text-toned px-1.5 py-0.5',
          description: 'mt-3 text-muted text-sm [&_code]:text-xs/4'
        }
      }
    }
  }
})
```

## Changelog

<component-changelog prefix="prose">



</component-changelog>
