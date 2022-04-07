import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SchedulesUIController extends GetxController with SingleGetTickerProviderMixin {
  static SchedulesUIController get to => Get.find();
  TabController tabController;

  @override
  void onInit() {
    super.onInit();
    tabController = new TabController(vsync: this, length: 2);
  }

  @override
  void dispose() {
    super.dispose();
    tabController.dispose();
  }
}
