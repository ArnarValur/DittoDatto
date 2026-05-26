/**
 * useInboxHelpers — Display utilities for notifications and threads
 *
 * Pure functions for icon/color/label mapping and time formatting.
 * Shared between inbox page and any future notification components.
 */
export function useInboxHelpers() {
  // ── Notification helpers ──────────────────────────

  function getNotifIcon(type: string): string {
    const map: Record<string, string> = {
      booking_received: 'i-lucide-calendar-plus',
      booking_reminder: 'i-lucide-calendar-check',
      booking_change: 'i-lucide-calendar-clock',
      staff_invite: 'i-lucide-user-plus',
      staff_claimed: 'i-lucide-user-check',
      staff_update: 'i-lucide-users',
      system_alert: 'i-lucide-bell',
      agent_insight: 'i-lucide-sparkles',
    }
    return map[type] || 'i-lucide-bell'
  }

  function getNotifColor(type: string): string {
    const map: Record<string, string> = {
      booking_received: 'text-green-500',
      booking_reminder: 'text-blue-500',
      booking_change: 'text-amber-500',
      staff_invite: 'text-purple-500',
      staff_claimed: 'text-emerald-500',
      staff_update: 'text-purple-500',
      system_alert: 'text-gray-500',
      agent_insight: 'text-cyan-500',
    }
    return map[type] || 'text-gray-500'
  }

  function getNotifBgColor(type: string, isRead: boolean): string {
    if (isRead) return 'bg-gray-100 dark:bg-gray-800'
    const map: Record<string, string> = {
      booking_received: 'bg-green-100 dark:bg-green-900/30',
      booking_reminder: 'bg-blue-100 dark:bg-blue-900/30',
      booking_change: 'bg-amber-100 dark:bg-amber-900/30',
      staff_invite: 'bg-purple-100 dark:bg-purple-900/30',
      staff_claimed: 'bg-emerald-100 dark:bg-emerald-900/30',
      system_alert: 'bg-gray-100 dark:bg-gray-800',
    }
    return map[type] || 'bg-primary-100 dark:bg-primary-900/30'
  }

  function getTypeLabel(type: string): string {
    const map: Record<string, string> = {
      booking_received: 'Bestilling mottatt',
      booking_reminder: 'Bestillingspåminnelse',
      booking_change: 'Bestillingsendring',
      staff_invite: 'Personalinvitasjon',
      staff_claimed: 'Invitasjon akseptert',
      staff_update: 'Personaloppdatering',
      system_alert: 'Systemvarsel',
      agent_insight: 'AI-innsikt',
    }
    return map[type] || type
  }

  // ── Thread helpers ────────────────────────────────

  function getThreadIcon(type: string): string {
    const map: Record<string, string> = {
      booking_comment: 'i-lucide-message-square',
      inquiry: 'i-lucide-help-circle',
      support: 'i-lucide-life-buoy',
      feedback: 'i-lucide-message-circle',
    }
    return map[type] || 'i-lucide-message-square'
  }

  function getThreadColor(type: string): string {
    const map: Record<string, string> = {
      booking_comment: 'text-green-500',
      inquiry: 'text-blue-500',
      support: 'text-amber-500',
      feedback: 'text-purple-500',
    }
    return map[type] || 'text-primary-500'
  }

  function getThreadTypeLabel(type: string): string {
    const map: Record<string, string> = {
      booking_comment: 'Bestillingskommentar',
      inquiry: 'Henvendelse',
      support: 'Støtte',
      feedback: 'Tilbakemelding',
    }
    return map[type] || type
  }

  // ── Time helpers ──────────────────────────────────

  function relativeTime(iso: string | Date | { seconds: number; nanoseconds: number } | null): string {
    if (!iso) return ''
    let then: number
    if (typeof iso === 'string') {
      then = new Date(iso).getTime()
    } else if (iso instanceof Date) {
      then = iso.getTime()
    } else if ('seconds' in iso) {
      then = iso.seconds * 1000
    } else {
      return ''
    }
    const now = Date.now()
    const diff = now - then
    const mins = Math.floor(diff / 60000)
    if (mins < 1) return 'Akkurat nå'
    if (mins < 60) return `${mins}m siden`
    const hours = Math.floor(mins / 60)
    if (hours < 24) return `${hours}t siden`
    const days = Math.floor(hours / 24)
    if (days < 7) return `${days}d siden`
    return new Date(then).toLocaleDateString('nb-NO', { day: 'numeric', month: 'short' })
  }

  function formatFullDate(iso: string | null): string {
    if (!iso) return ''
    return new Date(iso).toLocaleDateString('nb-NO', {
      weekday: 'long',
      year: 'numeric',
      month: 'long',
      day: 'numeric',
      hour: '2-digit',
      minute: '2-digit',
    })
  }

  return {
    // Notification
    getNotifIcon,
    getNotifColor,
    getNotifBgColor,
    getTypeLabel,
    // Thread
    getThreadIcon,
    getThreadColor,
    getThreadTypeLabel,
    // Time
    relativeTime,
    formatFullDate,
  }
}
