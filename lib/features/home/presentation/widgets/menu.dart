import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:restaurant/core/utils/constants/assets_manager.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:restaurant/core/utils/responsive/device_utils.dart';
import 'package:restaurant/features/home/data/models/menu_model.dart';
import 'package:restaurant/features/meal_details/presentation/screens/meal_details_screen.dart';
import 'package:skeletonizer/skeletonizer.dart';

class Menu extends StatelessWidget {
  const Menu({super.key, required this.menuModel});
  final MenuModel menuModel;
  
  @override
  Widget build(BuildContext context) {
    var totalPrice = menuModel.price! * (1 - menuModel.discount! / 100);
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MealDetailsScreen(menuModel: menuModel),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Color(0xFFEEEEEE), width: 2),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  color: Theme.of(context).scaffoldBackgroundColor,
                ),
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: menuModel.image,
                    placeholder: (context, url) =>
                        Skeletonizer(child: Container(color: Colors.grey)),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    fit: .contain,
                    width: DeviceUtils.isTablet(context) ? 220.w : 150.w,
                    height: DeviceUtils.isTablet(context) ? 220.h : 150.h,
                  ),
                ),
              ),
            ),
            Gap(8.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(8.r),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12.r),
                  topRight: Radius.circular(12.r),
                  bottomLeft: Radius.circular(10.r),
                  bottomRight: Radius.circular(10.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    menuModel.name,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  Gap(5.h),
                  Column(
                    crossAxisAlignment: .start,
                    children: [
                      Text(
                        "${menuModel.price} ${StringsManager.egp}",
                        style: TextStyle(
                          fontSize: menuModel.hasDiscount ? 12.sp : 16.sp,
                          color: Colors.black,
                          decoration: menuModel.hasDiscount
                              ? .lineThrough
                              : .none,
                          fontWeight: menuModel.hasDiscount ? .w100 : .w700,
                        ),
                      ),
                      if (menuModel.hasDiscount) ...[
                        Text(
                          "${totalPrice % 2 == 0 ? totalPrice.toInt() : totalPrice} ${StringsManager.egp}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.black,
                            fontWeight: .w700,
                          ),
                        ),
                      ],
                    ],
                  ),
                  Row(
                    crossAxisAlignment: .center,
                    children: [
                      Text(
                        menuModel.rate.toString(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey[800],
                          fontWeight: .bold,
                        ),
                      ),
                      Gap(7.w),
                      SvgPicture.asset(
                        AssetsManager.star,
                        width: DeviceUtils.isTablet(context) ? 25.w : 15.w,
                        height: DeviceUtils.isTablet(context) ? 25.h : 15.h,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
