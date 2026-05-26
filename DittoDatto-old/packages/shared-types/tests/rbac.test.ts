/**
 * RBAC (Role-Based Access Control) Test Suite
 * 
 * Tests the authorization rules for each app:
 * - public-marketplace: All roles allowed
 * - business-portal: business, admin, super_admin only
 * - admin-panel: super_admin ONLY
 */
import { describe, it, expect } from 'vitest'
import { 
  hasMinRole, 
  hasExactRole, 
  hasAnyRole, 
  canAccessApp, 
  getRoleFromClaims,
  ROLE_HIERARCHY,
  type Role 
} from '../src/rbac'

describe('RBAC Utilities', () => {
  describe('ROLE_HIERARCHY', () => {
    it('should define roles in correct order', () => {
      expect(ROLE_HIERARCHY).toEqual(['customer', 'business', 'admin', 'super_admin'])
    })
  })

  describe('hasMinRole', () => {
    it('should return false for null/undefined role', () => {
      expect(hasMinRole(null, 'customer')).toBe(false)
      expect(hasMinRole(undefined, 'customer')).toBe(false)
    })

    it('customer should only have min customer role', () => {
      expect(hasMinRole('customer', 'customer')).toBe(true)
      expect(hasMinRole('customer', 'business')).toBe(false)
      expect(hasMinRole('customer', 'admin')).toBe(false)
      expect(hasMinRole('customer', 'super_admin')).toBe(false)
    })

    it('business should have min customer and business roles', () => {
      expect(hasMinRole('business', 'customer')).toBe(true)
      expect(hasMinRole('business', 'business')).toBe(true)
      expect(hasMinRole('business', 'admin')).toBe(false)
      expect(hasMinRole('business', 'super_admin')).toBe(false)
    })

    it('admin should have min customer, business, and admin roles', () => {
      expect(hasMinRole('admin', 'customer')).toBe(true)
      expect(hasMinRole('admin', 'business')).toBe(true)
      expect(hasMinRole('admin', 'admin')).toBe(true)
      expect(hasMinRole('admin', 'super_admin')).toBe(false)
    })

    it('super_admin should have all roles', () => {
      expect(hasMinRole('super_admin', 'customer')).toBe(true)
      expect(hasMinRole('super_admin', 'business')).toBe(true)
      expect(hasMinRole('super_admin', 'admin')).toBe(true)
      expect(hasMinRole('super_admin', 'super_admin')).toBe(true)
    })
  })

  describe('hasExactRole', () => {
    it('should match exact roles only', () => {
      expect(hasExactRole('customer', 'customer')).toBe(true)
      expect(hasExactRole('customer', 'business')).toBe(false)
      expect(hasExactRole('super_admin', 'super_admin')).toBe(true)
      expect(hasExactRole('super_admin', 'admin')).toBe(false)
    })

    it('should return false for null/undefined', () => {
      expect(hasExactRole(null, 'customer')).toBe(false)
      expect(hasExactRole(undefined, 'super_admin')).toBe(false)
    })
  })

  describe('hasAnyRole', () => {
    it('should return true if role is in allowed list', () => {
      expect(hasAnyRole('business', ['business', 'admin'])).toBe(true)
      expect(hasAnyRole('admin', ['business', 'admin'])).toBe(true)
      expect(hasAnyRole('customer', ['business', 'admin'])).toBe(false)
    })

    it('should return false for null/undefined', () => {
      expect(hasAnyRole(null, ['customer'])).toBe(false)
      expect(hasAnyRole(undefined, ['super_admin'])).toBe(false)
    })
  })

  describe('getRoleFromClaims', () => {
    it('should extract valid role from claims', () => {
      expect(getRoleFromClaims({ role: 'customer' })).toBe('customer')
      expect(getRoleFromClaims({ role: 'super_admin' })).toBe('super_admin')
    })

    it('should return null for invalid role', () => {
      expect(getRoleFromClaims({ role: 'invalid_role' })).toBe(null)
      expect(getRoleFromClaims({ role: 123 })).toBe(null)
      expect(getRoleFromClaims({ role: null })).toBe(null)
      expect(getRoleFromClaims({})).toBe(null)
    })
  })
})

describe('App Access Rules', () => {
  describe('public-marketplace', () => {
    it('should allow all authenticated roles', () => {
      expect(canAccessApp('customer', 'public-marketplace')).toBe(true)
      expect(canAccessApp('business', 'public-marketplace')).toBe(true)
      expect(canAccessApp('admin', 'public-marketplace')).toBe(true)
      expect(canAccessApp('super_admin', 'public-marketplace')).toBe(true)
    })

    it('should allow unauthenticated users', () => {
      expect(canAccessApp(null, 'public-marketplace')).toBe(true)
      expect(canAccessApp(undefined, 'public-marketplace')).toBe(true)
    })
  })

  describe('business-portal', () => {
    it('should allow business, admin, super_admin roles', () => {
      expect(canAccessApp('business', 'business-portal')).toBe(true)
      expect(canAccessApp('admin', 'business-portal')).toBe(true)
      expect(canAccessApp('super_admin', 'business-portal')).toBe(true)
    })

    it('should DENY customer role', () => {
      expect(canAccessApp('customer', 'business-portal')).toBe(false)
    })

    it('should DENY unauthenticated users', () => {
      expect(canAccessApp(null, 'business-portal')).toBe(false)
      expect(canAccessApp(undefined, 'business-portal')).toBe(false)
    })
  })

  describe('admin-panel', () => {
    it('should ONLY allow super_admin role', () => {
      expect(canAccessApp('super_admin', 'admin-panel')).toBe(true)
    })

    it('should DENY all other roles', () => {
      expect(canAccessApp('customer', 'admin-panel')).toBe(false)
      expect(canAccessApp('business', 'admin-panel')).toBe(false)
      expect(canAccessApp('admin', 'admin-panel')).toBe(false)
    })

    it('should DENY unauthenticated users', () => {
      expect(canAccessApp(null, 'admin-panel')).toBe(false)
      expect(canAccessApp(undefined, 'admin-panel')).toBe(false)
    })
  })
})

describe('Security Scenarios', () => {
  const allRoles: Role[] = ['customer', 'business', 'admin', 'super_admin']

  it('customer cannot access any protected app', () => {
    expect(canAccessApp('customer', 'business-portal')).toBe(false)
    expect(canAccessApp('customer', 'admin-panel')).toBe(false)
  })

  it('business user can access business-portal but NOT admin-panel', () => {
    expect(canAccessApp('business', 'business-portal')).toBe(true)
    expect(canAccessApp('business', 'admin-panel')).toBe(false)
  })

  it('admin can access business-portal but NOT admin-panel', () => {
    expect(canAccessApp('admin', 'business-portal')).toBe(true)
    expect(canAccessApp('admin', 'admin-panel')).toBe(false)
  })

  it('super_admin can access ALL apps', () => {
    expect(canAccessApp('super_admin', 'public-marketplace')).toBe(true)
    expect(canAccessApp('super_admin', 'business-portal')).toBe(true)
    expect(canAccessApp('super_admin', 'admin-panel')).toBe(true)
  })

  it('only 1 role should access admin-panel', () => {
    const rolesWithAdminAccess = allRoles.filter(role => canAccessApp(role, 'admin-panel'))
    expect(rolesWithAdminAccess).toHaveLength(1)
    expect(rolesWithAdminAccess[0]).toBe('super_admin')
  })

  it('exactly 3 roles should access business-portal', () => {
    const rolesWithPortalAccess = allRoles.filter(role => canAccessApp(role, 'business-portal'))
    expect(rolesWithPortalAccess).toHaveLength(3)
    expect(rolesWithPortalAccess).toEqual(['business', 'admin', 'super_admin'])
  })
})
