# Architecture

## System Overview

A2NUI implements a three-layer architecture that separates concerns cleanly:

```
┌─────────────────────────────────────────────────────────┐
│                    Playground / App                       │
│  ┌────────┐   ┌────────┐   ┌──────────┐                │
│  │  Chat  │   │ Paste  │   │ Inspect  │                 │
│  └───┬────┘   └───┬────┘   └────┬─────┘                │
│      │            │              │                       │
│      └────────────┴──────────────┘                       │
│                    │                                     │
│  ┌─────────────────▼─────────────────┐                  │
│  │     useA2uiSurface (composable)    │  ◄── Reactivity │
│  │  • Vue ref<Map> of surfaces        │                  │
│  │  • feed() / clear() / getSurface() │                  │
│  └─────────────────┬─────────────────┘                  │
│                    │                                     │
│  ┌─────────────────▼─────────────────┐                  │
│  │     processor.ts (pure logic)      │  ◄── No Vue deps│
│  │  • parseJsonl()                    │                  │
│  │  • processMessage()                │                  │
│  │  • rebuildTree()                   │                  │
│  │  • resolveBindings()               │                  │
│  └─────────────────┬─────────────────┘                  │
│                    │                                     │
│  ┌─────────────────▼─────────────────┐                  │
│  │     Renderer (Vue components)      │  ◄── Nuxt UI    │
│  │  • Renderer.vue → Node.vue         │                  │
│  │  • Node.vue → Text / Button / ...  │                  │
│  └───────────────────────────────────┘                  │
└─────────────────────────────────────────────────────────┘
```

## Data Flow

### 1. JSONL Ingestion

All A2UI input enters as newline-delimited JSON (JSONL). Each line is an **envelope**:

```jsonl
{"version":"v0.10","createSurface":{"surfaceId":"demo","catalogId":"standard"}}
{"version":"v0.10","updateComponents":{"surfaceId":"demo","components":[...]}}
```

### 2. Message Processing (`processor.ts`)

The processor is **framework-agnostic** — pure TypeScript with no Vue imports. It handles four message types:

| Message Type       | Action                                     |
| ------------------ | ------------------------------------------ |
| `createSurface`    | Creates a new surface entry in the Map     |
| `updateComponents` | Upserts flat component list, rebuilds tree |
| `updateDataModel`  | Merges data into surface's data model      |
| `deleteSurface`    | Removes surface from the Map               |

After `updateComponents`, the processor runs `rebuildTree()` which converts the flat component array into a nested `ResolvedNode` tree by resolving `children` references.

### 3. Reactivity Layer (`useA2uiSurface.ts`)

The composable wraps the processor with Vue reactivity:

```ts
const surfaces = ref(new Map<string, Surface>());

function feed(jsonl: string) {
  for (const msg of parseJsonl(jsonl)) {
    processMessage(surfaces.value, msg);
  }
  triggerRef(surfaces); // Force Vue to re-render
}
```

### 4. Rendering (`Renderer.vue` → `Node.vue` → catalog)

```
Renderer.vue
  └── receives Surface, reads rootNode
       └── Node.vue (recursive)
            └── resolves type → explicit import map
                 ├── Text.vue     → <h1>-<h5>, <p>, <span>
                 ├── Button.vue   → <UButton>
                 ├── TextField.vue → <UInput> / <UTextarea>
                 ├── CheckBox.vue → <UCheckbox>
                 ├── Image.vue    → <img>
                 ├── Icon.vue     → <UIcon>
                 ├── Row.vue      → flex-row → recursive Node
                 ├── Column.vue   → flex-col → recursive Node
                 ├── Card.vue     → <UCard> → recursive Node
                 ├── Divider.vue  → <USeparator>
                 ├── Tabs.vue     → <UTabs> → recursive Node
                 └── Fallback.vue → debug display
```

**Key design decision**: `Node.vue` uses explicit imports instead of `resolveComponent()` because Nuxt's auto-imported components don't resolve dynamically at runtime via string names.

## File Structure

```
app/
├── components/a2ui/
│   ├── Node.vue          # Dynamic type resolver (explicit imports)
│   ├── Renderer.vue      # Root surface renderer
│   ├── Text.vue          # Text/heading component
│   ├── Button.vue        # Button with variant mapping
│   ├── TextField.vue     # Input/textarea with label
│   ├── CheckBox.vue      # Checkbox toggle
│   ├── Image.vue         # Image display
│   ├── Icon.vue          # Icon via UIcon
│   ├── Row.vue           # Horizontal flex layout
│   ├── Column.vue        # Vertical flex layout
│   ├── Card.vue          # Card container
│   ├── Divider.vue       # Horizontal separator
│   ├── Tabs.vue          # Tabbed content
│   └── Fallback.vue      # Unknown type debugger
├── composables/
│   └── useA2uiSurface.ts # Vue reactive wrapper
├── pages/
│   └── playground.vue    # 3-tab playground (Chat/Paste/Inspect)
└── utils/a2ui/
    ├── types.ts           # TypeScript interfaces
    └── processor.ts       # Framework-agnostic processor

server/
└── api/a2ui/
    └── chat.post.ts       # Gemini API → A2UI JSONL via SSE
```

## Server Route Architecture

The `chat.post.ts` endpoint:

1. Receives chat messages from the client
2. Prepends a detailed **system prompt** instructing Gemini to respond in A2UI v0.10 JSONL
3. Calls the Gemini API with streaming enabled
4. Forwards text chunks as SSE `data:` events to the client
5. Client processes SSE, feeds each complete JSONL line to the processor

```
Client                    Server                    Gemini
  │                         │                         │
  │── POST /api/a2ui/chat ──▶│                         │
  │                         │── generateContentStream ─▶│
  │                         │◀── text chunks ──────────│
  │◀── SSE data: {...} ────│                         │
  │◀── SSE data: {...} ────│                         │
  │◀── SSE data: [DONE] ───│                         │
  │                         │                         │
  ▼ feed() each line        │                         │
  ▼ processMessage()        │                         │
  ▼ render()                │                         │
```
