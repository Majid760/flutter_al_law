import 'package:flutter/material.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/models/add_schedule_model.dart';
import 'package:flutter_al_law/services/firestore_service.dart';
import 'package:get/get.dart';

class AddScheduleController extends GetxController {
  static AddScheduleController get to => Get.find();

  final FireStoreService fireStoreService =
      FireStoreService(uid: AuthController.to.firebaseUser.value.uid);
  final String uid = AuthController.to.firebaseUser.value.uid;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController scheduleTitleCtrl = TextEditingController();
  TextEditingController scheduleTypeCtrl = TextEditingController();
  TextEditingController scheduleDateTimeCtrl = TextEditingController(
    text: DateTime.now().add(const Duration(days: 1)).toString(),
  );
  TextEditingController scheduleDetailCtrl = TextEditingController();
  TextEditingController scheduleRemarksCtrl = TextEditingController();

  String scheduleID;
  String scheduleType;

  @override
  void onInit() {
    super.onInit();
    var args = Get.arguments;
    scheduleID = args[0];
    scheduleType = args[1];
  }

  addScheduleToFireStore(ScheduleModel _schedule) {
    fireStoreService.addSchedule(_schedule);
    update();
  }

  @override
  void dispose() {
    super.dispose();
    scheduleTitleCtrl.dispose();
    scheduleDateTimeCtrl.dispose();
    scheduleDetailCtrl.dispose();
    scheduleRemarksCtrl.dispose();
  }
}
