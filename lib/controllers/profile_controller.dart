import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_al_law/controllers/auth_controller.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/services/firestore_service.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find();

  TextEditingController mobileController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController experienceController = TextEditingController();
  TextEditingController educationController = TextEditingController();
  Stream<UserModel> userModelStream;
  List<String> selectedServices = [];
  List<String> selectedDegrees = [];
  List<String> lawyerServices = [
    "Civil Matters",
    "Copyrights Trademarks",
    "Criminal Matters",
    "Cyber Crimes",
    "Family & Guardian",
    "Insurance Claims",
    "NAB Matters",
    "Nadra Laws",
    "Revenue Matters",
    "Service Matters",
    "Taxation Laws",
  ];
  List<String> lawyerDegrees = [
    "Master of Laws",
    "Bachelor of Laws",
    "Phd Law",
  ];

  final FireStoreService fireStoreService =
      FireStoreService(uid: AuthController.to.firebaseUser.value.uid);
  final String uid = AuthController.to.firebaseUser.value.uid;

  @override
  void onInit() {
    super.onInit();
    userModelStream = fireStoreService.streamFireStoreUser();
  }

  var status = true;
  void changeStatus(bool value) {
    status = value;
    update();
  }

  void onServicesConfirm(List<String> values) {
    selectedServices = values;
    update();
  }

  void onDegreesConfirm(List<String> values) {
    selectedDegrees = values;
    update();
  }

  updateFirebaseUserAndProfile(
    String name,
    String mobile,
    String experience,
    List<String> selectedServices,
    List<String> selectedDegrees,
  ) {
    fireStoreService.updateUser(
      name,
      mobile,
      experience,
      selectedServices ?? [],
      selectedDegrees ?? [],
    );
    update();
  }

  updateFirebaseProfile(Uint8List imageBytes) {
    fireStoreService.updateUserProfile(imageBytes);
    update();
  }

  @override
  void onClose() {
    mobileController.dispose();
    emailController.dispose();
    nameController.dispose();
    experienceController.dispose();
    educationController.dispose();
    super.onClose();
  }
}
