import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Helpers {
  static void unFocus() {
    try {
      WidgetsBinding.instance.focusManager.primaryFocus.unfocus();
    } catch (e) {
      print(e);
    }
  }

  static showLoader(context) => Loader.show(
        context,
        progressIndicator: SpinKitCircle(
          color: Colors.black,
          size: 65.0,
        ),
        overlayColor: Color(0x33000000),
      );

  static hideLoader() => Loader.hide();
}
