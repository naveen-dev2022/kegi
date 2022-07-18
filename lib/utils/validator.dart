import 'package:flutter/material.dart';

class Validator {
  String? validateName(String? value) {
    String? pattern = r'(^[a-zA-Z ]*$)';
    RegExp? regExp = new RegExp(pattern);
    if (value!.length == 0) {
      return "Name is required";
    } else if (!regExp.hasMatch(value)) {
      return "Name must be a-z and A-Z";
    }
    return null;
  }

  String? validateMobile(String? value) {
    String? pattern = r'(^[0-9]*$)';
    RegExp? regExp = new RegExp(pattern);
    if (value!.length == 0) {
      return "Mobile number is required";
    } else if (!regExp.hasMatch(value)) {
      return "Mobile Number must be digits";
    }
    return null;
  }

  String? validateWhatsAppMobile(String? value) {
    String? pattern = r'(^[0-9]*$)';
    RegExp? regExp = RegExp(pattern);
    if (value!.length == 0) {
      return 'Mobile number is required';
    } /*else if (!regExp.hasMatch(value)) {
      return "Mobile Number must be digits";
    }*/
    return null;
  }

  String? validateOldPassword(String? value) {
    if (value!.length == 0) {
      return "Old Password can't be empty";
    }
    return null;
  }

  String? validatePasswordLength(String? value) {
    if (value!.length == 0) {
      return "Password can't be empty";
    } else if (value.length < 6) {
      return "Password must be longer than 6 characters";
    }
    return null;
  }

  String? validateConfirmPassword(String? value1, String? value2) {
    if (value2!.length == 0) {
      return "Confirm Password can't be empty";
    } else if (value1 != value2) {
      return "Password must be same";
    }
    return null;
  }

  String? validateEmail(String? value) {
    String? pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp? regExp = new RegExp(pattern);
    if (value!.length == 0) {
      return "Email is required";
    } else if (!regExp.hasMatch(value)) {
      return "Invalid Email";
    } else {
      return null;
    }
  }

  String? validateLength(String value) {
    if (value.length == 0) {
      return "Required all fields";
    } else {
      return null;
    }
  }
}
