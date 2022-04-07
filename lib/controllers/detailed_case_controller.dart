import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/models/add_case_model.dart';
import 'package:flutter_al_law/models/add_note_model.dart';
import 'package:flutter_al_law/models/add_schedule_model.dart';
import 'package:flutter_al_law/services/firestore_service.dart';
import 'package:get/get.dart';

class DetailedCaseController extends GetxController with SingleGetTickerProviderMixin {
  static DetailedCaseController get to => Get.find();

  int selectedCaseIndex;
  String caseID;
  CaseModel caseData;
  Stream<DocumentSnapshot> userNotesStream;
  Stream<DocumentSnapshot> userSchedulesStream;

  final FireStoreService fireStoreService =
      FireStoreService(uid: AuthController.to.firebaseUser.value.uid);
  final String uid = AuthController.to.firebaseUser.value.uid;

  TabController tabController;
  var isSelected = [true, false];

  ScrollController scrollController;
  bool dialVisible = true;

  var editCaseStatus = false;
  void changeEditCaseStatus(bool value) {
    editCaseStatus = value;
    update();
  }

  TextEditingController clientNameCtrl = TextEditingController(text: '');
  TextEditingController caseNameCtrl = TextEditingController(text: '');
  TextEditingController caseNumberCtrl = TextEditingController(text: '');
  TextEditingController caseRemarksCtrl = TextEditingController(text: '');
  TextEditingController caseDateTimeCtrl = TextEditingController(text: DateTime.now().toString());
  TextEditingController caseTypeCtrl = TextEditingController(text: '');
  TextEditingController caseChargesCtrl = TextEditingController(text: '');
  TextEditingController casePetitionerCtrl = TextEditingController(text: '');
  TextEditingController caseDescriptionCtrl = TextEditingController(text: '');
  TextEditingController courtNameCtrl = TextEditingController(text: '');
  TextEditingController judgeNameCtrl = TextEditingController(text: '');

  String selectedCaseType = 'Civil';
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

  void onCityChanged(String value) {
    selectedCity = value;
    update();
  }

  onCaseTypeChanged(String value) {
    selectedCaseType = value;
    update();
  }

  void setDialVisible(bool value) {
    dialVisible = value;
    update();
  }

  void updateSelected(bool value, int buttonIndex) {
    isSelected[buttonIndex] = value;
    update();
  }

  @override
  void onInit() {
    super.onInit();

    var list = Get.arguments;
    selectedCaseIndex = list[0];
    caseID = list[1];
    caseData = list[2];
    tabController = new TabController(vsync: this, length: 4);
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection == ScrollDirection.forward);
      });

    userNotesStream = fireStoreService.streamFireStoreUserNotes();
    userSchedulesStream = fireStoreService.streamFireStoreUserSchedules();

    clientNameCtrl.text = caseData.clientName;
    caseNameCtrl.text = caseData.caseName;
    caseNumberCtrl.text = caseData.caseNumber;
    caseRemarksCtrl.text = caseData.caseRemarks;
    caseDateTimeCtrl.text = caseData.caseDate.toString();
    caseTypeCtrl.text = caseData.caseType;
    caseChargesCtrl.text = caseData.caseCharges.toString();
    casePetitionerCtrl.text = caseData.casePetitioner;
    caseDescriptionCtrl.text = caseData.caseDesc;
    courtNameCtrl.text = caseData.courtName;
    judgeNameCtrl.text = caseData.judgeName;
    selectedCity = caseData.courtCity;
  }

  Future<void> updateCaseToFirebase() {
    CaseModel _case = new CaseModel(
      caseID: caseID,
      clientName: clientNameCtrl.text,
      caseName: caseNameCtrl.text,
      caseNumber: caseNumberCtrl.text,
      caseRemarks: caseRemarksCtrl.text,
      caseDate: DateTime.parse(caseDateTimeCtrl.text),
      caseType: selectedCaseType,
      caseCharges: double.parse(caseChargesCtrl.text),
      casePetitioner: casePetitionerCtrl.text,
      caseDesc: caseDescriptionCtrl.text,
      courtName: courtNameCtrl.text,
      courtCity: selectedCity,
      judgeName: judgeNameCtrl.text,
    );
    CaseModel _oldCase = new CaseModel(
      caseID: caseID,
      clientName: caseData.clientName,
      caseName: caseData.caseName,
      caseNumber: caseData.caseNumber,
      caseRemarks: caseData.caseRemarks,
      caseDate: caseData.caseDate,
      caseType: caseData.caseType,
      caseCharges: caseData.caseCharges,
      casePetitioner: caseData.casePetitioner,
      caseDesc: caseData.caseDesc,
      courtName: caseData.courtName,
      courtCity: caseData.courtCity,
      judgeName: caseData.judgeName,
    );
    return fireStoreService.updateCase(_case, _oldCase);
  }

  Future<void> deleteCaseFromFirebase() async {
    CaseModel _oldCase = new CaseModel(
      caseID: caseID,
      clientName: caseData.clientName,
      caseName: caseData.caseName,
      caseNumber: caseData.caseNumber,
      caseRemarks: caseData.caseRemarks,
      caseDate: caseData.caseDate,
      caseType: caseData.caseType,
      caseCharges: caseData.caseCharges,
      casePetitioner: caseData.casePetitioner,
      caseDesc: caseData.caseDesc,
      courtName: caseData.courtName,
      courtCity: caseData.courtCity,
      judgeName: caseData.judgeName,
    );
    fireStoreService.deleteCase(_oldCase);
    await _deleteLinkedSchedules();
    await _deleteLinkedNotes();
  }

  Future<void> _deleteLinkedSchedules() async {
    List<ScheduleModel> schedules = await fireStoreService.getFireStoreUserSchedules(caseID);
    if (schedules.isEmpty) {
      await fireStoreService.deleteSchedules(schedules);
      await NotificationsController.to.removeMultipleNotificationsByTag(schedules);
    }
  }

  Future<void> _deleteLinkedNotes() async {
    List<NoteModel> notes = await fireStoreService.getFireStoreUserNotes(caseID);
    return notes.isEmpty ? null : fireStoreService.deleteNotes(notes);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();

    clientNameCtrl.dispose();
    caseNameCtrl.dispose();
    caseNumberCtrl.dispose();
    caseRemarksCtrl.dispose();
    caseTypeCtrl.dispose();
    caseChargesCtrl.dispose();
    casePetitionerCtrl.dispose();
    caseDescriptionCtrl.dispose();
    courtNameCtrl.dispose();
    judgeNameCtrl.dispose();
  }
}
