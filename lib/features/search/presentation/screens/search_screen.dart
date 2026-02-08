import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:restaurant/core/theme/color_manager.dart';
import 'package:restaurant/core/utils/constants/assets_manager.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:restaurant/core/utils/responsive/device_utils.dart';
import 'package:restaurant/core/widgets/cart.dart';
import 'package:restaurant/core/widgets/custom_leading_button.dart';
import 'package:restaurant/core/widgets/custom_textField.dart';
import 'package:restaurant/features/home/logic/cubit/menu_cubit.dart';
import 'package:restaurant/features/meal_details/presentation/screens/meal_details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchController;
  late FocusNode focusNode;
  @override
  void initState() {
    super.initState();
    searchController = .new();
    focusNode = .new();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actionsPadding: EdgeInsets.symmetric(horizontal: 10.w),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: CustomLeadingButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          StringsManager.searchText,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: .bold,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          )
        ),
        actions: [Cart(color: Theme.of(context).colorScheme)],
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 24.r,
          left: 24.r,
          right: 24.r,
          bottom: 0.r,
        ),
        child: Column(
          children: [
            CustomTextField(
              controller: searchController,
              isEnabled: true,
              focusNode: focusNode,
              onChanged: (value) {
                context.read<MenuCubit>().loadMenuBySearch(value);
              },
            ),
            Gap(24.h),
            BlocBuilder<MenuCubit, MenuState>(
              builder: (context, state) {
                if (state is MenuSuccess) {
                  return state.menu.isEmpty ? Text(StringsManager.nothingToShow) : Expanded(
                    child: GridView.builder(
                      itemCount: state.menu.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.5,
                      ),
                      itemBuilder: (context, index) {
                        var totalPrice = state.menu[index].price! * (1 - state.menu[index].discount! / 100);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MealDetailsScreen(
                                  menuModel: state.menu[index],
                                ),
                              ),
                            );
                          },
                          child: Container(
                            clipBehavior: .antiAlias,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey[200]!,
                                width: 1,
                              ),
                            ),
                            child: Column(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: EdgeInsets.all(10.r),
                                    child: CachedNetworkImage(
                                      imageUrl: state.menu[index].image,
                                      placeholder: (context, url) => Center(
                                        child: CupertinoActivityIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Center(child: Icon(Icons.error)),
                                      fit: .contain,
                                      width: DeviceUtils.isTablet(context)
                                          ? 220.w
                                          : 160.w,
                                      height: DeviceUtils.isTablet(context)
                                          ? 220.h
                                          : 160.h,
                                    ),
                                  ),
                                ),
                                Container(
                                  color: Colors.grey[200],
                                  width: double.infinity,
                                  padding: EdgeInsets.all(8.r),
                                  child: Column(
                                    crossAxisAlignment: .start,
                                    children: [
                                      Text(
                                        state.menu[index].name,
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 16.sp,
                                          fontWeight: .bold,
                                        ),
                                      ),
                                      Column(
                                        crossAxisAlignment: .start,
                                        children: [
                                          Text(
                                            "${state.menu[index].price} ${StringsManager.egp}",
                                            style: TextStyle(
                                              fontSize:
                                                  state.menu[index].hasDiscount
                                                  ? 14.sp
                                                  : 16.sp,
                                              color: Colors.black,
                                              decoration:
                                                  state.menu[index].hasDiscount
                                                  ? .lineThrough
                                                  : .none,
                                              fontWeight:
                                                  state.menu[index].hasDiscount
                                                  ? .w100
                                                  : .w700,
                                            ),
                                          ),
                                          if (state.menu[index].hasDiscount) ...[
                                            Text(
                                              "${totalPrice % 2 == 0 ? totalPrice.toInt() : totalPrice} ${StringsManager.egp}",
                                              style: TextStyle(
                                                fontSize: 16.sp,
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
                                            state.menu[index].rate.toString(),
                                            style: TextStyle(
                                              fontSize: 16.sp,
                                              color: Colors.black,
                                              fontWeight: .bold,
                                            ),
                                          ),
                                          Gap(7.w),
                                          SvgPicture.asset(
                                            AssetsManager.star,
                                            width: DeviceUtils.isTablet(context)
                                                ? 25.w
                                                : 15.w,
                                            height: DeviceUtils.isTablet(context)
                                                ? 25.h
                                                : 15.h,
                                            colorFilter: ColorFilter.mode(
                                              ColorsManager.primary,
                                              BlendMode.srcIn,
                                            ),
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
                      },
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }
            ),
          ],
        ),
      ),
    );
  }
}
