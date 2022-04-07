import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/helpers/helpers.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/ui/components/components.dart';
import 'package:flutter_al_law/ui/ui.dart';
import 'package:flutter_al_law/utils/custom_text_input_formatter.dart';
import 'package:flutter_al_law/utils/helpers.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';
import 'package:share_plus/share_plus.dart';

class DetailedClientUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: DetailedClientController(),
      builder: (DetailedClientController controller) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              icon: Icon(Icons.share),
              onPressed: () async {
                String shareText = 'Client: ${controller.clientData.name}\n'
                    '\nAddress -> ${controller.clientData.address}'
                    '\nContact -> ${controller.clientData.contact}'
                    '\nEmail -> ${controller.clientData.email}'
                    '\nCity -> ${controller.clientData.city}'
                    '\nRemarks -> ${controller.clientData.remarks}';
                await Share.share(shareText);
              },
            ),
            IconButton(
              icon: Icon(controller.editClientStatus ? Icons.save_alt : Icons.edit),
              onPressed: () async {
                if (controller.editClientStatus) {
                  Get.dialog(
                    CustomAlertDialog(
                      'Save Changes',
                      'Do you want to save changes made to client?',
                      'Save',
                      'Cancel',
                      onPositiveButton: () async {
                        Get.back();
                        await Helpers.showLoader(context);
                        await controller.updateClientToFirebase();
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
                controller.editClientStatus
                    ? controller.changeEditClientStatus(false)
                    : controller.changeEditClientStatus(true);
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                Get.dialog(
                  CustomAlertDialog(
                    'Delete Client',
                    'Do you want to delete this client?',
                    'Delete',
                    'Cancel',
                    onPositiveButton: () async {
                      Get.back();
                      await Helpers.showLoader(context);
                      await controller.deleteClientFromFirebase();
                      Get.back();
                      Helpers.hideLoader();
                      Get.snackbar('Deleted', 'Deleted client successfully',
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
              //   await controller.deleteClientFromFirebase();
              //   Get.back();
              // },
            ),
          ],
          title: Text(
            'Client Detail',
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
                // height: 100,
                padding: const EdgeInsets.only(bottom: 12, top: 8, left: 12, right: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.orange,
                            ),
                            child: Center(
                              child: AutoSizeText(
                                controller.clientData.name != null
                                    ? controller.clientData.name.substring(0, 1)
                                    : '?',
                                style: TextStyle(
                                  fontSize: 32,
                                  color: Colors.white,
                                ),
                              ),
                            )),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          controller.clientData.name ?? 'Unknown',
                          style: TextStyle(color: Colors.white, fontSize: 22),
                        ),
                      ],
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
                      text: "DETAILS",
                    ),
                    // new Tab(
                    //   text: "CASES",
                    // ),
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
                    _buildClientDetailsTabView(),
                    // _buildCasesTabView(),
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

  _buildClientDetailsTabView() {
    return ClientDetailsFormWidget();
  }

  _buildCasesTabView() {
    return Center(
      child: Text(
        "Cases",
      ),
    );
  }

  _buildScheduleTabView() {
    return ClientsSchedules();
  }

  _buildNotesTabView() {
    return ClientsNotes();
    // return Center(
    //   child: Text(
    //     "Notes",
    //   ),
    // );
  }

  SpeedDial _buildSpeedDial(DetailedClientController controller) {
    return SpeedDial(
      /// both default to 16
      marginEnd: 18,
      marginBottom: 20,
      // animatedIcon: AnimatedIcons.menu_close,
      // animatedIconTheme: IconThemeData(size: 22.0),
      /// This is ignored if animatedIcon is non null
      icon: Icons.add,
      activeIcon: Icons.clear,
      // iconTheme: IconThemeData(color: Colors.grey[50], size: 30),

      /// The label of the main button.
      // label: Text("Open Speed Dial"),
      /// The active label of the main button, Defaults to label if not specified.
      // activeLabel: Text("Close Speed Dial"),
      /// Transition Builder between label and activeLabel, defaults to FadeTransition.
      // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
      /// The below button size defaults to 56 itself, its the FAB size + It also affects relative padding and other elements
      buttonSize: 56.0,
      visible: true,

      /// If true user is forced to close dial manually
      /// by tapping main button and overlay is not rendered.
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
          onTap: () => Get.to(() => AddNoteUI(), arguments: [controller.clientID, "Client"]),
          // onLongPress: () => print('ADD NOTES'),
        ),
        SpeedDialChild(
          child: Icon(
            Icons.image_search,
            color: Colors.white,
          ),
          backgroundColor: Colors.orange,
          label: 'Add Schedule',
          labelStyle: TextStyle(
            fontSize: 14.0,
            color: Colors.white,
          ),
          labelBackgroundColor: Colors.black54,
          onTap: () => Get.to(() => AddScheduleUI(), arguments: [controller.clientID, "Client"]),
          // onLongPress: () => print('ADD EVIDENCE'),
        ),
      ],
    );
  }
}

class ClientDetailsFormWidget extends StatefulWidget {
  @override
  _ClientDetailsFormWidgetState createState() => _ClientDetailsFormWidgetState();
}

class _ClientDetailsFormWidgetState extends State<ClientDetailsFormWidget>
    with AutomaticKeepAliveClientMixin<ClientDetailsFormWidget> {
  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<DetailedClientController>(
      builder: (controller) => SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            children: [
              CustomTextWidgetOutlined(
                controller: controller.clientNameCtrl,
                label: '* Name',
                enabled: controller.editClientStatus,
                keyboardType: TextInputType.name,
                keyboardAction: TextInputAction.next,
                obscureText: false,
                validators: (val) {
                  if (val.length == 0) {
                    return "Name can't be empty";
                  } else {
                    return null;
                  }
                },
              ),
              CustomTextWidgetOutlined(
                controller: controller.clientContactCtrl,
                label: '* Contact',
                hintText: '03**-*******',
                enabled: controller.editClientStatus,
                inputFormatter: new MaskTextInputFormatter(
                  mask: '####-#######',
                  filter: {
                    "#": RegExp(r'[0-9]'),
                  },
                ),
                keyboardType: TextInputType.phone,
                keyboardAction: TextInputAction.next,
                obscureText: false,
                validators: Validator().phone,
              ),
              CustomTextWidgetOutlined(
                controller: controller.clientEmailCtrl,
                label: 'Email',
                keyboardType: TextInputType.emailAddress,
                keyboardAction: TextInputAction.next,
                enabled: controller.editClientStatus,
                obscureText: false,
              ),
              CustomTextWidgetOutlined(
                controller: controller.clientAddressCtrl,
                label: 'Address',
                enabled: controller.editClientStatus,
                keyboardType: TextInputType.streetAddress,
                keyboardAction: TextInputAction.next,
                obscureText: false,
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 8),
                child: DropdownSearch<String>(
                  validator: (v) => v == null ? "required field" : null,
                  // hint: "Select a country",
                  mode: Mode.MENU,
                  enabled: controller.editClientStatus,
                  showSearchBox: true,
                  dropdownSearchDecoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 9,
                      horizontal: 17,
                    ),
                    isDense: true,
                    labelStyle: TextStyle(
                      color: controller.editClientStatus ? Colors.orange : Colors.orange.shade300,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4.0),
                      borderSide: BorderSide(
                        color: controller.editClientStatus ? Colors.orange : Colors.orange.shade200,
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
                        color: controller.editClientStatus ? Colors.black45 : Colors.black38,
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
                      color: controller.editClientStatus ? Colors.black : Colors.black54,
                    ),
                  ),
                  dropdownButtonBuilder: (_) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.arrow_drop_down,
                      size: 24,
                      color: controller.editClientStatus ? Colors.black : Colors.black54,
                    ),
                  ),
                  showSelectedItem: true,
                  items: controller.citiesList,
                  label: "* City",
                  showClearButton: true,
                  onChanged: (String value) {
                    controller.onCityChanged(value);
                  },
                  dropdownBuilder:
                      (BuildContext context, String selectedItem, String itemAsString) {
                    return Text(
                      selectedItem,
                      style: Theme.of(context).textTheme.subtitle1.copyWith(
                            color: controller.editClientStatus ? Colors.black87 : Colors.black54,
                          ),
                    );
                  },
                  popupItemBuilder: _customPopupItemBuilderExample,
                  popupBackgroundColor: Colors.white,
                  selectedItem: controller.selectedCity,
                ),
                // child: DropdownSearch<String>(
                //   validator: (v) => v == null ? "required field" : null,
                //   mode: Mode.MENU,
                //   showSearchBox: true,
                //   enabled: controller.editClientStatus,
                //   dropdownSearchDecoration: InputDecoration(
                //     isDense: true,
                //     labelStyle: TextStyle(
                //       color:
                //           controller.editClientStatus ? Colors.orange : Colors.orange.shade300,
                //     ),
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(4.0),
                //       borderSide: BorderSide(
                //         color: controller.editClientStatus
                //             ? Colors.orange
                //             : Colors.orange.shade200,
                //         width: 1.5,
                //       ),
                //     ),
                //     disabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(4.0),
                //       ),
                //       borderSide: BorderSide(
                //         color: Colors.black12,
                //         width: 1,
                //       ),
                //     ),
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(4.0),
                //       ),
                //       borderSide: BorderSide(
                //         color: Colors.black45,
                //         width: 1,
                //       ),
                //     ),
                //   ),
                //   searchBoxDecoration: InputDecoration(
                //     isDense: true,
                //     labelText: 'Search',
                //     labelStyle: TextStyle(color: Colors.orange),
                //     focusedBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.circular(4.0),
                //       borderSide: BorderSide(
                //         color: Colors.orange,
                //         width: 1.5,
                //       ),
                //     ),
                //     enabledBorder: OutlineInputBorder(
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(4.0),
                //       ),
                //       borderSide: BorderSide(
                //         color: Colors.black45,
                //         width: 1,
                //       ),
                //     ),
                //   ),
                //   showAsSuffixIcons: true,
                //   clearButtonBuilder: (_) => Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: const Icon(
                //       Icons.clear,
                //       size: 24,
                //       color: Colors.black,
                //     ),
                //   ),
                //   dropdownButtonBuilder: (_) => Padding(
                //     padding: const EdgeInsets.all(8.0),
                //     child: const Icon(
                //       Icons.arrow_drop_down,
                //       size: 24,
                //       color: Colors.black,
                //     ),
                //   ),
                //   showSelectedItem: true,
                //   items: controller.citiesList,
                //   label: "* City",
                //   showClearButton: true,
                //   onChanged: (String value) {
                //     controller.onCityChanged(value);
                //   },
                //   popupItemBuilder: _customPopupItemBuilderExample,
                //   popupBackgroundColor: Colors.white,
                //   selectedItem: controller.selectedCity,
                // ),
              ),
              CustomTextWidgetOutlined(
                controller: controller.clientRemarksCtrl,
                label: 'Remarks',
                enabled: controller.editClientStatus,
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

class ClientsSchedules extends StatefulWidget {
  const ClientsSchedules({
    Key key,
  }) : super(key: key);

  @override
  _ClientsSchedulesState createState() => _ClientsSchedulesState();
}

class _ClientsSchedulesState extends State<ClientsSchedules>
    with AutomaticKeepAliveClientMixin<ClientsSchedules> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<DetailedClientController>(
      builder: (controller) => StreamBuilder<DocumentSnapshot>(
        stream: controller.clientSchedulesStream,
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
          schedulesList.retainWhere((element) => element.type == "Client"
              ? element.id == controller.clientID
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

class ClientsNotes extends StatefulWidget {
  const ClientsNotes({
    Key key,
  }) : super(key: key);

  @override
  _ClientsNotesState createState() => _ClientsNotesState();
}

class _ClientsNotesState extends State<ClientsNotes>
    with AutomaticKeepAliveClientMixin<ClientsNotes> {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return GetBuilder<DetailedClientController>(
      builder: (controller) => StreamBuilder<DocumentSnapshot>(
        stream: controller.clientNotesStream,
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
          notesList.retainWhere((element) => element.type == "Client"
              ? element.id == controller.clientID
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
        },
      ),
    );
  }
}
