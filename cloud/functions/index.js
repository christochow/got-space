const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp(functions.config().firebase);
const db = admin.firestore();

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
exports.getSchools = functions.https.onRequest(async (request, response) => {
 const data = await db.collection('schools').get();
 response.send(JSON.stringify(data.docs.map(e=>e.id)));
});

