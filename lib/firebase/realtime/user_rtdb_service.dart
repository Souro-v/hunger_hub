import 'package:firebase_database/firebase_database.dart';
import '../../core/error/exceptions.dart';

class UserRtdbService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // ── Create User ──
  Future<void> createUser({
    required String userId,
    required Map<String, dynamic> userData,
  }) async {
    try {
      await _database.ref().child('users/$userId').set({
        ...userData,
        'createdAt': ServerValue.timestamp,
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get User ──
  Future<Map<String, dynamic>> getUser(String userId) async {
    try {
      final snapshot =
      await _database.ref().child('users/$userId').once();
      if (snapshot.snapshot.value == null) {
        throw const DataNotFoundException();
      }
      final user =
      Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      user['id'] = userId;
      return user;
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
      await _database.ref().child('users/$userId').update({
        ...userData,
        'updatedAt': ServerValue.timestamp,
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
      final ref = _database
          .ref()
          .child('users/$userId/addresses')
          .push();
      await ref.set(address);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get Addresses ──
  Future<List<Map<String, dynamic>>> getAddresses(
      String userId) async {
    try {
      final snapshot = await _database
          .ref()
          .child('users/$userId/addresses')
          .once();
      if (snapshot.snapshot.value == null) return [];

      final data =
      Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      return data.entries.map((e) {
        final address =
        Map<String, dynamic>.from(e.value as Map);
        address['id'] = e.key;
        return address;
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Remove Address ──
  Future<void> removeAddress({
    required String userId,
    required String addressId,
  }) async {
    try {
      await _database
          .ref()
          .child('users/$userId/addresses/$addressId')
          .remove();
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
      await _database.ref().child('users/$userId').update({
        'fcmToken': token,
      });
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
      final ref = _database
          .ref()
          .child('reviews/$restaurantId')
          .push();
      await ref.set({
        ...review,
        'createdAt': ServerValue.timestamp,
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get Reviews ──
  Future<List<Map<String, dynamic>>> getReviews(
      String restaurantId) async {
    try {
      final snapshot = await _database
          .ref()
          .child('reviews/$restaurantId')
          .once();
      if (snapshot.snapshot.value == null) return [];

      final data =
      Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      return data.entries.map((e) {
        final review =
        Map<String, dynamic>.from(e.value as Map);
        review['id'] = e.key;
        return review;
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}