import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:restaurant/core/theme/color_manager.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:restaurant/core/utils/responsive/device_utils.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({super.key, required this.color});
  final ColorScheme color;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: DeviceUtils.isTablet(context) ? 45.w : 45.w,
          height: DeviceUtils.isTablet(context) ? 70.h : 45.h,
          padding: EdgeInsets.all(11.r),
          alignment: .center,
          decoration: BoxDecoration(
            color: color.onPrimary,
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: SvgPicture.asset("assets/svg/menu.svg" , width: 18.w, height: 18.h, ),
        ),
        Gap(18.w),
        Expanded(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              Text(
                StringsManager.deliverTo.toUpperCase(),
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: .bold,
                  color: ColorsManager.primary,
                ),
              ),
              Gap(3.h),
              Row(
                children: [
                  Text(
                    "Ain Shams",
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: .normal,
                      color: color.onPrimaryFixed,
                    ),
                  ),
                  Gap(9.w),
                  Icon(
                    Icons.arrow_drop_down,
                    color: color.onPrimaryFixedVariant,
                    size: 22.w,
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: DeviceUtils.isTablet(context) ? 45.w : 45.w,
          height: DeviceUtils.isTablet(context) ? 70.h : 45.h,
          padding: EdgeInsets.all(11.r),
          alignment: .center,
          decoration: BoxDecoration(
            color: color.onPrimaryFixedVariant,
            borderRadius: BorderRadius.circular(50.r),
          ),
          child: Stack(
            clipBehavior: .none,
            children: [
              SvgPicture.asset(
                "assets/svg/cart.svg",
                width: 25.w,
                height: 25.h, 
                colorFilter: ColorFilter.mode(
                  color.onPrimaryContainer,
                  BlendMode.srcIn,
                ),
              ),
              Positioned(
                top: DeviceUtils.isTablet(context) ? -35.h : -18.h,
                right: DeviceUtils.isTablet(context) ? -45.h : -18.w,
                child: Container(
                  width: DeviceUtils.isTablet(context) ? 30.w : 25.w,
                  height: DeviceUtils.isTablet(context) ? 45.h : 25.h,
                  alignment: .center,
                  decoration: BoxDecoration(
                    color: color.onSecondary,
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Text(
                    "2",
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.white,
                      fontWeight: .w900,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
