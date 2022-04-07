import 'package:flutter/material.dart';
import 'package:flutter_al_law/controllers/guest/guest_dashboard_controller.dart';
import 'package:flutter_al_law/ui/guest/search_lawyer_ui.dart';
import 'package:flutter_al_law/utils/palettes.dart';
import 'package:get/get.dart';
import 'package:flutter_al_law/utils/extensions.dart';

class GuestDashboardUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: GuestDashboardController(),
      builder: (GuestDashboardController controller) => Scaffold(
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
                      'Welcome Guest',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                child: Card(
                  elevation: 2,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Find a Lawyer',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(() => SearchLawyerUI());
                          },
                          child: Container(
                            height: 45,
                            margin: EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              border: Border.all(width: 1.0, color: Colors.black12),
                              borderRadius: BorderRadius.all(
                                Radius.circular(4.0),
                              ), // Set rounded corner radius
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 16,
                                ),
                                Icon(
                                  Icons.search,
                                  color: Colors.black38,
                                  size: 22,
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Text(
                                  "Lawyer name, Specialization...",
                                  style: TextStyle(color: Colors.black38),
                                ),
                              ],
                            ),
                            // child: TextFormField(
                            //   // enabled: false,
                            //   decoration: InputDecoration(
                            //     filled: true,
                            //     hintText: "Lawyer name, Specialization...",
                            //     hintStyle: TextStyle(color: Colors.black38),
                            //     prefixIcon: Icon(
                            //       Icons.search,
                            //       color: Colors.black38,
                            //     ),
                            //     contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            //     enabledBorder: _border,
                            //     focusedBorder: _border,
                            //     disabledBorder: _border,
                            //   ),
                            //   controller: controller.searchFieldController,
                            //   onSaved: (value) {},
                            //   onTap: () {
                            //     Get.to(() => LawyersListUI());
                            //   },
                            //   onChanged: (value) {},
                            //   keyboardType: TextInputType.name,
                            // ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 18,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 4),
                child: Card(
                  elevation: 2,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Top Categories',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(
                          height: 36,
                        ),
                        Row(
                          children: [
                            //Family
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.onCategoryTap('family');
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      child: Image.asset("family".png),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "Family",
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //Corporate
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.onCategoryTap('corporate');
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      child: Image.asset("corporate".png),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "Corporate",
                                      style: TextStyle(fontSize: 16, color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //Criminal
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.onCategoryTap('criminal');
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      child: Image.asset("criminal".png),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "Criminal",
                                      style: TextStyle(fontSize: 16, color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 36,
                        ),
                        Row(
                          children: [
                            //Civil
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.onCategoryTap('civil');
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      child: Image.asset("personal".png),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "Civil",
                                      style: TextStyle(fontSize: 16, color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //Tax
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.onCategoryTap('tax');
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      child: Image.asset("tax".png),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "Tax",
                                      style: TextStyle(fontSize: 16, color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            //Cyber
                            Expanded(
                              child: InkWell(
                                onTap: () {
                                  controller.onCategoryTap('cyber');
                                },
                                child: Column(
                                  children: [
                                    Container(
                                      height: 50,
                                      width: 50,
                                      child: Image.asset("bankruptcy".png),
                                    ),
                                    SizedBox(
                                      height: 12,
                                    ),
                                    Text(
                                      "Cyber",
                                      style: TextStyle(fontSize: 16, color: Colors.black87),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          height: 35,
                          margin: EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            border: Border.all(width: 1.0),
                            borderRadius: BorderRadius.all(
                              Radius.circular(2.0),
                            ), // Set rounded corner radius
                          ),
                          child: InkWell(
                            onTap: () {
                              Get.to(() => SearchLawyerUI());
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Find other categories",
                                  style: TextStyle(
                                    color: Colors.black87,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                SizedBox(
                                  width: 12,
                                ),
                                Icon(
                                  Icons.arrow_right_alt,
                                  color: Colors.black87,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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

class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double height = size.height;
    Path path = Path();

    path.moveTo(0, height - 10);
    path.quadraticBezierTo(size.width / 2, height, size.width, height - 10);
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => true;
}
