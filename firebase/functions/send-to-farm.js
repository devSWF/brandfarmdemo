// The Cloud Functions for Firebase SDK to create Cloud Functions and setup
// triggers.
const functions = require("firebase-functions");

// The Firebase Admin SDK to access Firestore.
const admin = require("firebase-admin");
if (!admin.apps.length) {
  admin.initializeApp(functions.config().firebase);
}

let newData;

exports.pushNotification = functions.firestore
    .document("/SendToFarm/{docID}")
    .onCreate((snapshot, context) => {
      if (snapshot.empty) {
        return console.log("No Data Available");
      }

      newData = snapshot.data();
      const payload = {
        notification: {
          title: newData.title,
          body: newData.content,
          sound: "default",
        },
        data: {
          message: newData.content,
        },
      };

      return admin
          .messaging()
          .sendToDevice(newData.fcmToken, payload)
          .then((response) => {
            return console.log("Notification Sent Successful");
          })
          .catch((error) => {
            return console.log(error);
          });
    });