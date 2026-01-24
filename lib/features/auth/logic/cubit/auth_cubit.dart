import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:restaurant/features/auth/data/entities/user_entity.dart';
import 'package:restaurant/features/auth/data/models/user_model.dart';
import 'package:restaurant/features/auth/data/repositories/user_repo.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepository userRepository;
  AuthCubit(this.userRepository) : super(AuthInitial());

  Future<void> signUp(UserModel userModel, String password) async {
    emit(AuthLoading());
    try {
      UserModel newUser = await userRepository.signUp(userModel, password);
      await userRepository.setUserData(newUser);
      emit(AuthSuccess(user: newUser));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await userRepository.signIn(email, password);
      final String userId = FirebaseAuth.instance.currentUser!.uid;
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      final user = UserModel.fromEntity(
        MyUserEntity.fromDocument(userDoc.data()!),
      );
      emit(AuthLoggedIn());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> signOut() async {
    try {
      emit(AuthLoading());
      await userRepository.signOut();
      emit(AuthSignedOut());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future signInWithGoogle() async {
    emit(AuthLoading());
    try {
      final user = await GoogleSignIn().signIn();
      if (user == null) {
        emit(AuthInitial());
        return;
      }
      final bool success = await userRepository.signInWithGoogle();
      if (success) {
        emit(AuthLoggedIn());
      } else {
        emit(AuthError(message: "Google Sign In Failed"));
      }
    } catch (e) {
      emit(AuthError(message: e.toString()));
      print(e.toString());
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      emit(AuthLoading());
      await userRepository.forgotPassword(email);
      emit(AuthResetEmailSent());
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Stream listenToAuthChanges() {
    return userRepository.user;
  }
}
