import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:restaurant/core/utils/responsive/device_utils.dart';
import 'package:restaurant/core/widgets/custom_button.dart' as coreCustomButton;
import 'package:restaurant/features/cart/data/models/cart_item_model.dart';
import 'package:restaurant/features/cart/logic/cubit/cart_cubit.dart';
import 'package:restaurant/features/cart/presentation/screens/cart_screen.dart';
import 'package:restaurant/features/home/data/models/menu_model.dart';
import 'package:restaurant/features/meal_details/logic/cubit/is_spicey_cubit.dart';
import 'package:restaurant/features/meal_details/logic/cubit/selected_item.dart';
import 'package:restaurant/features/meal_details/presentation/widgets/price_count_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant/features/meal_details/logic/cubit/count_cubit.dart';
import 'package:restaurant/features/meal_details/logic/cubit/size_cubit.dart';

class MyBottomSheet extends StatelessWidget {
  const MyBottomSheet({super.key, required this.menuModel});

  final MenuModel menuModel;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: DeviceUtils.isTablet(context) ? 230.h : 200.h,
      padding: EdgeInsets.symmetric(
        horizontal: DeviceUtils.isTablet(context) ? 10.w : 24.w,
        vertical: DeviceUtils.isTablet(context) ? 15.h : 20.h,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSecondaryFixed,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 153, 153, 153),
            offset: Offset(0, 2),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PriceCountInfo(menuModel: menuModel),
          GestureDetector(
            onTap: () {
              final count = context.read<CountCubit>().state;
              final sizeIndex = context.read<SizeCubit>().state;
              final spiceyIndex = context.read<IsSpiceyCubit>().state;
              final sizePrice = PriceCountInfo.getSizePrice(
                menuModel.categoryId,
                sizeIndex,
              );
              final discountedPrice = menuModel.hasDiscount ? menuModel.price! * (1 - menuModel.discount! / 100) : menuModel.price!;
              final totalPrice = (discountedPrice + sizePrice) * count;
              final size = menuModel.categoryId == "burger" ? sizeIndex == 0 ? "Single" : "Double" : menuModel.categoryId == "pizza" ? sizeIndex == 0 ? "Small" : sizeIndex == 1 ? "Medium" : "Large" : "";
              final item = CartItemModel(
                id: menuModel.id,
                type: menuModel.categoryId,
                name: menuModel.name,
                image: menuModel.image,
                price: totalPrice,
                size: size,
                quantity: count,
                spicey: spiceyIndex,
                totalPrice: totalPrice,
                toAdd: context.read<SelectedItem>().state,
              );
              context.read<CartCubit>().addToCart(item);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
            child: coreCustomButton.CustomButton(
              text: StringsManager.addToCart,
            ),
          ),
        ],
      ),
    );
  }
}
