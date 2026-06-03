---
description: DittoDatto Grapher — Smart consolidated panel to manage all Conductor-to-Obsidian graph synchronizers in this project (Parent Core and Child Services)
---

# 📊 Multi-Conductor Grapher Control Panel

This consolidated workflow manages all **ConductorGraph** watchers in the DittoDatto ecosystem, including the Parent Core and all Child Service conductors.

---

## Step 1: Discover and Audit Conductors

Scan the active workspace to locate all `conductor/` directories. For each, verify if it is valid (contains the 4 required files: `project-context.md`, `tracks.md`, `pulse.md`, and `workflow.md`) and check its current daemon status:

| Project Target | Conductor Path | Status Check | Target Vault |
| :--- | :--- | :--- | :--- |
| **DittoDatto Core** | `conductor/` | `pgrep -fl "main.py.*target /home/solmundur/Projects/DittoDatto "` | `Documents/DittoDatto-Vault/` |
| **MercuryEngine** | `services/mercury-engine/conductor/` | `pgrep -fl "main.py.*mercury-engine"` | `Documents/mercury-engine-Vault/` |
| **SearchAnalytics** | `services/search-analytics/conductor/` | `pgrep -fl "main.py.*search-analytics"` | `Documents/search-analytics-Vault/` |

---

## Step 2: Auto-Detect Active Target

Determine the intended project target by checking:

1. **User Input:** Did the user mention a specific service in their slash command or message? (e.g., `/grapher mercury`, `/grapher engine`, `/grapher core`).
2. **Editor Context:** Does the user have a file open in a child project directory (e.g., inside `services/mercury-engine`)?
3. **If Ambiguous:** Present a status dashboard of all discovered conductors and ask the user to select their target.

---

## Step 3: Present Operations

For the resolved target, present its current status and offer the following options:

| Option | Action | Description |
| :--- | :--- | :--- |
| **Start Watcher** | Launch in background | Starts the reactive watcher daemon for the target conductor. |
| **Stop Watcher** | Terminate process | Safely stops the running synchronizer for the target. |
| **Check Logs** | Display logs | Shows the latest synchronizer updates and active vault status. |

---

## Step 4: Execution Instructions

Depending on the selected target, execute the following commands:

### A. Start Watcher

```bash
# For DittoDatto Core
OBSIDIAN_VAULT_LIBRARIES=/home/solmundur/Documents nohup /home/solmundur/Hermes/AgentPollux/.venv/bin/python /home/solmundur/Hermes/AgentPollux/src/main.py --target /home/solmundur/Projects/DittoDatto --watch > /tmp/ditto-grapher.log 2>&1 &

# For MercuryEngine
OBSIDIAN_VAULT_LIBRARIES=/home/solmundur/Documents nohup /home/solmundur/Hermes/AgentPollux/.venv/bin/python /home/solmundur/Hermes/AgentPollux/src/main.py --target /home/solmundur/Projects/DittoDatto/services/mercury-engine --watch > /tmp/mercury-engine-grapher.log 2>&1 &

# For SearchAnalytics
OBSIDIAN_VAULT_LIBRARIES=/home/solmundur/Documents nohup /home/solmundur/Hermes/AgentPollux/.venv/bin/python /home/solmundur/Hermes/AgentPollux/src/main.py --target /home/solmundur/Projects/DittoDatto/services/search-analytics --watch > /tmp/search-analytics-grapher.log 2>&1 &
```

### B. Stop Watcher

```bash
# For DittoDatto Core
pkill -f "AgentPollux/src/main.py.*Projects/DittoDatto\b"

# For MercuryEngine
pkill -f "AgentPollux/src/main.py.*mercury-engine"

# For SearchAnalytics
pkill -f "AgentPollux/src/main.py.*search-analytics"
```

### C. Check Logs

Display the last 15 lines of the active log file:

- **DittoDatto Core:** `tail -n 15 /tmp/ditto-grapher.log`
- **MercuryEngine:** `tail -n 15 /tmp/mercury-engine-grapher.log`
- **SearchAnalytics:** `tail -n 15 /tmp/search-analytics-grapher.log`
