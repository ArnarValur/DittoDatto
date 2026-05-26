# CodeCollapse

> Make long code blocks collapsible to save space and improve readability.

## Usage

Wrap your code-block with a `code-collapse` component to display a collapsible code block.

<code-preview className="[&>div]:*:my-0,[&>div]:*:w-full">
<code-collapse className="[&>div]:my-0">

```css [main.css]
@import "tailwindcss";
@import "@nuxt/ui";

@theme static {
  --font-sans: 'Public Sans', sans-serif;

  --breakpoint-3xl: 1920px;

  --color-green-50: #EFFDF5;
  --color-green-100: #D9FBE8;
  --color-green-200: #B3F5D1;
  --color-green-300: #75EDAE;
  --color-green-400: #00DC82;
  --color-green-500: #00C16A;
  --color-green-600: #00A155;
  --color-green-700: #007F45;
  --color-green-800: #016538;
  --color-green-900: #0A5331;
  --color-green-950: #052E16;
}
```

</code-collapse>

<template v-slot:code="">

```mdc
::code-collapse

```css [main.css]
@import "tailwindcss";
@import "@nuxt/ui";

@theme static {
  --font-sans: 'Public Sans', sans-serif;

  --breakpoint-3xl: 1920px;

  --color-green-50: #EFFDF5;
  --color-green-100: #D9FBE8;
  --color-green-200: #B3F5D1;
  --color-green-300: #75EDAE;
  --color-green-400: #00DC82;
  --color-green-500: #00C16A;
  --color-green-600: #00A155;
  --color-green-700: #007F45;
  --color-green-800: #016538;
  --color-green-900: #0A5331;
  --color-green-950: #052E16;
}
```

::
```

</template>
</code-preview>

## API

### Props

```ts
/**
 * Props for the ProseCodeCollapse component
 */
interface ProseCodeCollapseProps {
  /**
   * The icon displayed to toggle the code.
   */
  icon?: any;
  /**
   * The name displayed in the trigger label.
   */
  name?: string | undefined;
  /**
   * The text displayed when the code is collapsed.
   */
  openText?: string | undefined;
  /**
   * The text displayed when the code is expanded.
   */
  closeText?: string | undefined;
  ui?: { root?: ClassNameValue; footer?: ClassNameValue; trigger?: ClassNameValue; triggerIcon?: ClassNameValue; } | undefined;
  /**
   * @default "false"
   */
  open?: boolean | undefined;
}
```

### Slots

```ts
/**
 * Slots for the CodeCollapse component
 */
interface CodeCollapseSlots {
  default(): any;
}
```

## Theme

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      codeCollapse: {
        slots: {
          root: 'relative [&_pre]:h-[200px]',
          footer: 'h-16 absolute inset-x-px bottom-px rounded-b-md flex items-center justify-center',
          trigger: 'group',
          triggerIcon: 'group-data-[state=open]:rotate-180'
        },
        variants: {
          open: {
            true: {
              root: '[&_pre]:h-auto [&_pre]:min-h-[200px] [&_pre]:max-h-[80vh] [&_pre]:pb-12'
            },
            false: {
              root: '[&_pre]:overflow-hidden',
              footer: 'bg-gradient-to-t from-muted'
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
