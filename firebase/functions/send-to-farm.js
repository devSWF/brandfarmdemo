// The Cloud Functions for Firebase SDK to create Cloud Functions and setup
// triggers.
const functions = require("firebase-functions");

// The Firebase Admin SDK to access Firestore.
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

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

      if (newData.fid.length > 0) {
        const fid = newData.fid;
        console.log("fid:", fid);
        return admin
            .firestore()
            .collection("Field")
            .doc(fid)
            .get()
            .then((snapshot) => {
              if (snapshot.exists) {
                console.log("sfmid:", snapshot.data().sfmid);
                return snapshot.data().sfmid;
              } else {
                console.log("field document is empty");
              }
            })
            .catch((error) => {
              return console.log(error);
            })
            .then((sfmid) => {
              return admin
                  .firestore()
                  .collection("User")
                  .doc(sfmid)
                  .get()
                  .then((snapshot) => {
                    if (snapshot.exists) {
                      console.log("fcmToken:", snapshot.data().fcmToken);
                      return admin
                          .messaging()
                          .sendToDevice(snapshot.data().fcmToken, payload)
                          .then((response) => {
                            return console
                                .log(
                                    "Notification sent successfully:",
                                    response.results[0].error
                                );
                          })
                          .catch((error) => {
                            return console
                                .log("Error Sending Notification", error);
                          });
                    } else {
                      console.log("user document is empty");
                    }
                  })
                  .catch((error) => {
                    return console.log(error);
                  });
            })
            .catch((error) => {
              return console.log(error);
            });
      } else {
        return console.log("Empty Token");
      }
    });
