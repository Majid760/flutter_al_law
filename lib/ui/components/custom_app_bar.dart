import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget {
  final Widget leading, trailing, child;
  final String title;
  final double height, childHeight, positionTop;
  final bool isBig;

  const CustomAppBar({
    Key key,
    this.leading,
    this.trailing,
    this.title,
    this.height,
    this.positionTop,
    this.childHeight,
    this.isBig,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        ClipPath(
          clipper: _AppBarClipper(childHeight: childHeight, isBig: isBig),
          child: Container(
            padding: const EdgeInsets.only(top: 28),
            color: Theme.of(context).primaryColor,
            height: height,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // leading,
                FlatButton(
                  onPressed: null,
                  padding: EdgeInsets.symmetric(horizontal: 8),
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: Theme.of(context).scaffoldBackgroundColor,
                    ),
                  ),
                ),
                trailing
              ],
            ),
          ),
        ),
        Positioned(
          top: childHeight - positionTop,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: child,
          ),
        ),
      ],
    );
  }
}

class _AppBarClipper extends CustomClipper<Path> {
  final bool isBig;
  final double childHeight;

  _AppBarClipper({@required this.isBig, @required this.childHeight});

  @override
  Path getClip(Size size) {
    double height = isBig ? size.height - childHeight + 50 : size.height;
    Path path = Path();

    path.moveTo(0, height - 15);
    path.quadraticBezierTo(size.width / 2, height, size.width, height - 15);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
