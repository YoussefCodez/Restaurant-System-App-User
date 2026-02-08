import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:restaurant/core/theme/color_manager.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:restaurant/core/utils/validators/valdiator.dart';
import 'package:restaurant/core/widgets/custom_button.dart';
import 'package:restaurant/core/widgets/custom_field_text.dart';
import 'package:restaurant/features/auth/data/models/user_model.dart';
import 'package:restaurant/features/auth/logic/cubit/auth_cubit.dart';
import 'package:restaurant/features/auth/presentation/screens/Login/login_screen.dart';
import 'package:restaurant/core/widgets/custom_field.dart';
import 'package:restaurant/features/home/presentation/screens/home_screen.dart';
import 'package:restaurant/core/widgets/my_dialog.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> keyForm = .new();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passController;
  late TextEditingController passRepeatController;

  @override
  void initState() {
    nameController = .new();
    emailController = .new();
    passController = .new();
    passRepeatController = .new();
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passController.dispose();
    passRepeatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        StringsManager.signUp,
                        style: TextStyle(
                          fontSize: 30.sp,
                          color: Colors.white,
                          fontWeight: .bold,
                        ),
                      ),
                      Gap(5.h),
                      Text(
                        StringsManager.pleaseSignUp,
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
                      CustomFieldText(text: StringsManager.name),
                      Gap(8.h),
                      CustomField(
                        hintText: StringsManager.nameText,
                        controller: nameController,
                        validator: Valdiator.nameValidator,
                      ),
                      Gap(24.h),
                      CustomFieldText(text: StringsManager.email),
                      Gap(8.h),
                      CustomField(
                        hintText: StringsManager.exmapleEmail,
                        controller: emailController,
                        validator: Valdiator.emailValidator,
                      ),
                      Gap(24.h),
                      CustomFieldText(text: StringsManager.password),
                      Gap(8.h),
                      CustomField(
                        hintText: StringsManager.obscure,
                        controller: passController,
                        isPassword: true,
                        validator: Valdiator.passValidator,
                      ),
                      Gap(24.h),
                      CustomFieldText(text: StringsManager.reTypePass),
                      Gap(8.h),
                      CustomField(
                        hintText: StringsManager.obscure,
                        controller: passRepeatController,
                        isPassword: true,
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return StringsManager.pleaseRepeatPass;
                          }
                          if (value != passController.text) {
                            return StringsManager.passNotMatch;
                          }
                        },
                      ),
                      Gap(29.h),
                      BlocConsumer<AuthCubit, AuthState>(
                        listener: (context, state) {
                          if (state is AuthSuccess) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => HomeScreen()),
                            );
                          } else if (state is AuthError) {
                            showDialog(
                              context: context,
                              builder: (context) =>
                                  myDialog(message: state.message),
                            );
                          }
                        },
                        builder: (context, state) {
                          return state is AuthLoading
                              ? CircularProgressIndicator(
                                  color: ColorsManager.primary,
                                  strokeWidth: 5,
                                )
                              : GestureDetector(
                                  onTap: () {
                                    if (keyForm.currentState!.validate()) {
                                      final UserModel userModel = .new(
                                        userId: '',
                                        name: nameController.text,
                                        email: emailController.text,
                                      );
                                      final String password =
                                          passController.text;
                                      context.read<AuthCubit>().signUp(
                                        userModel,
                                        password,
                                      );
                                    } else {}
                                  },
                                  child: CustomButton(
                                    text: StringsManager.signUp,
                                  ),
                                );
                        },
                      ),
                      Gap(22.h),
                      Row(
                        mainAxisAlignment: .center,
                        children: [
                          Text(
                            StringsManager.alreadyHaveAcc,
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
                                  builder: (_) => LoginScreen(),
                                ),
                              );
                            },
                            child: Text(
                              StringsManager.login,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: .bold,
                                color: ColorsManager.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
