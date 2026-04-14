import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class FirebaseAuthDataSource {
  Future<UserModel> signInWithEmailPassword(String email, String password);
  Future<UserModel> signUpWithEmailPassword(String email, String password, String name);
  Future<void> signOut();
  Future<UserModel> signInAnonymously();
  UserModel? getCurrentUser();
  Stream<UserModel?> get authStateChanges;
}

class FirebaseAuthDataSourceImpl implements FirebaseAuthDataSource {
  final FirebaseAuth firebaseAuth;

  FirebaseAuthDataSourceImpl(this.firebaseAuth);

  @override
  Future<UserModel> signInWithEmailPassword(String email, String password) async {
    try {
      final credential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        throw const AuthException('User not found after sign in.');
      }
      return UserModel.fromFirebaseUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'An error occurred during sign in.');
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel> signUpWithEmailPassword(String email, String password, String name) async {
    try {
      final credential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (credential.user == null) {
        throw const AuthException('Failed to create user.');
      }
      await credential.user!.updateDisplayName(name);
      return UserModel.fromFirebaseUser(credential.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'An error occurred during sign up.');
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  @override
  Future<UserModel> signInAnonymously() async {
    try {
      final credential = await firebaseAuth.signInAnonymously();
      if (credential.user == null) {
        throw const AuthException('Failed to sign in as guest.');
      }
      return UserModel.fromFirebaseUser(credential.user!, isGuest: true);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'An error occurred during guest sign in.');
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  UserModel? getCurrentUser() {
    final user = firebaseAuth.currentUser;
    return user != null ? UserModel.fromFirebaseUser(user) : null;
  }

  @override
  Stream<UserModel?> get authStateChanges => firebaseAuth.authStateChanges().map(
        (user) => user != null ? UserModel.fromFirebaseUser(user) : null,
      );
}
