import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_al_law/bloc/drawer_bloc.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/ui/components/components.dart';
import 'package:get/get.dart';

class EvidencesUI extends StatelessWidget with DrawerStates {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<EvidencesUIController>(
      init: EvidencesUIController(),
      builder: (controller) => StreamBuilder<DocumentSnapshot>(
        stream: controller.evidenceStream,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.hasError && !snapshot.hasData) {
            return Center(
              child: Text('Unable to load evidences'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          List<dynamic> schedulesData = [];
          print(snapshot.data.data());
          try {
            schedulesData = snapshot.data.get('evidences');
          } catch (e) {
            print(e);
          }
          List<ScheduleModel> schedulesList =
              schedulesData.map((element) => ScheduleModel.fromJson(element)).toList();

          if (schedulesList == null || schedulesList.isEmpty) {
            return Center(
              child: Text('No evidences for now!'),
            );
          }

          return MediaQuery.removePadding(
            removeTop: true,
            context: context,
            child: ListView.builder(
              itemCount: schedulesList.length,
              itemBuilder: (BuildContext context, int index) {
                return SingleScheduleCard(schedule: schedulesList[index]);
              },
            ),
          );
        },
      ),
    );
  }
}
