# A2NUI — A2UI Protocol for Nuxt

> A Nuxt 4 / Vue 3 implementation of the [A2UI protocol](https://github.com/anthropics/a2ui) (v0.10), enabling AI agents to generate and stream native UI components in real-time.

## Documentation Index

| Document                                        | Description                                      |
| ----------------------------------------------- | ------------------------------------------------ |
| [Architecture](./architecture.md)               | System overview, data flow, and component map    |
| [Getting Started](./getting-started.md)         | Setup, configuration, and running the playground |
| [Roadmap](./roadmap.md)                         | Next steps, suggestions, and future plans        |
| [Use Cases](./use-cases.md)                     | Real-world application examples                  |
| [AI Dashboard Vision](./ai-dashboard-vision.md) | The AI-powered Business Portal dashboard concept |

## Quick Start

```bash
# Install dependencies
pnpm install

# Set your Gemini API key
cp .env.example .env
# Edit .env and add your GEMINI_API_KEY

# Run the playground
NUXT_PORT=3003 pnpm dev

# Open http://localhost:3003/playground
```

## What is A2UI?

A2UI (Agent-to-UI) is a JSONL-based streaming protocol that allows AI models to generate platform-agnostic UI definitions. Instead of returning markdown or HTML, the AI returns structured component descriptions that get rendered using the host platform's native widget set.

**Key insight**: The AI doesn't need to know about CSS, Tailwind, or Nuxt UI internals. It just says "give me a Text with variant h2" and the renderer handles the rest.

## Session History

- **2026-02-13**: Initial implementation — processor, renderer, 11 catalog components, Gemini API integration, playground with Chat/Paste/Inspect tabs. Full end-to-end streaming working.
