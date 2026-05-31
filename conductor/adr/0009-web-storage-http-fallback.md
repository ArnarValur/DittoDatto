# ADR-0009: Web Storage HTTP Fallback

> **Recorded:** 2026-06-01 00:12
> **Status:** accepted

## Context

When deploying the Admin Panel to our on-premise staging environment (Saturn) over a Tailscale mesh VPN, it is served on an unsecure HTTP origin (`http://dittodatto.tailb251cd.ts.net:8002`). Under non-secure HTTP contexts, modern browsers disable the Web Cryptography API (`window.crypto.subtle`). 

Using the `flutter_secure_storage` package on Web targets requires Web Crypto. Calling `write()` in non-secure contexts throws an unhandled JavaScript runtime error, which crashed the authentication flow and froze the login page.

## Decision

We will implement a platform-agnostic, conditionally-imported Web Storage wrapper:
1. **Conditional Import:** Define `WebStorage` using conditional compile-time imports (`dart.library.html` routing to `dart:html` on Web targets and stubbing on native targets).
2. **Plain LocalStorage Fallback:** On Web targets, route token persistence directly to the browser's standard `window.localStorage` (unencrypted).
3. **Native Isolation:** On native platforms (Linux desktop, Android), continue to rely on the standard encrypted secure storage of `FlutterSecureStorage`.
4. **Defensive Error Handling:** Catch all runtime errors and exceptions (`catch (e)`) during auth operations to prevent UI freeze.

## Consequences

- The Admin Panel compiles and runs flawlessly under non-secure HTTP web staging environments (like Saturn).
- Stored tokens on the Web are stored unencrypted in `localStorage`. This is acceptable because access to the Tailscale mesh VPN is strictly gated and staging credentials have limited lifetimes.
- Android and Linux desktop compilations are completely unaffected and retain full, high-grade hardware-backed secure storage.
