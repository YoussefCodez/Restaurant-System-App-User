import 'package:flutter/material.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:restaurant/core/utils/responsive/device_utils.dart';
import 'package:restaurant/features/home/data/models/menu_model.dart';
import 'package:restaurant/features/meal_details/logic/cubit/count_cubit.dart';
import 'package:restaurant/features/meal_details/logic/cubit/size_cubit.dart';

class PriceCountInfo extends StatelessWidget {
  const PriceCountInfo({super.key, required this.menuModel});
  final MenuModel menuModel;
  static double getSizePrice(String categoryId, int sizeIndex) {
    if (categoryId == "burger") {
      if (sizeIndex == 0) return 0;
      if (sizeIndex == 1) return 120;
    }
    if (categoryId == "pizza") {
      if (sizeIndex == 0) return 0;
      if (sizeIndex == 1) return 50;
      if (sizeIndex == 2) return 100;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SizeCubit, int>(
      builder: (context, sizeState) {
        double sizePrice = getSizePrice(menuModel.categoryId, sizeState);
        return BlocBuilder<CountCubit, int>(
          builder: (context, count) {
            double discountedPrice = menuModel.hasDiscount ? menuModel.price! * (1 - menuModel.discount! / 100) : menuModel.price!;
            double totalPrice = (discountedPrice + sizePrice) * count;
            return Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  "${totalPrice.toInt().toString()} ${StringsManager.egp}",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                    fontSize: DeviceUtils.isTablet(context) ? 24.sp : 28.sp,
                    fontWeight: .w300,
                  ),
                ),
                Gap(DeviceUtils.isTablet(context) ? 10.w : 0.w),
                Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Color(0xFF121223),
                    borderRadius: BorderRadius.circular(50.r),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          context.read<CountCubit>().increment();
                        },
                        child: Container(
                          padding: EdgeInsets.all(8.r),
                          decoration: BoxDecoration(
                            color: Color(0xFF41404e),
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                          child: SvgPicture.asset(
                            "assets/svg/plus.svg",
                            width: DeviceUtils.isTablet(context) ? 20.w : 15.w,
                            height: DeviceUtils.isTablet(context) ? 20.h : 15.h,
                          ),
                        ),
                      ),
                      Gap(20.w),
                      Text(
                        count.toString(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: .bold,
                          color: Colors.white,
                        ),
                      ),
                      Gap(20.w),
                      GestureDetector(
                        onTap: () {
                          context.read<CountCubit>().decrement();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Color(0xFF41404e),
                            borderRadius: BorderRadius.circular(100.r),
                          ),
                          child: Icon(
                            Icons.remove,
                            color: Colors.white,
                            size: DeviceUtils.isTablet(context) ? 24.r : 20.r,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
