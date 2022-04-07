import 'package:flutter/material.dart';
import 'package:flutter_al_law/services/firestore_service.dart';
import 'package:flutter_al_law/ui/guest/lawyers_list_ui.dart';
import 'package:get/get.dart';
import 'package:flutter_al_law/models/models.dart';

class SearchLawyerController extends GetxController {
  static SearchLawyerController get to => Get.find();

  TextEditingController searchFieldController = new TextEditingController();
  List<ProfileModel> selectedLawyers = [];
  List<ProfileModel> searchedLawyers = [];
  final FireStoreService fireStoreService = FireStoreService();
  List<ProfileModel> profilesData;

  @override
  void onInit() {
    super.onInit();
    fetchData();
    searchedLawyers.addAll(selectedLawyers);
    searchFieldController.addListener(_searchedData);
  }

  Future<void> fetchData() async {
    List<ProfileModel> myList = await fireStoreService.getFireStoreProfiles();
    profilesData = selectedLawyers = myList;
    update();
  }

  _searchedData() {
    filterSearchResults(searchFieldController.text);
  }

  void filterSearchResults(String query) {
    List<ProfileModel> dummySearchList = <ProfileModel>[];
    dummySearchList.addAll(selectedLawyers);
    if (query.isNotEmpty) {
      List<ProfileModel> dummyListData = <ProfileModel>[];
      dummySearchList.forEach((item) {
        if (item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        } else if (item.name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      searchedLawyers.clear();
      searchedLawyers.addAll(dummyListData);
      update();
      return;
    } else {
      searchedLawyers.clear();
      // searchedCustomers.addAll(selectedCustomers);
      update();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onCategoryTap(String categoryType) {
    Get.to(() => LawyersListUI(), arguments: categoryType);
  }
}
