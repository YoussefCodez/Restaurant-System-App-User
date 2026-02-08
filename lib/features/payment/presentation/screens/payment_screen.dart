import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:restaurant/core/widgets/custom_leading_button.dart';
import 'package:restaurant/features/payment/logic/cubit/total_price_cubit.dart';
import 'package:restaurant/features/payment/presentation/widgets/pay_button.dart';
import 'package:restaurant/features/payment/presentation/widgets/payment_widget.dart';
import 'package:restaurant/features/payment/presentation/widgets/payment_method_widget.dart';
import 'package:restaurant/features/payment/presentation/widgets/total_widget.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        leading: CustomLeadingButton(
          onPressed: () {
            Navigator.pop(context);
            context.read<TotalPriceCubit>().resetTotalPrice();
          },
        ),
        title: Text(
          StringsManager.payment,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          children: [
            PaymentMethodWidget(),
            PaymentWidget(),
            Spacer(),
            TotalWidget(),
            Gap(10.h),
            PayButton(),
          ],
        ),
      ),
    );
  }
}
