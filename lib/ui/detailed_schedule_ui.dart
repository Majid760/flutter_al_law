import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/ui/components/components.dart';
import 'package:flutter_al_law/utils/date_time_utils.dart';
import 'package:flutter_al_law/utils/helpers.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class DetailedScheduleUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DetailedScheduleController(),
      builder: (DetailedScheduleController controller) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () async {
                String shareText = '${controller.scheduleData.type} Schedule\n'
                    '\nTitle -> ${controller.scheduleData.title}'
                    '\nDateTime -> ${controller.scheduleData.dateTime}'
                    '\nDetail -> ${controller.scheduleData.detail}';
                await Share.share(shareText);
              },
            ),
            IconButton(
              icon: Icon(controller.editScheduleStatus ? Icons.save_alt : Icons.edit),
              onPressed: () async {
                if (controller.editScheduleStatus) {
                  Get.dialog(
                    CustomAlertDialog(
                      'Save Changes',
                      'Do you want to save changes made to note?',
                      'Save',
                      'Cancel',
                      onPositiveButton: () async {
                        Get.back();
                        await Helpers.showLoader(context);
                        await controller.updateScheduleToFirebase();
                        Get.back();
                        Helpers.hideLoader();
                        Get.snackbar('Saved', 'Saved changes successfully',
                            snackPosition: SnackPosition.BOTTOM,
                            duration: Duration(seconds: 3),
                            backgroundColor: Get.theme.snackBarTheme.backgroundColor,
                            colorText: Get.theme.snackBarTheme.actionTextColor);
                      },
                      onNegativeButton: () {
                        Get.back();
                      },
                    ),
                  );
                }
                controller.editScheduleStatus
                    ? controller.changeEditScheduleStatus(false)
                    : controller.changeEditScheduleStatus(true);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                Get.dialog(
                  CustomAlertDialog(
                    'Delete Note',
                    'Do you want to delete this note?',
                    'Delete',
                    'Cancel',
                    onPositiveButton: () async {
                      Get.back();
                      await Helpers.showLoader(context);
                      await controller.deleteScheduleFromFirebase();
                      await controller.removeNotificationIfExists();
                      Get.back();
                      Helpers.hideLoader();
                      Get.snackbar('Deleted', 'Deleted note successfully',
                          snackPosition: SnackPosition.BOTTOM,
                          duration: Duration(seconds: 3),
                          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
                          colorText: Get.theme.snackBarTheme.actionTextColor);
                    },
                    onNegativeButton: () {
                      Get.back();
                    },
                  ),
                );
              },
            ),
          ],
          title: Text(
            'Schedule Detail',
          ),
        ),
        body: GestureDetector(
          onTap: () {
            Helpers.unFocus();
          },
          child: Column(
            children: [
              Container(
                color: Colors.black,
                height: 100,
                padding: const EdgeInsets.symmetric(vertical: 5.0, horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.schedule,
                      size: 80,
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.scheduleData.title,
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          Text(
                            controller.scheduleData.detail,
                            style: TextStyle(color: Colors.white54, fontSize: 14),
                          ),
                          Text(
                            dateFormat.format(controller.scheduleData.dateTime),
                            style: TextStyle(color: Colors.white54, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Material(
                color: Colors.black,
                elevation: 2,
                child: TabBar(
                  unselectedLabelColor: Colors.white.withOpacity(0.5),
                  indicatorColor: Colors.white,
                  indicatorWeight: 3,
                  isScrollable: false,
                  tabs: <Tab>[
                    new Tab(
                      text: "BASIC DETAILS",
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
                  children: <Widget>[
                    ScheduleDetailsFormWidget(),
                  ],
                  controller: controller.tabController,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ScheduleDetailsFormWidget extends StatefulWidget {
  @override
  _ScheduleDetailsFormWidgetState createState() => _ScheduleDetailsFormWidgetState();
}

class _ScheduleDetailsFormWidgetState extends State<ScheduleDetailsFormWidget>
    with AutomaticKeepAliveClientMixin<ScheduleDetailsFormWidget> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<DetailedScheduleController>(
      builder: (controller) => SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            children: [
              CustomTextWidgetOutlined(
                controller: controller.scheduleTitleCtrl,
                label: '* Schedule Title',
                enabled: controller.editScheduleStatus,
                keyboardType: TextInputType.name,
                keyboardAction: TextInputAction.next,
                obscureText: false,
                validators: (val) {
                  if (val.length == 0) {
                    return "Title can't be empty.";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 8,
              ),
              DateTimePicker(
                type: DateTimePickerType.dateTime,
                enabled: controller.editScheduleStatus,
                controller: controller.scheduleDateTimeCtrl,
                dateMask: 'd MMMM, yyyy - hh:mm a',
                // initialValue: dateFormat.format(DateTime.now()),
                firstDate: DateTime.now(),
                lastDate: DateTime(2100),
                style: TextStyle(
                  color: controller.editScheduleStatus ? Colors.black87 : Colors.black54,
                ),
                validator: (val) {
                  if (val.length == 0) {
                    return "Schedule Date can't be empty.";
                  } else {
                    return null;
                  }
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 9,
                    horizontal: 17,
                  ),
                  suffixIcon: Icon(
                    Icons.access_time,
                    color: Colors.black45,
                  ),
                  labelStyle: TextStyle(
                    color: controller.editScheduleStatus ? Colors.orange : Colors.orange.shade300,
                  ),
                  labelText: '* Schedule Date Time',
                  filled: false,
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide(
                      color: Colors.black,
                      width: 1.0,
                    ),
                  ),
                  disabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    borderSide: BorderSide(
                      color: Colors.black12,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    borderSide: BorderSide(
                      color: controller.editScheduleStatus ? Colors.black45 : Colors.black38,
                      width: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              CustomTextWidgetOutlined(
                controller: controller.scheduleDetailCtrl,
                label: 'Schedule Detail',
                enabled: controller.editScheduleStatus,
                keyboardType: TextInputType.text,
                keyboardAction: TextInputAction.next,
                obscureText: false,
              ),
              CustomTextWidgetOutlined(
                controller: controller.scheduleRemarksCtrl,
                label: 'Schedule Remarks',
                enabled: controller.editScheduleStatus,
                keyboardType: TextInputType.text,
                keyboardAction: TextInputAction.done,
                obscureText: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
