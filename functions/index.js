const functions = require("firebase-functions");
const admin = require('firebase-admin');

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
        console.log(newValue.score)
        console.log(previousValue.score)
        return change.after.ref.set(previousValue, {merge: true});
    }else{
        let diff = newValue.score-previousValue.score;
        //Our logic relies on the diff, and assumes thats the new score from the user,
        //but Sometimes when an updates comes from a old cache, the diff is huge, so added a check less than 12
        if(diff >0 && diff <12){
            newValue.weekscore=newValue.weekscore+diff;
            return change.after.ref.set(newValue,{merge:true});
        }
    }
    //...therefore update the document as.
    // admin.firestore().collection('test').doc(docId).update(snapshot.after.data());

});
admin.initializeApp();

exports.scheduledFunction = functions.pubsub.schedule('0 0 * * 1')
.timeZone('Asia/Kolkata')
.onRun(async (context) => {
    const cSnap = await admin.firestore().collection('teams').get();
    const batch = admin.firestore().batch();
    let maxscore =0;
    let maxid='';
    let championship=0;
    cSnap.forEach(docSnap => {
        if (!docSnap.data()) { return; }
        if(docSnap.data().weekscore>maxscore){
            maxscore=docSnap.data().weekscore;
            maxid=docSnap.id;
            championship=docSnap.data().championship
        }
        const ref = admin.firestore().doc(`teams/${docSnap.id}`);
        batch.update(ref,{weekscore:0});
       
    });
    if(maxid){
        console.log(`Max score: ${maxscore} ${maxid}`);
        cSnap.forEach(docSnap => {
            const ref = admin.firestore().doc(`teams/${docSnap.id}`);
            if( docSnap.id ==maxid){
                batch.update(ref,{championship:championship+1,champion:true});
            }else{
                batch.update(ref,{champion:false});
            }
        });
    }   
   
    batch.commit();
    return null;
  });
