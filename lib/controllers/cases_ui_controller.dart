import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_al_law/controllers/auth_controller.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/services/firestore_service.dart';
import 'package:get/get.dart';

class CasesUIController extends GetxController {
  static CasesUIController get to => Get.find();

  final FireStoreService fireStoreService =
      FireStoreService(uid: AuthController.to.firebaseUser.value.uid);
  final String uid = AuthController.to.firebaseUser.value.uid;

  TextEditingController searchFieldController = new TextEditingController();
  final List<CaseModel> selectedCustomers = [];
  final List<CaseModel> searchedCustomers = [];
  bool isSearching = false;
  Stream<DocumentSnapshot> casesStream;

  @override
  void onInit() {
    super.onInit();
    casesStream = fireStoreService.streamFireStoreUserCases();
    fetchData();
    searchFieldController.addListener(_searchedData);
  }

  Future<void> fetchData() async {
    List<CaseModel> myList = await fireStoreService.getFireStoreUserCases();
    // searchedCustomers = selectedCustomers = myList;
    searchedCustomers.addAll(myList);
    selectedCustomers.addAll(myList);
    update();
  }

  _searchedData() {
    filterSearchResults(searchFieldController.text);
  }

  void filterSearchResults(String query) {
    List<CaseModel> dummySearchList = <CaseModel>[];
    dummySearchList.addAll(selectedCustomers);
    if (query.isNotEmpty) {
      List<CaseModel> dummyListData = <CaseModel>[];
      dummySearchList.forEach((item) {
        if (item.caseName.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        } else if (item.judgeName.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      searchedCustomers.clear();
      searchedCustomers.addAll(dummyListData);
      update();
      return;
    } else {
      searchedCustomers.clear();
      searchedCustomers.addAll(selectedCustomers);
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
