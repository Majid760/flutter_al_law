import 'package:flutter/material.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/models/add_client_model.dart';
import 'package:flutter_al_law/services/firestore_service.dart';
import 'package:get/get.dart';

class AddClientController extends GetxController {
  static AddClientController get to => Get.find();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController clientNameCtrl = TextEditingController(text: "");
  TextEditingController clientContactCtrl = TextEditingController(text: "");
  TextEditingController clientAddressCtrl = TextEditingController(text: "");
  TextEditingController clientEmailCtrl = TextEditingController(text: "");
  TextEditingController clientRemarksCtrl = TextEditingController(text: "");

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

  final FireStoreService fireStoreService =
      FireStoreService(uid: AuthController.to.firebaseUser.value.uid);
  final String uid = AuthController.to.firebaseUser.value.uid;

  Stream<ClientModel> streamFireStoreClients() {
    // return fireStoreService.streamFireStoreUser();
  }

  addClientToFireStore(ClientModel _client) {
    fireStoreService.addClient(_client);
    update();
  }

  @override
  void dispose() {
    super.dispose();
    clientNameCtrl.dispose();
    clientContactCtrl.dispose();
    clientAddressCtrl.dispose();
    clientEmailCtrl.dispose();
    clientRemarksCtrl.dispose();
  }
}
