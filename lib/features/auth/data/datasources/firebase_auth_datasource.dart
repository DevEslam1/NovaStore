import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../../../../core/error/exceptions.dart';

abstract class FirebaseAuthDataSource {
  Future<UserModel> signInWithEmailPassword(String email, String password);
  Future<UserModel> signUpWithEmailPassword(String email, String password, String name);
  Future<String> verifyPhoneNumber(String phoneNumber);
  Future<UserModel> signInWithOtp(String verificationId, String smsCode);
  Future<void> signOut();
  Future<UserModel> signInAnonymously();
  Future<void> updateUserDeviceToken(String token);
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
  Future<String> verifyPhoneNumber(String phoneNumber) async {
    final Completer<String> completer = Completer<String>();

    try {
      await firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Automatic verification or instant verification.
          // For now, we'll let the user enter the code manually or handled by callbacks.
        },
        verificationFailed: (FirebaseAuthException e) {
          if (!completer.isCompleted) {
            completer.completeError(AuthException(e.message ?? 'Verification failed'));
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          if (!completer.isCompleted) {
            completer.complete(verificationId);
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          if (!completer.isCompleted) {
            completer.complete(verificationId);
          }
        },
      );
      return completer.future;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Future<UserModel> signInWithOtp(String verificationId, String smsCode) async {
    try {
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final userCredential = await firebaseAuth.signInWithCredential(credential);
      if (userCredential.user == null) {
        throw const AuthException('Failed to sign in with OTP.');
      }
      return UserModel.fromFirebaseUser(userCredential.user!);
    } on FirebaseAuthException catch (e) {
      throw AuthException(e.message ?? 'Invalid verification code.');
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  @override
  Stream<UserModel?> get authStateChanges => firebaseAuth.authStateChanges().map(
        (user) => user != null ? UserModel.fromFirebaseUser(user) : null,
      );

  @override
  Future<void> updateUserDeviceToken(String token) async {
    final user = firebaseAuth.currentUser;
    if (user != null) {
      final firestore = FirebaseFirestore.instance;
      await firestore.collection('users').doc(user.uid).update({
        'deviceToken': token,
        'lastTokenUpdate': FieldValue.serverTimestamp(),
      });
    }
  }
}
