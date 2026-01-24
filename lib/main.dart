import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant/core/services/shared_prefs/shared_prefs.dart';
import 'package:restaurant/features/auth/logic/cubit/remember_me_status_cubit.dart';
import 'package:restaurant/features/onBoarding/logic/cubit/once_board_cubit.dart';
import 'package:restaurant/firebase_options.dart';
import 'package:restaurant/my_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await SharedPrefs.init();
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => OnceBoardCubit()),
        BlocProvider(create: (_) => RememberMeStatusCubit()),
      ],
      child: const MyApp(),
    ),
  );
}
