---
title: "Vue Form Component"
source: "https://ui.nuxt.com/docs/components/form"
author:
  - "[[Nuxt UI]]"
published:
created: 2026-01-28
description: "A form component with built-in validation and submission handling."
tags:
---
## Form

[GitHub](https://github.com/nuxt/ui/blob/v4/src/runtime/components/Form.vue)

A form component with built-in validation and submission handling.

## Usage

Use the Form component to validate form data using any validation library supporting [Standard Schema](https://github.com/standard-schema/standard-schema) such as [Valibot](https://github.com/fabian-hiller/valibot), [Zod](https://github.com/colinhacks/zod), [Regle](https://github.com/victorgarciaesgi/regle), [Yup](https://github.com/jquense/yup), [Joi](https://github.com/hapijs/joi) or [Superstruct](https://github.com/ianstormtaylor/superstruct) or your own validation logic.

It works with the [FormField](https://ui.nuxt.com/docs/components/form-field) component to display error messages around form elements automatically.

### Schema validation

It requires two props:

- `state` - a reactive object holding the form's state.
- `schema` - any [Standard Schema](https://github.com/standard-schema/standard-schema) or [Superstruct](https://github.com/ianstormtaylor/superstruct).

**No validation library is included** by default, ensure you **install the one you need**.

Errors are reported directly to the [FormField](https://ui.nuxt.com/docs/components/form-field) component based on the `name` or `error-pattern` prop. This means the validation rules defined for the `email` attribute in your schema will be applied to `<FormField name="email">`.

Nested validation rules are handled using dot notation. For example, a rule like `{ user: z.object({ email: z.string() }) }` will be applied to `<FormField name="user.email">`.

### Custom validation

Use the `validate` prop to apply your own validation logic.

The validation function must return a list of errors with the following attributes:

- `message` - the error message to display.
- `name` - the `name` of the `FormField` to send the error to.

It can be used alongside the `schema` prop to handle complex use cases.

```
<script setup lang="ts">

import type { FormError, FormSubmitEvent } from '@nuxt/ui'

const state = reactive({

  email: undefined,

  password: undefined

})

type Schema = typeof state

function validate(state: Partial<Schema>): FormError[] {

  const errors = []

  if (!state.email) errors.push({ name: 'email', message: 'Required' })

  if (!state.password) errors.push({ name: 'password', message: 'Required' })

  return errors

}

const toast = useToast()

async function onSubmit(event: FormSubmitEvent<Schema>) {

  toast.add({ title: 'Success', description: 'The form has been submitted.', color: 'success' })

  console.log(event.data)

}

</script>

<template>

  <UForm :validate="validate" :state="state" class="space-y-4" @submit="onSubmit">

    <UFormField label="Email" name="email">

      <UInput v-model="state.email" />

    </UFormField>

    <UFormField label="Password" name="password">

      <UInput v-model="state.password" type="password" />

    </UFormField>

    <UButton type="submit">

      Submit

    </UButton>

  </UForm>

</template>
```

### Input events

The Form component automatically triggers validation when an input emits an `input`, `change`, or `blur` event.

- Validation on `input` occurs **as you type**.
- Validation on `change` occurs when you **commit to a value**.
- Validation on `blur` happens when an input **loses focus**.

You can control when validation happens this using the `validate-on` prop.

The form always validates on submit.

You can use the [`useFormField`](https://ui.nuxt.com/docs/composables/use-form-field) composable to implement this inside your own components.

You can listen to the `@error` event to handle errors. This event is triggered when the form is submitted and contains an array of `FormError` objects with the following fields:

- `id` - the input's `id`.
- `name` - the `name` of the `FormField`
- `message` - the error message to display.

Here's an example that focuses the first input element with an error after the form is submitted:

```
<script setup lang="ts">

import type { FormError, FormErrorEvent, FormSubmitEvent } from '@nuxt/ui'

const state = reactive({

  email: undefined,

  password: undefined

})

type Schema = typeof state

function validate(state: Partial<Schema>): FormError[] {

  const errors = []

  if (!state.email) errors.push({ name: 'email', message: 'Required' })

  if (!state.password) errors.push({ name: 'password', message: 'Required' })

  return errors

}

const toast = useToast()

async function onSubmit(event: FormSubmitEvent<Schema>) {

  toast.add({ title: 'Success', description: 'The form has been submitted.', color: 'success' })

  console.log(event.data)

}

async function onError(event: FormErrorEvent) {

  if (event?.errors?.[0]?.id) {

    const element = document.getElementById(event.errors[0].id)

    element?.focus()

    element?.scrollIntoView({ behavior: 'smooth', block: 'center' })

  }

}

</script>

<template>

  <UForm :validate="validate" :state="state" class="space-y-4" @submit="onSubmit" @error="onError">

    <UFormField label="Email" name="email">

      <UInput v-model="state.email" />

    </UFormField>

    <UFormField label="Password" name="password">

      <UInput v-model="state.password" type="password" />

    </UFormField>

    <UButton type="submit">

      Submit

    </UButton>

  </UForm>

</template>
```

### Nesting forms

Use the `nested` prop to nest multiple Form components and link their validation functions. In this case, validating the parent form will automatically validate all the other forms inside it.

Nested forms directly inherit their parent's state, so you don't need to define a separate state for them. You can use the `name` prop to target a nested attribute within the parent's state.

It can be used to dynamically add fields based on user's input:

```
<script setup lang="ts">

import * as z from 'zod'

import type { FormSubmitEvent } from '@nuxt/ui'

const schema = z.object({

  name: z.string().min(2),

  news: z.boolean().default(false)

})

type Schema = z.output<typeof schema>

const nestedSchema = z.object({

  email: z.email()

})

type NestedSchema = z.output<typeof nestedSchema>

const state = reactive<Partial<Schema & NestedSchema>>({ })

const toast = useToast()

async function onSubmit(event: FormSubmitEvent<Schema>) {

  toast.add({ title: 'Success', description: 'The form has been submitted.', color: 'success' })

  console.log(event.data)

}

</script>

<template>

  <UForm

    ref="form"

    :state="state"

    :schema="schema"

    class="gap-4 flex flex-col w-60"

    @submit="onSubmit"

  >

    <UFormField label="Name" name="name">

      <UInput v-model="state.name" placeholder="John Lennon" />

    </UFormField>

    <div>

      <UCheckbox v-model="state.news" name="news" label="Register to our newsletter" @update:model-value="state.email = undefined" />

    </div>

    <UForm v-if="state.news" :schema="nestedSchema" nested>

      <UFormField label="Email" name="email">

        <UInput v-model="state.email" placeholder="john@lennon.com" />

      </UFormField>

    </UForm>

    <div>

      <UButton type="submit">

        Submit

      </UButton>

    </div>

  </UForm>

</template>
```

Or to validate list inputs:

```
<script setup lang="ts">

import * as z from 'zod'

import type { FormSubmitEvent } from '@nuxt/ui'

const schema = z.object({

  customer: z.string().min(2)

})

type Schema = z.output<typeof schema>

const itemSchema = z.object({

  description: z.string().min(1),

  price: z.number().min(0)

})

type ItemSchema = z.output<typeof itemSchema>

const state = reactive<Partial<Schema & { items: Partial<ItemSchema>[] }>>({ })

function addItem() {

  if (!state.items) {

    state.items = []

  }

  state.items.push({})

}

function removeItem() {

  if (state.items) {

    state.items.pop()

  }

}

const toast = useToast()

async function onSubmit(event: FormSubmitEvent<Schema>) {

  toast.add({ title: 'Success', description: 'The form has been submitted.', color: 'success' })

  console.log(event.data)

}

</script>

<template>

  <UForm

    :state="state"

    :schema="schema"

    class="gap-4 flex flex-col w-60"

    @submit="onSubmit"

  >

    <UFormField label="Customer" name="customer">

      <UInput v-model="state.customer" placeholder="Wonka Industries" />

    </UFormField>

    <UForm

      v-for="item, count in state.items"

      :key="count"

      :name="\`items.${count}\`"

      :schema="itemSchema"

      class="flex gap-2"

      nested

    >

      <UFormField :label="!count ? 'Description' : undefined" name="description">

        <UInput v-model="item.description" />

      </UFormField>

      <UFormField :label="!count ? 'Price' : undefined" name="price" class="w-20">

        <UInput v-model="item.price" type="number" />

      </UFormField>

    </UForm>

    <div class="flex gap-2">

      <UButton color="neutral" variant="subtle" size="sm" @click="addItem()">

        Add Item

      </UButton>

      <UButton color="neutral" variant="ghost" size="sm" @click="removeItem()">

        Remove Item

      </UButton>

    </div>

    <div>

      <UButton type="submit">

        Submit

      </UButton>

    </div>

  </UForm>

</template>
```

## API

### Props

| Prop | Default | Type |
| --- | --- | --- |
| `id` |  | ` string \| number` |
| `schema` |  | ` S`  Schema to validate the form state. Supports Standard Schema objects, Yup, Joi, and Superstructs. |
| `state` |  | ` N extends false ? Partial<InferInput<S>> : never`  An object representing the current state of the form. |
| `validate` |  | ` (state: Partial<InferInput<S>>): FormError<string>[] \| Promise<FormError<string>[]>`  Custom validation function to validate the form state. |
| `validateOn` | `` `['blur', 'change', 'input']` `` | ` FormInputEvents[]`  The list of input events that trigger the form validation. |
| `disabled` |  | `boolean`  Disable all inputs inside the form. |
| `name` |  | ` N extends true ? string : never`  Path of the form's state within it's parent form. Used for nesting forms. Only available if `nested` is true. |
| `validateOnInputDelay` | `300` | ` number`  Delay in milliseconds before validating the form on input events. |
| `transform` | `true as T` | ` T`  If true, applies schema transformations on submit. |
| `nested` | `` `false` `` | ` N`  If true, this form will attach to its parent Form and validate at the same time. |
| `loadingAuto` | `true` | `boolean`  When `true`, all form elements will be disabled on `@submit` event. This will cause any focused input elements to lose their focus state. |
| `acceptcharset` |  | ` string` |
| `action` |  | ` string` |
| `autocomplete` |  | ` string` |
| `enctype` |  | ` string` |
| `method` |  | ` string` |
| `novalidate` |  | ` false \| true \| "true" \| "false"` |
| `target` |  | ` string` |

This component also supports all native `<form>` HTML attributes.

### Slots

| Slot | Type |
| --- | --- |
| `default` | `{ errors: FormError<string>[]; loading: boolean; }` |

### Emits

| Event | Type |
| --- | --- |
| `submit` | `[event: FormSubmitEvent<FormData<S, T>>]` |
| `error` | `[event: FormErrorEvent]` |

### Expose

You can access the typed component instance using [`useTemplateRef`](https://vuejs.org/api/composition-api-helpers.html#usetemplateref).

```
<script setup lang="ts">

const form = useTemplateRef('form')

</script>

<template>

  <UForm ref="form" />

</template>
```

This will give you access to the following:

| Name | Type |
| --- | --- |
| `submit()` | `Promise<void>`    Triggers form submission. |
| `validate(opts: { name?: keyof T \| (keyof T)[], silent?: boolean, nested?: boolean, transform?: boolean })` | `Promise<T>`    Triggers form validation. Will raise any errors unless `opts.silent` is set to true. |
| `clear(path?: keyof T \| RegExp)` | `void`    Clears form errors associated with a specific path. If no path is provided, clears all form errors. |
| `getErrors(path?: keyof T RegExp)` | `FormError[]`    Retrieves form errors associated with a specific path. If no path is provided, returns all form errors. |
| `setErrors(errors: FormError[], name?: keyof T RegExp)` | `void`    Sets form errors for a given path. If no path is provided, overrides all errors. |
| `errors` | `Ref<FormError[]>`    A reference to the array containing validation errors. Use this to access or manipulate the error information. |
| `disabled` | `Ref<boolean>` |
| `dirty` | `Ref<boolean>` `true` if at least one form field has been updated by the user. |
| `dirtyFields` | `DeepReadonly<Set<keyof T>>` Tracks fields that have been modified by the user. |
| `touchedFields` | `DeepReadonly<Set<keyof T>>` Tracks fields that the user interacted with. |
| `blurredFields` | `DeepReadonly<Set<keyof T>>` Tracks fields blurred by the user. |

## Theme

app.config.ts

```ts
export default defineAppConfig({

  ui: {

    form: {

      base: ''

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

        form: {

          base: ''

        }

      }

    })

  ]

})
```

## Changelog

[`5b177`](https://github.com/nuxt/ui/commit/5b177513238ffb6a060bf200d4cb1566bc866938) — feat: extend native HTML attributes ([#5348](https://github.com/nuxt/ui/issues/5348))

[`8d5c2`](https://github.com/nuxt/ui/commit/8d5c26f216e5b6790393d1ce97350d20f4e47962) — fix: refine `nested` prop type handling and simplify logic ([#5360](https://github.com/nuxt/ui/issues/5360))

[`817b9`](https://github.com/nuxt/ui/commit/817b902070183c197616f499159aa4bf3616c3a5) — fix: flaky reactivity tests ([#5033](https://github.com/nuxt/ui/issues/5033))

[`77a55`](https://github.com/nuxt/ui/commit/77a554eb422e243fd43a6105df22568ef333a0b4) — fix: improve nested form validation handling ([#5024](https://github.com/nuxt/ui/issues/5024))

[`99dbe`](https://github.com/nuxt/ui/commit/99dbe81783f16cdd9bee14e9c74b34b93eb61976) — fix!: don't mutate the form's state if transformations are enabled ([#4902](https://github.com/nuxt/ui/issues/4902))

[`2269b`](https://github.com/nuxt/ui/commit/2269b4831acb172ce9ab9d1526ce60051b7462b8) — fix: handling race condition on `clear` function ([#4843](https://github.com/nuxt/ui/issues/4843))

[`7133f`](https://github.com/nuxt/ui/commit/7133f501e4346ba6990c437cfa16af05b886c884) — fix: broken types for `update:model-value` event ([#4853](https://github.com/nuxt/ui/issues/4853))

[`ec2bc`](https://github.com/nuxt/ui/commit/ec2bc0a89d3b0854b6ccd6384d1a5fd78be8b726) — feat: export form errors injection key ([#4808](https://github.com/nuxt/ui/issues/4808))

[`a32cc`](https://github.com/nuxt/ui/commit/a32cc37f7392499ab02558e4d58b46195f7ffad4) — fix: default slot types ([#4758](https://github.com/nuxt/ui/issues/4758))

[`5cb65`](https://github.com/nuxt/ui/commit/5cb65cfbd0d176393e841796bbbcd825be7cd376) — feat: import `@nuxt/ui-pro` components

[`b8b74`](https://github.com/nuxt/ui/commit/b8b74a0c333f1cad12781aecd3f20e94b8617763) — feat: support error RegExp in exposed methods ([#4608](https://github.com/nuxt/ui/issues/4608))

[`5ea35`](https://github.com/nuxt/ui/commit/5ea3581414cc8f03c97d95f6fd63a3d8611a1082) — docs: add tips for submit only validation ([#4554](https://github.com/nuxt/ui/issues/4554))

[`6f2ce`](https://github.com/nuxt/ui/commit/6f2ce5c610e1247e70b6e2072059cf6ecbe82711) — refactor: unite syntax for emits declaration ([#4512](https://github.com/nuxt/ui/issues/4512))

[`1a8fe`](https://github.com/nuxt/ui/commit/1a8feb751e6827c414ef82fe9fb259ba7dcc7e08) — fix: expose reactive fields ([#4386](https://github.com/nuxt/ui/issues/4386))

[`ea0c4`](https://github.com/nuxt/ui/commit/ea0c459306be585bacaaf5b433114d072550c824) — feat: expose loading state to default slot ([#4247](https://github.com/nuxt/ui/issues/4247))

[`37abc`](https://github.com/nuxt/ui/commit/37abcc6a5b0a678be626673af5067956657a50d6) — fix: conditionally type form data via `transform` prop ([#4188](https://github.com/nuxt/ui/issues/4188))

[`f4294`](https://github.com/nuxt/ui/commit/f42949820be9be9fca41abc653dc12c033e1eeec) — fix: input and output type inference ([#3938](https://github.com/nuxt/ui/issues/3938))

[`1a0d7`](https://github.com/nuxt/ui/commit/1a0d7a3103cf7591b019ef3ad685e2f3786ef6f2) — feat: add `attach` prop to opt-out of nested form attachement ([#3939](https://github.com/nuxt/ui/issues/3939))

[`8e78e`](https://github.com/nuxt/ui/commit/8e78eb15c85beef1c814206c4a192d4eb00a7e86) — fix: loses focus on submit ([#3796](https://github.com/nuxt/ui/issues/3796))

[`fdee2`](https://github.com/nuxt/ui/commit/fdee2522bb9d8361ff3e9fdd4aa2350be8e49b05) — feat: export loading state ([#3861](https://github.com/nuxt/ui/issues/3861))

[`39c86`](https://github.com/nuxt/ui/commit/39c861a64bbd452256ebd1a14a257b94c35855d4) — fix: refactor types after `@nuxt/module-builder` upgrade ([#3855](https://github.com/nuxt/ui/issues/3855))

[`3dd88`](https://github.com/nuxt/ui/commit/3dd88bacecb2945efba8cc3cb4fe59fcbc056e9a) — fix: clear dirty state after submit ([#3692](https://github.com/nuxt/ui/issues/3692))

[`02184`](https://github.com/nuxt/ui/commit/02184b016a8450c03ef916c0eaedd86996379518) — chore: improve TSDoc ([#3619](https://github.com/nuxt/ui/issues/3619))[FileUpload](https://ui.nuxt.com/docs/components/file-upload)

[

An input element to upload files.

](https://ui.nuxt.com/docs/components/file-upload)[

FormField

A wrapper for form elements that provides validation and error handling.

](https://ui.nuxt.com/docs/components/form-field)