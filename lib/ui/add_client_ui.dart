import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/helpers/helpers.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/ui/guest/guest_dashboard_ui.dart';
import 'package:flutter_al_law/utils/custom_text_input_formatter.dart';
import 'package:flutter_al_law/utils/helpers.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'components/components.dart';

class AddClientUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AddClientController(),
      builder: (AddClientController controller) {
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
                        'Add Client',
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
                                    controller: controller.clientNameCtrl,
                                    label: '* Name',
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
                                    obscureText: false,
                                    validators: Validator().emailComplexWithNull,
                                  ),
                                  CustomTextWidgetOutlined(
                                    controller: controller.clientAddressCtrl,
                                    label: 'Address',
                                    keyboardType: TextInputType.streetAddress,
                                    keyboardAction: TextInputAction.next,
                                    obscureText: false,
                                  ),
                                  Container(
                                    margin: EdgeInsets.symmetric(vertical: 8),
                                    child: DropdownSearch<String>(
                                      validator: (v) => v == null ? "City required" : null,
                                      mode: Mode.MENU,
                                      // showSearchBox: true,
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
                                      items: controller.citiesList,
                                      label: "* City",
                                      showClearButton: true,
                                      onChanged: (String value) {
                                        controller.onCityChanged(value);
                                      },
                                      popupItemBuilder: _customPopupItemBuilderExample,
                                      popupBackgroundColor: Colors.white,
                                      selectedItem: controller.selectedCity,
                                    ),
                                  ),
                                  CustomTextWidgetOutlined(
                                    controller: controller.clientRemarksCtrl,
                                    label: 'Remarks',
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
                                    //     return "Case can't be empty.";
                                    //   } else {
                                    //     return null;
                                    //   }
                                    // },
                                    // onSaved: (value) {
                                    //   registerData.email = value;
                                    // },
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
                                    ClientModel _client = new ClientModel(
                                      id: Uuid().v1(),
                                      name: controller.clientNameCtrl.text,
                                      contact: controller.clientContactCtrl.text,
                                      email: controller.clientEmailCtrl.text,
                                      city: controller.selectedCity,
                                      remarks: controller.clientRemarksCtrl.text,
                                      address: controller.clientAddressCtrl.text,
                                    );
                                    controller.addClientToFireStore(_client);
                                    Get.back();
                                    Get.snackbar(
                                      'Client',
                                      'Added successfully',
                                      snackPosition: SnackPosition.BOTTOM,
                                      duration: Duration(seconds: 3),
                                      backgroundColor: Get.theme.snackBarTheme.backgroundColor,
                                      colorText: Get.theme.snackBarTheme.actionTextColor,
                                    );
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
        selectedTileColor: Colors.orange.withOpacity(0.1),
        title: Text(item),
      ),
    );
  }
}
