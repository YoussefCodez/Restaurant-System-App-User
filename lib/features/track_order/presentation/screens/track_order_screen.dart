import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:restaurant/core/theme/color_manager.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:restaurant/core/utils/responsive/device_utils.dart';
import 'package:restaurant/core/widgets/custom_empty_.dart';
import 'package:restaurant/core/widgets/custom_leading_button.dart';
import 'package:restaurant/features/home/presentation/screens/home_screen.dart';
import 'package:restaurant/features/payment/logic/cubit/get_orders_cubit.dart';

class TrackOrderScreen extends StatefulWidget {
  const TrackOrderScreen({super.key});

  @override
  State<TrackOrderScreen> createState() => _TrackOrderScreenState();
}

class _TrackOrderScreenState extends State<TrackOrderScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<GetOrdersCubit>().loadOrders(
        FirebaseAuth.instance.currentUser!.uid,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: ColorsManager.primary,
        title: Text(
          "Orders",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        leading: CustomLeadingButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          },
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.r),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Expanded(
              child: BlocBuilder<GetOrdersCubit, GetOrdersState>(
                builder: (context, orders) {
                  if (orders is GetOrdersLoading) {
                    return const Center(
                      child: CupertinoActivityIndicator(radius: 15),
                    );
                  } else if (orders is GetOrdersFailure) {
                    return Center(
                      child: Text(
                        orders.message,
                        style: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: .w900,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSecondaryContainer,
                        ),
                      ),
                    );
                  } else if (orders is GetOrdersSuccess) {
                    if (orders.orders.isEmpty) {
                      return CustomEmpty(text: "You Have No Orders");
                    }
                    return ListView.separated(
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      itemBuilder: (context, index) {
                        return Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(16.r),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.r),
                            color: ColorsManager.holderColor,
                          ),
                          child: Column(
                            crossAxisAlignment: .start,
                            children: [
                              Text(
                                "Order #${index + 1}",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: .bold,
                                  color: Colors.black,
                                ),
                              ),
                              for (
                                int i = 0;
                                i < orders.orders[index].items.length;
                                i++
                              ) ...[
                                if (i != orders.orders[index].items.length)
                                  Gap(16.h),
                                Row(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: orders
                                          .orders[index]
                                          .items[i]
                                          .mealImage,
                                      height: DeviceUtils.isTablet(context)
                                          ? 100.h
                                          : 50.h,
                                      width: DeviceUtils.isTablet(context)
                                          ? 100.w
                                          : 50.w,
                                      fit: DeviceUtils.isTablet(context)
                                          ? .contain
                                          : .cover,
                                    ),
                                    Gap(30.w),
                                    Column(
                                      crossAxisAlignment: .start,
                                      children: [
                                        Text(
                                          orders
                                              .orders[index]
                                              .items[i]
                                              .mealName,
                                          style: TextStyle(
                                            fontSize: 16.sp,
                                            fontWeight: .bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Text(
                                          "${orders.orders[index].items[i].mealPrice} ${StringsManager.egp}",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: .normal,
                                            color: ColorsManager.hint,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                              Gap(16.h),
                              MealOrderInfo(
                                text:
                                    orders.orders[index].status ?? "Delivered",
                                title: "Status",
                              ),
                              Gap(16.h),
                              MealOrderInfo(
                                text:
                                    orders.orders[index].deliveryTime ??
                                    "Waiting",
                                title: "Delivery Time",
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: 24.h);
                      },
                      itemCount: orders.orders.length,
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MealOrderInfo extends StatelessWidget {
  const MealOrderInfo({super.key, required this.text, required this.title});
  final String title;
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: .bold,
          ),
        ),
        Container(
          padding: EdgeInsets.all(8.r),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6.r),
            color: ColorsManager.primary,
          ),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontWeight: .bold,
            ),
          ),
        ),
      ],
    );
  }
}
