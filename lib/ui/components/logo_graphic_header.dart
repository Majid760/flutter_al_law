import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LogoGraphicHeader extends StatelessWidget {
  LogoGraphicHeader();

  @override
  Widget build(BuildContext context) {
    String _imageLogo = 'assets/images/al_law.svg';
    return Hero(
      tag: 'App Logo',
      child: CircleAvatar(
          foregroundColor: Colors.blue,
          backgroundColor: Colors.transparent,
          radius: 60.0,
          child: ClipOval(
            child: SvgPicture.asset(
              _imageLogo,
              fit: BoxFit.cover,
              width: 120.0,
              height: 120.0,
            ),
          )),
    );
  }
}
