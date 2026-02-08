import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant/features/home/data/models/category_model.dart';
import 'package:restaurant/features/home/data/repositories/category_repo.dart';

part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  final CategoryRepo repo;
  StreamSubscription? _subscription;
  List<CategoryModel>? cachedCategory;
  CategoryCubit(this.repo) : super(CategoryInitial());

  void loadCategories() {
    emit(CategoryLoading());
    _subscription?.cancel();
    _subscription = repo.getCategory().listen(
      (categories) {
        cachedCategory = categories;
        emit(CategoriesLoaded(categories: categories));
      },
      onError: (e) {
        emit(CategoryError(message: e.toString()));
      },
    );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
