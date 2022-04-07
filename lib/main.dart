import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'package:flutter_al_law/constants/constants.dart';
import 'package:flutter_al_law/controllers/controllers.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppThemes.ebonyClay,
    ),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Firebase.initializeApp();
  Get.put<AuthController>(AuthController(), permanent: true);
  Get.put<NotificationsController>(NotificationsController(), permanent: true);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.rightToLeftWithFade,
      //defaultTransition: Transition.fade,
      theme: AppThemes.lightTheme,
      initialRoute: "/",
      getPages: AppRoutes.routes,
    );
  }
}
