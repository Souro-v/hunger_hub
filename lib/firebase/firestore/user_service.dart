import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';
import '../../core/error/exceptions.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── Create User ──
  Future<void> createUser({
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .set({
        ...userData,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get User ──
  Future<Map<String, dynamic>> getUser(String userId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .get();
      if (!doc.exists) throw const DataNotFoundException();
      return {'id': doc.id, ...doc.data()!};
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
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({
        ...userData,
        'updatedAt': FieldValue.serverTimestamp(),
      });
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
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({
        'addresses': FieldValue.arrayUnion([address]),
      });
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
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({
        'addresses': FieldValue.arrayRemove([address]),
      });
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
      await _firestore
          .collection(AppConstants.usersCollection)
          .doc(userId)
          .update({'fcmToken': token});
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Add Review ──
  Future<void> addReview({
    required String restaurantId,
    required Map<String, dynamic> review,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.restaurantsCollection)
          .doc(restaurantId)
          .collection(AppConstants.reviewsCollection)
          .add({
        ...review,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}