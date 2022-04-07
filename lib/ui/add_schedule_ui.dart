import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/ui/components/components.dart';
import 'package:flutter_al_law/ui/guest/guest_dashboard_ui.dart';
import 'package:flutter_al_law/utils/helpers.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';

class AddScheduleUI extends StatelessWidget {
  final NotificationsController _notificationsController = NotificationsController.to;
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AddScheduleController(),
      builder: (AddScheduleController controller) {
        return Scaffold(
          body: GestureDetector(
            onTap: () {
              Helpers.unFocus();
            },
            child: Column(
              children: [
                Container(
                  height: 85,
                  child: ClipPath(
                    clipper: CustomAppBarClipper(),
                    child: AppBar(
                      title: Text(
                        'Add Schedule',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Form(
                    key: controller.formKey,
                    child: Column(
                      children: [
                        Expanded(
                          child: SingleChildScrollView(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                              child: Column(
                                children: [
                                  CustomTextWidgetOutlined(
                                    controller: controller.scheduleTitleCtrl,
                                    label: '* Schedule Title',
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
                                    // initialValue: dateFormat.format(DateTime.now()),
                                    controller: controller.scheduleDateTimeCtrl,
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2100),
                                    validator: (val) {
                                      if (val.length == 0) {
                                        return "Date can't be empty.";
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
                                      labelStyle: TextStyle(color: Colors.orange),
                                      labelText: '* Schedule Date Time',
                                      filled: false,
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4.0),
                                        borderSide: BorderSide(
                                          color: Colors.black,
                                          width: 1.0,
                                        ),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(4.0),
                                        ),
                                        borderSide: BorderSide(
                                          color: Colors.black45,
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
                                    keyboardType: TextInputType.text,
                                    keyboardAction: TextInputAction.next,
                                    obscureText: false,
                                  ),
                                  CustomTextWidgetOutlined(
                                    controller: controller.scheduleRemarksCtrl,
                                    label: 'Schedule Remarks',
                                    keyboardType: TextInputType.text,
                                    keyboardAction: TextInputAction.done,
                                    obscureText: false,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Container(
                          color: Colors.black,
                          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () async {
                                  if (controller.formKey.currentState.validate()) {
                                    String notificationTag = Uuid().v1();
                                    ScheduleModel _schedule = new ScheduleModel(
                                      id: controller.scheduleID,
                                      type: controller.scheduleType,
                                      title: controller.scheduleTitleCtrl.text,
                                      dateTime:
                                          DateTime.parse(controller.scheduleDateTimeCtrl.text),
                                      detail: controller.scheduleDetailCtrl.text,
                                      remarks: controller.scheduleRemarksCtrl.text,
                                      notificationTag: notificationTag,
                                    );
                                    try {
                                      await controller.addScheduleToFireStore(_schedule);
                                      Get.back();
                                      _notificationsController.scheduleNewNotification(
                                        notificationTag,
                                        controller.scheduleTitleCtrl.text,
                                        controller.scheduleDetailCtrl.text,
                                        DateTime.parse(controller.scheduleDateTimeCtrl.text),
                                      );
                                      Get.snackbar(
                                        'Schedule',
                                        'Added successfully',
                                        snackPosition: SnackPosition.BOTTOM,
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
                                        colorText: Get.theme.snackBarTheme.actionTextColor,
                                      );
                                    } catch (e) {
                                      print(e);
                                      Get.back();
                                      Get.snackbar(
                                        'Issue Occurred',
                                        'There was an issue faced',
                                        snackPosition: SnackPosition.BOTTOM,
                                        duration: Duration(seconds: 3),
                                        backgroundColor: Get.theme.snackBarTheme.backgroundColor,
                                        colorText: Get.theme.snackBarTheme.actionTextColor,
                                      );
                                    }
                                  }
                                },
                                child: Text('Complete'),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
