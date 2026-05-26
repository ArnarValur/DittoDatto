/**
 * Notifications Module
 *
 * Firestore triggers that create user-scoped notifications
 * stored at: users/{uid}/notifications/{notifId}
 *
 * Also sends transactional emails via firestore-send-email extension.
 *
 * Phase 1: Booking notifications only
 * Future: event reminders, broadcasts, system alerts, agent insights
 */
import { onDocumentCreated } from "firebase-functions/v2/firestore";
import { getFirestore, FieldValue } from "firebase-admin/firestore";
import { getAuth } from "firebase-admin/auth";
import { renderBookingConfirmedEmail } from "../emails/booking-confirmed";
import { renderBookingReceivedEmail } from "../emails/booking-received";

const db = getFirestore();

const PORTAL_URL =
  "https://portal.dittodatto.no";
const MARKETPLACE_URL =
  "https://dittodatto.no";

/**
 * When a new booking is created, notify + email:
 *  1. The customer — in-app (booking_reminder) + email (booking confirmed)
 *  2. The store owner — in-app (booking_received) + email (new booking received)
 *
 * Trigger: bookings/{bookingId} onCreate
 */
export const onBookingCreated = onDocumentCreated(
  { document: "bookings/{bookingId}", region: "europe-west1" },
  async (event) => {
    const snapshot = event.data;
    if (!snapshot) return;

    const booking = snapshot.data();
    const bookingId = event.params.bookingId;

    // Guard: must have a userId
    const userId = booking.userId;
    if (!userId) {
      console.warn(`[notifications] Booking ${bookingId} has no userId, skipping.`);
      return;
    }

    // --- Gather common data ---

    // Format time strings for notification body + emails
    const startTime = booking.startTime;
    let timeStr = "";
    let dateStr = "";
    let timeRangeStr = "";
    try {
      const d = typeof startTime === "string" ? new Date(startTime) : startTime?.toDate?.();
      if (d) {
        timeStr = d.toLocaleDateString("nb-NO", {
          weekday: "short",
          day: "numeric",
          month: "short",
        }) + " kl. " + d.toLocaleTimeString("nb-NO", {
          hour: "2-digit",
          minute: "2-digit",
          hour12: false,
        });

        // Full date for emails
        dateStr = d.toLocaleDateString("nb-NO", {
          weekday: "long",
          day: "numeric",
          month: "long",
          year: "numeric",
        });

        // Time range (start – end)
        const startStr = d.toLocaleTimeString("nb-NO", {
          hour: "2-digit",
          minute: "2-digit",
          hour12: false,
        });

        const endTime = booking.endTime;
        if (endTime) {
          const endD = typeof endTime === "string" ? new Date(endTime) : endTime?.toDate?.();
          if (endD) {
            const endStr = endD.toLocaleTimeString("nb-NO", {
              hour: "2-digit",
              minute: "2-digit",
              hour12: false,
            });
            timeRangeStr = `${startStr} – ${endStr}`;
          } else {
            timeRangeStr = startStr;
          }
        } else {
          timeRangeStr = startStr;
        }
      }
    } catch { /* fallback to empty */ }

    // Format price
    const price = booking.priceAtTimeOfBooking;
    const currency = booking.currency || "NOK";
    let priceStr = "";
    if (price != null) {
      try {
        priceStr = new Intl.NumberFormat("nb-NO", {
          style: "currency",
          currency,
        }).format(price);
      } catch {
        priceStr = `${currency} ${price}`;
      }
    }

    const customerName = booking.userName || "En kunde";
    const customerEmail = booking.userEmail || "";
    const storeName = booking.storeName || "";
    const serviceTitle = booking.serviceTitle || "Tjeneste";
    const duration = booking.duration || 0;

    // Fetch store address (nice-to-have for emails)
    let storeAddress = "";
    if (booking.companyId && booking.storeId) {
      try {
        const storeDoc = await db
          .collection("companies")
          .doc(booking.companyId)
          .collection("stores")
          .doc(booking.storeId)
          .get();
        if (storeDoc.exists) {
          const sd = storeDoc.data();
          storeAddress = sd?.address || sd?.location?.address || "";
        }
      } catch { /* non-critical */ }
    }

    const companyId = booking.companyId;
    let ownerId: string | null = null;
    let ownerEmail: string | null = null;
    let ownerName: string | null = null;

    if (companyId) {
      try {
        const companyDoc = await db.collection("companies").doc(companyId).get();
        if (companyDoc.exists) {
          ownerId = companyDoc.data()?.ownerId || null;
          console.log(`[notifications] Company ${companyId} ownerId: ${ownerId}`);
        } else {
          console.warn(`[notifications] Company ${companyId} not found in Firestore.`);
        }
      } catch (e) {
        console.warn(`[notifications] Failed to look up company ${companyId}:`, e);
      }

      // Fetch owner's email + name for the email
      if (ownerId) {
        try {
          const ownerRecord = await getAuth().getUser(ownerId);
          ownerEmail = ownerRecord.email || null;
          ownerName = ownerRecord.displayName || null;
        } catch {
          // Owner record might not exist
        }
      }
    }

    const batch = db.batch();

    // ═══════════════════════════════════════════════════
    // 0. CRM INTEGRATION (Auto-import customer based on booking)
    // ═══════════════════════════════════════════════════
    if (companyId) {
      const customerRef = db.collection("companies").doc(companyId).collection("customers").doc(userId);
      try {
        const custDoc = await customerRef.get();
        const nowIso = new Date().toISOString();
        if (!custDoc.exists) {
          batch.set(customerRef, {
            id: userId,
            companyId,
            userId,
            name: customerName,
            email: customerEmail || "",
            phone: booking.userPhone || "",
            channel: booking.channel || "app",
            status: "active",
            totalVisits: 1,
            storeIds: booking.storeId ? [booking.storeId] : [],
            lastBookingId: bookingId,
            firstVisitAt: startTime || nowIso,
            lastVisitAt: startTime || nowIso,
            createdAt: nowIso,
            updatedAt: nowIso
          });
        } else {
          batch.update(customerRef, {
             totalVisits: FieldValue.increment(1),
             storeIds: booking.storeId ? FieldValue.arrayUnion(booking.storeId) : [],
             lastBookingId: bookingId,
             lastVisitAt: startTime || nowIso,
             updatedAt: nowIso,
             status: "active"
          });
        }
      } catch (e) {
        console.error(`[notifications] Failed to upsert CRM customer ${userId}`, e);
      }
    }

    // ═══════════════════════════════════════════════════
    // 1. CUSTOMER — in-app notification + email
    // ═══════════════════════════════════════════════════

    // 1a. In-app notification
    const customerNotif = {
      type: "booking_reminder",
      title: serviceTitle || "Ny bestilling",
      body: timeStr
        ? `Din avtale er bekreftet for ${timeStr}`
        : "Din avtale er bekreftet",
      icon: "i-lucide-calendar-check",
      context: {
        bookingId,
        companyId: booking.companyId || null,
        storeId: booking.storeId || null,
      },
      isRead: false,
      isArchived: false,
      requiresAction: false,
      respondedBy: "system",
      createdAt: FieldValue.serverTimestamp(),
    };

    const customerNotifRef = db
      .collection("users")
      .doc(userId)
      .collection("notifications")
      .doc();
    batch.set(customerNotifRef, customerNotif);

    // 1b. Customer email (booking confirmation)
    if (customerEmail) {
      const customerMailRef = db.collection("mail").doc();
      batch.set(customerMailRef, {
        to: [customerEmail],
        message: {
          subject: `Bestilling bekreftet – ${serviceTitle}`,
          html: renderBookingConfirmedEmail({
            customerName,
            storeName: storeName || serviceTitle,
            storeAddress,
            serviceTitle,
            date: dateStr || "—",
            time: timeRangeStr || "—",
            duration,
            price: priceStr || "—",
            bookingRef: bookingId,
            bookingsUrl: `${MARKETPLACE_URL}/profile/bookings`,
          }),
        },
      });
      console.log(`[notifications] Booking confirmation email queued for ${customerEmail}`);
    }

    // ═══════════════════════════════════════════════════
    // 2. STORE OWNER — in-app notification + email
    // ═══════════════════════════════════════════════════

    if (!companyId) {
      console.warn(`[notifications] Booking ${bookingId} has no companyId — skipping owner notification.`);
    }

    if (ownerId && ownerId !== userId) {
      // 2a. In-app notification
      const ownerNotif = {
        type: "booking_received",
        title: storeName
          ? `Ny bestilling hos ${storeName}`
          : "Ny bestilling mottatt",
        body: timeStr
          ? `${customerName} har bestilt time ${timeStr}`
          : `${customerName} har bestilt en time`,
        icon: "i-lucide-calendar-plus",
        context: {
          bookingId,
          companyId: companyId || null,
          storeId: booking.storeId || null,
        },
        isRead: false,
        isArchived: false,
        requiresAction: false,
        respondedBy: "system",
        createdAt: FieldValue.serverTimestamp(),
      };

      const ownerNotifRef = db
        .collection("users")
        .doc(ownerId)
        .collection("notifications")
        .doc();
      batch.set(ownerNotifRef, ownerNotif);

      console.log(
        `[notifications] Created booking_received for owner ${ownerId}, booking ${bookingId}`
      );

      // 2b. Owner email (booking received)
      if (ownerEmail) {
        const ownerMailRef = db.collection("mail").doc();
        batch.set(ownerMailRef, {
          to: [ownerEmail],
          message: {
            subject: `Ny bestilling – ${customerName} hos ${storeName || serviceTitle}`,
            html: renderBookingReceivedEmail({
              ownerName: ownerName || undefined,
              customerName,
              customerEmail,
              storeName: storeName || serviceTitle,
              serviceTitle,
              date: dateStr || "—",
              time: timeRangeStr || "—",
              duration,
              price: priceStr || "—",
              bookingRef: bookingId,
              portalUrl: `${PORTAL_URL}/bookings`,
            }),
          },
        });
        console.log(`[notifications] Booking received email queued for owner ${ownerEmail}`);
      }
    } else if (ownerId && ownerId === userId) {
      console.log(`[notifications] Owner ${ownerId} is same as customer — skipping booking_received.`);
    } else if (!ownerId && companyId) {
      console.warn(`[notifications] Company ${companyId} has no ownerId — cannot notify owner.`);
    }

    // ═══════════════════════════════════════════════════
    // 3. BOOKING COMMENT THREAD (if customer left a note)
    // ═══════════════════════════════════════════════════

    if (booking.notes && booking.notes.trim()) {
      const participantIds = [userId];
      if (ownerId && ownerId !== userId) {
        participantIds.push(ownerId);
      }

      const now = new Date().toISOString();
      const threadRef = db.collection("threads").doc();

      // Create the thread
      batch.set(threadRef, {
        type: "booking_comment",
        mode: "human", // Default: human. Agent mode toggled by owner later.
        participantIds,
        companyId: companyId || null,
        storeId: booking.storeId || null,
        bookingId,
        subject: `${serviceTitle} – ${timeStr || "Bestilling"}`,
        lastMessagePreview: booking.notes.trim().slice(0, 100),
        unreadByUser: ownerId && ownerId !== userId
          ? { [ownerId]: 1 }
          : {},
        status: "open",
        lastMessageAt: now,
        lastMessageBy: userId,
        createdAt: now,
      });

      // Create the first message
      const messageRef = db.collection("messages").doc();
      batch.set(messageRef, {
        threadId: threadRef.id,
        senderId: userId,
        senderType: "user",
        content: booking.notes.trim(),
        createdAt: now,
      });

      console.log(
        `[notifications] Created booking_comment thread ${threadRef.id} for booking ${bookingId}`
      );
    }

    // Commit all notifications + emails + threads in a single batch
    await batch.commit();

    console.log(
      `[notifications] Created booking_reminder for user ${userId}, booking ${bookingId}`
    );
  }
);


