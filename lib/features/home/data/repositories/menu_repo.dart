import 'package:restaurant/features/home/data/models/category_model.dart';
import 'package:restaurant/features/home/data/models/menu_model.dart';

abstract class MenuRepo {
  Future<List<CategoryModel>> getCategory();
  Future<List<MenuModel>> getMenuByCategory(String categoryId);
  Future<List<MenuModel>> getMenu();
}
