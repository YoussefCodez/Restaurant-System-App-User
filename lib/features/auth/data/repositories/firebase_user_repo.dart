import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:restaurant/core/services/hive_service.dart';
import 'package:restaurant/features/auth/data/entities/user_entity.dart';
import 'package:restaurant/features/auth/data/models/user_model.dart';
import 'package:restaurant/features/auth/data/repositories/user_repo.dart';

class FirebaseUserRepo implements UserRepository {
  final FirebaseAuth _firebaseAuth;
  final usersCollection = FirebaseFirestore.instance.collection('users');
  FirebaseUserRepo({FirebaseAuth? firebaseAuth})
    : _firebaseAuth =
          firebaseAuth ?? FirebaseAuth.instance; //For Dependency Injection

  @override
  Stream<User?> get user {
    return _firebaseAuth.authStateChanges().map((firebaseUser) {
      return firebaseUser;
    });
  }

  @override
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<UserModel> signUp(UserModel userModel, String password) async {
    try {
      UserCredential user = await _firebaseAuth.createUserWithEmailAndPassword(
        email: userModel.email,
        password: password,
      );
      userModel = userModel.copyWith(userId: user.user!.uid);
      return userModel;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _firebaseAuth.signOut();
  }

  Future<bool> signInWithGoogle() async {
    await GoogleSignIn().signOut();
    final user = await GoogleSignIn().signIn();
    GoogleSignInAuthentication userAuth = await user!.authentication;
    var credential = GoogleAuthProvider.credential(
      idToken: userAuth.idToken,
      accessToken: userAuth.accessToken,
    );
    await _firebaseAuth.signInWithCredential(credential);
    if (_firebaseAuth.currentUser != null) {
      await usersCollection.doc(_firebaseAuth.currentUser!.uid).set({
        "name": _firebaseAuth.currentUser?.displayName,
        "email": _firebaseAuth.currentUser?.email,
        "userId": _firebaseAuth.currentUser!.uid,
        "phone": "",
        "address": "",
        "governorate": "Cairo",
      }, SetOptions(merge: true));
    }
    return _firebaseAuth.currentUser != null;
  }

  @override
  Future<void> setUserData(UserModel user) async {
    try {
      await usersCollection.doc(user.userId).set(user.toEntity().toDocument());
      await HiveService().cacheUserName(user.name);
      await HiveService().cacheUserAddress(user.address ?? "");
      await HiveService().cacheUserPhone(user.phone ?? "");
      await HiveService().cacheUserGovernorate(user.governorate ?? "");
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<UserModel> getUserData(String uid) async {
    try {
      final doc = await usersCollection.doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final user = UserModel.fromEntity(
          MyUserEntity.fromDocument(doc.data()!),
        );
        await HiveService().cacheUserName(user.name);
        await HiveService().cacheUserAddress(user.address ?? "");
        await HiveService().cacheUserPhone(user.phone ?? "");
        await HiveService().cacheUserGovernorate(user.governorate ?? "");
        return user;
      }
      return UserModel.empty;
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<String> getUserName(String uid) async {
    try {
      final cachedName = HiveService().getCachedUserName();
      if (cachedName != null && cachedName.isNotEmpty) {
        return cachedName;
      }
      final doc = await usersCollection.doc(uid).get();
      if (doc.exists && doc.data() != null) {
        final user = UserModel.fromEntity(
          MyUserEntity.fromDocument(doc.data()!),
        );
        await HiveService().cacheUserName(user.name);
        return user.name;
      }
      return "";
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }

  @override
  Future<void> forgotPassword(String email) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}
