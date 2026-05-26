---
title: "Vue ChatPrompt Component"
source: "https://ui.nuxt.com/docs/components/chat-prompt"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "An enhanced Textarea for submitting prompts in AI chat interfaces."
tags:
---
## ChatPrompt

[Textarea](https://ui.nuxt.com/docs/components/textarea) [GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/ChatPrompt.vue)

An enhanced Textarea for submitting prompts in AI chat interfaces.

## Usage

The ChatPrompt component renders a `<form>` element and extends the [Textarea](https://ui.nuxt.com/docs/components/textarea) component so you can pass any property such as `icon`, `placeholder`, `autofocus`, etc.

The ChatPrompt handles the following events:
- The form is submitted when the user presses ↵ or when the user clicks on the submit button.
- The textarea is blurred when Esc is pressed and emits a `close` event.

### Variant

Use the `variant` prop to change the style of the prompt. Defaults to `outline`.

```
<template>

  <UChatPrompt variant="soft" />

</template>
```

## Examples

Check the **ChatMessages** documentation for server API setup and installation instructions.

### Within a page

Use the ChatPrompt component with the `Chat` class from AI SDK v5 to display a chat prompt within a page.

Pass the `input` prop alongside the `error` prop to disable the textarea when an error occurs.

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

You can also use it as a starting point for a chat interface.

pages/index.vue

```
<script setup lang="ts">

import { Chat } from '@ai-sdk/vue'

const input = ref('')

const chat = new Chat()

async function onSubmit() {

  chat.sendMessage({ text: input.value })

  // Navigate to chat page after first message

  if (chat.messages.length === 1) {

    await navigateTo('/chat')

  }

}

</script>

<template>

  <UDashboardPanel>

    <template #body>

      <UContainer>

        <h1>How can I help you today?</h1>

        <UChatPrompt v-model="input" @submit="onSubmit">

          <UChatPromptSubmit :status="chat.status" />

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
| `as` | `'form'` | `any`  The element or component this component should render as. |
| `placeholder` | `t('chatPrompt.placeholder')` | ` string`  The placeholder text for the textarea. |
| `variant` | `'outline'` | ` "outline" \| "soft" \| "subtle" \| "naked"` |
| `error` |  | ` Error` |
| `autofocus` | `true` | `boolean` |
| `disabled` |  | `boolean` |
| `icon` |  | `any`  Display an icon based on the `leading` and `trailing` props. |
| `avatar` |  | ` AvatarProps`  Display an avatar on the left side. |
| `loading` |  | `boolean`  When `true`, the loading icon will be displayed. |
| `loadingIcon` | `appConfig.ui.icons.loading` | `any`  The icon when the `loading` prop is `true`. |
| `rows` | `1` | ` number` |
| `autofocusDelay` |  | ` number` |
| `autoresize` | `true` | `boolean` |
| `autoresizeDelay` |  | ` number` |
| `maxrows` |  | ` number` |
| `modelValue` | `''` | ` string` |
| `ui` |  | ` { root?: ClassNameValue; header?: ClassNameValue; body?: ClassNameValue; footer?: ClassNameValue; base?: ClassNameValue; } & { root?: ClassNameValue; base?: ClassNameValue; leading?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; trailing?: ClassNameValue; trailingIcon?: ClassNameValue; }` |

This component also supports all native `<textarea>` HTML attributes.

### Slots

| Slot | Type |
| --- | --- |
| `header` | `{}` |
| `footer` | `{}` |
| `leading` | `{ ui: { root: (props?: Record<string, any> \| undefined) => string; base: (props?: Record<string, any> \| undefined) => string; leading: (props?: Record<string, any> \| undefined) => string; leadingIcon: (props?: Record<string, any> \| undefined) => string; leadingAvatar: (props?: Record<string, any> \| undefined) => string; leadingAvatarSize: (props?: Record<string, any> \| undefined) => string; trailing: (props?: Record<string, any> \| undefined) => string; trailingIcon: (props?: Record<string, any> \| undefined) => string; }; }` |
| `default` | `{ ui: { root: (props?: Record<string, any> \| undefined) => string; base: (props?: Record<string, any> \| undefined) => string; leading: (props?: Record<string, any> \| undefined) => string; leadingIcon: (props?: Record<string, any> \| undefined) => string; leadingAvatar: (props?: Record<string, any> \| undefined) => string; leadingAvatarSize: (props?: Record<string, any> \| undefined) => string; trailing: (props?: Record<string, any> \| undefined) => string; trailingIcon: (props?: Record<string, any> \| undefined) => string; }; }` |
| `trailing` | `{ ui: { root: (props?: Record<string, any> \| undefined) => string; base: (props?: Record<string, any> \| undefined) => string; leading: (props?: Record<string, any> \| undefined) => string; leadingIcon: (props?: Record<string, any> \| undefined) => string; leadingAvatar: (props?: Record<string, any> \| undefined) => string; leadingAvatarSize: (props?: Record<string, any> \| undefined) => string; trailing: (props?: Record<string, any> \| undefined) => string; trailingIcon: (props?: Record<string, any> \| undefined) => string; }; }` |

### Emits

| Event | Type |
| --- | --- |
| `close` | `[event: Event]` |
| `submit` | `[event: Event]` |
| `update:modelValue` | `[value: string]` |

### Expose

When accessing the component via a template ref, you can use the following:

| Name | Type |
| --- | --- |
| `textareaRef` | `Ref<HTMLTextAreaElement \| null>` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    chatPrompt: {

      slots: {

        root: 'relative flex flex-col items-stretch gap-2 px-2.5 py-2 w-full rounded-lg backdrop-blur',

        header: 'flex items-center gap-1.5',

        body: 'items-start',

        footer: 'flex items-center justify-between gap-1.5',

        base: 'text-base/5'

      },

      variants: {

        variant: {

          outline: {

            root: 'bg-default/75 ring ring-default'

          },

          soft: {

            root: 'bg-elevated/50'

          },

          subtle: {

            root: 'bg-elevated/50 ring ring-default'

          },

          naked: {

            root: ''

          }

        }

      },

      defaultVariants: {

        variant: 'outline'

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

        chatPrompt: {

          slots: {

            root: 'relative flex flex-col items-stretch gap-2 px-2.5 py-2 w-full rounded-lg backdrop-blur',

            header: 'flex items-center gap-1.5',

            body: 'items-start',

            footer: 'flex items-center justify-between gap-1.5',

            base: 'text-base/5'

          },

          variants: {

            variant: {

              outline: {

                root: 'bg-default/75 ring ring-default'

              },

              soft: {

                root: 'bg-elevated/50'

              },

              subtle: {

                root: 'bg-elevated/50 ring ring-default'

              },

              naked: {

                root: ''

              }

            }

          },

          defaultVariants: {

            variant: 'outline'

          }

        }

      }

    })

  ]

})
```

## Changelog

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`fce2d`](https://github.com/nuxt/ui/commit/fce2df4e0660d0bdb3cdd4fb3041416824cbe893) — fix!: consistent exposed refs ([#5385](https://github.com/nuxt/ui/issues/5385))

[`a8f21`](https://github.com/nuxt/ui/commit/a8f215641e0e479161312a3a81c9b4ab202c7bff) — fix: proxy `disabled` prop

[`3173b`](https://github.com/nuxt/ui/commit/3173bee38ce9e518076848999f14374600069d35) — fix: proxySlots reactivity ([#4969](https://github.com/nuxt/ui/issues/4969))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[ChatPalette](https://ui.nuxt.com/docs/components/chat-palette)

[

A chat palette to create a chatbot interface inside an overlay.

](https://ui.nuxt.com/docs/components/chat-palette)[

ChatPromptSubmit

A Button for submitting chat prompts with automatic status handling.

](https://ui.nuxt.com/docs/components/chat-prompt-submit)