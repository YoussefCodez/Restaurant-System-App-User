import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant/core/theme/color_manager.dart';
import 'package:restaurant/features/auth/logic/cubit/remember_me_status_cubit.dart';

class CustomCheckbox extends StatelessWidget {
  CustomCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        
        context.read<RememberMeStatusCubit>().saveOnBoardingStatus();
      },
      child: Container(
        padding: EdgeInsets.all(2.r),
        decoration: BoxDecoration(
          border: Border.all(width: 2, color: Color(0xFFE3EBF2)),
          borderRadius: BorderRadius.circular(5.r),
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 16.w,
            maxWidth: 16.w,
            minHeight: 16.w,
            minWidth: 16.w,
          ),
          child: BlocBuilder<RememberMeStatusCubit, bool>(
            builder: (context, state) {
              final isActive = context.read<RememberMeStatusCubit>().state;
              return AnimatedContainer(
                duration: Duration(milliseconds: 200),
                width: 16.w,
                height: 16.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.r),
                  color: isActive
                      ? ColorsManager.primary
                      : Colors.transparent,
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
