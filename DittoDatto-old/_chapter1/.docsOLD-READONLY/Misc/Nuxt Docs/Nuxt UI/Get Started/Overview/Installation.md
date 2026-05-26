# Installation

> Learn how to install and configure Nuxt UI in your Nuxt application.

<callout icon="i-logos-vue" className="hidden" to="/docs/getting-started/installation/vue">

Looking for the **Vue** version?

</callout>

## Setup

### Add to a Nuxt project

<steps level="4">

#### Install the Nuxt UI package

<code-group sync="pm">

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

<warning>

If you're using **pnpm**, ensure that you either set [`shamefully-hoist=true`](https://pnpm.io/npmrc#shamefully-hoist) in your `.npmrc` file or install `tailwindcss` in your project's root directory.

</warning>

#### Add the Nuxt UI module in your `nuxt.config.ts`

```ts [nuxt.config.ts]
export default defineNuxtConfig({
  modules: ['@nuxt/ui']
})
```

#### Import Tailwind CSS and Nuxt UI in your CSS

<code-group>

```css [app/assets/css/main.css]
@import "tailwindcss";
@import "@nuxt/ui";
```

```ts [nuxt.config.ts]
export default defineNuxtConfig({
  modules: ['@nuxt/ui'],
  css: ['~/assets/css/main.css']
})
```

</code-group>

<callout icon="i-simple-icons-visualstudiocode">

It's recommended to install the [Tailwind CSS IntelliSense](https://marketplace.visualstudio.com/items?itemName=bradlc.vscode-tailwindcss) extension for VSCode and add the following settings:

```json [.vscode/settings.json]
{
  "files.associations": {
    "*.css": "tailwindcss"
  },
  "editor.quickSuggestions": {
    "strings": "on"
  },
  "tailwindCSS.classAttributes": ["class", "ui"],
  "tailwindCSS.experimental.classRegex": [
    ["ui:\\s*{([^)]*)\\s*}", "(?:'|\"|`)([^']*)(?:'|\"|`)"]
  ]
}
```

</callout>

#### Wrap your app with App component

```vue [app.vue]
<template>
  <UApp>
    <NuxtPage />
  </UApp>
</template>
```

<note to="/docs/components/app">

The `App` component provides global configurations and is required for **Toast**, **Tooltip** components to work as well as **Programmatic Overlays**.

</note>
</steps>

### Use a Nuxt template

To quickly get started with Nuxt UI, you can use the [starter template](https://github.com/nuxt-ui-templates/starter) by running:

```bash [Terminal]
npm create nuxt@latest -- -t ui
```

You can also get started with one of our [official templates](/templates):

<card-group>
<card color="neutral" icon="i-simple-icons-github" target="_blank" title="Starter" to="https://github.com/nuxt-ui-templates/starter">

A minimal template to get started with Nuxt UI.

</card>

<card color="neutral" icon="i-simple-icons-github" target="_blank" title="Landing" to="https://github.com/nuxt-ui-templates/landing">

A modern landing page template powered by Nuxt Content.

</card>

<card color="neutral" icon="i-simple-icons-github" target="_blank" title="Docs" to="https://github.com/nuxt-ui-templates/docs">

A documentation template powered by Nuxt Content.

</card>

<card color="neutral" icon="i-simple-icons-github" target="_blank" title="SaaS" to="https://github.com/nuxt-ui-templates/saas">

A SaaS template with landing, pricing, docs and blog powered by Nuxt Content.

</card>

<card color="neutral" icon="i-simple-icons-github" target="_blank" title="Dashboard" to="https://github.com/nuxt-ui-templates/dashboard" variant="subtle">

A dashboard template with multi-column layout for building sophisticated admin interfaces.

</card>

<card color="neutral" icon="i-simple-icons-github" target="_blank" title="Chat" to="https://github.com/nuxt-ui-templates/chat">

An AI chatbot template to build your own chatbot powered by Nuxt MDC and Vercel AI SDK.

</card>

<card color="neutral" icon="i-simple-icons-github" target="_blank" title="Portfolio" to="https://github.com/nuxt-ui-templates/portfolio">

A sleek portfolio template to showcase your work, skills and blog powered by Nuxt Content.

</card>

<card color="neutral" icon="i-simple-icons-github" target="_blank" title="Changelog" to="https://github.com/nuxt-ui-templates/changelog">

A changelog template to display your repository releases notes from GitHub powered by Nuxt MDC.

</card>
</card-group>

You can use the `Use this template` button on GitHub to create a new repository or use the CLI:

<code-group>

```bash [Starter]
npm create nuxt@latest -- -t ui
```

```bash [Landing]
npm create nuxt@latest -- -t ui/landing
```

```bash [Docs]
npm create nuxt@latest -- -t ui/docs
```

```bash [SaaS]
npm create nuxt@latest -- -t ui/saas
```

```bash [Dashboard]
npm create nuxt@latest -- -t ui/dashboard
```

```bash [Chat]
npm create nuxt@latest -- -t ui/chat
```

```bash [Portfolio]
npm create nuxt@latest -- -t ui/portfolio
```

```bash [Changelog]
npm create nuxt@latest -- -t ui/changelog
```

</code-group>

## Options

You can customize Nuxt UI by providing options in your `nuxt.config.ts`.

### `prefix`

Use the `prefix` option to change the prefix of the components.

- Default: `U`

```ts [nuxt.config.ts]
export default defineNuxtConfig({
  modules: ['@nuxt/ui'],
  css: ['~/assets/css/main.css'],
  ui: {
    prefix: 'Nuxt'
  }
})
```

### `fonts`

Use the `fonts` option to enable or disable the [`@nuxt/fonts`](https://github.com/nuxt/fonts) module.

- Default: `true`

```ts [nuxt.config.ts]
export default defineNuxtConfig({
  modules: ['@nuxt/ui'],
  css: ['~/assets/css/main.css'],
  ui: {
    fonts: false
  }
})
```

### `colorMode`

Use the `colorMode` option to enable or disable the [`@nuxt/color-mode`](https://github.com/nuxt-modules/color-mode) module.

- Default: `true`

```ts [nuxt.config.ts]
export default defineNuxtConfig({
  modules: ['@nuxt/ui'],
  css: ['~/assets/css/main.css'],
  ui: {
    colorMode: false
  }
})
```

### `theme.colors`

Use the `theme.colors` option to define the dynamic color aliases used to generate components theme.

- Default: `['primary', 'secondary', 'success', 'info', 'warning', 'error']`

```ts [nuxt.config.ts]
export default defineNuxtConfig({
  modules: ['@nuxt/ui'],
  css: ['~/assets/css/main.css'],
  ui: {
    theme: {
      colors: ['primary', 'error']
    }
  }
})
```

<tip to="/docs/getting-started/theme/design-system#colors">

Learn more about color customization and theming in the Theme section.

</tip>

### `theme.transitions`

Use the `theme.transitions` option to enable or disable transitions on components.

- Default: `true`

```ts [nuxt.config.ts]
export default defineNuxtConfig({
  modules: ['@nuxt/ui'],
  css: ['~/assets/css/main.css'],
  ui: {
    theme: {
      transitions: false
    }
  }
})
```

<note>

This option adds the `transition-colors` class on components with hover or active states.

</note>

### `theme.defaultVariants`

Use the `theme.defaultVariants` option to override the default `color` and `size` variants for components.

- Default: `{ color: 'primary', size: 'md' }`

```ts [nuxt.config.ts]
export default defineNuxtConfig({
  modules: ['@nuxt/ui'],
  css: ['~/assets/css/main.css'],
  ui: {
    theme: {
      defaultVariants: {
        color: 'neutral',
        size: 'sm'
      }
    }
  }
})
```

### `theme.prefix` <badge label="4.2+"></badge>

Use the `theme.prefix` option to configure the same prefix you set on your Tailwind CSS import. This ensures Nuxt UI components use the correct prefixed utility classes and CSS variables.

<code-group>

```ts [nuxt.config.ts]
export default defineNuxtConfig({
  modules: ['@nuxt/ui'],
  css: ['~/assets/css/main.css'],
  ui: {
    theme: {
      prefix: 'tw'
    }
  }
})
```

```css [app/assets/css/main.css]
@import "tailwindcss" prefix(tw);
@import "@nuxt/ui";
```

</code-group>

<warning to="https://fonts.nuxt.com/get-started/configuration#processcssvariables">

You might need to enable `fonts.processCSSVariables` to use the prefix option with the `@nuxt/fonts` module:

```ts [nuxt.config.ts]
export default defineNuxtConfig({
  modules: ['@nuxt/ui'],
  css: ['~/assets/css/main.css'],
  ui: {
    theme: {
      prefix: 'tw'
    }
  },
  fonts: {
    processCSSVariables: true
  }
})
```

</warning>

This will automatically prefix all Tailwind utility classes and CSS variables in Nuxt UI component themes:

```html
<!-- Without prefix -->
<button class="px-2 py-1 text-xs hover:bg-primary/75">Button</button>

<!-- With prefix: tw -->
<button class="tw:px-2 tw:py-1 tw:text-xs tw:hover:bg-primary/75">Button</button>
```

<note to="https://tailwindcss.com/docs/styling-with-utility-classes#using-the-prefix-option" target="_blank">

Learn more about using a prefix in the Tailwind CSS documentation.

</note>

### `mdc`

Use the `mdc` option to force the import of Nuxt UI `<Prose>` components even if `@nuxtjs/mdc` or `@nuxt/content` is not installed.

- Default: `false`

```ts [nuxt.config.ts]
export default defineNuxtConfig({
  modules: ['@nuxt/ui'],
  css: ['~/assets/css/main.css'],
  ui: {
    mdc: true
  }
})
```

### `content`

Use the `content` option to force the import of Nuxt UI `<Prose>` and `<UContent>` components even if `@nuxt/content` is not installed (`@nuxtjs/mdc` is installed by `@nuxt/content`).

- Default: `false`

```ts [nuxt.config.ts]
export default defineNuxtConfig({
  modules: ['@nuxt/ui'],
  css: ['~/assets/css/main.css'],
  ui: {
    content: true
  }
})
```

### `experimental.componentDetection` <badge label="4.1+"></badge>

Use the `experimental.componentDetection` option to enable automatic component detection for tree-shaking. This feature scans your source code to detect which components are actually used and only generates the necessary CSS for those components (including their dependencies).

- Default: `false`
- Type: `boolean | string[]`

**Enable automatic detection:**

```ts [nuxt.config.ts]
export default defineNuxtConfig({
  modules: ['@nuxt/ui'],
  css: ['~/assets/css/main.css'],
  ui: {
    experimental: {
      componentDetection: true
    }
  }
})
```

**Include additional components for dynamic usage:**

```ts [nuxt.config.ts]
export default defineNuxtConfig({
  modules: ['@nuxt/ui'],
  css: ['~/assets/css/main.css'],
  ui: {
    experimental: {
      componentDetection: ['Modal', 'Dropdown', 'Popover']
    }
  }
})
```

<note>

When providing an array of component names, automatic detection is enabled and these components (along with their dependencies) are guaranteed to be included. This is useful for dynamic components like `<component :is="..." />` that can't be statically analyzed.

</note>

## Continuous releases

Nuxt UI uses [pkg.pr.new](https://github.com/stackblitz-labs/pkg.pr.new) for continuous preview releases, providing developers with instant access to the latest features and bug fixes without waiting for official releases.

Automatic preview releases are created for all commits and PRs to the `v4` branch. Use them by replacing your package version with the specific commit hash or PR number.

```diff [package.json]
{
  "dependencies": {
-   "@nuxt/ui": "^4.0.0",
+   "@nuxt/ui": "https://pkg.pr.new/@nuxt/ui@4c96909",
  }
}
```

<note>

**pkg.pr.new** will automatically comment on PRs with the installation URL, making it easy to test changes.

</note>
