import 'package:flutter/material.dart';

abstract class Valdiator {
  static FormFieldValidator<String?> emailValidator = (value) {
    if (value == null || value.trim().isEmpty) {
      return "Email Can't Be Empty";
    }
    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$").hasMatch(value)) {
      return "Enter a valid email";
    }
    return null;
  };
  static FormFieldValidator<String?> nameValidator = (value) {
    if (value == null || value.trim().isEmpty) {
      return "Name Can't Be Empty";
    }
    if (value.length > 20) {
      return "Name Can't Be Long";
    }
  };
  static FormFieldValidator<String?> passValidator = (value) {
    if (value == null || value.trim().isEmpty) {
      return "Password cannot be empty";
    }
    if (value.length < 6) {
      return "Password must be at least 6 characters";
    }
    return null;
  };
}
