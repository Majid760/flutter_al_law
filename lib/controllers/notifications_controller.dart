import 'package:flutter_al_law/controllers/auth_controller.dart';
import 'package:flutter_al_law/models/add_schedule_model.dart';
import 'package:flutter_al_law/services/firestore_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationsController extends GetxController {
  static NotificationsController get to => Get.find();

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  NotificationAppLaunchDetails notificationAppLaunchDetails;

  final store = GetStorage();
  String notifications = 'enable';
  // ThemeMode get themeMode => _themeMode;
  String get currentNotification => notifications;

  /// Streams are created so that app can respond to notification-related events
  /// since the plugin is initialised in the `main` function
  // final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
  //     BehaviorSubject<ReceivedNotification>();

  // final BehaviorSubject<String> selectNotificationSubject = BehaviorSubject<String>();

  @override
  Future<void> onInit() async {
    super.onInit();
    await _configureLocalTimeZone();
    notificationAppLaunchDetails =
        await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    getNotificationsModeFromStore();
  }

  Future<void> setNotificationsMode(String value) async {
    notifications = value;
    if (value == 'enable') {
      List<ScheduleModel> schedules = await FireStoreService(
        uid: AuthController.to.firebaseUser.value.uid,
      ).getAllFireStoreSchedules();
      if (schedules.isNotEmpty) {
        schedules.retainWhere(
          (element) => element.dateTime.isAfter(
            DateTime.now().add(
              Duration(seconds: 10),
            ),
          ),
        );
        scheduleMultipleNotifications(schedules);
      }
    } else {
      removeAllNotifications();
    }
    await store.write('notifications', value);
    update();
  }

  getNotificationsModeFromStore() async {
    String _notificationsString = await store.read('notifications') ?? 'enable';
    // setNotificationsMode(_notificationsString);
  }

  Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Karachi'));
  }

  Future<void> scheduleNewNotification(
    String _tag,
    String _title,
    String _body,
    DateTime dateTime,
  ) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
        0,
        _title,
        _body,
        tz.TZDateTime.from(dateTime, tz.local),
        NotificationDetails(
          android: AndroidNotificationDetails(
            'al-law',
            'al-law org',
            'al-law notifications',
            tag: _tag,
          ),
        ),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      );
    } catch (e) {
      print(e);
    }
  }

  Future<void> scheduleMultipleNotifications(
    List<ScheduleModel> schedules,
  ) async {
    try {
      for (final data in schedules) {
        await scheduleNewNotification(
          data.notificationTag,
          data.title,
          data.detail,
          data.dateTime,
        );
      }
      final List<PendingNotificationRequest> pendingNotificationRequests =
          await flutterLocalNotificationsPlugin.pendingNotificationRequests();
      print(pendingNotificationRequests.length);
    } catch (e) {
      print(e);
    }
  }

  removeNotificationByTag(String tag) async {
    try {
      await flutterLocalNotificationsPlugin.cancel(0, tag: tag);
    } catch (e) {
      print(e);
    }
  }

  removeMultipleNotificationsByTag(List<ScheduleModel> schedules) async {
    for (final data in schedules) {
      try {
        await flutterLocalNotificationsPlugin.cancel(0, tag: data.notificationTag);
      } catch (e) {
        print(e);
      }
    }
  }

  removeAllNotifications() async {
    try {
      await flutterLocalNotificationsPlugin.cancelAll();
    } catch (e) {
      print(e);
    }
  }

  void onDispose() {
    // didReceiveLocalNotificationSubject.close();
    // selectNotificationSubject.close();
  }
}
