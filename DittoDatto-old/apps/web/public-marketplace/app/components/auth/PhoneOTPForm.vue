<script setup lang="ts">
/**
 * PhoneOTPForm Component
 *
 * Two-step phone authentication:
 * 1. Enter phone number → send OTP
 * 2. Enter verification code → verify
 *
 * Requires a #recaptcha-container element in the parent layout.
 */
const { signInWithPhone, verifyPhoneOTP, loading, error, phoneVerificationId, cleanupRecaptcha } = useAuth()

const emit = defineEmits<{
  success: [user: unknown]
  'needs-profile': [user: unknown]
}>()

const phoneNumber = ref('+47')
const otpCode = ref('')
const codeSent = ref(false)
const resendTimer = ref(0)
let resendInterval: ReturnType<typeof setInterval> | null = null

async function handleSendCode() {
  try {
    await signInWithPhone(phoneNumber.value)
    codeSent.value = true
    startResendTimer()
  } catch {
    // Error handled by useAuth
  }
}

async function handleVerifyCode() {
  try {
    const user = await verifyPhoneOTP(otpCode.value)
    emit('success', user)
  } catch {
    // Error handled by useAuth — code stays visible for retry
  }
}

function startResendTimer() {
  resendTimer.value = 60
  if (resendInterval) clearInterval(resendInterval)
  resendInterval = setInterval(() => {
    resendTimer.value--
    if (resendTimer.value <= 0 && resendInterval) {
      clearInterval(resendInterval)
    }
  }, 1000)
}

async function handleResend() {
  codeSent.value = false
  otpCode.value = ''
  cleanupRecaptcha()
  await nextTick()
  await handleSendCode()
}

function handleBack() {
  codeSent.value = false
  otpCode.value = ''
  cleanupRecaptcha()
}

onUnmounted(() => {
  if (resendInterval) clearInterval(resendInterval)
  cleanupRecaptcha()
})
</script>

<template>
  <div class="space-y-4">
    <!-- Step 1: Phone number input -->
    <div v-if="!codeSent" class="space-y-4">
      <div class="text-center mb-2">
        <UIcon name="i-lucide-smartphone" class="text-3xl text-primary mb-2" />
        <p class="text-sm text-muted">
          We'll send a verification code to your phone
        </p>
      </div>

      <UFormField label="Phone number">
        <UInput
          v-model="phoneNumber"
          type="tel"
          placeholder="+47 XXX XX XXX"
          size="lg"
          :ui="{ base: 'font-mono tracking-wider' }"
          @keydown.enter="handleSendCode"
        />
      </UFormField>

      <UButton
        block
        size="lg"
        :loading="loading"
        :disabled="phoneNumber.length < 10"
        @click="handleSendCode"
      >
        <UIcon name="i-lucide-send" class="mr-2" />
        Send Code
      </UButton>
    </div>

    <!-- Step 2: OTP code input -->
    <div v-else class="space-y-4">
      <div class="text-center mb-2">
        <UIcon name="i-lucide-shield-check" class="text-3xl text-primary mb-2" />
        <p class="text-sm text-muted">
          Enter the 6-digit code sent to
        </p>
        <p class="font-mono font-semibold text-sm">{{ phoneNumber }}</p>
      </div>

      <UFormField label="Verification code">
        <UInput
          v-model="otpCode"
          type="text"
          inputmode="numeric"
          placeholder="000000"
          maxlength="6"
          size="lg"
          autocomplete="one-time-code"
          :ui="{ base: 'text-center font-mono tracking-[0.5em] text-xl' }"
          @keydown.enter="handleVerifyCode"
        />
      </UFormField>

      <UButton
        block
        size="lg"
        :loading="loading"
        :disabled="otpCode.length !== 6"
        @click="handleVerifyCode"
      >
        <UIcon name="i-lucide-check-circle" class="mr-2" />
        Verify Code
      </UButton>

      <div class="flex items-center justify-between text-sm">
        <button
          class="text-muted hover:text-primary transition-colors"
          @click="handleBack"
        >
          ← Change number
        </button>

        <button
          v-if="resendTimer <= 0"
          class="text-primary hover:underline"
          @click="handleResend"
        >
          Resend code
        </button>
        <span v-else class="text-muted tabular-nums">
          Resend in {{ resendTimer }}s
        </span>
      </div>
    </div>

    <!-- Error display -->
    <div v-if="error" class="p-3 rounded-lg bg-error/10 text-error text-sm text-center">
      {{ error }}
    </div>
  </div>
</template>
