import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant/core/theme/app_theme.dart';
import 'package:restaurant/features/auth/data/repositories/firebase_user_repo.dart';
import 'package:restaurant/features/auth/logic/cubit/auth_cubit.dart';
import 'package:restaurant/features/home/data/repositories/firebase_menu_repo.dart';
import 'package:restaurant/features/home/logic/cubit/menu_cubit.dart';
import 'package:restaurant/features/splash/screens/splash_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (context, child) {
        return MultiBlocProvider(
            providers: [
                BlocProvider(
                  create: (context) => AuthCubit(FirebaseUserRepo()),
                ),
                BlocProvider(
                    create: (context) => MenuCubit(FirebaseMenuRepo()),
                ),
            ],
                      child: MaterialApp(
                    debugShowCheckedModeBanner: false,
                    theme: AppTheme.ligtTheme,
                    darkTheme: AppTheme.darkTheme,
                    themeMode: ThemeMode.light,
                    home: SplashScreen(),
                  ),
        );
      },
    );
  }
}
