# Media Manager as Shared Package with Abstract Storage Backend

> **Recorded:** 2026-06-26 14:17
> **Status:** accepted

Media management is extracted from `apps/business-portal/lib/features/media/` into a shared Dart package at `packages/media_manager/`. The package owns the data model (`MediaItem`, `MediaCategory`), repository methods (fetch, create, delete via `TenantConnection`), and reusable UI widgets: `MediaGalleryPage` (standalone full-page gallery), `MediaPickerWidget` (inline form picker with configurable `maxSelection`), and a modal gallery picker (opened from the inline widget, category-filtered by default).

Storage is abstracted behind a `MediaStorageBackend` interface (upload, delete, getUrl). Firebase Storage remains the PoC implementation; a European-sovereign backend will replace it without package changes. Each consuming app provides its concrete storage impl via dependency injection (Riverpod).

## Considered Options

- **Keep media code in BP, extract later** — lower upfront cost, but the second consumer (establishment edit, then Admin Panel, then Marketplace) was already identified. Extracting later means migrating dependents.
- **Widget-only package** — extract just the picker widget, leave data layer in BP. Rejected: splits ownership of a single concern across two locations.
- **Package with embedded providers** — Riverpod providers inside the package. Rejected: couples the package to the consuming app's DI wiring.

## Consequences

- All Flutter apps (BP, Admin Panel, Marketplace) can import media management with zero duplication.
- The storage backend swap (Firebase → European S3-compatible) requires writing one new class, not touching any UI code.
- The package boundary is a commitment — breaking changes affect all consumers.
- Follows the established pattern: `ditto_auth` (auth), `establishment_ui` (establishment display), `mercury_client` (HTTP + models), `media_manager` (media CRUD + UI).
