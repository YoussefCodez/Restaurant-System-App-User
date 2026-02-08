import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomLeadingButton extends StatelessWidget {
  const CustomLeadingButton({super.key, required this.onPressed});
  final Function onPressed;
  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back_ios_new_outlined, size: 20.sp, color: Theme.of(context).colorScheme.onSecondaryContainer,),
      onPressed: () {
        onPressed();
      },
    );
  }
}
