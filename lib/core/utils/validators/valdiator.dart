import 'package:flutter/material.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';

abstract class Valdiator {
  static FormFieldValidator<String?> emailValidator = (value) {
    if (value == null || value.trim().isEmpty) {
      return StringsManager.emailEmpty;
    }
    if (!RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w]{2,4}$").hasMatch(value)) {
      return StringsManager.validEmail;
    }
    return null;
  };
  static FormFieldValidator<String?> nameValidator = (value) {
    if (value == null || value.trim().isEmpty) {
      return StringsManager.nameEmpty;
    }
    if (value.length > 20) {
      return StringsManager.nameLong;
    }
    return null;
  };
  static FormFieldValidator<String?> passValidator = (value) {
    if (value == null || value.trim().isEmpty) {
      return StringsManager.passEmpty;
    }
    if (value.length < 6) {
      return StringsManager.passValid;
    }
    return null;
  };
}
