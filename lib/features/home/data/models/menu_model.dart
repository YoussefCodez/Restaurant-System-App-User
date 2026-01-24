class MenuModel {
  final String categoryId;
  final String name;
  final String id;
  final String image;
  final bool isActive;
  final double price;
  MenuModel({
    required this.categoryId,
    required this.name,
    required this.id,
    required this.image,
    required this.isActive,
    required this.price,
  });

  factory MenuModel.fromMap(Map<String, dynamic> map) {
    return MenuModel(
      categoryId: map['categoryId'],
      name: map['name'],
      id: map['id'],
      image: map['image'],
      isActive: map['isActive'],
      price: map['price'],
    );
  }
}
