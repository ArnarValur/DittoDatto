# Dynamic Resource Modes - Future Feature

## Concept
Allow Admin Panel to configure resource modes dynamically without code changes.

## Admin Panel UI
`Settings > Resource Modes`

| Mode | Icon | Fields | Description |
|------|------|--------|-------------|
| pool | 🪑 | capacity | Capacity-based (restaurants) |
| staff | 👤 | schedule | Per-person scheduling |
| asset | 🔧 | name, count | Physical resources (bays, rooms) |
| *+ Add New* | | | |

## Firestore Structure
```
/config/resourceModes
├── pool: { icon, label, fields: [...] }
├── staff: { icon, label, fields: [...] }
└── asset: { icon, label, fields: [...] }
```

## Benefits
- Add new modes without code changes
- Datto queries this config to understand available types
- Business Portal dynamically renders the right UI based on mode schema

## Complexity
Medium—requires dynamic form rendering based on mode schema.

## Priority
Low - future enhancement for scaling to different industries.
