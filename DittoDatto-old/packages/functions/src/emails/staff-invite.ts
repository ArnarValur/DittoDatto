/**
 * Staff Invite Email Template
 *
 * Sent when a business owner invites someone to their company.
 * Uses the shared brand layout with purple color scheme.
 */
import { renderEmailLayout, EMAIL_COLORS } from "./base-layout";

export interface StaffInviteEmailData {
  companyName: string;
  roleName: string;
  portalUrl: string;
  /** Whether the invited user already has an account */
  hasExistingAccount: boolean;
}

export function renderStaffInviteEmail(data: StaffInviteEmailData): string {
  const accountNote = data.hasExistingAccount
    ? "Logg inn med din eksisterende konto for å akseptere invitasjonen."
    : "Opprett en konto med denne e-postadressen for å komme i gang.";

  return renderEmailLayout({
    gradientFrom: EMAIL_COLORS.staffInvite.from,
    gradientTo: EMAIL_COLORS.staffInvite.to,
    headerTitle: "🎉 Du er invitert!",
    bodyHtml: `
      <p style="font-size: 16px; line-height: 1.6; margin: 0 0 16px;">
        Hei! Du har blitt invitert til <strong>${data.companyName}</strong>
        som <strong>${data.roleName}</strong> på DittoDatto-plattformen.
      </p>
      <p style="color: #888; font-size: 13px; margin: 0;">
        ${accountNote}
      </p>
    `,
    cta: {
      label: "Åpne Bedriftsportalen",
      url: data.portalUrl,
      color: EMAIL_COLORS.staffInvite.cta,
    },
    footerNote:
      "Denne e-posten ble sendt fra DittoDatto. Hvis du ikke forventet denne invitasjonen, kan du se bort fra denne meldingen.",
  });
}
