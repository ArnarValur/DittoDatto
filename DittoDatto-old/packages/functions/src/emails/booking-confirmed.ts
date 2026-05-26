/**
 * Booking Confirmed Email Template (Customer)
 *
 * Sent to the customer after their booking is confirmed.
 * Green color scheme — positive confirmation tone.
 */
import { renderEmailLayout, EMAIL_COLORS } from "./base-layout";

export interface BookingConfirmedEmailData {
  customerName: string;
  storeName: string;
  storeAddress?: string;
  serviceTitle: string;
  date: string; // formatted, e.g. "fredag 20. februar 2026"
  time: string; // formatted, e.g. "10:00 – 12:00"
  duration: number; // in minutes
  price: string; // formatted, e.g. "NOK 1 990,00"
  bookingRef: string; // booking ID
  /** Link to user's bookings page */
  bookingsUrl?: string;
}

export function renderBookingConfirmedEmail(
  data: BookingConfirmedEmailData
): string {
  const addressLine = data.storeAddress
    ? `<p style="color: #888; font-size: 13px; margin: 4px 0 0;">${data.storeAddress}</p>`
    : "";

  return renderEmailLayout({
    gradientFrom: EMAIL_COLORS.bookingConfirmed.from,
    gradientTo: EMAIL_COLORS.bookingConfirmed.to,
    headerTitle: "✅ Bestilling bekreftet!",
    bodyHtml: `
      <p style="font-size: 16px; line-height: 1.6; margin: 0 0 20px;">
        Hei <strong>${data.customerName}</strong>! Din bestilling er bekreftet.
      </p>

      <div style="background: #12122a; border-radius: 8px; padding: 16px; margin: 0 0 16px;">
        <p style="margin: 0 0 4px; font-size: 15px; font-weight: 600; color: #fff;">
          ${data.storeName}
        </p>
        ${addressLine}

        <hr style="border: 1px solid #2d2d44; margin: 12px 0;" />

        <table style="width: 100%; font-size: 14px; color: #ccc;" cellpadding="0" cellspacing="0">
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
            <td style="padding: 4px 0; text-align: right; font-weight: 600; color: #10b981;">${data.price}</td>
          </tr>
        </table>

        <hr style="border: 1px solid #2d2d44; margin: 12px 0;" />

        <p style="margin: 0; font-size: 12px; color: #666;">
          Referanse: <strong style="color: #888;">${data.bookingRef}</strong>
        </p>
      </div>
    `,
    cta: data.bookingsUrl
      ? {
          label: "Se mine bestillinger",
          url: data.bookingsUrl,
          color: EMAIL_COLORS.bookingConfirmed.cta,
        }
      : undefined,
  });
}
