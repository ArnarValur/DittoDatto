/**
 * Resend Failed Emails
 *
 * Finds all ERROR state mail docs and re-queues them by creating
 * new mail docs with the same to/message content.
 *
 * Usage: npx tsx scripts/resend-failed.ts
 */
import { initializeApp } from 'firebase-admin/app'
import { getFirestore } from 'firebase-admin/firestore'

const app = initializeApp({ projectId: 'cs-poc-4zmxog23jmy4io0d4yx6rj0' })
const db = getFirestore(app)

async function resendFailed() {
  const snap = await db.collection('mail')
    .where('delivery.state', '==', 'ERROR')
    .get()

  if (snap.empty) {
    console.log('✅ No failed emails to resend.')
    return
  }

  console.log(`Found ${snap.size} failed email(s). Re-queuing...\n`)

  const batch = db.batch()

  for (const doc of snap.docs) {
    const data = doc.data()
    const newRef = db.collection('mail').doc()

    // Create fresh mail doc (extension picks up docs without delivery field)
    batch.set(newRef, {
      to: data.to,
      message: data.message,
    })

    console.log(`📧 ${doc.id} → ${newRef.id}`)
    console.log(`   to:      ${JSON.stringify(data.to)}`)
    console.log(`   subject: ${data.message?.subject}\n`)
  }

  await batch.commit()
  console.log(`\n✅ Re-queued ${snap.size} email(s). Extension will attempt delivery.`)
}

resendFailed().catch(console.error)
