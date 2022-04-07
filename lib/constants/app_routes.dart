import 'package:flutter_al_law/ui/drawer/drawer.dart';
import 'package:get/get.dart';
import 'package:flutter_al_law/ui/ui.dart';
import 'package:flutter_al_law/ui/auth/auth.dart';

class AppRoutes {
  AppRoutes._(); //this is to prevent anyone from instantiating this object
  static final routes = [
    GetPage(name: '/', page: () => SplashUI()),
    GetPage(name: '/signin', page: () => SignInUI()),
    GetPage(name: '/signup', page: () => SignUpUI()),
    GetPage(name: '/home', page: () => HomeUI()),
    GetPage(name: '/settings', page: () => SettingsUI()),
    GetPage(name: '/reset-password', page: () => ResetPasswordUI()),
    GetPage(name: '/update-profile', page: () => UpdateProfileUI()),
    GetPage(name: '/add-case', page: () => AddCaseUI()),
    GetPage(name: '/add-client', page: () => AddClientUI()),
    GetPage(name: '/detailed-case', page: () => DetailedCaseUI()),
    GetPage(name: '/detailed-client', page: () => DetailedClientUI()),
    GetPage(name: '/add-schedule', page: () => AddScheduleUI()),
    GetPage(name: '/add-evidence', page: () => AddEvidenceUI()),
    GetPage(name: '/add-note', page: () => AddNoteUI()),
  ];
}
