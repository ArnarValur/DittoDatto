# Conductor to Obsidian Vault Sync Specification

This document specifications the structure and mapping used by the **ConductorGraph** agent to transform local `/conductor` metadata into a highly linked Obsidian Vault at `/home/solmundur/Documents/DittoDatto-Vault`.

---

## 🎯 Target Vault Map

The synchronizer processes the raw markdown and JSON declarations in `/conductor` and sculpts the following folders and files in the vault:

| Conductor Source | Vault Target | Formatting & Link Strategy |
| :--- | :--- | :--- |
| `conductor/tracks.md` | `DittoDatto Graph.md` | Unified Canvas/Graph Index linking active work packages. |
| `conductor/context.md` | `Domain Glossary.md` | Fully cross-referenced dictionary of ubiquitous domain terms. |
| `conductor/adr/` | `Decisions/` | ADR mapping with frontmatter extraction and state labels. |
| `conductor/tracks/` | `Tracks/` | Active tracks containing checklist tracking, phase maps, and metadata. |
| `conductor/docs/` | `Identity/`, `Entities/`, `State/` | Extracted structural architecture notes. |

---

## 🔄 Reactive Synchronization

The background daemon operates in two distinct phases:

1. **Baseline Initialization:** When started, it performs a complete synchronous scan to establish all nodes and clean up any dangling references.
2. **Reactive Watch Mode:** Utilizes file-system watches (`watchfiles` or reactive AG trigger policies). Every time a file is saved in the `/conductor` workspace, the synchronizer triggers a partial compilation, updating the vault instantly.
