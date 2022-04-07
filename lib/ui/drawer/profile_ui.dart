import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_al_law/bloc/drawer_bloc.dart';
import 'package:flutter_al_law/constants/app_themes.dart';
import 'package:flutter_al_law/controllers/profile_controller.dart';
import 'package:flutter_al_law/helpers/helpers.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/ui/components/components.dart';
import 'package:flutter_al_law/utils/custom_text_input_formatter.dart';
import 'package:get/get.dart';

class ProfileUI extends StatelessWidget with DrawerStates {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (controller) {
        return StreamBuilder<UserModel>(
          stream: controller.userModelStream,
          builder: (BuildContext context, AsyncSnapshot<UserModel> snapshot) {
            print(snapshot.connectionState);
            if (snapshot.hasError) {
              return Container();
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container();
            }

            controller.nameController.text = snapshot.data.name;
            controller.emailController.text = snapshot.data.email;
            controller.mobileController.text = snapshot.data.mobile;
            controller.selectedServices = snapshot.data.services ?? [];
            controller.selectedDegrees = snapshot.data.degrees ?? [];

            return Card(
              margin: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    child: IntrinsicHeight(
                      child: Row(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Center(
                            child: Text(
                              'Personal Information',
                              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                          Spacer(),
                          controller.status
                              ? _getEditWidget(controller)
                              : _getSaveWidget(controller),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: true,
                      child: ListView(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              //Name
                              Text(
                                'Name',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ).paddingOnly(left: 14.0, right: 12.0, top: 8),
                              Container(
                                height: 45,
                                child: new TextField(
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                  controller: controller.nameController,
                                  enabled: !controller.status,
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 2,
                                    ),
                                  ),
                                ),
                              ).paddingOnly(left: 12.0, right: 12.0, top: 3.0),
                              //Email ID
                              Text(
                                'Email ID',
                                style: TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ).paddingOnly(left: 14.0, right: 12.0, top: 12.0),
                              Container(
                                height: 45,
                                child: new TextField(
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 2,
                                    ),
                                    hintText: "example@abc.com",
                                  ),
                                  controller: controller.emailController,
                                  // enabled: !controller.status,
                                  enabled: false,
                                ),
                              ).paddingOnly(left: 12.0, right: 12.0, top: 3.0),
                              //Mobile
                              Row(
                                children: <Widget>[
                                  new Text(
                                    'Mobile',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ).paddingOnly(left: 14.0, right: 12.0, top: 12.0),
                              Container(
                                height: 45,
                                child: new TextFormField(
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 2,
                                    ),
                                    hintText: "Enter Mobile Number",
                                  ),
                                  inputFormatters: [
                                    new MaskTextInputFormatter(
                                      mask: '####-#######',
                                      filter: {
                                        "#": RegExp(r'[0-9]'),
                                      },
                                    ),
                                  ],
                                  validator: Validator().phone,
                                  controller: controller.mobileController,
                                  enabled: !controller.status,
                                  keyboardType: TextInputType.phone,
                                ),
                              ).paddingOnly(left: 12.0, right: 12.0, top: 3.0),
                              //Education
                              Row(
                                children: <Widget>[
                                  new Text(
                                    'Education',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ).paddingOnly(left: 14.0, right: 12.0, top: 12.0),
                              Container(
                                height: 45,
                                child: new TextField(
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 2,
                                    ),
                                    hintText: "Latest degree",
                                  ),
                                  controller: controller.educationController,
                                  enabled: !controller.status,
                                  keyboardType: TextInputType.text,
                                ),
                              ).paddingOnly(left: 12.0, right: 12.0, top: 3.0),
                              //Experience
                              Row(
                                children: <Widget>[
                                  new Text(
                                    'Experience in years',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ).paddingOnly(left: 14.0, right: 12.0, top: 12.0),
                              Container(
                                height: 45,
                                child: new TextField(
                                  style: TextStyle(
                                    fontSize: 14,
                                  ),
                                  decoration: const InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                      vertical: 2,
                                    ),
                                    hintText: "e.g  10",
                                  ),
                                  inputFormatters: [
                                    FilteringTextInputFormatter.digitsOnly,
                                    LengthLimitingTextInputFormatter(3)
                                  ],
                                  controller: controller.experienceController,
                                  enabled: !controller.status,
                                  keyboardType: TextInputType.number,
                                ),
                              ).paddingOnly(left: 12.0, right: 12.0, top: 3.0),
                              //Services
                              Row(
                                children: <Widget>[
                                  new Text(
                                    'Services',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ).paddingOnly(left: 14.0, right: 12.0, top: 12.0),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: !controller.status ? AppThemes.nevada : Colors.black26,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                ),
                                height: 45,
                                child: Center(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Text(
                                        controller.selectedServices != null &&
                                                controller.selectedServices.isNotEmpty
                                            ? 'Edit services'
                                            : 'Add services',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        onPressed: !controller.status
                                            ? () {
                                                showModalBottomSheet(
                                                    shape: BottomSheetShape(),
                                                    context: context,
                                                    isDismissible: false,
                                                    builder: (context) {
                                                      return MultiSelectChip(
                                                        controller.lawyerServices,
                                                        controller.selectedServices,
                                                        onServicesSaved: (selectedList) {
                                                          controller
                                                              .onServicesConfirm(selectedList);
                                                        },
                                                      );
                                                    });
                                              }
                                            : null,
                                        icon: Icon(
                                          controller.selectedServices != null &&
                                                  controller.selectedServices.isNotEmpty
                                              ? Icons.edit
                                              : Icons.add,
                                          color:
                                              !controller.status ? Colors.black87 : Colors.black26,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ).paddingOnly(left: 12.0, right: 12.0, top: 3.0),
                              controller.selectedServices != null &&
                                      controller.selectedServices.isNotEmpty
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: !controller.status
                                              ? AppThemes.nevada
                                              : Colors.black26,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                      ),
                                      child: Wrap(
                                        children: controller.selectedServices
                                            .map((service) => Container(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: ChoiceChip(
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize.shrinkWrap,
                                                    label: Text(
                                                      service,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: !controller.status
                                                            ? Colors.white
                                                            : Colors.black54,
                                                      ),
                                                    ),
                                                    pressElevation: 0,
                                                    selected: true,
                                                    onSelected: (selected) {},
                                                    selectedColor: !controller.status
                                                        ? Colors.black
                                                        : Colors.black12,
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    ).paddingOnly(left: 12.0, right: 12.0, top: 1)
                                  : SizedBox.shrink(),

                              //Education
                              Row(
                                children: <Widget>[
                                  new Text(
                                    'Degrees',
                                    style: TextStyle(
                                      fontSize: 12.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ).paddingOnly(left: 14.0, right: 12.0, top: 12.0),
                              Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: !controller.status ? AppThemes.nevada : Colors.black26,
                                    width: 1.0,
                                  ),
                                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                ),
                                height: 45,
                                child: Center(
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 12,
                                      ),
                                      Text(
                                        controller.selectedDegrees != null &&
                                                controller.selectedDegrees.isNotEmpty
                                            ? 'Edit degrees'
                                            : 'Add degrees',
                                        style: TextStyle(fontSize: 14),
                                      ),
                                      Spacer(),
                                      IconButton(
                                        onPressed: !controller.status
                                            ? () {
                                                showModalBottomSheet(
                                                    shape: BottomSheetShape(),
                                                    context: context,
                                                    isDismissible: false,
                                                    builder: (context) {
                                                      return MultiSelectChip(
                                                        controller.lawyerDegrees,
                                                        controller.selectedDegrees,
                                                        onServicesSaved: (selectedList) {
                                                          controller.onDegreesConfirm(selectedList);
                                                        },
                                                      );
                                                    });
                                              }
                                            : null,
                                        icon: Icon(
                                          controller.selectedDegrees != null &&
                                                  controller.selectedDegrees.isNotEmpty
                                              ? Icons.edit
                                              : Icons.add,
                                          color:
                                              !controller.status ? Colors.black87 : Colors.black26,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ).paddingOnly(left: 12.0, right: 12.0, top: 3.0),
                              controller.selectedDegrees != null &&
                                      controller.selectedDegrees.isNotEmpty
                                  ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: !controller.status
                                              ? AppThemes.nevada
                                              : Colors.black26,
                                          width: 1.0,
                                        ),
                                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                                      ),
                                      child: Wrap(
                                        children: controller.selectedDegrees
                                            .map((service) => Container(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: ChoiceChip(
                                                    materialTapTargetSize:
                                                        MaterialTapTargetSize.shrinkWrap,
                                                    label: Text(
                                                      service,
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: !controller.status
                                                            ? Colors.white
                                                            : Colors.black54,
                                                      ),
                                                    ),
                                                    pressElevation: 0,
                                                    selected: true,
                                                    onSelected: (selected) {},
                                                    selectedColor: !controller.status
                                                        ? Colors.black
                                                        : Colors.black12,
                                                  ),
                                                ))
                                            .toList(),
                                      ),
                                    ).paddingOnly(left: 12.0, right: 12.0, top: 1)
                                  : SizedBox.shrink(),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  // SizedBox(
                  //   height: 8,
                  // ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _getSaveWidget(ProfileController controller) {
    return Row(
      children: [
        TextButton(
          child: new Text(
            "Cancel",
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
          onPressed: () {
            controller.changeStatus(true);
          },
        ),
        SizedBox(
          width: 2,
        ),
        TextButton(
          child: new Text(
            "Save",
            style: TextStyle(
              color: Colors.blue,
            ),
          ),
          onPressed: () {
            controller.changeStatus(true);
            controller.updateFirebaseUserAndProfile(
              controller.nameController.text,
              controller.mobileController.text,
              controller.experienceController.text,
              controller.selectedServices,
              controller.selectedDegrees,
            );
          },
        ),
      ],
    );
  }

  // Widget _getActionButtons(ProfileController controller) {
  //   return Padding(
  //     padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 35.0),
  //     child: new Row(
  //       mainAxisSize: MainAxisSize.max,
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       children: <Widget>[
  //         Expanded(
  //           child: Padding(
  //             padding: EdgeInsets.only(right: 10.0),
  //             child: Container(
  //               child: new RaisedButton(
  //                 child: new Text("Save"),
  //                 textColor: Colors.white,
  //                 color: Colors.black,
  //                 onPressed: () {
  //                   controller.changeStatus(true);
  //                   controller.updateFirebaseUserAndProfile(
  //                     controller.nameController.text,
  //                     controller.mobileController.text,
  //                     controller.experienceController.text,
  //                     controller.selectedServices,
  //                     controller.selectedDegrees,
  //                   );
  //                 },
  //                 shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(20.0)),
  //               ),
  //             ),
  //           ),
  //         ),
  //         Expanded(
  //           child: Padding(
  //             padding: EdgeInsets.only(left: 10.0),
  //             child: Container(
  //                 child: new RaisedButton(
  //               child: new Text("Cancel"),
  //               // textColor: Colors.bla,
  //               color: Colors.white,
  //               onPressed: () {
  //                 controller.changeStatus(true);
  //               },
  //               shape: new RoundedRectangleBorder(
  //                 side: BorderSide(color: Colors.black, width: 1),
  //                 borderRadius: new BorderRadius.circular(
  //                   20.0,
  //                 ),
  //               ),
  //             )),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _getEditWidget(ProfileController controller) {
    return TextButton(
      onPressed: () {
        controller.changeStatus(false);
      },
      child: Text(
        'Edit',
        style: TextStyle(
          color: Colors.blue,
        ),
      ),
    );
  }
}
