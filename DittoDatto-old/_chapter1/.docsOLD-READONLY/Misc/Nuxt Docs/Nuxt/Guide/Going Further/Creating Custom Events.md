---
title: "Creating Custom Events · Nuxt Advanced v4"
source: "https://nuxt.com/docs/4.x/guide/going-further/events"
author:
  - "nuxt.com"
published:
created: 2026-02-08
description:
tags:
  - "Nuxt"
---
## Creating Custom Events

Nuxt provides a powerful event system powered by hookable.

Using events is a great way to decouple your application and allow for more flexible and modular communication between different parts of your code. Events can have multiple listeners that do not depend on each other. For example, you may wish to send an email to your user each time an order has shipped. Instead of coupling your order processing code to your email code, you can emit an event which a listener can receive and use to dispatch an email.

The Nuxt event system is powered by [unjs/hookable](https://github.com/unjs/hookable), which is the same library that powers the Nuxt hooks system.

## Creating Events and Listeners

You can create your own custom events using the `hook` method:

To emit an event and notify any listeners, use `callHook`:

You can also use the payload object to enable two-way communication between the emitter and listeners. Since the payload is passed by reference, a listener can modify it to send data back to the emitter.

You can inspect all events using the **Nuxt DevTools** Hooks panel.

Learn more about Nuxt's built-in hooks and how to extend them

[Report an issue](https://github.com/nuxt/nuxt/issues/new/choose) or [Edit this page on GitHub](https://github.com/nuxt/nuxt/edit/main/docs/3.guide/6.going-further/1.events.md)[Sessions and Authentication](https://nuxt.com/docs/4.x/guide/recipes/sessions-and-authentication)

[

Authentication is an extremely common requirement in web apps. This recipe will show you how to implement basic user registration and authentication in your Nuxt app.

](https://nuxt.com/docs/4.x/guide/recipes/sessions-and-authentication)[

Experimental Features

Enable Nuxt experimental features to unlock new possibilities.

](https://nuxt.com/docs/4.x/guide/going-further/experimental-features)