class AppException implements Exception {
  final String message;
  const AppException(this.message);

  @override
  String toString() => message;
}

// ── Auth Exceptions ──
class AuthException extends AppException {
  const AuthException(super.message);
}

class UserNotFoundException extends AppException {
  const UserNotFoundException() : super('User not found');
}

class WrongPasswordException extends AppException {
  const WrongPasswordException() : super('Wrong password');
}

class EmailAlreadyInUseException extends AppException {
  const EmailAlreadyInUseException() : super('Email already in use');
}

class WeakPasswordException extends AppException {
  const WeakPasswordException() : super('Password is too weak');
}

// ── Firestore Exceptions ──
class ServerException extends AppException {
  const ServerException(super.message);
}

class DataNotFoundException extends AppException {
  const DataNotFoundException() : super('Data not found');
}

// ── Network Exceptions ──
class NetworkException extends AppException {
  const NetworkException() : super('No internet connection');
}

// ── Cache Exceptions ──
class CacheException extends AppException {
  const CacheException() : super('Cache error');
}

// ── Permission Exceptions ──
class PermissionException extends AppException {
  const PermissionException() : super('Permission denied');
}

// ── Storage Exceptions ──
class StorageException extends AppException {
  const StorageException(super.message);
}