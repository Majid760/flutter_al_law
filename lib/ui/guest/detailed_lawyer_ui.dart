import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_al_law/controllers/guest/detailed_lawyer_controller.dart';
import 'package:flutter_al_law/ui/components/components.dart';
import 'package:flutter_al_law/ui/guest/guest_dashboard_ui.dart';
import 'package:flutter_al_law/utils/palettes.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:flutter_al_law/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailedLawyerUI extends StatelessWidget {
  const DetailedLawyerUI({Key key}) : super(key: key);

  _launchURL(String phoneNo) async {
    String url = 'tel:$phoneNo';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DetailedLawyerController(),
      builder: (DetailedLawyerController controller) => Scaffold(
        backgroundColor: kAppBackgroundColorLight1,
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 85,
                child: ClipPath(
                  clipper: CustomAppBarClipper(),
                  child: AppBar(
                    centerTitle: true,
                    iconTheme: IconThemeData(
                      color: Colors.white,
                    ),
                    actionsIconTheme: IconThemeData(
                      color: Colors.white,
                    ),
                    title: Text(
                      controller.lawyerProfile.name ?? 'Unknown',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 3, bottom: 2, top: 2),
                          height: 65,
                          width: 65,
                          child: CircleAvatar(
                            backgroundImage: controller.lawyerProfile.photoBlob != null
                                ? new MemoryImage(
                                    controller.lawyerProfile.photoBlob.bytes,
                                  )
                                : AssetImage(
                                    'lawyer_m'.png,
                                  ),
                            backgroundColor: Colors.white,
                          ),
                          // child: CircleAvatar(
                          //   // radius: 15,
                          //   backgroundColor: Colors.grey.shade300,
                          //   child: Image.asset(
                          //     'lawyer_m'.png,
                          //     width: 45,
                          //     height: 45,
                          //   ),
                          // ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  controller.lawyerProfile.name ?? 'Unknown',
                                  style: TextStyle(
                                    // fontFamily: 'Geometria',
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "${controller.lawyerProfile.education ?? 'Law'}",
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                ),
                                SizedBox(
                                  height: 4,
                                ),
                                Text(
                                  "${controller.lawyerProfile.degrees.isNotEmpty ? controller.lawyerProfile.degrees.first : ''}",
                                  style: TextStyle(
                                    fontStyle: FontStyle.normal,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.black54,
                                    fontSize: 14,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        InkWell(
                          onTap: () {
                            print(controller.lawyerProfile.mobile);
                            _launchURL(controller.lawyerProfile.mobile);
                          },
                          child: Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Icon(
                              Icons.call,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 8,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${controller.lawyerProfile.experience ?? '0'} Years',
                                  style: TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Text(
                                  'Experience',
                                  style: TextStyle(fontSize: 12, color: Colors.black54),
                                ),
                              ],
                            ),
                          ),
                          VerticalDivider(
                            thickness: 1,
                          ),
                          Expanded(
                            child: IntrinsicHeight(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${controller.currentRatingPercentage}% (${controller.ratingsList.length})',
                                        style: TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 2,
                                      ),
                                      Text(
                                        '${controller.ratingStatus}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 12,
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton(
                                        onPressed: () {
                                          Get.dialog(
                                            AlertDialog(
                                              title: Container(
                                                width: MediaQuery.of(context).size.width,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                                  child: Text(
                                                    'Rate lawyer',
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
                                                  SizedBox(height: 18),
                                                  Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      RatingBar.builder(
                                                        initialRating: controller.selectedRating,
                                                        minRating: 1,
                                                        direction: Axis.horizontal,
                                                        allowHalfRating: false,
                                                        itemCount: 5,
                                                        itemPadding:
                                                            EdgeInsets.symmetric(horizontal: 4.0),
                                                        itemBuilder: (context, _) => Icon(
                                                          Icons.star,
                                                          color: Colors.amber,
                                                        ),
                                                        onRatingUpdate: (rating) {
                                                          print(rating);
                                                          controller.updateRating(rating);
                                                        },
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 8),
                                                  Container(
                                                    padding: EdgeInsets.symmetric(horizontal: 8),
                                                    child: CustomTextWidgetOutlined(
                                                      controller: controller.lawyerReviewCtrl,
                                                      label: 'Review',
                                                      hintText:
                                                          'Describe your experience (optional)',
                                                      keyboardType: TextInputType.multiline,
                                                      keyboardAction: TextInputAction.done,
                                                      obscureText: false,
                                                    ),
                                                  ),
                                                  SizedBox(height: 36),
                                                  Row(
                                                    children: [
                                                      Expanded(
                                                        child: FlatButton(
                                                          color: Colors.white,
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(2.0),
                                                            side: BorderSide(
                                                                color: Colors.black, width: 1),
                                                          ),
                                                          child: Container(
                                                            height: 40,
                                                            child: Center(
                                                              child: Text(
                                                                'Cancel',
                                                                style: TextStyle(
                                                                  color: Colors.black,
                                                                  // fontFamily: 'Inter',
                                                                  fontSize: 16.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          onPressed: () {
                                                            Get.back();
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
                                                            borderRadius:
                                                                BorderRadius.circular(2.0),
                                                          ),
                                                          child: Container(
                                                            height: 40,
                                                            child: Center(
                                                              child: Text(
                                                                "Rate",
                                                                style: TextStyle(
                                                                  color: Colors.white,
                                                                  // fontFamily: 'Inter',
                                                                  fontSize: 16.0,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          onPressed: () async {
                                                            Get.back();
                                                            if (controller.selectedRating != null) {
                                                              try {
                                                                await controller
                                                                    .addRatingToFirestore();
                                                                controller.updateRatingCount();
                                                                Get.snackbar('Reviewed',
                                                                    'Reviewed successfully',
                                                                    snackPosition:
                                                                        SnackPosition.BOTTOM,
                                                                    duration: Duration(seconds: 3),
                                                                    backgroundColor: Get
                                                                        .theme
                                                                        .snackBarTheme
                                                                        .backgroundColor,
                                                                    colorText: Get
                                                                        .theme
                                                                        .snackBarTheme
                                                                        .actionTextColor);
                                                              } catch (e) {
                                                                print(e);
                                                              }
                                                            }
                                                            // if (onPositiveButton != null) {
                                                            //   onPositiveButton();
                                                            // }
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        style: ButtonStyle(
                                          minimumSize:
                                              MaterialStateProperty.all<Size>(Size(50, 25)),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(Colors.black),
                                          padding: MaterialStateProperty.all<EdgeInsets>(
                                            EdgeInsets.all(0),
                                          ),
                                        ),
                                        // style: TextButton.styleFrom(
                                        //   backgroundColor: Colors.black,
                                        //   padding: EdgeInsets.all(2),
                                        //   // minimumSize: Size(50, 20),
                                        //   // alignment: Alignment.center,
                                        // ),
                                        child: Text(
                                          'Rate',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Services",
                        style: TextStyle(
                          // fontFamily: 'Geometria',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          childAspectRatio: 10.0,
                          padding: EdgeInsets.only(left: 8, right: 8),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          children: controller.lawyerProfile.services
                              .map((item) => Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 5,
                                        color: Colors.black26,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        '$item',
                                        style: TextStyle(fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Card(
                margin: EdgeInsets.symmetric(horizontal: 0, vertical: 4),
                child: Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Education",
                        style: TextStyle(
                          // fontFamily: 'Geometria',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                          fontSize: 16,
                        ),
                      ),
                      Divider(),
                      SizedBox(
                        height: 10,
                      ),
                      Flexible(
                        child: GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          childAspectRatio: 10.0,
                          padding: EdgeInsets.only(left: 8, right: 8),
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          children: controller.lawyerProfile.degrees
                              .map((item) => Row(
                                    children: [
                                      Icon(
                                        Icons.circle,
                                        size: 5,
                                        color: Colors.black26,
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        '$item',
                                        style: TextStyle(fontSize: 14, color: Colors.black),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
