import 'package:equatable/equatable.dart';
import 'package:restaurant/features/auth/data/entities/user_entity.dart';

class UserModel extends Equatable {
  final String userId;
  final String name;
  final String email;
  final String? phone;
  final String? address;
  final String? governorate;
  const UserModel({
    required this.userId,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.governorate,
  });

  static const empty = UserModel(userId: "", name: "", email: "", phone: "", address: "", governorate: "Cairo");

  UserModel copyWith({
    final String? userId,
    final String? name,
    final String? email,
    final String? phone,
    final String? address,
    final String? governorate,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      governorate: governorate ?? this.governorate,
    );
  }

  MyUserEntity toEntity() {
    return MyUserEntity(userId: userId, email: email, name: name, phone: phone ?? "", address: address ?? "", governorate: governorate ?? "");
  }

  static UserModel fromEntity(MyUserEntity entity) {
    return UserModel(
      userId: entity.userId,
      name: entity.name,
      email: entity.email,
      phone: entity.phone,
      address: entity.address,
      governorate: entity.governorate,
    );
  }

  @override
  List<Object?> get props => [userId, name, email, phone, address, governorate];
}
