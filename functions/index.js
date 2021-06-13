const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.updateUser = functions.firestore
    .document('teams/{team}')
    .onUpdate((change, context) => {
    // Get an object representing the current document
    const newValue = change.after.data();
    // ...or the previous value before this update
    const previousValue = change.before.data();   
    if(newValue.score<previousValue.score){
        console.log(newValue)
        console.log(previousValue)
        return change.after.ref.set(previousValue, {merge: true});
    }
    //...therefore update the document as.
    // admin.firestore().collection('test').doc(docId).update(snapshot.after.data());

});
