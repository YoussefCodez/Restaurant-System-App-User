import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomEditButton extends StatelessWidget {
  const CustomEditButton({super.key, required this.text, required this.onTap, required this.color});

  final String text;
  final Function onTap;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: TextButton(
        style: ButtonStyle(
          overlayColor: WidgetStateProperty.all(Colors.transparent),
          backgroundColor: WidgetStateProperty.all(Colors.transparent),
        ),
        onPressed: () {
          onTap();
        },
        child: Text(
          text,
          style: TextStyle(
            color: color,
            decorationColor: color,
            decoration: .underline,
            fontSize: 12.sp,
            fontWeight: .w300,
          ),
        ),
      ),
    );
  }
}
