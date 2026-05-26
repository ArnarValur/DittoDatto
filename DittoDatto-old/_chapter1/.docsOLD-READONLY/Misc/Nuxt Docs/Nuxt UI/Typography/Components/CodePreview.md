# CodePreview

> Display code examples with a preview and their source for clearer documentation.

## Usage

Wrap any content with the `code-preview` component to display a live preview alongside its source code using the `code` slot.

<code-preview className="[&>div]:*:my-0,[&>div]:*:w-full" label="Preview">
<code-preview className="[&>div]:*:my-0">

`inline code`

<template v-slot:code="">

```mdc
`inline code`
```

</template>
</code-preview>

<template v-slot:code="">

```mdc
::code-preview
`inline code`

#code
```mdc
`inline code`
```
::
```

</template>
</code-preview>

## API

### Props

```ts
/**
 * Props for the ProseCodePreview component
 */
interface ProseCodePreviewProps {
  ui?: { root?: ClassNameValue; preview?: ClassNameValue; code?: ClassNameValue; } | undefined;
}
```

### Slots

```ts
/**
 * Slots for the CodePreview component
 */
interface CodePreviewSlots {
  default(): any;
  code(): any;
}
```

## Theme

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      codePreview: {
        slots: {
          root: 'my-5',
          preview: 'flex justify-center border border-muted relative p-4 rounded-md',
          code: '[&>div>pre]:rounded-t-none [&>div]:my-0'
        },
        variants: {
          code: {
            true: {
              preview: 'border-b-0 rounded-b-none'
            }
          }
        }
      }
    }
  }
})
```

## Changelog

<component-changelog prefix="prose">



</component-changelog>
