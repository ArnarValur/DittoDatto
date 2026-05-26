import * as admin from 'firebase-admin';

// Initialize Admin SDK
// Make sure GOOGLE_APPLICATION_CREDENTIALS is set, or running locally with gcloud auth application-default login
if (!admin.apps.length) {
  admin.initializeApp();
}

async function restoreAdmin() {
  const email = 'arnarvalur@avj.info';
  try {
    const user = await admin.auth().getUserByEmail(email);
    const existingClaims = user.customClaims || {};
    
    console.log('Current claims:', existingClaims);
    
    const newClaims = {
      ...existingClaims,
      role: 'super_admin'
    };
    
    await admin.auth().setCustomUserClaims(user.uid, newClaims);
    console.log('Successfully restored super_admin claim for', email);
    
    // Also update Firestore users profile
    await admin.firestore().collection('users').doc(user.uid).set({
      role: 'super_admin'
    }, { merge: true });
    
    console.log('Updated firestore user role to super_admin.');
  } catch (err) {
    console.error('Error restoring admin claim:', err);
  }
}

restoreAdmin().then(() => process.exit(0));
