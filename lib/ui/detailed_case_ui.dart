import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/ui/components/components.dart';
import 'package:flutter_al_law/ui/ui.dart';
import 'package:flutter_al_law/utils/date_time_utils.dart';
import 'package:flutter_al_law/utils/helpers.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

enum ScheduleType {
  Client_Meeting,
  Case_Discussion,
  Case_Hearing,
}

class DetailedCaseUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DetailedCaseController(),
      builder: (DetailedCaseController controller) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () async {
                String shareText = 'Basic Details\n'
                    '\nClient Name -> ${controller.caseData.clientName}'
                    '\nCase Name -> ${controller.caseData.caseName}'
                    '\nCase No. -> ${controller.caseData.caseNumber}'
                    '\nCase Remarks -> ${controller.caseData.caseRemarks}'
                    '\nCase Date -> ${controller.caseData.caseDate}'
                    '\n\nCase Details\n'
                    '\nCase Type -> ${controller.caseData.caseType}'
                    '\nCase Charges -> ${controller.caseData.caseCharges}'
                    '\nCase Petitioner -> ${controller.caseData.casePetitioner}'
                    '\nCase Description -> ${controller.caseData.caseDesc}'
                    '\n\nCourt Details\n'
                    '\nCourt Name -> ${controller.caseData.courtName}'
                    '\nCourt City -> ${controller.caseData.courtCity}'
                    '\nJudge Name -> ${controller.caseData.judgeName}';
                await Share.share(shareText);
              },
            ),
            IconButton(
              icon: Icon(controller.editCaseStatus ? Icons.save_alt : Icons.edit),
              onPressed: () async {
                if (controller.editCaseStatus) {
                  Get.dialog(
                    CustomAlertDialog(
                      'Save Changes',
                      'Do you want to save changes made to case?',
                      'Save',
                      'Cancel',
                      onPositiveButton: () async {
                        Get.back();
                        await Helpers.showLoader(context);
                        await controller.updateCaseToFirebase();
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
                controller.editCaseStatus
                    ? controller.changeEditCaseStatus(false)
                    : controller.changeEditCaseStatus(true);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                Get.dialog(
                  CustomAlertDialog(
                    'Delete Case',
                    'Do you want to delete this case?',
                    'Delete',
                    'Cancel',
                    onPositiveButton: () async {
                      Get.back();
                      await Helpers.showLoader(context);
                      await controller.deleteCaseFromFirebase();
                      Get.back();
                      Helpers.hideLoader();
                      Get.snackbar('Deleted', 'Deleted case successfully',
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
              // onPressed: () async {
              //   await controller.deleteCaseFromFirebase();
              //   Get.back();
              // },
            ),
          ],
          title: Text(
            'Case Detail',
          ),
        ),
        floatingActionButton: _buildSpeedDial(controller),
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
                      Icons.book,
                      size: 80,
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            controller.caseData.caseName,
                            style: TextStyle(color: Colors.white, fontSize: 22),
                          ),
                          Text(
                            controller.caseData.clientName,
                            style: TextStyle(color: Colors.white54, fontSize: 14),
                          ),
                          Text(
                            dateFormat.format(controller.caseData.caseDate),
                            style: TextStyle(color: Colors.white54, fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    ToggleButtons(
                      borderWidth: 0.5,
                      borderColor: Colors.white54,
                      selectedBorderColor: Colors.white54,
                      selectedColor: Colors.white,
                      color: Colors.white54,
                      fillColor: Colors.orange,
                      // constraints: BoxConstraints(
                      //   minHeight: Get.width > 500 ? 30 : 24,
                      //   minWidth: Get.width > 500 ? 48 : 36,
                      // ),
                      // borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        topRight: Radius.circular(5),
                        bottomRight: Radius.circular(25),
                        bottomLeft: Radius.circular(5),
                      ),
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "OPEN",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "CLOSE",
                            style: TextStyle(
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                      onPressed: (int index) {
                        print("Index: " + index.toString());
                        for (int buttonIndex = 0;
                            buttonIndex < controller.isSelected.length;
                            buttonIndex++) {
                          if (buttonIndex == index) {
                            controller.updateSelected(true, buttonIndex);
                          } else {
                            controller.updateSelected(false, buttonIndex);
                          }
                        }
                      },
                      isSelected: controller.isSelected,
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
                  isScrollable: true,
                  tabs: <Tab>[
                    new Tab(
                      text: "CASE DETAILS",
                    ),
                    new Tab(
                      text: "EVIDENCES",
                    ),
                    new Tab(
                      text: "SCHEDULES",
                    ),
                    new Tab(
                      text: "NOTES",
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
                    _buildCaseDetailsTabView(),
                    _buildEvidencesTabView(),
                    _buildScheduleTabView(),
                    _buildNotesTabView(),
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

  _buildCaseDetailsTabView() {
    return CaseDetailsFormWidget();
  }

  _buildEvidencesTabView() {
    return Center(
      child: Text(
        "Evidences",
      ),
    );
  }

  _buildScheduleTabView() {
    return CasesSchedules();
  }

  _buildNotesTabView() {
    return CasesNotes();
  }

  SpeedDial _buildSpeedDial(DetailedCaseController controller) {
    return SpeedDial(
      marginEnd: 18,
      marginBottom: 20,
      icon: Icons.add,
      activeIcon: Icons.clear,
      buttonSize: 56.0,
      visible: true,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.1,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.orange,
      foregroundColor: Colors.white,
      elevation: 8.0,
      shape: CircleBorder(),
      // orientation: SpeedDialOrientation.Up,
      // childMarginBottom: 2,
      // childMarginTop: 2,
      children: [
        SpeedDialChild(
          child: Icon(
            Icons.note_add,
            color: Colors.white,
          ),
          backgroundColor: Colors.orange,
          label: 'Add Notes',
          labelStyle: TextStyle(
            fontSize: 14.0,
            color: Colors.white,
          ),
          labelBackgroundColor: Colors.black54,
          onTap: () => Get.to(() => AddNoteUI(), arguments: [controller.caseID, "Case"]),
          // onLongPress: () => print('ADD NOTES'),
        ),
        SpeedDialChild(
          child: Icon(
            Icons.image_search,
            color: Colors.white,
          ),
          backgroundColor: Colors.orange,
          label: 'Add Evidence',
          labelStyle: TextStyle(
            fontSize: 14.0,
            color: Colors.white,
          ),
          labelBackgroundColor: Colors.black54,
          // onTap: () => Get.to(() => AddEvidenceUI(), arguments: controller.caseID),
          onTap: () {},
          // onLongPress: () => print('ADD EVIDENCE'),
        ),
        SpeedDialChild(
          child: Icon(
            Icons.calendar_today,
            color: Colors.white,
          ),
          backgroundColor: Colors.orange,
          label: 'Add Schedule',
          labelStyle: TextStyle(
            fontSize: 14.0,
            color: Colors.white,
          ),
          labelBackgroundColor: Colors.black54,
          onTap: () => Get.to(() => AddScheduleUI(), arguments: [controller.caseID, "Case"]),
          // onLongPress: () => print('ADD SCHEDULE'),
        ),
      ],
    );
  }
}

class CaseDetailsFormWidget extends StatefulWidget {
  @override
  _CaseDetailsFormWidgetState createState() => _CaseDetailsFormWidgetState();
}

class _CaseDetailsFormWidgetState extends State<CaseDetailsFormWidget>
    with AutomaticKeepAliveClientMixin<CaseDetailsFormWidget> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<DetailedCaseController>(
      builder: (controller) => SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            children: [
              CustomTextWidgetOutlined(
                controller: controller.clientNameCtrl,
                label: '* Client Name',
                enabled: controller.editCaseStatus,
                // hintText: 'John',
                keyboardType: TextInputType.name,
                keyboardAction: TextInputAction.done,
                // focusNode: userNameNode,
                // onFieldSubmitted: (term) {
                //   userNameNode.unfocus();
                //   FocusScope.of(context).requestFocus(emailNode);
                // },
                obscureText: false,
                validators: (val) {
                  if (val.length == 0) {
                    return "Client can't be empty";
                  } else {
                    return null;
                  }
                },
                // onSaved: (value) {
                //   registerData.userName = value;
                // },
              ),
              CustomTextWidgetOutlined(
                controller: controller.caseNameCtrl,
                label: '* Case Name',
                enabled: controller.editCaseStatus,
                // hintText: 'Theft',
                // focusNode: emailNode,
                // onFieldSubmitted: (term) {
                //   emailNode.unfocus();
                //   FocusScope.of(context).requestFocus(passwordNode);
                // },
                keyboardType: TextInputType.text,
                keyboardAction: TextInputAction.done,
                obscureText: false,
                validators: (val) {
                  if (val.length == 0) {
                    return "Case can't be empty.";
                  } else {
                    return null;
                  }
                },
                // onSaved: (value) {
                //   registerData.email = value;
                // },
              ),
              CustomTextWidgetOutlined(
                controller: controller.caseNumberCtrl,
                label: '* Case Number',
                enabled: controller.editCaseStatus,
                // hintText: '0012',
                // focusNode: emailNode,
                // onFieldSubmitted: (term) {
                //   emailNode.unfocus();
                //   FocusScope.of(context).requestFocus(passwordNode);
                // },
                keyboardType: TextInputType.number,
                keyboardAction: TextInputAction.done,
                obscureText: false,
                validators: (val) {
                  if (val.length == 0) {
                    return "Case Number can't be empty.";
                  } else {
                    return null;
                  }
                },
                // onSaved: (value) {
                //   registerData.email = value;
                // },
              ),
              CustomTextWidgetOutlined(
                controller: controller.caseRemarksCtrl,
                label: 'Case Remarks',
                enabled: controller.editCaseStatus,
                keyboardType: TextInputType.text,
                keyboardAction: TextInputAction.done,
                obscureText: false,
                validators: (val) {
                  if (val.length == 0) {
                    return "Case can't be empty.";
                  } else {
                    return null;
                  }
                },
              ),
              SizedBox(
                height: 8,
              ),
              DateTimePicker(
                type: DateTimePickerType.date,
                enabled: controller.editCaseStatus,
                controller: controller.caseDateTimeCtrl,
                dateMask: 'd MMMM, yyyy - hh:mm a',
                // initialValue: dateFormat.format(DateTime.now()),
                firstDate: DateTime(2020),
                lastDate: DateTime(2100),
                style: TextStyle(
                  color: controller.editCaseStatus ? Colors.black87 : Colors.black54,
                ),
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
                    color: controller.editCaseStatus ? Colors.orange : Colors.orange.shade300,
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
                      color: controller.editCaseStatus ? Colors.black45 : Colors.black38,
                      width: 1,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              DropdownSearch<String>(
                validator: (v) => v == null ? "required field" : null,
                // hint: "Select a country",
                mode: Mode.MENU,
                enabled: controller.editCaseStatus,
                showSearchBox: true,
                dropdownSearchDecoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 9,
                    horizontal: 17,
                  ),
                  isDense: true,
                  labelStyle: TextStyle(
                    color: controller.editCaseStatus ? Colors.orange : Colors.orange.shade300,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide(
                      color: controller.editCaseStatus ? Colors.orange : Colors.orange.shade200,
                      width: 1.5,
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
                      color: controller.editCaseStatus ? Colors.black45 : Colors.black38,
                      width: 1,
                    ),
                  ),
                ),
                searchBoxDecoration: InputDecoration(
                  isDense: true,
                  labelText: 'Search',
                  labelStyle: TextStyle(color: Colors.orange),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4.0),
                    borderSide: BorderSide(
                      color: Colors.orange,
                      width: 1.5,
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
                showAsSuffixIcons: true,
                clearButtonBuilder: (_) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.clear,
                    size: 24,
                    color: controller.editCaseStatus ? Colors.black : Colors.black54,
                  ),
                ),
                dropdownButtonBuilder: (_) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.arrow_drop_down,
                    size: 24,
                    color: controller.editCaseStatus ? Colors.black : Colors.black54,
                  ),
                ),
                showSelectedItem: true,
                items: controller.caseTypesList,
                label: "* Case Type",
                showClearButton: true,
                onChanged: (String value) {
                  controller.onCaseTypeChanged(value);
                },
                dropdownBuilder: (BuildContext context, String selectedItem, String itemAsString) {
                  return Text(
                    selectedItem,
                    style: Theme.of(context).textTheme.subtitle1.copyWith(
                          color: controller.editCaseStatus ? Colors.black87 : Colors.black54,
                        ),
                  );
                },
                popupItemBuilder: _customPopupItemBuilderExample,
                popupBackgroundColor: Colors.white,
                selectedItem: controller.selectedCaseType,
              ),
              SizedBox(
                height: 8,
              ),
              CustomTextWidgetOutlined(
                controller: controller.caseChargesCtrl,
                label: 'Case Charges',
                enabled: controller.editCaseStatus,
                // hintText: 'Theft',
                // focusNode: emailNode,
                // onFieldSubmitted: (term) {
                //   emailNode.unfocus();
                //   FocusScope.of(context).requestFocus(passwordNode);
                // },
                keyboardType: TextInputType.number,
                keyboardAction: TextInputAction.done,
                obscureText: false,
                validators: (val) {
                  if (val.length == 0) {
                    return "Case can't be empty.";
                  } else {
                    return null;
                  }
                },
                // onSaved: (value) {
                //   registerData.email = value;
                // },
              ),
              CustomTextWidgetOutlined(
                controller: controller.casePetitionerCtrl,
                label: 'Case Petitioner',
                enabled: controller.editCaseStatus,
                // hintText: '0012',
                // focusNode: emailNode,
                // onFieldSubmitted: (term) {
                //   emailNode.unfocus();
                //   FocusScope.of(context).requestFocus(passwordNode);
                // },
                keyboardType: TextInputType.text,
                keyboardAction: TextInputAction.done,
                obscureText: false,
                // validators: (val) {
                //   if (val.length == 0) {
                //     return "Case Number can't be empty.";
                //   } else {
                //     return null;
                //   }
                // },
                // onSaved: (value) {
                //   registerData.email = value;
                // },
              ),
              CustomTextWidgetOutlined(
                controller: controller.caseDescriptionCtrl,
                label: 'Case Description',
                enabled: controller.editCaseStatus,
                // hintText: '0012',
                // focusNode: emailNode,
                // onFieldSubmitted: (term) {
                //   emailNode.unfocus();
                //   FocusScope.of(context).requestFocus(passwordNode);
                // },
                keyboardType: TextInputType.text,
                keyboardAction: TextInputAction.done,
                obscureText: false,
                validators: (val) {
                  if (val.length == 0) {
                    return "Case can't be empty.";
                  } else {
                    return null;
                  }
                },
                // onSaved: (value) {
                //   registerData.email = value;
                // },
              ),
              CustomTextWidgetOutlined(
                controller: controller.courtNameCtrl,
                label: '*  Court Name',
                enabled: controller.editCaseStatus,
                // hintText: 'John',
                keyboardType: TextInputType.name,
                keyboardAction: TextInputAction.done,
                // focusNode: userNameNode,
                // onFieldSubmitted: (term) {
                //   userNameNode.unfocus();
                //   FocusScope.of(context).requestFocus(emailNode);
                // },
                obscureText: false,
                validators: (val) {
                  if (val.length == 0) {
                    return "Court name can't be empty";
                  } else {
                    return null;
                  }
                },
                // onSaved: (value) {
                //   registerData.userName = value;
                // },
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: DropdownSearch<String>(
                  validator: (v) => v == null ? "City required" : null,
                  // hint: "Select a country",
                  mode: Mode.MENU,
                  enabled: controller.editCaseStatus,
                  showSearchBox: true,
                  dropdownSearchDecoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 9,
                      horizontal: 17,
                    ),
                    isDense: true,
                    labelStyle: TextStyle(
                      color: controller.editCaseStatus ? Colors.orange : Colors.orange.shade300,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(
                        color: controller.editCaseStatus ? Colors.orange : Colors.orange.shade200,
                        width: 1.5,
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
                        color: controller.editCaseStatus ? Colors.black45 : Colors.black38,
                        width: 1,
                      ),
                    ),
                  ),
                  searchBoxDecoration: InputDecoration(
                    isDense: true,
                    labelText: 'Search',
                    labelStyle: TextStyle(color: Colors.orange),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(
                        color: Colors.orange,
                        width: 1.5,
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
                  showAsSuffixIcons: true,
                  clearButtonBuilder: (_) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.clear,
                      size: 24,
                      color: controller.editCaseStatus ? Colors.black : Colors.black54,
                    ),
                  ),
                  dropdownButtonBuilder: (_) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: 24,
                      color: controller.editCaseStatus ? Colors.black : Colors.black54,
                    ),
                  ),
                  showSelectedItem: true,
                  items: controller.citiesList,
                  label: "* Court City",
                  showClearButton: true,
                  onChanged: (String value) {
                    controller.onCityChanged(value);
                  },
                  dropdownBuilder:
                      (BuildContext context, String selectedItem, String itemAsString) {
                    return Text(
                      selectedItem,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: controller.editCaseStatus ? Colors.black87 : Colors.black54,
                          ),
                    );
                  },
                  popupItemBuilder: _customPopupItemBuilderExample,
                  popupBackgroundColor: Colors.white,
                  selectedItem: controller.selectedCity,
                ),
              ),
              CustomTextWidgetOutlined(
                controller: controller.judgeNameCtrl,
                label: '* Judge Name',
                enabled: controller.editCaseStatus,
                // hintText: '0012',
                // focusNode: emailNode,
                // onFieldSubmitted: (term) {
                //   emailNode.unfocus();
                //   FocusScope.of(context).requestFocus(passwordNode);
                // },
                keyboardType: TextInputType.name,
                keyboardAction: TextInputAction.done,
                obscureText: false,
                validators: (val) {
                  if (val.length == 0) {
                    return "Case Number can't be empty.";
                  } else {
                    return null;
                  }
                },
                // onSaved: (value) {
                //   registerData.email = value;
                // },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _customPopupItemBuilderExample(BuildContext context, String item, bool isSelected) {
    return Container(
      child: ListTile(
        selected: isSelected,
        selectedTileColor: Colors.orange.withOpacity(0.1),
        title: Text(item),
      ),
    );
  }
}

class CasesSchedules extends StatefulWidget {
  final String scheduleType;
  const CasesSchedules({
    Key key,
    this.scheduleType = "Other",
  }) : super(key: key);

  @override
  _CasesSchedulesState createState() => _CasesSchedulesState();
}

class _CasesSchedulesState extends State<CasesSchedules>
    with AutomaticKeepAliveClientMixin<CasesSchedules> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<DetailedCaseController>(
      builder: (controller) => StreamBuilder<DocumentSnapshot>(
        stream: controller.userSchedulesStream,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError && !snapshot.hasData) {
            return Center(
              child: Text('Unable to load schedules'),
            );
          }
          print(snapshot.data.data());
          List<dynamic> schedulesData = [];
          try {
            schedulesData = snapshot.data.get('schedules');
          } catch (e) {
            print(e);
            return Center(
              child: Text('Unable to load schedules'),
            );
          }
          List<ScheduleModel> schedulesList =
              schedulesData.map((element) => ScheduleModel.fromJson(element)).toList();
          schedulesList.retainWhere((element) => element.type == "Case"
              ? element.id == controller.caseID
                  ? true
                  : false
              : false);
          if (schedulesList == null || schedulesList.isEmpty) {
            return Center(
              child: Text('No schedules for now!'),
            );
          }

          return ListView.builder(
            itemCount: schedulesList.length,
            itemBuilder: (BuildContext context, int index) {
              return SingleScheduleCard(
                schedule: schedulesList[index],
                onTap: () {
                  Get.to(() => DetailedScheduleUI(), arguments: [schedulesList[index]]);
                },
              );
            },
          );
        },
      ),
    );
  }
}

class CasesNotes extends StatefulWidget {
  const CasesNotes({
    Key key,
  }) : super(key: key);

  @override
  _CasesNotesState createState() => _CasesNotesState();
}

class _CasesNotesState extends State<CasesNotes> with AutomaticKeepAliveClientMixin<CasesNotes> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<DetailedCaseController>(
      builder: (controller) => StreamBuilder<DocumentSnapshot>(
        stream: controller.userNotesStream,
        builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError && !snapshot.hasData) {
            return Center(
              child: Text('Unable to load notes'),
            );
          }
          print(snapshot.data.data());
          List<dynamic> notesData = [];
          try {
            notesData = snapshot.data.get('notes');
          } catch (e) {
            print(e);
            return Center(
              child: Text('Unable to load notes'),
            );
          }
          List<NoteModel> notesList =
              notesData.map((element) => NoteModel.fromJson(element)).toList();
          notesList.retainWhere((element) => element.type == "Case"
              ? element.id == controller.caseID
                  ? true
                  : false
              : false);
          if (notesList == null || notesList.isEmpty) {
            return Center(
              child: Text('No notes'),
            );
          }

          return ListView.builder(
            itemCount: notesList.length,
            itemBuilder: (BuildContext context, int index) {
              return SingleNoteCard(
                note: notesList[index],
                onTap: () {
                  Get.to(() => DetailedNoteUI(), arguments: [notesList[index]]);
                },
              );
            },
          );

          // return ListView.builder(
          //   itemCount: schedulesList.length,
          //   itemBuilder: (BuildContext context, int index) {
          //     return SingleScheduleCard(schedule: schedulesList[index]);
          //   },
          // );
        },
      ),
    );
  }
}
