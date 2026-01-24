import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:restaurant/core/utils/constants/assets_manager.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:restaurant/core/utils/responsive/device_utils.dart';
import 'package:restaurant/core/widgets/custom_button.dart';
import 'package:restaurant/features/auth/presentation/screens/Login/login_screen.dart';
import 'package:restaurant/features/onBoarding/logic/cubit/index_cubit.dart';
import 'package:restaurant/features/onBoarding/logic/cubit/once_board_cubit.dart';
import 'package:restaurant/features/onBoarding/presentation/widgets/Indicator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class onBoardingScreen extends StatefulWidget {
  const onBoardingScreen({super.key});

  @override
  State<onBoardingScreen> createState() => _onBoardingScreenState();
}


class _onBoardingScreenState extends State<onBoardingScreen> {
  late PageController _controller;
  final List<String> title = [
    StringsManager.onBoardOne,
    StringsManager.onBoardTwo,
    StringsManager.onBoardThree,
  ];
  final List<String> description = [
    StringsManager.onBoardOneDes,
    StringsManager.onBoardTwoDes,
    StringsManager.onBoardThreeDes,
  ];
  @override
  void initState() {
    _controller = .new();
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => IndexCubit(),
        child: BlocListener<IndexCubit, IndexState>(
          listener: (context, state) {
            _controller.animateToPage(
              (state as IndexInitial).index,
              duration: Duration(milliseconds: 400),
              curve: Curves.easeInOut,
            );
          },
          child: BlocBuilder<IndexCubit, IndexState>(
            builder: (context, state) {
              final int index = (state as IndexInitial).index;
              return Column(
                children: [
                  Expanded(
                    flex: DeviceUtils.isTablet(context) ? 3 : 4,
                    child: SizedBox(
                      width: double.infinity,
                      child: PageView(
                        controller: _controller,
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          Image.asset(AssetsManager.onBoardThree, fit: .cover),
                          Image.asset(AssetsManager.onBoardTwo, fit: .cover),
                          Image.asset(AssetsManager.onBoardFour, fit: .cover),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.r),
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        children: [
                          Text(
                            title[index],
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 24.sp,
                              fontWeight: .w900,
                            ),
                          ),
                          Gap(18.h),
                          Text(
                            description[index],
                            style: TextStyle(
                              color: Theme.of(
                                context,
                              ).colorScheme.primaryContainer,
                              fontSize: 14.sp,
                              fontWeight: .normal,
                            ),
                            textAlign: .center,
                          ),
                          Gap(20.h),
                          Indicator(),
                          Gap(20.h),
                          GestureDetector(
                            onTap: () {
                              if (index == title.length - 1) {
                                context.read<OnceBoardCubit>().finishOnBoarding();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => LoginScreen(),
                                  ),
                                );
                              } else {
                                context.read<IndexCubit>().nextPage(
                                  title.length,
                                );
                              }
                            },
                            child: CustomButton(text: index == title.length - 1 ? "Get Started" : "Next"),
                          ),
                          Gap(5.h),
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
                              "Skip",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: .normal,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
