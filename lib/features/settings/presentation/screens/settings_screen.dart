import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:restaurant/core/theme/color_manager.dart';
import 'package:restaurant/core/utils/responsive/device_utils.dart';
import 'package:restaurant/core/widgets/custom_edit_button.dart';
import 'package:restaurant/core/widgets/custom_leading_button.dart';
import 'package:restaurant/core/widgets/sign_out_button.dart';
import 'package:restaurant/features/auth/logic/cubit/auth_cubit.dart';
import 'package:restaurant/features/settings/logic/cubit/active_dark_mode_cubit.dart';
import 'package:restaurant/features/settings/logic/cubit/edit_profile_cubit.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:restaurant/features/settings/presentation/widgets/user_info.dart';
import 'package:restaurant/core/widgets/my_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  @override
  void initState() {
    _usernameController = .new();
    _emailController = .new();
    super.initState();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomLeadingButton(
          onPressed: () {
            if (context.read<EditProfileCubit>().state) {
              context.read<EditProfileCubit>().reset();
              _usernameController.text =
                  (context.read<AuthCubit>().state as UserLoaded).user.name;
              Navigator.pop(context);
            } else {
              Navigator.pop(context);
            }
          },
        ),
        title: Text(
          StringsManager.settings,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: .bold,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
        actions: [
          BlocBuilder<EditProfileCubit, bool>(
            builder: (context, edit) {
              return BlocBuilder<AuthCubit, AuthState>(
                builder: (context, state) {
                  return CustomEditButton(
                    text: edit
                        ? StringsManager.cancel
                        : StringsManager.editProfile,
                    onTap: () {
                      if (edit) {
                        context.read<EditProfileCubit>().toggleEditMode();
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _usernameController.text =
                              (state as UserLoaded).user.name;
                        });
                      } else {
                        context.read<EditProfileCubit>().toggleEditMode();
                      }
                    },
                    color: edit ? Colors.red : ColorsManager.primary,
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          children: [
            UserInfo(
              usernameController: _usernameController,
              emailController: _emailController,
            ),
            Gap(30.h),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  StringsManager.darkMode,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                BlocBuilder<ActiveDarkModeCubit, ThemeMode>(
                  builder: (context, mode) {
                    return Switch(
                      value: mode == ThemeMode.dark,
                      onChanged: (value) {
                        context.read<ActiveDarkModeCubit>().toggleDarkMode();
                      },
                      activeThumbColor: ColorsManager.primary,
                    );
                  },
                ),
              ],
            ),
            Gap(DeviceUtils.isTablet(context) ? 30.h : 10.h),
            Row(
              mainAxisAlignment: .spaceBetween,
              children: [
                Text(
                  StringsManager.arabicLanguage,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.onSecondaryContainer,
                  ),
                ),
                Switch(
                  value: context.locale == const Locale('ar'),
                  onChanged: (value) {
                    if (value) {
                      context.setLocale(const Locale('ar'));
                    } else {
                      context.setLocale(const Locale('en'));
                    }
                  },
                  activeThumbColor: ColorsManager.primary,
                ),
              ],
            ),
            Spacer(),
            SignOutButton(),
          ],
        ),
      ),
      floatingActionButton: BlocBuilder<EditProfileCubit, bool>(
        builder: (context, edit) {
          return BlocBuilder<AuthCubit, AuthState>(
            builder: (context, state) {
              return edit && state is UserLoaded
                  ? FloatingActionButton(
                      backgroundColor: ColorsManager.primary,
                      splashColor: Colors.transparent,
                      onPressed: () {
                        if (_usernameController.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) => myDialog(
                              message: StringsManager.usernameCanNotBeEmpty,
                            ),
                          );
                        } else if (_usernameController.text.length > 20) {
                          showDialog(
                            context: context,
                            builder: (context) => myDialog(
                              message: StringsManager.usernameCanNotBeLong,
                            ),
                          );
                        } else {
                          final updatedUser = state.user.copyWith(
                            name: _usernameController.text,
                          );
                          context.read<AuthCubit>().updateUserData(updatedUser);
                          context.read<EditProfileCubit>().toggleEditMode();
                          FocusScope.of(context).unfocus();
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            _usernameController.text = updatedUser.name;
                          });
                        }
                      },
                      child: Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 22.sp,
                      ),
                    )
                  : const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
