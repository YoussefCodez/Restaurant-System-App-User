import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant/core/services/hive_service.dart';
import 'package:restaurant/features/home/data/models/category_model.dart';
import 'package:restaurant/features/home/data/repositories/category_repo.dart';

class FirebaseCategoryRepo implements CategoryRepo {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Stream<List<CategoryModel>> getCategory() {
    return firestore.collection('categories').orderBy('order').snapshots().map((
      snapshot,
    ) {
      final categories = snapshot.docs
          .map((doc) => CategoryModel.fromMap(doc.data(), doc.id))
          .toList();
      HiveService().cacheCategory(categories.map((e) => e.toMap()).toList());
      return categories;
    });
  }
}
