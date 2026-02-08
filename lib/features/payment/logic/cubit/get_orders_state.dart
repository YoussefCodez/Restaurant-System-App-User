part of 'get_orders_cubit.dart';

sealed class GetOrdersState extends Equatable {
  const GetOrdersState();

  @override
  List<Object> get props => [];
}

final class GetOrdersInitial extends GetOrdersState {}

final class GetOrdersLoading extends GetOrdersState {}

final class GetOrdersSuccess extends GetOrdersState {
  final List<OrderModel> orders;
  const GetOrdersSuccess({required this.orders});

  @override
  List<Object> get props => [orders];
}

final class GetOrdersFailure extends GetOrdersState {
  final String message;
  const GetOrdersFailure({required this.message});

  @override
  List<Object> get props => [message];
}
