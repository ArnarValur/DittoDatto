# Spec: Media Manager Shared Package

## Overview

The Business Portal's media management code (~1,288 lines across 3 files) is tightly coupled to BP. Per ADR-0021, media management needs to be a shared Dart package at `packages/media_manager/` — reusable by BP, Admin Panel, and Marketplace. This track extracts the existing code, refactors it into a clean architecture (repository + storage abstraction + reusable widgets), and wires BP to import from the package.
