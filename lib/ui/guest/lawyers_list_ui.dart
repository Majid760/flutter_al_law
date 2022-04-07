import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_al_law/controllers/guest/lawyer_list_controller.dart';
import 'package:flutter_al_law/models/profile_model.dart';
import 'package:flutter_al_law/ui/guest/detailed_lawyer_ui.dart';
import 'package:flutter_al_law/ui/guest/guest_dashboard_ui.dart';
import 'package:flutter_al_law/utils/palettes.dart';
import 'package:get/get.dart';
import 'package:flutter_al_law/utils/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class LawyersListUI extends StatelessWidget {
  const LawyersListUI({Key key}) : super(key: key);

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
      init: LawyerListController(),
      builder: (LawyerListController controller) => Scaffold(
        backgroundColor: kAppBackgroundColorLight1,
        body: Column(
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
                    'Lawyers',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: StreamBuilder<QuerySnapshot>(
                  stream: controller.profilesStream,
                  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    print(snapshot.connectionState);
                    if (snapshot.hasError && !snapshot.hasData) {
                      return Center(
                        child: Text('Unable to load lawyers'),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    // snapshot.data.docs.forEach((element) {
                    //   print(element.id);
                    //   print(element.data());
                    // });
                    // List<String> profileIds = snapshot.data.docs.map((doc) => doc.id).toList();
                    List<ProfileModel> profilesData = snapshot.data.docs
                        .map((doc) => ProfileModel.fromJson(doc.data(), doc.id))
                        .toList();
                    if (controller.categoryName != null && controller.categoryName != 'all') {
                      test(String value) => value.toLowerCase().contains(controller.categoryName);
                      profilesData.retainWhere((element) => element.services.any(test));
                      // profilesData.any((element) => element.services.contains(controller.categoryName))
                    }

                    if (profilesData == null || profilesData.isEmpty) {
                      return Center(
                        child: Text('No Lawyers available for now!'),
                      );
                    }

                    return ListView.builder(
                      itemCount: profilesData.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Card(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.only(left: 3, bottom: 2, top: 2),
                                      height: 65,
                                      width: 65,
                                      child: CircleAvatar(
                                        backgroundImage: profilesData[index].photoBlob != null
                                            ? new MemoryImage(
                                                profilesData[index].photoBlob.bytes,
                                              )
                                            : AssetImage(
                                                'lawyer_m'.png,
                                              ),
                                        backgroundColor: Colors.white,
                                      ),
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
                                              profilesData[index].name ?? 'Unknown',
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
                                              "${profilesData[index].education ?? 'Law'}",
                                              // profilesData[index].specialist ?? "Criminal, Family",
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
                                              // profilesData[index].education ?? "PhD, Criminal Law",
                                              "${profilesData[index].degrees.isNotEmpty ? profilesData[index].degrees.first : ''}",
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
                                          children: [
                                            Text(
                                              '${profilesData[index].experience ?? '0'} Years',
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
                                        child: Column(
                                          children: [
                                            Text(
                                              '${controller.getRatingPercentage(profilesData[index].ratings)}% (${profilesData[index].ratings.length})',
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 2,
                                            ),
                                            Text(
                                              '${controller.ratingStatus}',
                                              style: TextStyle(fontSize: 12, color: Colors.black54),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
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
                                              "View Profile",
                                              style: TextStyle(
                                                color: Colors.black,
                                                // fontFamily: 'Inter',
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          Get.to(
                                            () => DetailedLawyerUI(),
                                            arguments: profilesData[index],
                                          );
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
                                              'Call Now',
                                              style: TextStyle(
                                                color: Colors.white,
                                                // fontFamily: 'Inter',
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          ),
                                        ),
                                        onPressed: () {
                                          _launchURL(profilesData[index].mobile);
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
                    );
                  },
                ),
                // child: ListView.builder(
                //   itemCount: 5,
                //   itemBuilder: (BuildContext context, int index) {
                //     return Card(
                //       child: Container(
                //         margin: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                //         child: Column(
                //           children: [
                //             Row(
                //               children: [
                //                 Container(
                //                   margin: EdgeInsets.only(left: 3, bottom: 2, top: 2),
                //                   height: 65,
                //                   width: 65,
                //                   child: CircleAvatar(
                //                     // radius: 15,
                //                     backgroundColor: Colors.grey.shade300,
                //                     child: Image.asset(
                //                       'lawyer_m'.png,
                //                       width: 45,
                //                       height: 45,
                //                     ),
                //                   ),
                //                 ),
                //                 SizedBox(
                //                   width: 10,
                //                 ),
                //                 Expanded(
                //                   child: Container(
                //                     child: Column(
                //                       crossAxisAlignment: CrossAxisAlignment.start,
                //                       children: [
                //                         Text(
                //                           "Justice Babar Awan",
                //                           style: TextStyle(
                //                             // fontFamily: 'Geometria',
                //                             fontStyle: FontStyle.normal,
                //                             fontWeight: FontWeight.w500,
                //                             color: Colors.black,
                //                             fontSize: 16,
                //                           ),
                //                         ),
                //                         SizedBox(
                //                           height: 4,
                //                         ),
                //                         Text(
                //                           "Criminal, Family",
                //                           style: TextStyle(
                //                             fontStyle: FontStyle.normal,
                //                             fontWeight: FontWeight.w400,
                //                             color: Colors.black54,
                //                             fontSize: 14,
                //                           ),
                //                         ),
                //                         SizedBox(
                //                           height: 4,
                //                         ),
                //                         Text(
                //                           "PhD, Criminal Law",
                //                           style: TextStyle(
                //                             fontStyle: FontStyle.normal,
                //                             fontWeight: FontWeight.w400,
                //                             color: Colors.black54,
                //                             fontSize: 14,
                //                           ),
                //                         )
                //                       ],
                //                     ),
                //                   ),
                //                 ),
                //               ],
                //             ),
                //             SizedBox(
                //               height: 20,
                //             ),
                //             IntrinsicHeight(
                //               child: Row(
                //                 children: [
                //                   Expanded(
                //                     child: Column(
                //                       children: [
                //                         Text(
                //                           '10 Years',
                //                           style: TextStyle(
                //                             color: Colors.black,
                //                           ),
                //                         ),
                //                         SizedBox(
                //                           height: 2,
                //                         ),
                //                         Text(
                //                           'Experience',
                //                           style: TextStyle(fontSize: 12, color: Colors.black54),
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                   VerticalDivider(
                //                     thickness: 1,
                //                   ),
                //                   Expanded(
                //                     child: Column(
                //                       children: [
                //                         Text(
                //                           '100% (10)',
                //                           style: TextStyle(
                //                             color: Colors.black,
                //                           ),
                //                         ),
                //                         SizedBox(
                //                           height: 2,
                //                         ),
                //                         Text(
                //                           'Satisfied',
                //                           style: TextStyle(fontSize: 12, color: Colors.black54),
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                 ],
                //               ),
                //             ),
                //             SizedBox(
                //               height: 20,
                //             ),
                //             Row(
                //               children: [
                //                 Expanded(
                //                   child: FlatButton(
                //                     color: Colors.white,
                //                     shape: RoundedRectangleBorder(
                //                       borderRadius: BorderRadius.circular(2.0),
                //                       side: BorderSide(color: Colors.black, width: 1),
                //                     ),
                //                     child: Container(
                //                       height: 40,
                //                       child: Center(
                //                         child: Text(
                //                           "View Profile",
                //                           style: TextStyle(
                //                             color: Colors.black,
                //                             // fontFamily: 'Inter',
                //                             fontSize: 16.0,
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                     onPressed: () {
                //                       Get.to(() => DetailedLawyerUI());
                //                     },
                //                   ),
                //                 ),
                //                 SizedBox(
                //                   width: 10,
                //                 ),
                //                 Expanded(
                //                   child: FlatButton(
                //                     color: Colors.black,
                //                     shape: RoundedRectangleBorder(
                //                       borderRadius: BorderRadius.circular(2.0),
                //                     ),
                //                     child: Container(
                //                       height: 40,
                //                       child: Center(
                //                         child: Text(
                //                           'Call Now',
                //                           style: TextStyle(
                //                             color: Colors.white,
                //                             // fontFamily: 'Inter',
                //                             fontSize: 16.0,
                //                           ),
                //                         ),
                //                       ),
                //                     ),
                //                     onPressed: () {},
                //                   ),
                //                 ),
                //               ],
                //             )
                //           ],
                //         ),
                //       ),
                //     );
                //   },
                // ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
