import 'package:bloc/bloc.dart';
import 'package:restaurant/core/utils/constants/strings_manager.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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
      emit(AuthError(message: _handleAuthException(e)));
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoading());
    try {
      await userRepository.signIn(email, password);
      final String userId = FirebaseAuth.instance.currentUser!.uid;
      await userRepository.getUserData(userId);
      emit(AuthLoggedIn());
    } catch (e) {
      emit(AuthError(message: _handleAuthException(e)));
    }
  }

  Future<void> signOut() async {
    try {
      emit(AuthLoading());
      await userRepository.signOut();
      emit(AuthSignedOut());
    } catch (e) {
      emit(AuthError(message: _handleAuthException(e)));
    }
  }

  Future signInWithGoogle() async {
    emit(AuthGoogleLoading());
    try {
      final user = await GoogleSignIn().signIn();
      if (user == null) {
        emit(AuthInitial());
        return;
      }
      final bool success = await userRepository.signInWithGoogle();
      if (success) {
        final String userId = FirebaseAuth.instance.currentUser!.uid;
        await userRepository.getUserData(userId);
        emit(AuthLoggedIn());
      } else {
        emit(AuthError(message: StringsManager.googleSignInFailed));
      }
    } catch (e) {
      emit(AuthError(message: _handleAuthException(e)));
      print(e.toString());
    }
  }

  Future<void> forgotPassword(String email) async {
    try {
      emit(AuthLoading());
      await userRepository.forgotPassword(email);
      emit(AuthResetEmailSent());
    } catch (e) {
      emit(AuthError(message: _handleAuthException(e)));
    }
  }

  Future<void> loadUserData() async {
    try {
      emit(AuthLoading());
      final uid = FirebaseAuth.instance.currentUser!.uid;
      final user = await userRepository.getUserData(uid);
      emit(UserLoaded(user: user));
    } catch (e) {
      emit(AuthError(message: _handleAuthException(e)));
    }
  }

  Future<void> updateUserData(UserModel user) async {
    try {
      emit(AuthLoading());
      await userRepository.setUserData(user);
      emit(UserLoaded(user: user));
    } catch (e) {
      emit(AuthError(message: _handleAuthException(e)));
    }
  }

  Stream listenToAuthChanges() {
    return userRepository.user;
  }

  String _handleAuthException(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'user-not-found':
          return StringsManager.userNotFound;
        case 'wrong-password':
          return StringsManager.wrongPassword;
        case 'email-already-in-use':
          return StringsManager.emailAlreadyInUse;
        case 'weak-password':
          return StringsManager.weakPassword;
        case 'network-request-failed':
          return StringsManager.networkRequestFailed;
        case 'too-many-requests':
          return StringsManager.tooManyRequests;
        case 'user-disabled':
          return StringsManager.userDisabled;
        case 'invalid-email':
          return StringsManager.invalidEmailFormat;
        default:
          return e.message ?? StringsManager.unknownError;
      }
    }
    return StringsManager.unknownError;
  }
}
