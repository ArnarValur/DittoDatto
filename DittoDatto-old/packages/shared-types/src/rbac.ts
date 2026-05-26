/**
 * RBAC (Role-Based Access Control) Utilities
 * 
 * Defines role hierarchy and access rules for each app.
 * 
 * Role Hierarchy (lowest to highest):
 * - customer: Basic user, can use public marketplace
 * - business: Business owner, can access business portal
 * - admin: Administrator, can access business portal
 * - super_admin: Full access, can access admin panel
 * 
 * App Access Rules:
 * - public-marketplace: All roles (or unauthenticated)
 * - business-portal: business, admin, super_admin
 * - admin-panel: super_admin ONLY
 */
import { z } from 'zod'

// Role definitions (matches UserRoleSchema)
export const RoleSchema = z.enum(['customer', 'business', 'admin', 'super_admin'])
export type Role = z.infer<typeof RoleSchema>

// Role hierarchy - higher index = more permissions
export const ROLE_HIERARCHY: readonly Role[] = ['customer', 'business', 'admin', 'super_admin'] as const

/**
 * Check if a role has at least the minimum required role level
 */
export function hasMinRole(userRole: Role | undefined | null, minRole: Role): boolean {
  if (!userRole) return false
  const userLevel = ROLE_HIERARCHY.indexOf(userRole)
  const minLevel = ROLE_HIERARCHY.indexOf(minRole)
  return userLevel >= minLevel
}

/**
 * Check if a role is exactly the specified role
 */
export function hasExactRole(userRole: Role | undefined | null, requiredRole: Role): boolean {
  return userRole === requiredRole
}

/**
 * Check if a role is one of the allowed roles
 */
export function hasAnyRole(userRole: Role | undefined | null, allowedRoles: Role[]): boolean {
  if (!userRole) return false
  return allowedRoles.includes(userRole)
}

// App-specific access rules
export const APP_ACCESS_RULES = {
  'public-marketplace': {
    allowedRoles: ['customer', 'business', 'admin', 'super_admin'] as Role[],
    allowUnauthenticated: true,
    description: 'Public marketplace - all users welcome'
  },
  'business-portal': {
    allowedRoles: ['business', 'admin', 'super_admin'] as Role[],
    allowUnauthenticated: false,
    description: 'Business portal - requires business role or higher'
  },
  'admin-panel': {
    allowedRoles: ['super_admin'] as Role[],
    allowUnauthenticated: false,
    description: 'Admin panel - super_admin only'
  }
} as const

export type AppName = keyof typeof APP_ACCESS_RULES

/**
 * Check if a role can access a specific app
 */
export function canAccessApp(userRole: Role | undefined | null, appName: AppName): boolean {
  const rules = APP_ACCESS_RULES[appName]
  
  if (!userRole) {
    return rules.allowUnauthenticated
  }
  
  return rules.allowedRoles.includes(userRole)
}

/**
 * Get the role from Firebase token claims
 */
export function getRoleFromClaims(claims: Record<string, unknown>): Role | null {
  const role = claims?.role
  if (!role || typeof role !== 'string') return null
  
  const parsed = RoleSchema.safeParse(role)
  return parsed.success ? parsed.data : null
}
