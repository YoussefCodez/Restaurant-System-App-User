import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:restaurant/core/theme/color_manager.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:restaurant/core/utils/validators/valdiator.dart';
import 'package:restaurant/core/widgets/custom_button.dart';
import 'package:restaurant/features/auth/data/repositories/firebase_user_repo.dart';
import 'package:restaurant/features/auth/logic/cubit/auth_cubit.dart';
import 'package:restaurant/features/auth/presentation/screens/Login/login_screen.dart';
import 'package:restaurant/features/auth/presentation/widgets/custom_field.dart';
import 'package:restaurant/features/auth/presentation/widgets/custom_text.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final GlobalKey<FormState> keyForm = .new();
  late TextEditingController emailController;
  @override
  void initState() {
    emailController = .new();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(FirebaseUserRepo()),
      child: Scaffold(
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
                    top: 35.h,
                    left: 20.w,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        width: 45.w,
                        height: 45.h,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50.r),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new,
                          color: Color(0xFF5E616F),
                          size: 20.w,
                        ),
                      ),
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
                          StringsManager.forgotPassword,
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
                        Gap(30.h),
                        BlocConsumer<AuthCubit, AuthState>(
                          listener: (context, state) {
                            if (state is AuthResetEmailSent) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    "Reset email sent successfully",
                                  ),
                                ),
                              );
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => LoginScreen(),
                                ),
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
                                : GestureDetector(
                                    onTap: () {
                                      if (keyForm.currentState!.validate()) {
                                        context
                                            .read<AuthCubit>()
                                            .forgotPassword(
                                              emailController.text.trim(),
                                            );
                                      } else {}
                                    },
                                    child: CustomButton(
                                      text: StringsManager.sendCode,
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
