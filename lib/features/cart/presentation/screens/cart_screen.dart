import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:restaurant/core/theme/color_manager.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:restaurant/core/widgets/custom_button.dart';
import 'package:restaurant/core/widgets/custom_empty_.dart';
import 'package:restaurant/core/widgets/custom_leading_button.dart';
import 'package:restaurant/core/widgets/custom_unfilled_button.dart';
import 'package:restaurant/features/cart/data/models/cart_item_model.dart';
import 'package:restaurant/features/cart/logic/cubit/cart_cubit.dart';
import 'package:restaurant/features/cart/logic/cubit/edit_mode_cubit.dart';
import 'package:restaurant/features/payment/logic/cubit/total_price_cubit.dart';
import 'package:restaurant/core/widgets/custom_edit_button.dart';
import 'package:restaurant/features/home/presentation/screens/home_screen.dart';
import 'package:restaurant/features/payment/presentation/screens/payment_screen.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        leading: CustomLeadingButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<EditModeCubit>().setEditMode(false);
          },
        ),
        title: Text(
          StringsManager.cart,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        actions: [
          BlocBuilder<EditModeCubit, bool>(
            builder: (context, state) {
              return context.read<CartCubit>().state.isNotEmpty
                  ? CustomEditButton(
                      text: state
                          ? StringsManager.done
                          : StringsManager.editItems,
                      color: state ? Colors.green : ColorsManager.primary,
                      onTap: () {
                        context.read<EditModeCubit>().toggleEditMode();
                      },
                    )
                  : SizedBox.shrink();
            },
          ),
        ],
      ),
      body: BlocBuilder<CartCubit, List<CartItemModel>>(
        builder: (context, state) {
          return state.isEmpty
              ? CustomEmpty(text: StringsManager.cartIsEmpty)
              : Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.r),
                  child: Column(
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: ListView.builder(
                          itemCount: state.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.only(
                                top: index == 0 ? 0 : 20.h,
                              ),
                              child: Row(
                                children: [
                                  Image.network(
                                    state[index].image,
                                    height: 130.h,
                                    width: 130.w,
                                  ),
                                  Gap(20.w),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: .start,
                                      children: [
                                        Text(
                                          state[index].name,
                                          overflow: .ellipsis,
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: .w300,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSecondaryContainer,
                                          ),
                                        ),
                                        Text(
                                          "${StringsManager.quantity} : ${state[index].quantity}",
                                          style: TextStyle(
                                            fontSize: 18.sp,
                                            fontWeight: .w300,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSecondaryContainer,
                                          ),
                                        ),
                                        Text(
                                          "${state[index].totalPrice} ${StringsManager.egp}",
                                          style: TextStyle(
                                            fontSize: 20.sp,
                                            fontWeight: .w900,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSecondaryContainer,
                                          ),
                                        ),
                                        Text(
                                          "${StringsManager.size} : ${state[index].size}",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: .w300,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSecondaryContainer,
                                          ),
                                        ),
                                        Text(
                                          "${StringsManager.hot} : ${state[index].spicey == 0 ? StringsManager.normal : StringsManager.hot}",
                                          style: TextStyle(
                                            fontSize: 12.sp,
                                            fontWeight: .w300,
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.onSecondaryContainer,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  BlocBuilder<EditModeCubit, bool>(
                                    builder: (context, state) {
                                      return state
                                          ? GestureDetector(
                                              onTap: () {
                                                context
                                                    .read<CartCubit>()
                                                    .removeFromCart(
                                                      context
                                                          .read<CartCubit>()
                                                          .state[index],
                                                    );
                                                if (context
                                                    .read<CartCubit>()
                                                    .state
                                                    .isEmpty) {
                                                  context
                                                      .read<EditModeCubit>()
                                                      .setEditMode(false);
                                                }
                                              },
                                              child: AnimatedContainer(
                                                duration: const Duration(
                                                  seconds: 1,
                                                ),
                                                curve: Curves.easeInOut,
                                                padding: EdgeInsets.all(10.r),
                                                decoration: BoxDecoration(
                                                  color: Colors.redAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                        50.r,
                                                      ),
                                                ),
                                                child: Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                  size: 25.sp,
                                                ),
                                              ),
                                            )
                                          : const SizedBox();
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      CustomUnfilledButton(
                        text: StringsManager.contiuneShopping,
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HomeScreen(),
                            ),
                          );
                        },
                      ),
                      Gap(10.h),
                      GestureDetector(
                        onTap: () {
                          for (int i = 0; i < state.length; i++) {
                            context.read<TotalPriceCubit>().updateTotalPrice(
                              state[i].totalPrice,
                            );
                          }
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PaymentScreen(),
                            ),
                          );
                        },
                        child: CustomButton(text: StringsManager.goToPayment),
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}
