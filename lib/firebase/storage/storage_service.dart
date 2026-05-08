import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../../core/constants/app_constants.dart';
import '../../core/error/exceptions.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // ── Get Image URL ──
  Future<String> getImageUrl(String path) async {
    try {
      final ref = _storage.ref().child(path);
      return await ref.getDownloadURL();
    } catch (e) {
      throw StorageException(e.toString());
    }
  }

  // ── Upload User Avatar ──
  Future<String> uploadUserAvatar({
    required String userId,
    required File imageFile,
  }) async {
    try {
      final ref = _storage
          .ref()
          .child('${AppConstants.userAvatarsPath}/$userId.jpg');
      final uploadTask = await ref.putFile(imageFile);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw StorageException(e.toString());
    }
  }

  // ── Get Restaurant Image URL ──
  Future<String> getRestaurantImageUrl(String restaurantId) async {
    try {
      final ref = _storage
          .ref()
          .child('${AppConstants.restaurantImagesPath}/$restaurantId.jpg');
      return await ref.getDownloadURL();
    } catch (e) {
      throw StorageException(e.toString());
    }
  }

  // ── Get Food Item Image URL ──
  Future<String> getFoodItemImageUrl(String foodItemId) async {
    try {
      final ref = _storage
          .ref()
          .child('${AppConstants.foodItemImagesPath}/$foodItemId.jpg');
      return await ref.getDownloadURL();
    } catch (e) {
      throw StorageException(e.toString());
    }
  }

  // ── Get Icon URL ──
  Future<String> getIconUrl(String iconName) async {
    try {
      final ref = _storage
          .ref()
          .child('${AppConstants.iconsPath}/$iconName');
      return await ref.getDownloadURL();
    } catch (e) {
      throw StorageException(e.toString());
    }
  }

  // ── Delete File ──
  Future<void> deleteFile(String path) async {
    try {
      await _storage.ref().child(path).delete();
    } catch (e) {
      throw StorageException(e.toString());
    }
  }
}