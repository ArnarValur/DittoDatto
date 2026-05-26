# ChatPalette

> A chat palette to create a chatbot interface inside an overlay.

## Usage

The ChatPalette component is a structured layout wrapper that organizes [ChatMessages](/docs/components/chat-messages) in a scrollable content area and [ChatPrompt](/docs/components/chat-prompt) in a fixed bottom section, creating cohesive chatbot interfaces for modals, slideovers, or drawers.

```vue
<template>
  <UChatPalette>
    <UChatMessages />

    <template #prompt>
      <UChatPrompt />
    </template>
  </UChatPalette>
</template>
```

## Examples

<note target="_blank" to="https://ai-sdk.dev/docs/getting-started/nuxt">

These chat components are designed to be used with the **AI SDK v5** from **Vercel AI SDK**.

</note>

### Within a Modal

You can use the ChatPalette component inside a [Modal](/docs/components/modal)'s content.

```vue [ChatPaletteModalExample.vue]
<script setup lang="ts">
import { Chat } from '@ai-sdk/vue'
import type { UIMessage } from 'ai'
import { getTextFromMessage } from '@nuxt/ui/utils/ai'

const messages: UIMessage[] = []
const input = ref('')

const chat = new Chat({
  messages
})

function onSubmit() {
  chat.sendMessage({ text: input.value })

  input.value = ''
}
</script>

<template>
  <UModal open :ui="{ content: 'sm:max-w-3xl sm:h-[28rem]' }">
    <template #content>
      <UChatPalette>
        <UChatMessages
          :messages="chat.messages"
          :status="chat.status"
          :user="{ side: 'left', variant: 'naked', avatar: { src: 'https://github.com/benjamincanac.png' } }"
          :assistant="{ icon: 'i-lucide-bot' }"
        >
          <template #content="{ message }">
            <MDC
              :value="getTextFromMessage(message)"
              :cache-key="message.id"
              class="[&_.my-5]:my-2.5 *:first:!mt-0 *:last:!mb-0 [&_.leading-7]:!leading-6"
            />
          </template>
        </UChatMessages>

        <template #prompt>
          <UChatPrompt
            v-model="input"
            icon="i-lucide-search"
            variant="naked"
            :error="chat.error"
            @submit="onSubmit"
          />
        </template>
      </UChatPalette>
    </template>
  </UModal>
</template>
```

### Within ContentSearch

You can use the ChatPalette component conditionally inside [ContentSearch](/docs/components/content-search)'s content to display a chatbot interface when a user selects an item.

```vue [ChatPaletteContentSearchExample.vue]
<script setup lang="ts">
import { Chat } from '@ai-sdk/vue'
import type { UIMessage } from 'ai'
import { getTextFromMessage } from '@nuxt/ui/utils/ai'

const messages: UIMessage[] = []
const input = ref('')

const groups = computed(() => [{
  id: 'ai',
  ignoreFilter: true,
  items: [{
    label: searchTerm.value ? `Ask AI for “${searchTerm.value}”` : 'Ask AI',
    icon: 'i-lucide-bot',
    onSelect: (e: any) => {
      e.preventDefault()

      ai.value = true

      if (searchTerm.value) {
        messages.push({
          id: '1',
          role: 'user',
          parts: [{ type: 'text', text: searchTerm.value }]
        })

        chat.regenerate()
      }
    }
  }]
}])

const ai = ref(false)
const searchTerm = ref('')

const chat = new Chat({
  messages
})

function onSubmit() {
  chat.sendMessage({ text: input.value })

  input.value = ''
}

function onClose(e: Event) {
  e.preventDefault()

  ai.value = false
}
</script>

<template>
  <UContentSearch v-model:search-term="searchTerm" open :groups="groups">
    <template v-if="ai" #content>
      <UChatPalette>
        <UChatMessages
          :messages="chat.messages"
          :status="chat.status"
          :user="{ side: 'left', variant: 'naked', avatar: { src: 'https://github.com/benjamincanac.png' } }"
          :assistant="{ icon: 'i-lucide-bot' }"
        >
          <template #content="{ message }">
            <MDC
              :value="getTextFromMessage(message)"
              :cache-key="message.id"
              class="[&_.my-5]:my-2.5 *:first:!mt-0 *:last:!mb-0 [&_.leading-7]:!leading-6"
            />
          </template>
        </UChatMessages>

        <template #prompt>
          <UChatPrompt
            v-model="input"
            icon="i-lucide-search"
            variant="naked"
            :error="chat.error"
            @submit="onSubmit"
            @close="onClose"
          />
        </template>
      </UChatPalette>
    </template>
  </UContentSearch>
</template>
```

## API

### Props

```ts
/**
 * Props for the ChatPalette component
 */
interface ChatPaletteProps {
  /**
   * The element or component this component should render as.
   */
  as?: any;
  ui?: { root?: ClassNameValue; prompt?: ClassNameValue; close?: ClassNameValue; content?: ClassNameValue; } | undefined;
}
```

### Slots

```ts
/**
 * Slots for the ChatPalette component
 */
interface ChatPaletteSlots {
  default(): any;
  prompt(): any;
}
```

## Theme

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    chatPalette: {
      slots: {
        root: 'relative flex-1 flex flex-col min-h-0 min-w-0',
        prompt: 'px-0 rounded-t-none border-t border-default',
        close: '',
        content: 'overflow-y-auto flex-1 flex flex-col py-3'
      }
    }
  }
})
```

## Changelog

<component-changelog>



</component-changelog>
