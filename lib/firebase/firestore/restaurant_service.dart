import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';
import '../../core/error/exceptions.dart';

class RestaurantService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── Get All Restaurants ──
  Future<List<Map<String, dynamic>>> getAllRestaurants() async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.restaurantsCollection)
          .get();
      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get Restaurant By Id ──
  Future<Map<String, dynamic>> getRestaurantById(String id) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.restaurantsCollection)
          .doc(id)
          .get();
      if (!doc.exists) throw const DataNotFoundException();
      return {'id': doc.id, ...doc.data()!};
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get Restaurants By Category ──
  Future<List<Map<String, dynamic>>> getRestaurantsByCategory(
      String category) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.restaurantsCollection)
          .where('category', isEqualTo: category)
          .get();
      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get Food Items By Restaurant ──
  Future<List<Map<String, dynamic>>> getFoodItemsByRestaurant(
      String restaurantId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.restaurantsCollection)
          .doc(restaurantId)
          .collection(AppConstants.foodItemsCollection)
          .get();
      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get Categories ──
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.categoriesCollection)
          .get();
      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Search Restaurants ──
  Future<List<Map<String, dynamic>>> searchRestaurants(String query) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.restaurantsCollection)
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThanOrEqualTo: '$query\uf8ff')
          .get();
      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}