import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SplashUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white10,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Stack(
              alignment: AlignmentDirectional.center,
              children: <Widget>[
                new Container(
                  width: _width / 2,
                  height: _width / 2,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight,
                          colors: [
                            Colors.white70,
                            Colors.white60,
                            Colors.white24,
                            Colors.white10,
                          ])),
                  // decoration: BoxDecoration(
                  //   shape: BoxShape.circle,
                  //   color: Colors.grey[100],
                  // ),
                ),
                new Container(
                  decoration: BoxDecoration(
                    // color: Colors.grey[100],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 2,
                        spreadRadius: 1,
                        color: Colors.black26,
                      ),
                    ],
                  ),
                  child: new CircleAvatar(
                    radius: _width / 5,
                    backgroundColor: Colors.grey[100],
                    child: SvgPicture.asset(
                      'assets/images/al_law.svg',
                      width: _width / 3,
                      height: _width / 3,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              "Al-Law",
              style: TextStyle(
                fontSize: 24.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 100),
            SpinKitFadingCube(
              color: Colors.white,
              size: 40.0,
              duration: const Duration(milliseconds: 1500),
            ),
          ],
        ),
      ),
    );
  }
}
