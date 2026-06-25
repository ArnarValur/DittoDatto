# E2E Authentication Test Checklist — Public Marketplace

> **Purpose:** Manual and automated E2E verification of the consumer authentication flow.
> All tests exercise the **deployed app** (phone or web) against **Saturn SDB** — not mocked, not local.
>
> **Created:** 2026-06-25
> **Access method:** `consumer_auth` RECORD ACCESS on `users/users`

---

## 1. Signup — New User Creation

- [ ] **1.1** Open marketplace app → navigate to Profile tab
- [ ] **1.2** Tap "Opprett konto" (Create account)
- [ ] **1.3** Fill in: Name, Email, Password (≥8 chars), Confirm Password
- [ ] **1.4** Tap "Opprett konto" button
- [ ] **1.5** Verify: redirected to Profile screen with "Hei, {firstName} 👋"
- [ ] **1.6** Verify: Norwegian date displayed ("I dag er {day} {date}")
- [ ] **1.7** Verify: email displayed under avatar
- [ ] **1.8** Verify: user record exists in Saturn SDB (`SELECT * FROM user WHERE email = '...'`)
- [ ] **1.9** Verify: `role = 'customer'`, `is_onboarded = false`, `password_hash` is argon2

### Validation edge cases

- [ ] **1.10** Signup with existing email → error shown (not crash)
- [ ] **1.11** Signup with mismatched passwords → client-side validation blocks submit
- [ ] **1.12** Signup with password < 8 chars → client-side validation blocks submit
- [ ] **1.13** Signup with empty name → client-side validation blocks submit
- [ ] **1.14** Signup with invalid email format → client-side validation blocks submit

---

## 2. Login — Existing User

- [ ] **2.1** Log out first (if authenticated)
- [ ] **2.2** Navigate to Profile tab → Login screen
- [ ] **2.3** Enter registered email + correct password
- [ ] **2.4** Tap "Logg inn" button
- [ ] **2.5** Verify: redirected to Profile screen with correct name and email
- [ ] **2.6** Verify: session token stored (survives app restart — test in §4)

### Role variants (hierarchical RBAC)

- [ ] **2.7** Login as `customer` role → ✅ success
- [ ] **2.8** Login as `business` role → ✅ success (higher includes lower)
- [ ] **2.9** Login as `admin` role → ✅ success
- [ ] **2.10** Login as `super_admin` role → ✅ success (`arnarvalur@avj.info`)

### Error cases

- [ ] **2.11** Wrong password → error message shown (Norwegian), no crash
- [ ] **2.12** Non-existent email → error message shown, no crash
- [ ] **2.13** Empty fields → client-side validation blocks submit

---

## 3. Profile Screen — Account Section

> The profile screen displays user info and provides account management actions.

### Display

- [ ] **3.1** Shows "Hei, {firstName} 👋" greeting
- [ ] **3.2** Shows "I dag er {day} {date}" in Norwegian (nb_NO locale)
- [ ] **3.3** Shows avatar with initials
- [ ] **3.4** Shows email address

### Account Actions (3 items)

#### 3A. Change Password

- [ ] **3.5** "Endre passord" button visible in account section
- [ ] **3.6** Tap → shows change password form (current password, new password, confirm new)
- [ ] **3.7** Enter correct current password + valid new password → success
- [ ] **3.8** Verify: can log out and log back in with new password
- [ ] **3.9** Verify: old password no longer works
- [ ] **3.10** Wrong current password → error shown
- [ ] **3.11** New password < 8 chars → validation blocks submit
- [ ] **3.12** New passwords don't match → validation blocks submit

#### 3B. Delete Account

- [ ] **3.13** "Slett konto" button visible in account section
- [ ] **3.14** Tap → confirmation dialog ("Er du sikker?" or similar)
- [ ] **3.15** Cancel → nothing happens, stays on profile
- [ ] **3.16** Confirm → account deleted, redirected to login/home
- [ ] **3.17** Verify: user record removed from Saturn SDB
- [ ] **3.18** Verify: cannot log in with deleted credentials
- [ ] **3.19** Verify: stored session token cleared

#### 3C. Logout

- [ ] **3.20** "Logg ut" button visible in account section
- [ ] **3.21** Tap → redirected to unauthenticated state (Home tab or login)
- [ ] **3.22** Verify: stored session token cleared
- [ ] **3.23** Verify: Profile tab shows login screen again
- [ ] **3.24** Verify: other tabs (Utforsk, Bestillinger) still accessible (Anonymous Browsing, ADR-0020)

---

## 4. Session Persistence

- [ ] **4.1** Login → force-close app → reopen → auto-restored to Profile (no re-login)
- [ ] **4.2** Login → wait 24h+ → token expired → redirected to login on next open
- [ ] **4.3** Login on device A → login on device B with same account → both sessions active

---

## 5. Cross-App Consistency

- [ ] **5.1** User created via Admin Panel → can login in marketplace
- [ ] **5.2** User created via marketplace signup → visible in Admin Panel user list
- [ ] **5.3** Password changed in marketplace → reflected if logging into BP (same `users/users` table)

---

## Implementation Status

| Feature | UI Built | Backend | Tests | Notes |
|---------|----------|---------|-------|-------|
| Signup | ✅ | ✅ `consumer_auth` SIGNUP | ✅ 13 integration (ditto_auth) | Working E2E |
| Login | ✅ | ✅ `consumer_auth` SIGNIN | ✅ 13 integration (ditto_auth) | Working E2E |
| Profile display | ✅ | ✅ (from auth result) | ❌ No widget tests | Locale fix applied |
| Change password | ❌ Not built | ❌ No endpoint | ❌ | Needs new SurrealQL query |
| Delete account | ❌ Not built | ❌ No endpoint | ❌ | GDPR consideration |
| Logout | ✅ | ✅ | ✅ | Working |
| Session restore | ✅ | ✅ TokenStore | ✅ | Working |
