# ChatMessage

> Display a chat message with icon, avatar, and actions.

## Usage

The ChatMessage component renders an `<article>` element for a `user` or `assistant` chat message.

<code-preview>
<u-chat-message :avatar="{"src":"https://github.com/benjamincanac.png"}" :parts="[{"type":"text","id":"1","text":"Hello! Tell me more about building AI chatbots with Nuxt UI."}]" id="1" role="user" side="right" variant="soft">



</u-chat-message>
</code-preview>

<tip to="/docs/components/chat-messages">

Use the [`ChatMessages`](/docs/components/chat-messages) component to display a list of chat messages.

</tip>

### Parts

Use the `parts` prop to display the message content using the AI SDK v5 format.

```vue
<template>
  <UChatMessage role="user" id="1" />
</template>
```

<note>

The `parts` prop is the recommended format for AI SDK v5. Each part has a `type` (e.g., 'text') and corresponding content. The ChatMessage component also supports the deprecated `content` prop for backward compatibility.

</note>

### Side

Use the `side` prop to display the message on the left or right.

```vue
<template>
  <UChatMessage side="right" role="user" id="1" />
</template>
```

<note>

When using the [`ChatMessages`](/docs/components/chat-messages) component, the `side` prop is set to `left` for `assistant` messages and `right` for `user` messages.

</note>

### Variant

Use the `variant` prop to change style of the message.

```vue
<template>
  <UChatMessage variant="soft" role="user" id="1" />
</template>
```

<note>

When using the [`ChatMessages`](/docs/components/chat-messages) component, the `variant` prop is set to `naked` for `assistant` messages and `soft` for `user` messages.

</note>

### Icon

Use the `icon` prop to display an [Icon](/docs/components/icon) component next to the message.

```vue
<template>
  <UChatMessage icon="i-lucide-user" variant="soft" side="right" role="user" id="1" />
</template>
```

### Avatar

Use the `avatar` prop to display an [Avatar](/docs/components/avatar) component next to the message.

```vue
<template>
  <UChatMessage variant="soft" side="right" role="user" id="1" />
</template>
```

You can also use the `avatar.icon` prop to display an icon as the avatar.

```vue
<template>
  <UChatMessage role="assistant" id="1" />
</template>
```

### Actions

Use the `actions` prop to display actions below the message that will be displayed when hovering over the message.

```vue
<template>
  <UChatMessage role="user" id="1" />
</template>
```

## API

### Props

```ts
/**
 * Props for the ChatMessage component
 */
interface ChatMessageProps {
  /**
   * A unique identifier for the message.
   */
  id: string;
  /**
   * The role of the message.
   */
  role: "system" | "user" | "assistant";
  /**
   * The parts of the message. Use this for rendering the message in the UI.
   * 
   * System messages should be avoided (set the system prompt on the server instead).
   * They can have text parts.
   * 
   * User messages can have text parts and file parts.
   * 
   * Assistant messages can have text, reasoning, tool invocation, and file parts.
   */
  parts: UIMessagePart<UIDataTypes, UITools>[];
  /**
   * The element or component this component should render as.
   * @default "\"article\""
   */
  as?: any;
  icon?: any;
  avatar?: (AvatarProps & { [key: string]: any; }) | undefined;
  variant?: "solid" | "outline" | "soft" | "subtle" | "naked" | undefined;
  side?: "left" | "right" | undefined;
  /**
   * Display a list of actions under the message.
   * The `label` will be used in a tooltip.
   * `{ size: 'xs', color: 'neutral', variant: 'ghost' }`{lang="ts-type"}
   */
  actions?: (Omit<ButtonProps, "onClick"> & { onClick?: ((e: MouseEvent, message: UIMessage<unknown, UIDataTypes, UITools>) => void) | undefined; })[] | undefined;
  /**
   * Render the message in a compact style.
   * This is done automatically when used inside a `UChatPalette`{lang="ts-type"}.
   */
  compact?: boolean | undefined;
  content?: string | undefined;
  ui?: { root?: ClassNameValue; container?: ClassNameValue; leading?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; content?: ClassNameValue; actions?: ClassNameValue; } | undefined;
  /**
   * The metadata of the message.
   */
  metadata?: unknown;
}
```

### Slots

```ts
/**
 * Slots for the ChatMessage component
 */
interface ChatMessageSlots {
  leading(): any;
  content(): any;
  actions(): any;
}
```

## Theme

```ts [app.config.ts]
export default defineAppConfig({
  ui: {
    chatMessage: {
      slots: {
        root: 'group/message relative w-full',
        container: 'relative flex items-start',
        leading: 'inline-flex items-center justify-center min-h-6',
        leadingIcon: 'shrink-0',
        leadingAvatar: 'shrink-0',
        leadingAvatarSize: '',
        content: 'relative text-pretty min-w-0 *:first:mt-0 *:last:mb-0',
        actions: [
          'opacity-0 group-hover/message:opacity-100 absolute bottom-0 flex items-center',
          'transition-opacity'
        ]
      },
      variants: {
        variant: {
          solid: {
            content: 'bg-inverted text-inverted'
          },
          outline: {
            content: 'bg-default ring ring-default'
          },
          soft: {
            content: 'bg-elevated/50'
          },
          subtle: {
            content: 'bg-elevated/50 ring ring-default'
          },
          naked: {
            content: ''
          }
        },
        side: {
          left: {
            container: 'rtl:justify-end'
          },
          right: {
            container: 'ltr:justify-end ms-auto max-w-[75%]'
          }
        },
        leading: {
          true: ''
        },
        actions: {
          true: ''
        },
        compact: {
          true: {
            root: 'scroll-mt-3',
            container: 'gap-1.5 pb-3',
            leadingIcon: 'size-5',
            leadingAvatarSize: '2xs'
          },
          false: {
            root: 'scroll-mt-4 sm:scroll-mt-6',
            container: 'gap-3 pb-8',
            leadingIcon: 'size-8',
            leadingAvatarSize: 'md'
          }
        }
      },
      compoundVariants: [
        {
          compact: true,
          actions: true,
          class: {
            container: 'pb-8'
          }
        },
        {
          leading: true,
          compact: false,
          side: 'left',
          class: {
            actions: 'left-11'
          }
        },
        {
          leading: true,
          compact: true,
          side: 'left',
          class: {
            actions: 'left-6.5'
          }
        },
        {
          variant: [
            'solid',
            'outline',
            'soft',
            'subtle'
          ],
          compact: false,
          class: {
            content: 'px-4 py-3 rounded-lg min-h-12',
            leading: 'mt-2'
          }
        },
        {
          variant: [
            'solid',
            'outline',
            'soft',
            'subtle'
          ],
          compact: true,
          class: {
            content: 'px-2 py-1 rounded-lg min-h-8',
            leading: 'mt-1'
          }
        },
        {
          variant: 'naked',
          side: 'left',
          class: {
            content: 'w-full'
          }
        }
      ],
      defaultVariants: {
        variant: 'naked'
      }
    }
  }
})
```

## Changelog

<component-changelog>



</component-changelog>
