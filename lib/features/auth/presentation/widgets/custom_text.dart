import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomText extends StatelessWidget {
  const CustomText({super.key, required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(fontSize: 11.sp, color: Colors.black, fontWeight: .w100),
    );
  }
}
