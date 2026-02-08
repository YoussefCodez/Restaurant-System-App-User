import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:restaurant/features/payment/data/models/order_item_model.dart';

class OrderModel {
  final String userId;
  final num totalOrderPrice;
  final Timestamp orderedAt;
  final String? status;
  final String? deliveryTime;
  final List<OrderItemModel> items;

  OrderModel({
    required this.userId,
    required this.totalOrderPrice,
    required this.orderedAt,
    required this.status,
    required this.deliveryTime,
    required this.items,
  });

  factory OrderModel.fromDocument(Map<String, dynamic> doc) {
    return OrderModel(
      userId: doc["userId"] ?? "",
      totalOrderPrice: doc["totalOrderPrice"] ?? 0,
      orderedAt: doc["orderedAt"] ?? Timestamp.now().toDate(),
      status: doc["status"] ?? "",
      deliveryTime: doc["deliveryTime"] ?? "",
      items: List<OrderItemModel>.from(doc["items"]?.map((e) => OrderItemModel.fromMap(e)) ?? []),
    );
  } 

  Map<String, dynamic> toMap() {
    return {
      "userId": userId,
      "totalOrderPrice": totalOrderPrice,
      "orderedAt": orderedAt,
      "status": status,
      "deliveryTime": deliveryTime,
      "items": items.map((e) => e.toMap()).toList(),
    };
  }
}