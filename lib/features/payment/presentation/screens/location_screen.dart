import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:restaurant/core/services/hive_service.dart';
import 'package:restaurant/core/theme/color_manager.dart';
import 'package:restaurant/core/widgets/custom_leading_button.dart';
import 'package:restaurant/features/payment/presentation/widgets/governorate_selector.dart';
import 'package:restaurant/features/payment/presentation/widgets/payment_button.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key});

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  late TextEditingController addressController;
  late TextEditingController phoneController;
  final List<String> locations = [
    "Cairo",
    "Giza",
    "Alexandria",
    "Dakahlia",
    "Beheira",
    "Monufia",
    "Sharqia",
    "Gharbia",
    "Qalyubia",
    "Fayoum",
    "Beni Suef",
    "Minya",
    "Assiut",
    "Sohag",
    "Qena",
    "Luxor",
    "Aswan",
    "Suez",
    "Port Said",
    "Damietta",
    "Ismailia",
    "North Sinai",
    "South Sinai",
    "Matrouh",
    "New Valley",
    "Red Sea",
  ]..sort();

  @override
  void initState() {
    addressController = .new();
    phoneController = .new();
    addressController.text = HiveService().getCachedUserAddress() ?? "";
    phoneController.text = HiveService().getCachedUserPhone() ?? "";
    super.initState();
  }

  @override
  void dispose() {
    addressController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomLeadingButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "Location",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.r),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: .start,
            children: [
              GovernorateSelector(
                locations: locations,
                initialValue: HiveService().getCachedUserGovernorate() ?? "Cairo",
              ),
              Gap(24.h),
              Text(
                "Address",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              Gap(16.h),
              TextField(
                controller: addressController,
                cursorColor: ColorsManager.primary,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontSize: 16.sp,
                ),
                decoration: InputDecoration(
                  hintText: "Enter Your Address..",
                  hintStyle: TextStyle(
                    color: ColorsManager.hint,
                    fontSize: 13.sp,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
              Gap(24.h),
              Text(
                "Phone Number",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                ),
              ),
              Gap(16.h),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                cursorColor: ColorsManager.primary,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSecondaryContainer,
                  fontSize: 16.sp,
                ),
                decoration: InputDecoration(
                  hintText: "Enter Your Phone Number..",
                  hintStyle: TextStyle(
                    color: ColorsManager.hint,
                    fontSize: 13.sp,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
                  ),
                ),
              ),
              Gap(30.h),
              PaymentButton(addressController: addressController, phoneController: phoneController),
            ],
          ),
        ),
      ),
    );
  }
}