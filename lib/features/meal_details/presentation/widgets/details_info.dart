
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:restaurant/core/utils/responsive/device_utils.dart';


class DetailsInfo extends StatelessWidget {
  const DetailsInfo({
    super.key,
    required this.text,
    required this.svg,
  });

  final String text;
  final String svg;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgPicture.asset(
          svg,
          width: DeviceUtils.isTablet(context) ? 24.w : 20.w,
          height: DeviceUtils.isTablet(context) ? 24.h : 20.h,
        ),
        Gap(10.w),
        Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: .w300,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        )
      ],
    );
  }
}
