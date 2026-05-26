# ChatPromptSubmit

> A Button for submitting chat prompts with automatic status handling.

## Usage

The ChatPromptSubmit component is used inside the [ChatPrompt](/docs/components/chat-prompt) component to submit the prompt. It automatically handles the different `status` values to control the chat.

It extends the [Button](/docs/components/button) component, so you can pass any property such as `color`, `variant`, `size`, etc.

<code-preview>
<u-chat-prompt-submit>



</u-chat-prompt-submit>

<template v-slot:code="">

```vue
<template>
  <UChatPrompt>
    <UChatPromptSubmit />
  </UChatPrompt>
</template>
```

</template>
</code-preview>

<note>

You can also use it inside the `footer` slot of the [`ChatPrompt`](/docs/components/chat-prompt) component.

</note>

### Ready

When its status is `ready`, use the `color`, `variant` and `icon` props to customize the Button. Defaults to:

- `color="primary"`
- `variant="solid"`
- `icon="i-lucide-arrow-up"`

```vue
<template>
  <UChatPromptSubmit color="primary" variant="solid" icon="i-lucide-arrow-up" />
</template>
```

<framework-only>
<template v-slot:nuxt="">
<tip to="/docs/getting-started/integrations/icons/nuxt#theme">

You can customize this icon globally in your `app.config.ts` under `ui.icons.arrowUp` key.

</tip>
</template>

<template v-slot:vue="">
<tip to="/docs/getting-started/integrations/icons/vue#theme">

You can customize this icon globally in your `vite.config.ts` under `ui.icons.arrowUp` key.

</tip>
</template>
</framework-only>

### Submitted

When its status is `submitted`, use the `submitted-color`, `submitted-variant` and `submitted-icon` props to customize the Button. Defaults to:

- `submittedColor="neutral"`
- `submittedVariant="subtle"`
- `submittedIcon="i-lucide-square"`

<note>

The `stop` event is emitted when the user clicks on the Button.

</note>

```vue
<template>
  <UChatPromptSubmit submitted-color="neutral" submitted-variant="subtle" submitted-icon="i-lucide-square" status="submitted" />
</template>
```

<framework-only>
<template v-slot:nuxt="">
<tip to="/docs/getting-started/integrations/icons/nuxt#theme">

You can customize this icon globally in your `app.config.ts` under `ui.icons.stop` key.

</tip>
</template>

<template v-slot:vue="">
<tip to="/docs/getting-started/integrations/icons/vue#theme">

You can customize this icon globally in your `vite.config.ts` under `ui.icons.stop` key.

</tip>
</template>
</framework-only>

### Streaming

When its status is `streaming`, use the `streaming-color`, `streaming-variant` and `streaming-icon` props to customize the Button. Defaults to:

- `streamingColor="neutral"`
- `streamingVariant="subtle"`
- `streamingIcon="i-lucide-square"`

<note>

The `stop` event is emitted when the user clicks on the Button.

</note>

```vue
<template>
  <UChatPromptSubmit streaming-color="neutral" streaming-variant="subtle" streaming-icon="i-lucide-square" status="streaming" />
</template>
```

<framework-only>
<template v-slot:nuxt="">
<tip to="/docs/getting-started/integrations/icons/nuxt#theme">

You can customize this icon globally in your `app.config.ts` under `ui.icons.stop` key.

</tip>
</template>

<template v-slot:vue="">
<tip to="/docs/getting-started/integrations/icons/vue#theme">

You can customize this icon globally in your `vite.config.ts` under `ui.icons.stop` key.

</tip>
</template>
</framework-only>

### Error

When its status is `error`, use the `error-color`, `error-variant` and `error-icon` props to customize the Button. Defaults to:

- `errorColor="error"`
- `errorVariant="soft"`
- `errorIcon="i-lucide-rotate-ccw"`

<note>

The `reload` event is emitted when the user clicks on the Button.

</note>

```vue
<template>
  <UChatPromptSubmit error-color="error" error-variant="soft" error-icon="i-lucide-rotate-ccw" status="error" />
</template>
```

<framework-only>
<template v-slot:nuxt="">
<tip to="/docs/getting-started/integrations/icons/nuxt#theme">

You can customize this icon globally in your `app.config.ts` under `ui.icons.reload` key.

</tip>
</template>

<template v-slot:vue="">
<tip to="/docs/getting-started/integrations/icons/vue#theme">

You can customize this icon globally in your `vite.config.ts` under `ui.icons.reload` key.

</tip>
</template>
</framework-only>

## Examples

<note target="_blank" to="https://ai-sdk.dev/docs/getting-started/nuxt">

These chat components are designed to be used with the **AI SDK v5** from **Vercel AI SDK**.

</note>

<callout icon="i-simple-icons-github" target="_blank" to="https://github.com/nuxt-ui-templates/chat">

Check out the source code of our **AI Chat template** on GitHub for a real-life example.

</callout>

### Within a page

Use the ChatPromptSubmit component with the `Chat` class from AI SDK v5 to display a chat prompt within a page.

Pass the `status` prop and listen to the `stop` and `reload` events to control the chat.

```vue [pages/[id].vue]
<script setup lang="ts">
import { Chat } from '@ai-sdk/vue'
import { getTextFromMessage } from '@nuxt/ui/utils/ai'

const input = ref('')

const chat = new Chat({
  onError(error) {
    console.error(error)
  }
})

function onSubmit() {
  chat.sendMessage({ text: input.value })

  input.value = ''
}
</script>

<template>
  <UDashboardPanel>
    <template #body>
      <UContainer>
        <UChatMessages :messages="chat.messages" :status="chat.status">
          <template #content="{ message }">
            <MDC :value="getTextFromMessage(message)" :cache-key="message.id" class="*:first:mt-0 *:last:mb-0" />
          </template>
        </UChatMessages>
      </UContainer>
    </template>

    <template #footer>
      <UContainer class="pb-4 sm:pb-6">
        <UChatPrompt v-model="input" :error="chat.error" @submit="onSubmit">
          <UChatPromptSubmit :status="chat.status" @stop="chat.stop()" @reload="chat.regenerate()" />
        </UChatPrompt>
      </UContainer>
    </template>
  </UDashboardPanel>
</template>
```

## API

### Props

```ts
/**
 * Props for the ChatPromptSubmit component
 */
interface ChatPromptSubmitProps {
  /**
   * @default "\"ready\""
   */
  status?: ChatStatus | undefined;
  /**
   * The icon displayed in the button when the status is `ready`.
   */
  icon?: any;
  /**
   * The color of the button when the status is `ready`.
   */
  color?: "error" | "primary" | "secondary" | "success" | "info" | "warning" | "neutral" | undefined;
  /**
   * The variant of the button when the status is `ready`.
   */
  variant?: "solid" | "outline" | "soft" | "subtle" | "ghost" | "link" | undefined;
  /**
   * The icon displayed in the button when the status is `streaming`.
   */
  streamingIcon?: any;
  /**
   * The color of the button when the status is `streaming`.
   * @default "\"neutral\""
   */
  streamingColor?: "error" | "primary" | "secondary" | "success" | "info" | "warning" | "neutral" | undefined;
  /**
   * The variant of the button when the status is `streaming`.
   * @default "\"subtle\""
   */
  streamingVariant?: "solid" | "outline" | "soft" | "subtle" | "ghost" | "link" | undefined;
  /**
   * The icon displayed in the button when the status is `submitted`.
   */
  submittedIcon?: any;
  /**
   * The color of the button when the status is `submitted`.
   * @default "\"neutral\""
   */
  submittedColor?: "error" | "primary" | "secondary" | "success" | "info" | "warning" | "neutral" | undefined;
  /**
   * The variant of the button when the status is `submitted`.
   * @default "\"subtle\""
   */
  submittedVariant?: "solid" | "outline" | "soft" | "subtle" | "ghost" | "link" | undefined;
  /**
   * The icon displayed in the button when the status is `error`.
   */
  errorIcon?: any;
  /**
   * The color of the button when the status is `error`.
   * @default "\"error\""
   */
  errorColor?: "error" | "primary" | "secondary" | "success" | "info" | "warning" | "neutral" | undefined;
  /**
   * The variant of the button when the status is `error`.
   * @default "\"soft\""
   */
  errorVariant?: "solid" | "outline" | "soft" | "subtle" | "ghost" | "link" | undefined;
  ui?: ({ base?: ClassNameValue; } & { base?: ClassNameValue; label?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; trailingIcon?: ClassNameValue; }) | undefined;
  /**
   * The type of the button when not a link.
   */
  type?: "reset" | "submit" | "button" | undefined;
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
  label?: string | undefined;
  activeColor?: "error" | "primary" | "secondary" | "success" | "info" | "warning" | "neutral" | undefined;
  activeVariant?: "solid" | "outline" | "soft" | "subtle" | "ghost" | "link" | undefined;
  size?: "md" | "xs" | "sm" | "lg" | "xl" | undefined;
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
 * Slots for the ChatPromptSubmit component
 */
interface ChatPromptSubmitSlots {
  leading(): any;
  default(): any;
  trailing(): any;
}
```

### Emits

```ts
/**
 * Emitted events for the ChatPromptSubmit component
 */
interface ChatPromptSubmitEmits {
  stop: (payload: [event: MouseEvent]) => void;
  reload: (payload: [event: MouseEvent]) => void;
}
```

## Theme

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    chatPromptSubmit: {
      slots: {
        base: ''
      }
    }
  }
})
```

## Changelog

<component-changelog>



</component-changelog>
