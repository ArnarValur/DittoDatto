# Icons

> Nuxt UI integrates with Nuxt Icon to access over 200,000+ icons from Iconify.

<callout className="hidden" icon="i-logos-vue" to="/docs/getting-started/integrations/icons/vue">

Looking for the **Vue** version?

</callout>

## Usage

Nuxt UI automatically registers the [`@nuxt/icon`](https://github.com/nuxt/icon) module for you, so there's no additional setup required.

### Icon component

You can use the [Icon](/docs/components/icon) component with a `name` prop to display an icon:

```vue
<template>
  <UIcons name="i-lucide-lightbulb" class="size-5" />
</template>
```

<note>

You can use any name from the [https://icones.js.org](https://icones.js.org) collection.

</note>

### Component props

Some components also have an `icon` prop to display an icon, like the [Button](/docs/components/button) for example:

```vue
<template>
  <UIcons icon="i-lucide-sun" variant="subtle">
    Button
  </UIcons>
</template>
```

## Collections

### Iconify dataset

It's highly recommended to install the icon data locally with:

<code-group sync="pm">

```bash [pnpm]
pnpm i @iconify-json/{collection_name}
```

```bash [yarn]
yarn add @iconify-json/{collection_name}
```

```bash [npm]
npm install @iconify-json/{collection_name}
```

</code-group>

For example, to use the `i-uil-github` icon, install its collection with `@iconify-json/uil`. This way the icons can be served locally or from your serverless functions, which is faster and more reliable on both SSR and client-side.

<note target="_blank" to="https://github.com/nuxt/icon?tab=readme-ov-file#iconify-dataset">

Read more about this in the `@nuxt/icon` documentation.

</note>

### Custom local collections

You can use local SVG files to create a custom Iconify collection.

For example, place your icons' SVG files under a folder of your choice, for example, `./app/assets/icons`:

```bash
assets/icons
├── add.svg
└── remove.svg
```

In your `nuxt.config.ts`, add an item in `icon.customCollections`:

```ts
export default defineNuxtConfig({
  modules: ['@nuxt/ui'],
  css: ['~/assets/css/main.css'],
  icon: {
    customCollections: [{
      prefix: 'custom',
      dir: './app/assets/icons'
    }]
  }
})
```

Then you can use the icons like this:

```vue
<template>
  <UIcon name="i-custom-add" />
</template>
```

<note target="_blank" to="https://github.com/nuxt/icon?tab=readme-ov-file#custom-local-collections">

Read more about this in the `@nuxt/icon` documentation.

</note>

## Theme

You can change the default icons used by components in your `app.config.ts`:

<icons-theme>



</icons-theme>
