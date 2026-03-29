const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNotificationOnNewDocument = functions.firestore
    .document('notifications/{notificationId}')
    .onCreate(async (snap, context) => {
      const notificationData = snap.data();

      const receiverId = notificationData.receiverId;
      const title = notificationData.title || 'إشعار جديد';
      const body = notificationData.body || '';

      if (!receiverId) {
        return console.log('لا يوجد رقم مستلم (receiverId) للتنبيه.');
      }

      const userRef = admin.firestore().collection('users').doc(receiverId);
      const userDoc = await userRef.get();

      if (!userDoc.exists) {
        return console.log('المستخدم غير موجود.');
      }

      const userData = userDoc.data();
      const fcmToken = userData.fcmToken;

      if (!fcmToken) {
        return console.log(`المستخدم ${receiverId} لا يمتلك fcmToken نشط.`);
      }

      // Use the modern send() API instead of deprecated sendToDevice()
      const message = {
        token: fcmToken,
        notification: {
          title: title,
          body: body,
        },
        data: {
          type: notificationData.type || 'general',
          orderId: notificationData.orderId || '',
          click_action: "FLUTTER_NOTIFICATION_CLICK"
        },
        android: {
          priority: "high",
          notification: {
            sound: "default",
            channelId: "high_importance_channel",
          }
        },
        apns: {
          payload: {
            aps: {
              sound: "default",
              badge: 1,
            }
          }
        }
      };

      try {
        const response = await admin.messaging().send(message);
        console.log('تم إرسال الإشعار بنجاح:', response);
      } catch (error) {
        console.error('حدث خطأ أثناء إرسال الإشعار:', error);
      }
    });
