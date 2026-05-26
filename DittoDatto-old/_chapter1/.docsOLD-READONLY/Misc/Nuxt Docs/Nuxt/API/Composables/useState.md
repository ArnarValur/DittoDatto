---
title: "useState · Nuxt Composables v4"
source: "https://nuxt.com/docs/4.x/api/composables/use-state"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## Usage

```ts
// Create a reactive state and set default value

const count = useState('counter', () => Math.round(Math.random() * 100))
```

Read more in Docs > 4 X > Getting Started > State Management.

Because the data inside `useState` will be serialized to JSON, it is important that it does not contain anything that cannot be serialized, such as classes, functions or symbols.

`useState` is a reserved function name transformed by the compiler, so you should not name your own function `useState`.

## Using shallowRef

If you don't need your state to be deeply reactive, you can combine `useState` with [`shallowRef`](https://vuejs.org/api/reactivity-advanced#shallowref). This can improve performance when your state contains large objects and arrays.

```ts
const state = useState('my-shallow-state', () => shallowRef({ deep: 'not reactive' }))

// isShallow(state) === true
```

## Type

Signature

```ts
export function useState<T> (init?: () => T | Ref<T>): Ref<T>

export function useState<T> (key: string, init?: () => T | Ref<T>): Ref<T>
```

- `key`: A unique key ensuring that data fetching is properly de-duplicated across requests. If you do not provide a key, then a key that is unique to the file and line number of the instance of [`useState`](https://nuxt.com/docs/4.x/api/composables/use-state) will be generated for you.
- `init`: A function that provides initial value for the state when not initiated. This function can also return a `Ref`.
- `T`: (typescript only) Specify the type of state

## Troubleshooting

### Cannot stringify arbitrary non-POJOs

This error occurs when you try to store a non-serializable payload with `useState`, such as class instances.

If you want to store class instances with `useState` that are not supported by Nuxt, you can use [`definePayloadPlugin`](https://nuxt.com/docs/4.x/api/composables/use-nuxt-app#custom-reducerreviver) to add a custom serializer and deserializer for your classes.

Read more in Docs > 4 X > API > Composables > Use Nuxt App#payload.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/2.composables/use-state.md)[useServerSeoMeta](https://nuxt.com/docs/4.x/api/composables/use-server-seo-meta)

[

The useServerSeoMeta composable lets you define your site's SEO meta tags as a flat object with full TypeScript support.

](https://nuxt.com/docs/4.x/api/composables/use-server-seo-meta)[

$fetch

Nuxt uses ofetch to expose globally the $fetch helper for making HTTP requests.

](https://nuxt.com/docs/4.x/api/utils/dollarfetch)