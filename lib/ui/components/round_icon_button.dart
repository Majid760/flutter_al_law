import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  RoundIconButton({@required this.icon, @required this.onPressed, this.color = Colors.orange});
  final IconData icon;
  final Function onPressed;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      child: Icon(
        icon,
        size: 26,
        color: Colors.white,
      ),
      elevation: 4.0,
      fillColor: color,
      constraints: BoxConstraints.tightFor(width: 60.0, height: 60.0),
      shape: CircleBorder(),
      onPressed: onPressed,
    );
  }
}
