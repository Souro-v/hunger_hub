abstract class Failure {
  final String message;
  const Failure(this.message);
}

// ── Firebase Auth Failures ──
class AuthFailure extends Failure {
  const AuthFailure(super.message);
}

class UserNotFoundFailure extends Failure {
  const UserNotFoundFailure() : super('User not found');
}

class WrongPasswordFailure extends Failure {
  const WrongPasswordFailure() : super('Wrong password');
}

class EmailAlreadyInUseFailure extends Failure {
  const EmailAlreadyInUseFailure() : super('Email already in use');
}

class WeakPasswordFailure extends Failure {
  const WeakPasswordFailure() : super('Password is too weak');
}

// ── Firestore Failures ──
class ServerFailure extends Failure {
  const ServerFailure(super.message);
}

class DataNotFoundFailure extends Failure {
  const DataNotFoundFailure() : super('Data not found');
}

// ── Network Failures ──
class NetworkFailure extends Failure {
  const NetworkFailure() : super('No internet connection');
}

// ── Cache Failures ──
class CacheFailure extends Failure {
  const CacheFailure() : super('Cache error');
}

// ── Permission Failures ──
class PermissionFailure extends Failure {
  const PermissionFailure() : super('Permission denied');
}

// ── Unknown Failure ──
class UnknownFailure extends Failure {
  const UnknownFailure() : super('Something went wrong');
}