import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/ui/components/components.dart';
import 'package:flutter_al_law/utils/date_time_utils.dart';
import 'package:flutter_al_law/utils/helpers.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class DetailedNoteUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DetailedNoteController(),
      builder: (DetailedNoteController controller) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () async {
                String shareText = '${controller.noteData.type} Note\n'
                    '\nTitle -> ${controller.noteData.title}'
                    '\nDateTime -> ${controller.noteData.dateTime}'
                    '\nDetail -> ${controller.noteData.detail}';
                await Share.share(shareText);
              },
            ),
            IconButton(
              icon: Icon(controller.editNoteStatus ? Icons.save_alt : Icons.edit),
              onPressed: () async {
                if (controller.editNoteStatus) {
                  Get.dialog(
                    CustomAlertDialog(
                      'Save Changes',
                      'Do you want to save changes made to note?',
                      'Save',
                      'Cancel',
                      onPositiveButton: () async {
                        Get.back();
                        await controller.updateNoteToFirebase();
                        Get.back();
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
                controller.editNoteStatus
                    ? controller.changeEditNoteStatus(false)
                    : controller.changeEditNoteStatus(true);
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
                      await controller.deleteNoteFromFirebase();
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
            'Note Detail',
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
                      Icons.sticky_note_2,
                      size: 80,
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.noteData.title,
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          Text(
                            controller.noteData.detail,
                            style: TextStyle(color: Colors.white54, fontSize: 14),
                          ),
                          Text(
                            dateFormat.format(controller.noteData.dateTime),
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
                    NoteDetailsFormWidget(),
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

class NoteDetailsFormWidget extends StatefulWidget {
  @override
  _NoteDetailsFormWidgetState createState() => _NoteDetailsFormWidgetState();
}

class _NoteDetailsFormWidgetState extends State<NoteDetailsFormWidget>
    with AutomaticKeepAliveClientMixin<NoteDetailsFormWidget> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<DetailedNoteController>(
      builder: (controller) => SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            children: [
              CustomTextWidgetOutlined(
                controller: controller.noteTitleCtrl,
                label: '* Note Title',
                enabled: controller.editNoteStatus,
                keyboardType: TextInputType.name,
                keyboardAction: TextInputAction.next,
                obscureText: false,
                validators: (val) {
                  if (val.length == 0) {
                    return "Title can't be empty";
                  } else {
                    return null;
                  }
                },
              ),
              CustomTextWidgetOutlined(
                controller: controller.noteDetailCtrl,
                label: '* Note Detail',
                enabled: controller.editNoteStatus,
                keyboardType: TextInputType.name,
                keyboardAction: TextInputAction.next,
                obscureText: false,
                validators: (val) {
                  if (val.length == 0) {
                    return "Detail can't be empty.";
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
                enabled: controller.editNoteStatus,
                controller: controller.noteDateTimeCtrl,
                dateMask: 'd MMMM, yyyy - hh:mm a',
                // initialValue: dateFormat.format(DateTime.now()),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                style: TextStyle(
                  color: controller.editNoteStatus ? Colors.black87 : Colors.black54,
                ),
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
                  labelStyle: TextStyle(
                    color: controller.editNoteStatus ? Colors.orange : Colors.orange.shade300,
                  ),
                  labelText: '* Case Date',
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
                      color: controller.editNoteStatus ? Colors.black45 : Colors.black38,
                      width: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
