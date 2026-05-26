# Headers and text

> Beautifully styled headings, paragraphs, text formatting, and links for optimal readability.

## Headings

Use headings to organize your content and make it easier to read.

H1 to H3 headings get anchor links and show up in the table of contents for easy navigation.

<note>

You can control [anchor links](https://content.nuxt.com/docs/getting-started/configuration#anchorlinks) generation (for example, for AI chat interfaces) in your `nuxt.config.ts`:

```ts [nuxt.config.ts]
export default defineNuxtConfig({
  content: {
    renderer: {
      anchorLinks: false
    }
  }
})
```

</note>

<note>

You can control behavior of [toc generation](https://content.nuxt.com/docs/getting-started/configuration#toc) in your `nuxt.config.ts`:

```ts [nuxt.config.ts]
export default defineNuxtConfig({
  content: {
    build: {
      markdown: {
        toc: {
          depth: 3
        }
      }
    }
  }
})
```

</note>

### Heading 1

<tabs className="gap-0">
<code-preview label="Preview" className="[&>div]:*:my-0">

# Nuxt UI

<template v-slot:code="">

```mdc
# Nuxt UI
```

</template>
</code-preview>

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      h1: {
        slots: {
          base: 'text-4xl text-highlighted font-bold mb-8 scroll-mt-[calc(45px+var(--ui-header-height))] lg:scroll-mt-(--ui-header-height)',
          link: 'inline-flex items-center gap-2'
        }
      }
    }
  }
})
```

</tabs>

### Heading 2

<tabs className="gap-0">
<code-preview label="Preview" className="[&>div]:*:my-0">

## What's new in v4?

<template v-slot:code="">

```mdc
## What's new in v4?
```

</template>
</code-preview>

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      h2: {
        slots: {
          base: [
            'relative text-2xl text-highlighted font-bold mt-12 mb-6 scroll-mt-[calc(48px+45px+var(--ui-header-height))] lg:scroll-mt-[calc(48px+var(--ui-header-height))] [&>a]:focus-visible:outline-primary [&>a>code]:border-dashed hover:[&>a>code]:border-primary hover:[&>a>code]:text-primary [&>a>code]:text-xl/7 [&>a>code]:font-bold',
            '[&>a>code]:transition-colors'
          ],
          leading: [
            'absolute -ms-8 top-1 opacity-0 group-hover:opacity-100 group-focus:opacity-100 p-1 bg-elevated hover:text-primary rounded-md hidden lg:flex text-muted',
            'transition'
          ],
          leadingIcon: 'size-4 shrink-0',
          link: 'group lg:ps-2 lg:-ms-2'
        }
      }
    }
  }
})
```

</tabs>

### Heading 3

<tabs className="gap-0">
<code-preview label="Preview" className="[&>div]:*:my-0">

### Enhanced components

<template v-slot:code="">

```mdc
### Enhanced components
```

</template>
</code-preview>

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      h3: {
        slots: {
          base: [
            'relative text-xl text-highlighted font-bold mt-8 mb-3 scroll-mt-[calc(32px+45px+var(--ui-header-height))] lg:scroll-mt-[calc(32px+var(--ui-header-height))] [&>a]:focus-visible:outline-primary [&>a>code]:border-dashed hover:[&>a>code]:border-primary hover:[&>a>code]:text-primary [&>a>code]:text-lg/6 [&>a>code]:font-bold',
            '[&>a>code]:transition-colors'
          ],
          leading: [
            'absolute -ms-8 top-0.5 opacity-0 group-hover:opacity-100 group-focus:opacity-100 p-1 bg-elevated hover:text-primary rounded-md hidden lg:flex text-muted',
            'transition'
          ],
          leadingIcon: 'size-4 shrink-0',
          link: 'group lg:ps-2 lg:-ms-2'
        }
      }
    }
  }
})
```

</tabs>

### Heading 4

<tabs className="gap-0">
<code-preview label="Preview" className="[&>div]:*:my-0">

#### Getting started

<template v-slot:code="">

```mdc
#### Getting started
```

</template>
</code-preview>

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      h4: {
        slots: {
          base: 'text-lg text-highlighted font-bold mt-6 mb-2 scroll-mt-[calc(24px+45px+var(--ui-header-height))] lg:scroll-mt-[calc(24px+var(--ui-header-height))] [&>a]:focus-visible:outline-primary',
          link: ''
        }
      }
    }
  }
})
```

</tabs>

## Text formatting

Structure your content with clear paragraphs and consistent text formatting for better readability.

### Paragraph

<tabs className="gap-0">
<code-preview label="Preview" className="[&>div]:*:my-0">

Nuxt UI provides a comprehensive collection of Vue components, composables and utilities for building modern, accessible applications with consistent design and enhanced user experience.

<template v-slot:code="">

```mdc
Nuxt UI provides a comprehensive collection of Vue components, composables and utilities for building modern, accessible applications with consistent design and enhanced user experience.
```

</template>
</code-preview>

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      p: {
        base: 'my-5 leading-7 text-pretty'
      }
    }
  }
})
```

</tabs>

### Strong

<tabs className="gap-0">
<code-preview label="Preview" className="[&>div]:*:my-0">

**Strong text**

<template v-slot:code="">

```mdc
**Strong text**
```

</template>
</code-preview>

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      strong: {
        base: ''
      }
    }
  }
})
```

</tabs>

### Emphasis

<tabs className="gap-0">
<code-preview label="Preview" className="[&>div]:*:my-0">

*Emphasized text*

<template v-slot:code="">

```mdc
*Emphasized text*
```

</template>
</code-preview>

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      em: {
        base: ''
      }
    }
  }
})
```

</tabs>

## Links

To create a link, wrap the link text in brackets followed by the URL in parentheses. Works for both external and internal links.

<tabs className="gap-0">
<code-preview label="Preview" className="[&>div]:*:my-0">

[Nuxt documentation](https://nuxt.com)

<template v-slot:code="">

```mdc
[Nuxt documentation](https://nuxt.com)
```

</template>
</code-preview>

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      a: {
        base: [
          'text-primary border-b border-transparent hover:border-primary font-medium focus-visible:outline-primary [&>code]:border-dashed hover:[&>code]:border-primary hover:[&>code]:text-primary',
          'transition-colors [&>code]:transition-colors'
        ]
      }
    }
  }
})
```

</tabs>

## Blockquotes

Use blockquotes to highlight important information or quotes.

<tabs className="gap-0">
<code-preview label="Preview">

> Nuxt UI automatically adapts to your theme settings, ensuring consistent typography across your entire application.

<template v-slot:code="">

```mdc
> Nuxt UI automatically adapts to your theme settings, ensuring consistent typography across your entire application.
```

</template>
</code-preview>

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      blockquote: {
        base: 'border-s-4 border-accented ps-4 italic'
      }
    }
  }
})
```

</tabs>

## Horizontal rules

Use horizontal rules to visually separate content sections.

<tabs className="gap-0">
<code-preview label="Preview" className="[&>div]:*:my-0,[&>div]:*:w-full">

---

<template v-slot:code="">

```mdc
---
```

</template>
</code-preview>

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      hr: {
        base: 'border-t border-default my-12'
      }
    }
  }
})
```

</tabs>
