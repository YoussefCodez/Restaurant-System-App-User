part of 'menu_cubit.dart';

sealed class MenuState extends Equatable {
  const MenuState();

  @override
  List<Object> get props => [];
}

final class MenuInitial extends MenuState {}

final class MenuLoading extends MenuState {}

final class MenuSuccess extends MenuState {
  final List<MenuModel> menu;
  const MenuSuccess({required this.menu});
  @override
  List<Object> get props => [menu];
}

final class MenuError extends MenuState {
  final String message;
  const MenuError({required this.message});
  @override
  List<Object> get props => [message];
}
