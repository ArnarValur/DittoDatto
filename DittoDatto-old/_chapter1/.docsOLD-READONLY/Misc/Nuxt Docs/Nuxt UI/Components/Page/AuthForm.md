---
title: "Vue AuthForm Component"
source: "https://ui.nuxt.com/docs/components/auth-form"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A customizable Form to create login, register or password reset forms."
tags:
---
## Usage

Built on top of the [Form](https://ui.nuxt.com/docs/components/form) component, the `AuthForm` component can be used in your pages or wrapped in a [PageCard](https://ui.nuxt.com/docs/components/page-card).

```
<script setup lang="ts">

import * as z from 'zod'

import type { FormSubmitEvent, AuthFormField } from '@nuxt/ui'

const toast = useToast()

const fields: AuthFormField[] = [{

  name: 'email',

  type: 'email',

  label: 'Email',

  placeholder: 'Enter your email',

  required: true

}, {

  name: 'password',

  label: 'Password',

  type: 'password',

  placeholder: 'Enter your password',

  required: true

}, {

  name: 'remember',

  label: 'Remember me',

  type: 'checkbox'

}]

const providers = [{

  label: 'Google',

  icon: 'i-simple-icons-google',

  onClick: () => {

    toast.add({ title: 'Google', description: 'Login with Google' })

  }

}, {

  label: 'GitHub',

  icon: 'i-simple-icons-github',

  onClick: () => {

    toast.add({ title: 'GitHub', description: 'Login with GitHub' })

  }

}]

const schema = z.object({

  email: z.email('Invalid email'),

  password: z.string('Password is required').min(8, 'Must be at least 8 characters')

})

type Schema = z.output<typeof schema>

function onSubmit(payload: FormSubmitEvent<Schema>) {

  console.log('Submitted', payload)

}

</script>

<template>

  <div class="flex flex-col items-center justify-center gap-4 p-4">

    <UPageCard class="w-full max-w-md">

      <UAuthForm

        :schema="schema"

        title="Login"

        description="Enter your credentials to access your account."

        icon="i-lucide-user"

        :fields="fields"

        :providers="providers"

        @submit="onSubmit"

      />

    </UPageCard>

  </div>

</template>
```

### Fields

The Form will construct itself based on the `fields` prop and the state will be handled internally.

Use the `fields` prop as an array of objects with the following properties:

- `name: string`
- `type: 'checkbox' | 'select' | 'otp' | 'InputHTMLAttributes['type']'`

Each field must include a `type` property, which determines the input component and any additional props applied: `checkbox` fields use [Checkbox](https://ui.nuxt.com/docs/components/checkbox#props) props, `select` fields use [SelectMenu](https://ui.nuxt.com/docs/components/select-menu#props) props, `otp` fields use [PinInput](https://ui.nuxt.com/docs/components/pin-input#props) props, and all other types use [Input](https://ui.nuxt.com/docs/components/input#props) props.

You can also pass any property from the [FormField](https://ui.nuxt.com/docs/components/form-field#props) component to each field.

```
<script setup lang="ts">

import type { AuthFormField } from '@nuxt/ui'

const fields = ref<AuthFormField[]>([

  {

    name: 'email',

    type: 'email',

    label: 'Email',

    placeholder: 'Enter your email',

    required: true

  },

  {

    name: 'password',

    type: 'password',

    label: 'Password',

    placeholder: 'Enter your password',

    required: true

  },

  {

    name: 'country',

    type: 'select',

    label: 'Country',

    placeholder: 'Select country',

    items: [

      {

        label: 'United States',

        value: 'us'

      },

      {

        label: 'France',

        value: 'fr'

      },

      {

        label: 'United Kingdom',

        value: 'uk'

      },

      {

        label: 'Australia',

        value: 'au'

      }

    ]

  },

  {

    name: 'otp',

    type: 'otp',

    label: 'OTP',

    length: 6,

    placeholder: '○'

  },

  {

    name: 'remember',

    type: 'checkbox',

    label: 'Remember me',

    description: 'You will be logged in for 30 days.'

  }

])

</script>

<template>

  <UAuthForm :fields="fields" class="max-w-sm" />

</template>
```

Use the `title` prop to set the title of the Form.

### Description

Use the `description` prop to set the description of the Form.

### Icon

Use the `icon` prop to set the icon of the Form.

### Providers

Use the `providers` prop to add providers to the form.

You can pass any property from the [Button](https://ui.nuxt.com/docs/components/button) component such as `variant`, `color`, `to`, etc.

### Separator

Use the `separator` prop to customize the [Separator](https://ui.nuxt.com/docs/components/separator) between the providers and the fields. Defaults to `or`.

You can pass any property from the [Separator](https://ui.nuxt.com/docs/components/separator#props) component to customize it.

### Submit

Use the `submit` prop to change the submit button of the Form.

You can pass any property from the [Button](https://ui.nuxt.com/docs/components/button) component such as `variant`, `color`, `to`, etc.

## Examples

### Within a page

You can wrap the `AuthForm` component with the [PageCard](https://ui.nuxt.com/docs/components/page-card) component to display it within a `login.vue` page for example.

```
<script setup lang="ts">

import * as z from 'zod'

import type { FormSubmitEvent, AuthFormField } from '@nuxt/ui'

const toast = useToast()

const fields: AuthFormField[] = [{

  name: 'email',

  type: 'email',

  label: 'Email',

  placeholder: 'Enter your email',

  required: true

}, {

  name: 'password',

  label: 'Password',

  type: 'password',

  placeholder: 'Enter your password',

  required: true

}, {

  name: 'remember',

  label: 'Remember me',

  type: 'checkbox'

}]

const providers = [{

  label: 'Google',

  icon: 'i-simple-icons-google',

  onClick: () => {

    toast.add({ title: 'Google', description: 'Login with Google' })

  }

}, {

  label: 'GitHub',

  icon: 'i-simple-icons-github',

  onClick: () => {

    toast.add({ title: 'GitHub', description: 'Login with GitHub' })

  }

}]

const schema = z.object({

  email: z.email('Invalid email'),

  password: z.string('Password is required').min(8, 'Must be at least 8 characters')

})

type Schema = z.output<typeof schema>

function onSubmit(payload: FormSubmitEvent<Schema>) {

  console.log('Submitted', payload)

}

</script>

<template>

  <div class="flex flex-col items-center justify-center gap-4 p-4">

    <UPageCard class="w-full max-w-md">

      <UAuthForm

        :schema="schema"

        :fields="fields"

        :providers="providers"

        title="Welcome back!"

        icon="i-lucide-lock"

        @submit="onSubmit"

      >

        <template #description>

          Don't have an account? <ULink to="#" class="text-primary font-medium">Sign up</ULink>.

        </template>

        <template #password-hint>

          <ULink to="#" class="text-primary font-medium" tabindex="-1">Forgot password?</ULink>

        </template>

        <template #validation>

          <UAlert color="error" icon="i-lucide-info" title="Error signing in" />

        </template>

        <template #footer>

          By signing in, you agree to our <ULink to="#" class="text-primary font-medium">Terms of Service</ULink>.

        </template>

      </UAuthForm>

    </UPageCard>

  </div>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `as` | `'div'` | `any`  The element or component this component should render as. |
| `icon` |  | `any`  The icon displayed above the title. |
| `title` |  | ` string` |
| `description` |  | ` string` |
| `fields` |  | ` F[]` |
| `providers` |  | ` ButtonProps[]`  Display a list of Button under the description.`{ color: 'neutral', variant: 'subtle', block: true }` |
| `separator` | `'or'` | ` string \| SeparatorProps`  The text displayed in the separator. |
| `submit` |  | ` Omit<ButtonProps, LinkPropsKeys>`  Display a submit button at the bottom of the form.`{ label: 'Continue', block: true }` |
| `schema` |  | ` T` |
| `validate` |  | ` (state: Partial<InferInput<T>>): FormError<string>[] \| Promise<FormError<string>[]>` |
| `validateOn` |  | ` FormInputEvents[]` |
| `validateOnInputDelay` |  | ` number` |
| `disabled` |  | `boolean` |
| `loading` |  | `boolean` |
| `loadingAuto` |  | `boolean` |
| `name` |  | ` string` |
| `autocomplete` |  | ` string` |
| `acceptcharset` |  | ` string` |
| `action` |  | ` string` |
| `enctype` |  | ` string` |
| `method` |  | ` string` |
| `novalidate` |  | ` false \| true \| "true" \| "false"` |
| `target` |  | ` string` |
| `ui` |  | ` { root?: ClassNameValue; header?: ClassNameValue; leading?: ClassNameValue; leadingIcon?: ClassNameValue; title?: ClassNameValue; description?: ClassNameValue; body?: ClassNameValue; providers?: ClassNameValue; checkbox?: ClassNameValue; select?: ClassNameValue; password?: ClassNameValue; otp?: ClassNameValue; input?: ClassNameValue; separator?: ClassNameValue; form?: ClassNameValue; footer?: ClassNameValue; }` |

This component also supports all native `<form>` HTML attributes.

### Slots

| Slot | Type |
| --- | --- |
| `header` | `{}` |
| `leading` | `{ ui: object; }` |
| `title` | `{}` |
| `description` | `{}` |
| `providers` | `{}` |
| `validation` | `{}` |
| `submit` | `{ loading: boolean; }` |
| `footer` | `{}` |

### Emits

| Event | Type |
| --- | --- |
| `submit` | `[payload: FormSubmitEvent<Reactive<InferInput<T>>>]` |

### Expose

You can access the typed component instance (exposing formRef and state) using [`useTemplateRef`](https://vuejs.org/api/composition-api-helpers.html#usetemplateref). For example, in a separate form (e.g. a "reset" form) you can do:

```
<script setup lang="ts">

const authForm = useTemplateRef('authForm')

</script>

<template>

  <UAuthForm ref="authForm" />

</template>
```

This gives you access to the following (exposed) properties:

| Name | Type |
| --- | --- |
| `formRef` | `Ref<HTMLFormElement \| null>` |
| `state` | `Reactive<FormStateType>` |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    authForm: {

      slots: {

        root: 'w-full space-y-6',

        header: 'flex flex-col text-center',

        leading: 'mb-2',

        leadingIcon: 'size-8 shrink-0 inline-block',

        title: 'text-xl text-pretty font-semibold text-highlighted',

        description: 'mt-1 text-base text-pretty text-muted',

        body: 'gap-y-6 flex flex-col',

        providers: 'space-y-3',

        checkbox: '',

        select: 'w-full',

        password: 'w-full',

        otp: 'w-full',

        input: 'w-full',

        separator: '',

        form: 'space-y-5',

        footer: 'text-sm text-center text-muted mt-2'

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

        authForm: {

          slots: {

            root: 'w-full space-y-6',

            header: 'flex flex-col text-center',

            leading: 'mb-2',

            leadingIcon: 'size-8 shrink-0 inline-block',

            title: 'text-xl text-pretty font-semibold text-highlighted',

            description: 'mt-1 text-base text-pretty text-muted',

            body: 'gap-y-6 flex flex-col',

            providers: 'space-y-3',

            checkbox: '',

            select: 'w-full',

            password: 'w-full',

            otp: 'w-full',

            input: 'w-full',

            separator: '',

            form: 'space-y-5',

            footer: 'text-sm text-center text-muted mt-2'

          }

        }

      }

    })

  ]

})
```

## Changelog

[`1f900`](https://github.com/nuxt/ui/commit/1f9009f41241790f92bb966b3399d5daf3460087) — feat: allow all input types ([#5565](https://github.com/nuxt/ui/issues/5565))

[`184ea`](https://github.com/nuxt/ui/commit/184eaab1cd5f4f4943b509ea1a3efb1b6f6d7f91) — chore: reduce type verbosity by omitting link props from action buttons

[`dd81d`](https://github.com/nuxt/ui/commit/dd81d46eaca9f552a929569418619dea5ed5f5bf) — feat: add `data-slot` attributes ([#5447](https://github.com/nuxt/ui/issues/5447))

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`fce2d`](https://github.com/nuxt/ui/commit/fce2df4e0660d0bdb3cdd4fb3041416824cbe893) — fix!: consistent exposed refs ([#5385](https://github.com/nuxt/ui/issues/5385))

[`55ea9`](https://github.com/nuxt/ui/commit/55ea9be8a4202f87b06d958b1b8acf155a1354f6) — fix: use password input id for aria-controls ([#5312](https://github.com/nuxt/ui/issues/5312))

[`63c0a`](https://github.com/nuxt/ui/commit/63c0a5f1b2039509427d770473c739410e6d06e1) — feat: expose `ui` in slot props where used ([#5207](https://github.com/nuxt/ui/issues/5207))

[`344f2`](https://github.com/nuxt/ui/commit/344f26950bd7d509aafd07a91848e4e919ebb10a) — fix: export type with proper inference for field-specific props ([#5106](https://github.com/nuxt/ui/issues/5106))

[`61b60`](https://github.com/nuxt/ui/commit/61b603fff476aeac065268bd8dd493ff45577de4) — feat: allow passing a component instead of a name ([#4766](https://github.com/nuxt/ui/issues/4766))

[`00dfb`](https://github.com/nuxt/ui/commit/00dfb6b5866760e0669e9dbbaa247919f5400f55) — fix: use `error` from form field ([#4738](https://github.com/nuxt/ui/issues/4738))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components[Tooltip](https://ui.nuxt.com/docs/components/tooltip)

[

A popup that reveals information when hovering over an element.

](https://ui.nuxt.com/docs/components/tooltip)[

BlogPost

A customizable article to display in a blog page.

](https://ui.nuxt.com/docs/components/blog-post)