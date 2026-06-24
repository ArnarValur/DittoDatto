# Anonymous Browsing by Default

> **Recorded:** 2026-06-24 19:17
> **Status:** accepted

The Public Marketplace allows unauthenticated users to browse discovery listings and EstablishmentPages without creating an account. Authentication is required only for booking, favorites, and profile access. This means most routes are public — auth guards apply only to action-gated screens. Discovery DB connection auth (how anonymous clients read `companies/discovery` and `company_{slug}`) is deferred to a future grill session.

## Consequences

- Router structure: most routes are unguarded. Auth redirect only on booking/favorites/profile.
- SearchEvent attribution for anonymous users must remain PII-free (aligns with GDPR constraint in project-context).
- Discovery DB connection auth becomes a separate architectural decision when the Home/DittoBar screens are built.
