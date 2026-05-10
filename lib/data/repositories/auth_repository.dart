import 'package:firebase_auth/firebase_auth.dart';
import '../../core/error/exceptions.dart';
import '../../core/error/failures.dart';
import '../../core/storage/local_storage.dart';
import '../../firebase/auth/firebase_auth_service.dart';
import '../../firebase/firestore/user_service.dart';
import '../models/user_model.dart';

class AuthRepository {
  final FirebaseAuthService _authService;
  final UserService _userService;
  final LocalStorage _localStorage;

  AuthRepository({
    required FirebaseAuthService authService,
    required UserService userService,
    required LocalStorage localStorage,
  })  : _authService = authService,
        _userService = userService,
        _localStorage = localStorage;

  // ── Sign Up ──
  Future<UserModel> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final user = await _authService.signUpWithEmail(
        email: email,
        password: password,
      );
      if (user == null) throw const AuthException('Sign up failed');

      final userModel = UserModel(
        id: user.uid,
        name: name,
        email: email,
      );

      await _userService.createUser(
        userId: user.uid,
        userData: userModel.toMap(),
      );

      await _authService.sendEmailVerification();
      await _localStorage.saveUserId(user.uid);
      await _localStorage.setLoggedIn(true);

      return userModel;
    } on AppException {
      rethrow;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  // ── Sign In ──
  Future<UserModel> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final user = await _authService.signInWithEmail(
        email: email,
        password: password,
      );
      if (user == null) throw const AuthException('Sign in failed');

      final userData = await _userService.getUser(user.uid);
      final userModel = UserModel.fromMap(userData);

      await _localStorage.saveUserId(user.uid);
      await _localStorage.setLoggedIn(true);

      return userModel;
    } on AppException {
      rethrow;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  // ── Sign Out ──
  Future<void> signOut() async {
    try {
      await _authService.signOut();
      await _localStorage.clearAll();
    } catch (e) {
      throw AuthException(e.toString());
    }
  }

  // ── Get Current User ──
  Future<UserModel?> getCurrentUser() async {
    try {
      final userId = _localStorage.getUserId();
      if (userId == null) return null;
      final userData = await _userService.getUser(userId);
      return UserModel.fromMap(userData);
    } catch (e) {
      return null;
    }
  }

  // ── Is Logged In ──
  bool get isLoggedIn => _localStorage.isLoggedIn();

  // ── Auth State ──
  Stream<User?> get authStateChanges => _authService.authStateChanges;

  // ── Reset Password ──
  Future<void> resetPassword(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
    } on AppException {
      rethrow;
    } catch (e) {
      throw AuthException(e.toString());
    }
  }
}