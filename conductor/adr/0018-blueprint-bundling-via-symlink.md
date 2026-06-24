# Blueprint Bundling via Symlink

> **Recorded:** 2026-06-24 14:03
> **Status:** accepted

## Context

The company blueprint schema (`company-blueprint.surql`, ~540 lines, 18 tables + relations) exists in two locations: `schemas/company-blueprint.surql` (source of truth for seed scripts and migrations) and `apps/admin/assets/company-blueprint.surql` (runtime copy loaded by Admin Panel via `rootBundle.loadString()`). Keeping these in sync manually has already caused a bug (path escape attempt with `../../`), and any schema update requires remembering to copy the file.

## Decision

Replace the copy at `apps/admin/assets/company-blueprint.surql` with a symlink pointing to `../../schemas/company-blueprint.surql`. Flutter's asset bundler follows symlinks, so the build pipeline requires no changes. Single source of truth, zero sync risk.

## Consequences

- Schema edits are made in one place (`schemas/company-blueprint.surql`) and automatically reflected in Admin Panel builds.
- Works on Linux and macOS (both development platforms). Windows developers would need to use `mklink` or WSL, but no Windows development is currently planned.
- The `pubspec.yaml` asset declaration remains unchanged — Flutter resolves the symlink at build time.
