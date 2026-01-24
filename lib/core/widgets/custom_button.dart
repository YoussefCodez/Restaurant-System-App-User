import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant/core/theme/color_manager.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 20).h,
      alignment: .center,
      decoration: BoxDecoration(
        color: ColorsManager.primary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 14.sp,
          color: Colors.white,
          fontWeight: .bold,
        ),
      ),
    );
  }
}
