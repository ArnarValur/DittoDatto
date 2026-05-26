# Specification: Business Portal Structure - User Settings

## 1. Goal
To provide a dedicated "Settings" area in the Business Portal where users can manage their personal identity and public-facing profile information.

## 2. Core Features

### 2.1 Profile Management
*   **Fields:** Name, Email, Username, Bio.
*   **Validation:** 
    *   Name: Min 1, Max 255.
    *   Email: Must be a valid email format.
    *   Username: Unique identifier (String).
    *   Bio: Multi-line text for profile description.
*   **Persistence:** All changes are saved to the user's document in the `users` Firestore collection.

### 2.2 Avatar Management
*   **Storage:** Avatars are stored in Firebase Storage at `avatars/${userId}`.
*   **Constraints:** Max size 1MB. Allowed types: JPG, GIF, PNG.
*   **Flow:**
    1.  User selects a file.
    2.  File is uploaded to Firebase Storage.
    3.  User document's `photoUrl` is updated with the storage URL.

### 2.3 User Interface
*   **Location:** `/settings` (General).
*   **Layout:** Consistent with the Business Portal dashboard, using `UDashboardPanel` and `UDashboardSection`.
*   **Visuals:** Mirror the provided design (Labels, Placeholders, "Save changes" button).

## 3. Technical Implementation

### 3.1 Data Schema
Update `UserSchema` in `packages/shared-types/src/user.ts`:
```typescript
{
  username: z.string().optional(),
  bio: z.string().optional(),
}
```

### 3.2 Security Rules
*   **Storage:** `match /avatars/{userId}` allows `write` if `request.auth.uid == userId`.

### 3.3 Composables
*   `useUserProfile()`:
    *   `profile`: Reactive user data from Firestore.
    *   `updateProfile(data)`: Method to persist changes.
    *   `uploadAvatar(file)`: Method to handle storage upload and URL update.

## 4. Acceptance Criteria
1.  **Navigation:** User can click "Settings" -> "General" in the sidebar.
2.  **Form:** The form displays current user data (Name, Email, Username, Bio).
3.  **Update:** Clicking "Save changes" updates the Firestore document.
4.  **Avatar:** Uploading a new image updates the avatar preview and saves to Storage/Firestore.
5.  **Validation:** Form shows errors for invalid email or empty name.
