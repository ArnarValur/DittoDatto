# Design System

> Nuxt UI's design system uses Tailwind CSS for simple theming and easy customization.

## Tailwind CSS

Tailwind CSS uses a CSS-first configuration, letting you define your design tokens with the [`@theme`](https://tailwindcss.com/docs/functions-and-directives#theme-directive) directive directly in your CSS. This makes your theme portable, maintainable and easy to customize.

```css [app/assets/css/main.css]
@import "tailwindcss";
@import "@nuxt/ui";

@theme {
  /* Your custom design tokens go here */
}
```

<note to="https://tailwindcss.com/docs/theme" target="_blank">

Check the Tailwind CSS documentation for all available theme variable customization options.

</note>

### Fonts

Use the `--font-*` theme variables to [customize the font family utilities](https://tailwindcss.com/docs/font-family#customizing-your-theme) in your project.

```css [app/assets/css/main.css]
@import "tailwindcss";
@import "@nuxt/ui";

@theme {
  --font-sans: 'Public Sans', system-ui, sans-serif;
  --font-mono: 'JetBrains Mono', monospace;
}
```

<framework-only>
<template v-slot:nuxt="">
<note to="/docs/getting-started/integrations/fonts">

Fonts defined here are automatically loaded and optimized by the `@nuxt/fonts` module.

</note>
</template>
</framework-only>

### Colors

Use the `--color-*` theme variables to [customize your colors](https://tailwindcss.com/docs/colors#customizing-your-colors) or [override default colors](https://tailwindcss.com/docs/colors#overriding-default-colors).

```css [app/assets/css/main.css]
@import "tailwindcss";
@import "@nuxt/ui";

@theme static {
  /* Override default green color */
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

  /* Define new custom color */
  --color-brand-50: #fef2f2;
  --color-brand-100: #fee2e2;
  --color-brand-200: #fecaca;
  --color-brand-300: #fca5a5;
  --color-brand-400: #f87171;
  --color-brand-500: #ef4444;
  --color-brand-600: #dc2626;
  --color-brand-700: #b91c1c;
  --color-brand-800: #991b1b;
  --color-brand-900: #7f1d1d;
  --color-brand-950: #450a0a;
}
```

<warning>

When adding custom colors, make sure to define all shades from `50` to `950` for each color.

</warning>

### Breakpoints

Use the `--breakpoint-*` theme variables to [customize your breakpoints](https://tailwindcss.com/docs/responsive-design#customizing-your-theme).

```css [app/assets/css/main.css]
@import "tailwindcss";
@import "@nuxt/ui";

@theme {
  --breakpoint-3xl: 1920px;
  --breakpoint-4xl: 2560px;
  --breakpoint-5xl: 3840px;
}
```

## Colors

Nuxt UI's color system is designed around **semantic naming** rather than specific color values. This approach makes your UI more maintainable and allows for easy theme switching.

### Semantic colors

Nuxt UI provides semantic color aliases that describe the **purpose** of the color. Each alias is defined based on a color from your `@theme` configuration, which can be any color you define in addition to the [default Tailwind CSS palette](https://tailwindcss.com/docs/colors).

<table>
<thead>
  <tr>
    <th>
      Color
    </th>
    
    <th>
      Default
    </th>
    
    <th>
      Description
    </th>
  </tr>
</thead>

<tbody>
  <tr>
    <td>
      <code color="primary">
        primary
      </code>
    </td>
    
    <td>
      <code>
        green
      </code>
    </td>
    
    <td>
      Main CTAs, active navigation, brand elements, important links
    </td>
  </tr>
  
  <tr>
    <td>
      <code color="secondary">
        secondary
      </code>
    </td>
    
    <td>
      <code>
        blue
      </code>
    </td>
    
    <td>
      Secondary buttons, alternative actions, complementary UI elements
    </td>
  </tr>
  
  <tr>
    <td>
      <code color="success">
        success
      </code>
    </td>
    
    <td>
      <code>
        green
      </code>
    </td>
    
    <td>
      Success messages, completed states, positive confirmations
    </td>
  </tr>
  
  <tr>
    <td>
      <code color="info">
        info
      </code>
    </td>
    
    <td>
      <code>
        blue
      </code>
    </td>
    
    <td>
      Info alerts, tooltips, help text, neutral notifications
    </td>
  </tr>
  
  <tr>
    <td>
      <code color="warning">
        warning
      </code>
    </td>
    
    <td>
      <code>
        yellow
      </code>
    </td>
    
    <td>
      Warning messages, pending states, attention-needed items
    </td>
  </tr>
  
  <tr>
    <td>
      <code color="error">
        error
      </code>
    </td>
    
    <td>
      <code>
        red
      </code>
    </td>
    
    <td>
      Error messages, validation errors, destructive actions
    </td>
  </tr>
  
  <tr>
    <td>
      <code>
        neutral
      </code>
    </td>
    
    <td>
      <code>
        slate
      </code>
    </td>
    
    <td>
      Text, borders, backgrounds, disabled states
    </td>
  </tr>
</tbody>
</table>

These semantic colors are available in the `color` prop of Nuxt UI components:

```vue
<template>
  <UDesign System color="primary">
    Save Changes
  </UDesign System>
</template>
```

<note>

Try the <prose-icon className="text-primary" name="i-lucide-swatch-book">



</prose-icon>

 theme picker in the header to instantly see how different color schemes affect the entire UI!

</note>

### Runtime configuration

<framework-only>
<template v-slot:nuxt="">
<div>

You can configure these colors at runtime in your [`app.config.ts`](https://nuxt.com/docs/guide/directory-structure/app-config#app-config-file) file under the `ui.colors` key, allowing for dynamic theme customization without restarting the server:

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    colors: {
      primary: 'blue',
      secondary: 'purple',
      neutral: 'zinc'
    }
  }
})
```

</div>
</template>

<template v-slot:vue="">
<div>

You can configure these colors at runtime in your `vite.config.ts` file under the `ui.colors` key, allowing for dynamic theme customization:

```ts [vite.config.ts]
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import ui from '@nuxt/ui/vite'

export default defineConfig({
  plugins: [
    vue(),
    ui({
      ui: {
        colors: {
          primary: 'blue',
          secondary: 'purple',
          neutral: 'zinc'
        }
      }
    })
  ]
})
```

</div>
</template>
</framework-only>

<caution>

You can only use colors that exist in your theme. Either:

- Use [Tailwind's default colors](https://tailwindcss.com/docs/colors) (like `blue`, `green`, `zinc`)
- Define custom colors first using the `@theme` directive (like `brand` in our example above)

</caution>

### Extend colors

You may want to define extra semantic colors beyond the defaults, such as adding a `tertiary` color:

<framework-only>
<template v-slot:nuxt="">
<div>

First, register the new color in your `nuxt.config.ts` under the `ui.theme.colors` key:

```ts [nuxt.config.ts]
export default defineNuxtConfig({
  ui: {
    theme: {
      colors: [
        'primary',
        'secondary',
        'tertiary',
        'info',
        'success',
        'warning',
        'error'
      ]
    }
  }
})
```

Then, assign it in your `app.config.ts` under the `ui.colors` key:

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    colors: {
      primary: 'blue',
      secondary: 'purple',
      tertiary: 'indigo'
    }
  }
})
```

</div>
</template>

<template v-slot:vue="">
<div>

Register and assign the new color in your `vite.config.ts` file:

```ts [vite.config.ts]
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
import ui from '@nuxt/ui/vite'

export default defineConfig({
  plugins: [
    vue(),
    ui({
      theme: {
        colors: [
          'primary',
          'secondary',
          'tertiary',
          'info',
          'success',
          'warning',
          'error'
        ]
      },
      ui: {
        colors: {
          primary: 'blue',
          secondary: 'purple',
          tertiary: 'indigo'
        }
      }
    })
  ]
})
```

</div>
</template>
</framework-only>

Finally, use this new color in components that support the `color` prop or [as a class](/docs/getting-started/theme/css-variables):

```vue
<UButton color="tertiary">
  Special Action
</UButton>
```
