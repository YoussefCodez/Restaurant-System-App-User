import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:restaurant/core/theme/color_manager.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:restaurant/core/utils/responsive/device_utils.dart';
import 'package:restaurant/features/home/logic/cubit/category_cubit.dart';
import 'package:restaurant/features/home/logic/cubit/index_cubit.dart';
import 'package:restaurant/features/home/logic/cubit/menu_cubit.dart';

class Category extends StatelessWidget {
  const Category({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => IndexCubit(),
      child: BlocBuilder<CategoryCubit, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return ListView.builder(
              scrollDirection: .horizontal,
              itemCount: 3,
              itemBuilder: (context, index) {
                return Container(
                  width: 30.w,
                  height: 15.h,
                  margin: EdgeInsets.only(right: 7),
                  padding: DeviceUtils.isTablet(context)
                      ? EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h)
                      : EdgeInsets.only(
                          left: 8.w,
                          right: 16.w,
                          top: 8.h,
                          bottom: 8.h,
                        ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50.r),
                    color: ColorsManager.textFieldFillColor,
                  ),
                  child: SizedBox(width: 30.w),
                );
              },
            );
          } else if (state is CategoryError) {
            return Center(
              child: Text(
                state.message,
                style: TextStyle(color: Colors.red, fontSize: 12.sp),
              ),
            );
          } else {
            return ListView.builder(
              scrollDirection: .horizontal,
              itemCount: state is CategoriesLoaded
                  ? state.categories.length
                  : 0,
              itemBuilder: (context, index) {
                if (state is CategoriesLoaded) {
                  final category = state.categories[index];
                  return BlocBuilder<IndexCubit, int>(
                    builder: (context, indexState) {
                      return GestureDetector(
                        onTap: () {
                          context.read<IndexCubit>().changeIndex(
                            category.order,
                          );
                          if (category.order != 0) {
                            context.read<MenuCubit>().loadMenuByCategory(
                              category.id,
                            );
                          } else {
                            context.read<MenuCubit>().loadMenu();
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 7),
                          padding: EdgeInsets.only(
                            left: context.locale.languageCode == 'ar'
                                ? 8.w
                                : category.order == 0
                                ? 0.w
                                : 8.w,
                            right: context.locale.languageCode == 'ar'
                                ? category.order == 0
                                      ? 0.w
                                      : 8.w
                                : 12.w,
                            top: 8.h,
                            bottom: 8.h,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.r),
                            color: index == indexState
                                ? ColorsManager.selectionColor
                                : ColorsManager.textFieldFillColor,
                          ),
                          child: Row(
                            children: [
                              Transform.scale(
                                scale: DeviceUtils.isTablet(context)
                                    ? 1.2
                                    : 0.9,
                                child: CachedNetworkImage(
                                  imageUrl: category.image,
                                  width: 44.w,
                                  height: 44.h,
                                  fit: DeviceUtils.isTablet(context)
                                      ? .contain
                                      : .cover,
                                  placeholder: (context, url) {
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  },
                                  errorWidget: (context, url, error) {
                                    return Icon(
                                      Icons.image_not_supported_outlined,
                                    );
                                  },
                                ),
                              ),
                              Gap(
                                category.name == StringsManager.all
                                    ? 5.w
                                    : 12.w,
                              ),
                              Text(
                                category.name,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: .bold,
                                  color: ColorsManager.thirdColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const SizedBox.shrink();
                }
              },
            );
          }
        },
      ),
    );
  }
}
