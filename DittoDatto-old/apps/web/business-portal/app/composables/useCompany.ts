/**
 * useCompany Composable (Multi-Company Support)
 * 
 * Fetches ALL companies the user owns based on ownerId field.
 * Stores active company in localStorage for persistence across page reloads.
 * 
 * TODO: When implementing team members / employees access:
 * - Sync companyMembershipIds on user document when adding members
 * - Query both ownerId AND companyMembershipIds for full access list
 * - For now, we only query companies WHERE ownerId === user.uid
 */
import type { Company } from '@dittodatto/shared-types'
import { collection, query, where, getDocs } from 'firebase/firestore'
import { useFirestore, useCurrentUser } from 'vuefire'

const ACTIVE_COMPANY_KEY = 'dittodatto_active_company_id'

export function useCompany() {
  const db = useFirestore()
  const currentUser = useCurrentUser()
  
  const loading = ref(true)
  const error = ref<string | null>(null)
  
  // All companies user has access to
  const companies = ref<Company[]>([])
  
  // Active company ID (stored in localStorage)
  const activeCompanyId = ref<string | null>(null)
  
  // Computed: Active company object
  const company = computed(() => {
    if (!activeCompanyId.value || companies.value.length === 0) return null
    return companies.value.find(c => c.id === activeCompanyId.value) || companies.value[0]
  })
  
  // Sync activeCompanyId ref with localStorage
  const savedId = typeof window !== 'undefined' ? localStorage.getItem(ACTIVE_COMPANY_KEY) : null
  if (savedId) {
    activeCompanyId.value = savedId
  }

  // Watch for user changes and fetch their companies
  watch(currentUser, async (user) => {
    if (!user) {
      companies.value = []
      activeCompanyId.value = null
      loading.value = false
      return
    }

    try {
      // Primary query: Get all companies where user is owner
      const companiesQuery = query(
        collection(db, 'companies'),
        where('ownerId', '==', user.uid)
      )
      const snapshot = await getDocs(companiesQuery)
      
      companies.value = snapshot.docs.map(d => ({ id: d.id, ...d.data() } as Company))

      // Fallback: If not an owner, check custom claims for staff access
      if (companies.value.length === 0) {
        const tokenResult = await user.getIdTokenResult()
        const claimCompanyIds: string[] = tokenResult.claims.companyIds as string[] || []

        if (claimCompanyIds.length > 0) {
          // Fetch each company by ID (staff member access)
          const { doc: docRef, getDoc } = await import('firebase/firestore')
          const companyDocs = await Promise.all(
            claimCompanyIds.map(async (cId) => {
              const snap = await getDoc(docRef(db, 'companies', cId))
              return snap.exists() ? { id: snap.id, ...snap.data() } as Company : null
            })
          )
          companies.value = companyDocs.filter((c): c is Company => c !== null)
        }
      }

      if (companies.value.length === 0) {
        error.value = 'No companies associated with this account'
        loading.value = false
        return
      }

      // Set active company if not already set or if saved one doesn't exist
      if (!activeCompanyId.value || !companies.value.find(c => c.id === activeCompanyId.value)) {
        activeCompanyId.value = companies.value[0]?.id || null
        if (activeCompanyId.value && typeof window !== 'undefined') {
          localStorage.setItem(ACTIVE_COMPANY_KEY, activeCompanyId.value)
        }
      }

    } catch (e) {
      console.error('[useCompany] Error:', e)
      error.value = 'Failed to load company information'
    } finally {
      loading.value = false
    }
  }, { immediate: true })

  // Switch active company
  function switchCompany(companyId: string) {
    if (!companies.value.find(c => c.id === companyId)) {
      console.warn('[useCompany] Cannot switch to company not in list:', companyId)
      return
    }
    activeCompanyId.value = companyId
    if (typeof window !== 'undefined') {
      localStorage.setItem(ACTIVE_COMPANY_KEY, companyId)
    }
  }

  return {
    // Active company (for backward compatibility)
    company,
    companyId: computed(() => activeCompanyId.value),
    
    // Multi-company support
    companies,
    switchCompany,
    
    // State
    loading,
    error
  }
}
