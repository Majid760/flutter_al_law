import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEvidenceController extends GetxController {
  static AddEvidenceController get to => Get.find();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController evidenceNameCtrl = TextEditingController();
  TextEditingController evidenceDateTimeCtrl = TextEditingController();
  TextEditingController evidenceDescriptionCtrl = TextEditingController();
  TextEditingController evidenceRemarksCtrl = TextEditingController();
  TextEditingController evidenceFileCtrl = TextEditingController(text: 'Select File');

  String selectedEvidenceType;
  List<String> evidenceTypeList = [
    'Image',
    'Video',
    'File',
    'Other',
  ];

  void onEvidenceTypeChanged(String value) {
    selectedEvidenceType = value;
    update();
  }

  @override
  void dispose() {
    super.dispose();
    evidenceNameCtrl.dispose();
    evidenceDateTimeCtrl.dispose();
    evidenceDescriptionCtrl.dispose();
    evidenceRemarksCtrl.dispose();
    evidenceFileCtrl.dispose();
  }
}
