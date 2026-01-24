import 'package:equatable/equatable.dart';
import 'package:restaurant/features/auth/data/entities/user_entity.dart';

class UserModel extends Equatable {
  final String userId;
  final String name;
  final String email;

  const UserModel({
    required this.userId,
    required this.name,
    required this.email,
  });

  static const empty = UserModel(userId: "", name: "", email: "");

  UserModel copyWith({
    final String? userId,
    final String? name,
    final String? email,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  MyUserEntity toEntity() {
    return MyUserEntity(userId: userId, email: email, name: name);
  }

  static UserModel fromEntity(MyUserEntity entity) {
    return UserModel(
      userId: entity.userId,
      name: entity.name,
      email: entity.email,
    );
  }

  @override
  // TODO: implement props
  List<Object?> get props => [userId, name, email];
}
