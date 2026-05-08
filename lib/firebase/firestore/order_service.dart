import 'package:cloud_firestore/cloud_firestore.dart';
import '../../core/constants/app_constants.dart';
import '../../core/error/exceptions.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ── Place Order ──
  Future<String> placeOrder(Map<String, dynamic> orderData) async {
    try {
      final docRef = await _firestore
          .collection(AppConstants.ordersCollection)
          .add({
        ...orderData,
        'createdAt': FieldValue.serverTimestamp(),
        'status': AppConstants.orderPending,
      });
      return docRef.id;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get Order By Id ──
  Future<Map<String, dynamic>> getOrderById(String orderId) async {
    try {
      final doc = await _firestore
          .collection(AppConstants.ordersCollection)
          .doc(orderId)
          .get();
      if (!doc.exists) throw const DataNotFoundException();
      return {'id': doc.id, ...doc.data()!};
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get Orders By User ──
  Future<List<Map<String, dynamic>>> getOrdersByUser(String userId) async {
    try {
      final snapshot = await _firestore
          .collection(AppConstants.ordersCollection)
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snapshot.docs.map((doc) {
        return {'id': doc.id, ...doc.data()};
      }).toList();
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Track Order (Realtime) ──
  Stream<Map<String, dynamic>> trackOrder(String orderId) {
    return _firestore
        .collection(AppConstants.ordersCollection)
        .doc(orderId)
        .snapshots()
        .map((doc) {
      if (!doc.exists) throw const DataNotFoundException();
      return {'id': doc.id, ...doc.data()!};
    });
  }

  // ── Update Order Status ──
  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      await _firestore
          .collection(AppConstants.ordersCollection)
          .doc(orderId)
          .update({
        'status': status,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Cancel Order ──
  Future<void> cancelOrder(String orderId) async {
    try {
      await _firestore
          .collection(AppConstants.ordersCollection)
          .doc(orderId)
          .update({
        'status': AppConstants.orderCancelled,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}