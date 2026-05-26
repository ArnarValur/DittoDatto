# CodeTree

> Visualize file and folder structures with syntax-highlighted code.

## Usage

Wrap your code blocks with a `code-tree` component in any particular order to display a tree view of your files.

<code-preview className="[&>div]:*:my-0,[&>div]:*:w-full">
<code-tree default-value="app/app.config.ts">

```ts [nuxt.config.ts]
export default defineNuxtConfig({
  modules: ['@nuxt/ui'],

  css: ['~/assets/css/main.css']
})
```

```css [app/assets/css/main.css]
@import "tailwindcss";
@import "@nuxt/ui";
```

```ts [app/app.config.ts]
export default defineAppConfig({
  ui: {
    colors: {
      primary: 'sky',
      colors: 'slate'
    }
  }
})
```

```vue [app/app.vue]
<template>
  <UApp>
    <NuxtPage />
  </UApp>
</template>
```

```json [package.json]
{
  "name": "nuxt-app",
  "private": true,
  "type": "module",
  "scripts": {
    "build": "nuxt build",
    "dev": "nuxt dev",
    "generate": "nuxt generate",
    "preview": "nuxt preview",
    "postinstall": "nuxt prepare",
    "typecheck": "nuxt typecheck"
  },
  "dependencies": {
    "@iconify-json/lucide": "^1.2.18",
    "@nuxt/ui": "^4.0.0",
    "nuxt": "^4.0.0"
  },
  "devDependencies": {
    "typescript": "^5.8.2",
    "vue-tsc": "^2.2.10"
  }
}
```

```json [tsconfig.json]
{
  "extends": "./.nuxt/tsconfig.json"
}
```

```md [README.md]
# Nuxt 4 Minimal Starter

Look at the [Nuxt 4 documentation](https://nuxt.com/docs/getting-started/introduction) to learn more.

## Setup

Make sure to install the dependencies:

```bash
# npm
npm install

# pnpm
pnpm install

# yarn
yarn install

# bun
bun install
```

## Development server

Start the development server on `http://localhost:3000`:

```bash
# npm
npm run dev

# pnpm
pnpm run dev

# yarn
yarn dev

# bun
bun run dev
```

## Production

Build the application for production:

```bash
# npm
npm run build

# pnpm
pnpm run build

# yarn
yarn build

# bun
bun run build
```

Locally preview production build:

```bash
# npm
npm run preview

# pnpm
pnpm run preview

# yarn
yarn preview

# bun
bun run preview
```

Check out the [deployment documentation](https://nuxt.com/docs/getting-started/deployment) for more information.
```

</code-tree>

<template v-slot:code="">
<code-collapse className="[&>div>pre]:rounded-t-none,[&>div]:my-0">

```mdc
::code-tree{defaultValue="app/app.config.ts"}

```ts [nuxt.config.ts]
export default defineNuxtConfig({
  modules: ['@nuxt/ui'],

  css: ['~/assets/css/main.css']
})

```

```css [app/assets/css/main.css]
@import "tailwindcss";
@import "@nuxt/ui";
```

```ts [app/app.config.ts]
export default defineAppConfig({
  ui: {
    colors: {
      primary: 'sky',
      colors: 'slate'
    }
  }
})
```

```vue [app/app.vue]
<template>
  <UApp>
    <NuxtPage />
  </UApp>
</template>
```

```json [package.json]
{
  "name": "nuxt-app",
  "private": true,
  "type": "module",
  "scripts": {
    "build": "nuxt build",
    "dev": "nuxt dev",
    "generate": "nuxt generate",
    "preview": "nuxt preview",
    "postinstall": "nuxt prepare",
    "typecheck": "nuxt typecheck"
  },
  "dependencies": {
    "@iconify-json/lucide": "^1.2.18",
    "@nuxt/ui": "^4.0.0",
    "nuxt": "^4.0.0"
  },
  "devDependencies": {
    "typescript": "^5.8.2",
    "vue-tsc": "^2.2.10"
  }
}
```

```json [tsconfig.json]
{
  "extends": "./.nuxt/tsconfig.json"
}
```

````md [README.md]
# Nuxt 4 Minimal Starter

Look at the [Nuxt 4 documentation](https://nuxt.com/docs/getting-started/introduction) to learn more.

## Setup

Make sure to install the dependencies:

```bash
# npm
npm install

# pnpm
pnpm install

# yarn
yarn install

# bun
bun install
```

## Development server

Start the development server on `http://localhost:3000`:

```bash
# npm
npm run dev

# pnpm
pnpm run dev

# yarn
yarn dev

# bun
bun run dev
```

## Production

Build the application for production:

```bash
# npm
npm run build

# pnpm
pnpm run build

# yarn
yarn build

# bun
bun run build
```

Locally preview production build:

```bash
# npm
npm run preview

# pnpm
pnpm run preview

# yarn
yarn preview

# bun
bun run preview
```

Check out the [deployment documentation](https://nuxt.com/docs/getting-started/deployment) for more information.
````

::
```

</code-collapse>
</template>
</code-preview>

<note to="/docs/typography/code#code-blocks">

Like the `ProsePre` component, the `CodeTree` handles filenames, icons and copy button.

</note>

## API

### Props

```ts
/**
 * Props for the ProseCodeTree component
 */
interface ProseCodeTreeProps {
  /**
   * The default path to select.
   */
  defaultValue?: string | undefined;
  /**
   * Expand all directories by default.
   */
  expandAll?: boolean | undefined;
  ui?: { root?: ClassNameValue; list?: ClassNameValue; item?: ClassNameValue; listWithChildren?: ClassNameValue; itemWithChildren?: ClassNameValue; link?: ClassNameValue; linkLeadingIcon?: ClassNameValue; linkLabel?: ClassNameValue; linkTrailing?: ClassNameValue; linkTrailingIcon?: ClassNameValue; content?: ClassNameValue; } | undefined;
}
```

### Slots

```ts
/**
 * Slots for the CodeTree component
 */
interface CodeTreeSlots {
  default(): any;
}
```

## Theme

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      codeTree: {
        slots: {
          root: 'relative lg:h-[450px] my-5 grid lg:grid-cols-3 border border-muted rounded-md',
          list: 'isolate relative p-2 border-b lg:border-b-0 lg:border-e border-muted overflow-y-auto',
          item: '',
          listWithChildren: 'ms-4.5 border-s border-default',
          itemWithChildren: 'ps-1.5 -ms-px',
          link: 'relative group peer w-full px-2.5 py-1.5 before:inset-y-px before:inset-x-0 flex items-center gap-1.5 text-sm before:absolute before:z-[-1] before:rounded-md focus:outline-none focus-visible:outline-none focus-visible:before:ring-inset focus-visible:before:ring-2',
          linkLeadingIcon: 'size-4 shrink-0',
          linkLabel: 'truncate',
          linkTrailing: 'ms-auto inline-flex gap-1.5 items-center',
          linkTrailingIcon: 'size-5 transform transition-transform duration-200 shrink-0 group-data-expanded:rotate-180',
          content: 'overflow-hidden lg:col-span-2 flex flex-col [&>div]:my-0 [&>div]:flex-1 [&>div]:flex [&>div]:flex-col [&>div>div]:border-0 [&>div>pre]:border-b-0 [&>div>pre]:border-s-0 [&>div>pre]:border-e-0 [&>div>pre]:rounded-l-none [&>div>pre]:flex-1 [&>div]:overflow-y-auto'
        },
        variants: {
          active: {
            true: {
              link: 'text-highlighted before:bg-elevated'
            },
            false: {
              link: [
                'hover:text-highlighted hover:before:bg-elevated/50',
                'transition-colors before:transition-colors'
              ]
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
