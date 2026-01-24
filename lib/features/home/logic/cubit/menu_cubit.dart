import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant/features/home/data/models/category_model.dart';
import 'package:restaurant/features/home/data/repositories/menu_repo.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepo repo;
  MenuCubit(this.repo) : super(MenuInitial());

  loadCategories() async {
    emit(MenuLoading());
    final categories = await repo.getCategory();
    emit(CategoriesLoaded(categories: categories));
  }

  void loadMenu() async {
    emit(MenuLoading());
    final menu = await repo.getMenu();
    emit(MenuSuccess());
  }

  void loadMenuByCategory(String categoryId) async {
    emit(MenuLoading());
    final menu = await repo.getMenuByCategory(categoryId);
    emit(MenuSuccess());
  }
}
