import 'package:date_time_picker/date_time_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/models/add_note_model.dart';
import 'package:flutter_al_law/ui/components/components.dart';
import 'package:flutter_al_law/ui/guest/guest_dashboard_ui.dart';
import 'package:flutter_al_law/utils/helpers.dart';
import 'package:get/get.dart';

class AddNoteUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AddNoteController(),
      builder: (AddNoteController controller) {
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
                        'Add Note',
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
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            child: Column(
                              children: [
                                CustomTextWidgetOutlined(
                                  controller: controller.noteTitleCtrl,
                                  label: '* Note Title',
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
                                CustomTextWidgetOutlined(
                                  controller: controller.noteDetailCtrl,
                                  label: '* Note Detail',
                                  keyboardType: TextInputType.text,
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
                                  controller: controller.noteDateTimeCtrl,
                                  dateMask: 'd MMMM, yyyy - hh:mm a',
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100),
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
                                    labelText: '* Note Date Time',
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
                                // SizedBox(
                                //   height: 8,
                                // ),
                                // CustomTextWidgetOutlined(
                                //   controller: controller.noteRemarksCtrl,
                                //   label: 'Note Remarks',
                                //   keyboardType: TextInputType.text,
                                //   keyboardAction: TextInputAction.done,
                                //   obscureText: false,
                                // ),
                              ],
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
                                    NoteModel _note = new NoteModel(
                                      id: controller.noteID,
                                      type: controller.noteType,
                                      title: controller.noteTitleCtrl.text,
                                      dateTime: DateTime.parse(controller.noteDateTimeCtrl.text),
                                      detail: controller.noteDetailCtrl.text,
                                    );
                                    try {
                                      await controller.addNoteToFireStore(_note);
                                      Get.back();
                                      Get.snackbar('Note', 'Added successfully',
                                          snackPosition: SnackPosition.BOTTOM,
                                          duration: Duration(seconds: 3),
                                          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
                                          colorText: Get.theme.snackBarTheme.actionTextColor);
                                    } catch (e) {
                                      print(e);
                                      Get.back();
                                      Get.snackbar('Issue Occurred', 'There was an issue faced',
                                          snackPosition: SnackPosition.BOTTOM,
                                          duration: Duration(seconds: 3),
                                          backgroundColor: Get.theme.snackBarTheme.backgroundColor,
                                          colorText: Get.theme.snackBarTheme.actionTextColor);
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
