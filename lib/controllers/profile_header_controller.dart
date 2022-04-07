import 'dart:typed_data';
import 'package:flutter_al_law/controllers/auth_controller.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/services/firestore_service.dart';
import 'package:get/get.dart';

class ProfileHeaderController extends GetxController {
  static ProfileHeaderController get to => Get.find();
  Stream<UserModel> userStream;

  final FireStoreService fireStoreService =
      FireStoreService(uid: AuthController.to.firebaseUser.value.uid);
  final String uid = AuthController.to.firebaseUser.value.uid;

  updateFirebaseProfile(Uint8List imageBytes) {
    fireStoreService.updateUserProfile(imageBytes);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    userStream = fireStoreService.streamFireStoreUser();
  }
}
