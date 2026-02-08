import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant/core/services/hive_service.dart';
import 'package:restaurant/features/home/data/models/menu_model.dart';
import 'package:restaurant/features/home/data/repositories/menu_repo.dart';

class FirebaseMenuRepo implements MenuRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Stream<List<MenuModel>> getMenuByCategory(String categoryId) {
    return firestore
        .collection('menu')
        .where('categoryId', isEqualTo: categoryId)
        .limit(10)
        .snapshots()
        .map((snapshot) {
          final menu = snapshot.docs
              .map((doc) => MenuModel.fromMap(doc.data(), doc.id))
              .toList();
          HiveService().cacheMenu(menu.map((item) => item.toMap()).toList());
          return menu;
        });
  }

  @override
  Stream<List<MenuModel>> getMenu() {
    return firestore.collection('menu').orderBy('categoryId').snapshots().map((snapshot) {
      final menu = snapshot.docs
          .map((doc) => MenuModel.fromMap(doc.data(), doc.id))
          .toList();
      HiveService().cacheMenu(menu.map((item) => item.toMap()).toList());
      return menu;
    });
  }
}
