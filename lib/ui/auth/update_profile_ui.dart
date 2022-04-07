import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_al_law/ui/guest/guest_dashboard_ui.dart';
import 'package:flutter_al_law/utils/helpers.dart';
import 'package:get/get.dart';
import 'package:flutter_al_law/models/models.dart';
import 'package:flutter_al_law/ui/components/components.dart';
import 'package:flutter_al_law/helpers/helpers.dart';
import 'package:flutter_al_law/controllers/controllers.dart';

class UpdateProfileUI extends StatelessWidget {
  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
    //print('user.name: ' + user?.value?.name);
    authController.nameController.text = authController.firestoreUser.value.name;
    authController.emailController.text = authController.firestoreUser.value.email;
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
                    'Update Email',
                  ),
                ),
              ),
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 24),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        LogoGraphicHeader(),
                        SizedBox(height: 48.0),
                        FormInputFieldWithIcon(
                          controller:
                              TextEditingController(text: authController.emailController.text),
                          iconPrefix: Icons.email,
                          labelText: 'Current Email',
                          enabled: false,
                          // validator: Validator().email,
                          validator: Validator().emailComplex,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) => null,
                          onSaved: (value) => null,
                        ),
                        FormVerticalSpace(),
                        FormInputFieldWithIcon(
                          controller: authController.emailController,
                          iconPrefix: Icons.email,
                          labelText: 'New Email',
                          // validator: Validator().email,
                          validator: Validator().emailComplex,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) => null,
                          onSaved: (value) => authController.emailController.text = value,
                        ),
                        FormVerticalSpace(),
                        PrimaryButton(
                            labelText: 'Update',
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                SystemChannels.textInput.invokeMethod('TextInput.hide');
                                print(authController.firestoreUser.value.photoBlob);
                                UserModel _updatedUser = UserModel(
                                  uid: authController.firestoreUser.value.uid,
                                  name: authController.nameController.text,
                                  email: authController.emailController.text,
                                  mobile: authController.firestoreUser.value.mobile,
                                  photoUrl: authController.firestoreUser.value.photoUrl,
                                  photoBlob: authController.firestoreUser.value.photoBlob,
                                );
                                _updateUserConfirm(context, _updatedUser,
                                    authController.firestoreUser.value.email);
                              }
                            }),
                        // FormVerticalSpace(),
                        // LabelButton(
                        //   labelText: 'Forgot password?',
                        //   onPressed: () => Get.to(() => ResetPasswordUI()),
                        // ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _updateUserConfirm(
      BuildContext context, UserModel updatedUser, String oldEmail) async {
    final AuthController authController = AuthController.to;
    final TextEditingController _password = new TextEditingController();
    return Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        title: Text(
          'Enter your password',
        ),
        content: FormInputFieldWithIcon(
          controller: _password,
          iconPrefix: Icons.lock,
          labelText: 'Password',
          validator: (value) {
            String pattern = r'^.{6,}$';
            RegExp regex = RegExp(pattern);
            if (!regex.hasMatch(value))
              return 'Password must be at least 6 characters.';
            else
              return null;
          },
          obscureText: true,
          onChanged: (value) => null,
          onSaved: (value) => _password.text = value,
          maxLines: 1,
        ),
        actions: <Widget>[
          new TextButton(
            child: new Text('CANCEL'),
            onPressed: () {
              Get.back();
            },
          ),
          new TextButton(
            child: new Text('SUBMIT'),
            onPressed: () async {
              Get.back();
              await authController.updateUser(context, updatedUser, oldEmail, _password.text);
            },
          )
        ],
      ),
    );
  }
}
