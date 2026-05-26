# CSS Variables

> Nuxt UI uses CSS variables as design tokens for flexible, consistent theming with built-in light and dark mode support.

## Colors

Nuxt UI provides Tailwind CSS utility classes for each [semantic color](/docs/getting-started/theme/design-system#semantic-colors) you define, allowing you to use class names like `text-error` or `bg-success`:

<code-preview>
<span className="text-primary,text-sm,px-4,py-1.5,inline-block">

Primary

</span>

<span className="text-secondary,text-sm,px-4,py-1.5,inline-block">

Secondary

</span>

<span className="text-success,text-sm,px-4,py-1.5,inline-block">

Success

</span>

<span className="text-info,text-sm,px-4,py-1.5,inline-block">

Info

</span>

<span className="text-warning,text-sm,px-4,py-1.5,inline-block">

Warning

</span>

<span className="text-error,text-sm,px-4,py-1.5,inline-block">

Error

</span>



<template v-slot:code="">

```vue
<template>
  <span class="text-primary">Primary</span>
  <span class="text-secondary">Secondary</span>
  <span class="text-success">Success</span>
  <span class="text-info">Info</span>
  <span class="text-warning">Warning</span>
  <span class="text-error">Error</span>
</template>
```

</template>
</code-preview>

Each utility class uses a CSS variable to set its color for light and dark modes:

<code-group>

```css [Light]
:root {
  --ui-primary: var(--ui-color-primary-500);
  --ui-secondary: var(--ui-color-secondary-500);
  --ui-success: var(--ui-color-success-500);
  --ui-info: var(--ui-color-info-500);
  --ui-warning: var(--ui-color-warning-500);
  --ui-error: var(--ui-color-error-500);
}
```

```css [Dark]
.dark {
  --ui-primary: var(--ui-color-primary-400);
  --ui-secondary: var(--ui-color-secondary-400);
  --ui-success: var(--ui-color-success-400);
  --ui-info: var(--ui-color-info-400);
  --ui-warning: var(--ui-color-warning-400);
  --ui-error: var(--ui-color-error-400);
}
```

</code-group>

<tip>

You can adjust which shade each utility class uses for light and dark mode in your `main.css` file:

```css [app/assets/css/main.css]
@import "tailwindcss";
@import "@nuxt/ui";

:root {
  --ui-primary: var(--ui-color-primary-700);
}

.dark {
  --ui-primary: var(--ui-color-primary-200);
}
```

</tip>

<warning>

You can't use `primary: 'black'` in your [**config**](/docs/getting-started/theme/design-system#runtime-configuration) because `black` doesn't have multiple shades. To use solid black or white as your primary color, set it directly in your `main.css` file:

```css [app/assets/css/main.css]
@import "tailwindcss";
@import "@nuxt/ui";

:root {
  --ui-primary: black;
}

.dark {
  --ui-primary: white;
}
```

</warning>

## Text

Nuxt UI provides Tailwind CSS utility classes for text colors, allowing you to use class names like `text-dimmed` or `text-muted`:

<code-preview>
<span className="text-dimmed,text-sm,px-4,py-1.5,inline-block,rounded-md">

Dimmed

</span>

<span className="text-muted,text-sm,px-4,py-1.5,inline-block,rounded-md">

Muted

</span>

<span className="text-toned,text-sm,px-4,py-1.5,inline-block,rounded-md">

Toned

</span>

<span className="text-default,text-sm,px-4,py-1.5,inline-block,rounded-md">

Text

</span>

<span className="text-highlighted,text-sm,px-4,py-1.5,inline-block,rounded-md">

Highlighted

</span>

<span className="text-inverted,bg-inverted,text-sm,px-4,py-1.5,inline-block,rounded-md">

Inverted

</span>



<template v-slot:code="">

```vue
<template>
  <span class="text-dimmed">Dimmed</span>
  <span class="text-muted">Muted</span>
  <span class="text-toned">Toned</span>
  <span class="text-default">Text</span>
  <span class="text-highlighted">Highlighted</span>
  <span class="text-inverted bg-inverted">Inverted</span>
</template>
```

</template>
</code-preview>

Each utility class uses a CSS variable to set its color for light and dark modes:

<code-group>

```css [Light]
:root {
  --ui-text-dimmed: var(--ui-color-neutral-400);
  --ui-text-muted: var(--ui-color-neutral-500);
  --ui-text-toned: var(--ui-color-neutral-600);
  --ui-text: var(--ui-color-neutral-700);
  --ui-text-highlighted: var(--ui-color-neutral-900);
  --ui-text-inverted: white;
}
```

```css [Dark]
.dark {
  --ui-text-dimmed: var(--ui-color-neutral-500);
  --ui-text-muted: var(--ui-color-neutral-400);
  --ui-text-toned: var(--ui-color-neutral-300);
  --ui-text: var(--ui-color-neutral-200);
  --ui-text-highlighted: white;
  --ui-text-inverted: var(--ui-color-neutral-900);
}
```

</code-group>

<tip>

You can customize these CSS variables in your `main.css` file:

```css [app/assets/css/main.css]
@import "tailwindcss";
@import "@nuxt/ui";

:root {
  --ui-text: var(--ui-color-neutral-900);
}

.dark {
  --ui-text: white;
}
```

</tip>

## Background

Nuxt UI provides Tailwind CSS utility classes for background colors, allowing you to use class names like `bg-default` or `bg-muted`:

<code-preview>
<span className="bg-default,text-sm,px-4,py-1.5,inline-block,rounded-md,mr-2">

Default

</span>

<span className="bg-muted,text-sm,px-4,py-1.5,inline-block,rounded-md,mr-2">

Muted

</span>

<span className="bg-elevated,text-sm,px-4,py-1.5,inline-block,rounded-md,mr-2">

Elevated

</span>

<span className="bg-accented,text-sm,px-4,py-1.5,inline-block,rounded-md,mr-2">

Accented

</span>

<span className="bg-inverted,text-inverted,text-sm,px-4,py-1.5,inline-block,rounded-md">

Inverted

</span>



<template v-slot:code="">

```vue
<template>
  <div class="bg-default">Default</div>
  <div class="bg-muted">Muted</div>
  <div class="bg-elevated">Elevated</div>
  <div class="bg-accented">Accented</div>
  <div class="bg-inverted text-inverted">Inverted</div>
</template>
```

</template>
</code-preview>

Each utility class uses a CSS variable to set its color for light and dark modes:

<code-group>

```css [Light]
:root {
  --ui-bg: white;
  --ui-bg-muted: var(--ui-color-neutral-50);
  --ui-bg-elevated: var(--ui-color-neutral-100);
  --ui-bg-accented: var(--ui-color-neutral-200);
  --ui-bg-inverted: var(--ui-color-neutral-900);
}
```

```css [Dark]
.dark {
  --ui-bg: var(--ui-color-neutral-900);
  --ui-bg-muted: var(--ui-color-neutral-800);
  --ui-bg-elevated: var(--ui-color-neutral-800);
  --ui-bg-accented: var(--ui-color-neutral-700);
  --ui-bg-inverted: white;
}
```

</code-group>

<tip>

You can customize these CSS variables in your `main.css` file:

```css [app/assets/css/main.css]
@import "tailwindcss";
@import "@nuxt/ui";

:root {
  --ui-bg: var(--ui-color-neutral-50);
}

.dark {
  --ui-bg: var(--ui-color-neutral-950);
}
```

</tip>

## Border

Nuxt UI provides Tailwind CSS utility classes for border colors, allowing you to use class names like `border-default` or `border-muted`:

<code-preview>
<span className="border-2,border-default,text-sm,px-4,py-1.5,inline-block,rounded-md,mr-2">

Default

</span>

<span className="border-2,border-muted,text-sm,px-4,py-1.5,inline-block,rounded-md,mr-2">

Muted

</span>

<span className="border-2,border-accented,text-sm,px-4,py-1.5,inline-block,rounded-md,mr-2">

Accented

</span>

<span className="border-2,border-inverted,text-sm,px-4,py-1.5,inline-block,rounded-md">

Inverted

</span>



<template v-slot:code="">

```vue
<template>
  <div class="border border-default">Default</div>
  <div class="border border-muted">Muted</div>
  <div class="border border-accented">Accented</div>
  <div class="border border-inverted">Inverted</div>
</template>
```

</template>
</code-preview>

Each utility class uses a CSS variable to set its color for light and dark modes:

<code-group>

```css [Light]
:root {
  --ui-border: var(--ui-color-neutral-200);
  --ui-border-muted: var(--ui-color-neutral-200);
  --ui-border-accented: var(--ui-color-neutral-300);
  --ui-border-inverted: var(--ui-color-neutral-900);
}
```

```css [Dark]
.dark {
  --ui-border: var(--ui-color-neutral-800);
  --ui-border-muted: var(--ui-color-neutral-700);
  --ui-border-accented: var(--ui-color-neutral-700);
  --ui-border-inverted: white;
}
```

</code-group>

<tip>

You can customize these CSS variables in your `main.css` file:

```css [app/assets/css/main.css]
@import "tailwindcss";
@import "@nuxt/ui";

:root {
  --ui-border: var(--ui-color-neutral-100);
}

.dark {
  --ui-border: var(--ui-color-neutral-900);
}
```

</tip>

## Radius

Nuxt UI overrides Tailwind CSS's default `rounded-*` utilities with a unified border radius system, allowing you to use regular [border radius utilities](https://tailwindcss.com/docs/border-radius) like `rounded-xs` or `rounded-2xl`:

<code-preview>
<span className="border-2,border-accented,text-sm,px-4,py-1.5,inline-block,rounded-xs,mr-2">

xs

</span>

<span className="border-2,border-accented,text-sm,px-4,py-1.5,inline-block,rounded-sm,mr-2">

sm

</span>

<span className="border-2,border-accented,text-sm,px-4,py-1.5,inline-block,rounded-md,mr-2">

md

</span>

<span className="border-2,border-accented,text-sm,px-4,py-1.5,inline-block,rounded-lg,mr-2">

lg

</span>

<span className="border-2,border-accented,text-sm,px-4,py-1.5,inline-block,rounded-xl,mr-2">

xl

</span>

<span className="border-2,border-accented,text-sm,px-4,py-1.5,inline-block,rounded-2xl,mr-2">

2xl

</span>

<span className="border-2,border-accented,text-sm,px-4,py-1.5,inline-block,rounded-3xl,mr-2">

3xl

</span>



<template v-slot:code="">

```vue
<template>
  <div class="rounded-xs">xs</div>
  <div class="rounded-sm">sm</div>
  <div class="rounded-md">md</div>
  <div class="rounded-lg">lg</div>
  <div class="rounded-xl">xl</div>
  <div class="rounded-2xl">2xl</div>
  <div class="rounded-3xl">3xl</div>
</template>
```

</template>
</code-preview>

These utility classes are calculated based on a global `--ui-radius` CSS variable, which defines the base radius value applied across all components for a consistent look.

```css
:root {
  --ui-radius: 0.25rem;
}
```

<tip>

You can customize the base radius value in your `main.css` file:

```css [app/assets/css/main.css]
@import "tailwindcss";
@import "@nuxt/ui";

:root {
  --ui-radius: 0.5rem;
}
```

</tip>

<note>

Try the <prose-icon className="text-primary" name="i-lucide-swatch-book">



</prose-icon>

 theme picker in the header above to change the base radius value.

</note>

## Container

Nuxt UI provides a `--ui-container` CSS variable that controls the maximum width of the [Container](/docs/components/container) component.

```css
:root {
  --ui-container: 80rem; /* var(--container-7xl) */
}
```

<tip>

You can customize this value in your `main.css` file to adjust container widths consistently throughout your application:

```css [app/assets/css/main.css]
@import "tailwindcss";
@import "@nuxt/ui";

@theme {
  --container-8xl: 90rem;
}

:root {
  --ui-container: var(--container-8xl);
}
```

</tip>

## Header

Nuxt UI provides a `--ui-header-height` CSS variable that controls the height of the [Header](/docs/components/header) component.

```css
:root {
  --ui-header-height: --spacing(16);
}
```

<tip>

You can customize this value in your `main.css` to adjust header height consistently throughout your application:

```css [app/assets/css/main.css]
@import "tailwindcss";
@import "@nuxt/ui";

:root {
  --ui-header-height: --spacing(24);
}
```

</tip>

## Body

Nuxt UI applies default classes on the `<body>` element of your app for consistent theming across light and dark modes:

```css
body {
  @apply antialiased text-default bg-default scheme-light dark:scheme-dark;
}
```
