import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant/core/utils/constants/assets_manager.dart';
import 'package:restaurant/features/auth/logic/cubit/remember_me_status_cubit.dart';
import 'package:restaurant/features/auth/presentation/screens/Login/login_screen.dart';
import 'package:restaurant/features/home/presentation/screens/home_screen.dart';
import 'package:restaurant/features/onBoarding/logic/cubit/once_board_cubit.dart';
import 'package:restaurant/features/onBoarding/presentation/screens/on_boarding_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset(AssetsManager.logo, width: 150.w)
            .animate(
              onComplete: (_) async {
                if (!context.mounted) return;
                final bool isOnBoarded = context.read<OnceBoardCubit>().state;
                final bool isRemembered = context
                    .read<RememberMeStatusCubit>()
                    .state;
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return StreamBuilder<User?>(
                        stream: FirebaseAuth.instance.authStateChanges(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && isRemembered) {
                            return const HomeScreen();
                          } else if (!isOnBoarded) {
                            return const onBoardingScreen();
                          } else {
                            return const LoginScreen();
                          }
                        },
                      );
                    },
                  ),
                );
              },
            )
            .fadeIn(
              delay: Duration(milliseconds: 100),
              duration: Duration(milliseconds: 1500),
            ),
      ),
    );
  }
}
