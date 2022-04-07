// matching various patterns for kinds of data
import 'package:get/get.dart';

class Validator {
  Validator();

  String phone(String value) {
    String pattern = r'^((\+92)?(0092)?(92)?(0)?)(3)([0-9]{2})((-?)|( ?))([0-9]{7})$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Please enter a valid phone number.';
    else
      return null;
  }

  String email(String value) {
    String pattern = r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Please enter a valid email address.';
    else
      return null;
  }

  String emailComplex(String value) {
    String pattern =
        r"^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Please enter a valid email address.';
    else
      return null;
  }

  String emailComplexWithNull(String value) {
    String pattern =
        r"^([\w-\.]+)@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.)|(([\w-]+\.)+))([a-zA-Z]{2,4}|[0-9]{1,3})(\]?)$";
    RegExp regex = RegExp(pattern);
    if (value.isEmpty) return null;
    if (!regex.hasMatch(value))
      return 'Please enter a valid email address.';
    else
      return null;
  }

  String password(String value) {
    String pattern = r'^.{6,}$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Password must be at least 6 characters.';
    else
      return null;
  }

  String name(String value) {
    String pattern = r"^[a-zA-Z]+(([',. -][a-zA-Z ])?[a-zA-Z]*)*$";
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Please enter a valid name.';
    else
      return null;
  }

  String number(String value) {
    String pattern = r'^\D?(\d{3})\D?\D?(\d{3})\D?(\d{4})$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Please enter a valid number.';
    else
      return null;
  }

  String amount(String value) {
    String pattern = r'^\d+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Please enter a valid amount.';
    else
      return null;
  }

  String notEmpty(String value) {
    String pattern = r'^\S+$';
    RegExp regex = RegExp(pattern);
    if (!regex.hasMatch(value))
      return 'Please enter some value';
    else
      return null;
  }
}
