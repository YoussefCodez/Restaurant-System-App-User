import 'package:restaurant/features/home/data/models/category_model.dart';

abstract class CategoryRepo {
  Stream<List<CategoryModel>> getCategory();
}
