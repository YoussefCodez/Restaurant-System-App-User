import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:restaurant/core/theme/color_manager.dart';
import 'package:restaurant/features/onBoarding/logic/cubit/index_cubit.dart';

class Indicator extends StatelessWidget {
  const Indicator({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<IndexCubit, IndexState>(
      builder: (context, state) {
        final int index = (state as IndexInitial).index;
        return Row(
          mainAxisAlignment: .center,
          children: [Dot(isActive: index == 0), Gap(12.w), Dot(isActive: index == 1), Gap(12.w), Dot(isActive: index == 2)],
        );
      },
    );
  }
}

class Dot extends StatelessWidget {
  Dot({super.key, required this.isActive});
  bool isActive;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10.w,
      height: 10.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.r),
        color: isActive ? ColorsManager.primary : ColorsManager.hover,
      ),
    );
  }
}
