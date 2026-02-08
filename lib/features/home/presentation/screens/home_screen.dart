import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:restaurant/core/theme/color_manager.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:restaurant/core/utils/responsive/device_utils.dart';
import 'package:restaurant/core/widgets/custom_text.dart';
import 'package:restaurant/core/widgets/custom_textField.dart';
import 'package:restaurant/features/auth/data/repositories/firebase_user_repo.dart';
import 'package:restaurant/features/auth/logic/cubit/auth_cubit.dart';
import 'package:restaurant/features/auth/logic/cubit/user_name_cubit.dart';
import 'package:restaurant/features/home/data/repositories/firebase_menu_repo.dart';
import 'package:restaurant/features/home/logic/cubit/category_cubit.dart';
import 'package:restaurant/features/home/logic/cubit/menu_cubit.dart';
import 'package:restaurant/features/home/presentation/widgets/app_bar.dart';
import 'package:restaurant/features/home/presentation/widgets/category.dart';
import 'package:restaurant/features/home/presentation/widgets/head_line.dart';
import 'package:restaurant/features/home/presentation/widgets/menu.dart';
import 'package:restaurant/features/home/presentation/widgets/menu_skeleton_item.dart';
import 'package:restaurant/features/home/presentation/widgets/my_drawer.dart';
import 'package:restaurant/features/search/presentation/screens/search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late TextEditingController searchController;
  late FocusNode focusNode;
  int menuLength = 1;
  @override
  void initState() {
    super.initState();
    searchController = .new();
    focusNode = .new();
    Future.microtask(() {
      context.read<CategoryCubit>().loadCategories();
      context.read<MenuCubit>().loadMenu();
      context.read<AuthCubit>().loadUserData();
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme color = Theme.of(context).colorScheme;
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarColor: color.secondary,
      ),
    );

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              UserNameCubit(FirebaseUserRepo())
                ..loadUserName(FirebaseAuth.instance.currentUser?.uid ?? ""),
        ),
        BlocProvider(
          create: (context) => MenuCubit(FirebaseMenuRepo())..loadMenu(),
        ),
      ],
      child: SafeArea(
          child: Scaffold(
            key: scaffoldKey,
          drawer: MyDrawer(),
          body: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              SliverList(
                delegate: SliverChildListDelegate([
                  Padding(
                    padding: EdgeInsets.all(20.r),
                    child: AppBarWidget(color: color, scaffoldKey: scaffoldKey),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.r),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        HeadLine(color: color),
                        Gap(16.h),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SearchScreen(),
                              ),
                            );
                          },
                          child: CustomTextField(
                            controller: searchController,
                            isEnabled: false,
                            focusNode: focusNode,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 24.r),
                    child: CustomText(text: StringsManager.allCategories),
                  ),
                  Gap(20.h),
                  Padding(
                    padding: EdgeInsets.only(left: 24.r),
                    child: SizedBox(
                      height: DeviceUtils.isTablet(context) ? 70.h : 50.h,
                      child: Category(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(24.r),
                    child: CustomText(text: StringsManager.menu),
                  ),
                ]),
              ),
              BlocBuilder<MenuCubit, MenuState>(
                builder: (context, state) {
                  if (state is MenuLoading) {
                    return SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 24.r),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 0.7,
                                ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => MenuSkeletonItem(),
                          childCount: 6,
                        ),
                      ),
                    );
                  } else if (state is MenuError) {
                    return SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(16.r),
                          child: Text(
                            state.message,
                            textAlign: .center,
                            style: TextStyle(
                              fontSize: 30.sp,
                              color: ColorsManager.primary,
                              fontWeight: .w900,
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (state is MenuSuccess) {
                    return SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 24.r),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 16,
                                  crossAxisSpacing: 16,
                                  childAspectRatio: 0.55,
                                ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => Menu(menuModel: state.menu[index]),
                          childCount: state.menu.length,
                        ),
                      ),
                    );
                  } else {
                    return SliverToBoxAdapter(child: SizedBox());
                  }
                },
              ),
              SliverToBoxAdapter(child: Gap(50.h)),
            ],
          ),
        ),
      ),
    );
  }
}
