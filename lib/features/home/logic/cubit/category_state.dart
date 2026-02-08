part of 'category_cubit.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object> get props => [];
}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategoriesLoaded extends CategoryState {
  final List<CategoryModel> categories;
  const CategoriesLoaded({required this.categories});
  @override
  List<Object> get props => [categories];
}

final class CategoryError extends CategoryState {
  final String message;

  const CategoryError({required this.message});
  @override
  List<Object> get props => [message];
}
