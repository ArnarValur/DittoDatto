# Migration to v4

> A comprehensive guide to migrate your application from Nuxt UI v3 to Nuxt UI v4.

Nuxt UI v4 marks a major milestone: **Nuxt UI and Nuxt UI Pro are now unified into a single, fully open-source and free library**. You now have access to 100+ production-ready components, all available in the `@nuxt/ui` package.

<note>

Nuxt UI v4 requires **Nuxt 4** due to some dependencies. Make sure to upgrade to Nuxt 4 before migrating to Nuxt UI v4.

</note>

This guide provides step-by-step instructions to migrate your application from v3 to v4.

## Migrate your project

### From Nuxt UI Pro

1. Replace `@nuxt/ui-pro` with `@nuxt/ui` in your `package.json`:

<code-group sync="pm">

```bash [pnpm]
pnpm remove @nuxt/ui-pro
pnpm add @nuxt/ui
```

```bash [yarn]
yarn remove @nuxt/ui-pro
yarn add @nuxt/ui
```

```bash [npm]
npm uninstall @nuxt/ui-pro
npm install @nuxt/ui
```

```bash [bun]
bun remove @nuxt/ui-pro
bun add @nuxt/ui
```

</code-group>

<framework-only>
<template v-slot:nuxt="">
<div>

1. Replace `@nuxt/ui-pro` with `@nuxt/ui` in your `nuxt.config.ts`:

```diff [nuxt.config.ts]
export default defineNuxtConfig({
  modules: [
-   '@nuxt/ui-pro',
+   '@nuxt/ui'
  ]
})
```

</div>
</template>

<template v-slot:vue="">
<div>

1. Replace `@nuxt/ui-pro` with `@nuxt/ui` in your `vite.config.ts`:

```diff [vite.config.ts]
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'
- import uiPro from '@nuxt/ui-pro/vite'
+ import ui from '@nuxt/ui/vite'

export default defineConfig({
  plugins: [
    vue(),
-   uiPro({
+   ui({
      ui: {
        colors: {
          primary: 'green',
          neutral: 'slate'
        }
      }
    })
  ]
})
```

</div>
</template>
</framework-only>

<framework-only>
<template v-slot:nuxt="">
<div>

1. Use the `ui` key instead of `uiPro` in your `app.config.ts`:

```diff [app.config.ts]
export default defineAppConfig({
  ui: {
    colors: {
      primary: 'green',
      neutral: 'slate'
    },
+   pageCard: {
+     slots: {
+       root: 'rounded-xl',
+     }
+   }
  },
- uiPro: {
-   pageCard: {
-     slots: {
-       root: 'rounded-xl',
-     }
-   }
- }
})
```

</div>
</template>

<template v-slot:vue="">
<div>

1. Use the `ui` key instead of `uiPro` in your `vite.config.ts`:

```diff [vite.config.ts]
export default defineConfig({
  plugins: [
    vue(),
    ui({
      ui: {
        colors: {
          primary: 'green',
          neutral: 'slate'
        },
+       pageCard: {
+         slots: {
+           root: 'rounded-xl',
+         }
+       }
      },
-     uiPro: {
-       pageCard: {
-         slots: {
-           root: 'rounded-xl',
-         }
-       }
-     }
    })
  ]
})
```

</div>
</template>
</framework-only>

1. Replace `@nuxt/ui-pro` with `@nuxt/ui` in your CSS:

<framework-only>
<template v-slot:nuxt="">
<div>

```diff [app/assets/css/main.css]
@import "tailwindcss";
- @import "@nuxt/ui-pro";
+ @import "@nuxt/ui";
```

<warning>

If you are upgrading to Nuxt 4 at the same time as Nuxt UI v4, make sure to update the `@source` directive to match the new directory structure.

```diff [app/assets/css/main.css]
@import "tailwindcss";
@import "@nuxt/ui";

- @source "../../content/**/*";
+ @source "../../../content/**/*";
```

</warning>
</div>
</template>

<template v-slot:vue="">
<div>

```diff [src/assets/css/main.css]
@import "tailwindcss";
- @import "@nuxt/ui-pro";
+ @import "@nuxt/ui";
```

</div>
</template>
</framework-only>

1. Replace `@nuxt/ui-pro` with `@nuxt/ui` in your imports:

```diff
- import type { BannerProps } from '@nuxt/ui-pro'
+ import type { BannerProps } from '@nuxt/ui'
```

### From Nuxt UI

1. When upgrading from Nuxt UI v3, you simply need to update to v4:

<code-group sync="pm">

```bash [pnpm]
pnpm add @nuxt/ui
```

```bash [yarn]
yarn add @nuxt/ui
```

```bash [npm]
npm install @nuxt/ui
```

```bash [bun]
bun add @nuxt/ui
```

</code-group>

## Changes from v3

After upgrading to Nuxt UI v4, please note the following important changes:

### Renamed ButtonGroup

The `ButtonGroup` component has been renamed to [`FieldGroup`](/docs/components/field-group):

```diff
<template>
- <UButtonGroup>
+ <UFieldGroup>
    <UButton label="Button" />
    <UButton icon="i-lucide-chevron-down" />
+ </UFieldGroup>
- </UButtonGroup>
</template>
```

### Renamed PageMarquee

The `PageMarquee` component has been renamed to [`Marquee`](/docs/components/marquee):

```diff
<template>
- <UPageMarquee :items="items" />
+ <UMarquee :items="items" />
</template>
```

### Removed PageAccordion

The `PageAccordion` component has been removed in favor of [`Accordion`](/docs/components/accordion):

```diff
<template>
- <UPageAccordion
+ <UAccordion
    :items="items"
+   :unmount-on-hide="false"
+   :ui="{ trigger: 'text-base', body: 'text-base text-muted' }"
  />
</template>
```

<note>

The `PageAccordion` component was a wrapper that set `unmount-on-hide` to `false` and customized the `ui` prop.

</note>

### Renamed model modifiers

The `modelModifiers` shape used by [`Input`](/docs/components/input), [`InputNumber`](/docs/components/input-number) and [`Textarea`](/docs/components/textarea) has changed in v4:

1. The `nullify` modifier was renamed to `nullable` (it converts empty/blank values to `null`).
2. A new `optional` modifier was added (it converts empty/blank values to `undefined`).

```diff
- <UInput v-model.nullify="value" />
+ <UInput v-model.nullable="value" />
```

```diff
- <UTextarea v-model="value" :model-modifiers="{ nullify: true }" />
+ <UTextarea v-model="value" :model-modifiers="{ nullable: true }" />
```

Use `nullable` when you want empty values as `null`, and `optional` when you prefer `undefined` for absent values.

### Changes to Form component

The `Form` component has been improved in v4 with better state management and nested form handling. Here are the key changes you need to be aware of:

1. Schema **transformations will only** be applied to the **@submit data** and will no longer mutate the form's state. This provides better predictability and prevents unexpected state mutations.
2. **Nested forms must be enabled explicitly** using the `nested` prop. This makes the component behavior more explicit and prevents accidental nested form creation.
3. **Nested forms should now provide a name** prop (similar to `UFormField`) and will automatically inherit their state from their parent form.

```diff
<template>
  <UForm :state="state" :schema="schema" @submit="onSubmit">
    <UFormField label="Customer" name="customer">
      <UInput v-model="state.customer" placeholder="Wonka Industries" />
    </UFormField>

    <div v-for="(item, index) in state.items" :key="index">
      <UForm
-       :state="item"
+       :name="`items.${index}`"
        :schema="itemSchema"
+       nested
      >
        <UFormField :label="!index ? 'Description' : undefined" name="description">
          <UInput v-model="item.description" />
        </UFormField>
        <UFormField :label="!index ? 'Price' : undefined" name="price">
          <UInput v-model="item.price" type="number" />
        </UFormField>
      </UForm>
    </div>
  </UForm>
</template>
```

### Removed deprecated utilities

Some **Nuxt Content utilities** that were previously available in Nuxt UI Pro have been **removed** in v4:

- `findPageBreadcrumb`
- `findPageHeadline`

These are now fully provided by Nuxt Content. Make sure to update your imports and usage accordingly.

```diff
- import { findPageHeadline } from '@nuxt/ui-pro/utils/content'
+ import { findPageHeadline } from '@nuxt/content/utils'

- import { findPageBreadcrumb } from '@nuxt/ui-pro/utils/content'
+ import { findPageBreadcrumb } from '@nuxt/content/utils'
```

### AI SDK v5 migration (optional)

This section only applies if you're using the AI SDK and chat components (`ChatMessage`, `ChatMessages`, `ChatPrompt`, `ChatPromptSubmit`, `ChatPalette`). If you're not using AI features, you can skip this section.

1. Update `@ai-sdk/vue` and `ai` dependencies in your `package.json`:

```diff
{
  "dependencies": {
-   "@ai-sdk/vue": "^1.2.x",
+   "@ai-sdk/vue": "^2.0.x",
-   "ai": "^4.3.x"
+   "ai": "^5.0.x"
  }
}
```

1. `useChat` composable has been replaced with the new `Chat` class:

```diff
<script setup lang="ts">
- import { useChat } from '@ai-sdk/vue'
+ import { Chat } from '@ai-sdk/vue'
+ import type { UIMessage } from 'ai'

- const { messages, input, handleSubmit, status, error, reload, setMessages } = useChat()
+ const messages: UIMessage[] = []
+ const input = ref('')
+
+ const chat = new Chat({
+   messages
+ })
+
+ function handleSubmit() {
+   chat.sendMessage({ text: input.value })
+   input.value = ''
+ }
</script>
```

1. Messages now use `parts` instead of `content`:

```diff
// When manually creating messages
- setMessages([{
+ messages.push({
  id: '1',
  role: 'user',
- content: 'Hello world'
+ parts: [{ type: 'text', text: 'Hello world' }]
- }])
+ })

// In templates
<template>
- <UChatMessage :content="message.content" />
+ <UChatMessage :parts="message.parts" />
</template>
```

1. Some methods have been renamed:

```diff
// Regenerate the last message
- reload()
+ chat.regenerate()

// Access chat state
- :messages="messages"
- :status="status"
+ :messages="chat.messages"
+ :status="chat.status"
```

1. New `getTextFromMessage` utility to extract text from AI SDK v5 message parts:

```vue
<script setup lang="ts">
import { getTextFromMessage } from '@nuxt/ui/utils/ai'
</script>

<template>
  <UChatMessages :messages="chat.messages" :status="chat.status">
    <template #content="{ message }">
      <!-- Extract text from message parts and render with MDC -->
      <MDC :value="getTextFromMessage(message)" :cache-key="message.id" class="*:first:mt-0 *:last:mb-0" />
    </template>
  </UChatMessages>
</template>
```

<note target="_blank" to="https://ai-sdk.dev/docs/migration-guides/migration-guide-5-0">

For more details on AI SDK v5 changes, review the **official AI SDK v5 migration guide**.

</note>

<tip target="_blank" to="https://github.com/nuxt/ui/pull/4698">

View all changes from AI SDK v4 to v5 **in the upgrade PR** for a detailed migration reference.

</tip>
