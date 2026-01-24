part of 'menu_cubit.dart';

sealed class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

final class MenuInitial extends MenuState {}

final class MenuLoading extends MenuState {}

final class CategoriesLoaded extends MenuState {
  final List<CategoryModel> categories;
  const CategoriesLoaded({required this.categories});
}

final class MenuSuccess extends MenuState {
  
}

final class MenuError extends MenuState {
  final String message;
  const MenuError({required this.message});
}
