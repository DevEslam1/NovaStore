import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signInWithEmailPassword(String email, String password);
  Future<Either<Failure, UserEntity>> signUpWithEmailPassword(String email, String password, String name);
  Future<Either<Failure, String>> signInWithPhone(String phoneNumber);
  Future<Either<Failure, UserEntity>> verifyOtp(String verificationId, String smsCode);
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, UserEntity>> signInAsGuest();
  Future<Either<Failure, UserEntity?>> getCurrentUser();
  Future<Either<Failure, void>> updateDeviceToken(String token);
  Stream<UserEntity?> get authStateChanges;
}
