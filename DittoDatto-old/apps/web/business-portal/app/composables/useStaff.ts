/**
 * useStaff Composable
 *
 * Manages staff members for the active company.
 * Collection path: companies/{companyId}/staff
 *
 * Provides reactive staff list, CRUD operations, and filtering.
 */
import type { StaffMember, CreateStaffMember } from '@dittodatto/shared-types'
import {
  collection,
  addDoc,
  doc,
  updateDoc,
  serverTimestamp,
} from 'firebase/firestore'
import { useFirestore, useCollection } from 'vuefire'

export function useStaff() {
  const db = useFirestore()
  const { companyId, loading: companyLoading } = useCompany()

  // Reactive Firestore query for all staff
  const staffQuery = computed(() => {
    if (!companyId.value) return null
    return collection(db, 'companies', companyId.value, 'staff')
  })

  const { data: allStaff, pending: staffLoading } =
    useCollection<StaffMember>(staffQuery)

  // ---- Filters ----
  const statusFilter = ref<'active' | 'invited' | 'all'>('all')
  const storeFilter = ref<string | null>(null)
  const searchQuery = ref('')

  const staff = computed(() => {
    // Always exclude removed — they live in the archive
    let result = (allStaff.value ?? []).filter((s) => s.status !== 'removed')

    // Status filter
    if (statusFilter.value !== 'all') {
      result = result.filter((s) => s.status === statusFilter.value)
    }

    // Store filter
    if (storeFilter.value) {
      result = result.filter((s) => s.storeIds?.includes(storeFilter.value!))
    }

    // Search filter (name or email, case-insensitive)
    if (searchQuery.value.trim()) {
      const q = searchQuery.value.toLowerCase()
      result = result.filter(
        (s) =>
          s.displayName?.toLowerCase().includes(q) ||
          s.email?.toLowerCase().includes(q) ||
          s.position?.toLowerCase().includes(q)
      )
    }

    return result
  })

  // Archived (removed) staff — sorted by removal date descending
  const archivedStaff = computed(() => {
    return (allStaff.value ?? [])
      .filter((s) => s.status === 'removed')
      .sort((a, b) => {
        const aTime = a.updatedAt instanceof Date ? a.updatedAt.getTime() : 0
        const bTime = b.updatedAt instanceof Date ? b.updatedAt.getTime() : 0
        return bTime - aTime
      })
  })

  // Stats
  const stats = computed(() => {
    const all = allStaff.value ?? []
    return {
      total: all.filter((s) => s.status !== 'removed').length,
      active: all.filter((s) => s.status === 'active').length,
      invited: all.filter((s) => s.status === 'invited').length,
      suspended: all.filter((s) => s.status === 'suspended').length,
      archived: all.filter((s) => s.status === 'removed').length,
    }
  })

  // ---- Helpers ----

  /** Remove undefined values — Firestore rejects them */
  function scrubUndefined<T extends Record<string, any>>(obj: T): Partial<T> {
    return Object.fromEntries(
      Object.entries(obj).filter(([_, v]) => v !== undefined)
    ) as Partial<T>
  }

  // ---- CRUD ----

  /**
   * Invite a new staff member.
   * Creates document with status: 'invited'.
   */
  async function addStaff(input: CreateStaffMember) {
    if (!companyId.value) throw new Error('No active company')

    const docData = scrubUndefined({
      ...input,
      companyId: companyId.value,
      status: input.status || 'invited',
      isBookable: input.isBookable ?? false,
      storeIds: input.storeIds || [],
      defaultCapabilities: input.defaultCapabilities || [],
      storeCapabilities: input.storeCapabilities || {},
      invitedAt: serverTimestamp(),
      createdAt: serverTimestamp(),
      updatedAt: serverTimestamp(),
    })

    const ref = await addDoc(
      collection(db, 'companies', companyId.value, 'staff'),
      docData
    )
    return ref.id
  }

  /**
   * Update an existing staff member (partial update).
   */
  async function updateStaffMember(
    staffId: string,
    updates: Partial<StaffMember>
  ) {
    if (!companyId.value) throw new Error('No active company')

    // Strip id from updates to avoid overwriting, scrub undefined
    const { id: _, ...rest } = updates as any
    const safeUpdates = scrubUndefined({
      ...rest,
      updatedAt: serverTimestamp(),
    })

    await updateDoc(
      doc(db, 'companies', companyId.value, 'staff', staffId),
      safeUpdates
    )
  }

  /**
   * Soft-delete: set status to 'removed'.
   * We retain the doc for booking history / audit.
   */
  async function removeStaff(staffId: string) {
    return updateStaffMember(staffId, { status: 'removed' } as any)
  }

  /**
   * Get staff members for a specific store.
   */
  function getStaffForStore(storeId: string) {
    return computed(() =>
      (allStaff.value ?? []).filter(
        (s) => s.storeIds?.includes(storeId) && s.status !== 'removed'
      )
    )
  }

  return {
    // Data
    staff,
    allStaff,
    archivedStaff,
    stats,

    // Filters
    statusFilter,
    storeFilter,
    searchQuery,

    // CRUD
    addStaff,
    updateStaff: updateStaffMember,
    removeStaff,
    getStaffForStore,

    // State
    loading: computed(
      () => companyLoading.value || staffLoading.value
    ),
    isEmpty: computed(
      () =>
        !staffLoading.value &&
        (!allStaff.value || allStaff.value.length === 0)
    ),
  }
}
