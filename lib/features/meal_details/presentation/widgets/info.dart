import 'package:flutter/material.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:restaurant/core/utils/constants/assets_manager.dart';
import 'package:restaurant/features/home/data/models/menu_model.dart';
import 'package:restaurant/features/meal_details/presentation/widgets/details_info.dart';

class Info extends StatelessWidget {
  const Info({super.key, required this.menuModel});

  final MenuModel menuModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .spaceBetween,
      children: [
        DetailsInfo(text: menuModel.rate.toString(), svg: AssetsManager.rate),
        DetailsInfo(text: StringsManager.free, svg: AssetsManager.delivery),
        DetailsInfo(
          text: StringsManager.deliveryTime,
          svg: AssetsManager.clock,
        ),
      ],
    );
  }
}
