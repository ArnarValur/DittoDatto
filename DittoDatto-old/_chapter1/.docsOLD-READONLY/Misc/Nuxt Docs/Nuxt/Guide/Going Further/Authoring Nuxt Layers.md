---
title: "Authoring Nuxt Layers · Nuxt Advanced v4"
source: "https://nuxt.com/docs/4.x/guide/going-further/layers"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## Authoring Nuxt Layers

Nuxt provides a powerful system that allows you to extend the default files, configs, and much more.

Nuxt layers are a powerful feature that you can use to share and reuse partial Nuxt applications within a monorepo, or from a git repository or npm package. The layers structure is almost identical to a standard Nuxt application, which makes them easy to author and maintain.

Read more in Docs > 4 X > Getting Started > Layers.

A minimal Nuxt layer directory should contain a [`nuxt.config.ts`](https://nuxt.com/docs/4.x/directory-structure/nuxt-config) file to indicate it is a layer.

base/nuxt.config.ts

```ts
export default defineNuxtConfig({})
```

Additionally, certain other files in the layer directory will be auto-scanned and used by Nuxt for the project extending this layer.

- [`app/components/*`](https://nuxt.com/docs/4.x/directory-structure/app/components) - Extend the default components
- [`app/composables/*`](https://nuxt.com/docs/4.x/directory-structure/app/composables) - Extend the default composables
- [`app/layouts/*`](https://nuxt.com/docs/4.x/directory-structure/app/layouts) - Extend the default layouts
- [`app/middleware/*`](https://nuxt.com/docs/4.x/directory-structure/app/middleware) - Extend the default middleware
- [`app/pages/*`](https://nuxt.com/docs/4.x/directory-structure/app/pages) - Extend the default pages
- [`app/plugins/*`](https://nuxt.com/docs/4.x/directory-structure/app/plugins) - Extend the default plugins
- [`app/utils/*`](https://nuxt.com/docs/4.x/directory-structure/app/utils) - Extend the default utils
- [`app/app.config.ts`](https://nuxt.com/docs/4.x/directory-structure/app/app-config) - Extend the default app config
- [`server/*`](https://nuxt.com/docs/4.x/directory-structure/server) - Extend the default server endpoints & middleware
- [`nuxt.config.ts`](https://nuxt.com/docs/4.x/directory-structure/nuxt-config) - Extend the default nuxt config

## Basic Example

nuxt.config.ts

```ts
export default defineNuxtConfig({

  extends: [

    './base',

  ],

})
```

## Layer Priority

When extending from multiple layers, it's important to understand the override order. Layers with **higher priority** override layers with lower priority when they define the same files or components.

The priority order from highest to lowest is:

1. **Your project files** - always have the highest priority
2. **Auto-scanned layers** from `~~/layers` directory - sorted alphabetically (Z has higher priority than A)
3. **Layers in `extends`** config - first entry has higher priority than second

### When to Use Each

- **`extends`** - Use for external dependencies (npm packages, remote repositories) or layers outside your project directory
- **`~~/layers` directory** - Use for local layers that are part of your project

If you need to control the order of auto-scanned layers, you can prefix them with numbers: `~/layers/1.z-layer`, `~/layers/2.a-layer`. This way `2.a-layer` will have higher priority than `1.z-layer`.

### Example

nuxt.config.ts

```ts
export default defineNuxtConfig({

  extends: [

    // Local layer outside the project

    '../base',

    // NPM package

    '@my-themes/awesome',

    // Remote repository

    'github:my-themes/awesome#v1',

  ],

})
```

If you also have `~~/layers/custom`, the priority order is:

- Your project files (highest)
- `~~/layers/custom`
- `../base`
- `@my-themes/awesome`
- `github:my-themes/awesome#v1` (lowest)

This means your project files will override any layer, and `~~/layers/custom` will override anything in `extends`.

## Starter Template

To get started you can initialize a layer with the [nuxt/starter/layer template](https://github.com/nuxt/starter/tree/layer). This will create a basic structure you can build upon. Execute this command within the terminal to get started:

Terminal

```bash
npm create nuxt -- --template layer nuxt-layer
```

Follow up on the README instructions for the next steps.

## Publishing Layers

You can publish and share layers by either using a remote source or an npm package.

### Git Repository

You can use a git repository to share your Nuxt layer. Some examples:

nuxt.config.ts

```ts
export default defineNuxtConfig({

  extends: [

    // GitHub Remote Source

    'github:username/repoName',

    // GitHub Remote Source within /base directory

    'github:username/repoName/base',

    // GitHub Remote Source from dev branch

    'github:username/repoName#dev',

    // GitHub Remote Source from v1.0.0 tag

    'github:username/repoName#v1.0.0',

    // GitLab Remote Source example

    'gitlab:username/repoName',

    // Bitbucket Remote Source example

    'bitbucket:username/repoName',

  ],

})
```

If you want to extend a private remote source, you need to add the environment variable `GIGET_AUTH=<token>` to provide a token.

If you want to extend a remote source from a self-hosted GitHub or GitLab instance, you need to supply its URL with the `GIGET_GITHUB_URL=<url>` or `GIGET_GITLAB_URL=<url>` environment variable - or directly configure it with [the `auth` option](https://github.com/unjs/c12#extending-config-layer-from-remote-sources) in your `nuxt.config`.

Bear in mind that if you are extending a remote source as a layer, you will not be able to access its dependencies outside of Nuxt. For example, if the remote layer depends on an eslint plugin, this will not be usable in your eslint config. That is because these dependencies will be located in a special location (`node_modules/.c12/layer_name/node_modules/`) that is not accessible to your package manager.

When using git remote sources, if a layer has npm dependencies and you wish to install them, you can do so by specifying `install: true` in your layer options.

nuxt.config.ts

```ts
export default defineNuxtConfig({

  extends: [

    ['github:username/repoName', { install: true }],

  ],

})
```

### npm Package

You can publish Nuxt layers as an npm package that contains the files and dependencies you want to extend. This allows you to share your config with others, use it in multiple projects or use it privately.

To extend from an npm package, you need to make sure that the module is published to npm and installed in the user's project as a devDependency. Then you can use the module name to extend the current nuxt config:

nuxt.config.ts

```ts
export default defineNuxtConfig({

  extends: [

    // Node Module with scope

    '@scope/moduleName',

    // or just the module name

    'moduleName',

  ],

})
```

To publish a layer directory as an npm package, you want to make sure that the `package.json` has the correct properties filled out. This will make sure that the files are included when the package is published.

package.json

```json
{

  "name": "my-theme",

  "version": "1.0.0",

  "type": "module",

  "main": "./nuxt.config.ts",

  "dependencies": {},

  "devDependencies": {

    "nuxt": "^3.0.0"

  }

}
```

Make sure any dependency imported in the layer is **explicitly added** to the `dependencies`. The `nuxt` dependency, and anything only used for testing the layer before publishing, should remain in the `devDependencies` field.

Now you can proceed to publish the module to npm, either publicly or privately.

When publishing the layer as a private npm package, you need to make sure you log in, to authenticate with npm to download the node module.

## Tips

### Named Layer Aliases

Auto-scanned layers (from your `~~/layers` directory) automatically create aliases. For example, you can access your `~~/layers/test` layer via `#layers/test`.

If you want to create named layer aliases for other layers, you can specify a name in the configuration of the layer.

nuxt.config.ts

```ts
export default defineNuxtConfig({

  $meta: {

    name: 'example',

  },

})
```

This will produce an alias of `#layers/example` which points to your layer.

### Relative Paths and Aliases

When importing using global aliases (such as `~/` and `@/`) in a layer components and composables, note that these aliases are resolved relative to the user's project paths. As a workaround, you can **use relative paths** to import them, or use named layer aliases.

Also when using relative paths in `nuxt.config` file of a layer, (with exception of nested `extends`) they are resolved relative to user's project instead of the layer. As a workaround, use full resolved paths in `nuxt.config`:

nuxt.config.ts

```ts
import { fileURLToPath } from 'node:url'

import { dirname, join } from 'node:path'

const currentDir = dirname(fileURLToPath(import.meta.url))

export default defineNuxtConfig({

  css: [

    join(currentDir, './app/assets/main.css'),

  ],

})
```

## Disabling Modules from Layers

When extending a layer, you might want to disable certain modules that it includes. You can do this by setting the module's config key to `false` in your Nuxt config.

nuxt.config.ts

```ts
export default defineNuxtConfig({

  extends: ['./base-layer'],

  // Disable modules from the layer by setting their config key to false

  image: false, // Disables @nuxt/image

  pinia: false, // Disables @pinia/nuxt

})
```

The config key is defined by each module. Common examples include `image` for `@nuxt/image`, `pinia` for `@pinia/nuxt`, and `content` for `@nuxt/content`. Check the module's documentation for its specific config key.

This is useful when:

- A layer includes modules you don't need in your project
- You want to use a different implementation than what the layer provides
- You need to disable analytics or other modules in specific environments

You can also use this approach to disable modules in your own project - not just those from layers. Setting a module's config key to `false` will prevent its setup function from running while still generating types for the module.

## Multi-Layer Support for Nuxt Modules

You can use the [`getLayerDirectories`](https://nuxt.com/docs/4.x/api/kit/layers#getlayerdirectories) utility from Nuxt Kit to support custom multi-layer handling for your modules.

modules/my-module.ts

```ts
import { defineNuxtModule, getLayerDirectories } from 'nuxt/kit'

export default defineNuxtModule({

  setup (_options, nuxt) {

    const layerDirs = getLayerDirectories()

    for (const [index, layer] of layerDirs.entries()) {

      console.log(\`Layer ${index}:\`)

      console.log(\`  Root: ${layer.root}\`)

      console.log(\`  App: ${layer.app}\`)

      console.log(\`  Server: ${layer.server}\`)

      console.log(\`  Pages: ${layer.appPages}\`)

      // ... other directories

    }

  },

})
```

**Notes:**

- Earlier items in the array have higher priority and override later ones
- The user's project is the first item in the array

## Going Deeper

Configuration loading and extends support is handled by [unjs/c12](https://github.com/unjs/c12), merged using [unjs/defu](https://github.com/unjs/defu) and remote git sources are supported using [unjs/giget](https://github.com/unjs/giget). Check the docs and source code to learn more.

Checkout our ongoing development to bring more improvements for layers support on GitHub.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/3.guide/6.going-further/7.layers.md)[NuxtApp](https://nuxt.com/docs/4.x/guide/going-further/nuxt-app)

[

In Nuxt, you can access runtime app context within composables, components and plugins.

](https://nuxt.com/docs/4.x/guide/going-further/nuxt-app)[

Debugging

In Nuxt, you can get started with debugging your application directly in the browser as well as in your IDE.

](https://nuxt.com/docs/4.x/guide/going-further/debugging)