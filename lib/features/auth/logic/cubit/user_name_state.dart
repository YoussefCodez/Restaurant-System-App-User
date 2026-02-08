part of 'user_name_cubit.dart';

sealed class UserNameState extends Equatable {
  const UserNameState();

  @override
  List<Object> get props => [];
}

final class UserNameInitial extends UserNameState {}

final class UserNameLoading extends UserNameState {}

final class UserNameLoaded extends UserNameState {
  final String name;
  const UserNameLoaded({required this.name});

  @override
  List<Object> get props => [name];
}

final class UserNameError extends UserNameState {
  final String error;
  const UserNameError({required this.error});
}
