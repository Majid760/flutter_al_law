import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/services/firestore_service.dart';
import 'package:get/get.dart';

class DetailedNoteController extends GetxController with SingleGetTickerProviderMixin {
  static DetailedNoteController get to => Get.find();

  NoteModel noteData;

  final FireStoreService fireStoreService =
      FireStoreService(uid: AuthController.to.firebaseUser.value.uid);
  final String uid = AuthController.to.firebaseUser.value.uid;

  TabController tabController;

  ScrollController scrollController;
  bool dialVisible = true;

  var editNoteStatus = false;
  void changeEditNoteStatus(bool value) {
    editNoteStatus = value;
    update();
  }

  TextEditingController noteTitleCtrl = TextEditingController();
  TextEditingController noteDetailCtrl = TextEditingController();
  TextEditingController noteDateTimeCtrl = TextEditingController();

  @override
  void onInit() {
    super.onInit();

    var args = Get.arguments;
    noteData = args[0];
    tabController = new TabController(vsync: this, length: 1);
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection == ScrollDirection.forward);
      });
    noteTitleCtrl.text = noteData.title ?? '';
    noteDetailCtrl.text = noteData.detail ?? '';
    noteDateTimeCtrl.text = noteData.dateTime.toString() ?? '';
  }

  Future<void> updateNoteToFirebase() {
    NoteModel _client = new NoteModel(
      id: noteData.id,
      title: noteTitleCtrl.text,
      detail: noteDetailCtrl.text,
      type: noteData.type,
      dateTime: DateTime.parse(noteDateTimeCtrl.text),
    );
    NoteModel _oldNote = new NoteModel(
      id: noteData.id,
      title: noteData.title,
      detail: noteData.detail,
      type: noteData.type,
      dateTime: noteData.dateTime,
    );
    return fireStoreService.updateNote(_client, _oldNote);
  }

  Future<void> deleteNoteFromFirebase() {
    NoteModel _client = new NoteModel(
      id: noteData.id,
      title: noteData.title,
      detail: noteData.detail,
      type: noteData.type,
      dateTime: noteData.dateTime,
    );
    return fireStoreService.deleteNotes([_client]);
  }

  void setDialVisible(bool value) {
    dialVisible = value;
    update();
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();

    noteTitleCtrl.dispose();
    noteDetailCtrl.dispose();
    noteDateTimeCtrl.dispose();
  }
}
