import 'package:restaurant/features/payment/data/models/order_model.dart';

abstract class OrderRepo {
  Future<void> placeOrder(OrderModel order);
  Stream<List<OrderModel>> getOrders(String userId);
}
