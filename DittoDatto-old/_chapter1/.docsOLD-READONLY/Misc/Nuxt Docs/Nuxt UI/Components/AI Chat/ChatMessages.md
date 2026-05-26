---
title: "Vue ChatMessages Component"
source: "https://ui.nuxt.com/docs/components/chat-messages"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "Display a list of chat messages, designed to work seamlessly with Vercel AI SDK."
tags:
---
Display a list of chat messages, designed to work seamlessly with Vercel AI SDK.

## Usage

The ChatMessages component displays a list of [ChatMessage](https://ui.nuxt.com/docs/components/chat-message) components using either the default slot or the `messages` prop.

```
<template>

  <UChatMessages>

    <UChatMessage

      v-for="(message, index) in messages"

      :key="index"

      v-bind="message"

    />

  </UChatMessages>

</template>
```

This component is purpose-built for AI chatbots with features like:
- Initial scroll to the bottom upon loading ([`shouldScrollToBottom`](https://ui.nuxt.com/docs/components/#should-scroll-to-bottom)).
- Continuous scrolling down as new messages arrive ([`shouldAutoScroll`](https://ui.nuxt.com/docs/components/#should-auto-scroll)).
- An "Auto scroll" button appears when scrolled up, allowing users to jump back to the latest messages ([`autoScroll`](https://ui.nuxt.com/docs/components/#auto-scroll)).
- A loading indicator displays while the assistant is processing ([`status`](https://ui.nuxt.com/docs/components/#status)).
- Submitted messages are scrolled to the top of the viewport and the height of the last user message is dynamically adjusted.

### Messages

Use the `messages` prop to display a list of chat messages.

Hello, how are you?

I am doing well, thank you for asking! How can I assist you today?

What is the current weather in Tokyo?

Based on the latest data, Tokyo is currently experiencing sunny weather with temperatures around 24°C (75°F). It's a beautiful day with clear skies.

```
<script setup lang="ts">

const messages = ref([

  {

    id: '6045235a-a435-46b8-989d-2df38ca2eb47',

    role: 'user',

    parts: [

      {

        type: 'text',

        text: 'Hello, how are you?'

      }

    ]

  },

  {

    id: '7a92b3c1-d5f8-4e76-b8a9-3c1e5fb2e0d8',

    role: 'assistant',

    parts: [

      {

        type: 'text',

        text: 'I am doing well, thank you for asking! How can I assist you today?'

      }

    ]

  },

  {

    id: '9c84d6a7-8b23-4f12-a1d5-e7f3b9c05e2a',

    role: 'user',

    parts: [

      {

        type: 'text',

        text: 'What is the current weather in Tokyo?'

      }

    ]

  },

  {

    id: 'b2e5f8c3-a1d9-4e67-b3f2-c9d8e7a6b5f4',

    role: 'assistant',

    parts: [

      {

        type: 'text',

        text: "Based on the latest data, Tokyo is currently experiencing sunny weather with temperatures around 24°C (75°F). It's a beautiful day with clear skies."

      }

    ]

  }

])

</script>

<template>

  <UChatMessages :messages="messages" />

</template>
```

### Status

Use the `status` prop to display a visual indicator when the assistant is processing.

Hello, how are you?

```
<script setup lang="ts">

const messages = ref([

  {

    id: '6045235a-a435-46b8-989d-2df38ca2eb47',

    role: 'user',

    parts: [

      {

        type: 'text',

        text: 'Hello, how are you?'

      }

    ]

  }

])

</script>

<template>

  <UChatMessages status="submitted" :messages="messages" />

</template>
```

Here's the detail of the different statuses from the AI SDK v5 Chat class:
- `submitted`: The message has been sent to the API and we're awaiting the start of the response stream.
- `streaming`: The response is actively streaming in from the API, receiving chunks of data.
- `ready`: The full response has been received and processed; a new user message can be submitted.
- `error`: An error occurred during the API request, preventing successful completion.

### User

Use the `user` prop to change the [ChatMessage](https://ui.nuxt.com/docs/components/chat-message) props for `user` messages. Defaults to:

- `side: 'right'`
- `variant: 'soft'`

Hello, how are you?

I am doing well, thank you for asking! How can I assist you today?

What is the current weather in Tokyo?

Based on the latest data, Tokyo is currently experiencing sunny weather with temperatures around 24°C (75°F). It's a beautiful day with clear skies.

```
<script setup lang="ts">

const messages = ref([

  {

    id: '6045235a-a435-46b8-989d-2df38ca2eb47',

    role: 'user',

    parts: [

      {

        type: 'text',

        text: 'Hello, how are you?'

      }

    ]

  },

  {

    id: '7a92b3c1-d5f8-4e76-b8a9-3c1e5fb2e0d8',

    role: 'assistant',

    parts: [

      {

        type: 'text',

        text: 'I am doing well, thank you for asking! How can I assist you today?'

      }

    ]

  },

  {

    id: '9c84d6a7-8b23-4f12-a1d5-e7f3b9c05e2a',

    role: 'user',

    parts: [

      {

        type: 'text',

        text: 'What is the current weather in Tokyo?'

      }

    ]

  },

  {

    id: 'b2e5f8c3-a1d9-4e67-b3f2-c9d8e7a6b5f4',

    role: 'assistant',

    parts: [

      {

        type: 'text',

        text: "Based on the latest data, Tokyo is currently experiencing sunny weather with temperatures around 24°C (75°F). It's a beautiful day with clear skies."

      }

    ]

  }

])

</script>

<template>

  <UChatMessages

    :user="{

      side: 'left',

      variant: 'solid',

      avatar: {

        src: 'https://github.com/benjamincanac.png'

      }

    }"

    :messages="messages"

  />

</template>
```

### Assistant

Use the `assistant` prop to change the [ChatMessage](https://ui.nuxt.com/docs/components/chat-message) props for `assistant` messages. Defaults to:

- `side: 'left'`
- `variant: 'naked'`

Hello, how are you?

I am doing well, thank you for asking! How can I assist you today?

What is the current weather in Tokyo?

Based on the latest data, Tokyo is currently experiencing sunny weather with temperatures around 24°C (75°F). It's a beautiful day with clear skies.

```
<script setup lang="ts">

const messages = ref([

  {

    id: '6045235a-a435-46b8-989d-2df38ca2eb47',

    role: 'user',

    parts: [

      {

        type: 'text',

        text: 'Hello, how are you?'

      }

    ]

  },

  {

    id: '7a92b3c1-d5f8-4e76-b8a9-3c1e5fb2e0d8',

    role: 'assistant',

    parts: [

      {

        type: 'text',

        text: 'I am doing well, thank you for asking! How can I assist you today?'

      }

    ]

  },

  {

    id: '9c84d6a7-8b23-4f12-a1d5-e7f3b9c05e2a',

    role: 'user',

    parts: [

      {

        type: 'text',

        text: 'What is the current weather in Tokyo?'

      }

    ]

  },

  {

    id: 'b2e5f8c3-a1d9-4e67-b3f2-c9d8e7a6b5f4',

    role: 'assistant',

    parts: [

      {

        type: 'text',

        text: "Based on the latest data, Tokyo is currently experiencing sunny weather with temperatures around 24°C (75°F). It's a beautiful day with clear skies."

      }

    ]

  }

])

</script>

<template>

  <UChatMessages

    :assistant="{

      side: 'left',

      variant: 'outline',

      avatar: {

        icon: 'i-lucide-bot'

      },

      actions: [

        {

          label: 'Copy to clipboard',

          icon: 'i-lucide-copy'

        }

      ]

    }"

    :messages="messages"

  />

</template>
```

### Auto Scroll

Use the `auto-scroll` prop to customize or hide the auto scroll button (with `false` value) displayed when scrolling to the top of the chat. Defaults to:

- `color: 'neutral'`
- `variant: 'outline'`

You can pass any property from the [Button](https://ui.nuxt.com/docs/components/button) component to customize it.

Hello, how are you?

I am doing well, thank you for asking! How can I assist you today?

What is the current weather in Tokyo?

Based on the latest data, Tokyo is currently experiencing sunny weather with temperatures around 24°C (75°F). It's a beautiful day with clear skies. The forecast for the rest of the week shows a slight chance of rain on Thursday, with temperatures gradually rising to 28°C by the weekend. Humidity levels are moderate at around 65%, and wind speeds are light at 8 km/h from the southeast. Air quality is good with an index of 42. The UV index is high at 7, so it's recommended to wear sunscreen if you're planning to spend time outdoors. Sunrise was at 5:24 AM and sunset will be at 6:48 PM, giving Tokyo approximately 13 hours and 24 minutes of daylight today. The moon is currently in its waxing gibbous phase.

```
<script setup lang="ts">

const messages = ref([

  {

    id: '6045235a-a435-46b8-989d-2df38ca2eb47',

    role: 'user',

    parts: [

      {

        type: 'text',

        text: 'Hello, how are you?'

      }

    ]

  },

  {

    id: '7a92b3c1-d5f8-4e76-b8a9-3c1e5fb2e0d8',

    role: 'assistant',

    parts: [

      {

        type: 'text',

        text: 'I am doing well, thank you for asking! How can I assist you today?'

      }

    ]

  },

  {

    id: '9c84d6a7-8b23-4f12-a1d5-e7f3b9c05e2a',

    role: 'user',

    parts: [

      {

        type: 'text',

        text: 'What is the current weather in Tokyo?'

      }

    ]

  },

  {

    id: 'b2e5f8c3-a1d9-4e67-b3f2-c9d8e7a6b5f4',

    role: 'assistant',

    parts: [

      {

        type: 'text',

        text: "Based on the latest data, Tokyo is currently experiencing sunny weather with temperatures around 24°C (75°F). It's a beautiful day with clear skies. The forecast for the rest of the week shows a slight chance of rain on Thursday, with temperatures gradually rising to 28°C by the weekend. Humidity levels are moderate at around 65%, and wind speeds are light at 8 km/h from the southeast. Air quality is good with an index of 42. The UV index is high at 7, so it's recommended to wear sunscreen if you're planning to spend time outdoors. Sunrise was at 5:24 AM and sunset will be at 6:48 PM, giving Tokyo approximately 13 hours and 24 minutes of daylight today. The moon is currently in its waxing gibbous phase."

      }

    ]

  },

  {

    id: 'c3e5f8c3-a1d9-4e67-b3f2-c9d8e7a6b5f4',

    role: 'user',

    parts: [

      {

        type: 'text',

        text: 'Can you recommend some popular tourist attractions in Kyoto?'

      }

    ]

  },

  {

    id: 'd4f5g8c3-a1d9-4e67-b3f2-c9d8e7a6b5f4',

    role: 'assistant',

    parts: [

      {

        type: 'text',

        text: 'Kyoto is known for its beautiful temples, traditional tea houses, and gardens. Some popular attractions include Kinkaku-ji (Golden Pavilion) with its stunning gold leaf exterior reflecting in the mirror pond, Fushimi Inari Shrine with its thousands of vermilion torii gates winding up the mountainside, Arashiyama Bamboo Grove where towering stalks create an otherworldly atmosphere, Kiyomizu-dera Temple perched on a hillside offering panoramic views of the city, and the historic Gion district where you might spot geisha hurrying to evening appointments through narrow stone-paved streets lined with traditional wooden machiya houses.'

      }

    ]

  }

])

</script>

<template>

  <UChatMessages

    :auto-scroll="{

      color: 'neutral',

      variant: 'outline'

    }"

    :should-scroll-to-bottom="false"

    :messages="messages"

  />

</template>
```

### Auto Scroll Icon

Use the `auto-scroll-icon` prop to customize the auto scroll button [Icon](https://ui.nuxt.com/docs/components/icon). Defaults to `i-lucide-arrow-down`.

Hello, how are you?

I am doing well, thank you for asking! How can I assist you today?

What is the current weather in Tokyo?

Based on the latest data, Tokyo is currently experiencing sunny weather with temperatures around 24°C (75°F). It's a beautiful day with clear skies. The forecast for the rest of the week shows a slight chance of rain on Thursday, with temperatures gradually rising to 28°C by the weekend. Humidity levels are moderate at around 65%, and wind speeds are light at 8 km/h from the southeast. Air quality is good with an index of 42. The UV index is high at 7, so it's recommended to wear sunscreen if you're planning to spend time outdoors. Sunrise was at 5:24 AM and sunset will be at 6:48 PM, giving Tokyo approximately 13 hours and 24 minutes of daylight today. The moon is currently in its waxing gibbous phase.

```
<script setup lang="ts">

const messages = ref([

  {

    id: '6045235a-a435-46b8-989d-2df38ca2eb47',

    role: 'user',

    parts: [

      {

        type: 'text',

        text: 'Hello, how are you?'

      }

    ]

  },

  {

    id: '7a92b3c1-d5f8-4e76-b8a9-3c1e5fb2e0d8',

    role: 'assistant',

    parts: [

      {

        type: 'text',

        text: 'I am doing well, thank you for asking! How can I assist you today?'

      }

    ]

  },

  {

    id: '9c84d6a7-8b23-4f12-a1d5-e7f3b9c05e2a',

    role: 'user',

    parts: [

      {

        type: 'text',

        text: 'What is the current weather in Tokyo?'

      }

    ]

  },

  {

    id: 'b2e5f8c3-a1d9-4e67-b3f2-c9d8e7a6b5f4',

    role: 'assistant',

    parts: [

      {

        type: 'text',

        text: "Based on the latest data, Tokyo is currently experiencing sunny weather with temperatures around 24°C (75°F). It's a beautiful day with clear skies. The forecast for the rest of the week shows a slight chance of rain on Thursday, with temperatures gradually rising to 28°C by the weekend. Humidity levels are moderate at around 65%, and wind speeds are light at 8 km/h from the southeast. Air quality is good with an index of 42. The UV index is high at 7, so it's recommended to wear sunscreen if you're planning to spend time outdoors. Sunrise was at 5:24 AM and sunset will be at 6:48 PM, giving Tokyo approximately 13 hours and 24 minutes of daylight today. The moon is currently in its waxing gibbous phase."

      }

    ]

  },

  {

    id: 'c3e5f8c3-a1d9-4e67-b3f2-c9d8e7a6b5f4',

    role: 'user',

    parts: [

      {

        type: 'text',

        text: 'Can you recommend some popular tourist attractions in Kyoto?'

      }

    ]

  },

  {

    id: 'd4f5g8c3-a1d9-4e67-b3f2-c9d8e7a6b5f4',

    role: 'assistant',

    parts: [

      {

        type: 'text',

        text: 'Kyoto is known for its beautiful temples, traditional tea houses, and gardens. Some popular attractions include Kinkaku-ji (Golden Pavilion) with its stunning gold leaf exterior reflecting in the mirror pond, Fushimi Inari Shrine with its thousands of vermilion torii gates winding up the mountainside, Arashiyama Bamboo Grove where towering stalks create an otherworldly atmosphere, Kiyomizu-dera Temple perched on a hillside offering panoramic views of the city, and the historic Gion district where you might spot geisha hurrying to evening appointments through narrow stone-paved streets lined with traditional wooden machiya houses.'

      }

    ]

  }

])

</script>

<template>

  <UChatMessages

    auto-scroll-icon="i-lucide-chevron-down"

    :should-scroll-to-bottom="false"

    :messages="messages"

  />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.arrowDown` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.arrowDown` key.

### Should Auto Scroll

Use the `should-auto-scroll` prop to enable/disable continuous auto scroll while messages are streaming. Defaults to `false`.

```
<template>

  <UChatMessages :messages="messages" should-auto-scroll />

</template>
```

Use the `should-scroll-to-bottom` prop to enable/disable bottom auto scroll when the component is mounted. Defaults to `true`.

```
<template>

  <UChatMessages :messages="messages" :should-scroll-to-bottom="false" />

</template>
```

## Examples

The Chat components are designed to be used with the [Vercel AI SDK](https://ai-sdk.dev/), specifically the [`Chat`](https://ai-sdk.dev/docs/reference/ai-sdk-ui/use-chat) class for managing chat state and streaming responses.

First, install the required dependencies:

Then, create a server API endpoint to handle chat requests using [`streamText`](https://ai-sdk.dev/docs/reference/ai-sdk-core/stream-text) from the AI SDK. You can use the [Vercel AI Gateway](https://vercel.com/ai-gateway) to access AI models through a centralized endpoint:

server/api/chat.post.ts

```ts
import { streamText, convertToModelMessages } from 'ai'

import { gateway } from '@ai-sdk/gateway'

export default defineEventHandler(async (event) => {

  const { messages } = await readBody(event)

  return streamText({

    model: gateway('openai/gpt-4o-mini'),

    maxOutputTokens: 10000,

    system: 'You are a helpful assistant.',

    messages: await convertToModelMessages(messages)

  }).toUIMessageStreamResponse()

})
```

Check out the source code of our **AI Chat template** on GitHub for a real-life example.

### Within a page

Use the ChatMessages component with the `Chat` class from AI SDK v5 to display a list of chat messages within a page.

Pass the `messages` prop alongside the `status` prop that will be used for the auto scroll and the indicator display.

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

In this example, we use the `MDC` component from [`@nuxtjs/mdc`](https://github.com/nuxt-modules/mdc) to render the assistant messages as markdown. User messages are rendered as plain text to prevent XSS vulnerabilities. As Nuxt UI provides pre-styled prose components, your content will be automatically styled.

### With indicator slot

You can customize the loading indicator that appears when the status is `submitted`.

Hello! Can you help me with something?

```
<template>

  <UChatMessages

    :messages="[

      {

        id: '1',

        role: 'user',

        parts: [{ type: 'text', text: 'Hello! Can you help me with something?' }]

      }

    ]"

    status="submitted"

    :should-scroll-to-bottom="false"

    :user="{

      avatar: { icon: 'i-lucide-user' },

      variant: 'soft',

      side: 'right'

    }"

  >

    <template #indicator>

      <UButton

        class="px-0"

        color="neutral"

        variant="link"

        loading

        loading-icon="i-lucide-loader"

        label="Thinking..."

      />

    </template>

  </UChatMessages>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `messages` |  | ` UIMessage<unknown, UIDataTypes, UITools>[]` |
| `status` |  | ` "error" \| "submitted" \| "streaming" \| "ready"` |
| `shouldAutoScroll` | `false` | `boolean`  Whether to automatically scroll to the bottom when a message is streaming. |
| `shouldScrollToBottom` | `true` | `boolean`  Whether to scroll to the bottom on mounted. |
| `autoScroll` | `true` | `boolean \| Omit<ButtonProps, LinkPropsKeys>`  Display an auto scroll button.`{ size: 'md', color: 'neutral', variant: 'outline' }` |
| `autoScrollIcon` | `appConfig.ui.icons.arrowDown` | `any`  The icon displayed in the auto scroll button. |
| `user` |  | ` Pick<ChatMessageProps, "ui" \| "variant" \| "icon" \| "avatar" \| "side" \| "actions">`  The `user` messages props.`{ side: 'right', variant: 'soft' }` |
| `assistant` |  | ` Pick<ChatMessageProps, "ui" \| "variant" \| "icon" \| "avatar" \| "side" \| "actions">`  The `assistant` messages props.`{ side: 'left', variant: 'naked' }` |
| `compact` | `false` | `boolean`  Render the messages in a compact style. This is done automatically when used inside a `UChatPalette`. |
| `spacingOffset` | `0` | ` number`  The spacing offset for the last message in px. Can be useful when the prompt is sticky for example. |
| `ui` |  | ` { root?: ClassNameValue; indicator?: ClassNameValue; viewport?: ClassNameValue; autoScroll?: ClassNameValue; }` |

### Slots

| Slot | Type |
| --- | --- |
| `leading` | `{ avatar: (AvatarProps & { [key: string]: any; }) \| undefined; ui: object; } & { message: UIMessage<unknown, UIDataTypes, UITools>; }` |
| `content` | `ChatMessageProps & { message: UIMessage<unknown, UIDataTypes, UITools>; }` |
| `actions` | `{ actions: (Omit<ButtonProps, "onClick"> & { onClick?: ((e: MouseEvent, message: UIMessage<unknown, UIDataTypes, UITools>) => void) \| undefined; })[] \| undefined; } & { message: UIMessage<unknown, UIDataTypes, UITools>; }` |
| `default` | `{}` |
| `indicator` | `{ ui: object; }` |
| `viewport` | `{ ui: object; }` |

You can use all the slots of the [`ChatMessage`](https://ui.nuxt.com/docs/components/chat-message#slots) component inside ChatMessages, they are automatically forwarded allowing you to customize individual messages when using the `messages` prop.

```
<template>

  <UChatMessages :messages="messages" :status="status">

    <template #content="{ message }">

      <template v-for="(part, index) in message.parts" :key="\`${message.id}-${part.type}-${index}\`">

        <MDC v-if="part.type === 'text' && message.role === 'assistant'" :value="part.text" :cache-key="\`${message.id}-${index}\`" class="*:first:mt-0 *:last:mb-0" />

        <p v-else-if="part.type === 'text' && message.role === 'user'" class="whitespace-pre-wrap">{{ part.text }}</p>

      </template>

    </template>

  </UChatMessages>

</template>
```

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    chatMessages: {

      slots: {

        root: 'w-full flex flex-col gap-1 flex-1 px-2.5 [&>article]:last-of-type:min-h-(--last-message-height)',

        indicator: 'h-6 flex items-center gap-1 py-3 *:size-2 *:rounded-full *:bg-elevated [&>*:nth-child(1)]:animate-[bounce_1s_infinite] [&>*:nth-child(2)]:animate-[bounce_1s_0.15s_infinite] [&>*:nth-child(3)]:animate-[bounce_1s_0.3s_infinite]',

        viewport: 'absolute inset-x-0 top-[86%] data-[state=open]:animate-[fade-in_200ms_ease-out] data-[state=closed]:animate-[fade-out_200ms_ease-in]',

        autoScroll: 'rounded-full absolute right-1/2 translate-x-1/2 bottom-0'

      },

      variants: {

        compact: {

          true: '',

          false: ''

        }

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

        chatMessages: {

          slots: {

            root: 'w-full flex flex-col gap-1 flex-1 px-2.5 [&>article]:last-of-type:min-h-(--last-message-height)',

            indicator: 'h-6 flex items-center gap-1 py-3 *:size-2 *:rounded-full *:bg-elevated [&>*:nth-child(1)]:animate-[bounce_1s_infinite] [&>*:nth-child(2)]:animate-[bounce_1s_0.15s_infinite] [&>*:nth-child(3)]:animate-[bounce_1s_0.3s_infinite]',

            viewport: 'absolute inset-x-0 top-[86%] data-[state=open]:animate-[fade-in_200ms_ease-out] data-[state=closed]:animate-[fade-out_200ms_ease-in]',

            autoScroll: 'rounded-full absolute right-1/2 translate-x-1/2 bottom-0'

          },

          variants: {

            compact: {

              true: '',

              false: ''

            }

          }

        }

      }

    })

  ]

})
```

## Changelog

[`184ea`](https://github.com/nuxt/ui/commit/184eaab1cd5f4f4943b509ea1a3efb1b6f6d7f91) — chore: reduce type verbosity by omitting link props from action buttons

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`db737`](https://github.com/nuxt/ui/commit/db73765d7ab7af6ae5c71d85057f66eb2e422754) — fix: allow user scroll with `should-auto-scroll` ([#5252](https://github.com/nuxt/ui/issues/5252))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`240bc`](https://github.com/nuxt/ui/commit/240bc1ac7c7f124a5f6d7795ce365fc2288125c5) — fix: define user & assistant `ui` prop type ([#5234](https://github.com/nuxt/ui/issues/5234))

[`ff67f`](https://github.com/nuxt/ui/commit/ff67fa368bfd4f73d77eeed13fecf04674d41d76) — fix: watch deep to handle streaming with `parts`

[`0db62`](https://github.com/nuxt/ui/commit/0db622acfb78f4dcb75b8f71694b6db502e10507) — fix: ensure content is render before scrolling

[`c00bf`](https://github.com/nuxt/ui/commit/c00bf30497ac0235e45ece5edeaf53e13da4a5dc) — fix: wrap indicator with slot ([#5036](https://github.com/nuxt/ui/issues/5036))

[`3173b`](https://github.com/nuxt/ui/commit/3173bee38ce9e518076848999f14374600069d35) — fix: proxySlots reactivity ([#4969](https://github.com/nuxt/ui/issues/4969))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`de782`](https://github.com/nuxt/ui/commit/de7822f6a11f6d1830421db337237c6e16f530b1) — feat!: upgrade `ai-sdk` to v5 ([#4698](https://github.com/nuxt/ui/issues/4698))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[ChatMessage](https://ui.nuxt.com/docs/components/chat-message)

[

Display a chat message with icon, avatar, and actions.

](https://ui.nuxt.com/docs/components/chat-message)[

ChatPalette

A chat palette to create a chatbot interface inside an overlay.

](https://ui.nuxt.com/docs/components/chat-palette)