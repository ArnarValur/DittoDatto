---
title: "Nightly Release Channel · Nuxt Advanced v4"
source: "https://nuxt.com/docs/4.x/guide/going-further/nightly-release-channel"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## Nightly Release Channel

The nightly release channel allows using Nuxt built directly from the latest commits to the repository.

Nuxt lands commits, improvements, and bug fixes every day. You can opt in to test them earlier before the next release.

After a commit is merged into the `main` branch of [nuxt/nuxt](https://github.com/nuxt/nuxt) and **passes all tests**, we trigger an automated npm release, using GitHub Actions.

You can use these 'nightly' releases to beta test new features and changes.

The build and publishing method and quality of these 'nightly' releases are the same as stable ones. The only difference is that you should often check the GitHub repository for updates. There is a slight chance of regressions not being caught during the review process and by the automated tests. Therefore, we internally use this channel to double-check everything before each release.

Features that are only available on the nightly release channel are marked with an alert in the documentation.

The `latest` nightly release channel is currently tracking the Nuxt v4 branch, meaning that it is particularly likely to have breaking changes right now — be careful! You can opt in to the 3.x branch nightly releases with `"nuxt": "npm:nuxt-nightly@3x"`.

## Opting In

Update `nuxt` dependency inside `package.json`:

package.json

```
{

  "devDependencies": {

--    "nuxt": "^4.0.0"

++    "nuxt": "npm:nuxt-nightly@latest"

  }

}
```

Remove lockfile (`package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `bun.lock` or `bun.lockb`) and reinstall dependencies.

## Opting Out

Update `nuxt` dependency inside `package.json`:

package.json

```
{

  "devDependencies": {

--    "nuxt": "npm:nuxt-nightly@latest"

++    "nuxt": "^4.0.0"

  }

}
```

Remove lockfile (`package-lock.json`, `yarn.lock`, `pnpm-lock.yaml`, `bun.lock` or `bun.lockb`) and reinstall dependencies.

## Using Nightly @nuxt/cli

To try the latest version of [nuxt/cli](https://github.com/nuxt/cli):

Terminal

```bash
npx @nuxt/cli-nightly@latest [command]
```

Read more about the available commands.

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/3.guide/6.going-further/11.nightly-release-channel.md)[Runtime Config](https://nuxt.com/docs/4.x/guide/going-further/runtime-config)

[

Nuxt provides a runtime config API to expose configuration and secrets within your application.

](https://nuxt.com/docs/4.x/guide/going-further/runtime-config)[

Lifecycle Hooks

Nuxt provides a powerful hooking system to expand almost every aspect using hooks.

](https://nuxt.com/docs/4.x/guide/going-further/hooks)