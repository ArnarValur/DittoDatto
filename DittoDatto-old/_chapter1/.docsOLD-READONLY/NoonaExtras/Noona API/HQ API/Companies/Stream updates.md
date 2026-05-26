---
tag: "noona.is"
---
[HQ API](https://docs.noona.is/docs/hq) Companies

Streams updates for specified entity types for a company.

This is a generic stream endpoint that allows clients to subscribe to real-time updates for specific types of entities. The client specifies which entity types to monitor through the filter parameter, and will receive notifications whenever those entities are created, updated, or deleted.

The stream uses Server-Sent Events (SSE) protocol and maintains a persistent connection to deliver real-time updates.

## Event Names

The endpoint emits typed SSE events based on the entity type that was updated. See the `StreamEventName` schema for all possible event names and their meanings.

Each event name follows the pattern `on{EntityType}Updated` (singular form):

- `events` entity type → `onEventUpdated` event name
- `products` entity type → `onProductUpdated` event name
- `notifications` entity type → `onNotificationUpdated` event name
- ... etc.

## Response Format

The stream returns Server-Sent Events with typed event names and empty JSON objects as payload.

The JSON payload could include metadata about the update in the future.

```
event: onEventUpdated

data: {}

event: onProductUpdated

data: {}
```

## Client Usage

```
const eventSource = new EventSource('/v1/hq/stream/companies/123?filter={"entity_types":["events","products"]}');

eventSource.addEventListener('onEventUpdated', (event) => {

  console.log('An event was updated!');

  // Refresh your events data

});

eventSource.addEventListener('onProductUpdated', (event) => {

  console.log('A product was updated!');

  // Refresh your products data

});
```

GET `/v1/hq/stream/companies/{company_id}`

BearerTokenAuth

Authorization Bearer <token>

The Noona HQ API uses Bearer token for authentication.

Endpoints that return generic information that does not contain sensitive data do not require authentication. Endpoints that require authentication are specifically marked in the documentation.

**Authorization: Bearer your-token**

In: `header`

## Path Parameters

company\_id \* string

Example `"dwawd8awudawd"`

## Query Parameters

filter \*

Filter for the generic entity stream endpoint.

Specifies which types of entities to subscribe to for real-time updates. Multiple entity types can be specified to receive updates for all of them.

select?array<string>

[Field Selector](https://api.noona.is/docs/working-with-the-apis/select)

expand?array<string>

[Expandable attributes](https://api.noona.is/docs/working-with-the-apis/expandable_attributes)

## Response Body

```
curl -X GET "https://api.noona.is/v1/hq/stream/companies/dwawd8awudawd?entity_types=events%2Cnotifications%2Cproducts"
```

Empty

Empty

Empty[List VATs GET](https://docs.noona.is/docs/hq/companies/ListVATs)

[

Previous Page

](https://docs.noona.is/docs/hq/companies/ListVATs)[

Update a company POST

Next Page

](https://docs.noona.is/docs/hq/companies/UpdateCompany)