import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/utils/date_time_utils.dart';
import 'package:get/get.dart';

class HomeUIHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeHeaderController>(
      init: HomeHeaderController(),
      builder: (controller) => Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        child: Column(
          children: [
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Date: ',
                              style: TextStyle(color: Colors.yellow, fontSize: 16),
                            ),
                            Text(
                              '${dateFormatNeat.format(DateTime.now())}',
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Today's No. of Meeting(s)",
                                maxLines: 2,
                                style: TextStyle(
                                    color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  VerticalDivider(
                    thickness: 2,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Center(
                      child: StreamBuilder(
                        stream: controller.userSchedulesStream,
                        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                          if (snapshot.hasError || !snapshot.hasData) {
                            return Text(
                              '0',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            );
                          }

                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Text(
                              '0',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 22,
                              ),
                            );
                          }

                          List<dynamic> schedulesData = [];
                          print(snapshot.data.data());
                          try {
                            schedulesData = snapshot.data.get('schedules');
                          } catch (e) {
                            print(e);
                          }

                          List<ScheduleModel> schedulesList = schedulesData
                              .map((element) => ScheduleModel.fromJson(element))
                              .toList();

                          schedulesList.retainWhere(
                              (element) => calculateDifferenceOfDays(element.dateTime) == 0);

                          return Text(
                            schedulesList.length.toString() ?? '0',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 6),
              child: Divider(
                color: Colors.white38,
              ),
            ),
            Row(
              children: [
                Text(
                  'Status Overview',
                  style: TextStyle(color: Colors.yellow, fontSize: 16),
                ),
              ],
            ),
            SizedBox(
              height: 10,
            ),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Cases',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        StreamBuilder(
                          stream: controller.userCasesStream,
                          builder:
                              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError ||
                                !snapshot.hasData ||
                                snapshot.connectionState == ConnectionState.waiting) {
                              return Text(
                                '0',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }

                            var cases;
                            try {
                              cases = snapshot.data.get('cases');
                            } catch (e) {
                              print(e);
                              cases = [];
                            }

                            return Text(
                              cases.length.toString() ?? '0',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  VerticalDivider(
                    thickness: 1.5,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Open Cases',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        StreamBuilder(
                          stream: controller.userCasesStream,
                          builder:
                              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError ||
                                !snapshot.hasData ||
                                snapshot.connectionState == ConnectionState.waiting) {
                              return Text(
                                '0',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }

                            var cases;
                            try {
                              cases = snapshot.data.get('cases');
                            } catch (e) {
                              print(e);
                              cases = [];
                            }

                            return Text(
                              cases.length.toString() ?? '0',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 5,
            ),
            IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total Schedules",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        StreamBuilder(
                          stream: controller.userSchedulesStream,
                          builder:
                              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError || !snapshot.hasData) {
                              return Text(
                                '0',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }

                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return Text(
                                '0',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }

                            List<dynamic> schedulesData = [];
                            print(snapshot.data.data());
                            try {
                              schedulesData = snapshot.data.get('schedules');
                            } catch (e) {
                              print(e);
                            }

                            return Text(
                              schedulesData.length.toString() ?? '0',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  VerticalDivider(
                    thickness: 1.5,
                    color: Colors.white,
                  ),
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Clients',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        StreamBuilder(
                          stream: controller.userClientsStream,
                          builder:
                              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (snapshot.hasError ||
                                !snapshot.hasData ||
                                snapshot.connectionState == ConnectionState.waiting) {
                              return Text(
                                '0',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            }

                            var clients;
                            try {
                              clients = snapshot.data.get('clients');
                            } catch (e) {
                              print(e);
                              clients = [];
                            }

                            return Text(
                              clients.length.toString() ?? '0',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
