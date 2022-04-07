import 'package:flutter/material.dart';
// import 'package:flutter_call_recording/utils/utils.dart';
// import 'package:flutter_call_recording/widgets/widgets.dart';

class CustomAlertDialog extends StatelessWidget {
  const CustomAlertDialog(
    this.title,
    this.description,
    this.positiveText,
    this.negativeText, {
    this.onPositiveButton,
    this.onNegativeButton,
  });
  final String title;
  final String description;
  final String positiveText;
  final String negativeText;
  final VoidCallback onPositiveButton;
  final VoidCallback onNegativeButton;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Container(
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      titlePadding: EdgeInsets.symmetric(
        horizontal: 0.0,
      ),
      contentPadding: EdgeInsets.symmetric(
        vertical: 16.0,
        horizontal: 12.0,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            description,
            style: TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: FlatButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                    side: BorderSide(color: Colors.black, width: 1),
                  ),
                  child: Container(
                    height: 40,
                    child: Center(
                      child: Text(
                        negativeText,
                        style: TextStyle(
                          color: Colors.black,
                          // fontFamily: 'Inter',
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (onNegativeButton != null) {
                      onNegativeButton();
                    }
                  },
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                child: FlatButton(
                  color: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                  child: Container(
                    height: 40,
                    child: Center(
                      child: Text(
                        positiveText,
                        style: TextStyle(
                          color: Colors.white,
                          // fontFamily: 'Inter',
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (onPositiveButton != null) {
                      onPositiveButton();
                    }
                  },
                ),
              ),
            ],
          )
          // Row(
          //   children: [
          //     Expanded(
          //       child: UnFilledButton(
          //         height: 32,
          //         noElevation: true,
          //         text: negativeText,
          //         onPressed: () {
          //           if (onNegativeButton != null) {
          //             onNegativeButton!();
          //           }
          //         },
          //       ),
          //     ),
          //     SizedBox(width: 10),
          //     Expanded(
          //       child: FilledButton(
          //         noElevation: true,
          //         height: 32,
          //         widget: Text(
          //           positiveText,
          //           style: textTheme.button?.copyWith(
          //             fontSize: 14,
          //           ),
          //         ),
          //         onPressed: () {
          //           if (onPositiveButton != null) {
          //             onPositiveButton!();
          //           }
          //         },
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
