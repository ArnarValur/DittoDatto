---
title: "Vue Button Component"
source: "https://ui.nuxt.com/docs/components/button"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A button element that can act as a link or trigger an action."
tags:
---
## Button

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Button.vue)

A button element that can act as a link or trigger an action.

## Usage

Use the default slot to set the label of the Button.

```
<template>

  <UButton>Button</UButton>

</template>
```

### Label

Use the `label` prop to set the label of the Button.

```
<template>

  <UButton label="Button" />

</template>
```

### Color

Use the `color` prop to change the color of the Button.

```
<template>

  <UButton color="neutral">Button</UButton>

</template>
```

### Variant

Use the `variant` prop to change the variant of the Button.

```
<template>

  <UButton color="neutral" variant="outline">Button</UButton>

</template>
```

### Size

Use the `size` prop to change the size of the Button.

```
<template>

  <UButton size="xl">Button</UButton>

</template>
```

### Icon

Use the `icon` prop to show an [Icon](https://ui.nuxt.com/docs/components/icon) inside the Button.

```
<template>

  <UButton icon="i-lucide-rocket" size="md" color="primary" variant="solid">Button</UButton>

</template>
```

Use the `leading` and `trailing` props to set the icon position or the `leading-icon` and `trailing-icon` props to set a different icon for each position.

```
<template>

  <UButton trailing-icon="i-lucide-arrow-right" size="md">Button</UButton>

</template>
```

The `label` as prop or slot is optional so you can use the Button as an icon-only button.

```
<template>

  <UButton icon="i-lucide-search" size="md" color="primary" variant="solid" />

</template>
```

Use the `avatar` prop to show an [Avatar](https://ui.nuxt.com/docs/components/avatar) inside the Button.

```
<template>

  <UButton

    :avatar="{

      src: 'https://github.com/nuxt.png'

    }"

    size="md"

    color="neutral"

    variant="outline"

  >

    Button

  </UButton>

</template>
```

The `label` as prop or slot is optional so you can use the Button as an avatar-only button.

```
<template>

  <UButton

    :avatar="{

      src: 'https://github.com/nuxt.png'

    }"

    size="md"

    color="neutral"

    variant="outline"

  />

</template>
```

### Link

You can pass any property from the [Link](https://ui.nuxt.com/docs/components/link#props) component such as `to`, `target`, etc.

[Button](https://github.com/nuxt/ui)

```
<template>

  <UButton to="https://github.com/nuxt/ui" target="_blank">Button</UButton>

</template>
```

When the Button is a link or when using the `active` prop, you can use the `active-color` and `active-variant` props to customize the active state.

```
<template>

  <UButton active color="neutral" variant="outline" active-color="primary" active-variant="solid">

    Button

  </UButton>

</template>
```

You can also use the `active-class` and `inactive-class` props to customize the active state.

```
<template>

  <UButton active active-class="font-bold" inactive-class="font-light">Button</UButton>

</template>
```

You can configure these styles globally in your `app.config.ts` file under the `ui.button.variants.active` key.

```ts
export default defineAppConfig({

  ui: {

    button: {

      variants: {

        active: {

          true: {

            base: 'font-bold'

          }

        }

      }

    }

  }

})
```

Use the `loading` prop to show a loading icon and disable the Button.

```
<template>

  <UButton loading>Button</UButton>

</template>
```

Use the `loading-auto` prop to show the loading icon automatically while the `@click` promise is pending.

```
<script setup lang="ts">

async function onClick() {

  return new Promise<void>(res => setTimeout(res, 1000))

}

</script>

<template>

  <UButton loading-auto @click="onClick">

    Button

  </UButton>

</template>
```

This also works with the [Form](https://ui.nuxt.com/docs/components/form) component.

```
<script setup lang="ts">

const state = reactive({ fullName: '' })

async function onSubmit() {

  return new Promise<void>(res => setTimeout(res, 1000))

}

async function validate(data: Partial<typeof state>) {

  if (!data.fullName?.length) return [{ name: 'fullName', message: 'Required' }]

  return []

}

</script>

<template>

  <UForm :state="state" :validate="validate" @submit="onSubmit">

    <UFormField name="fullName" label="Full name">

      <UInput v-model="state.fullName" />

    </UFormField>

    <UButton type="submit" class="mt-2" loading-auto>

      Submit

    </UButton>

  </UForm>

</template>
```

Use the `loading-icon` prop to customize the loading icon. Defaults to `i-lucide-loader-circle`.

```
<template>

  <UButton loading loading-icon="i-lucide-loader">Button</UButton>

</template>
```

You can customize this icon globally in your `app.config.ts` under `ui.icons.loading` key.

You can customize this icon globally in your `vite.config.ts` under `ui.icons.loading` key.

### Disabled

Use the `disabled` prop to disable the Button.

```
<template>

  <UButton disabled>Button</UButton>

</template>
```

## Examples

### class prop

Use the `class` prop to override the base styles of the Button.

```
<template>

  <UButton class="font-bold rounded-full">Button</UButton>

</template>
```

### ui prop

Use the `ui` prop to override the slots styles of the Button.

```
<template>

  <UButton

    icon="i-lucide-rocket"

    color="neutral"

    variant="outline"

    :ui="{

      leadingIcon: 'text-primary'

    }"

  >

    Button

  </UButton>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'button'` | `any`  The element or component this component should render as when not a link. |
| `label` |  | ` string` |
| `color` | `'primary'` | ` "error" \| "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "neutral"` |
| `activeColor` |  | ` "error" \| "primary" \| "secondary" \| "success" \| "info" \| "warning" \| "neutral"` |
| `variant` | `'solid'` | ` "solid" \| "outline" \| "soft" \| "subtle" \| "ghost" \| "link"` |
| `activeVariant` |  | ` "solid" \| "outline" \| "soft" \| "subtle" \| "ghost" \| "link"` |
| `size` | `'md'` | ` "xs" \| "sm" \| "md" \| "lg" \| "xl"` |
| `square` |  | `boolean`  Render the button with equal padding on all sides. |
| `block` |  | `boolean`  Render the button full width. |
| `loadingAuto` |  | `boolean`  Set loading state automatically based on the `@click` promise state |
| `icon` |  | `any`  Display an icon based on the `leading` and `trailing` props. |
| `avatar` |  | ` AvatarProps`  Display an avatar on the left side. |
| `leading` |  | `boolean`  When `true`, the icon will be displayed on the left side. |
| `leadingIcon` |  | `any`  Display an icon on the left side. |
| `trailing` |  | `boolean`  When `true`, the icon will be displayed on the right side. |
| `trailingIcon` |  | `any`  Display an icon on the right side. |
| `loading` |  | `boolean`  When `true`, the loading icon will be displayed. |
| `loadingIcon` | `appConfig.ui.icons.loading` | `any`  The icon when the `loading` prop is `true`. |
| `to` |  | ` string \| kt \| Tt` |
| `autofocus` |  | ` false \| true \| "true" \| "false"` |
| `disabled` |  | `boolean` |
| `name` |  | ` string` |
| `type` | `'button'` | ` "reset" \| "submit" \| "button"`  The type of the button when not a link. |
| `download` |  | `any` |
| `hreflang` |  | ` string` |
| `media` |  | ` string` |
| `ping` |  | ` string` |
| `target` |  | ` null \| string & {} \| "_blank" \| "_parent" \| "_self" \| "_top"`  Where to display the linked URL, as the name for a browsing context. |
| `referrerpolicy` |  | ` "" \| "no-referrer" \| "no-referrer-when-downgrade" \| "origin" \| "origin-when-cross-origin" \| "same-origin" \| "strict-origin" \| "strict-origin-when-cross-origin" \| "unsafe-url"` |
| `active` |  | `boolean`  Force the link to be active independent of the current route. |
| `trailingSlash` |  | ` "remove" \| "append"`  An option to either add or remove trailing slashes in the `href` for this specific link. Overrides the global `trailingSlash` option if provided. |
| `ui` |  | ` { base?: ClassNameValue; label?: ClassNameValue; leadingIcon?: ClassNameValue; leadingAvatar?: ClassNameValue; leadingAvatarSize?: ClassNameValue; trailingIcon?: ClassNameValue; }` |

This component also supports all native `<button>` HTML attributes.

The `Button` component extends the `Link` component. Check out the source code on GitHub.

### Slots

| Slot | Type |
| --- | --- |
| `leading` | `{ ui: object; }` |
| `default` | `{ ui: object; }` |
| `trailing` | `{ ui: object; }` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    button: {

      slots: {

        base: [

          'rounded-md font-medium inline-flex items-center disabled:cursor-not-allowed aria-disabled:cursor-not-allowed disabled:opacity-75 aria-disabled:opacity-75',

          'transition-colors'

        ],

        label: 'truncate',

        leadingIcon: 'shrink-0',

        leadingAvatar: 'shrink-0',

        leadingAvatarSize: '',

        trailingIcon: 'shrink-0'

      },

      variants: {

        fieldGroup: {

          horizontal: 'not-only:first:rounded-e-none not-only:last:rounded-s-none not-last:not-first:rounded-none focus-visible:z-[1]',

          vertical: 'not-only:first:rounded-b-none not-only:last:rounded-t-none not-last:not-first:rounded-none focus-visible:z-[1]'

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

        variant: {

          solid: '',

          outline: '',

          soft: '',

          subtle: '',

          ghost: '',

          link: ''

        },

        size: {

          xs: {

            base: 'px-2 py-1 text-xs gap-1',

            leadingIcon: 'size-4',

            leadingAvatarSize: '3xs',

            trailingIcon: 'size-4'

          },

          sm: {

            base: 'px-2.5 py-1.5 text-xs gap-1.5',

            leadingIcon: 'size-4',

            leadingAvatarSize: '3xs',

            trailingIcon: 'size-4'

          },

          md: {

            base: 'px-2.5 py-1.5 text-sm gap-1.5',

            leadingIcon: 'size-5',

            leadingAvatarSize: '2xs',

            trailingIcon: 'size-5'

          },

          lg: {

            base: 'px-3 py-2 text-sm gap-2',

            leadingIcon: 'size-5',

            leadingAvatarSize: '2xs',

            trailingIcon: 'size-5'

          },

          xl: {

            base: 'px-3 py-2 text-base gap-2',

            leadingIcon: 'size-6',

            leadingAvatarSize: 'xs',

            trailingIcon: 'size-6'

          }

        },

        block: {

          true: {

            base: 'w-full justify-center',

            trailingIcon: 'ms-auto'

          }

        },

        square: {

          true: ''

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

        active: {

          true: {

            base: ''

          },

          false: {

            base: ''

          }

        }

      },

      compoundVariants: [

        {

          color: 'primary',

          variant: 'solid',

          class: 'text-inverted bg-primary hover:bg-primary/75 active:bg-primary/75 disabled:bg-primary aria-disabled:bg-primary focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary'

        },

        {

          color: 'primary',

          variant: 'outline',

          class: 'ring ring-inset ring-primary/50 text-primary hover:bg-primary/10 active:bg-primary/10 disabled:bg-transparent aria-disabled:bg-transparent dark:disabled:bg-transparent dark:aria-disabled:bg-transparent focus:outline-none focus-visible:ring-2 focus-visible:ring-primary'

        },

        {

          color: 'primary',

          variant: 'soft',

          class: 'text-primary bg-primary/10 hover:bg-primary/15 active:bg-primary/15 focus:outline-none focus-visible:bg-primary/15 disabled:bg-primary/10 aria-disabled:bg-primary/10'

        },

        {

          color: 'primary',

          variant: 'subtle',

          class: 'text-primary ring ring-inset ring-primary/25 bg-primary/10 hover:bg-primary/15 active:bg-primary/15 disabled:bg-primary/10 aria-disabled:bg-primary/10 focus:outline-none focus-visible:ring-2 focus-visible:ring-primary'

        },

        {

          color: 'primary',

          variant: 'ghost',

          class: 'text-primary hover:bg-primary/10 active:bg-primary/10 focus:outline-none focus-visible:bg-primary/10 disabled:bg-transparent aria-disabled:bg-transparent dark:disabled:bg-transparent dark:aria-disabled:bg-transparent'

        },

        {

          color: 'primary',

          variant: 'link',

          class: 'text-primary hover:text-primary/75 active:text-primary/75 disabled:text-primary aria-disabled:text-primary focus:outline-none focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-primary'

        },

        {

          color: 'neutral',

          variant: 'solid',

          class: 'text-inverted bg-inverted hover:bg-inverted/90 active:bg-inverted/90 disabled:bg-inverted aria-disabled:bg-inverted focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-inverted'

        },

        {

          color: 'neutral',

          variant: 'outline',

          class: 'ring ring-inset ring-accented text-default bg-default hover:bg-elevated active:bg-elevated disabled:bg-default aria-disabled:bg-default focus:outline-none focus-visible:ring-2 focus-visible:ring-inverted'

        },

        {

          color: 'neutral',

          variant: 'soft',

          class: 'text-default bg-elevated hover:bg-accented/75 active:bg-accented/75 focus:outline-none focus-visible:bg-accented/75 disabled:bg-elevated aria-disabled:bg-elevated'

        },

        {

          color: 'neutral',

          variant: 'subtle',

          class: 'ring ring-inset ring-accented text-default bg-elevated hover:bg-accented/75 active:bg-accented/75 disabled:bg-elevated aria-disabled:bg-elevated focus:outline-none focus-visible:ring-2 focus-visible:ring-inverted'

        },

        {

          color: 'neutral',

          variant: 'ghost',

          class: 'text-default hover:bg-elevated active:bg-elevated focus:outline-none focus-visible:bg-elevated hover:disabled:bg-transparent dark:hover:disabled:bg-transparent hover:aria-disabled:bg-transparent dark:hover:aria-disabled:bg-transparent'

        },

        {

          color: 'neutral',

          variant: 'link',

          class: 'text-muted hover:text-default active:text-default disabled:text-muted aria-disabled:text-muted focus:outline-none focus-visible:ring-inset focus-visible:ring-2 focus-visible:ring-inverted'

        },

        {

          size: 'xs',

          square: true,

          class: 'p-1'

        },

        {

          size: 'sm',

          square: true,

          class: 'p-1.5'

        },

        {

          size: 'md',

          square: true,

          class: 'p-1.5'

        },

        {

          size: 'lg',

          square: true,

          class: 'p-2'

        },

        {

          size: 'xl',

          square: true,

          class: 'p-2'

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

        color: 'primary',

        variant: 'solid',

        size: 'md'

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

        button: {

          slots: {

            base: [

              'rounded-md font-medium inline-flex items-center disabled:cursor-not-allowed aria-disabled:cursor-not-allowed disabled:opacity-75 aria-disabled:opacity-75',

              'transition-colors'

            ],

            label: 'truncate',

            leadingIcon: 'shrink-0',

            leadingAvatar: 'shrink-0',

            leadingAvatarSize: '',

            trailingIcon: 'shrink-0'

          },

          variants: {

            fieldGroup: {

              horizontal: 'not-only:first:rounded-e-none not-only:last:rounded-s-none not-last:not-first:rounded-none focus-visible:z-[1]',

              vertical: 'not-only:first:rounded-b-none not-only:last:rounded-t-none not-last:not-first:rounded-none focus-visible:z-[1]'

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

            variant: {

              solid: '',

              outline: '',

              soft: '',

              subtle: '',

              ghost: '',

              link: ''

            },

            size: {

              xs: {

                base: 'px-2 py-1 text-xs gap-1',

                leadingIcon: 'size-4',

                leadingAvatarSize: '3xs',

                trailingIcon: 'size-4'

              },

              sm: {

                base: 'px-2.5 py-1.5 text-xs gap-1.5',

                leadingIcon: 'size-4',

                leadingAvatarSize: '3xs',

                trailingIcon: 'size-4'

              },

              md: {

                base: 'px-2.5 py-1.5 text-sm gap-1.5',

                leadingIcon: 'size-5',

                leadingAvatarSize: '2xs',

                trailingIcon: 'size-5'

              },

              lg: {

                base: 'px-3 py-2 text-sm gap-2',

                leadingIcon: 'size-5',

                leadingAvatarSize: '2xs',

                trailingIcon: 'size-5'

              },

              xl: {

                base: 'px-3 py-2 text-base gap-2',

                leadingIcon: 'size-6',

                leadingAvatarSize: 'xs',

                trailingIcon: 'size-6'

              }

            },

            block: {

              true: {

                base: 'w-full justify-center',

                trailingIcon: 'ms-auto'

              }

            },

            square: {

              true: ''

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

            active: {

              true: {

                base: ''

              },

              false: {

                base: ''

              }

            }

          },

          compoundVariants: [

            {

              color: 'primary',

              variant: 'solid',

              class: 'text-inverted bg-primary hover:bg-primary/75 active:bg-primary/75 disabled:bg-primary aria-disabled:bg-primary focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-primary'

            },

            {

              color: 'primary',

              variant: 'outline',

              class: 'ring ring-inset ring-primary/50 text-primary hover:bg-primary/10 active:bg-primary/10 disabled:bg-transparent aria-disabled:bg-transparent dark:disabled:bg-transparent dark:aria-disabled:bg-transparent focus:outline-none focus-visible:ring-2 focus-visible:ring-primary'

            },

            {

              color: 'primary',

              variant: 'soft',

              class: 'text-primary bg-primary/10 hover:bg-primary/15 active:bg-primary/15 focus:outline-none focus-visible:bg-primary/15 disabled:bg-primary/10 aria-disabled:bg-primary/10'

            },

            {

              color: 'primary',

              variant: 'subtle',

              class: 'text-primary ring ring-inset ring-primary/25 bg-primary/10 hover:bg-primary/15 active:bg-primary/15 disabled:bg-primary/10 aria-disabled:bg-primary/10 focus:outline-none focus-visible:ring-2 focus-visible:ring-primary'

            },

            {

              color: 'primary',

              variant: 'ghost',

              class: 'text-primary hover:bg-primary/10 active:bg-primary/10 focus:outline-none focus-visible:bg-primary/10 disabled:bg-transparent aria-disabled:bg-transparent dark:disabled:bg-transparent dark:aria-disabled:bg-transparent'

            },

            {

              color: 'primary',

              variant: 'link',

              class: 'text-primary hover:text-primary/75 active:text-primary/75 disabled:text-primary aria-disabled:text-primary focus:outline-none focus-visible:ring-2 focus-visible:ring-inset focus-visible:ring-primary'

            },

            {

              color: 'neutral',

              variant: 'solid',

              class: 'text-inverted bg-inverted hover:bg-inverted/90 active:bg-inverted/90 disabled:bg-inverted aria-disabled:bg-inverted focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-inverted'

            },

            {

              color: 'neutral',

              variant: 'outline',

              class: 'ring ring-inset ring-accented text-default bg-default hover:bg-elevated active:bg-elevated disabled:bg-default aria-disabled:bg-default focus:outline-none focus-visible:ring-2 focus-visible:ring-inverted'

            },

            {

              color: 'neutral',

              variant: 'soft',

              class: 'text-default bg-elevated hover:bg-accented/75 active:bg-accented/75 focus:outline-none focus-visible:bg-accented/75 disabled:bg-elevated aria-disabled:bg-elevated'

            },

            {

              color: 'neutral',

              variant: 'subtle',

              class: 'ring ring-inset ring-accented text-default bg-elevated hover:bg-accented/75 active:bg-accented/75 disabled:bg-elevated aria-disabled:bg-elevated focus:outline-none focus-visible:ring-2 focus-visible:ring-inverted'

            },

            {

              color: 'neutral',

              variant: 'ghost',

              class: 'text-default hover:bg-elevated active:bg-elevated focus:outline-none focus-visible:bg-elevated hover:disabled:bg-transparent dark:hover:disabled:bg-transparent hover:aria-disabled:bg-transparent dark:hover:aria-disabled:bg-transparent'

            },

            {

              color: 'neutral',

              variant: 'link',

              class: 'text-muted hover:text-default active:text-default disabled:text-muted aria-disabled:text-muted focus:outline-none focus-visible:ring-inset focus-visible:ring-2 focus-visible:ring-inverted'

            },

            {

              size: 'xs',

              square: true,

              class: 'p-1'

            },

            {

              size: 'sm',

              square: true,

              class: 'p-1.5'

            },

            {

              size: 'md',

              square: true,

              class: 'p-1.5'

            },

            {

              size: 'lg',

              square: true,

              class: 'p-2'

            },

            {

              size: 'xl',

              square: true,

              class: 'p-2'

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

            color: 'primary',

            variant: 'solid',

            size: 'md'

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

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`a0963`](https://github.com/nuxt/ui/commit/a0963eba8254d2ecf02cd1ee87cee7f73c4b2bc4) — feat!: rename from `ButtonGroup` ([#4596](https://github.com/nuxt/ui/issues/4596))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`9debc`](https://github.com/nuxt/ui/commit/9debce737cc779229713cd19b03e6167dfd3ea8e) — fix: merge `active-class` / `inactive-class` with app config ([#4446](https://github.com/nuxt/ui/issues/4446))

[`127e0`](https://github.com/nuxt/ui/commit/127e06ae83c1ec145dadffcab357907b7b06bc98) — chore: update all non-major dependencies (v3) ([#4443](https://github.com/nuxt/ui/issues/4443))

[`df8f2`](https://github.com/nuxt/ui/commit/df8f20232fd367469deb1b46a3888811cbf0b5e7) — fix: add `active` styles to behave like `hover` on mobile

[`67da9`](https://github.com/nuxt/ui/commit/67da90a2f638124f640c4271d3376c5ff3fab6a1) — fix: consistent behavior between nuxt, vue and inertia ([#4134](https://github.com/nuxt/ui/issues/4134))

[`f244d`](https://github.com/nuxt/ui/commit/f244d15b96d97cd8ba34ba9c18f23965e17e3cef) — fix: handle zero value in label correctly ([#4108](https://github.com/nuxt/ui/issues/4108))

[`e6e51`](https://github.com/nuxt/ui/commit/e6e510b848d995a286a51d50a120d67483e11232) — fix: `class` should have priority over `ui` prop

[`d49e0`](https://github.com/nuxt/ui/commit/d49e0dadeea2a58e05e60b2c461b29ce1d334d2b) — feat: define neutral utilities ([#3629](https://github.com/nuxt/ui/issues/3629))

[`f9737`](https://github.com/nuxt/ui/commit/f9737c8f401bf8bc5307674fad6defe2aeeeb907) — feat: dynamic `rounded-*` utilities ([#3906](https://github.com/nuxt/ui/issues/3906))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`37005`](https://github.com/nuxt/ui/commit/370054b20c0201c9dba84ddfcd1e916594619b93) — fix: proxy `onClick`

[`c231f`](https://github.com/nuxt/ui/commit/c231fe5f26ca7614df46a7ec8a5ce7f4ec8884e7) — fix: use `focus:outline-none` instead of `focus:outline-hidden`