import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_al_law/controllers/profile_header_controller.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/utils/image_picker_utils.dart';
import 'package:get/get.dart';

class ProfileUIHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileHeaderController>(
      init: ProfileHeaderController(),
      builder: (controller) {
        return ClipOval(
          child: InkWell(
            onTap: () async {
              final File imageFile = await onImageButtonPressed();
              if (imageFile != null) {
                final Uint8List imageBytes = await imageFile.readAsBytes();
                if (imageBytes != null) {
                  controller.updateFirebaseProfile(imageBytes);
                  Get.snackbar(
                    'Success',
                    'Profile Changed Successfully',
                    snackPosition: SnackPosition.BOTTOM,
                    duration: Duration(seconds: 3),
                    backgroundColor: Get.theme.snackBarTheme.backgroundColor,
                    colorText: Get.theme.snackBarTheme.actionTextColor,
                  );
                }
              }
            },
            child: Container(
              height: 85,
              width: 85,
              margin: const EdgeInsets.only(
                top: 2,
                left: 2,
                right: 2,
                bottom: 2,
              ),
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
              child: StreamBuilder<UserModel>(
                stream: controller.userStream,
                builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
                  if (snapshot.hasError && !snapshot.hasData) {
                    return CircleAvatar(
                      backgroundImage: new ExactAssetImage('assets/images/profile.png'),
                      backgroundColor: Colors.white,
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircleAvatar(
                      backgroundImage: new ExactAssetImage('assets/images/profile.png'),
                      backgroundColor: Colors.white,
                    );
                  }

                  if (snapshot.data.photoBlob == null) {
                    return CircleAvatar(
                      backgroundImage: new ExactAssetImage('assets/images/profile.png'),
                      backgroundColor: Colors.white,
                    );
                  }

                  return CircleAvatar(
                    backgroundImage: new MemoryImage(snapshot.data.photoBlob.bytes),
                    backgroundColor: Colors.white,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
