import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_al_law/controllers/auth_controller.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/services/firestore_service.dart';

class AddCaseController extends GetxController {
  static AddCaseController get to => Get.find();

  final FireStoreService fireStoreService =
      FireStoreService(uid: AuthController.to.firebaseUser.value.uid);
  final String uid = AuthController.to.firebaseUser.value.uid;

  addCaseFireStore(CaseModel _case) {
    fireStoreService.addCase(_case);
    update();
  }

  List<GlobalKey<FormState>> formKeys = [
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
    GlobalKey<FormState>(),
  ];

  TextEditingController clientNameCtrl = TextEditingController();
  TextEditingController caseNameCtrl = TextEditingController();
  TextEditingController caseNumberCtrl = TextEditingController();
  TextEditingController caseRemarksCtrl = TextEditingController();
  TextEditingController caseDateCtrl = TextEditingController(text: DateTime.now().toString());
  TextEditingController caseChargesCtrl = TextEditingController();
  TextEditingController casePetitionerCtrl = TextEditingController();
  TextEditingController caseDescriptionCtrl = TextEditingController();
  TextEditingController courtNameCtrl = TextEditingController();
  TextEditingController judgeNameCtrl = TextEditingController();

  String selectedCaseType;
  List<String> caseTypesList = [
    'Family Law',
    'Civil Litigation',
    'Criminal Law',
    'Personal Injury',
    'Intellectual Property',
    'Corporate Law',
    'Tax',
    'Other',
  ];

  String selectedCity;
  List<String> citiesList = [
    'Islamabad',
    'Karachi',
    'Lahore',
    'Peshawar',
    'Quetta',
    'Multan',
    'Faisalabad',
  ];

  String selectedCourt;
  List<String> courtsList = [
    'Islamabad High Court',
    'Lahore High Court',
    'Sindh High Court',
    'Peshawar High Court',
    'Balochistan High Court',
  ];

  onCaseTypeChanged(String value) {
    selectedCaseType = value;
    update();
  }

  void onCityChanged(String value) {
    selectedCity = value;
    update();
  }

  void onCourtChanged(String value) {
    selectedCourt = value;
    update();
  }

  // THE FOLLOWING TWO VARIABLES ARE REQUIRED TO CONTROL THE STEPPER.
  int activeStep = 0; // Initial step set to 0.

  int upperBound = 2; // upperBound MUST BE total number of icons minus 1.

  onStepReached(int index) {
    activeStep = index;
    update();
  }

  incrementActiveStep() {
    activeStep++;
    update();
  }

  decrementActiveStep() {
    activeStep--;
    update();
  }

  @override
  void dispose() {
    super.dispose();

    clientNameCtrl.dispose();
    caseNameCtrl.dispose();
    caseNumberCtrl.dispose();
    caseRemarksCtrl.dispose();
    caseDateCtrl.dispose();
    caseChargesCtrl.dispose();
    casePetitionerCtrl.dispose();
    caseDescriptionCtrl.dispose();
    judgeNameCtrl.dispose();
  }
}
