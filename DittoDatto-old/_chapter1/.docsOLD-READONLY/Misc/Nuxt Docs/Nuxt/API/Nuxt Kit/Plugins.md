---
title: "Plugins · Nuxt Kit v4"
source: "https://nuxt.com/docs/4.x/api/kit/plugins"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## Plugins

[Source](https://github.com/nuxt/nuxt/blob/main/packages/kit/src/plugin.ts)

Nuxt Kit provides a set of utilities to help you create and use plugins. You can add plugins or plugin templates to your module using these functions.

Plugins are self-contained code that usually add app-level functionality to Vue. In Nuxt, plugins are automatically imported from the `app/plugins/` directory. However, if you need to ship a plugin with your module, Nuxt Kit provides the `addPlugin` and `addPluginTemplate` methods. These utils allow you to customize the plugin configuration to better suit your needs.

## addPlugin

Registers a Nuxt plugin and adds it to the plugins array.

Watch Vue School video about `addPlugin`.

### Usage

```ts
import { addPlugin, createResolver, defineNuxtModule } from '@nuxt/kit'

export default defineNuxtModule({

  setup () {

    const { resolve } = createResolver(import.meta.url)

    addPlugin({

      src: resolve('runtime/plugin.js'),

      mode: 'client',

    })

  },

})
```

### Type

```ts
function addPlugin (plugin: NuxtPlugin | string, options?: AddPluginOptions): NuxtPlugin
```

### Parameters

**`plugin`**: A plugin object or a string with the path to the plugin. If a string is provided, it will be converted to a plugin object with `src` set to the string value.

If a plugin object is provided, it must have the following properties:

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `src` | `string` | `true` | Path to the plugin file. |
| `mode` | `'all' \| 'server' \| 'client'` | `false` | If set to `'all'`, the plugin will be included in both client and server bundles. If set to `'server'`, the plugin will only be included in the server bundle. If set to `'client'`, the plugin will only be included in the client bundle. You can also use `.client` and `.server` modifiers when specifying `src` option to use plugin only in client or server side. |
| `order` | `number` | `false` | Order of the plugin. This allows more granular control over plugin order and should only be used by advanced users. Lower numbers run first, and user plugins default to `0`. It's recommended to set `order` to a number between `-20` for `pre` -plugins (plugins that run before Nuxt plugins) and `20` for `post` -plugins (plugins that run after Nuxt plugins). |

Avoid using `order` unless necessary. Use `append` if you simply need to register plugins after Nuxt defaults.

**`options`**: Optional object with the following properties:

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `append` | `boolean` | `false` | If `true`, the plugin will be appended to the plugins array. If `false`, it will be prepended. Defaults to `false`. |

### Examples

## addPluginTemplate

Adds a template and registers as a nuxt plugin. This is useful for plugins that need to generate code at build time.

Watch Vue School video about `addPluginTemplate`.

### Usage

```ts
import { addPluginTemplate, defineNuxtModule } from '@nuxt/kit'

export default defineNuxtModule({

  setup (options) {

    addPluginTemplate({

      filename: 'module-plugin.mjs',

      getContents: () => \`import { defineNuxtPlugin } from '#app/nuxt'

export default defineNuxtPlugin({

  name: 'module-plugin',

  setup (nuxtApp) {

    ${options.log ? 'console.log("Plugin install")' : ''}

  }

})\`,

    })

  },

})
```

### Type

```ts
function addPluginTemplate (pluginOptions: NuxtPluginTemplate, options?: AddPluginOptions): NuxtPlugin
```

### Parameters

**`pluginOptions`**: A plugin template object with the following properties:

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `src` | `string` | `false` | Path to the template. If `src` is not provided, `getContents` must be provided instead. |
| `filename` | `string` | `false` | Filename of the template. If `filename` is not provided, it will be generated from the `src` path. In this case, the `src` option is required. |
| `dst` | `string` | `false` | Path to the destination file. If `dst` is not provided, it will be generated from the `filename` path and nuxt `buildDir` option. |
| `mode` | `'all' \| 'server' \| 'client'` | `false` | If set to `'all'`, the plugin will be included in both client and server bundles. If set to `'server'`, the plugin will only be included in the server bundle. If set to `'client'`, the plugin will only be included in the client bundle. You can also use `.client` and `.server` modifiers when specifying `src` option to use plugin only in client or server side. |
| `options` | `Record<string, any>` | `false` | Options to pass to the template. |
| `getContents` | `(data: Record<string, any>) => string \| Promise<string>` | `false` | A function that will be called with the `options` object. It should return a string or a promise that resolves to a string. If `src` is provided, this function will be ignored. |
| `write` | `boolean` | `false` | If set to `true`, the template will be written to the destination file. Otherwise, the template will be used only in virtual filesystem. |
| `order` | `number` | `false` | Order of the plugin. This allows more granular control over plugin order and should only be used by advanced users. Lower numbers run first, and user plugins default to `0`. It's recommended to set `order` to a number between `-20` for `pre` -plugins (plugins that run before Nuxt plugins) and `20` for `post` -plugins (plugins that run after Nuxt plugins). |

Prefer using `getContents` for dynamic plugin generation. Avoid setting `order` unless necessary.

**`options`**: Optional object with the following properties:

| Property | Type | Required | Description |
| --- | --- | --- | --- |
| `append` | `boolean` | `false` | If `true`, the plugin will be appended to the plugins array. If `false`, it will be prepended. Defaults to `false`. |

### Examples

#### Generate a plugin template with different options

Use `addPluginTemplate` when you need to generate plugin code dynamically at build time. This allows you to generate different plugin contents based on the options passed to it. For example, Nuxt internally uses this function to generate Vue app configurations.

module.ts

```ts
import { addPluginTemplate, defineNuxtModule } from '@nuxt/kit'

export default defineNuxtModule({

  setup (_, nuxt) {

    if (nuxt.options.vue.config && Object.values(nuxt.options.vue.config).some(v => v !== null && v !== undefined)) {

      addPluginTemplate({

        filename: 'vue-app-config.mjs',

        write: true,

        getContents: () => \`import { defineNuxtPlugin } from '#app/nuxt'

export default defineNuxtPlugin({

  name: 'nuxt:vue-app-config',

  enforce: 'pre',

  setup (nuxtApp) {

    ${Object.keys(nuxt.options.vue.config!)

        .map(k => \`nuxtApp.vueApp.config[${JSON.stringify(k)}] = ${JSON.stringify(nuxt.options.vue.config![k as 'idPrefix'])}\`)

        .join('\n')

    }

  }

})\`,

      })

    }

  },

})
```

This generates different plugin code depending on the provided configuration.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/4.api/5.kit/9.plugins.md)[Head](https://nuxt.com/docs/4.x/api/kit/head)

[

Nuxt Kit provides utilities to help you manage head configuration in modules.

](https://nuxt.com/docs/4.x/api/kit/head)[

Lifecycle Hooks

Nuxt provides a powerful hooking system to expand almost every aspect using hooks.

](https://nuxt.com/docs/4.x/api/advanced/hooks)