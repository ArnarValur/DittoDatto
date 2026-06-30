# Discovery Service as Shared Dart Package

> **Recorded:** 2026-06-30 20:15
> **Status:** accepted

All discovery read/write logic lives in `packages/discovery_service/`. The package contains: `DiscoveryRepository` (reads listings, categories, areas from `companies/discovery`), `ListingSyncService` (writes `establishment_listing` on publish), and Dart models (`EstablishmentListing`, `DiscoveryCategory`, `DiscoveryArea`). Consumed by Marketplace (reads) and Business Portal (writes on publish). Follows the established shared-package pattern (`ditto_auth`, `establishment_ui`, `booking_ui`).

## Considered Options

- **Inline in each app** — BP sync logic + Marketplace query logic written independently. Rejected: duplicated models, no shared contract.
- **Part of `mercury_client`** — extend the existing client package. Rejected: `mercury_client` is already heavy and discovery has no relation to the MercuryEngine HTTP API.
