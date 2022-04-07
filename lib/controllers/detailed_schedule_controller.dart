import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/services/firestore_service.dart';
import 'package:get/get.dart';

class DetailedScheduleController extends GetxController with SingleGetTickerProviderMixin {
  static DetailedScheduleController get to => Get.find();

  ScheduleModel scheduleData;

  final FireStoreService fireStoreService =
      FireStoreService(uid: AuthController.to.firebaseUser.value.uid);
  final String uid = AuthController.to.firebaseUser.value.uid;

  TabController tabController;

  ScrollController scrollController;
  bool dialVisible = true;

  var editScheduleStatus = false;
  void changeEditScheduleStatus(bool value) {
    editScheduleStatus = value;
    update();
  }

  TextEditingController scheduleTitleCtrl = TextEditingController();
  TextEditingController scheduleDetailCtrl = TextEditingController();
  TextEditingController scheduleDateTimeCtrl = TextEditingController();
  TextEditingController scheduleRemarksCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    var args = Get.arguments;
    scheduleData = args[0];
    tabController = new TabController(vsync: this, length: 1);
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection == ScrollDirection.forward);
      });
    scheduleTitleCtrl.text = scheduleData.title ?? '';
    scheduleDetailCtrl.text = scheduleData.detail ?? '';
    scheduleDateTimeCtrl.text = scheduleData.dateTime.toString() ?? '';
    scheduleRemarksCtrl.text = scheduleData.remarks ?? '';
  }

  Future<void> updateScheduleToFirebase() {
    ScheduleModel _client = new ScheduleModel(
      id: scheduleData.id,
      title: scheduleTitleCtrl.text,
      detail: scheduleDetailCtrl.text,
      type: scheduleData.type,
      dateTime: DateTime.parse(scheduleDateTimeCtrl.text),
      remarks: scheduleRemarksCtrl.text,
    );
    return fireStoreService.updateSchedule(_client, scheduleData);
  }

  Future<void> deleteScheduleFromFirebase() {
    return fireStoreService.deleteSchedules([scheduleData]);
  }

  Future<void> removeNotificationIfExists() async {
    NotificationsController.to.removeNotificationByTag(scheduleData.notificationTag);
  }

  void setDialVisible(bool value) {
    dialVisible = value;
    update();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();

    scheduleTitleCtrl.dispose();
    scheduleDetailCtrl.dispose();
    scheduleDateTimeCtrl.dispose();
    scheduleRemarksCtrl.dispose();
  }
}
