# Plan: Store Preview Page - Structure, Layout Modes & Publishing

## Phase 1: Schema Foundation ✅
*Goal: Add coverLayoutMode to Store schema*

- [x] **Task 1.1:** Add `coverLayoutMode` enum (`'showcase' | 'spotlight' | 'bento'`) to `StoreSchema`
- [x] **Task 1.2:** Run `npm run build` in shared-types to verify
- [x] **Task 1.3:** Update store form types/interfaces if needed

---

## Phase 2: Media Tab UI ✅
*Goal: Add new "Media" tab to store edit page*

- [x] **Task 2.1:** Add "Media" tab to store edit navigation (after Settings)
- [x] **Task 2.2:** Create tab content with layout mode selector
- [x] **Task 2.3:** Add Cover Image picker (reuse MediaPickerButton)
- [x] **Task 2.4:** Add Gallery images picker (multi-select with remove)
- [x] **Task 2.5:** Add Logo picker (small thumbnail)
- [x] **Task 2.6:** Wire up save logic for images + layoutMode

---

## Phase 3: Layout Mode Selector Component ✅
*Goal: Visual selector showing the 3 layout options*

- [x] **Task 3.1:** Create visual card-based selector in Media tab
- [x] **Task 3.2:** Design mini-preview cards with icons for each mode
- [x] **Task 3.3:** Emit and save selected mode value

---

## Phase 4: Gallery Component Refactor ✅
*Goal: Make EstablishmentImageGallery support 3 modes*

- [x] **Task 4.1:** Add `layoutMode` prop to `EstablishmentImageGallery.vue`
- [x] **Task 4.2:** Keep "bento" mode (current behavior, default)
- [x] **Task 4.3:** Implement "spotlight" mode (full-width cover only)
- [x] **Task 4.4:** Implement "showcase" mode (3/4 + 1/4 vertical scroll)
- [x] **Task 4.5:** Update preview page to pass layoutMode from store data
- [x] **Task 4.6:** Fix hover scale overlap with overflow-hidden
- [x] **Task 4.7:** Add auto-scroll for showcase carousel (4s interval, pause on hover)
- [x] **Task 4.8:** Adjust "more" indicator threshold (only show when >4 images)

---

## Phase 5: Publishing Flow ✅
*Goal: Toggle store visibility*

- [x] **Task 5.1:** Publish toggle exists in Settings tab
- [x] **Task 5.3:** isPublished field updates in Firestore
- [x] **Task 5.4:** Visual indicator for published vs draft (badge in header)
- [ ] **Task 5.2:** Add soft warnings for missing data (cover, address, services) [DEFERRED]

---

## Phase 6: Manual Verification ✅

- [x] **Test A:** Open Media tab, select "Showcase" layout, save
- [x] **Test B:** Preview page shows 3/4 + 1/4 scroll layout
- [x] **Test C:** Switch to "Spotlight", preview shows full cover
- [x] **Test D:** Switch to "Bento", preview shows 2+4 grid
- [x] **Test E:** Toggle publish ON, verify `isPublished: true` in Firestore
- [ ] **Test F:** Mobile responsiveness for all 3 modes [NEEDS TESTING]

---

## Bugs Fixed During Track

- [x] Multi-company storage permissions (companyIds array support)
- [x] Firestore rules for media collection (companyIds array)
- [x] isCompanyMember helper for multi-company users
- [x] Store edit navigation (slug vs id lookup)
- [x] Store preview page (slug vs id lookup)
- [x] Company owner transfer auth claims sync
- [x] Upload size limit increased to 10MB

---

## Future (Post-Track)

- [ ] Public Marketplace route: `/stores/[slug]`
- [ ] Gallery lightbox modal for fullscreen viewing
- [ ] Drag-drop reordering in gallery editor
- [ ] SEO meta tags for published stores
- [ ] Pre-publish warning checklist
- [ ] Mobile carousel for showcase mode
