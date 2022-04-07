import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextWidgetOutlined extends StatelessWidget {
  final String label;
  final String hintText;
  final Function onSubmit;
  final Function onFieldSubmitted;
  final TextInputType keyboardType;
  final TextInputAction keyboardAction;
  final bool obscureText;
  final Function validators;
  final Function onSaved;
  final TextEditingController controller;
  final TextInputFormatter inputFormatter;
  final bool enabled;

  const CustomTextWidgetOutlined(
      {this.label,
      this.controller,
      this.hintText,
      this.onSubmit,
      this.enabled = true,
      this.onFieldSubmitted,
      this.keyboardType,
      this.keyboardAction,
      this.obscureText,
      this.validators,
      this.inputFormatter,
      this.onSaved});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        textInputAction: keyboardAction,
        textCapitalization: TextCapitalization.sentences,
        cursorColor: Colors.black,
        onFieldSubmitted: onFieldSubmitted,
        obscureText: obscureText,
        style: TextStyle(
          color: enabled ? Colors.black87 : Colors.black54,
        ),
        inputFormatters: inputFormatter == null ? null : [inputFormatter],
        decoration: InputDecoration(
          labelStyle: TextStyle(
            color: enabled ? Colors.orange : Colors.orange.shade300,
          ),
          contentPadding: EdgeInsets.symmetric(
            vertical: 9,
            horizontal: 17,
          ),
          errorStyle: TextStyle(
            color: Colors.red,
            fontSize: 12.0,
            fontWeight: FontWeight.w400,
            fontStyle: FontStyle.normal,
            letterSpacing: 1.2,
          ),
          labelText: label,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.black38, fontSize: 14),
          filled: false,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(4.0),
            borderSide: BorderSide(
              color: enabled ? Colors.orange : Colors.orange.shade200,
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
              color: enabled ? Colors.black45 : Colors.black38,
              width: 1,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(4.0),
            ),
            borderSide: BorderSide(
              color: Colors.red,
              width: 1,
            ),
          ),
        ),
        validator: validators,
        onSaved: onSaved,
        // style: kTextFieldTextStyle,
      ),
    );
  }
}
