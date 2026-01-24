import 'package:equatable/equatable.dart';

class MyUserEntity extends Equatable {
  final String userId;
  final String name;
  final String email;
  const MyUserEntity({
    required this.userId,
    required this.name,
    required this.email,
  });
  Map<String, Object?> toDocument() {
    return {'userId': userId, 'name': name, 'email': email};
  }

  static MyUserEntity fromDocument(Map<String, dynamic> doc) {
    return MyUserEntity(userId: doc['userId'], name: doc['name'], email: doc['email']);
  }

  @override
  // TODO: implement props
  List<Object?> get props => [userId, email, name];
}
