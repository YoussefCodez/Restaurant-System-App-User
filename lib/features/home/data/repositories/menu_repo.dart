import 'package:restaurant/features/home/data/models/menu_model.dart';

abstract class MenuRepo {
  Stream<List<MenuModel>> getMenuByCategory(String categoryId);
  Stream<List<MenuModel>> getMenu();
}
