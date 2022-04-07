import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_al_law/constants/constants.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

onImageButtonPressed() async {
  try {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
    );
    return await _cropImage(pickedFile.path);
  } catch (e) {
    print(e);
    return null;
  }
}

_cropImage(imagePath) async {
  File croppedFile = await ImageCropper.cropImage(
      sourcePath: imagePath,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9
            ]
          : [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio5x3,
              CropAspectRatioPreset.ratio5x4,
              CropAspectRatioPreset.ratio7x5,
              CropAspectRatioPreset.ratio16x9
            ],
      androidUiSettings: AndroidUiSettings(
        toolbarTitle: 'Cropper',
        statusBarColor: AppThemes.blackPearl,
        toolbarColor: AppThemes.black,
        toolbarWidgetColor: Colors.white,
        initAspectRatio: CropAspectRatioPreset.original,
        lockAspectRatio: false,
      ),
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
      ));
  if (croppedFile != null) {
    return croppedFile;
  }
  return null;
}
