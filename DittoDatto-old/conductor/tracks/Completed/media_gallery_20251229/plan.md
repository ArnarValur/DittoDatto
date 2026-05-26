# Plan: Media Gallery MVP

## Phase 1: Data Foundation
*Goal: Schema and security rules*

- [x] **Task 1.1:** Create `packages/shared-types/src/media.ts` with `MediaTypeSchema`, `MediaItemSchema`
- [x] **Task 1.2:** Export from `packages/shared-types/src/index.ts`
- [x] **Task 1.3:** Update `storage.rules` for company-scoped uploads (5MB limit, image types)
- [ ] **Task 1.4:** Update `firestore.rules` for `media` collection access (deferred - using existing rules)

---

## Phase 2: Core Logic
*Goal: Reusable upload composable*

- [x] **Task 2.1:** Create `useMediaUpload` composable in `packages/ui/composables/`
  - File validation (size, MIME type)
  - `uploadBytesResumable` to correct path
  - Firestore document creation
  - Reactive state: `uploadProgress`, `isUploading`, `error`, `downloadUrl`

---

## Phase 3: Admin Panel - Media Manager
*Goal: Super Admin can view/manage all media, filtered by company*

- [x] **Task 3.1:** Create `/pages/media/index.vue` with company filter header
- [x] **Task 3.2:** Implement media table display
- [x] **Task 3.3:** Add delete functionality with confirmation
- [x] **Task 3.4:** Add sidebar navigation link

---

## Phase 4: Business Portal - Upload UI
*Goal: Company users can upload media (MVP functional state)*

- [x] **Task 4.1:** Create `/pages/media/index.vue` with grid display
- [x] **Task 4.2:** Basic upload interface with type selector
- [x] **Task 4.3:** Display existing uploads with delete option
- [x] **Task 4.4:** Add sidebar navigation link

---

## Manual Verification (Phase 5)

- [x] **Test A:** As Super Admin, upload a logo in Admin Panel
- [x] **Test B:** As Company User, upload a store gallery image in Business Portal
- [x] **Test C:** Verify storage path follows `companies/{companyId}/...` structure
- [x] **Test D:** Verify invalid file types/sizes are rejected

---

## Phase 6: Schema Evolution (Phase 2 Feature)
*Goal: Tag-based media organization and store image structure*

- [x] **Task 6.1:** Update `MediaItem` schema - replace `type` enum with `tags: string[]`, add `name`
- [x] **Task 6.2:** Update `Company` schema - add `mediaConfig.defaultTags`
- [x] **Task 6.3:** Update `Store` schema - restructure `images` object (logo, cover, gallery)
- [x] **Task 6.4:** Run `npm run build` in shared-types to verify

---

## Phase 7: Reusable Media Components
*Goal: Modal-based media picker for forms*

- [x] **Task 7.1:** Create `MediaGrid.vue` component
- [x] **Task 7.2:** Create `MediaLibraryModal.vue` (dark theme mockup)
- [x] **Task 7.3:** Create `MediaPickerButton.vue`
- [x] **Task 7.4:** Refactor `/pages/media/index.vue` to use `MediaGrid`

---

## Phase 8: Store Integration
*Goal: Use media picker in store edit forms*

- [x] **Task 8.1:** Replace `logoUrl` input with `MediaPickerButton`
- [ ] **Task 8.2:** Add "Media" tab with cover and gallery pickers
- [x] **Task 8.3:** Update form state and `handleSave()` for new structure
- [ ] **Task 8.4:** Add tag management UI to Media page

---

## Manual Verification (Phase 9)

- [x] **Test E:** Modal picker opens and displays media grid
- [x] **Test F:** Selecting image populates form field and closes modal
- [ ] **Test G:** Tag filtering works correctly (deferred - tag UI not yet built)
- [x] **Test H:** Dark/light mode styling matches mockup

