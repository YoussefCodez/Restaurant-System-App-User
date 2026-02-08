import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:restaurant/core/theme/color_manager.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:restaurant/core/widgets/custom_text.dart';
import 'package:restaurant/features/home/data/models/menu_model.dart';
import 'package:restaurant/features/home/logic/cubit/menu_cubit.dart';
import 'package:restaurant/features/home/presentation/widgets/menu.dart';
import 'package:restaurant/features/meal_details/logic/cubit/count_cubit.dart';
import 'package:restaurant/features/meal_details/logic/cubit/is_spicey_cubit.dart';
import 'package:restaurant/features/meal_details/logic/cubit/selected_item.dart';
import 'package:restaurant/features/meal_details/logic/cubit/size_cubit.dart';
import 'package:restaurant/features/meal_details/presentation/widgets/custom_app_bar.dart';
import 'package:restaurant/features/meal_details/presentation/widgets/custom_button.dart';
import 'package:restaurant/features/meal_details/presentation/widgets/info.dart';
import 'package:restaurant/features/meal_details/presentation/widgets/my_bottom_sheet.dart';
import 'package:restaurant/features/meal_details/presentation/widgets/to_add.dart';

class MealDetailsScreen extends StatefulWidget {
  const MealDetailsScreen({super.key, required this.menuModel});
  final MenuModel menuModel;

  @override
  State<MealDetailsScreen> createState() => _MealDetailsScreenState();
}

class _MealDetailsScreenState extends State<MealDetailsScreen> {
  @override
  void initState() {
    context.read<MenuCubit>().loadMenuExcept(
      widget.menuModel.categoryId,
      widget.menuModel.id,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => IsSpiceyCubit()),
        BlocProvider(create: (_) => SizeCubit()),
        BlocProvider(create: (_) => CountCubit()),
        BlocProvider(create: (_) => SelectedItem()),
      ],
      child: Scaffold(
        body: CustomScrollView(
          slivers: [
            CustomAppBar(menuModel: widget.menuModel),
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(24.r),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Info(menuModel: widget.menuModel),
                    Gap(20.h),
                    Text(
                      StringsManager.placeholderDes,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w300,
                        color: ColorsManager.hint,
                      ),
                    ),
                    Gap(20.h),
                    if (widget.menuModel.categoryId == "burger") ...[
                      BlocBuilder<SizeCubit, int>(
                        builder: (context, state) {
                          return Row(
                            children: [
                              Text(
                                "${StringsManager.size.toUpperCase()} : ",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300,
                                  color: ColorsManager.hint,
                                ),
                              ),
                              CustomButton(
                                text: StringsManager.single,
                                onTap: () {
                                  context.read<SizeCubit>().select(0);
                                },
                                selected: state == 0,
                              ),
                              Gap(10.w),
                              CustomButton(
                                text: StringsManager.double,
                                onTap: () {
                                  context.read<SizeCubit>().select(1);
                                },
                                selected: state == 1,
                              ),
                            ],
                          );
                        },
                      ),
                    ] else if (widget.menuModel.categoryId == "pizza") ...[
                      BlocBuilder<SizeCubit, int>(
                        builder: (context, state) {
                          return Row(
                            mainAxisAlignment: .spaceAround,
                            children: [
                              Text(
                                "${StringsManager.size.toUpperCase()} : ",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w300,
                                  color: ColorsManager.hint,
                                ),
                              ),
                              CustomButton(
                                text: StringsManager.small,
                                onTap: () {
                                  context.read<SizeCubit>().select(0);
                                },
                                selected: state == 0,
                              ),
                              CustomButton(
                                text: StringsManager.medium,
                                onTap: () {
                                  context.read<SizeCubit>().select(1);
                                },
                                selected: state == 1,
                              ),
                              CustomButton(
                                text: StringsManager.large,
                                onTap: () {
                                  context.read<SizeCubit>().select(2);
                                },
                                selected: state == 2,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                    Gap(20.h),
                    BlocBuilder<IsSpiceyCubit, int>(
                      builder: (context, state) {
                        return Row(
                          children: [
                            Text(
                              "${StringsManager.hot.toUpperCase()} : ",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w300,
                                color: ColorsManager.hint,
                              ),
                            ),
                            Gap(10.w),
                            CustomButton(
                              text: StringsManager.normal,
                              onTap: () {
                                context.read<IsSpiceyCubit>().select(0);
                              },
                              selected: state == 0,
                            ),
                            Gap(10.w),
                            CustomButton(
                              text: StringsManager.spicey,
                              onTap: () {
                                context.read<IsSpiceyCubit>().select(1);
                              },
                              selected: state == 1,
                            ),
                          ],
                        );
                      },
                    ),
                    Gap(20.h),
                    CustomText(text: StringsManager.toAdd.toUpperCase()),
                    Gap(5.h),
                    Text(
                      StringsManager.toAddCondition,
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w300,
                        color: Colors.black,
                      ),
                    ),
                    Gap(20.h),
                    ToAdd(),
                    Gap(20.h),
                    CustomText(
                      text: StringsManager.recommendations.toUpperCase(),
                    ),
                    Gap(20.h),
                  ],
                ),
              ),
            ),
            BlocBuilder<MenuCubit, MenuState>(
              builder: (context, state) {
                if (state is MenuSuccess) {
                  return SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: 24.r),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            childAspectRatio: 0.6,
                          ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => Menu(menuModel: state.menu[index]),
                        childCount: state.menu.length,
                      ),
                    ),
                  );
                }
                return SliverToBoxAdapter(child: SizedBox(height: 300.h));
              },
            ),
            SliverToBoxAdapter(child: SizedBox(height: 300.h)),
          ],
        ),
        bottomNavigationBar: MyBottomSheet(menuModel: widget.menuModel),
      ),
    );
  }
}
