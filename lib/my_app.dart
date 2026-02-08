import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant/core/theme/app_theme.dart';
import 'package:restaurant/features/add_card/logic/cubit/add_card_cubit.dart';
import 'package:restaurant/features/auth/data/repositories/firebase_user_repo.dart';
import 'package:restaurant/features/auth/logic/cubit/auth_cubit.dart';
import 'package:restaurant/features/auth/logic/cubit/user_name_cubit.dart';
import 'package:restaurant/features/cart/logic/cubit/cart_cubit.dart';
import 'package:restaurant/features/cart/logic/cubit/edit_mode_cubit.dart';
import 'package:restaurant/features/payment/data/repositories/firebase_order_repo.dart';
import 'package:restaurant/features/payment/logic/cubit/credit_cards_cubit.dart';
import 'package:restaurant/features/payment/logic/cubit/get_orders_cubit.dart';
import 'package:restaurant/features/payment/logic/cubit/location_cubit.dart';
import 'package:restaurant/features/payment/logic/cubit/order_cubit.dart';
import 'package:restaurant/features/payment/logic/cubit/total_price_cubit.dart';
import 'package:restaurant/features/favourites/logic/cubit/favourite_item_cubit.dart';
import 'package:restaurant/features/home/data/repositories/firebase_category_repo.dart';
import 'package:restaurant/features/home/data/repositories/firebase_menu_repo.dart';
import 'package:restaurant/features/home/logic/cubit/category_cubit.dart';
import 'package:restaurant/features/home/logic/cubit/menu_cubit.dart';
import 'package:restaurant/features/meal_details/logic/cubit/favourite_cubit.dart';
import 'package:restaurant/features/payment/logic/cubit/payment_select_cubit.dart';
import 'package:restaurant/features/settings/logic/cubit/active_dark_mode_cubit.dart';
import 'package:restaurant/features/settings/logic/cubit/edit_profile_cubit.dart';
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
            BlocProvider(create: (context) => AuthCubit(FirebaseUserRepo())),
            BlocProvider(create: (context) => MenuCubit(FirebaseMenuRepo())),
            BlocProvider(
              create: (context) => CategoryCubit(FirebaseCategoryRepo()),
            ),
            BlocProvider(create: (context) => CartCubit()),
            BlocProvider(create: (context) => FavouriteItemCubit()),
            BlocProvider(create: (context) => FavouriteCubit()),
            BlocProvider(create: (context) => EditModeCubit()),
            BlocProvider(create: (context) => PaymentSelectCubit()),
            BlocProvider(create: (context) => TotalPriceCubit()),
            BlocProvider(create: (context) => AddCardCubit()),
            BlocProvider(create: (context) => CreditCardsCubit()),
            BlocProvider(create: (context) => EditProfileCubit()),
            BlocProvider(create: (context) => ActiveDarkModeCubit()),
            BlocProvider(create: (context) => LocationCubit()),
            BlocProvider(create: (context) => OrderCubit()),
            BlocProvider(
              create: (context) => GetOrdersCubit(FirebaseOrderRepo()),
            ),
            BlocProvider(
              create: (context) => UserNameCubit(FirebaseUserRepo()),
            ),
          ],
          child: BlocBuilder<ActiveDarkModeCubit, ThemeMode>(
            builder: (context, mode) {
              return MaterialApp(
                scrollBehavior: const MaterialScrollBehavior().copyWith(
                  overscroll: false,
                ),
                debugShowCheckedModeBanner: false,
                localizationsDelegates: context.localizationDelegates,
                supportedLocales: context.supportedLocales,
                locale: context.locale,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: mode,
                home: SplashScreen(),
              );
            },
          ),
        );
      },
    );
  }
}
