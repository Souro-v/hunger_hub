abstract class AuthEvent {}

// ── Sign In ──
class SignInEvent extends AuthEvent {
  final String email;
  final String password;

  SignInEvent({required this.email, required this.password});
}

// ── Sign Up ──
class SignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  SignUpEvent({
    required this.name,
    required this.email,
    required this.password,
  });
}

// ── Sign Out ──
class SignOutEvent extends AuthEvent {}

// ── Reset Password ──
class ResetPasswordEvent extends AuthEvent {
  final String email;
  ResetPasswordEvent({required this.email});
}

// ── Check Auth ──
class CheckAuthEvent extends AuthEvent {}