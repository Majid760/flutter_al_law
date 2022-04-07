import 'package:flutter_al_law/ui/guest/lawyers_list_ui.dart';
import 'package:flutter_al_law/ui/guest/search_lawyer_ui.dart';
import 'package:get/get.dart';

class GuestDashboardController extends GetxController {
  static GuestDashboardController get to => Get.find();

  // final FireStoreService fireStoreService =
  //     FireStoreService(uid: AuthController.to.firebaseUser.value.uid);
  // final String uid = AuthController.to.firebaseUser.value.uid;
  //
  // Stream<UserModel> streamFireStoreUser() {
  //   return fireStoreService.streamFireStoreUser();
  // }

  List<SpecialistCategory> myList;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void onCategoryTap(String categoryType) {
    switch (categoryType) {
      case 'family':
        break;
      case 'corporate':
        break;
      case 'criminal':
        break;
      case 'civil':
        break;
      case 'tax':
        break;
      case 'cyber':
        break;
    }
    Get.to(() => LawyersListUI(), arguments: categoryType);
  }
}

class SpecialistCategory {
  String _title;
  String _img;

  SpecialistCategory(this._title, this._img);

  String get img => _img;
  String get title => _title;
}
