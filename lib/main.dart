import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:restaurant/core/services/shared_prefs/shared_prefs.dart';
import 'package:restaurant/features/auth/logic/cubit/remember_me_status_cubit.dart';
import 'package:restaurant/features/onBoarding/logic/cubit/once_board_cubit.dart';
import 'package:restaurant/core/services/hive_service.dart';
import 'package:restaurant/firebase_options.dart';
import 'package:restaurant/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await SharedPrefs.init();
  await Hive.initFlutter();
  await Hive.openBox('userBox');
  await Hive.openBox('categoryBox');
  await Hive.openBox('menuBox');
  await Hive.openBox('favouriteBox');
  await Hive.openBox('favouriteStateBox');
  await Hive.openBox('creditCardBox');
  await Hive.openBox('darkModeBox');
  await HiveService().clearCategory();
  await HiveService().clearMenu();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => OnceBoardCubit()),
          BlocProvider(create: (_) => RememberMeStatusCubit()),
        ],
        child: const MyApp(),
      ),
    ),
  );
}
