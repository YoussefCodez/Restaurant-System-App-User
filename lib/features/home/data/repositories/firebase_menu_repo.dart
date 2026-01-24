import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant/features/home/data/models/category_model.dart';
import 'package:restaurant/features/home/data/models/menu_model.dart';
import 'package:restaurant/features/home/data/repositories/menu_repo.dart';

class FirebaseMenuRepo implements MenuRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Future<List<CategoryModel>> getCategory() async {
    final snapshot = await firestore
        .collection('categories')
        .orderBy('order')
        .get();
    return snapshot.docs
        .map((doc) => CategoryModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<List<MenuModel>> getMenuByCategory(String categoryId) async {
    final snapshot = await firestore
        .collection('menu')
        .where('categoryId', isEqualTo: categoryId)
        .get();
    return snapshot.docs.map((doc) => MenuModel.fromMap(doc.data())).toList();
  }

  @override
  Future<List<MenuModel>> getMenu() async {
    final snapshot = await firestore.collection('menu').get();
    return snapshot.docs.map((doc) => MenuModel.fromMap(doc.data())).toList();
  }
}
