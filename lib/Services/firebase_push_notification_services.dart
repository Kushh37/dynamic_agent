import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel',
  "High Importance Notifcations",
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationplugin =
    FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
}

class FirebaseNotifcation {
  initialize(context) async {
    await Firebase.initializeApp();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    await flutterLocalNotificationplugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    var intializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');
    var initializationSettings =
        InitializationSettings(android: intializationSettingsAndroid);

    flutterLocalNotificationplugin.initialize(initializationSettings);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      // ss.SchedulerBinding.instance?.addPostFrameCallback((_) {
      //   Navigator.of(GlobalVariable.navState.currentContext!)
      //       .push(MaterialPageRoute(builder: (context) => Login()));
      // });
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        AndroidNotificationDetails notificationDetails =
            AndroidNotificationDetails(
          channel.id,
          channel.name,
          importance: Importance.max,
          priority: Priority.high,
        );
        NotificationDetails notificationDetailsPlatformSpefics =
            NotificationDetails(android: notificationDetails);
        flutterLocalNotificationplugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            notificationDetailsPlatformSpefics);
      }

      List<ActiveNotification>? activeNotifications =
          await flutterLocalNotificationplugin
              .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin>()
              ?.getActiveNotifications();
      if (activeNotifications!.isNotEmpty) {
        List<String> lines =
            activeNotifications.map((e) => e.title.toString()).toList();
        InboxStyleInformation inboxStyleInformation = InboxStyleInformation(
            lines,
            contentTitle: "${activeNotifications.length - 1} messages",
            summaryText: "${activeNotifications.length - 1} messages");
        // AndroidNotificationDetails groupNotificationDetails =
        //     AndroidNotificationDetails(
        //         channel.id, channel.name, channel.description,
        //         styleInformation: inboxStyleInformation,
        //         setAsGroupSummary: true,
        //         );

        // NotificationDetails groupNotificationDetailsPlatformSpefics =
        //     NotificationDetails(android: groupNotificationDetails);
        // await flutterLocalNotificationplugin.show(
        //     0, '', '', groupNotificationDetailsPlatformSpefics);
      }
    });
  }

  Future<String?> getToken() async {
    String? token = await FirebaseMessaging.instance.getToken();

    return token;
  }

  subscribeToTopic(String topic) async {
    await FirebaseMessaging.instance.subscribeToTopic(topic);
  }
}
