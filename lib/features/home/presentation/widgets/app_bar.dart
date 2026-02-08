import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:restaurant/core/services/hive_service.dart';
import 'package:restaurant/core/theme/color_manager.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:restaurant/core/utils/responsive/device_utils.dart';
import 'package:restaurant/core/widgets/cart.dart';

class AppBarWidget extends StatelessWidget {
  const AppBarWidget({
    super.key,
    required this.color,
    required this.scaffoldKey,
  });
  final ColorScheme color;
  final GlobalKey<ScaffoldState> scaffoldKey;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () {
            scaffoldKey.currentState?.openDrawer();
          },
          child: Container(
            width: DeviceUtils.isTablet(context) ? 45.w : 45.w,
            height: DeviceUtils.isTablet(context) ? 70.h : 45.h,
            padding: EdgeInsets.all(11.r),
            alignment: .center,
            decoration: BoxDecoration(
              color: color.onPrimary,
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: SvgPicture.asset(
              "assets/svg/menu.svg",
              width: 18.w,
              height: 18.h,
            ),
          ),
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
                    HiveService().getCachedUserGovernorate() != null &&
                            HiveService().getCachedUserAddress() != null &&
                            HiveService().getCachedUserAddress()!.isNotEmpty &&
                            HiveService().getCachedUserGovernorate()!.isNotEmpty
                        ? "${HiveService().getCachedUserGovernorate()} , ${HiveService().getCachedUserAddress()!.substring(0, HiveService().getCachedUserAddress()!.length > 10 ? 10 : HiveService().getCachedUserAddress()!.length)}"
                        : "Location",
                    overflow: .ellipsis,
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
        Cart(color: color),
      ],
    );
  }
}
