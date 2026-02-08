

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant/core/services/hive_service.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:restaurant/core/widgets/custom_button.dart';
import 'package:restaurant/core/widgets/my_dialog.dart';
import 'package:restaurant/features/auth/logic/cubit/auth_cubit.dart';
import 'package:restaurant/features/cart/logic/cubit/cart_cubit.dart';
import 'package:restaurant/features/payment/data/models/order_item_model.dart';
import 'package:restaurant/features/payment/data/models/order_model.dart';
import 'package:restaurant/features/payment/logic/cubit/location_cubit.dart';
import 'package:restaurant/features/payment/logic/cubit/order_cubit.dart';
import 'package:restaurant/features/payment/presentation/widgets/complete_order_dialog.dart';

class PaymentButton extends StatelessWidget {
  const PaymentButton({
    super.key,
    required this.addressController,
    required this.phoneController,
  });

  final TextEditingController addressController;
  final TextEditingController phoneController;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderCubit, OrderState>(
      builder: (context, order) {
        return BlocBuilder<AuthCubit, AuthState>(
          builder: (context, auth) {
            return GestureDetector(
              onTap: () async {
                if (addressController.text.length < 10) {
                  showDialog(
                    context: context,
                    builder: (_) =>
                        myDialog(message: "Enter A Detailed Address"),
                  );
                  return;
                }
                if (phoneController.text.length != 11) {
                  showDialog(
                    context: context,
                    builder: (_) =>
                        myDialog(message: "Enter A Correct Phone Number"),
                  );
                  return;
                }
                if (addressController.text.isNotEmpty &&
                    phoneController.text.isNotEmpty &&
                    addressController.text.length > 10 &&
                    phoneController.text.length == 11) {
                  if (!RegExp(
                    r'^01[0125][0-9]{8}$',
                  ).hasMatch(phoneController.text)) {
                    showDialog(
                      context: context,
                      builder: (_) =>
                          myDialog(message: "Invalid Phone Number"),
                    );
                    return;
                  }
                  final auth = context.read<AuthCubit>().state;
                  if (auth is! UserLoaded) return;
                  final cartItems = context.read<CartCubit>().state;
                  if (cartItems.isEmpty) {
                    showDialog(
                      context: context,
                      builder: (_) =>
                          myDialog(message: "Cart is empty"),
                    );
                    return;
                  }
                  final orderItems = cartItems.map((item) {
                    return OrderItemModel(
                      mealId: item.id,
                      mealName: item.name,
                      mealImage: item.image,
                      mealSize: item.size,
                      mealType: item.type,
                      mealPrice: item.price,
                      mealSpicey: item.spicey == 0 ? "Normal" : "Hot",
                      mealToAdd: item.toAdd,
                      orderItemTotalPrice: item.totalPrice,
                      orderItemQuantity: item.quantity,
                    );
                  }).toList();
                  await context.read<OrderCubit>().placeOrder(
                    OrderModel(
                      userId: auth.user.userId,
                      items: orderItems,
                      totalOrderPrice: orderItems.fold(
                        0,
                        (num sum, item) =>
                            sum + item.orderItemTotalPrice,
                      ),
                      orderedAt: Timestamp.now(),
                      status: "Pending",
                      deliveryTime: "Not Set",
                    ),
                  );
                  HiveService().cacheUserPhone(phoneController.text);
                  HiveService().cacheUserAddress(addressController.text);
                  HiveService().cacheUserGovernorate(context.read<LocationCubit>().state);
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (_) => CompleteOrderDialog(),
                  );
                  final newUser = auth.user.copyWith(
                    address: addressController.text,
                    phone: phoneController.text,
                    governorate: context.read<LocationCubit>().state,
                  );
                  context.read<AuthCubit>().updateUserData(newUser);
                  HiveService().cacheUserAddress(
                    addressController.text,
                  );
                  HiveService().cacheUserPhone(phoneController.text);
                  HiveService().cacheUserGovernorate(
                    context.read<LocationCubit>().state,
                  );
                  context.read<CartCubit>().clearCart();
                }
              },
              child: order is OrderLoading
                  ? const Center(child: CupertinoActivityIndicator())
                  : CustomButton(text: StringsManager.goToPayment),
            );
          },
        );
      },
    );
  }
}
