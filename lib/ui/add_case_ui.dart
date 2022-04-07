import 'package:date_time_picker/date_time_picker.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/ui/components/components.dart';
import 'package:flutter_al_law/ui/guest/guest_dashboard_ui.dart';
import 'package:flutter_al_law/utils/helpers.dart';
import 'package:get/get.dart';
import 'package:im_stepper/stepper.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:uuid/uuid.dart';

class AddCaseUI extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: AddCaseController(),
      builder: (AddCaseController controller) {
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
                        'Add Case',
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    children: [
                      NumberStepper(
                        numbers: [
                          1,
                          2,
                          3,
                        ],
                        // icons: [
                        //   Icon(Icons.post_add_rounded),
                        //   Icon(Icons.file_present),
                        //   Icon(Icons.account_balance_rounded),
                        // ],

                        enableStepTapping: false,

                        activeStepBorderWidth: 1,

                        // activeStep property set to activeStep variable defined above.
                        activeStep: controller.activeStep,

                        steppingEnabled: true,

                        // This ensures step-tapping updates the activeStep.
                        onStepReached: (index) {
                          // setState(() {
                          //   activeStep = index;
                          // });
                          controller.onStepReached(index);
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      _header(controller),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                            child: _body(controller),
                          ),
                        ),
                      ),
                      Container(
                        color: Colors.black,
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            controller.activeStep == 0 ? Container() : _previousButton(controller),
                            controller.activeStep == 2
                                ? _completeButton(controller)
                                : _nextButton(controller),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Returns the next button.
  Widget _completeButton(AddCaseController controller) {
    return ElevatedButton(
      onPressed: () {
        if (controller.activeStep == controller.upperBound) {
          if (controller.formKeys[controller.activeStep].currentState.validate()) {
            CaseModel _case = new CaseModel(
              caseID: Uuid().v1(),
              clientName: controller.clientNameCtrl.text,
              caseName: controller.caseNameCtrl.text,
              caseNumber: controller.caseNumberCtrl.text,
              caseRemarks: controller.caseRemarksCtrl.text,
              caseDate: DateTime.parse(controller.caseDateCtrl.text),
              caseType: controller.selectedCaseType,
              caseCharges: double.parse(controller.caseChargesCtrl.text),
              casePetitioner: controller.casePetitionerCtrl.text,
              caseDesc: controller.caseDescriptionCtrl.text,
              courtName: controller.selectedCourt,
              courtCity: controller.selectedCity,
              judgeName: controller.judgeNameCtrl.text,
            );
            controller.addCaseFireStore(_case);
            Get.back();
          }
        }
      },
      child: Text('Complete'),
    );
  }

  /// Returns the next button.
  Widget _nextButton(AddCaseController controller) {
    return ElevatedButton(
      onPressed: () {
        // Increment activeStep, when the next button is tapped. However, check for upper bound.
        if (controller.activeStep < controller.upperBound) {
          // setState(() {
          //   activeStep++;
          // });
          print(controller.activeStep);
          if (controller.formKeys[controller.activeStep].currentState.validate()) {
            controller.incrementActiveStep();
          }
        } else if (controller.activeStep == controller.upperBound) {
          if (controller.formKeys[controller.activeStep].currentState.validate()) {
            // controller.incrementActiveStep();
          }
        }
      },
      child: Text('Next'),
    );
  }

  /// Returns the previous button.
  Widget _previousButton(AddCaseController controller) {
    return ElevatedButton(
      onPressed: () {
        // Decrement activeStep, when the previous button is tapped. However, check for lower bound i.e., must be greater than 0.
        if (controller.activeStep > 0) {
          // setState(() {
          //   activeStep--;
          // });
          controller.decrementActiveStep();
        }
      },
      child: Text('Prev'),
    );
  }

  /// Returns the header wrapping the header text.
  Widget _header(AddCaseController controller) {
    return Material(
      // decoration: BoxDecoration(
      //   color: Colors.orange,
      //   borderRadius: BorderRadius.circular(5),
      // ),
      color: Colors.black,
      elevation: 2,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _headerText(controller),
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Returns the header text based on the activeStep.
  String _headerText(AddCaseController controller) {
    switch (controller.activeStep) {
      case 0:
        return 'Basic Details';

      case 1:
        return 'Case Details';

      case 2:
        return 'Court Details';

      default:
        return 'Basic Details';
    }
  }

  Widget _body(AddCaseController controller) {
    switch (controller.activeStep) {
      case 0:
        return _basicDetailWidget(controller);

      case 1:
        return _caseDetailWidget(controller);

      case 2:
        return _courtDetailWidget(controller);

      default:
        return _basicDetailWidget(controller);
    }
  }

  _basicDetailWidget(AddCaseController controller) {
    return Form(
      key: controller.formKeys[0],
      child: Column(
        children: [
          CustomTextWidgetOutlined(
            controller: controller.clientNameCtrl,
            label: '* Client Name',
            keyboardType: TextInputType.name,
            keyboardAction: TextInputAction.next,
            obscureText: false,
            validators: (val) {
              if (val.length == 0) {
                return "Client name can't be empty";
              } else {
                return null;
              }
            },
          ),
          CustomTextWidgetOutlined(
            controller: controller.caseNameCtrl,
            label: '* Case Name',
            keyboardType: TextInputType.name,
            keyboardAction: TextInputAction.next,
            obscureText: false,
            validators: (val) {
              if (val.length == 0) {
                return "Case name can't be empty.";
              } else {
                return null;
              }
            },
          ),
          CustomTextWidgetOutlined(
            controller: controller.caseNumberCtrl,
            label: '* Case Number',
            keyboardType: TextInputType.number,
            keyboardAction: TextInputAction.next,
            obscureText: false,
            validators: (val) {
              if (val.length == 0) {
                return "Case Number can't be empty.";
              } else {
                return null;
              }
            },
          ),
          CustomTextWidgetOutlined(
            controller: controller.caseRemarksCtrl,
            label: 'Case Remarks',
            keyboardType: TextInputType.text,
            keyboardAction: TextInputAction.done,
            obscureText: false,
          ),
          SizedBox(
            height: 8,
          ),
          DateTimePicker(
            type: DateTimePickerType.date,
            // initialValue: dateFormat.format(DateTime.now()),
            controller: controller.caseDateCtrl,
            firstDate: DateTime(2020),
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
              labelText: '* Case Date',
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
        ],
      ),
    );
  }

  _caseDetailWidget(AddCaseController controller) {
    return Form(
      key: controller.formKeys[1],
      child: Column(
        children: [
          SizedBox(
            height: 8,
          ),
          DropdownSearch<String>(
            validator: (v) => v == null ? "Case type required" : null,
            hint: "Select case type",
            mode: Mode.MENU,
            // showSearchBox: true,
            dropdownSearchDecoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.symmetric(
                vertical: 9,
                horizontal: 17,
              ),
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
            items: controller.caseTypesList,
            label: "* Case Type",
            showClearButton: true,
            onChanged: (String value) {
              controller.onCaseTypeChanged(value);
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
            label: '* Case Charges',
            keyboardType: TextInputType.number,
            keyboardAction: TextInputAction.next,
            obscureText: false,
            validators: (val) {
              if (val.length == 0) {
                return "Charges can't be empty.";
              } else {
                return null;
              }
            },
          ),
          CustomTextWidgetOutlined(
            controller: controller.casePetitionerCtrl,
            label: 'Case Petitioner',
            keyboardType: TextInputType.name,
            keyboardAction: TextInputAction.next,
            obscureText: false,
          ),
          CustomTextWidgetOutlined(
            controller: controller.caseDescriptionCtrl,
            label: 'Case Description',
            keyboardType: TextInputType.text,
            keyboardAction: TextInputAction.done,
            obscureText: false,
          ),
        ],
      ),
    );
  }

  _courtDetailWidget(AddCaseController controller) {
    return Form(
      key: controller.formKeys[2],
      child: Column(
        children: [
          // CustomTextWidgetOutlined(
          //   controller: controller.courtNameCtrl,
          //   label: '* Court Name',
          //   // hintText: 'John',
          //   keyboardType: TextInputType.name,
          //   keyboardAction: TextInputAction.next,
          //   obscureText: false,
          //   validators: (val) {
          //     if (val.length == 0) {
          //       return "Court name can't be empty";
          //     } else {
          //       return null;
          //     }
          //   },
          //   // onSaved: (value) {
          //   //   registerData.userName = value;
          //   // },
          // ),
          // CustomTextWidgetOutlined(
          //   controller: controller.courtCityCtrl,
          //   label: '* Court City',
          //   keyboardType: TextInputType.streetAddress,
          //   keyboardAction: TextInputAction.next,
          //   obscureText: false,
          //   validators: (val) {
          //     if (val.length == 0) {
          //       return "Court City can't be empty.";
          //     } else {
          //       return null;
          //     }
          //   },
          // ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: DropdownSearch<String>(
              validator: (v) => v == null ? "Court name required" : null,
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
              items: controller.courtsList,
              label: "* Court Name",
              showClearButton: true,
              onChanged: (String value) {
                controller.onCourtChanged(value);
              },
              popupItemBuilder: _customPopupItemBuilderExample,
              popupBackgroundColor: Colors.white,
              selectedItem: controller.selectedCourt,
            ),
          ),
          Container(
            margin: EdgeInsets.symmetric(vertical: 8),
            child: DropdownSearch<String>(
              validator: (v) => v == null ? "Court city required" : null,
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
              label: "* Court City",
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
            controller: controller.judgeNameCtrl,
            label: '* Judge Name',
            keyboardType: TextInputType.name,
            keyboardAction: TextInputAction.done,
            obscureText: false,
            validators: (val) {
              if (val.length == 0) {
                return "Judge Name can't be empty.";
              } else {
                return null;
              }
            },
          ),
        ],
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
