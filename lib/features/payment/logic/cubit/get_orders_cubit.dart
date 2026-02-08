import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant/features/payment/data/models/order_item_model.dart';
import 'package:restaurant/features/payment/data/models/order_model.dart';
import 'package:restaurant/features/payment/data/repositories/order_repo.dart';

part 'get_orders_state.dart';

class GetOrdersCubit extends Cubit<GetOrdersState> {
  final OrderRepo orderRepo;
  StreamSubscription? _subscription;

  GetOrdersCubit(this.orderRepo) : super(GetOrdersInitial());

  void loadOrders(String userId) {
    emit(GetOrdersLoading());
    _subscription?.cancel();
    _subscription = orderRepo
        .getOrders(userId)
        .listen(
          (orders) {
            emit(GetOrdersSuccess(orders: orders));
          },
          onError: (e) {
            emit(GetOrdersFailure(message: e.toString()));
          },
        );
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
