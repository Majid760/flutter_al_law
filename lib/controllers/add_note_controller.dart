import 'package:flutter/material.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/services/firestore_service.dart';
import 'package:get/get.dart';

class AddNoteController extends GetxController {
  static AddNoteController get to => Get.find();

  final FireStoreService fireStoreService =
      FireStoreService(uid: AuthController.to.firebaseUser.value.uid);
  final String uid = AuthController.to.firebaseUser.value.uid;

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController noteTitleCtrl = TextEditingController();
  TextEditingController noteDateTimeCtrl = TextEditingController(
    text: DateTime.now().toString(),
  );
  TextEditingController noteDetailCtrl = TextEditingController();
  TextEditingController noteRemarksCtrl = TextEditingController();

  String noteID;
  String noteType;

  addNoteToFireStore(NoteModel _note) {
    fireStoreService.addNote(_note);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    var args = Get.arguments;
    noteID = args[0];
    noteType = args[1];
  }

  @override
  void dispose() {
    super.dispose();
    noteTitleCtrl.dispose();
    noteDateTimeCtrl.dispose();
    noteDetailCtrl.dispose();
    noteRemarksCtrl.dispose();
  }
}
