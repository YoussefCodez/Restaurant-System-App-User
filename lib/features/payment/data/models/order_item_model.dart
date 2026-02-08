class OrderItemModel {
  final String mealId;
  final String mealName;
  final String mealImage;
  final String mealSize;
  final String mealType;
  final double? mealPrice;
  final String mealSpicey;
  final Set<String> mealToAdd;
  num orderItemTotalPrice;
  int orderItemQuantity;
  OrderItemModel({
    required this.mealId,
    required this.mealName,
    required this.mealImage,
    required this.mealSize,
    required this.mealType,
    required this.mealPrice,
    required this.mealSpicey,
    required this.mealToAdd,
    required this.orderItemTotalPrice,
    required this.orderItemQuantity,
  });

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      mealId: map["mealId"] ?? "",
      mealName: map["mealName"] ?? "",
      mealImage: map["mealImage"] ?? "",
      mealSize: map["mealSize"] ?? "",
      mealType: map["mealType"] ?? "",
      mealPrice: map["mealPrice"] ?? 0,
      mealSpicey: map["mealSpicey"] ?? "",
      mealToAdd: Set<String>.from(map["mealToAdd"] ?? {}),
      orderItemTotalPrice: map["orderItemTotalPrice"] ?? 0,
      orderItemQuantity: map["orderItemQuantity"] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "mealId": mealId,
      "mealName": mealName,
      "mealImage": mealImage,
      "mealSize": mealSize,
      "mealType": mealType,
      "mealPrice": mealPrice,
      "mealSpicey": mealSpicey,
      "mealToAdd": mealToAdd.toList(),
      "orderItemTotalPrice": orderItemTotalPrice,
      "orderItemQuantity": orderItemQuantity,
    };
  }
}
