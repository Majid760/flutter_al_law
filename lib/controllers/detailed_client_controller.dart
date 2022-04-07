import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/services/firestore_service.dart';
import 'package:get/get.dart';

class DetailedClientController extends GetxController with SingleGetTickerProviderMixin {
  static DetailedClientController get to => Get.find();

  int selectedClientIndex;
  ClientModel clientData;
  String clientID = '';
  Stream<DocumentSnapshot> clientSchedulesStream;
  Stream<DocumentSnapshot> clientNotesStream;

  final FireStoreService fireStoreService =
      FireStoreService(uid: AuthController.to.firebaseUser.value.uid);
  final String uid = AuthController.to.firebaseUser.value.uid;

  TabController tabController;
  var isSelected = [true, false];

  ScrollController scrollController;
  bool dialVisible = true;

  var editClientStatus = false;
  void changeEditClientStatus(bool value) {
    editClientStatus = value;
    update();
  }

  TextEditingController clientNameCtrl = TextEditingController();
  TextEditingController clientContactCtrl = TextEditingController();
  TextEditingController clientAddressCtrl = TextEditingController();
  TextEditingController clientEmailCtrl = TextEditingController();
  TextEditingController clientRemarksCtrl = TextEditingController();

  String selectedCity = 'Islamabad';
  List<String> citiesList = [
    'Islamabad',
    'Karachi',
    'Lahore',
    'Peshawar',
    'Quetta',
    'Multan',
    'Faisalabad',
  ];

  @override
  void onInit() {
    super.onInit();

    var args = Get.arguments;
    selectedClientIndex = args[0];
    clientData = args[1];
    clientID = args[2];
    tabController = new TabController(vsync: this, length: 3);
    scrollController = ScrollController()
      ..addListener(() {
        setDialVisible(scrollController.position.userScrollDirection == ScrollDirection.forward);
      });

    clientSchedulesStream = fireStoreService.streamFireStoreUserSchedules();
    clientNotesStream = fireStoreService.streamFireStoreUserNotes();

    clientNameCtrl.text = clientData.name ?? '';
    clientContactCtrl.text = clientData.contact ?? '';
    clientAddressCtrl.text = clientData.address ?? '';
    clientEmailCtrl.text = clientData.email ?? '';
    clientRemarksCtrl.text = clientData.remarks ?? '';
    selectedCity = clientData.city ?? '';
  }

  Future<void> updateClientToFirebase() {
    ClientModel _client = new ClientModel(
      id: clientID,
      name: clientNameCtrl.text,
      contact: clientContactCtrl.text,
      email: clientEmailCtrl.text,
      city: selectedCity,
      remarks: clientRemarksCtrl.text,
      address: clientAddressCtrl.text,
    );
    ClientModel _oldClient = new ClientModel(
      id: clientID,
      name: clientData.name,
      contact: clientData.contact,
      email: clientData.email,
      city: clientData.city,
      remarks: clientData.remarks,
      address: clientData.address,
    );
    return fireStoreService.updateClient(_client, _oldClient);
  }

  Future<void> deleteClientFromFirebase() async {
    ClientModel _client = new ClientModel(
      id: clientID,
      name: clientNameCtrl.text,
      contact: clientContactCtrl.text,
      email: clientEmailCtrl.text,
      city: selectedCity,
      remarks: clientRemarksCtrl.text,
      address: clientAddressCtrl.text,
    );
    fireStoreService.deleteClient(_client);
    await _deleteLinkedSchedules();
    await _deleteLinkedNotes();
  }

  Future<void> _deleteLinkedSchedules() async {
    List<ScheduleModel> schedules = await fireStoreService.getFireStoreUserSchedules(clientID);
    if (schedules.isEmpty) {
      await fireStoreService.deleteSchedules(schedules);
      await NotificationsController.to.removeMultipleNotificationsByTag(schedules);
    }
  }

  Future<void> _deleteLinkedNotes() async {
    List<NoteModel> notes = await fireStoreService.getFireStoreUserNotes(clientID);
    return notes.isEmpty ? null : fireStoreService.deleteNotes(notes);
  }

  void onCityChanged(String value) {
    selectedCity = value;
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
  void dispose() {
    super.dispose();
    tabController.dispose();

    clientNameCtrl.dispose();
    clientContactCtrl.dispose();
    clientAddressCtrl.dispose();
    clientEmailCtrl.dispose();
    clientRemarksCtrl.dispose();
  }
}
