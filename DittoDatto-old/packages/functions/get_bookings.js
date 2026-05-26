const admin = require("firebase-admin");
const path = require("path");
// Initialize using standard service account if needed, or default if running in emulator
process.env.FIRESTORE_EMULATOR_HOST = "127.0.0.1:8080";
admin.initializeApp({ projectId: "demo-dittodatto" });

async function getRecentBookings() {
   const db = admin.firestore();
   const snapshot = await db.collection("bookings").orderBy("createdAt", "desc").limit(5).get();
   snapshot.forEach(doc => {
     console.log(doc.id, "=>", doc.data().status, "paymentId:", doc.data().paymentId);
   });
}
getRecentBookings().catch(console.error);
