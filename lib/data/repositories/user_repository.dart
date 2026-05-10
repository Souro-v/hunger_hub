import 'dart:io';
import '../models/review_model.dart';
import '../../core/error/exceptions.dart';
import '../../firebase/firestore/user_service.dart';
import '../../firebase/storage/storage_service.dart';
import '../models/user_model.dart';

class UserRepository {
  final UserService _userService;
  final StorageService _storageService;

  UserRepository({
    required UserService userService,
    required StorageService storageService,
  })  : _userService = userService,
        _storageService = storageService;

  // ── Get User ──
  Future<UserModel> getUser(String userId) async {
    try {
      final data = await _userService.getUser(userId);
      return UserModel.fromMap(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Update User ──
  Future<void> updateUser({
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    try {
      await _userService.updateUser(
        userId: userId,
        userData: userData,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Update Avatar ──
  Future<String> updateAvatar({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final avatarUrl = await _storageService.uploadUserAvatar(
        userId: userId,
        imageFile: imageFile,
      );
      await _userService.updateUser(
        userId: userId,
        userData: {'avatarUrl': avatarUrl},
      );
      return avatarUrl;
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Add Address ──
  Future<void> addAddress({
    required String userId,
    required Map<String, dynamic> address,
  }) async {
    try {
      await _userService.addAddress(
        userId: userId,
        address: address,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Remove Address ──
  Future<void> removeAddress({
    required String userId,
    required Map<String, dynamic> address,
  }) async {
    try {
      await _userService.removeAddress(
        userId: userId,
        address: address,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Add Review ──
  Future<void> addReview({
    required String restaurantId,
    required ReviewModel review,
  }) async {
    try {
      await _userService.addReview(
        restaurantId: restaurantId,
        review: review.toMap(),
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Save FCM Token ──
  Future<void> saveFcmToken({
    required String userId,
    required String token,
  }) async {
    try {
      await _userService.saveFcmToken(
        userId: userId,
        token: token,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}