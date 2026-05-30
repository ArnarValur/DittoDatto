# ConductorGraph Sidecar Integration Spec

This document details the configuration and operational lifecycle of the background ConductorGraph synchronizer for the **DittoDatto** project.

---

## 🛠️ The Native AG 2.0 Sidecar

The DittoDatto ConductorGraph agent runs as a native Antigravity 2.0 Sidecar process. It is managed automatically by the Antigravity desktop application.

### Sidecar Configuration

- **Location:** `~/.gemini/config/sidecars/ditto-datto-grapher/sidecar.json`
- **Enabled Status:** Globally enabled in `~/.gemini/config/config.json` via `"sidecars": { "enabled": true }`.
- **Target Folder:** `/home/solmundur/Projects/DittoDatto/`
- **Output Vault:** `/home/solmundur/Documents/DittoDatto-Vault/`

### Execution Details

- **Interpreter:** `/home/solmundur/Hermes/conductor-graph/.venv/bin/python`
- **Script:** `/home/solmundur/Hermes/conductor-graph/src/main.py`
- **Arguments:** `--target /home/solmundur/Projects/DittoDatto --watch`
- **Environment Overrides:** `OBSIDIAN_VAULT_LIBRARIES=/home/solmundur/Documents`
- **Restart Policy:** `always` (the platform automatically revives the watcher if it crashes or the system reboots).

---

## ⚡ The `/grapher` Workspace Workflow (Consolidated)

To give you hands-on, on-demand control over all watchers in the project (Parent Core and Child Services), a consolidated workspace workflow has been registered.

- **Slash Command:** `/grapher`
- **Definition File:** `file:///home/solmundur/Projects/DittoDatto/.agents/workflows/grapher.md`

### Consolidated Capabilities

When you run `/grapher` in your DittoDatto project chat, the agent automatically:

1. **Auto-Detects Target:** Evaluates if you have a file open in a child project folder (like `services/mercury-engine`), parses target arguments from your chat message (e.g. `/grapher mercury`), or defaults to displaying a status dashboard panel for all project conductors.
2. **Interactive Controls:** Lets you choose a specific conductor target to manage (DittoDatto Core, MercuryEngine, etc.).
3. **Operations:**
   - **Start Watcher:** Launches the watcher for the target, logging to its corresponding `/tmp/<target>-grapher.log`.
   - **Stop Watcher:** Safely kills the active target synchronizer process.
   - **Check Logs:** Displays the last 15 log lines for that target.
