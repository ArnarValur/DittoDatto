---
title: "Vue ChatPromptSubmit Component"
source: "https://ui.nuxt.com/docs/components/chat-prompt-submit"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A Button for submitting chat prompts with automatic status handling."
tags:
---
## ChatPromptSubmit

[Button](https://ui.nuxt.com/docs/components/button) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/ChatPromptSubmit.vue)

A Button for submitting chat prompts with automatic status handling.

## Usage

The ChatPromptSubmit component is used inside the [ChatPrompt](https://ui.nuxt.com/docs/components/chat-prompt) component to submit the prompt. It automatically handles the different `status` values to control the chat.

It extends the [Button](https://ui.nuxt.com/docs/components/button) component, so you can pass any property such as `color`, `variant`, `size`, etc.

```
<template>

  <UChatPrompt>

    <UChatPromptSubmit />

  </UChatPrompt>

</template>
```

You can also use it inside the `footer` slot of the [`ChatPrompt`](https://ui.nuxt.com/docs/components/chat-prompt) component.

### Ready

When its status is `ready`, use the `color`, `variant` and `icon` props to customize the Button. Defaults to:

- `color="primary"`
- `variant="solid"`
- `icon="i-lucide-arrow-up"`

```
<template>

  <UChatPromptSubmit color="primary" variant="solid" icon="i-lucide-arrow-up" />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.arrowUp` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.arrowUp` key.

### Submitted

When its status is `submitted`, use the `submitted-color`, `submitted-variant` and `submitted-icon` props to customize the Button. Defaults to:

- `submittedColor="neutral"`
- `submittedVariant="subtle"`
- `submittedIcon="i-lucide-square"`

The `stop` event is emitted when the user clicks on the Button.

```
<template>

  <UChatPromptSubmit

    submitted-color="neutral"

    submitted-variant="subtle"

    submitted-icon="i-lucide-square"

    status="submitted"

  />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.stop` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.stop` key.

### Streaming

When its status is `streaming`, use the `streaming-color`, `streaming-variant` and `streaming-icon` props to customize the Button. Defaults to:

- `streamingColor="neutral"`
- `streamingVariant="subtle"`
- `streamingIcon="i-lucide-square"`

The `stop` event is emitted when the user clicks on the Button.

```
<template>

  <UChatPromptSubmit

    streaming-color="neutral"

    streaming-variant="subtle"

    streaming-icon="i-lucide-square"

    status="streaming"

  />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.stop` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.stop` key.

### Error

When its status is `error`, use the `error-color`, `error-variant` and `error-icon` props to customize the Button. Defaults to:

- `errorColor="error"`
- `errorVariant="soft"`
- `errorIcon="i-lucide-rotate-ccw"`

The `reload` event is emitted when the user clicks on the Button.

```
<template>

  <UChatPromptSubmit

    error-color="error"

    error-variant="soft"

    error-icon="i-lucide-rotate-ccw"

    status="error"

  />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.reload` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.reload` key.

## Examples

Check the **ChatMessages** documentation for server API setup and installation instructions.

### Within a page

Use the ChatPromptSubmit component with the `Chat` class from AI SDK v5 to display a chat prompt within a page.

Pass the `status` prop and listen to the `stop` and `reload` events to control the chat.

pages/\[id\].vue

```
<script setup lang="ts">

import { Chat } from '@ai-sdk/vue'

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

            <template v-for="(part, index) in message.parts" :key="\`${message.id}-${part.type}-${index}\`">

              <MDC v-if="part.type === 'text' && message.role === 'assistant'" :value="part.text" :cache-key="\`${message.id}-${index}\`" class="*:first:mt-0 *:last:mb-0" />

              <p v-else-if="part.type === 'text' && message.role === 'user'" class="whitespace-pre-wrap">{{ part.text }}</p>

            </template>

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

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'button'` | `any`  The element or component this component should render as when not a link. |
| `status` | `'ready'` | ` "error" \| "submitted" \| "streaming" \| "ready"` |
| `icon` | `appConfig.ui.icons.arrowUp` | `any`  The icon displayed in the button when the status is `ready`. |
| `color` | `'primary'` | ` "error" \| "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "neutral"`  The color of the button when the status is `ready`. |
| `variant` | `'solid'` | ` "solid" \| "outline" \| "soft" \| "subtle" \| "ghost" \| "link"`  The variant of the button when the status is `ready`. |
| `streamingIcon` | `appConfig.ui.icons.stop` | `any`  The icon displayed in the button when the status is `streaming`. |
| `streamingColor` | `'neutral'` | ` "error" \| "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "neutral"`  The color of the button when the status is `streaming`. |
| `streamingVariant` | `'subtle'` | ` "solid" \| "outline" \| "soft" \| "subtle" \| "ghost" \| "link"`  The variant of the button when the status is `streaming`. |
| `submittedIcon` | `appConfig.ui.icons.stop` | `any`  The icon displayed in the button when the status is `submitted`. |
| `submittedColor` | `'neutral'` | ` "error" \| "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "neutral"`  The color of the button when the status is `submitted`. |
| `submittedVariant` | `'subtle'` | ` "solid" \| "outline" \| "soft" \| "subtle" \| "ghost" \| "link"`  The variant of the button when the status is `submitted`. |
| `errorIcon` | `appConfig.ui.icons.reload` | `any`  The icon displayed in the button when the status is `error`. |
| `errorColor` | `'error'` | ` "error" \| "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "neutral"`  The color of the button when the status is `error`. |
| `errorVariant` | `'soft'` | ` "solid" \| "outline" \| "soft" \| "subtle" \| "ghost" \| "link"`  The variant of the button when the status is `error`. |
| `type` | `'button'` | ` "reset" \| "submit" \| "button"`  The type of the button when not a link. |
| `autofocus` |  | ` false \| true \| "true" \| "false"` |
| `disabled` |  | `boolean` |
| `name` |  | ` string` |
| `label` |  | ` string` |
| `activeColor` |  | ` "error" \| "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "neutral"` |
| `activeVariant` |  | ` "solid" \| "outline" \| "soft" \| "subtle" \| "ghost" \| "link"` |
| `size` | `'md'` | ` "md" \| "xs" \| "sm" \| "lg" \| "xl"` |
| `square` |  | `boolean`  Render the button with equal padding on all sides. |
| `block` |  | `boolean`  Render the button full width. |
| `loadingAuto` |  | `boolean`  Set loading state automatically based on the `@click` promise state |
| `avatar` |  | ` AvatarProps`  Display an avatar on the left side. |
| `leading` |  | `boolean`  When `true`, the icon will be displayed on the left side. |
| `leadingIcon` |  | `any`  Display an icon on the left side. |
| `trailing` |  | `boolean`  When `true`, the icon will be displayed on the right side. |
| `trailingIcon` |  | `any`  Display an icon on the right side. |
| `loading` |  | `boolean`  When `true`, the loading icon will be displayed. |
| `loadingIcon` | `appConfig.ui.icons.loading` | `any`  The icon when the `loading` prop is `true`. |
| `ui` |  | ` { base?: ClassNameValue; } & { base?: ClassNameValue; label?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; trailingIcon?: ClassNameValue; }` |

This component also supports all native `<button>` HTML attributes.

### Slots

| Slot | Type |
| --- | --- |
| `leading` | `{ ui: object; }` |
| `default` | `{ ui: object; }` |
| `trailing` | `{ ui: object; }` |

### Emits

| Event | Type |
| --- | --- |
| `stop` | `[event: MouseEvent]` |
| `reload` | `[event: MouseEvent]` |

## Theme

app.config.ts

```ts
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

vite.config.ts

```ts
import { defineConfig } from 'vite'

import vue from '@vitejs/plugin-vue'

import ui from '@nuxt/ui/vite'

export default defineConfig({

  plugins: [

    vue(),

    ui({

      ui: {

        chatPromptSubmit: {

          slots: {

            base: ''

          }

        }

      }

    })

  ]

})
```

## Changelog

[`184ea`](https://github.com/nuxt/ui/commit/184eaab1cd5f4f4943b509ea1a3efb1b6f6d7f91) — chore: reduce type verbosity by omitting link props from action buttons

[`736a5`](https://github.com/nuxt/ui/commit/736a5470d48517aef218ec8385e92121346b7419) — fix: proxy event to `stop` and `reload` emits ([#5400](https://github.com/nuxt/ui/issues/5400))

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`de782`](https://github.com/nuxt/ui/commit/de7822f6a11f6d1830421db337237c6e16f530b1) — feat!: upgrade `ai-sdk` to v5 ([#4698](https://github.com/nuxt/ui/issues/4698))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[ChatPrompt](https://ui.nuxt.com/docs/components/chat-prompt)

[

An enhanced Textarea for submitting prompts in AI chat interfaces.

](https://ui.nuxt.com/docs/components/chat-prompt)[

Editor

A rich text editor component based on TipTap with support for markdown, HTML, and JSON content types.

](https://ui.nuxt.com/docs/components/editor)