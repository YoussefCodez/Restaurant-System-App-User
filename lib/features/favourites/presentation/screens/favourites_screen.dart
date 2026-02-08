import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant/core/theme/color_manager.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:restaurant/core/widgets/custom_empty_.dart';
import 'package:restaurant/core/widgets/custom_leading_button.dart';
import 'package:restaurant/features/favourites/data/models/favourite_item_model.dart';
import 'package:restaurant/features/favourites/logic/cubit/favourite_item_cubit.dart';
import 'package:restaurant/features/home/data/models/menu_model.dart';
import 'package:restaurant/features/meal_details/presentation/screens/meal_details_screen.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: CustomLeadingButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          StringsManager.favourites,
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: .bold,
            color: Theme.of(context).colorScheme.onSecondaryContainer,
          ),
        ),
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(24.r),
              child: Column(
                children: [
                  BlocBuilder<FavouriteItemCubit, List<FavouriteItemModel>>(
                    builder: (context, state) {
                      return state.isEmpty
                          ? SizedBox(
                              height: MediaQuery.of(context).size.height * 0.8,
                              child: CustomEmpty(
                                text: StringsManager.favouritesIsEmpty,
                              ),
                            )
                          : SizedBox(
                              height: MediaQuery.of(context).size.height,
                              child: ListView.builder(
                                itemCount: state.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MealDetailsScreen(
                                                menuModel: MenuModel(
                                                  id: state[index].id,
                                                  name: state[index].name,
                                                  image: state[index].image,
                                                  price: state[index].price,
                                                  categoryId:
                                                      state[index].categoryId,
                                                  discount:
                                                      state[index].discount,
                                                  rate: state[index].rate,
                                                  hasDiscount:
                                                      state[index].hasDiscount,
                                                  isActive:
                                                      state[index].isActive,
                                                ),
                                              ),
                                        ),
                                      );
                                    },
                                    child: Row(
                                      mainAxisAlignment: .spaceBetween,
                                      children: [
                                        CachedNetworkImage(
                                          imageUrl: state[index].image,
                                          height: 70.h,
                                          width: 70.w,
                                          fit: .cover,
                                          placeholder: (context, url) {
                                            return Container(
                                              height: 70.h,
                                              width: 70.w,
                                              color: ColorsManager.primary,
                                              child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                                      color: Colors.white,
                                                    ),
                                              ),
                                            );
                                          },
                                          errorWidget: (context, url, error) {
                                            return Container(
                                              height: 60.h,
                                              width: 60.w,
                                              color: ColorsManager.primary,
                                            );
                                          },
                                        ),
                                        Expanded(
                                          child: Column(
                                            mainAxisAlignment: .spaceBetween,
                                            crossAxisAlignment: .end,
                                            children: [
                                              Text(
                                                state[index].name,
                                                style: TextStyle(
                                                  fontSize: 18.sp,
                                                  fontWeight: .w300,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondaryContainer,
                                                ),
                                              ),
                                              Text(
                                                "${state[index].price} ${StringsManager.egp}",
                                                style: TextStyle(
                                                  fontSize: 20.sp,
                                                  fontWeight: .w300,
                                                  color: Theme.of(context)
                                                      .colorScheme
                                                      .onSecondaryContainer,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
