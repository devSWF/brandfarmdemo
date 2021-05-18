importScripts("https://www.gstatic.com/firebasejs/8.2.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.4.1/firebase-messaging.js");
firebase.initializeApp({
    apiKey: "AIzaSyDNyF9_FegNtMap9BT3gEJBSTKznmaYoBM",
    authDomain: "brandfarm-53588.firebaseapp.com",
    projectId: "brandfarm-53588",
    storageBucket: "brandfarm-53588.appspot.com",
    messagingSenderId: "329825017618",
    appId: "1:329825017618:web:d4b5c7102041b3b7e81dcb",
    measurementId: "G-HLEXYE3MYL"
});
const messaging = firebase.messaging();
messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            return registration.showNotification("New Message");
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});