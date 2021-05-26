// The Cloud Functions for Firebase SDK to create Cloud Functions and setup
// triggers.
const functions = require("firebase-functions");

// The Firebase Admin SDK to access Firestore.
const admin = require("firebase-admin");
admin.initializeApp(functions.config().firebase);

let newData;

exports.pushNotification = functions.firestore
    .document("/Notification/{notid}")
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
          click_action: "FLUTTER_NOTIFICATION_CLICK",
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
        const farmid = newData.farmid;
        console.log("farmid:", farmid);
        return admin
            .firestore()
            .collection("Farm")
            .doc(farmid)
            .get()
            .then((snapshot) => {
              if (snapshot.exists) {
                return snapshot.data().fieldCategory;
              } else {
                console.log("Farm document is empty");
              }
            })
            .catch((error) => {
              return console.log(error);
            })
            .then((fieldCategory) => {
              console.log("fieldCategory:", fieldCategory);
              return admin
                  .firestore()
                  .collection("Field")
                  .where("fieldCategory", "==", fieldCategory)
                  .get()
                  .then((querySnapshot) => {
                    if (querySnapshot.empty) {
                      console.log("Field documents are empty");
                    } else {
                      console.log("querySnapshot length:",
                          querySnapshot.docs.length);
                      const flist = [];
                      querySnapshot.docs.forEach((snapshot) => {
                        if (snapshot.exists) {
                          flist.push(snapshot.data().sfmid);
                        } else {
                          console.log("Empty Document");
                        }
                      });
                      return flist;
                    }
                  })
                  .catch((error) => {
                    return console.log(error);
                  })
                  .then((flist) => {
                    console.log("flist length:", flist.length);
                    console.log(flist);
                    const tokens = [];
                    for (const sfmid of flist) {
                      console.log("sfmid exists:", sfmid);
                      const user = admin
                          .firestore()
                          .collection("User")
                          .doc(sfmid)
                          .get()
                          .then((snapshot) => {
                            if (snapshot.exists) {
                              if (snapshot.data().fcmToken.length > 0) {
                                return snapshot.data().fcmToken;
                              } else {
                                console.log("Empty token");
                                return "";
                              }
                            } else {
                              console.log("User document is empty");
                            }
                          })
                          .catch((error) => {
                            return console.log(error);
                          });
                      tokens.push(user);
                    }
                    return Promise.all(tokens);
                  })
                  .catch((error) => {
                    return console.log(error);
                  })
                  .then((tokens) => {
                    console.log("token list:", tokens);
                    const fcmTokens = [];
                    if (tokens.length > 0) {
                      for (const token of tokens) {
                        if (token.length > 0) {
                          fcmTokens.push(token);
                        } else {
                          console.log("Empty token from token list");
                        }
                      }
                    } else {
                      console.log("token list is empty");
                    }
                    return fcmTokens;
                  })
                  .catch((error) => {
                    return console.log(error);
                  })
                  .then((fcmTokens) => {
                    return admin
                        .messaging()
                        .sendToDevice(fcmTokens, payload)
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
                  });
            })
            .catch((error) => {
              return console.log(error);
            });
      }
    });
