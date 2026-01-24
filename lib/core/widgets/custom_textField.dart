import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant/core/theme/color_manager.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';

class CustomTextfield extends StatelessWidget {
  CustomTextfield({super.key , required this.controller});
  TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    return TextField(
      cursorWidth: 2,
      cursorColor: ColorsManager.primary,
      style: TextStyle(
        fontSize: 14.sp,
        fontWeight: .normal,
        color: Colors.black,
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: ColorsManager.textFieldFillColor,
        prefixIcon: Icon(Icons.search, color: ColorsManager.secondryText),
        hint: Text(
          StringsManager.search,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: .normal,
            color: ColorsManager.secondryText,
          ),
        ),
        enabledBorder: TextFieldBorder(context),
        focusedBorder: TextFieldBorder(context),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
          borderSide: BorderSide(color: Colors.red, width: 3),
        ),
      ),
    );
  }
}

OutlineInputBorder TextFieldBorder(BuildContext context) {
  return OutlineInputBorder(
    borderSide: BorderSide(color: Theme.of(context).scaffoldBackgroundColor),
    borderRadius: BorderRadius.circular(10.r),
  );
}
