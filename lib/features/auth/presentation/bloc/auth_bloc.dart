import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();
  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class AuthSignInRequested extends AuthEvent {
  final String email;
  final String password;
  const AuthSignInRequested(this.email, this.password);
  @override
  List<Object?> get props => [email, password];
}

class AuthSignInAsGuestRequested extends AuthEvent {}

class AuthSignOutRequested extends AuthEvent {}

class AuthSignUpRequested extends AuthEvent {
  final String email;
  final String password;
  final String name;

  const AuthSignUpRequested({
    required this.email,
    required this.password,
    required this.name,
  });

  @override
  List<Object?> get props => [email, password, name];
}

class AuthPhoneSignInRequested extends AuthEvent {
  final String phoneNumber;
  const AuthPhoneSignInRequested(this.phoneNumber);
  @override
  List<Object?> get props => [phoneNumber];
}

class AuthOtpVerificationRequested extends AuthEvent {
  final String verificationId;
  final String smsCode;
  final String phoneNumber;
  const AuthOtpVerificationRequested({
    required this.verificationId,
    required this.smsCode,
    required this.phoneNumber,
  });
  @override
  List<Object?> get props => [verificationId, smsCode, phoneNumber];
}


// States
abstract class AuthState extends Equatable {
  const AuthState();
  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class Authenticated extends AuthState {
  final UserEntity user;
  const Authenticated(this.user);
  @override
  List<Object?> get props => [user];
}

class AuthOtpSent extends AuthState {
  final String verificationId;
  final String phoneNumber;
  const AuthOtpSent({required this.verificationId, required this.phoneNumber});
  @override
  List<Object?> get props => [verificationId, phoneNumber];
}

class Unauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);
  @override
  List<Object?> get props => [message];
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  StreamSubscription<UserEntity?>? _authSubscription;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<AuthSignInRequested>(_onAuthSignInRequested);
    on<AuthSignInAsGuestRequested>(_onAuthSignInAsGuestRequested);
    on<AuthSignOutRequested>(_onAuthSignOutRequested);
    on<AuthSignUpRequested>(_onAuthSignUpRequested);
    on<AuthPhoneSignInRequested>(_onAuthPhoneSignInRequested);
    on<AuthOtpVerificationRequested>(_onAuthOtpVerificationRequested);


    _authSubscription = authRepository.authStateChanges.distinct().listen((user) {
      // Only trigger a check if we're not currently in a loading state
      // (as loading states are typically followed by an explicit emit)
      if (state is! AuthLoading) {
        add(AuthCheckRequested());
      }
    });
  }

  Future<void> _onAuthCheckRequested(AuthCheckRequested event, Emitter<AuthState> emit) async {
    final result = await authRepository.getCurrentUser();
    result.fold(
      (failure) => emit(Unauthenticated()),
      (user) {
        if (user != null) {
          emit(Authenticated(user));
        } else {
          emit(Unauthenticated());
        }
      },
    );
  }

  Future<void> _onAuthSignInRequested(AuthSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.signInWithEmailPassword(event.email, event.password);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onAuthSignInAsGuestRequested(AuthSignInAsGuestRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.signInAsGuest();
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onAuthSignOutRequested(AuthSignOutRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    await authRepository.signOut();
    emit(Unauthenticated());
  }

  Future<void> _onAuthSignUpRequested(AuthSignUpRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.signUpWithEmailPassword(
      event.email,
      event.password,
      event.name,
    );
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onAuthPhoneSignInRequested(AuthPhoneSignInRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.signInWithPhone(event.phoneNumber);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (verificationId) => emit(AuthOtpSent(verificationId: verificationId, phoneNumber: event.phoneNumber)),
    );
  }

  Future<void> _onAuthOtpVerificationRequested(AuthOtpVerificationRequested event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    final result = await authRepository.verifyOtp(event.verificationId, event.smsCode);
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(Authenticated(user)),
    );
  }

  @override
  Future<void> close() {
    _authSubscription?.cancel();
    return super.close();
  }
}
