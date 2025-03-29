importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/9.10.0/firebase-messaging-compat.js");

firebase.initializeApp({
  apiKey: "AIzaSyBRqCSSVpEh2dL2I2aLrLSOta-tV1YHBdY",
  authDomain: "nutridiet-83fa5.firebaseapp.com",
  projectId: "nutridiet-83fa5",
  storageBucket: "nutridiet-83fa5.firebasestorage.app",
  messagingSenderId: "552250045512",
  appId: "1:552250045512:android:06e8a08129c2ccfa66147d"
});

const messaging = firebase.messaging();

messaging.onBackgroundMessage(function(payload) {
  console.log('Received background message: ', payload);
  const notificationTitle = payload.notification.title;
  const notificationOptions = {
    body: payload.notification.body,
    icon: payload.notification.icon,
  };

  self.registration.showNotification(notificationTitle, notificationOptions);
});