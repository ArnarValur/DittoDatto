/**
 * Booking Received Email Template (Store Owner)
 *
 * Sent to the store owner when a new booking comes in.
 * Blue color scheme — informational / action tone.
 */
import { renderEmailLayout, EMAIL_COLORS } from "./base-layout";

export interface BookingReceivedEmailData {
  ownerName?: string;
  customerName: string;
  customerEmail: string;
  storeName: string;
  serviceTitle: string;
  date: string; // formatted
  time: string; // formatted
  duration: number; // in minutes
  price: string; // formatted
  bookingRef: string;
  /** Link to business portal bookings page */
  portalUrl?: string;
}

export function renderBookingReceivedEmail(
  data: BookingReceivedEmailData
): string {
  const greeting = data.ownerName
    ? `Hei <strong>${data.ownerName}</strong>!`
    : "Hei!";

  return renderEmailLayout({
    gradientFrom: EMAIL_COLORS.bookingReceived.from,
    gradientTo: EMAIL_COLORS.bookingReceived.to,
    headerTitle: "📅 Ny bestilling mottatt",
    bodyHtml: `
      <p style="font-size: 16px; line-height: 1.6; margin: 0 0 20px;">
        ${greeting} Du har mottatt en ny bestilling hos <strong>${data.storeName}</strong>.
      </p>

      <div style="background: #12122a; border-radius: 8px; padding: 16px; margin: 0 0 16px;">
        <table style="width: 100%; font-size: 14px; color: #ccc;" cellpadding="0" cellspacing="0">
          <tr>
            <td style="padding: 4px 0; color: #888;">👤 Kunde</td>
            <td style="padding: 4px 0; text-align: right; font-weight: 500;">${data.customerName}</td>
          </tr>
          <tr>
            <td style="padding: 4px 0; color: #888;">📧 E-post</td>
            <td style="padding: 4px 0; text-align: right; font-weight: 500;">${data.customerEmail}</td>
          </tr>

          <tr><td colspan="2" style="padding: 0;"><hr style="border: 1px solid #2d2d44; margin: 10px 0;" /></td></tr>

          <tr>
            <td style="padding: 4px 0; color: #888;">📅 Dato</td>
            <td style="padding: 4px 0; text-align: right; font-weight: 500;">${data.date}</td>
          </tr>
          <tr>
            <td style="padding: 4px 0; color: #888;">🕐 Tid</td>
            <td style="padding: 4px 0; text-align: right; font-weight: 500;">${data.time}</td>
          </tr>
          <tr>
            <td style="padding: 4px 0; color: #888;">✂️ Tjeneste</td>
            <td style="padding: 4px 0; text-align: right; font-weight: 500;">${data.serviceTitle}</td>
          </tr>
          <tr>
            <td style="padding: 4px 0; color: #888;">💰 Pris</td>
            <td style="padding: 4px 0; text-align: right; font-weight: 600; color: #3b82f6;">${data.price}</td>
          </tr>
        </table>

        <hr style="border: 1px solid #2d2d44; margin: 12px 0;" />

        <p style="margin: 0; font-size: 12px; color: #666;">
          Referanse: <strong style="color: #888;">${data.bookingRef}</strong>
        </p>
      </div>
    `,
    cta: data.portalUrl
      ? {
          label: "Åpne Bedriftsportalen",
          url: data.portalUrl,
          color: EMAIL_COLORS.bookingReceived.cta,
        }
      : undefined,
  });
}
