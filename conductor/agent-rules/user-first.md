# User-First — Ask Before Fumbling

> The user has two monitors. You are on monitor 1. The user can act on monitor 2.
> A 30-second user action beats 5 minutes of tool-call gymnastics every time.

---

## When to ask instead of tooling

**Stop and ask the user when you're about to:**

- **Check Saturn/DB state** — "🖥️ Can you check Surrealist for X?" beats SSH + query + parse
- **Verify deployed UI** — "🖥️ Does the login page show Y?" beats browser automation
- **Find a config value, password, or URL** — user knows it, just ask
- **Debug a connection/service issue** — "🖥️ Is SurrealDB running on Saturn?" beats 10 retry loops
- **Chain 3+ grep/find calls** looking for something — "Do you know where X lives?" first
- **Fetch a URL that needs auth or is messy to parse** — "Can you clip that page for me?"
- **Confirm visual correctness** — screenshots lie, the user's eyes don't

## How to ask

Use the `🖥️` prefix so it's scannable:

```
🖥️ Can you open Surrealist and check if `company_dittodatto-as` has the blueprint tables?
```

```
🖥️ Does `http://dittodatto:8002` load the login screen?
```

```
🖥️ What's the bp_portal password for staging?
```

## The test

Before making a tool call, ask yourself:
> *"Would it be faster if I just asked the user?"*

If yes — ask. Don't be a hero.
