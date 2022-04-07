import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_al_law/controllers/auth_controller.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/services/firestore_service.dart';
import 'package:get/get.dart';

class ClientsUIController extends GetxController {
  static ClientsUIController get to => Get.find();

  final FireStoreService fireStoreService =
      FireStoreService(uid: AuthController.to.firebaseUser.value.uid);
  final String uid = AuthController.to.firebaseUser.value.uid;

  Stream<DocumentSnapshot> clientsStream;
  TextEditingController searchFieldController = new TextEditingController();
  final List<ClientModel> selectedClients = [];
  final List<ClientModel> searchedClients = [];
  bool isSearching = false;

  @override
  void onInit() {
    super.onInit();
    clientsStream = fireStoreService.streamFireStoreUserClients();
    fetchData();
    searchFieldController.addListener(_searchedData);
  }

  Future<void> fetchData() async {
    List<ClientModel> myList = await fireStoreService.getFireStoreUserClients();
    searchedClients.addAll(myList);
    selectedClients.addAll(myList);
    update();
  }

  _searchedData() {
    filterSearchResults(searchFieldController.text);
  }

  void filterSearchResults(String query) {
    List<ClientModel> dummySearchList = <ClientModel>[];
    dummySearchList.addAll(selectedClients);
    if (query.isNotEmpty) {
      List<ClientModel> dummyListData = <ClientModel>[];
      dummySearchList.forEach((item) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        } else if (item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      searchedClients.clear();
      searchedClients.addAll(dummyListData);
      update();
      return;
    } else {
      searchedClients.clear();
      searchedClients.addAll(selectedClients);
      update();
    }
  }

  addCaseToUser(Uint8List imageBytes) {
    fireStoreService.updateUserProfile(imageBytes);
    update();
  }

  void clearSearch() {
    searchFieldController.clear();
    // isSearching = false;
    // update();
  }

  void searchBarVisibilityChanged(int toggle) {
    isSearching = true;
    if (toggle == 0) isSearching = false;
    update();
  }
}
