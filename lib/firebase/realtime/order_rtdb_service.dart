import 'package:firebase_database/firebase_database.dart';
import '../../core/constants/app_constants.dart';
import '../../core/error/exceptions.dart';

class OrderRtdbService {
  final FirebaseDatabase _database = FirebaseDatabase.instance;

  // ── Place Order ──
  Future<String> placeOrder(Map<String, dynamic> orderData) async {
    try {
      final ref = _database.ref().child('orders').push();
      await ref.set({
        ...orderData,
        'createdAt': ServerValue.timestamp,
        'status': AppConstants.orderPending,
      });
      return ref.key!;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get Order By Id ──
  Future<Map<String, dynamic>> getOrderById(String orderId) async {
    try {
      final snapshot = await _database.ref().child('orders/$orderId').once();
      if (snapshot.snapshot.value == null) {
        throw const DataNotFoundException();
      }
      final order = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      order['id'] = orderId;
      return order;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get Orders By User ──
  Future<List<Map<String, dynamic>>> getOrdersByUser(String userId) async {
    try {
      final snapshot = await _database
          .ref()
          .child('orders')
          .orderByChild('userId')
          .equalTo(userId)
          .once();
      if (snapshot.snapshot.value == null) return [];

      final data = Map<String, dynamic>.from(snapshot.snapshot.value as Map);
      final orders = data.entries.map((e) {
        final order = Map<String, dynamic>.from(e.value as Map);
        order['id'] = e.key;
        return order;
      }).toList();

      // ── Sort by createdAt descending ──
      orders.sort((a, b) {
        final aTime = a['createdAt'] ?? 0;
        final bTime = b['createdAt'] ?? 0;
        return bTime.compareTo(aTime);
      });

      return orders;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Track Order (Realtime) ──
  Stream<Map<String, dynamic>> trackOrder(String orderId) {
    return _database.ref().child('orders/$orderId').onValue.map((event) {
      if (event.snapshot.value == null) {
        throw const DataNotFoundException();
      }
      final order = Map<String, dynamic>.from(event.snapshot.value as Map);
      order['id'] = orderId;
      return order;
    });
  }

  // ── Update Order Status ──
  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      await _database.ref().child('orders/$orderId').update({
        'status': status,
        'updatedAt': ServerValue.timestamp,
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Cancel Order ──
  Future<void> cancelOrder(String orderId) async {
    try {
      await _database.ref().child('orders/$orderId').update({
        'status': AppConstants.orderCancelled,
        'updatedAt': ServerValue.timestamp,
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
