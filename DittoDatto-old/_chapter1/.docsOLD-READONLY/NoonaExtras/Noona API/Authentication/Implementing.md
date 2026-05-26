---
tag: "noona.is"
---
[Authentication](https://docs.noona.is/docs/authentication) [OAuth 2.0](https://docs.noona.is/docs/authentication/oauth)

In the previous section I highlighted the existence, and importance, of two endpoints:

- **Authorization** - \[[**Docs**](https://docs.noona.is/docs/hq/oauth/StartOAuthFlow) | [**Endpoint**](https://api.noona.is/v1/hq/oauth/auth)\]
- **Token** - \[[**Docs**](https://docs.noona.is/docs/hq/oauth/GetOAuthToken) | [**Endpoint**](https://api.noona.is/v1/hq/oauth/token)\]

For an external system that has validity and purpose outside of Noona, the developers might want to allow the flow from that side (and maybe exclusively so and omit the **App Store** flag when creating the app).

In that scenario the flow is:

1. User clicks 'Connect to Noona' in external system.
2. External system redirects user to:
	```
	https://api.noona.is/v1/hq/oauth/auth?response_type=code&client_id=G7NN26z5iAPhUFx2cvzcplEb&scope=user:read&scope=events:write&redirect_uri=https://external.app/oauth/callback&state=some-unique-identifier
	```
	and as we can see the required query parameters are being populated.
	![Auth Endpoint](https://docs.noona.is/docs/_next/image?url=%2Fdocs%2Fimg%2Fauth_endpoint.png&w=1920&q=75) Why pass in redirect\_uri?
	A single OAuth application might have multiple redirect URIs specified. So one of those URIs must be explicitly specified when starting the flow.
3. Noona handles consent and redirects the user to the redirect\_uri from step 2 with:
	- An Authorization Code
	- The state variable if it was provided
	- The scopes that the user gave consent for
4. External application knows what user just finished the flow from the state variable it sent during step 2. So the application can exchange the authorization code for a refresh/access token **using the token endpoint** and connect it to the user **identified by the state variable**.
	The token endpoint requires client authentication. The **recommended method** is HTTP Basic Authentication:
	```
	curl -X POST 'https://api.noona.is/v1/hq/oauth/token' \
	  -H 'Authorization: Basic base64(client_id:client_secret)' \
	  -H 'Content-Type: application/json' \
	  -d '{"grant_type": "authorization_code", "code": "<authorization-code>"}'
	```
	Legacy: Query parameters (deprecated)
	For backwards compatibility, you can also pass `client_id` and `client_secret` as query parameters. However, this method is deprecated as it exposes credentials in server logs and URLs. Use HTTP Basic Authentication instead.
5. It can now call Noona API using the access token with the Bearer authentication scheme.

Again, for more detailed guides visit the [**App Store Section**](https://docs.noona.is/docs/app-store).[Behind the scenes](https://docs.noona.is/docs/authentication/oauth/behind-the-scenes)

[

HQ API

Comprehensive API for business management and operations

](https://docs.noona.is/docs/hq)