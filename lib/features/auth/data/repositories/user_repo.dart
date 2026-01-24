import 'package:firebase_auth/firebase_auth.dart';
import 'package:restaurant/features/auth/data/models/user_model.dart';

abstract class UserRepository {
  Stream<User?> get user;

  Future<UserModel> signUp(UserModel userModel, String password);
  Future<void> signIn(String email, String password);
  Future<void> signOut();
  Future<void> setUserData(UserModel user);
  Future<void> forgotPassword(String email);
  Future<bool> signInWithGoogle();
}
