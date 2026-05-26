---
tag: "noona.is"
---
---

## Introduction

Noona provides webhooks for receiving HTTP push notifications whenever data is created or updated, enabling you to create integrations on top of Noona.

The creation and management of webhooks can be carried out via the [**Webhooks Page**](https://hq.noona.app/api/webhooks) within Noona HQ.

If you would like to create a webhook around an event that is currently not specified in the list of supported webhooks, please reach out and we'll add support for it.

## Security

It is possible to secure webhooks by using the ***headers*** attribute during webhook creation. The headers map will always be included in the request that happens when a webhook is triggered.

The code that processes the ***webhook invocation*** can then verify that this webhook was indeed sent from Noona.

## App Webhooks

### Creation

Apps in the Noona **[App Store](https://docs.noona.is/docs/app-store)** can utilize webhooks. But since the webhooks have to be created via code, when the app is installed for example, the webhook **[endpoints](https://docs.noona.is/docs/hq/webhooks/CreateWebhook)** need to be invoked directly.

It's important to note that an app must have a read scope for the webhook resources. If an app attempts to create a webhook that tracks **customer.created** but lacks the **customers:read** scope the webhook creation will fail.

### Cleanup

When an app is uninstalled, all webhooks created by the app are automatically deleted.