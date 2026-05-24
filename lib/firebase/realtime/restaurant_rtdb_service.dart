import 'package:firebase_database/firebase_database.dart';
import '../../core/error/exceptions.dart';

class RestaurantRtdbService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // ── Get All Restaurants ──
  Future<List<Map<String, dynamic>>> getAllRestaurants() async {
    try {
      final snapshot =
      await _database.ref().child('restaurants').once();
      if (snapshot.snapshot.value == null) return [];

      final data =
      Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      return data.entries.map((e) {
        final rest = Map<String, dynamic>.from(e.value as Map);
        rest['id'] = e.key;
        return rest;
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get Restaurant By Id ──
  Future<Map<String, dynamic>> getRestaurantById(String id) async {
    try {
      final snapshot =
      await _database.ref().child('restaurants/$id').once();
      if (snapshot.snapshot.value == null) {
        throw const DataNotFoundException();
      }
      final rest =
      Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      rest['id'] = id;
      return rest;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get Restaurants By Category ──
  Future<List<Map<String, dynamic>>> getRestaurantsByCategory(
      String category) async {
    try {
      final snapshot = await _database
          .ref()
          .child('restaurants')
          .orderByChild('category')
          .equalTo(category)
          .once();
      if (snapshot.snapshot.value == null) return [];

      final data =
      Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      return data.entries.map((e) {
        final rest = Map<String, dynamic>.from(e.value as Map);
        rest['id'] = e.key;
        return rest;
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get Food Items By Restaurant ──
  Future<List<Map<String, dynamic>>> getFoodItemsByRestaurant(
      String restaurantId) async {
    try {
      final snapshot = await _database
          .ref()
          .child('foodItems/$restaurantId')
          .once();
      if (snapshot.snapshot.value == null) return [];

      final data =
      Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      return data.entries.map((e) {
        final food = Map<String, dynamic>.from(e.value as Map);
        food['id'] = e.key;
        return food;
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get Categories ──
  Future<List<Map<String, dynamic>>> getCategories() async {
    try {
      final snapshot =
      await _database.ref().child('categories').once();
      if (snapshot.snapshot.value == null) return [];

      final data =
      Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      return data.entries.map((e) {
        final cat = Map<String, dynamic>.from(e.value as Map);
        cat['id'] = e.key;
        return cat;
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Search Restaurants ──
  Future<List<Map<String, dynamic>>> searchRestaurants(
      String query) async {
    try {
      final snapshot =
      await _database.ref().child('restaurants').once();
      if (snapshot.snapshot.value == null) return [];

      final data =
      Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      return data.entries
          .where((e) {
        final rest = Map<String, dynamic>.from(e.value as Map);
        return rest['name']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase());
      })
          .map((e) {
        final rest = Map<String, dynamic>.from(e.value as Map);
        rest['id'] = e.key;
        return rest;
      })
          .toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}