import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_al_law/ui/guest/guest_dashboard_ui.dart';
import 'package:flutter_al_law/utils/helpers.dart';
import 'package:get/get.dart';
import 'package:flutter_al_law/ui/components/components.dart';
import 'package:flutter_al_law/helpers/helpers.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/ui/auth/auth.dart';

class SignUpUI extends StatelessWidget {
  final AuthController authController = AuthController.to;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Widget build(BuildContext context) {
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
                    'Sign Up',
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
                      // mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        LogoGraphicHeader(),
                        SizedBox(height: 48.0),
                        FormInputFieldWithIcon(
                          controller: authController.nameController,
                          iconPrefix: Icons.person,
                          labelText: 'Name',
                          validator: Validator().name,
                          onChanged: (value) => null,
                          onSaved: (value) => authController.nameController.text = value,
                        ),
                        FormVerticalSpace(),
                        FormInputFieldWithIcon(
                          controller: authController.emailController,
                          iconPrefix: Icons.email,
                          labelText: 'Email',
                          // validator: Validator().email,
                          validator: Validator().emailComplex,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) => null,
                          onSaved: (value) => authController.emailController.text = value,
                        ),
                        FormVerticalSpace(),
                        FormInputFieldWithIcon(
                          controller: authController.passwordController,
                          iconPrefix: Icons.lock,
                          labelText: 'Password',
                          validator: Validator().password,
                          obscureText: true,
                          onChanged: (value) => null,
                          onSaved: (value) => authController.passwordController.text = value,
                          maxLines: 1,
                        ),
                        FormVerticalSpace(),
                        PrimaryButton(
                            labelText: 'Sign Up',
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide'); //to hide the keyboard - if any
                                authController.registerWithEmailAndPassword(context);
                              }
                            }),
                        FormVerticalSpace(),
                        LabelButton(
                          labelText: 'Have an Account? Sign In.',
                          onPressed: () => Get.to(() => SignInUI()),
                        ),
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
}
