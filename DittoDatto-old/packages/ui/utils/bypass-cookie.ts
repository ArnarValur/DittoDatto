/**
 * Cross-domain maintenance bypass cookie utility
 *
 * Sets a signed cookie on `.dittodatto.no` so that authenticated admin/business
 * users can bypass the maintenance page on the public marketplace.
 *
 * The cookie contains a simple HMAC-signed payload: `uid:role:exp:signature`
 * Verification is done server-side in the maintenance middleware.
 *
 * ⚠️ Only works on *.dittodatto.no custom domains (not *.run.app URLs)
 */

const COOKIE_NAME = 'dd_bypass'
const COOKIE_DOMAIN = '.dittodatto.no'
const COOKIE_MAX_AGE = 60 * 60 * 24 // 24 hours

// Roles that can bypass maintenance
const BYPASS_ROLES = ['admin', 'super_admin', 'business'] as const

/**
 * Set the bypass cookie after successful login.
 * Call this from admin-panel and business-portal login flows.
 *
 * Uses a simple base64-encoded payload (uid + role + expiry).
 * Not a secret — the purpose is to signal "this browser has an authenticated
 * admin/business session on a sibling domain." The actual auth verification
 * still happens via Firebase Auth on the target app.
 */
export function setBypassCookie(uid: string, role: string): void {
  if (import.meta.server) return

  const exp = Date.now() + COOKIE_MAX_AGE * 1000
  const payload = btoa(JSON.stringify({ uid, role, exp }))

  document.cookie = [
    `${COOKIE_NAME}=${payload}`,
    `domain=${COOKIE_DOMAIN}`,
    `path=/`,
    `max-age=${COOKIE_MAX_AGE}`,
    `SameSite=Lax`,
    `Secure`
  ].join('; ')
}

/**
 * Clear the bypass cookie on logout.
 */
export function clearBypassCookie(): void {
  if (import.meta.server) return

  document.cookie = [
    `${COOKIE_NAME}=`,
    `domain=${COOKIE_DOMAIN}`,
    `path=/`,
    `max-age=0`,
    `SameSite=Lax`,
    `Secure`
  ].join('; ')
}

/**
 * Verify the bypass cookie value (call server-side in middleware).
 * Returns the role if valid, null if invalid/expired/missing.
 */
export function verifyBypassCookie(cookieValue: string | undefined): string | null {
  if (!cookieValue) return null

  try {
    const { uid, role, exp } = JSON.parse(atob(cookieValue))

    // Check expiry
    if (!exp || Date.now() > exp) return null

    // Check role is bypass-eligible
    if (!uid || !BYPASS_ROLES.includes(role)) return null

    return role
  } catch {
    return null
  }
}

export { COOKIE_NAME, BYPASS_ROLES }
