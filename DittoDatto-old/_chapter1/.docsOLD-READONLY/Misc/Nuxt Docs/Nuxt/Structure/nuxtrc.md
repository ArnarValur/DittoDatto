---
title: ".nuxtrc · Nuxt Directory Structure v4"
source: "https://nuxt.com/docs/4.x/directory-structure/nuxtrc"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## .nuxtrc

The.nuxtrc file allows you to define nuxt configurations in a flat syntax.

The `.nuxtrc` file can be used to configure Nuxt with a flat syntax. It is based on [`unjs/rc9`](https://github.com/unjs/rc9).

For more advanced configurations, use [`nuxt.config`](https://nuxt.com/docs/4.x/directory-structure/nuxt-config).

## Usage

.nuxtrc

```bash
# Disable SSR

ssr=false

# Configuration for \`@nuxt/devtools\`

devtools.enabled=true

# Add Nuxt modules

modules[]=@nuxt/image

modules[]=nuxt-security

# Module setups (automatically added by Nuxt)

setups.@nuxt/test-utils="3.23.0"
```

If present, the properties in the `nuxt.config` file will overwrite the properties in `.nuxtrc` file.

Nuxt automatically adds a `setups` section to track module installation and upgrade state. This is used internally for [module lifecycle hooks](https://nuxt.com/docs/4.x/api/kit/modules#using-lifecycle-hooks-for-module-installation-and-upgrade) and should not be modified manually.

Discover all the available options in the **Nuxt configuration** documentation.

## Global.nuxtrc File

You can also create a global `.nuxtrc` file in your home directory to apply configurations globally.

- On macOS/Linux, this file is located at:
	```md
	~/.nuxtrc
	```
- On Windows, it is located at:
	```md
	C:\Users\{username}\.nuxtrc
	```

This global `.nuxtrc` file allows you to define default settings that apply to all Nuxt projects on your system. However, project-level `.nuxtrc` files will override these global settings, and `nuxt.config` will take precedence over both.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/2.directory-structure/2.nuxtrc.md)[.nuxtignore](https://nuxt.com/docs/4.x/directory-structure/nuxtignore)

[

The.nuxtignore file lets Nuxt ignore files in your project’s root directory during the build phase.

](https://nuxt.com/docs/4.x/directory-structure/nuxtignore)[

nuxt.config.ts

Nuxt can be easily configured with a single nuxt.config file.

](https://nuxt.com/docs/4.x/directory-structure/nuxt-config)