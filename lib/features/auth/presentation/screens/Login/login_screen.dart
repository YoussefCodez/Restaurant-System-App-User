import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:restaurant/core/theme/color_manager.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:restaurant/core/utils/validators/valdiator.dart';
import 'package:restaurant/core/widgets/custom_button.dart';
import 'package:restaurant/features/auth/data/repositories/firebase_user_repo.dart';
import 'package:restaurant/features/auth/logic/cubit/auth_cubit.dart';
import 'package:restaurant/features/auth/logic/cubit/obscure_cubit.dart';
import 'package:restaurant/features/auth/logic/cubit/remember_me_status_cubit.dart';
import 'package:restaurant/features/auth/presentation/screens/ForgotPassword/forgot_password_screen.dart';
import 'package:restaurant/features/auth/presentation/screens/Signup/signup_screen.dart';
import 'package:restaurant/features/auth/presentation/widgets/custom_checkbox.dart';
import 'package:restaurant/features/auth/presentation/widgets/custom_field.dart';
import 'package:restaurant/features/auth/presentation/widgets/custom_text.dart';
import 'package:restaurant/features/home/data/repositories/firebase_menu_repo.dart';
import 'package:restaurant/features/home/logic/cubit/menu_cubit.dart';
import 'package:restaurant/features/home/presentation/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> keyForm = .new();
  late TextEditingController passController;
  late TextEditingController emailController;

  @override
  void initState() {
    passController = .new();
    emailController = .new();
    super.initState();
  }

  @override
  void dispose() {
    passController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthCubit(FirebaseUserRepo())),
        BlocProvider(create: (context) => ObscureCubit()),
        BlocProvider(create: (context) => RememberMeStatusCubit()),
      ],
      child: Scaffold(
        backgroundColor: ColorsManager.backgroundDark,
        body: Column(
          children: [
            Expanded(
              flex: 2,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: SvgPicture.asset(
                      "assets/svg/BGAsset.svg",
                      fit: .cover,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    left: 0,
                    top: 100.h,
                    child: Column(
                      crossAxisAlignment: .center,
                      children: [
                        Text(
                          StringsManager.login,
                          style: TextStyle(
                            fontSize: 30.sp,
                            color: Colors.white,
                            fontWeight: .bold,
                          ),
                        ),
                        Gap(5.h),
                        Text(
                          StringsManager.pleaseSignIn,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: Colors.white,
                            fontWeight: .w100,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(24.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(24),
                    topLeft: Radius.circular(24),
                  ),
                ),
                child: SingleChildScrollView(
                  child: Form(
                    key: keyForm,
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        CustomText(text: StringsManager.email),
                        Gap(8.h),
                        CustomField(
                          hintText: StringsManager.exmapleEmail,
                          controller: emailController,
                          validator: Valdiator.emailValidator,
                        ),
                        Gap(24.h),
                        CustomText(text: StringsManager.password),
                        Gap(8.h),
                        CustomField(
                          hintText: StringsManager.obscure,
                          controller: passController,
                          isPassword: true,
                          validator: Valdiator.passValidator,
                        ),
                        Gap(24.h),
                        Row(
                          mainAxisAlignment: .spaceBetween,
                          children: [
                            Row(
                              children: [
                                CustomCheckbox(),
                                Gap(10.w),
                                Text(
                                  StringsManager.rememberMe,
                                  style: TextStyle(
                                    color: Color(0xFF7E8A97),
                                    fontSize: 12.sp,
                                    fontWeight: .normal,
                                  ),
                                ),
                              ],
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ForgotPasswordScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                StringsManager.forgotPassword,
                                style: TextStyle(
                                  color: ColorsManager.primary,
                                  fontSize: 12.sp,
                                  fontWeight: .normal,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(29.h),
                        BlocConsumer<AuthCubit, AuthState>(
                          listener: (context, state) {
                            if (state is AuthLoggedIn) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => HomeScreen(),
                                ),
                              );
                            } else if (state is AuthError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)),
                              );
                            }
                          },
                          builder: (context, state) {
                            return state is AuthLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: ColorsManager.primary,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      if (keyForm.currentState!.validate()) {
                                        context.read<AuthCubit>().signIn(
                                          emailController.text,
                                          passController.text,
                                        );
                                      } else {}
                                    },
                                    child: CustomButton(
                                      text: StringsManager.login,
                                    ),
                                  );
                          },
                        ),
                        Gap(38.h),
                        Row(
                          mainAxisAlignment: .center,
                          children: [
                            Text(
                              StringsManager.donthaveacc,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: .normal,
                                color: ColorsManager.secondry,
                              ),
                            ),
                            Gap(11.w),
                            TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => SignupScreen(),
                                  ),
                                );
                              },
                              child: Text(
                                StringsManager.signUp,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  fontWeight: .bold,
                                  color: ColorsManager.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Gap(21.h),
                        Align(
                          alignment: .center,
                          child: Text(
                            StringsManager.or,
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: .normal,
                              color: ColorsManager.secondry,
                            ),
                          ),
                        ),
                        Gap(21.h),
                        BlocConsumer<AuthCubit, AuthState>(
                          listener: (context, state) {
                            if (state is AuthLoggedIn) {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => HomeScreen()),
                              );
                            } else if (state is AuthError) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(state.message)),
                              );
                            }
                          },
                          builder: (context, state) {
                            return state is AuthLoading
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: ColorsManager.primary,
                                    ),
                                  )
                                : Align(
                                    alignment: .center,
                                    child: GestureDetector(
                                      onTap: () {
                                        context
                                            .read<AuthCubit>()
                                            .signInWithGoogle();
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(10.r),
                                        decoration: BoxDecoration(
                                          color: Colors.red,
                                          borderRadius: BorderRadius.circular(
                                            50.r,
                                          ),
                                        ),
                                        child: Icon(
                                          Icons.email,
                                          size: 30.w,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
