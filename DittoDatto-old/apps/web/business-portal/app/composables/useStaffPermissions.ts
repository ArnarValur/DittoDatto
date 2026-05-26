/**
 * useStaffPermissions Composable
 *
 * Resolves the current user's staff document for the active company
 * and provides capability-based permission checks.
 *
 * Key rules:
 * - Company owner (ownerId === uid) always has implicit full access
 * - Staff capabilities checked via `defaultCapabilities` first,
 *   then overridden by `storeCapabilities[storeId]` if provided
 * - No staff doc + not owner = no capabilities (read-only dashboard)
 */
import type { StaffCapability, StaffMember } from '@dittodatto/shared-types'
import { ALL_STAFF_CAPABILITIES } from '@dittodatto/shared-types'
import { collection, query, where } from 'firebase/firestore'
import { useFirestore, useCollection, useCurrentUser } from 'vuefire'

export function useStaffPermissions() {
  const db = useFirestore()
  const currentUser = useCurrentUser()
  const { company, companyId, loading: companyLoading } = useCompany()

  // ── Is the current user the company owner? ──
  const isOwner = computed(() => {
    if (!currentUser.value || !company.value) return false
    return company.value.ownerId === currentUser.value.uid
  })

  // ── Reactive query: find this user's staff doc by email ──
  // We use email because userId may not be set yet (invited state)
  // but the logged-in user's email should match
  const staffQuery = computed(() => {
    if (!companyId.value || !currentUser.value?.email) return null
    return query(
      collection(db, 'companies', companyId.value, 'staff'),
      where('email', '==', currentUser.value.email)
    )
  })

  const { data: staffDocs, pending: staffLoading } =
    useCollection<StaffMember>(staffQuery)

  // Current user's staff document (first match)
  const currentStaffDoc = computed<StaffMember | null>(() => {
    if (!staffDocs.value || staffDocs.value.length === 0) return null
    return staffDocs.value[0] ?? null
  })

  // ── Loading state ──
  const loading = computed(() =>
    companyLoading.value || staffLoading.value
  )

  // ── Capability Checks ──

  /**
   * Check if the current user has a specific capability.
   *
   * @param capability - The capability to check
   * @param storeId - Optional store ID for store-scoped override
   * @returns true if user has the capability
   *
   * Resolution order:
   * 1. Owner → always true
   * 2. storeCapabilities[storeId] → if provided and key exists
   * 3. defaultCapabilities → fallback
   */
  function hasCapability(capability: StaffCapability, storeId?: string): boolean {
    // Owner bypass — implicit full access
    if (isOwner.value) return true

    const doc = currentStaffDoc.value
    if (!doc) return false

    // Staff must be active to have permissions
    if (doc.status !== 'active' && doc.status !== 'invited') return false

    // Check store-specific override first
    if (storeId && doc.storeCapabilities?.[storeId]) {
      return doc.storeCapabilities[storeId].includes(capability)
    }

    // Fall back to default capabilities
    return (doc.defaultCapabilities ?? []).includes(capability)
  }

  /**
   * Check if user has ANY of the listed capabilities.
   * Useful for "show section if user can do at least one thing in it"
   */
  function hasAnyCapability(capabilities: StaffCapability[], storeId?: string): boolean {
    return capabilities.some(cap => hasCapability(cap, storeId))
  }

  /**
   * Check if user has ALL of the listed capabilities.
   */
  function hasAllCapabilities(capabilities: StaffCapability[], storeId?: string): boolean {
    return capabilities.every(cap => hasCapability(cap, storeId))
  }

  /**
   * Get resolved capabilities for the current user.
   * Returns all capabilities for owners.
   */
  const resolvedCapabilities = computed<StaffCapability[]>(() => {
    if (isOwner.value) return [...ALL_STAFF_CAPABILITIES]

    const doc = currentStaffDoc.value
    if (!doc) return []
    if (doc.status !== 'active' && doc.status !== 'invited') return []

    return doc.defaultCapabilities ?? []
  })

  /**
   * Whether this user can access the portal at all.
   * Owner or any active/invited staff doc = can access.
   */
  const canAccessPortal = computed(() => {
    if (isOwner.value) return true
    const doc = currentStaffDoc.value
    return !!doc && (doc.status === 'active' || doc.status === 'invited')
  })

  return {
    // Identity
    isOwner,
    currentStaffDoc,
    canAccessPortal,

    // Capability checks
    hasCapability,
    hasAnyCapability,
    hasAllCapabilities,
    resolvedCapabilities,

    // State
    loading,
  }
}
