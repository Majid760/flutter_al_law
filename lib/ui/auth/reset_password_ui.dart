import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_al_law/controllers/controllers.dart';
import 'package:flutter_al_law/helpers/validator.dart';
import 'package:flutter_al_law/ui/auth/auth.dart';
import 'package:flutter_al_law/ui/components/components.dart';
import 'package:flutter_al_law/ui/guest/guest_dashboard_ui.dart';
import 'package:flutter_al_law/utils/helpers.dart';
import 'package:get/get.dart';

class ResetPasswordUI extends StatelessWidget {
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
                    'Reset Password',
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
                        PrimaryButton(
                            labelText: 'Send Password Reset',
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                await authController.sendPasswordResetEmail(context);
                              }
                            }),
                        FormVerticalSpace(),
                        signInLink(context),
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

  signInLink(BuildContext context) {
    if (authController.emailController.text == '') {
      return LabelButton(
        labelText: 'Sign In',
        onPressed: () => Get.offAll(() => SignInUI()),
      );
    }
    return Container(width: 0, height: 0);
  }
}
