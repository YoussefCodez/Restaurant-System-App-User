import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant/core/theme/color_manager.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:restaurant/features/payment/logic/cubit/total_price_cubit.dart';

class TotalWidget extends StatelessWidget {
  const TotalWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          "${StringsManager.total.toUpperCase()} : ",
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w300,
            color: ColorsManager.hint,
          ),
        ),
        Text(
          "${context.read<TotalPriceCubit>().state} ${StringsManager.egp}",
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: .w500,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
      ],
    );
  }
}
