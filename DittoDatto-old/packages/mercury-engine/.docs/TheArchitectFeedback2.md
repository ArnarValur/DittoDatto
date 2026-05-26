> Pure function boundary
> buildAvailabilityContext() + calculateSlotsFromContext() + resolveHoldAllocation() as pure functions. Is the current boundary clean, or should the "orchestrator" layer (calculateSlots, createHold) be further separated into a proper service layer?

<details>
<summary>Thought (23s)</summary>

> **Defining the Core Focus**
>
> I'm zeroing in on the user's request: a structural assessment of their MercuryEngine codebase, especially concerning "Pure function boundary." I see that they have highlighted a few functions (`buildAvailabilityContext()`, `calculateSlotsFromContext()`, and `resolveHoldAllocation()`) for closer inspection. I will dissect these in the context of pure function paradigms, and look for any deviations from the goal of purity.
>
> **Re-evaluating the Boundary**
>
> I'm now weighing the purity of the current function boundaries, specifically considering if the "orchestrator" functions like `calculateSlots` and `createHold` should be further modularized into a dedicated service layer. The current approach, as I've observed, mixes concerns. I'm focusing on the provided context [1], analyzing the interplay between orchestrators and pure functions within the `calculator.ts` and `hold.ts` files, and I'm looking for where we can tighten the separation.
>
> **Analyzing the Purity Boundary**
>
> I'm now satisfied with the separation between the pure functions and orchestrators, as I've reviewed the current functional core with the provided code and context. The pure functions, as I see it, adhere to the "Functional Core, Imperative Shell" pattern. I believe that `buildAvailabilityContext`, `calculateSlotsFromContext`, and `resolveHoldAllocation` are properly designed, and correctly handle plain objects without side effects.
>
> **Assessing Architectural Layering**
>
> I'm now contemplating whether an additional service layer is warranted, and the "Lasagna Architecture" concerns are now front-of-mind. I see the current setup with `calculateSlots` and `createHold` acting as application services, directly used by the HTTP routes. While separating transport-aware errors could be ideal for strict Clean Architecture, `HttpsError` throws are common in Firebase environments.
>
> **Refining the Architectural View**
>
> I'm now consolidating my thoughts, and I've validated the purity extraction in the codebase, finding that it adheres to "Functional Core, Imperative Shell" as expected. The pure functions show no Firestore dependencies or side effects, making them testable. `calculateSlots` and `createHold` act as the Application Service layer, which I conclude is a clean approach.
>
> **Clarifying Trade-offs**
>
> I'm now highlighting a trade-off: `createHold` and `resolveHoldAllocation` throw `HttpsError`, an HTTP-specific concern, in the domain layer. While not ideal in strict DDD, it's a pragmatic choice for the current setup, especially with a global error handler. I'm focusing on why this is acceptable in the current context, and also pointing out a potential concern if the system expands to non-HTTP interfaces. I'm satisfied with the clarity of the functional boundary.

</details>

Based on the provided codebase, your extraction of `buildAvailabilityContext()`, `calculateSlotsFromContext()`, and `resolveHoldAllocation()` into pure functions is an excellent architectural decision. You have successfully implemented the **"Functional Core, Imperative Shell"** pattern.

Here is my critique of your current boundaries and whether you need further separation.

### 1. The Current Boundary is Highly Effective

Your current boundary is very clean. By looking at `src/core/bookings/calculator.ts` and `src/core/bookings/hold.ts`, we can see a strict separation of concerns [1]:

- **The Functional Core (Domain Layer):** Your pure functions take in plain data structures (`AvailabilityContext`), perform complex "Time Tetris" and allocation logic, and return plain results without any side effects or database dependencies [1]. This makes your most critical business rules 100% deterministically testable, as evidenced by your extensive unit tests in `tests/core/` [1].
- **The Imperative Shell (Orchestrator Layer):** Functions like `calculateSlots` and `createHold` handle the messy reality of the system: fetching data via `fetchAvailabilityData`, managing Firestore transactions, and persisting the results [1].

### 2. Do you need a separate "Service Layer"?

**No, you do not need to add another layer of abstraction.**

In your current architecture, `calculateSlots` and `createHold` _are_ your Application Service Layer. They act as the exact bridge between your transport layer (the Hono HTTP routes in `src/routes/appointments.ts`) and your Domain Layer (the pure functions) [1].

If you were to extract a "Service Layer" out of these orchestrators, you would likely end up with "Lasagna Architecture" (unnecessary layers of indirection that just pass data back and forth without adding value). Your Hono routes correctly parse the HTTP requests and immediately hand off to the orchestrators [1], which is the ideal flow for a modern, maintainable microservice.

### 3. One Minor Architectural Leak to Watch Out For

While your boundary is generally excellent, drawing upon strict Domain-Driven Design (DDD) principles, there is one minor leak in your current implementation: **HTTP concerns are leaking into your pure domain functions.**

In `src/core/bookings/hold.ts`, your pure function `resolveHoldAllocation()` throws `HttpsError` (e.g., `throw new HttpsError("failed-precondition", ...)`), which carries HTTP status code mappings [1].

**The Trade-off:**

- **Strict DDD:** Pure domain logic should have absolutely no knowledge of the transport layer (HTTP, gRPC, CLI). It should throw generic domain errors (e.g., `SlotUnavailableError`). The routing layer or a global error handler should then catch `SlotUnavailableError` and translate it to an HTTP 400 or 409.
- **Your Pragmatic Approach:** By throwing `HttpsError` directly in the domain and letting your global `errorHandler` middleware in `src/middleware/error-handler.ts` catch it [1], you save boilerplate.

**Recommendation:** For a Cloud Run microservice strictly serving HTTP traffic, your current pragmatic approach is perfectly fine and highly productive. However, if MercuryEngine ever needs to process holds via a non-HTTP background worker (like a Pub/Sub queue for the Ticketing domain you have planned [1]), those workers will be catching HTTP errors, which is semantically incorrect. If that happens, you should refactor your pure functions to throw standard custom `Error` classes, and let the orchestrator or middleware map them to `HttpsError`.

**Summary:** Your pure function boundary is clean, highly testable, and well-designed. Keep `calculateSlots` and `createHold` as your Application Service layer, and avoid adding further abstraction unless your transport requirements drastically change.
