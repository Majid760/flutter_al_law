import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_al_law/controllers/auth_controller.dart';
import 'package:flutter_al_law/services/firestore_service.dart';
import 'package:get/get.dart';

class HomeHeaderController extends GetxController {
  static HomeHeaderController get to => Get.find();
  Stream<DocumentSnapshot> userCasesStream;
  Stream<DocumentSnapshot> userSchedulesStream;
  Stream<DocumentSnapshot> userClientsStream;

  final FireStoreService fireStoreService =
      FireStoreService(uid: AuthController.to.firebaseUser.value.uid);
  final String uid = AuthController.to.firebaseUser.value.uid;

  @override
  void onInit() {
    super.onInit();
    userCasesStream = fireStoreService.streamFireStoreUserCases();
    userSchedulesStream = fireStoreService.streamFireStoreUserSchedules();
    userClientsStream = fireStoreService.streamFireStoreUserClients();
  }
}
