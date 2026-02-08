import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant/features/auth/logic/cubit/auth_cubit.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';

class HeadLine extends StatelessWidget {
  const HeadLine({super.key, required this.color});
  final ColorScheme color;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        if (state is UserLoaded) {
          return Text(
            "${StringsManager.hello}, ${state.user.name[0].toUpperCase() + state.user.name.substring(1)}",
            style: TextStyle(
              color: color.onSecondaryContainer,
              fontSize: 22.sp,
              fontWeight: .w900,
            ),
          );
        } else {
          return Text(
            StringsManager.hello,
            style: TextStyle(
              color: color.onSecondaryContainer,
              fontSize: 22.sp,
              fontWeight: .w900,
            ),
          );
        }
      },
    );
  }
}
