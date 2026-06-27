# 📋 Media Manager — E2E Test Checklist

> **Target:** Business Portal on Saturn (`http://dittodatto:8003`)
> **Login:** Any BP user with company access

---

## 1. Upload

| # | Scenario | Expected | ✅ |
|---|----------|----------|----|
| 1.1 | Upload single image from Gallery V2 AppBar "Last opp" | Category picker dialog → file picker → progress bar → image appears in correct category row | ☐ |
| 1.2 | Upload multiple images at once | Progress shows "1/N", "2/N" etc → all appear in gallery | ☐ |
| 1.3 | Upload from category row "+" button | Skips category dialog → auto-assigns that category | ☐ |
| 1.4 | Upload from empty category placeholder | Dashed box clickable → file picker → image lands in that category | ☐ |
| 1.5 | Upload from inside picker modal | "Last opp" in picker → uploads → new image immediately selectable | ☐ |
| 1.6 | Upload oversized file (>10 MB) | Rejected with error banner | ☐ |
| 1.7 | Upload unsupported format (e.g. .gif, .pdf) | Rejected — file picker should filter, but verify | ☐ |
| 1.8 | Upload SVG | Accepts, thumbnail renders in gallery | ☐ |

---

## 2. Gallery Browsing (V2 — Category Rows)

| # | Scenario | Expected | ✅ |
|---|----------|----------|----|
| 2.1 | All 7 categories render as rows | Each category with items shows horizontal scroll row | ☐ |
| 2.2 | Empty categories show dashed placeholder | Clickable "upload" placeholder for categories with 0 items | ☐ |
| 2.3 | Search by filename | Rows filter to matching items only | ☐ |
| 2.4 | Search by tag | Items tagged with search term appear | ☐ |
| 2.5 | Search with no results | "Ingen treff" empty state | ☐ |
| 2.6 | Clear search | All items reappear | ☐ |
| 2.7 | Horizontal scroll on category row | Scroll through >4 items in a category | ☐ |

---

## 3. Detail Modal

| # | Scenario | Expected | ✅ |
|---|----------|----------|----|
| 3.1 | Tap image tile → modal opens | Large preview, filename, size, MIME, category badge | ☐ |
| 3.2 | Rename image (display name) | Type new name → blur/submit → name persists after refresh | ☐ |
| 3.3 | Add tag | Type tag → submit → tag chip appears, persists after refresh | ☐ |
| 3.4 | Remove tag | Click × on tag chip → tag removed, persists after refresh | ☐ |
| 3.5 | Delete from modal | "Slett" → confirm dialog → image gone from gallery | ☐ |
| 3.6 | Close modal | Click outside or close button → returns to gallery | ☐ |

---

## 4. Picker Modal (from Establishment Edit)

| # | Scenario | Expected | ✅ |
|---|----------|----------|----|
| 4.1 | Open cover picker → select 1 image | Single-select mode, "Velg (1)" confirms, thumbnail shows in form | ☐ |
| 4.2 | Open gallery picker → select multiple | Multi-select mode, counter shows "N valgt" | ☐ |
| 4.3 | Open logo picker → select 1 image | Single-select, logo thumbnail shows in form | ☐ |
| 4.4 | Filter by category in picker | FilterChips work, grid updates | ☐ |
| 4.5 | Search in picker | Filters grid by filename/name | ☐ |
| 4.6 | Pre-populated selection | Re-open picker → previously selected items show checkmarks | ☐ |
| 4.7 | Cancel picker | No changes to form selection | ☐ |
| 4.8 | Change selection | Open picker with existing selection → deselect old, select new → form updates | ☐ |

---

## 5. Establishment Edit — Bilder Section

| # | Scenario | Expected | ✅ |
|---|----------|----------|----|
| 5.1 | Select cover layout mode (Bento) | Card highlights, value persists on save | ☐ |
| 5.2 | Switch layout mode to Showcase | Card switches, old deselects | ☐ |
| 5.3 | Switch layout mode to Spotlight | Same | ☐ |
| 5.4 | Select cover → save → reload edit | Cover thumbnail still shows after page reload | ☐ |
| 5.5 | Select gallery images → save → reload | Gallery thumbnails persist | ☐ |
| 5.6 | Select logo → save → reload | Logo thumbnail persists | ☐ |
| 5.7 | Remove cover selection (× button) | Thumbnail removed, save → reload → no cover | ☐ |
| 5.8 | Remove one gallery image from selection | Only that image removed, others stay | ☐ |

---

## 6. Preview Rendering

| # | Scenario | Expected | ✅ |
|---|----------|----------|----|
| 6.1 | Toggle preview (👁️) with NO media | "Bilder kommer snart" placeholder shows | ☐ |
| 6.2 | Toggle preview with cover set | Cover image renders (220px height) | ☐ |
| 6.3 | Toggle preview with gallery set | Horizontal thumbnail row renders below cover | ☐ |
| 6.4 | Toggle preview with logo set | CircleAvatar with logo image in info bar | ☐ |
| 6.5 | Toggle preview with NO logo | CircleAvatar shows business type icon fallback | ☐ |
| 6.6 | Change cover in edit → re-toggle preview | New cover image appears | ☐ |

---

## 7. Delete Flows

| # | Scenario | Expected | ✅ |
|---|----------|----------|----|
| 7.1 | Delete from gallery tile hover | Confirm dialog → image removed from gallery + Firebase Storage | ☐ |
| 7.2 | Delete image that's selected as cover | Image gone from gallery AND from establishment edit form | ☐ |
| 7.3 | Cancel delete confirmation | Image stays | ☐ |

---

## 8. Edge Cases

| # | Scenario | Expected | ✅ |
|---|----------|----------|----|
| 8.1 | Network error during upload | Error banner with dismiss, gallery unchanged | ☐ |
| 8.2 | Upload while another upload is in progress | Queued or rejected gracefully | ☐ |
| 8.3 | Empty gallery (no media at all) | "Ingen medier ennå" empty state, upload button works | ☐ |
| 8.4 | Broken image URL (manual DB corruption) | Broken image icon fallback, no crash | ☐ |

---

> **Total: 45 scenarios.** Check off as you test on Saturn.
