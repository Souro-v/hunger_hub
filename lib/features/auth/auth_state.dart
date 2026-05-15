import '../../data/models/user_model.dart';

abstract class AuthState {}

// ── Initial ──
class AuthInitial extends AuthState {}

// ── Loading ──
class AuthLoading extends AuthState {}

// ── Authenticated ──
class AuthAuthenticated extends AuthState {
  final UserModel user;
  AuthAuthenticated({required this.user});
}

// ── Unauthenticated ──
class AuthUnauthenticated extends AuthState {}

// ── Sign Up Success ──
class AuthSignUpSuccess extends AuthState {
  final UserModel user;
  AuthSignUpSuccess({required this.user});
}

// ── Reset Password Success ──
class AuthResetPasswordSuccess extends AuthState {}

// ── Error ──
class AuthError extends AuthState {
  final String message;
  AuthError({required this.message});
}