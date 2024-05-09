import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:awesome_notifications_fcm/awesome_notifications_fcm.dart';
import 'package:flutter/material.dart';

class NotificationController {
  static void init() {
    AwesomeNotifications().initialize(
      // set the icon to null if you want to use the default app icon
      null,
      [
        NotificationChannel(
          channelGroupKey: 'default_channel_group',
          channelKey: 'default_channel',
          channelName: 'Default notifications',
          channelDescription: 'Notification channel for default tests',
          defaultColor: Color(0xFF9D50DD),
          ledColor: Colors.white,
        )
      ],
      // Channel groups are only visual and are not required
      channelGroups: [
        NotificationChannelGroup(
          channelGroupKey: 'default_channel_group',
          channelGroupName: 'Default group',
        )
      ],
      debug: true,
    );

    AwesomeNotifications().setListeners(
      onActionReceivedMethod: onActionReceivedMethod,
      onNotificationCreatedMethod: onNotificationCreatedMethod,
      onNotificationDisplayedMethod: onNotificationDisplayedMethod,
      onDismissActionReceivedMethod: onDismissActionReceivedMethod,
    );

    NotificationController().requestPermissions();
    NotificationController().initRemote(debug: true);
  }

  /// Use this method to initialize the remote notifications
  Future<void> initRemote({
    required bool debug,
  }) async {
    await Firebase.initializeApp();
    await AwesomeNotificationsFcm().initialize(
      onFcmSilentDataHandle: NotificationController.handleFcmSiletData,
      onFcmTokenHandle: NotificationController.handleFcmToken,
      onNativeTokenHandle: NotificationController.handleNativeToken,
      // This license key is necessary only to remove the watermark for
      // push notifications in release mode. To know more about it, please
      // visit http://awesome-notifications.carda.me#prices
      licenseKeys: [],
      debug: debug,
    );
  }

  void requestPermissions() {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
  }

  /// Use this method to detect when a new notification or a schedule is created
  @pragma('vm:entry-point')
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
    print('Notification created: ${receivedNotification.id}');
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma('vm:entry-point')
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
    print('Notification displayed: ${receivedNotification.id}');
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma('vm:entry-point')
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
    print('Notification dismissed: ${receivedAction.id}');
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
    print('Action received: ${receivedAction.id}');

    // Navigate into pages, avoiding to open the notification details page over another details page already opened
  }

  // Request FCM token to Firebase
  Future<String> getFcmToken() async {
    String firebaseAppToken = '';

    if (await AwesomeNotificationsFcm().isFirebaseAvailable) {
      try {
        firebaseAppToken =
            await AwesomeNotificationsFcm().requestFirebaseAppToken();
      } catch (exception) {
        debugPrint('$exception');
      }
    } else {
      debugPrint('Firebase is not available on this project');
    }

    return firebaseAppToken;
  }

  /// Use this method to execute on background when a silent data arrives
  /// (even while terminated)
  @pragma('vm:entry-point')
  static Future<void> handleFcmSiletData(FcmSilentData silentData) async {
    print('SilentData: ${silentData.toString()}');

    if (silentData.createdLifeCycle != NotificationLifeCycle.Foreground) {
      print('BACKGROUND');
    } else {
      print('FOREGROUND');
    }

    print('starting long task');
    await Future.delayed(Duration(seconds: 4));
    print('long task done');
  }

  /// Use this method to detect when a new fcm token is received
  @pragma('vm:entry-point')
  static Future<void> handleFcmToken(String token) async {
    debugPrint('FCM Token: $token');
  }

  /// Use this method to detect when a new native token is received
  @pragma('vm:entry-point')
  static Future<void> handleNativeToken(String token) async {
    debugPrint('Native Token: $token');
  }
}
