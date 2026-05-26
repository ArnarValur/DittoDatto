/**
 * BankID Composable — Scaffold (Not Yet Implemented)
 *
 * PostIt: This composable is a placeholder for Norwegian BankID integration.
 * BankID will be used for legal identity verification of:
 * - Public users (optional, for age-restricted services)
 * - Business users (required for business registration)
 * - Business owners (required for company ownership verification)
 *
 * Implementation requires a service provider contract with one of:
 * - Signicat (https://www.signicat.com)
 * - Criipto (https://www.criipto.com)
 * - BankID Norge (https://www.bankid.no)
 *
 * The typical flow:
 * 1. User clicks "Verify with BankID"
 * 2. Redirect to BankID provider (OIDC/OAuth2 flow)
 * 3. User authenticates with their bank
 * 4. Callback with identity token (national ID, name, DOB)
 * 5. Link to Firebase Auth account via custom token
 *
 * @see https://www.bankid.no/en/developers/
 */

export interface BankIDVerificationResult {
  verified: boolean
  nationalId?: string // Norwegian fødselsnummer (11 digits)
  fullName?: string
  dateOfBirth?: string // ISO date
  provider?: string // Which bank was used
  timestamp?: string // When verification occurred
}

export interface BankIDConfig {
  clientId: string
  redirectUri: string
  environment: 'test' | 'production'
}

/**
 * PostIt: Uncomment and implement when BankID provider contract is signed.
 */
export function useBankID() {
  const verified = ref(false)
  const loading = ref(false)
  const error = ref<string | null>(null)

  /**
   * TODO: Initialize BankID OIDC client
   */
  async function initBankID(_config?: BankIDConfig): Promise<void> {
    error.value = 'BankID integration is not yet available.'
    console.warn('[useBankID] Not implemented — requires service provider contract')
  }

  /**
   * TODO: Start BankID verification flow (redirect to BankID provider)
   */
  async function verifyIdentity(): Promise<BankIDVerificationResult> {
    error.value = 'BankID integration is not yet available.'
    return { verified: false }
  }

  /**
   * TODO: Check if user has a verified BankID on record
   */
  async function getVerificationStatus(): Promise<BankIDVerificationResult> {
    return { verified: false }
  }

  return {
    verified: readonly(verified),
    loading: readonly(loading),
    error: readonly(error),
    initBankID,
    verifyIdentity,
    getVerificationStatus
  }
}
