import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_al_law/bloc/drawer_bloc.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/services/firestore_service.dart';
import 'package:flutter_al_law/ui/components/components.dart';
import 'package:flutter_al_law/ui/detailed_schedule_ui.dart';
import 'package:get/get.dart';

class SchedulesUI extends StatelessWidget with DrawerStates {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<SchedulesUIController>(
      init: SchedulesUIController(),
      builder: (controller) => Column(
        children: [
          Material(
            color: Colors.black,
            elevation: 2,
            child: TabBar(
              unselectedLabelColor: Colors.white.withOpacity(0.5),
              indicatorColor: Colors.white,
              indicatorWeight: 3,
              // isScrollable: true,
              tabs: <Tab>[
                new Tab(
                  text: "Client Schedules",
                ),
                new Tab(
                  text: "Cases Schedules",
                ),
              ],
              controller: controller.tabController,
            ),
          ),
          SizedBox(
            height: 2,
          ),
          Expanded(
            child: TabBarView(
              children: [
                ClientScheduleWidget(),
                CaseScheduleWidget(),
              ],
              controller: controller.tabController,
            ),
          ),
        ],
      ),
    );
  }
  // Align(
  // alignment: Alignment.bottomRight,
  // child: Padding(
  // padding: const EdgeInsets.all(12.0),
  // child: RoundIconButton(
  // color: Colors.teal,
  // icon: Icons.add,
  // onPressed: () {
  // Get.to(() => AddScheduleUI());
  // },
  // ),
  // ),
  // ),
}

class CaseScheduleWidget extends StatefulWidget {
  const CaseScheduleWidget({Key key}) : super(key: key);

  @override
  _CaseScheduleWidgetState createState() => _CaseScheduleWidgetState();
}

class _CaseScheduleWidgetState extends State<CaseScheduleWidget>
    with AutomaticKeepAliveClientMixin<CaseScheduleWidget> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<CasesScheduleController>(
      init: CasesScheduleController(),
      builder: (controller) {
        return StreamBuilder<DocumentSnapshot>(
          stream: controller.scheduleStream,
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError && !snapshot.hasData) {
              return Center(
                child: Text('Unable to load schedules'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            List<dynamic> schedulesData = [];
            print(snapshot.data.data());
            try {
              schedulesData = snapshot.data.get('schedules');
            } catch (e) {
              print(e);
            }
            List<ScheduleModel> schedulesList =
                schedulesData.map((element) => ScheduleModel.fromJson(element)).toList();
            schedulesList.retainWhere((element) => element.type == 'Case');

            if (schedulesList == null || schedulesList.isEmpty) {
              return Center(
                child: Text('No schedules for now!'),
              );
            }

            return MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView.builder(
                itemCount: schedulesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return SingleScheduleCard(
                    schedule: schedulesList[index],
                    onTap: () {
                      Get.to(() => DetailedScheduleUI(), arguments: [schedulesList[index]]);
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class CasesScheduleController extends GetxController {
  static CasesScheduleController get to => Get.find();

  final FireStoreService fireStoreService =
      FireStoreService(uid: AuthController.to.firebaseUser.value.uid);
  final String uid = AuthController.to.firebaseUser.value.uid;

  Stream<DocumentSnapshot> scheduleStream;
  @override
  void onInit() {
    super.onInit();
    scheduleStream = fireStoreService.streamFireStoreUserSchedules();
  }
}

class ClientScheduleWidget extends StatefulWidget {
  const ClientScheduleWidget({Key key}) : super(key: key);

  @override
  _ClientScheduleWidgetState createState() => _ClientScheduleWidgetState();
}

class _ClientScheduleWidgetState extends State<ClientScheduleWidget>
    with AutomaticKeepAliveClientMixin<ClientScheduleWidget> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<ClientScheduleController>(
      init: ClientScheduleController(),
      builder: (controller) {
        return StreamBuilder<DocumentSnapshot>(
          stream: controller.scheduleStream,
          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError && !snapshot.hasData) {
              return Center(
                child: Text('Unable to load schedules'),
              );
            }

            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            List<dynamic> schedulesData = [];
            print(snapshot.data.data());
            try {
              schedulesData = snapshot.data.get('schedules');
            } catch (e) {
              print(e);
            }
            List<ScheduleModel> schedulesList =
                schedulesData.map((element) => ScheduleModel.fromJson(element)).toList();
            schedulesList.retainWhere((element) => element.type == 'Client');

            if (schedulesList == null || schedulesList.isEmpty) {
              return Center(
                child: Text('No schedules for now!'),
              );
            }

            return MediaQuery.removePadding(
              removeTop: true,
              context: context,
              child: ListView.builder(
                itemCount: schedulesList.length,
                itemBuilder: (BuildContext context, int index) {
                  return SingleScheduleCard(
                    schedule: schedulesList[index],
                    onTap: () {
                      Get.to(() => DetailedScheduleUI(), arguments: [schedulesList[index]]);
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}

class ClientScheduleController extends GetxController {
  static ClientScheduleController get to => Get.find();

  final FireStoreService fireStoreService =
      FireStoreService(uid: AuthController.to.firebaseUser.value.uid);
  final String uid = AuthController.to.firebaseUser.value.uid;

  Stream<DocumentSnapshot> scheduleStream;
  @override
  void onInit() {
    super.onInit();
    scheduleStream = fireStoreService.streamFireStoreUserSchedules();
  }
}
