/**
 * DittoDatto Email Base Layout
 *
 * Shared brand wrapper for all transactional emails.
 * Inline CSS only — email clients strip <style> blocks.
 *
 * Color schemes per email type:
 *   staff_invite:      purple (#6366f1 → #8b5cf6)
 *   booking_confirmed: green  (#10b981 → #059669)
 *   booking_received:  blue   (#3b82f6 → #2563eb)
 *   system_alert:      gray   (#374151 → #1f2937)
 */

export interface EmailLayoutOptions {
  /** Gradient start color (hex) */
  gradientFrom: string;
  /** Gradient end color (hex) */
  gradientTo: string;
  /** Header title (can include emoji) */
  headerTitle: string;
  /** Main body HTML content */
  bodyHtml: string;
  /** Optional CTA button */
  cta?: {
    label: string;
    url: string;
    color: string; // button background color
  };
  /** Optional footer note (replaces default) */
  footerNote?: string;
}

/**
 * Wraps email content in the DittoDatto brand template.
 */
export function renderEmailLayout(opts: EmailLayoutOptions): string {
  const ctaHtml = opts.cta
    ? `
      <div style="text-align: center; margin: 24px 0;">
        <a href="${opts.cta.url}"
           style="background: ${opts.cta.color}; color: white; padding: 12px 32px; border-radius: 8px; text-decoration: none; font-weight: 600; display: inline-block; font-size: 15px;">
          ${opts.cta.label}
        </a>
      </div>
    `
    : "";

  const footer =
    opts.footerNote ||
    "Denne e-posten ble sendt automatisk fra DittoDatto. Du kan ikke svare direkte på denne meldingen.";

  return `
    <div style="font-family: 'Inter', 'Segoe UI', Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 0;">
      <div style="background: linear-gradient(135deg, ${opts.gradientFrom}, ${opts.gradientTo}); padding: 32px 24px; border-radius: 12px 12px 0 0; text-align: center;">
        <h1 style="color: white; margin: 0; font-size: 24px; font-weight: 700;">${opts.headerTitle}</h1>
      </div>
      <div style="background: #1a1a2e; color: #e0e0e0; padding: 24px; border-radius: 0 0 12px 12px;">
        ${opts.bodyHtml}
        ${ctaHtml}
        <hr style="border: 1px solid #2d2d44; margin: 24px 0;" />
        <p style="color: #666; font-size: 11px; text-align: center; margin: 0;">
          ${footer}
        </p>
      </div>
    </div>
  `;
}

// Pre-defined color schemes
export const EMAIL_COLORS = {
  staffInvite: { from: "#6366f1", to: "#8b5cf6", cta: "#6366f1" },
  bookingConfirmed: { from: "#10b981", to: "#059669", cta: "#10b981" },
  bookingReceived: { from: "#3b82f6", to: "#2563eb", cta: "#3b82f6" },
  systemAlert: { from: "#374151", to: "#1f2937", cta: "#374151" },
} as const;
