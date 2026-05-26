/**
 * Test Email Extension
 * 
 * Writes a test document to the `mail` collection to verify
 * the firestore-send-email extension is working.
 * 
 * Usage: npx tsx scripts/test-email.ts
 */
import { initializeApp, cert } from 'firebase-admin/app'
import { getFirestore } from 'firebase-admin/firestore'

// Initialize with default credentials (uses GOOGLE_APPLICATION_CREDENTIALS or gcloud auth)
const app = initializeApp({
  projectId: 'cs-poc-4zmxog23jmy4io0d4yx6rj0',
})

const db = getFirestore(app)

async function sendTestEmail() {
  const recipient = 'arnarvalur@avj.info' // Captain's email for verification
  
  console.log(`📧 Writing test email doc to 'mail' collection...`)
  console.log(`   To: ${recipient}`)
  console.log(`   From: noreply@dittodatto.no (extension default)`)
  
  const mailRef = await db.collection('mail').add({
    to: [recipient],
    message: {
      subject: '🧪 DittoDatto Email Extension Test',
      html: `
        <div style="font-family: 'Inter', Arial, sans-serif; max-width: 600px; margin: 0 auto; padding: 24px;">
          <div style="background: linear-gradient(135deg, #10b981, #059669); padding: 24px; border-radius: 12px 12px 0 0; text-align: center;">
            <h1 style="color: white; margin: 0; font-size: 24px;">✅ Extension Working!</h1>
          </div>
          <div style="background: #1a1a2e; color: #e0e0e0; padding: 24px; border-radius: 0 0 12px 12px;">
            <p>This is a test email from the <strong>firestore-send-email</strong> extension.</p>
            <p><strong>Project:</strong> DittoDattoNo (cs-poc-4zmxog23jmy4io0d4yx6rj0)</p>
            <p><strong>Collection:</strong> mail</p>
            <p><strong>Timestamp:</strong> ${new Date().toISOString()}</p>
            <hr style="border: 1px solid #333; margin: 16px 0;" />
            <p style="color: #888; font-size: 12px;">If you received this, the SMTP relay is correctly configured. 🖖</p>
          </div>
        </div>
      `,
    },
  })

  console.log(`✅ Mail doc created: ${mailRef.id}`)
  console.log(`   The extension will now pick it up and attempt delivery.`)
  console.log(`   Check the doc at: mail/${mailRef.id} for delivery status.`)
  console.log(``)
  console.log(`   Expected fields after processing:`)
  console.log(`   - delivery.state: "SUCCESS" or "ERROR"`)
  console.log(`   - delivery.error: (if failed)`)
  console.log(`   - delivery.endTime: (when processed)`)
}

sendTestEmail().catch(console.error)
