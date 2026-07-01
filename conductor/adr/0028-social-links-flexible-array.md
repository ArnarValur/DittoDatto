# Social links: flexible array of {platform, url} objects

> **Recorded:** 2026-07-01 14:55
> **Status:** accepted

The hardcoded `social_links.fb`, `social_links.ig`, `social_links.x` fields on `establishment` were too rigid. Norwegian SMBs use a variety of platforms beyond Facebook, Instagram, and X — notably TikTok and Snapchat.

We replace the three hardcoded fields with a flexible `social_links` array of `{platform: string, url: string}` objects. Known platforms in v1 receive first-class treatment (dedicated icons + URL pattern validation): `facebook`, `instagram`, `snapchat`, `tiktok`. Unknown platforms are accepted with a generic link icon — the system is open-ended by design.

## Consequences

- Schema: drop `social_links.fb/ig/x` fields, redefine `social_links` as `TYPE option<array<object>>` with `platform` (string) and `url` (string) subfields.
- Dart models: new `SocialLink` class with `platform` and `url` fields.
- BP UI: social links editor with platform dropdown (known) + free-text URL field. "Add link" button for additional entries.
- Marketplace: display social link icons on EstablishmentPage. Known platforms → brand icon, unknown → generic link icon.
