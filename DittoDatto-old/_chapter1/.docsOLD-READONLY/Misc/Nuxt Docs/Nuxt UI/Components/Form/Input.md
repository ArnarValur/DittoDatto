---
title: "Vue Input Component"
source: "https://ui.nuxt.com/docs/components/input"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "An input element to enter text."
tags:
---
## Input

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Input.vue)

An input element to enter text.

## Usage

Use the `v-model` directive to control the value of the Input.

```
<script setup lang="ts">

const value = ref('')

</script>

<template>

  <UInput v-model="value" />

</template>
```

### Type

Use the `type` prop to change the input type. Defaults to `text`.

Some types have been implemented in their own components such as [Checkbox](https://ui.nuxt.com/docs/components/checkbox), [Radio](https://ui.nuxt.com/docs/components/radio-group), [InputNumber](https://ui.nuxt.com/docs/components/input-number) etc. and others have been styled like `file` for example.

```
<template>

  <UInput type="file" />

</template>
```

You can check all the available types on the MDN Web Docs.

### Placeholder

Use the `placeholder` prop to set a placeholder text.

```
<template>

  <UInput placeholder="Search..." />

</template>
```

### Color

Use the `color` prop to change the ring color when the Input is focused.

```
<template>

  <UInput color="neutral" highlight placeholder="Search..." />

</template>
```

The `highlight` prop is used here to show the focus state. It's used internally when a validation error occurs.

### Variant

Use the `variant` prop to change the variant of the Input.

```
<template>

  <UInput color="neutral" variant="subtle" placeholder="Search..." />

</template>
```

### Size

Use the `size` prop to change the size of the Input.

```
<template>

  <UInput size="xl" placeholder="Search..." />

</template>
```

### Icon

Use the `icon` prop to show an [Icon](https://ui.nuxt.com/docs/components/icon) inside the Input.

```
<template>

  <UInput icon="i-lucide-search" size="md" variant="outline" placeholder="Search..." />

</template>
```

Use the `leading` and `trailing` props to set the icon position or the `leading-icon` and `trailing-icon` props to set a different icon for each position.

```
<template>

  <UInput trailing-icon="i-lucide-at-sign" placeholder="Enter your email" size="md" />

</template>
```

Use the `avatar` prop to show an [Avatar](https://ui.nuxt.com/docs/components/avatar) inside the Input.

```
<template>

  <UInput

    :avatar="{

      src: 'https://github.com/nuxt.png'

    }"

    size="md"

    variant="outline"

    placeholder="Search..."

  />

</template>
```

Use the `loading` prop to show a loading icon on the Input.

```
<template>

  <UInput loading placeholder="Search..." />

</template>
```

Use the `loading-icon` prop to customize the loading icon. Defaults to `i-lucide-loader-circle`.

```
<template>

  <UInput loading loading-icon="i-lucide-loader" placeholder="Search..." />

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.loading` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.loading` key.

### Disabled

Use the `disabled` prop to disable the Input.

```
<template>

  <UInput disabled placeholder="Search..." />

</template>
```

## Examples

### With clear button

You can put a [Button](https://ui.nuxt.com/docs/components/button) inside the `#trailing` slot to clear the Input.

```
<script setup lang="ts">

const value = ref('Click to clear')

</script>

<template>

  <UInput

    v-model="value"

    placeholder="Type something..."

    :ui="{ trailing: 'pe-1' }"

  >

    <template v-if="value?.length" #trailing>

      <UButton

        color="neutral"

        variant="link"

        size="sm"

        icon="i-lucide-circle-x"

        aria-label="Clear input"

        @click="value = ''"

      />

    </template>

  </UInput>

</template>
```

### With copy button

You can put a [Button](https://ui.nuxt.com/docs/components/button) inside the `#trailing` slot to copy the value to the clipboard.

```
<script setup lang="ts">

import { useClipboard } from '@vueuse/core'

const value = ref('npx nuxt module add ui')

const { copy, copied } = useClipboard()

</script>

<template>

  <UInput

    v-model="value"

    :ui="{ trailing: 'pr-0.5' }"

  >

    <template v-if="value?.length" #trailing>

      <UTooltip text="Copy to clipboard" :content="{ side: 'right' }">

        <UButton

          :color="copied ? 'success' : 'neutral'"

          variant="link"

          size="sm"

          :icon="copied ? 'i-lucide-copy-check' : 'i-lucide-copy'"

          aria-label="Copy to clipboard"

          @click="copy(value)"

        />

      </UTooltip>

    </template>

  </UInput>

</template>
```

### With password toggle

You can put a [Button](https://ui.nuxt.com/docs/components/button) inside the `#trailing` slot to toggle the password visibility.

```
<script setup lang="ts">

const show = ref(false)

const password = ref('')

</script>

<template>

  <UInput

    v-model="password"

    placeholder="Password"

    :type="show ? 'text' : 'password'"

    :ui="{ trailing: 'pe-1' }"

  >

    <template #trailing>

      <UButton

        color="neutral"

        variant="link"

        size="sm"

        :icon="show ? 'i-lucide-eye-off' : 'i-lucide-eye'"

        :aria-label="show ? 'Hide password' : 'Show password'"

        :aria-pressed="show"

        aria-controls="password"

        @click="show = !show"

      />

    </template>

  </UInput>

</template>

<style>

/* Hide the password reveal button in Edge */

::-ms-reveal {

    display: none;

}

</style>
```

### With password strength indicator

You can use the [Progress](https://ui.nuxt.com/docs/components/progress) component to display the password strength indicator.

Enter a password. Must contain:

- At least 8 characters
- At least 1 number
- At least 1 lowercase letter
- At least 1 uppercase letter

```
<script setup lang="ts">

const show = ref(false)

const password = ref('')

function checkStrength(str: string) {

  const requirements = [

    { regex: /.{8,}/, text: 'At least 8 characters' },

    { regex: /\d/, text: 'At least 1 number' },

    { regex: /[a-z]/, text: 'At least 1 lowercase letter' },

    { regex: /[A-Z]/, text: 'At least 1 uppercase letter' }

  ]

  return requirements.map(req => ({ met: req.regex.test(str), text: req.text }))

}

const strength = computed(() => checkStrength(password.value))

const score = computed(() => strength.value.filter(req => req.met).length)

const color = computed(() => {

  if (score.value === 0) return 'neutral'

  if (score.value <= 1) return 'error'

  if (score.value <= 2) return 'warning'

  if (score.value === 3) return 'warning'

  return 'success'

})

const text = computed(() => {

  if (score.value === 0) return 'Enter a password'

  if (score.value <= 2) return 'Weak password'

  if (score.value === 3) return 'Medium password'

  return 'Strong password'

})

</script>

<template>

  <div class="space-y-2">

    <UFormField label="Password">

      <UInput

        v-model="password"

        placeholder="Password"

        :color="color"

        :type="show ? 'text' : 'password'"

        :aria-invalid="score < 4"

        aria-describedby="password-strength"

        :ui="{ trailing: 'pe-1' }"

        class="w-full"

      >

        <template #trailing>

          <UButton

            color="neutral"

            variant="link"

            size="sm"

            :icon="show ? 'i-lucide-eye-off' : 'i-lucide-eye'"

            :aria-label="show ? 'Hide password' : 'Show password'"

            :aria-pressed="show"

            aria-controls="password"

            @click="show = !show"

          />

        </template>

      </UInput>

    </UFormField>

    <UProgress

      :color="color"

      :indicator="text"

      :model-value="score"

      :max="4"

      size="sm"

    />

    <p id="password-strength" class="text-sm font-medium">

      {{ text }}. Must contain:

    </p>

    <ul class="space-y-1" aria-label="Password requirements">

      <li

        v-for="(req, index) in strength"

        :key="index"

        class="flex items-center gap-0.5"

        :class="req.met ? 'text-success' : 'text-muted'"

      >

        <UIcon :name="req.met ? 'i-lucide-circle-check' : 'i-lucide-circle-x'" class="size-4 shrink-0" />

        <span class="text-xs font-light">

          {{ req.text }}

          <span class="sr-only">

            {{ req.met ? ' - Requirement met' : ' - Requirement not met' }}

          </span>

        </span>

      </li>

    </ul>

  </div>

</template>
```

### With character limit

You can use the `#trailing` slot to add a character limit to the Input.

0/15

```
<script setup lang="ts">

const value = ref('')

const maxLength = 15

</script>

<template>

  <UInput

    v-model="value"

    :maxlength="maxLength"

    aria-describedby="character-count"

    :ui="{ trailing: 'pointer-events-none' }"

  >

    <template #trailing>

      <div

        id="character-count"

        class="text-xs text-muted tabular-nums"

        aria-live="polite"

        role="status"

      >

        {{ value?.length }}/{{ maxLength }}

      </div>

    </template>

  </UInput>

</template>
```

### With keyboard shortcut

You can use the [Kbd](https://ui.nuxt.com/docs/components/kbd) component inside the `#trailing` slot to add a keyboard shortcut to the Input.

/

```
<script setup lang="ts">

const input = useTemplateRef('input')

defineShortcuts({

  '/': () => {

    input.value?.inputRef?.focus()

  }

})

</script>

<template>

  <UInput

    ref="input"

    icon="i-lucide-search"

    placeholder="Search..."

  >

    <template #trailing>

      <UKbd value="/" />

    </template>

  </UInput>

</template>
```

This example uses the `defineShortcuts` composable to focus the Input when the / key is pressed.

### With mask

There's no built-in support for masks, but you can use libraries like [maska](https://github.com/beholdr/maska) to mask the Input.

```
<script setup lang="ts">

import { vMaska } from 'maska/vue'

</script>

<template>

  <div class="flex flex-col gap-2">

    <UInput v-maska="'#### #### #### ####'" placeholder="4242 4242 4242 4242" icon="i-lucide-credit-card" />

    <div class="flex items-center gap-2">

      <UInput v-maska="'##/##'" placeholder="MM/YY" icon="i-lucide-calendar" />

      <UInput v-maska="'###'" placeholder="CVC" />

    </div>

  </div>

</template>
```

### With floating label

You can use the `#default` slot to add a floating label to the Input.

```
<script setup lang="ts">

const value = ref('')

</script>

<template>

  <UInput v-model="value" placeholder="" :ui="{ base: 'peer' }">

    <label class="pointer-events-none absolute left-0 -top-2.5 text-highlighted text-xs font-medium px-1.5 transition-all peer-focus:-top-2.5 peer-focus:text-highlighted peer-focus:text-xs peer-focus:font-medium peer-placeholder-shown:text-sm peer-placeholder-shown:text-dimmed peer-placeholder-shown:top-1.5 peer-placeholder-shown:font-normal">

      <span class="inline-flex bg-default px-1">Email address</span>

    </label>

  </UInput>

</template>
```

### Within a FormField

You can use the Input within a [FormField](https://ui.nuxt.com/docs/components/form-field) component to display a label, help text, required indicator, etc.

It also provides validation and error handling when used within a **Form** component.

### Within a FieldGroup

You can use the Input within a [FieldGroup](https://ui.nuxt.com/components/field-group) component to group multiple elements together.

https://

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `id` |  | ` string` |
| `name` |  | ` string` |
| `type` | `'text'` | ` "number" \| "image" \| "text" \| "button" \| "search" \| "time" \| "color" \| "checkbox" \| "date" \| "datetime-local" \| "email" \| "file" \| "hidden" \| "month" \| "password" \| "radio" \| "range" \| "reset" \| "submit" \| "tel" \| "url" \| "week" \| string & {}` |
| `placeholder` |  | ` string`  The placeholder text when the input is empty. |
| `color` | `'primary'` | ` "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "error" \| "neutral"` |
| `variant` | `'outline'` | ` "outline" \| "soft" \| "subtle" \| "ghost" \| "none"` |
| `size` | `'md'` | ` "xs" \| "sm" \| "md" \| "lg" \| "xl"` |
| `required` |  | `boolean` |
| `autocomplete` | `'off'` | ` string & {} \| "on" \| "off"` |
| `autofocus` |  | `boolean` |
| `autofocusDelay` | `0` | ` number` |
| `disabled` |  | `boolean` |
| `highlight` |  | `boolean`  Highlight the ring color like a focus state. |
| `modelValue` |  | ` T` |
| `defaultValue` |  | ` T` |
| `modelModifiers` |  | ` ModelModifiers<T>` |
| `icon` |  | `any`  Display an icon based on the `leading` and `trailing` props. |
| `avatar` |  | ` AvatarProps`  Display an avatar on the left side. |
| `leading` |  | `boolean`  When `true`, the icon will be displayed on the left side. |
| `leadingIcon` |  | `any`  Display an icon on the left side. |
| `trailing` |  | `boolean`  When `true`, the icon will be displayed on the right side. |
| `trailingIcon` |  | `any`  Display an icon on the right side. |
| `loading` |  | `boolean`  When `true`, the loading icon will be displayed. |
| `loadingIcon` | `appConfig.ui.icons.loading` | `any`  The icon when the `loading` prop is `true`. |
| `list` |  | ` string` |
| `max` |  | ` string \| number` |
| `maxlength` |  | ` string \| number` |
| `min` |  | ` string \| number` |
| `minlength` |  | ` string \| number` |
| `pattern` |  | ` string` |
| `readonly` |  | ` false \| true \| "true" \| "false"` |
| `step` |  | ` string \| number` |
| `ui` |  | ` { root?: ClassNameValue; base?: ClassNameValue; leading?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; trailing?: ClassNameValue; trailingIcon?: ClassNameValue; }` |

This component also supports all native `<input>` HTML attributes.

### Slots

| Slot | Type |
| --- | --- |
| `leading` | `{ ui: object; }` |
| `default` | `{ ui: object; }` |
| `trailing` | `{ ui: object; }` |

### Emits

| Event | Type |
| --- | --- |
| `update:modelValue` | `[value: T]` |
| `blur` | `[event: FocusEvent]` |
| `change` | `[event: Event]` |

### Expose

When accessing the component via a template ref, you can use the following:

| Name | Type |
| --- | --- |
| `inputRef` | `Ref<HTMLInputElement \| null>` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    input: {

      slots: {

        root: 'relative inline-flex items-center',

        base: [

          'w-full rounded-md border-0 appearance-none placeholder:text-dimmed focus:outline-none disabled:cursor-not-allowed disabled:opacity-75',

          'transition-colors'

        ],

        leading: 'absolute inset-y-0 start-0 flex items-center',

        leadingIcon: 'shrink-0 text-dimmed',

        leadingAvatar: 'shrink-0',

        leadingAvatarSize: '',

        trailing: 'absolute inset-y-0 end-0 flex items-center',

        trailingIcon: 'shrink-0 text-dimmed'

      },

      variants: {

        fieldGroup: {

          horizontal: {

            root: 'group has-focus-visible:z-[1]',

            base: 'group-not-only:group-first:rounded-e-none group-not-only:group-last:rounded-s-none group-not-last:group-not-first:rounded-none'

          },

          vertical: {

            root: 'group has-focus-visible:z-[1]',

            base: 'group-not-only:group-first:rounded-b-none group-not-only:group-last:rounded-t-none group-not-last:group-not-first:rounded-none'

          }

        },

        size: {

          xs: {

            base: 'px-2 py-1 text-xs gap-1',

            leading: 'ps-2',

            trailing: 'pe-2',

            leadingIcon: 'size-4',

            leadingAvatarSize: '3xs',

            trailingIcon: 'size-4'

          },

          sm: {

            base: 'px-2.5 py-1.5 text-xs gap-1.5',

            leading: 'ps-2.5',

            trailing: 'pe-2.5',

            leadingIcon: 'size-4',

            leadingAvatarSize: '3xs',

            trailingIcon: 'size-4'

          },

          md: {

            base: 'px-2.5 py-1.5 text-sm gap-1.5',

            leading: 'ps-2.5',

            trailing: 'pe-2.5',

            leadingIcon: 'size-5',

            leadingAvatarSize: '2xs',

            trailingIcon: 'size-5'

          },

          lg: {

            base: 'px-3 py-2 text-sm gap-2',

            leading: 'ps-3',

            trailing: 'pe-3',

            leadingIcon: 'size-5',

            leadingAvatarSize: '2xs',

            trailingIcon: 'size-5'

          },

          xl: {

            base: 'px-3 py-2 text-base gap-2',

            leading: 'ps-3',

            trailing: 'pe-3',

            leadingIcon: 'size-6',

            leadingAvatarSize: 'xs',

            trailingIcon: 'size-6'

          }

        },

        variant: {

          outline: 'text-highlighted bg-default ring ring-inset ring-accented',

          soft: 'text-highlighted bg-elevated/50 hover:bg-elevated focus:bg-elevated disabled:bg-elevated/50',

          subtle: 'text-highlighted bg-elevated ring ring-inset ring-accented',

          ghost: 'text-highlighted bg-transparent hover:bg-elevated focus:bg-elevated disabled:bg-transparent dark:disabled:bg-transparent',

          none: 'text-highlighted bg-transparent'

        },

        color: {

          primary: '',

          secondary: '',

          success: '',

          info: '',

          warning: '',

          error: '',

          neutral: ''

        },

        leading: {

          true: ''

        },

        trailing: {

          true: ''

        },

        loading: {

          true: ''

        },

        highlight: {

          true: ''

        },

        type: {

          file: 'file:me-1.5 file:font-medium file:text-muted file:outline-none'

        }

      },

      compoundVariants: [

        {

          color: 'primary',

          variant: [

            'outline',

            'subtle'

          ],

          class: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-primary'

        },

        {

          color: 'primary',

          highlight: true,

          class: 'ring ring-inset ring-primary'

        },

        {

          color: 'neutral',

          variant: [

            'outline',

            'subtle'

          ],

          class: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-inverted'

        },

        {

          color: 'neutral',

          highlight: true,

          class: 'ring ring-inset ring-inverted'

        },

        {

          leading: true,

          size: 'xs',

          class: 'ps-7'

        },

        {

          leading: true,

          size: 'sm',

          class: 'ps-8'

        },

        {

          leading: true,

          size: 'md',

          class: 'ps-9'

        },

        {

          leading: true,

          size: 'lg',

          class: 'ps-10'

        },

        {

          leading: true,

          size: 'xl',

          class: 'ps-11'

        },

        {

          trailing: true,

          size: 'xs',

          class: 'pe-7'

        },

        {

          trailing: true,

          size: 'sm',

          class: 'pe-8'

        },

        {

          trailing: true,

          size: 'md',

          class: 'pe-9'

        },

        {

          trailing: true,

          size: 'lg',

          class: 'pe-10'

        },

        {

          trailing: true,

          size: 'xl',

          class: 'pe-11'

        },

        {

          loading: true,

          leading: true,

          class: {

            leadingIcon: 'animate-spin'

          }

        },

        {

          loading: true,

          leading: false,

          trailing: true,

          class: {

            trailingIcon: 'animate-spin'

          }

        }

      ],

      defaultVariants: {

        size: 'md',

        color: 'primary',

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

        input: {

          slots: {

            root: 'relative inline-flex items-center',

            base: [

              'w-full rounded-md border-0 appearance-none placeholder:text-dimmed focus:outline-none disabled:cursor-not-allowed disabled:opacity-75',

              'transition-colors'

            ],

            leading: 'absolute inset-y-0 start-0 flex items-center',

            leadingIcon: 'shrink-0 text-dimmed',

            leadingAvatar: 'shrink-0',

            leadingAvatarSize: '',

            trailing: 'absolute inset-y-0 end-0 flex items-center',

            trailingIcon: 'shrink-0 text-dimmed'

          },

          variants: {

            fieldGroup: {

              horizontal: {

                root: 'group has-focus-visible:z-[1]',

                base: 'group-not-only:group-first:rounded-e-none group-not-only:group-last:rounded-s-none group-not-last:group-not-first:rounded-none'

              },

              vertical: {

                root: 'group has-focus-visible:z-[1]',

                base: 'group-not-only:group-first:rounded-b-none group-not-only:group-last:rounded-t-none group-not-last:group-not-first:rounded-none'

              }

            },

            size: {

              xs: {

                base: 'px-2 py-1 text-xs gap-1',

                leading: 'ps-2',

                trailing: 'pe-2',

                leadingIcon: 'size-4',

                leadingAvatarSize: '3xs',

                trailingIcon: 'size-4'

              },

              sm: {

                base: 'px-2.5 py-1.5 text-xs gap-1.5',

                leading: 'ps-2.5',

                trailing: 'pe-2.5',

                leadingIcon: 'size-4',

                leadingAvatarSize: '3xs',

                trailingIcon: 'size-4'

              },

              md: {

                base: 'px-2.5 py-1.5 text-sm gap-1.5',

                leading: 'ps-2.5',

                trailing: 'pe-2.5',

                leadingIcon: 'size-5',

                leadingAvatarSize: '2xs',

                trailingIcon: 'size-5'

              },

              lg: {

                base: 'px-3 py-2 text-sm gap-2',

                leading: 'ps-3',

                trailing: 'pe-3',

                leadingIcon: 'size-5',

                leadingAvatarSize: '2xs',

                trailingIcon: 'size-5'

              },

              xl: {

                base: 'px-3 py-2 text-base gap-2',

                leading: 'ps-3',

                trailing: 'pe-3',

                leadingIcon: 'size-6',

                leadingAvatarSize: 'xs',

                trailingIcon: 'size-6'

              }

            },

            variant: {

              outline: 'text-highlighted bg-default ring ring-inset ring-accented',

              soft: 'text-highlighted bg-elevated/50 hover:bg-elevated focus:bg-elevated disabled:bg-elevated/50',

              subtle: 'text-highlighted bg-elevated ring ring-inset ring-accented',

              ghost: 'text-highlighted bg-transparent hover:bg-elevated focus:bg-elevated disabled:bg-transparent dark:disabled:bg-transparent',

              none: 'text-highlighted bg-transparent'

            },

            color: {

              primary: '',

              secondary: '',

              success: '',

              info: '',

              warning: '',

              error: '',

              neutral: ''

            },

            leading: {

              true: ''

            },

            trailing: {

              true: ''

            },

            loading: {

              true: ''

            },

            highlight: {

              true: ''

            },

            type: {

              file: 'file:me-1.5 file:font-medium file:text-muted file:outline-none'

            }

          },

          compoundVariants: [

            {

              color: 'primary',

              variant: [

                'outline',

                'subtle'

              ],

              class: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-primary'

            },

            {

              color: 'primary',

              highlight: true,

              class: 'ring ring-inset ring-primary'

            },

            {

              color: 'neutral',

              variant: [

                'outline',

                'subtle'

              ],

              class: 'focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-inverted'

            },

            {

              color: 'neutral',

              highlight: true,

              class: 'ring ring-inset ring-inverted'

            },

            {

              leading: true,

              size: 'xs',

              class: 'ps-7'

            },

            {

              leading: true,

              size: 'sm',

              class: 'ps-8'

            },

            {

              leading: true,

              size: 'md',

              class: 'ps-9'

            },

            {

              leading: true,

              size: 'lg',

              class: 'ps-10'

            },

            {

              leading: true,

              size: 'xl',

              class: 'ps-11'

            },

            {

              trailing: true,

              size: 'xs',

              class: 'pe-7'

            },

            {

              trailing: true,

              size: 'sm',

              class: 'pe-8'

            },

            {

              trailing: true,

              size: 'md',

              class: 'pe-9'

            },

            {

              trailing: true,

              size: 'lg',

              class: 'pe-10'

            },

            {

              trailing: true,

              size: 'xl',

              class: 'pe-11'

            },

            {

              loading: true,

              leading: true,

              class: {

                leadingIcon: 'animate-spin'

              }

            },

            {

              loading: true,

              leading: false,

              trailing: true,

              class: {

                trailingIcon: 'animate-spin'

              }

            }

          ],

          defaultVariants: {

            size: 'md',

            color: 'primary',

            variant: 'outline'

          }

        }

      }

    })

  ]

})
```

Some colors in `compoundVariants` are omitted for readability. Check out the source code on GitHub.

## Changelog

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`fce2d`](https://github.com/nuxt/ui/commit/fce2df4e0660d0bdb3cdd4fb3041416824cbe893) — fix!: consistent exposed refs ([#5385](https://github.com/nuxt/ui/issues/5385))

[`5c347`](https://github.com/nuxt/ui/commit/5c347af8a3fee7b079171f3e69b68d87adb9a83a) — fix: make `modelModifiers` generic ([#5361](https://github.com/nuxt/ui/issues/5361))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`788d2`](https://github.com/nuxt/ui/commit/788d2deb53b2a96c8d87828629b3d5d5ec5187d6) — fix: standardize naming for type interfaces ([#4990](https://github.com/nuxt/ui/issues/4990))

[`83b03`](https://github.com/nuxt/ui/commit/83b0306a30835a385049200c5de804c51577c64c) — feat!: rename `nullify` modifier to `nullable` and add `optional` ([#4838](https://github.com/nuxt/ui/issues/4838))

[`7133f`](https://github.com/nuxt/ui/commit/7133f501e4346ba6990c437cfa16af05b886c884) — fix: broken types for `update:model-value` event ([#4853](https://github.com/nuxt/ui/issues/4853))

[`93cc8`](https://github.com/nuxt/ui/commit/93cc83cbc74644b9a5a337e1cb8aa963baa5a172) — fix: incorrect rendering of type `date` / `time` on iOS ([#4715](https://github.com/nuxt/ui/issues/4715))

[`a0963`](https://github.com/nuxt/ui/commit/a0963eba8254d2ecf02cd1ee87cee7f73c4b2bc4) — feat!: rename from `ButtonGroup` ([#4596](https://github.com/nuxt/ui/issues/4596))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`6f2ce`](https://github.com/nuxt/ui/commit/6f2ce5c610e1247e70b6e2072059cf6ecbe82711) — refactor: unite syntax for emits declaration ([#4512](https://github.com/nuxt/ui/issues/4512))

[`fb9e7`](https://github.com/nuxt/ui/commit/fb9e7bb85602ecec1f83cd148dffbfb5e99d5714) — feat: add `default-value` prop ([#4404](https://github.com/nuxt/ui/issues/4404))

[`3243f`](https://github.com/nuxt/ui/commit/3243fb88f71c5475824bfdc4d7c4f303b2d6790b) — fix: define model modifiers types ([#4195](https://github.com/nuxt/ui/issues/4195))

[`2e4c3`](https://github.com/nuxt/ui/commit/2e4c3082a1e66fa597086dc3431fec37fa29ef62) — fix: handle inside button group

[`3c8d6`](https://github.com/nuxt/ui/commit/3c8d6cd01dfafed5844c376f52adbdda0c814420) — fix: handle generic types

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`4d817`](https://github.com/nuxt/ui/commit/4d8179ba08bc69f28a541fa6d6cf3519db322662) — chore: clean functions order[FormField](https://ui.nuxt.com/docs/components/form-field)

[

A wrapper for form elements that provides validation and error handling.

](https://ui.nuxt.com/docs/components/form-field)[

InputDate

An input component for date selection.

](https://ui.nuxt.com/docs/components/input-date)