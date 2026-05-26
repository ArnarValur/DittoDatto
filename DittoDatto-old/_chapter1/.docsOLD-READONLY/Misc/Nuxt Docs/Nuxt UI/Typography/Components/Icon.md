# Icon

> Display icons from popular icon libraries to enhance your content.

## Usage

Use the `icon` component to display an [Icon](/docs/components/icon) in your content.

<code-preview>
<icon name="i-simple-icons-nuxtdotjs">



</icon>

<template v-slot:code="">

```mdc
:icon{name="i-simple-icons-nuxtdotjs"}
```

</template>
</code-preview>

## API

### Props

```ts
/**
 * Props for the ProseIcon component
 */
interface ProseIconProps {
  name: any;
  mode?: "svg" | "css" | undefined;
  size?: string | number | undefined;
  customize?: ((content: string, name?: string | undefined, prefix?: string | undefined, provider?: string | undefined) => string) | undefined;
}
```

## Theme

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      icon: {
        base: 'size-4 shrink-0 align-sub'
      }
    }
  }
})
```

## Changelog

<component-changelog prefix="prose">



</component-changelog>
