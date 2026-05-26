# DashboardSearchButton

> A pre-styled Button to open the DashboardSearch modal.

## Usage

The DashboardSearchButton component is used to open the [DashboardSearch](/docs/components/dashboard-search) modal.

```vue
<template>
  <UDashboardSearchButton />
</template>
```

It extends the [Button](/docs/components/button) component, so you can pass any property such as `color`, `variant`, `size`, etc.

```vue
<template>
  <UDashboardSearchButton variant="subtle" />
</template>
```

<note to="#collapsed">

The button defaults to `color="neutral"` and `variant="outline"` when not collapsed, `variant="ghost"` when collapsed.

</note>

### Collapsed

Use the `collapsed` prop to hide the button's label and [kbds](#kbds). Defaults to `false`.

```vue
<template>
  <UDashboardSearchButton collapsed />
</template>
```

<tip to="/docs/components/dashboard-sidebar#slots">

When using the button in the **DashboardSidebar** component, use the `collapsed` slot prop directly.

</tip>

### Kbds

Use the `kbds` prop to display keyboard keys in the button. Defaults to `['meta', 'K']` to match the default shortcut of the [DashboardSearch](/docs/components/dashboard-search#shortcut) component.

```vue
<template>
  <UDashboardSearchButton :collapsed="false" />
</template>
```

## API

### Props

```ts
/**
 * Props for the DashboardSearchButton component
 */
interface DashboardSearchButtonProps {
  /**
   * The icon displayed in the button.
   */
  icon?: any;
  /**
   * The label displayed in the button.
   */
  label?: string | undefined;
  /**
   * The color of the button.
   * @default "\"neutral\""
   */
  color?: "error" | "neutral" | "primary" | "secondary" | "success" | "info" | "warning" | undefined;
  /**
   * The variant of the button.
   * Defaults to 'outline' when not collapsed, 'ghost' when collapsed.
   */
  variant?: "solid" | "outline" | "soft" | "subtle" | "ghost" | "link" | undefined;
  /**
   * Whether the button is collapsed.
   * @default "false"
   */
  collapsed?: boolean | undefined;
  /**
   * Display a tooltip on the button when is collapsed with the button label.
   * This has priority over the global `tooltip` prop.
   * @default "false"
   */
  tooltip?: boolean | TooltipProps | undefined;
  /**
   * The keyboard keys to display in the button.
   * `{ variant: 'subtle' }`{lang="ts-type"}
   * @default "[\"meta\", \"k\"]"
   */
  kbds?: (string | undefined)[] | KbdProps[] | undefined;
  ui?: ({ base?: ClassNameValue; label?: ClassNameValue; trailing?: ClassNameValue; } & { base?: ClassNameValue; label?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; trailingIcon?: ClassNameValue; }) | undefined;
  /**
   * Route Location the link should navigate to when clicked on.
   */
  to?: string | RouteLocationAsRelativeGeneric | RouteLocationAsPathGeneric | undefined;
  /**
   * Class to apply when the link is active
   */
  activeClass?: string | undefined;
  /**
   * Class to apply when the link is exact active
   */
  exactActiveClass?: string | undefined;
  /**
   * Value passed to the attribute `aria-current` when the link is exact active.
   */
  ariaCurrentValue?: "page" | "step" | "location" | "date" | "time" | "true" | "false" | undefined;
  /**
   * Pass the returned promise of `router.push()` to `document.startViewTransition()` if supported.
   */
  viewTransition?: boolean | undefined;
  /**
   * Calls `router.replace` instead of `router.push`.
   */
  replace?: boolean | undefined;
  autofocus?: Booleanish | undefined;
  disabled?: boolean | undefined;
  form?: string | undefined;
  formaction?: string | undefined;
  formenctype?: string | undefined;
  formmethod?: string | undefined;
  formnovalidate?: Booleanish | undefined;
  formtarget?: string | undefined;
  name?: string | undefined;
  /**
   * The type of the button when not a link.
   */
  type?: "reset" | "submit" | "button" | undefined;
  download?: any;
  /**
   * An alias for `to`. If used with `to`, `href` will be ignored
   */
  href?: string | RouteLocationAsRelativeGeneric | RouteLocationAsPathGeneric | undefined;
  hreflang?: string | undefined;
  media?: string | undefined;
  ping?: string | undefined;
  /**
   * A rel attribute value to apply on the link. Defaults to "noopener noreferrer" for external links.
   */
  rel?: "noopener" | "noreferrer" | "nofollow" | "sponsored" | "ugc" | (string & {}) | null | undefined;
  /**
   * Where to display the linked URL, as the name for a browsing context.
   */
  target?: (string & {}) | "_blank" | "_parent" | "_self" | "_top" | null | undefined;
  referrerpolicy?: HTMLAttributeReferrerPolicy | undefined;
  onClick?: ((event: MouseEvent) => void | Promise<void>) | ((event: MouseEvent) => void | Promise<void>)[] | undefined;
  /**
   * The element or component this component should render as when not a link.
   */
  as?: any;
  /**
   * Force the link to be active independent of the current route.
   */
  active?: boolean | undefined;
  /**
   * Will only be active if the current route is an exact match.
   */
  exact?: boolean | undefined;
  /**
   * Allows controlling how the current route query sets the link as active.
   */
  exactQuery?: boolean | "partial" | undefined;
  /**
   * Will only be active if the current route hash is an exact match.
   */
  exactHash?: boolean | undefined;
  /**
   * The class to apply when the link is inactive.
   */
  inactiveClass?: string | undefined;
  /**
   * Forces the link to be considered as external (true) or internal (false). This is helpful to handle edge-cases
   */
  external?: boolean | undefined;
  /**
   * If set to true, no rel attribute will be added to the link
   */
  noRel?: boolean | undefined;
  /**
   * A class to apply to links that have been prefetched.
   */
  prefetchedClass?: string | undefined;
  /**
   * When enabled will prefetch middleware, layouts and payloads of links in the viewport.
   */
  prefetch?: boolean | undefined;
  /**
   * Allows controlling when to prefetch links. By default, prefetch is triggered only on visibility.
   */
  prefetchOn?: "visibility" | "interaction" | Partial<{ visibility: boolean; interaction: boolean; }> | undefined;
  /**
   * Escape hatch to disable `prefetch` attribute.
   */
  noPrefetch?: boolean | undefined;
  /**
   * An option to either add or remove trailing slashes in the `href` for this specific link.
   * Overrides the global `trailingSlash` option if provided.
   */
  trailingSlash?: "append" | "remove" | undefined;
  activeColor?: "error" | "neutral" | "primary" | "secondary" | "success" | "info" | "warning" | undefined;
  activeVariant?: "solid" | "outline" | "soft" | "subtle" | "ghost" | "link" | undefined;
  size?: "xs" | "sm" | "md" | "lg" | "xl" | undefined;
  /**
   * Render the button with equal padding on all sides.
   */
  square?: boolean | undefined;
  /**
   * Render the button full width.
   */
  block?: boolean | undefined;
  /**
   * Set loading state automatically based on the `@click` promise state
   */
  loadingAuto?: boolean | undefined;
  /**
   * Display an avatar on the left side.
   */
  avatar?: AvatarProps | undefined;
  /**
   * When `true`, the icon will be displayed on the left side.
   */
  leading?: boolean | undefined;
  /**
   * Display an icon on the left side.
   */
  leadingIcon?: any;
  /**
   * When `true`, the icon will be displayed on the right side.
   */
  trailing?: boolean | undefined;
  /**
   * Display an icon on the right side.
   */
  trailingIcon?: any;
  /**
   * When `true`, the loading icon will be displayed.
   */
  loading?: boolean | undefined;
  /**
   * The icon when the `loading` prop is `true`.
   */
  loadingIcon?: any;
}
```

< callout icon="i-simple-icons-mdnwebdocs" target="_blank" to="https://developer.mozilla.org/en-US/docs/Web/HTML/Element/button#attributes">

This component also supports all native `<button>` HTML attributes.

</callout>

### Slots

```ts
/**
 * Slots for the DashboardSearchButton component
 */
interface DashboardSearchButtonSlots {
  leading(): any;
  default(): any;
  trailing(): any;
}
```

## Theme

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    dashboardSearchButton: {
      slots: {
        base: '',
        label: '',
        trailing: 'hidden lg:flex items-center gap-0.5 ms-auto'
      },
      variants: {
        collapsed: {
          true: {
            label: 'hidden',
            trailing: 'lg:hidden'
          }
        }
      }
    }
  }
})
```

## Changelog

<component-changelog>



</component-changelog>
