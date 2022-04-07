import 'package:flutter/material.dart';
import 'package:flutter_al_law/bloc/drawer_bloc.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/ui/auth/auth.dart';
import 'package:flutter_al_law/ui/components/components.dart';
import 'package:get/get.dart';

class SettingsUI extends StatelessWidget with DrawerStates {
  //final LanguageController languageController = LanguageController.to;
  //final ThemeController themeController = ThemeController.to;

  @override
  Widget build(BuildContext context) {
    return _buildLayoutSection(context);
  }

  Widget _buildLayoutSection(BuildContext context) {
    return ListView(
      children: <Widget>[
        notificationsListTile(context),
        ListTile(
          title: Text('Update Email'),
          trailing: ElevatedButton(
            onPressed: () async {
              Get.to(() => UpdateProfileUI());
            },
            child: Text(
              'Update',
            ),
          ),
        ),
        ListTile(
          title: Text('Sign Out'),
          trailing: ElevatedButton(
            onPressed: () {
              AuthController.to.signOut();
            },
            child: Text(
              'Sign Out',
            ),
          ),
        )
      ],
    );
  }

  notificationsListTile(BuildContext context) {
    final List<MenuOptionsModel> themeOptions = [
      MenuOptionsModel(key: "enable", value: "Enabled", icon: Icons.notifications_active),
      MenuOptionsModel(key: "disable", value: 'Disabled', icon: Icons.notifications_off),
    ];
    return GetBuilder<NotificationsController>(
      builder: (controller) => ListTile(
        title: Text('Notifications'),
        trailing: SegmentedSelector(
          selectedOption: controller.currentNotification,
          menuOptions: themeOptions,
          onValueChanged: (value) {
            controller.setNotificationsMode(value);
          },
        ),
      ),
    );
  }
}
