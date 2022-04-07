import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_al_law/controllers/auth_controller.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/services/firestore_service.dart';
import 'package:get/get.dart';

class EvidencesUIController extends GetxController {
  static EvidencesUIController get to => Get.find();

  final FireStoreService fireStoreService =
      FireStoreService(uid: AuthController.to.firebaseUser.value.uid);
  final String uid = AuthController.to.firebaseUser.value.uid;

  Stream<DocumentSnapshot> evidenceStream;

  @override
  void onInit() {
    super.onInit();
    evidenceStream = fireStoreService.streamFireStoreUserEvidences();
  }

// addCaseToUser(Uint8List imageBytes) {
  //   fireStoreService.updateUserProfile(imageBytes);
  //   update();
  // }
}
