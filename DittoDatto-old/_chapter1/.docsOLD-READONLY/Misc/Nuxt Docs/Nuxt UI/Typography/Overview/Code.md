# Code

> Display inline code and syntax-highlighted code blocks with copy-to-clipboard support.

## Code blocks

Code blocks are rendered by the `ProsePre` component of `@nuxtjs/mdc` and [code highlighting](https://content.nuxt.com/docs/files/markdown#code-highlighting) is done underneath by [Shiki](https://github.com/shikijs/shiki).

<tabs className="gap-0">
<code-preview className="[&>div]:*:my-0,[&>div]:*:w-full" label="Preview">

```ts
export default defineNuxtConfig({
  modules: ['@nuxt/ui']
})
```

<template v-slot:code="">

```mdc
```ts
export default defineNuxtConfig({
  modules: ['@nuxt/ui']
})
```
```

</template>
</code-preview>

```ts
/**
 * Props for the ProseCode component
 */
interface ProseCodeProps {
  lang?: string | undefined;
  color?: "error" | "primary" | "secondary" | "success" | "info" | "warning" | "neutral" | undefined;
}
```

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      pre: {
        slots: {
          root: 'relative my-5 group',
          header: 'flex items-center gap-1.5 border border-muted bg-default border-b-0 relative rounded-t-md px-4 py-3',
          filename: 'text-default text-sm/6',
          icon: 'size-4 shrink-0',
          copy: 'absolute top-[11px] right-[11px] lg:opacity-0 lg:group-hover:opacity-100 transition',
          base: 'group font-mono text-sm/6 border border-muted bg-muted rounded-md px-4 py-3 whitespace-pre-wrap break-words overflow-x-auto focus:outline-none'
        },
        variants: {
          filename: {
            true: {
              root: '[&>pre]:rounded-t-none [&>pre]:my-0 my-5'
            }
          }
        }
      }
    }
  }
})
```

</tabs>

### Language

Syntax highlighting is available for dozens of programming languages.

<code-preview className="[&>div]:*:my-0,[&>div]:*:w-full">

```vue
<script setup lang="ts">
const message = ref('Hello World!')

function updateMessage() {
  message.value = 'Button clicked!'
}
</script>

<template>
  <div>
    <h1>{{ message }}</h1>
    <UButton @click="updateMessage">
      Click me
    </UButton>
  </div>
</template>
```

<template v-slot:code="">

```html
```vue
<script setup lang="ts">
const message = ref('Hello World!')

function updateMessage() {
  message.value = 'Button clicked!'
}
</script>

<template>
  <div>
    <h1>{{ message }}</h1>
    <UButton @click="updateMessage">
      Click me
    </UButton>
  </div>
</template>
```
```

</template>
</code-preview>

<tip>

By default for syntax highlighting, `material-theme-lighter` and `material-theme-palenight` VSCode themes are used for light & dark mode respectively. You can change this in your `nuxt.config.ts` through the [`content.build.markdown.highlight`](https://content.nuxt.com/docs/getting-started/configuration#highlight) key.

</tip>

### Filename

Code blocks support filename display with automatic icon detection.

<code-preview className="[&>div]:*:my-0,[&>div]:*:w-full">

```ts [nuxt.config.ts]
export default defineNuxtConfig({
  modules: ['@nuxt/ui']
})
```

<template v-slot:code="">

```mdc
```ts [nuxt.config.ts]
export default defineNuxtConfig({
  modules: ['@nuxt/ui']
})
```
```

</template>
</code-preview>

<tip>

The filename icon is rendered by the `ProseCodeIcon` component and contains a set of predefined icons which you can customize in your `app.config.ts`:

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      codeIcon: {
        terminal: 'i-ph-terminal-window-duotone',
        config: 'i-lucide-settings',
        package: 'i-lucide-package'
      }
    }
  }
})
```

</tip>

### Copy button

Every code-block has a built-in copy button that will copy the code to your clipboard.

<tip>

You can change the icon in your `app.config.ts` through the `ui.icons.copy` and `ui.icons.copyCheck` keys:

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    icons: {
      copy: 'i-lucide-copy',
      copyCheck: 'i-lucide-copy-check'
    }
  }
})
```

</tip>

### Line highlighting

Highlight specific lines to draw attention to important parts.

<code-preview className="[&>div]:*:my-0,[&>div]:*:w-full">

```ts [nuxt.config.ts]
export default defineNuxtConfig({
  modules: ['@nuxt/ui'], // This line is highlighted
  css: ['~/assets/css/main.css']
})
```

<template v-slot:code="">

```mdc
```ts [nuxt.config.ts] {2}
export default defineNuxtConfig({
  modules: ['@nuxt/ui'], // This line is highlighted
  css: ['~/assets/css/main.css']
})
```
```

</template>
</code-preview>

### Code diff

Use the `diff` language to show changes between code versions.

<code-preview className="[&>div]:*:my-0,[&>div]:*:w-full">

```diff [nuxt.config.ts]
export default defineNuxtConfig({
  modules: [
-   '@nuxt/ui-pro'
+   '@nuxt/ui'
  ]
})
```

<template v-slot:code="">

```md
```diff [nuxt.config.ts]
export default defineNuxtConfig({
  modules: [
-   '@nuxt/ui-pro'
+   '@nuxt/ui'
  ]
})
```
```

</template>
</code-preview>

## Inline code

Inline code snippets are rendered by the `ProseCode` component of `@nuxtjs/mdc`.

<tabs className="gap-0">
<code-preview className="[&>div]:*:my-0" label="Preview">

`inline code`

<template v-slot:code="">

```mdc
`inline code`
```

</template>
</code-preview>

```ts
/**
 * Props for the ProseCode component
 */
interface ProseCodeProps {
  lang?: string | undefined;
  color?: "error" | "primary" | "secondary" | "success" | "info" | "warning" | "neutral" | undefined;
}
```

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      code: {
        base: 'px-1.5 py-0.5 text-sm font-mono font-medium rounded-md inline-block',
        variants: {
          color: {
            primary: 'border border-primary/25 bg-primary/10 text-primary',
            secondary: 'border border-secondary/25 bg-secondary/10 text-secondary',
            success: 'border border-success/25 bg-success/10 text-success',
            info: 'border border-info/25 bg-info/10 text-info',
            warning: 'border border-warning/25 bg-warning/10 text-warning',
            error: 'border border-error/25 bg-error/10 text-error',
            neutral: 'border border-muted text-highlighted bg-muted'
          }
        },
        defaultVariants: {
          color: 'neutral'
        }
      }
    }
  }
})
```

</tabs>

### Color

Use the `color` prop to change the color of the inline code. Defaults to `neutral`.

<code-preview className="[&>div]:*:my-0">

`inline code`

<template v-slot:code="">

```mdc
`inline code`{color="error"}
```

</template>
</code-preview>

### Lang

Use the `lang` prop to specify the language of the inline code.

<code-preview className="[&>div]:*:my-0" label="Preview">

`nuxt.config.ts`

<template v-slot:code="">

```mdc
`nuxt.config.ts`{lang="ts-type"}
```

</template>
</code-preview>
