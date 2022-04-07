import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/ui/components/components.dart';
import 'package:flutter_al_law/ui/guest/guest_dashboard_ui.dart';
import 'package:flutter_al_law/utils/helpers.dart';
import 'package:get/get.dart';

class AddEvidenceUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AddEvidenceController(),
      builder: (AddEvidenceController controller) {
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
                        'Add Evidence',
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
                                  DropdownSearch<String>(
                                    validator: (v) => v == null ? "Evidence type required" : null,
                                    // hint: "Select a country",
                                    label: "* Evidence Type",
                                    mode: Mode.MENU,
                                    showSearchBox: true,
                                    dropdownSearchDecoration: InputDecoration(
                                      isDense: true,
                                      labelStyle: TextStyle(color: Colors.orange),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4.0),
                                        borderSide: BorderSide(
                                          color: Colors.orange,
                                          width: 1.5,
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
                                      child: const Icon(
                                        Icons.clear,
                                        size: 24,
                                        color: Colors.black,
                                      ),
                                    ),
                                    dropdownButtonBuilder: (_) => Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: const Icon(
                                        Icons.arrow_drop_down,
                                        size: 24,
                                        color: Colors.black,
                                      ),
                                    ),
                                    showSelectedItem: true,
                                    items: controller.evidenceTypeList,
                                    showClearButton: true,
                                    onChanged: (String value) {
                                      controller.onEvidenceTypeChanged(value);
                                    },
                                    popupItemBuilder: _customPopupItemBuilderExample,
                                    popupBackgroundColor: Colors.white,
                                    selectedItem: controller.selectedEvidenceType,
                                  ),
                                  CustomTextWidgetOutlined(
                                    controller: controller.evidenceNameCtrl,
                                    label: '* Evidence Name',
                                    // hintText: 'Theft',
                                    // focusNode: emailNode,
                                    // onFieldSubmitted: (term) {
                                    //   emailNode.unfocus();
                                    //   FocusScope.of(context).requestFocus(passwordNode);
                                    // },
                                    keyboardType: TextInputType.name,
                                    keyboardAction: TextInputAction.next,
                                    obscureText: false,
                                    validators: (val) {
                                      if (val.length == 0) {
                                        return "Evidence Name can't be empty.";
                                      } else {
                                        return null;
                                      }
                                    },
                                    // onSaved: (value) {
                                    //   registerData.email = value;
                                    // },
                                  ),
                                  CustomTextWidgetOutlined(
                                    controller: controller.evidenceDescriptionCtrl,
                                    label: 'Evidence Description',
                                    // hintText: 'Theft',
                                    // focusNode: emailNode,
                                    // onFieldSubmitted: (term) {
                                    //   emailNode.unfocus();
                                    //   FocusScope.of(context).requestFocus(passwordNode);
                                    // },
                                    keyboardType: TextInputType.text,
                                    keyboardAction: TextInputAction.next,
                                    obscureText: false,
                                    // onSaved: (value) {
                                    //   registerData.email = value;
                                    // },
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: CustomTextWidgetOutlined(
                                          controller: controller.evidenceFileCtrl,
                                          label: 'File',
                                          // hintText: 'Theft',
                                          // focusNode: emailNode,
                                          // onFieldSubmitted: (term) {
                                          //   emailNode.unfocus();
                                          //   FocusScope.of(context).requestFocus(passwordNode);
                                          // },
                                          keyboardType: TextInputType.text,
                                          keyboardAction: TextInputAction.next,
                                          obscureText: false,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      RaisedButton(
                                        child: new Text("SELECT"),
                                        textColor: Colors.white,
                                        color: Colors.orange,
                                        onPressed: () {},
                                        shape: new RoundedRectangleBorder(
                                          borderRadius: new BorderRadius.circular(2.0),
                                        ),
                                      )
                                    ],
                                  ),
                                  DateTimePicker(
                                    type: DateTimePickerType.dateTime,
                                    // initialValue: dateFormat.format(DateTime.now()),
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
                                      labelText: 'Evidence Date Time',
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
                                  CustomTextWidgetOutlined(
                                    controller: controller.evidenceRemarksCtrl,
                                    label: 'Evidence Remarks',
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
                                onPressed: () {
                                  if (controller.formKey.currentState.validate()) {
                                    // ScheduleModel _schedule = new ScheduleModel(
                                    //   id: Uuid().v1(),
                                    //   name: controller.clientNameCtrl.text,
                                    //   contact: controller.clientContactCtrl.text,
                                    //   email: controller.clientEmailCtrl.text,
                                    //   city: controller.selectedCity,
                                    //   remarks: controller.clientRemarksCtrl.text,
                                    // );
                                    // controller.addClientToFireStore(_client);
                                    // Get.back();
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

  Widget _customPopupItemBuilderExample(BuildContext context, String item, bool isSelected) {
    return Container(
      child: ListTile(
        selected: isSelected,
        selectedTileColor: Colors.black12,
        title: Text(item),
      ),
    );
  }
}
