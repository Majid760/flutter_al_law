import 'package:flutter/material.dart';
import 'package:flutter_al_law/constants/constants.dart';

class DrawerItem extends StatelessWidget {
  final String text;
  final Function onPressed;
  final IconData icon;
  final TextStyle style;

  const DrawerItem({
    Key key,
    this.text,
    this.icon = Icons.home,
    this.onPressed,
    this.style,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 45,
          child: FlatButton(
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            child: Text(
              text,
              style: style ??
                  TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppThemes.blackPearl,
                  ),
            ),
            onPressed: onPressed,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 8),
          child: Icon(
            icon,
            color: AppThemes.blackPearl,
            size: 24,
          ),
        ),
      ],
    );
  }
}

class DrawerSubItem extends StatelessWidget {
  final String text;
  final Function onPressed;

  const DrawerSubItem({Key key, this.text, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.w300, fontSize: 18),
      ),
      onPressed: onPressed,
    );
  }
}
