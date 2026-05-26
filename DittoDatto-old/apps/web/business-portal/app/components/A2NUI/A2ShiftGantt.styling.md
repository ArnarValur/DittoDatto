# A2ShiftGantt — Styling Reference

> **Component:** `app/components/A2NUI/A2ShiftGantt.vue`  
> **Stylesheet:** `app/assets/css/a2nui-gantt.css`  
> **Architecture:** `Obsidian_Vault/Projects/DittoDatto/Architecture/a2nui-gantt-shift-planner.md`

---

## How Colors Work — Two Layers

### Layer 1: Mermaid Theme Variables (Script)

`getThemeConfig()` returns a `themeVariables` object based on `useColorMode()`. Mermaid **bakes these into the SVG** as inline `fill`, `stroke`, and `style` attributes at render time.

| Variable             | Dark Value | Light Value | Controls                     |
| -------------------- | ---------- | ----------- | ---------------------------- |
| `background`         | `#0f172a`  | `#ffffff`   | SVG canvas                   |
| `sectionBkgColor`    | `#1e293b`  | `#f8fafc`   | Row backgrounds              |
| `taskBkgColor`       | `#4f46e5`  | `#6366f1`   | Default bar fill (scheduled) |
| `activeTaskBkgColor` | `#166534`  | `#22c55e`   | Confirmed bar fill           |
| `critBkgColor`       | `#92400e`  | `#f59e0b`   | Swap-requested bar fill      |
| `doneTaskBkgColor`   | `#334155`  | `#cbd5e1`   | Cancelled bar fill           |
| `titleColor`         | `#e2e8f0`  | `#0f172a`   | Chart title text             |
| `gridColor`          | `#334155`  | `#e2e8f0`   | Vertical grid lines          |

**To change bar colors:** Edit `getThemeConfig()` in the `.vue` file.  
**Chart re-renders** automatically when color mode changes.

### Layer 2: CSS Overrides (Stylesheet)

`a2nui-gantt.css` targets mermaid's generated SVG classes with `!important` to refine what mermaid bakes in. Uses `.dark` ancestor selector for dark mode.

#### Key CSS Selectors

| Selector                             | What it styles                             | Tweak for                             |
| ------------------------------------ | ------------------------------------------ | ------------------------------------- |
| `.gantt-chart`                       | Chart container bg, padding, border-radius | Container look                        |
| `.gantt-chart .titleText`            | Chart title                                | Font size, weight, color              |
| `.gantt-chart .sectionTitle`         | Staff name labels (left side)              | Font, uppercase, spacing              |
| `.gantt-chart .tick text`            | Time axis labels (bottom)                  | Font size, color                      |
| `.gantt-chart .grid .tick line`      | Vertical grid lines                        | Stroke color, opacity                 |
| `.gantt-chart rect.section0/1`       | Alternating row backgrounds                | Fill color per mode                   |
| `.gantt-chart .task rect`            | Shift bar rectangles                       | `rx`/`ry` (corner radius), hover glow |
| `.gantt-chart .taskText`             | Text inside bars                           | Fill color, size, weight              |
| `.gantt-chart .taskTextOutsideRight` | Text that overflows bar right              | Color, size                           |
| `.gantt-chart .today`                | Today marker line                          | Stroke, dash pattern                  |

#### Mermaid Gantt Config (Script)

These control layout spacing — not colors:

```
gantt: {
  barHeight: 24,      // Height of each shift bar (px)
  barGap: 4,          // Gap between bars in same section
  topPadding: 40,     // Space above first row
  leftPadding: 100,   // Space for staff name labels
  gridLineStartPadding: 20,
  fontSize: 12,
  sectionFontSize: 13
}
```

**To tighten rows:** Reduce `barHeight` and `barGap`.  
**To widen staff labels:** Increase `leftPadding`.

---

## Status → Visual Mapping

| Shift Status    | Mermaid Tag | Bar Color (dark) | Bar Color (light) | CSS Class              |
| --------------- | ----------- | ---------------- | ----------------- | ---------------------- |
| `scheduled`     | _(none)_    | Indigo `#4f46e5` | Indigo `#6366f1`  | `.task`                |
| `confirmed`     | `active`    | Green `#166534`  | Green `#22c55e`   | `.taskText.activeText` |
| `swapRequested` | `crit`      | Amber `#92400e`  | Amber `#f59e0b`   | `.crit`                |
| `cancelled`     | `done`      | Slate `#334155`  | Grey `#cbd5e1`    | `.done`                |

---

## Interactive Features

| Feature               | How                                               | Where        |
| --------------------- | ------------------------------------------------- | ------------ |
| **Hover tooltip**     | `@mousemove` on `.gantt-chart` → `.gantt-tooltip` | Script + CSS |
| **Click shift bar**   | `@click` → emits `shift-click` event              | Script       |
| **Expand lightbox**   | `.gantt-expand-btn` → `UModal`                    | Template     |
| **Color mode switch** | `watch(colorMode)` → `renderChart()`              | Script       |

---

## Quick Doodle Guide

**Want to change bar corner radius?**
→ `a2nui-gantt.css` → `.gantt-chart .task rect` → `rx` / `ry`

**Want to change hover glow?**
→ `a2nui-gantt.css` → `.gantt-chart .task:hover rect` → `filter`

**Want to change tooltip look?**
→ `a2nui-gantt.css` → `.gantt-tooltip` (light) + `.dark .gantt-tooltip` (dark)

**Want to change row spacing?**
→ `A2ShiftGantt.vue` → `gantt: { barHeight, barGap, topPadding }`

**Want to change bar colors?**
→ `A2ShiftGantt.vue` → `getThemeConfig()` → `themeVariables`
