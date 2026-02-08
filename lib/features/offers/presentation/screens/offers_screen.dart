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
import 'package:restaurant/core/widgets/custom_leading_button.dart';
import 'package:restaurant/features/home/data/repositories/firebase_menu_repo.dart';
import 'package:restaurant/features/home/logic/cubit/menu_cubit.dart';
import 'package:restaurant/features/meal_details/presentation/screens/meal_details_screen.dart';

class OffersScreen extends StatefulWidget {
  const OffersScreen({super.key});

  @override
  State<OffersScreen> createState() => _OffersScreenState();
}

class _OffersScreenState extends State<OffersScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<MenuCubit>().loadMenuByDiscount();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MenuCubit(FirebaseMenuRepo())..loadMenuByDiscount(),
      child: Scaffold(
        appBar: AppBar(
          leading: CustomLeadingButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            StringsManager.offers,
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSecondaryContainer,
            ),
          ),
        ),
        body: BlocBuilder<MenuCubit, MenuState>(
          builder: (context, state) {
            if (state is MenuLoading) {
              return Center(child: CupertinoActivityIndicator());
            } else if (state is MenuError) {
              return Center(child: Text(state.message));
            } else if (state is MenuSuccess) {
              return Padding(
                padding: EdgeInsets.all(16.r),
                child: GridView.builder(
                  itemCount: state.menu.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.6,
                  ),
                  itemBuilder: (context, index) {
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
                            color: ColorsManager.primary,
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
                                  placeholder: (context, url) => Center(child: CupertinoActivityIndicator()),
                                  errorWidget: (context, url, error) => Center(child: Icon(Icons.error)),
                                  fit: .contain,
                                  width: DeviceUtils.isTablet(context) ? 220.w : 160.w,
                                  height: DeviceUtils.isTablet(context) ? 220.h : 160.h,
                                ),
                              ),
                            ),
                            Container(
                              color: ColorsManager.primary,
                              width: double.infinity,
                              padding: EdgeInsets.all(8.r),
                              child: Column(
                                crossAxisAlignment: .center,
                                children: [
                                  Text(
                                    state.menu[index].name,
                                    textAlign: .center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: .bold,
                                    ),
                                  ),
                                  Text(
                                    "${state.menu[index].price! * (1 - state.menu[index].discount! / 100)} ${StringsManager.egp}",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.sp,
                                      fontWeight: .bold,
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment: .center,
                                    crossAxisAlignment: .center,
                                    children: [
                                      Text(
                                        state.menu[index].rate.toString(),
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: Colors.white,
                                          fontWeight: .bold,
                                        ),
                                      ),
                                      Gap(7.w),
                                      SvgPicture.asset(
                                        AssetsManager.star,
                                        width: DeviceUtils.isTablet(context) ? 25.w : 15.w,
                                        height: DeviceUtils.isTablet(context) ? 25.h : 15.h,
                                        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else {
              return Center(child: Text("No Offers"));
            }
          },
        ),
      ),
    );
  }
}
