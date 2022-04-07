import 'package:flutter/cupertino.dart';
import 'package:flutter_al_law/models/profile_model.dart';
import 'package:get/get.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/services/firestore_service.dart';

class DetailedLawyerController extends GetxController {
  static DetailedLawyerController get to => Get.find();
  ProfileModel lawyerProfile;
  TextEditingController lawyerReviewCtrl = new TextEditingController();
  double selectedRating = 5.0;
  String currentRatingPercentage = '';
  String ratingStatus = '';
  List<int> ratingsList = [];
  List<String> reviewsList = [];

  FireStoreService fireStoreService;

  @override
  void onInit() {
    super.onInit();
    lawyerProfile = Get.arguments;
    ratingsList = lawyerProfile.ratings;
    reviewsList = lawyerProfile.reviews;
    currentRatingPercentage = _getRatingPercentage(ratingsList);
    fireStoreService = FireStoreService(uid: lawyerProfile.lawyerID);
  }

  addRatingToFirestore() {
    ratingsList.add(selectedRating.toInt());
    reviewsList.add(lawyerReviewCtrl.text.isEmpty ? 'Great' : lawyerReviewCtrl.text);
    currentRatingPercentage = _getRatingPercentage(ratingsList);
    fireStoreService.addLawyerProfileRating(ratingsList, reviewsList);
    lawyerReviewCtrl.clear();
    selectedRating = 5;
    update();
  }

  String _getRatingPercentage(List<int> ratings) {
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

  void updateRating(double value) {
    selectedRating = value;
    update();
  }

  void updateRatingCount() {}
}
