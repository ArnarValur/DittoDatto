# Verification Log — Admin Panel

Living registry of automated and manual quality gates for the **Admin Panel** (`apps/admin/`).

---

## 1. Automated Test Registry

These test suites are executed via `flutter test` at the workspace level.

| Suite | Component | Scope / What is being tested | Status |
|:---|:---|:---|:---|
| `login_screen_test.dart` | `LoginScreen` | Visual layout elements, input field validation errors, and loading state indicator during authentication. | 🟢 Passed |
| `companies_form_test.dart` | `CompanyDialog` | Form input validations (required fields, email format, slug safety regex checks), and successful mock submission. | 🟢 Passed |
| `test_auth.dart` | Staging / CLI | Loopback authentication validation directly against `ws://dittodatto:8002/rpc` (asserts correct login works, incorrect fails). | 🟢 Passed |
| `test_users_crud.dart` | Staging / CLI | Integration CRUD validation directly against `ws://dittodatto:8002/rpc` (asserts user creation, listing, role promotion using type::record, and cleanup work). | 🟢 Passed |
| `test_companies_crud.dart` | Staging / CLI | Integration CRUD validation directly against `ws://dittodatto:8002/rpc` (asserts company creation, listing, tier update, and cleanup work). | 🟢 Passed |
| `test_null_remover.dart` | Staging / CLI | Verifies that nested JSON maps containing null values (e.g. social_links) are recursively stripped before SurrealDB injection to satisfy strict schema coercion rules. | 🟢 Passed |
| `ditto_window_class_test.dart` | `DittoWindowClass` | Material 3 responsive viewport breakpoint evaluations (`compact`, `medium`, `expanded`, `large`). | 🟢 Passed |
| `ditto_colors_test.dart` | `DittoColors` | Seed-based primary Moody Blue (#6F71CC) and dark surface grading definitions. | 🟢 Passed |
| `ditto_spacing_test.dart` | `DittoSpacing` | Standard 4px-base layout spacing constants and grid bounds. | 🟢 Passed |

---

## 2. Manual Integration Playbook

Checklists for live-environment verification on Asus Ascent staging (**Saturn**).

### 🔑 Authentication & Session Guard
- [ ] **Deterministic Session Restore:** Open panel in browser, verify loading splash/spinner. Sessions should restore instantly if the JWT token is persisted and has not expired (1-hour TTL).
- [ ] **Router Interception:** Manually navigate URL to `/users` or `/companies` while unauthenticated. The app must intercept and redirect to `/login`.
- [ ] **Opacity failures:** Attempt authentication with random credentials. The UI must fail silently without displaying detailed DB errors to prevent user enumeration.

### 👥 Users Screen (Operator Control)
- [ ] **Exclusion filtering:** Verify that `admin` and `super_admin` accounts (like `arnarvalur`) do **not** appear in the list.
- [ ] **Initials Badge:** Verify circle avatar renders with correct uppercase initials.
- [ ] **Search input:** Type queries in the "Search users..." bar. Verify that SurrealDB handles case-insensitive substring matches against `name` and `email`.
- [ ] **Role switching restriction:** Click the three-dots options menu. The assigned role must only switch between `Customer` and `Business`. Promotion to admin grades must be blocked.
- [ ] **Add User provisioning:** Open the "Add User" dialog. Form-fill details and submit. Verify a fresh document is created directly in the `users/profiles` namespace on Saturn.

### 🏢 Companies Screen
- [ ] **Horizontal scrolling:** Resize browser to compact/medium widths. Verify the horizontally scrollable 7-column table adapts fluidly.
- [ ] **Database provisioning:** Create a new company. Verify details are saved and database configurations are initialized.

### 📁 Categories Screen
- [ ] **Automatic slug generation:** Create a new category. Verify that typing a name automatically generates a URL-friendly slug.
- [ ] **Delete confirmation:** Trigger deletion of a category. Verify that the `DittoConfirmDialog` modal interrupts and asks for explicit confirmation before dropping the category from Saturn's SurrealDB discovery space.

---

## 3. Last Execution Log

| Date | Type | Target | Focus / Notes | Result |
|:---|:---|:---|:---|:---|
| 2026-06-01 13:38 | Hybrid | Staging (Saturn) | Developed recursive null-remover for all nested lists/maps in surreal_admin_repository.dart. Verified exact layout payload schema coercion by writing standalone integration suite test_null_remover.dart and resolving coercion crashes for social_links. | 🟢 Success |
| 2026-06-01 13:21 | Hybrid | Staging (Saturn) | Verified Company CRUD (creation, editing, deletion) and atomic User profile connection. Successfully integrated owner dropdown loading dynamically from users/profiles and updated database schemas. | 🟢 Success |
| 2026-06-01 00:37 | Hybrid | Staging (Saturn) | Verified WebStorage HTTP bypass, SurrealDB 3.0 type::record transition, dynamic text search, and manual user creation. Executed `test_auth.dart` and `test_users_crud.dart` integration tests. | 🟢 Success (All tests green) |
| 2026-06-01 00:44 | Hybrid | Staging (Saturn) | Resolved user creation exception by sweeping null values from JSON maps (fixing NULL vs none schema mismatches), removing the unused Company Slug input from dialogs, standardizing list/map normalization, and locking dialog components during submit tasks. | 🟢 Success |
