# Card

> Create highlighted content blocks with optional links and navigation.

## Usage

Use markdown in the default slot of the `card` component to highlight your content.

Use the `title`, `icon` and `color` props to customize it. You can also pass any property from the [`<NuxtLink>`](https://nuxt.com/docs/api/components/nuxt-link) component.

```vue
<template>
  <UCard title="Startup" icon="i-lucide-users" color="primary" to="https://nuxt.lemonsqueezy.com" target="_blank">
    Best suited for small teams, startups and agencies with up to 5 developers.
  </UCard>
</template>
```

## API

### Props

```ts
/**
 * Props for the ProseCard component
 */
interface ProseCardProps {
  /**
   * The element or component this component should render as.
   */
  as?: any;
  variant?: "solid" | "outline" | "soft" | "subtle" | undefined;
  ui?: { root?: ClassNameValue; header?: ClassNameValue; body?: ClassNameValue; footer?: ClassNameValue; } | undefined;
}
```

### Slots

```ts
/**
 * Slots for the Card component
 */
interface CardSlots {
  header(): any;
  default(): any;
  footer(): any;
}
```

## Theme

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    prose: {
      card: {
        slots: {
          base: [
            'group relative block my-5 p-4 sm:p-6 border border-default rounded-md bg-default',
            'transition-colors'
          ],
          icon: 'size-6 mb-2 block',
          title: 'text-highlighted font-semibold',
          description: 'text-[15px] text-muted *:first:mt-0 *:last:mb-0 *:my-1',
          externalIcon: [
            'size-4 align-top absolute right-2 top-2 text-dimmed pointer-events-none',
            'transition-colors'
          ]
        },
        variants: {
          color: {
            primary: {
              icon: 'text-primary'
            },
            secondary: {
              icon: 'text-secondary'
            },
            success: {
              icon: 'text-success'
            },
            info: {
              icon: 'text-info'
            },
            warning: {
              icon: 'text-warning'
            },
            error: {
              icon: 'text-error'
            },
            neutral: {
              icon: 'text-highlighted'
            }
          },
          to: {
            true: ''
          },
          title: {
            true: {
              description: 'mt-1'
            }
          }
        },
        compoundVariants: [
          {
            color: 'primary',
            to: true,
            class: {
              base: 'hover:bg-primary/10 hover:border-primary',
              externalIcon: 'group-hover:text-primary'
            }
          },
          {
            color: 'secondary',
            to: true,
            class: {
              base: 'hover:bg-secondary/10 hover:border-secondary',
              externalIcon: 'group-hover:text-secondary'
            }
          },
          {
            color: 'success',
            to: true,
            class: {
              base: 'hover:bg-success/10 hover:border-success',
              externalIcon: 'group-hover:text-success'
            }
          },
          {
            color: 'info',
            to: true,
            class: {
              base: 'hover:bg-info/10 hover:border-info',
              externalIcon: 'group-hover:text-info'
            }
          },
          {
            color: 'warning',
            to: true,
            class: {
              base: 'hover:bg-warning/10 hover:border-warning',
              externalIcon: 'group-hover:text-warning'
            }
          },
          {
            color: 'error',
            to: true,
            class: {
              base: 'hover:bg-error/10 hover:border-error',
              externalIcon: 'group-hover:text-error'
            }
          },
          {
            color: 'neutral',
            to: true,
            class: {
              base: 'hover:bg-elevated/50 hover:border-inverted',
              externalIcon: 'group-hover:text-highlighted'
            }
          }
        ],
        defaultVariants: {
          color: 'primary'
        }
      }
    }
  }
})
```

## Changelog

<component-changelog prefix="prose">



</component-changelog>
