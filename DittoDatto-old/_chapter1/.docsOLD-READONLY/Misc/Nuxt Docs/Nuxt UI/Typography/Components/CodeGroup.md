# CodeGroup

> Group multiple code examples in tabbed interfaces for easy comparison.

## Usage

Wrap your code blocks around a `code-group` component to group them together in tabs.

<code-preview className="[&>div]:*:my-0,[&>div]:*:w-full">
<code-group>

```bash [pnpm]
pnpm add @nuxt/ui
```

```bash [yarn]
yarn add @nuxt/ui
```

```bash [npm]
npm install @nuxt/ui
```

```bash [bun]
bun add @nuxt/ui
```

</code-group>

<template v-slot:code="">

```mdc
::code-group

```bash [pnpm]
pnpm add @nuxt/ui
```

```bash [yarn]
yarn add @nuxt/ui
```

```bash [npm]
npm install @nuxt/ui
```

```bash [bun]
bun add @nuxt/ui
```

::
```

</template>
</code-preview>

<note to="/docs/typography/code#code-blocks">

Like the `ProsePre` component, the `CodeGroup` handles filenames, icons and copy button.

</note>

## API

### Props

```ts
/**
 * Props for the ProseCodeGroup component
 */
interface ProseCodeGroupProps {
  /**
   * The default tab to select.
   * @default "\"0\""
   */
  defaultValue?: string | undefined;
  /**
   * Sync the selected tab with a local storage key.
   */
  sync?: string | undefined;
  ui?: { root?: ClassNameValue; list?: ClassNameValue; indicator?: ClassNameValue; trigger?: ClassNameValue; triggerIcon?: ClassNameValue; triggerLabel?: ClassNameValue; } | undefined;
  modelValue?: string | undefined;
}
```

### Slots

```ts
/**
 * Slots for the CodeGroup component
 */
interface CodeGroupSlots {
  default(): any;
}
```

## Theme

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      codeGroup: {
        slots: {
          root: 'relative group *:not-first:!my-0 *:not-first:!static my-5',
          list: 'relative flex items-center gap-1 border border-muted bg-default border-b-0 rounded-t-md overflow-x-auto p-2',
          indicator: 'absolute left-0 inset-y-2 w-(--reka-tabs-indicator-size) translate-x-(--reka-tabs-indicator-position) transition-[translate,width] duration-200 bg-elevated rounded-md shadow-xs',
          trigger: [
            'relative inline-flex items-center gap-1.5 text-default data-[state=active]:text-highlighted hover:bg-elevated/50 px-2 py-1.5 text-sm rounded-md disabled:cursor-not-allowed disabled:opacity-75 focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-primary focus:outline-none',
            'transition-colors'
          ],
          triggerIcon: 'size-4 shrink-0',
          triggerLabel: 'truncate'
        }
      }
    }
  }
})
```

## Changelog

<component-changelog prefix="prose">



</component-changelog>
