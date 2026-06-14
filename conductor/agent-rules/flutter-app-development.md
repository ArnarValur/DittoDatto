# Flutter App Development — Agent Rules

> Source: *Flutter App Development: How to Write for iOS and Android at Once* — Rap Payne
> Distilled for the DittoDatto monorepo (multi-app workspace with `ditto_design` + `mercury_client` shared packages).

---

## 1. Widget Composition

- **Prefer `StatelessWidget` by default.** Only promote to `StatefulWidget` when mutable state triggers re-renders.
- **Decompose aggressively.** Break complex UI into small, single-responsibility widgets. No monolithic build methods.
- **One widget per file.** Each custom widget class lives in its own `.dart` file.
- **Use `const` constructors** on literal widgets (`const Text('Hello')`) — compile-time optimization.
- **Pass data via named constructor parameters.** Widget properties must be `final`.
- **Formula: `Scene = f(Data)`.** As data changes, `build()` re-renders predictably.

---

## 2. State Management (Riverpod)

- **All state mutations inside `setState(() { ... })`** for StatefulWidget — never mutate outside it.
- **Never make the `setState()` callback async** — causes runtime assertion errors.
- **One-way data flow:** data flows DOWN via constructors, UP via callback functions.
- **Riverpod is the DittoDatto standard** (already in all apps):
  - `ProviderScope` wraps root app.
  - `ref.watch()` for reactive rebuilds; `ref.read()` for one-time reads.
  - Extend `ConsumerStatefulWidget` / `ConsumerState` when combining local + shared state.
- **Decision test:** Does the data change? → Does the change affect UI? → Then it's state.

---

## 3. Theming & Styling

- **Flutter styles do NOT cascade like CSS.** Setting a font on a parent does NOT affect children. Use `ThemeData` instead.
- **All styling goes through `ditto_design` package** — never inline ad-hoc styles in app code.
- **`ColorScheme.fromSeed()` for Material 3** — never `fromSwatch()`.
- **`.copyWith()` pattern** for incremental style overrides everywhere.
- **Hex colors: `Color(0xFFRRGGBB)`** — always include `FF` alpha prefix or color will be invisible.
- **Never set `color` on a Container AND its `BoxDecoration`** — move color into the `BoxDecoration`.
- **Dark mode:** set both `theme` (light) and `darkTheme` on `MaterialApp`.

> **DittoDatto note:** Theme is centralized in `packages/ditto_design/lib/src/theme/ditto_theme.dart`. Tokens (colors, spacing, border radius, animation) live in `ditto_design/lib/src/tokens/`. Apps import `package:ditto_design/ditto_design.dart`.

---

## 4. Layout Strategy (5-Step)

1. **Scene structure:** `MaterialApp` → `Scaffold` (appBar, body, drawer, FAB, bottomSheet) — all parts optional.
2. **Position widgets:** `Row` (horizontal), `Column` (vertical) — nest freely.
3. **Fix overflows:** `Wrap`, `Flexible`, `SingleChildScrollView`, `ListView`, `GridView`.
4. **Fill extra space:** `mainAxisAlignment`, `crossAxisAlignment`, `Expanded`, `Spacer`, `SizedBox`.
5. **Fine-tune:** `Container`, `Padding`, `Align`, `Center`.

### Critical Layout Rules

- **Always wrap body content in `SafeArea`** — avoids notches, status bars, rounded corners.
- **`ListView` over `SingleChildScrollView`** for large/infinite lists — only builds visible items.
- **`ListView.builder`** for dynamic data from APIs/databases.
- **`GridView.extent()`** (max width, auto columns) over `GridView.count()` (fixed columns) for responsive grids.
- **`Expanded` wraps children in Row/Column** to fill remaining space. Use `flex` for proportional distribution.
- **`Spacer`** for proportional gaps, **`SizedBox`** for fixed pixel gaps.
- **Avoid explicit `width`/`height` on Containers** — let widgets size themselves.
- **Container without alignment** shrinks to fit child. **With alignment**, grows greedily.
- **Responsive:** Use `Flex` + `MediaQuery.orientationOf(context)` to swap Row/Column by orientation.

### Unbounded Height Error

- Greedy widgets (`ListView`, `GridView`) inside unconstrained parents (`Column`) → infinite height → crash.
- **Fix: Wrap in `Expanded`** (or `SizedBox` / `LimitedBox`).

---

## 5. Navigation

- **DittoDatto uses GoRouter** (not vanilla Navigator) — but the principles apply:
  - Named routes are self-documenting.
  - Don't mix more than 2 nav types (tabs + stack is the standard pattern).
  - `Navigator.pop(context, value)` returns data from popped routes.
- **Drawers:** extract into own widget for reuse across screens.
- **Tabs:** require `DefaultTabController(length: N)` — tab count must match `TabBarView` children count.

---

## 6. API Calls & HTTP

- **DittoDatto uses `mercury_client` for all HTTP** — never raw `http` package in app code.
- **Use `FutureBuilder` for rendering async data:**
  - Always check `snapshot.connectionState`, `snapshot.hasError`, `snapshot.hasData` before `.data`.
  - Show `CircularProgressIndicator()` while waiting.
  - Check `response.statusCode` — 400/500 responses are valid HTTP but contain no useful data.
- **Use `StreamBuilder` for real-time/streaming data** (SurrealDB Live Queries).
- **Typed deserialization:** business classes with `fromJson()` / `toJson()` — centralized in models, never inline.

---

## 7. Forms & Input

- **`TextFormField` inside `Form`** (not bare `TextField`) — gives `onSaved` + `validator`.
- **Forms need `GlobalKey<FormState>`.** Call `validate()` before `save()`.
- **Validator returns `null` for valid**, error message string for invalid.
- **`GestureDetector`** wraps any widget for custom gestures.
- **`Dismissible`** for swipe-to-dismiss.

---

## 8. Dart Conventions

- **`final` by default** for variables. `const` for compile-time constants.
- **Null safety:** `?` nullable, `??` fallback, `?.` null-safe access. Use `!` only when certain.
- **`=>` (fat arrow)** for single-expression functions.
- **Named parameters with `{}`** in function signatures.
- **Omit `new` keyword.** Omit `this.` inside class bodies.
- **Private members start with `_`**.
- **No method overloading** — use named constructors (`Person.byName()`, `Person.byId()`).

---

## 9. Async Patterns

- **Dart is single-threaded** with an event loop.
- **`build()` cannot be async** — steer async work into event handlers or providers.
- Any function using `await` must be marked `async` and returns `Future<T>`.
- Handle futures with `await` (preferred) or `.then()`.

---

## 10. Debug Layout

- Toggle debug paint: VS Code → Command Palette → "Flutter: Toggle debug painting"
- **Teal borders** = widget boxes | **Blue** = padding/margin | **Yellow arrows** = alignment | **Green arrows** = scrollable regions
- **Yellow-black stripes** = overflow warning (debug only, clipped in production).

---

## 11. Shared Packages (DittoDatto Monorepo)

- **`ditto_design`** = shared design system (tokens, theme, layout shells, utility widgets). The equivalent of a Nuxt `~/shared/components/` directory.
- **`mercury_client`** = shared API client (HTTP, auth, models). The equivalent of Nuxt `~/shared/composables/` + `~/shared/api/`.
- Apps depend on packages via `path:` in `pubspec.yaml`. Root `pubspec.yaml` workspace resolution ties it all together.
- **Any widget, token, or utility used by 2+ apps → goes into a shared package.**
- **App-specific widgets stay in the app's `lib/` directory.**
