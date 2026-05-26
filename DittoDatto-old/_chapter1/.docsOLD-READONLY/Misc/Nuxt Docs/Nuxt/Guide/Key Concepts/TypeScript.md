---
title: "TypeScript · Nuxt Concepts v4"
source: "https://nuxt.com/docs/4.x/guide/concepts/typescript"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## TypeScript

Nuxt is fully typed and provides helpful shortcuts to ensure you have access to accurate type information when you are coding.

## Type-checking

By default, Nuxt doesn't check types when you run [`nuxt dev`](https://nuxt.com/docs/4.x/api/commands/dev) or [`nuxt build`](https://nuxt.com/docs/4.x/api/commands/build), for performance reasons.

To enable type-checking at build or development time, install `vue-tsc` and `typescript` as development dependency:

Then, run [`nuxt typecheck`](https://nuxt.com/docs/4.x/api/commands/typecheck) command to check your types:

Terminal

```bash
npx nuxt typecheck
```

To enable type-checking at build or development time, you can also use the [`typescript.typeCheck`](https://nuxt.com/docs/4.x/api/nuxt-config#typecheck) option in your `nuxt.config` file:

nuxt.config.ts

```ts
export default defineNuxtConfig({

  typescript: {

    typeCheck: true,

  },

})
```

## Auto-generated Types

Nuxt projects rely on auto-generated types to work properly. These types are stored in the [`.nuxt`](https://nuxt.com/docs/4.x/directory-structure/nuxt) directory and are generated when you run the dev server or build your application. You can also generate these files manually by running `nuxt prepare`.

The generated `tsconfig.json` files inside the [`.nuxt`](https://nuxt.com/docs/4.x/directory-structure/nuxt) directory include **recommended basic TypeScript configuration** for your project, references to [auto-imports](https://nuxt.com/docs/4.x/guide/concepts/auto-imports), [API route types](https://nuxt.com/docs/4.x/guide/concepts/server-engine#typed-api-routes), path aliases like `#imports`, `~/file`, or `#build/file`, and more.

Nuxt relies on this configuration, and [Nuxt modules](https://nuxt.com/docs/4.x/guide/modules) can extend it as well. For this reason, it is not recommended to modify your `tsconfig.json` file directly, as doing so could overwrite important settings. Instead, extend it via `nuxt.config.ts`. [Learn more about extending the configuration here](https://nuxt.com/docs/4.x/directory-structure/tsconfig).

Watch a video from Daniel Roe explaining built-in Nuxt aliases.

## Project References

Nuxt uses [TypeScript project references](https://www.typescriptlang.org/docs/handbook/project-references.html) to improve type-checking performance and provide better IDE support. This feature allows TypeScript to break up your codebase into smaller, more manageable pieces.

### How Nuxt Uses Project References

When you run `nuxt dev`, `nuxt build` or `nuxt prepare`, Nuxt will generate multiple `tsconfig.json` files for different parts of your application.

- **`.nuxt/tsconfig.app.json`** - Configuration for your application code within the `app/` directory
- **`.nuxt/tsconfig.node.json`** - Configuration for your `nuxt.config.ts` and files outside the other contexts
- **`.nuxt/tsconfig.server.json`** - Configuration for server-side code (when applicable)
- **`.nuxt/tsconfig.shared.json`** - For code shared between app and server contexts (like types and non-environment specific utilities)

Each of these files is configured to reference the appropriate dependencies and provide optimal type-checking for their specific context.

For backward compatibility, Nuxt still generates `.nuxt/tsconfig.json`. However, we recommend using [TypeScript project references](https://nuxt.com/docs/4.x/directory-structure/tsconfig) with the new configuration files (`.nuxt/tsconfig.app.json`, `.nuxt/tsconfig.server.json`, etc.) for better type safety and performance. This legacy file will be removed in a future version of Nuxt.

### Benefits of Project References

- **Faster builds**: TypeScript can skip rebuilding unchanged projects
- **Better IDE performance**: Your IDE can provide faster IntelliSense and error checking
- **Isolated compilation**: Errors in one part of your application don't prevent compilation of other parts
- **Clearer dependency management**: Each project explicitly declares its dependencies

### Augmenting Types with Project References

Since the project is divided into **multiple type contexts**, it's important to **augment types within the correct context** to ensure they're properly recognized. TypeScript will not recognize augmentations placed outside these directories unless they are explicitly included in the appropriate context.

For example, if you want to augment types for the `app` context, the augmentation file should be placed in the `app/` directory.

Similarly:

- For the `server` context, place the augmentation file in the `server/` directory.
- For types that are **shared between the app and server**, place the file in the `shared/` directory.

Read more about augmenting specific type contexts from **files outside those contexts** in the Module Author Guide.

## Strict Checks

TypeScript comes with certain checks to give you more safety and analysis of your program.

[Strict checks](https://www.typescriptlang.org/docs/handbook/migrating-from-javascript.html#getting-stricter-checks) are enabled by default in Nuxt when the [`typescript.typeCheck`](https://nuxt.com/docs/4.x/guide/concepts/typescript#type-checking) option is enabled to give you greater type safety.

If you are currently converting your codebase to TypeScript, you may want to temporarily disable strict checks by setting `strict` to `false` in your `nuxt.config`:

nuxt.config.ts

```ts
export default defineNuxtConfig({

  typescript: {

    strict: false,

  },

})
```

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/3.guide/1.concepts/8.typescript.md)[Modules](https://nuxt.com/docs/4.x/guide/concepts/modules)

[

Nuxt provides a module system to extend the framework core and simplify integrations.

](https://nuxt.com/docs/4.x/guide/concepts/modules)[

Code Style

Nuxt supports ESLint out of the box

](https://nuxt.com/docs/4.x/guide/concepts/code-style)