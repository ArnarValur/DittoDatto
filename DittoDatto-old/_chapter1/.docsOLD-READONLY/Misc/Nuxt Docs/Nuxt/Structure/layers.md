---
title: "layers · Nuxt Directory Structure v4"
source: "https://nuxt.com/docs/4.x/directory-structure/layers"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
The `layers/` directory allows you to organize and share reusable code, components, composables, and configurations across your Nuxt application. Any layers within your project in the `layers/` directory will be automatically registered.

The `layers/` directory auto-registration is available in Nuxt v3.12.0+.

Layers are ideal for organizing large codebases with **Domain-Driven Design (DDD)**, creating reusable **UI libraries** or **themes**, sharing **configuration presets** across projects, and separating concerns like **admin panels** or **feature modules**.

## Structure

Each subdirectory within `layers/` is treated as a separate layer. A layer can contain the same structure as a standard Nuxt application.

Every layer **must have** a `nuxt.config.ts` file to be recognized as a valid layer, even if it's empty.

Directory structure

```bash
-| layers/

---| base/

-----| nuxt.config.ts

-----| app/

-------| components/

---------| BaseButton.vue

-------| composables/

---------| useBase.ts

-----| server/

-------| api/

---------| hello.ts

---| admin/

-----| nuxt.config.ts

-----| app/

-------| pages/

---------| admin.vue

-------| layouts/

---------| admin.vue
```

## Automatic Aliases

Named layer aliases to the `srcDir` of each layer are automatically created. You can access a layer using the `#layers/[name]` alias:

```ts
// Access the base layer

import something from '#layers/base/path/to/file'

// Access the admin layer

import { useAdmin } from '#layers/admin/composables/useAdmin'
```

Named layer aliases were introduced in Nuxt v3.16.0.

## Layer Content

Each layer can include:

- [`nuxt.config.ts`](https://nuxt.com/docs/4.x/directory-structure/nuxt-config) - Layer-specific configuration that will be merged with the main config
- [`app.config.ts`](https://nuxt.com/docs/4.x/directory-structure/app/app-config) - Reactive application configuration
- [`app/components/`](https://nuxt.com/docs/4.x/directory-structure/app/components) - Vue components (auto-imported)
- [`app/composables/`](https://nuxt.com/docs/4.x/directory-structure/app/composables) - Vue composables (auto-imported)
- [`app/utils/`](https://nuxt.com/docs/4.x/directory-structure/app/utils) - Utility functions (auto-imported)
- [`app/pages/`](https://nuxt.com/docs/4.x/directory-structure/app/pages) - Application pages
- [`app/layouts/`](https://nuxt.com/docs/4.x/directory-structure/app/layouts) - Application layouts
- [`app/middleware/`](https://nuxt.com/docs/4.x/directory-structure/app/middleware) - Route middleware
- [`app/plugins/`](https://nuxt.com/docs/4.x/directory-structure/app/plugins) - Nuxt plugins
- [`server/`](https://nuxt.com/docs/4.x/directory-structure/server) - Server routes, middleware, and utilities
- [`shared/`](https://nuxt.com/docs/4.x/directory-structure/shared) - Shared code between app and server

## Priority Order

When multiple layers define the same resource (component, composable, page, etc.), the layer with **higher priority wins**. Layers are sorted alphabetically, with later letters having higher priority (Z > A).

To control the order, prefix directories with numbers: `1.base/`, `2.features/`, `3.admin/`.

Read more in Docs > 4 X > Getting Started > Layers#layer Priority.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/2.directory-structure/1.layers.md)