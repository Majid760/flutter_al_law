import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_al_law/services/firestore_service.dart';

class LawyerListController extends GetxController {
  static LawyerListController get to => Get.find();

  final FireStoreService fireStoreService = FireStoreService();

  Stream<QuerySnapshot> profilesStream;
  String categoryName;
  String currentRatingPercentage = '';
  String ratingStatus = '';

  @override
  void onInit() {
    super.onInit();
    categoryName = Get.arguments;
    // currentRatingPercentage = _getRatingPercentage(ratingsList);
    profilesStream = fireStoreService.streamFireStoreProfiles();
  }

  TextEditingController searchFieldController = new TextEditingController();

  @override
  void dispose() {
    super.dispose();
  }

  String getRatingPercentage(List<int> ratings) {
    int lawyerRating = 0;
    int totalRating = ratings.length * 5;
    int percentage = 0;
    ratings.forEach((element) {
      try {
        lawyerRating += element;
      } catch (e) {
        print(e);
      }
    });
    if (lawyerRating > 0 && totalRating > 0) {
      percentage = ((lawyerRating / totalRating) * 100).toInt();
      if (percentage > 90) {
        ratingStatus = 'Excellent';
      } else if (percentage > 80) {
        ratingStatus = 'Great';
      } else if (percentage > 70) {
        ratingStatus = 'Very Good';
      } else if (percentage > 60) {
        ratingStatus = 'Good';
      } else {
        ratingStatus = 'Average';
      }
      return percentage.toString();
    } else {
      ratingStatus = 'Nothing';
      return 'No rating';
    }
  }
}
