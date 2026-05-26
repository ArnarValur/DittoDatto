/**
 * Check Mail Delivery Status
 *
 * Reads the last 5 docs from the `mail` collection and prints their delivery status.
 * Usage: npx tsx scripts/check-mail.ts
 */
import { initializeApp } from 'firebase-admin/app'
import { getFirestore } from 'firebase-admin/firestore'

const app = initializeApp({ projectId: 'cs-poc-4zmxog23jmy4io0d4yx6rj0' })
const db = getFirestore(app)

async function checkMail() {
  const snap = await db.collection('mail')
    .orderBy('delivery.startTime', 'desc')
    .limit(5)
    .get()

  if (snap.empty) {
    // Fallback: no delivery field yet, get by creation order
    const snap2 = await db.collection('mail').limit(10).get()
    console.log(`Found ${snap2.size} mail docs (no delivery timestamps yet):\n`)
    snap2.forEach(doc => {
      const d = doc.data()
      console.log(`📧 ${doc.id}`)
      console.log(`   to:       ${JSON.stringify(d.to)}`)
      console.log(`   subject:  ${d.message?.subject}`)
      console.log(`   delivery: ${JSON.stringify(d.delivery ?? 'NOT PROCESSED YET')}`)
      console.log()
    })
    return
  }

  console.log(`Last ${snap.size} processed mail docs:\n`)
  snap.forEach(doc => {
    const d = doc.data()
    const delivery = d.delivery ?? {}
    const state = delivery.state ?? 'PENDING'
    const icon = state === 'SUCCESS' ? '✅' : state === 'ERROR' ? '❌' : '⏳'
    console.log(`${icon} ${doc.id}`)
    console.log(`   to:      ${JSON.stringify(d.to)}`)
    console.log(`   subject: ${d.message?.subject}`)
    console.log(`   state:   ${state}`)
    if (delivery.error) console.log(`   error:   ${delivery.error}`)
    if (delivery.endTime) console.log(`   endTime: ${delivery.endTime.toDate?.() ?? delivery.endTime}`)
    console.log()
  })
}

checkMail().catch(console.error)
