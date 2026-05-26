# Plan: Business Portal Structure

## Phase 1: User Profile Settings
*Goal: Allow users to manage their personal profile and avatar.*

- [x] Task: Update `UserSchema` in `packages/shared-types` to include `username` and `bio`.
- [x] Task: Update `storage.rules` to allow authenticated users to upload their avatar to `avatars/{userId}`.
- [x] Task: Create `useUserProfile` composable in `business-portal` for profile state and updates.
- [x] Task: Implement `apps/web/business-portal/app/pages/settings/index.vue` with the Profile form.
- [x] Task: Implement Avatar upload functionality with Firebase Storage.
- [x] Task: Conductor - User Manual Verification 'User Profile Settings' (Protocol in workflow.md)

## Phase 2: Security Settings
*Goal: Implement password reset link and prepare account deletion flow.*

- [x] Task: Replace password change form with "Send password reset email" button using Firebase Auth.
- [x] Task: Disable "Delete account" button with tooltip explaining feature is coming soon.
- [ ] Task: Conductor - User Manual Verification 'Security Settings'

> **⚠️ BLOCKED:** Password reset requires reCAPTCHA/App Check configuration in Firebase Console. Low priority - will revisit.
