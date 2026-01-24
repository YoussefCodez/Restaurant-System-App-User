import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:restaurant/core/theme/color_manager.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:restaurant/core/utils/responsive/device_utils.dart';
import 'package:restaurant/core/widgets/custom_textField.dart';
import 'package:restaurant/features/auth/data/repositories/firebase_user_repo.dart';
import 'package:restaurant/features/auth/logic/cubit/auth_cubit.dart';
import 'package:restaurant/features/auth/presentation/screens/Login/login_screen.dart';
import 'package:restaurant/features/home/data/models/category_model.dart';
import 'package:restaurant/features/home/data/repositories/firebase_menu_repo.dart';
import 'package:restaurant/features/home/data/repositories/menu_repo.dart';
import 'package:restaurant/features/home/logic/cubit/menu_cubit.dart';
import 'package:restaurant/features/home/presentation/widgets/app_bar.dart';
import 'package:restaurant/features/home/presentation/widgets/category.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late TextEditingController searchController;
  @override
  void initState() {
    Future.microtask(() {
      context.read<MenuCubit>().loadCategories();
    });
    searchController = .new();
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: .light,
        statusBarColor: color.secondary,
      ),
    );
    return BlocProvider(
      create: (context) => AuthCubit(FirebaseUserRepo()),
      child: SafeArea(
        child: Scaffold(
          body: Padding(
            padding: EdgeInsets.all(24.r),
            child: Column(
              crossAxisAlignment: .start,
              children: [
                AppBarWidget(color: color),
                Gap(24.h),
                BlocConsumer<AuthCubit, AuthState>(
                  listener: (context, state) {
                    if (state is AuthSignedOut) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    }
                  },
                  builder: (context, state) {
                    return GestureDetector(
                      onTap: () {
                        context.read<AuthCubit>().signOut();
                      },
                      child: Text(
                        "Hello, Youssef Mohamed",
                        style: TextStyle(
                          color: color.onSecondaryContainer,
                          fontSize: 22.sp,
                          fontWeight: .w900,
                        ),
                      ),
                    );
                  },
                ),
                Gap(16.h),
                CustomTextfield(controller: searchController),
                Gap(32.h),
                Text(
                  StringsManager.allCategories,
                  style: TextStyle(
                    fontSize: 20.sp,
                    fontWeight: .normal,
                    color: Colors.black
                  ),
                ),
                Gap(20.h),
                Expanded(
                  child: Category(),
                ),
                Spacer(flex: DeviceUtils.isTablet(context) ? 4 : 7,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
