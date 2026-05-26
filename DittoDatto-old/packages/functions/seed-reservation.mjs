/**
 * Seed a test reservation into companies/{companyId}/reservations
 * Run with: node --experimental-specifier-resolution=node seed-reservation.mjs
 */
import { initializeApp, cert } from 'firebase-admin/app';
import { getFirestore } from 'firebase-admin/firestore';

// Initialize with default credentials (uses GOOGLE_APPLICATION_CREDENTIALS or gcloud auth)
initializeApp({ projectId: 'cs-poc-4zmxog23jmy4io0d4yx6rj0' });
const db = getFirestore();

const companyId = 'noZUoOEFBThXMj8YdCdq';
const storeId = 'c3ya7cUM2nccplsVCfGN'; // Fjell og Flamme

async function seed() {
  // First, fetch one table resource to assign
  const resourcesSnap = await db
    .collection(`companies/${companyId}/stores/${storeId}/resources`)
    .where('type', '==', 'table')
    .limit(1)
    .get();

  const tableId = resourcesSnap.empty ? null : resourcesSnap.docs[0].id;
  const tableName = resourcesSnap.empty ? 'none' : resourcesSnap.docs[0].data().name;
  console.log(`Found table: ${tableName} (${tableId})`);

  const now = new Date();
  const today = now.toISOString().slice(0, 10); // "2026-03-05"

  // Create 3 test reservations
  const reservations = [
    {
      storeId,
      companyId,
      customerName: 'Erik Hansen',
      customerPhone: '+4791234567',
      customerEmail: 'erik@example.com',
      guestCount: 4,
      date: new Date(`${today}T14:00:00`),
      time: '14:00',
      duration: 90,
      status: 'confirmed',
      notes: 'Vindu-bord ønskes',
      createdAt: now,
      updatedAt: now,
      confirmedAt: now,
      ...(tableId ? { tableId } : {}),
    },
    {
      storeId,
      companyId,
      customerName: 'Lise Andersen',
      customerPhone: '+4798765432',
      guestCount: 2,
      date: new Date(`${today}T17:30:00`),
      time: '17:30',
      duration: 120,
      status: 'confirmed',
      createdAt: now,
      updatedAt: now,
      confirmedAt: now,
      // No tableId — will show as "Ikke tildelt"
    },
    {
      storeId,
      companyId,
      customerName: 'Magnus Olsen',
      customerPhone: '+4741112233',
      customerEmail: 'magnus@test.no',
      guestCount: 6,
      date: new Date(`${today}T18:00:00`),
      time: '18:00',
      duration: 90,
      status: 'pending',
      notes: 'Bursdagsfeiring',
      createdAt: now,
      updatedAt: now,
      // No tableId — will show as "Ikke tildelt"
    },
  ];

  for (const res of reservations) {
    const ref = db.collection(`companies/${companyId}/reservations`).doc();
    await ref.set({ id: ref.id, ...res });
    console.log(`Created reservation: ${res.customerName} at ${res.time} (${ref.id})`);
  }

  console.log('\nDone! Refresh /reservations to see them.');
}

seed().catch(console.error);
