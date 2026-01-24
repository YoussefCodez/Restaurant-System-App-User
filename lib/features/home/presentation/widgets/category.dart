import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:restaurant/core/theme/color_manager.dart';
import 'package:restaurant/features/home/logic/cubit/menu_cubit.dart';

class Category extends StatelessWidget {
  const Category({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MenuCubit, MenuState>(
      builder: (context, state) {
        return state is MenuLoading
            ? CircularProgressIndicator(color: ColorsManager.primary)
            : ListView.builder(
                scrollDirection: .horizontal,
                itemCount: state is CategoriesLoaded
                    ? state.categories.length
                    : 1,
                itemBuilder: (context, index) {
                  if (state is CategoriesLoaded) {
                    final category = state.categories[index];
                    return Container(
                      margin: EdgeInsets.only(right: 7),
                      padding: EdgeInsets.only(
                        left: category.name == "All" ? 0.w : 8.w,
                        right: 16.w,
                        top: 8.w,
                        bottom: 8.w,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        color: ColorsManager.textFieldFillColor,
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 55.w,
                            height: 55.h,
                            child: CachedNetworkImage(
                              imageUrl: category.image,
                              fit: .cover,
                              placeholder: (context, url) {
                                return Center(
                                  child: CircularProgressIndicator(),
                                );
                              },
                              errorWidget: (context, url, error) {
                                return Icon(Icons.image_not_supported_outlined);
                              },
                            ),
                          ),
                          Gap(category.name == "All" ? 5.w : 12.w),
                          Text(
                            category.name,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: .bold,
                              color: ColorsManager.iconColor,
                            ),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return CircularProgressIndicator(
                      color: ColorsManager.primary,
                    );
                  }
                },
              );
      },
    );
  }
}
