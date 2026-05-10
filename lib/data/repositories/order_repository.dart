import '../../core/error/exceptions.dart';
import '../../firebase/firestore/order_service.dart';
import '../models/cart_model.dart';
import '../models/order_model.dart';

class OrderRepository {
  final OrderService _orderService;

  OrderRepository({required OrderService orderService})
      : _orderService = orderService;

  // ── Place Order ──
  Future<String> placeOrder({
    required String userId,
    required String restaurantId,
    required String restaurantName,
    required CartModel cart,
    required Map<String, dynamic> deliveryAddress,
    required String paymentMethod,
  }) async {
    try {
      final orderData = {
        'userId': userId,
        'restaurantId': restaurantId,
        'restaurantName': restaurantName,
        'items': cart.items.map((item) => item.toMap()).toList(),
        'subtotal': cart.subtotal,
        'deliveryFee': 50.0,
        'discount': cart.discount,
        'total': cart.total + 50.0,
        'deliveryAddress': deliveryAddress,
        'paymentMethod': paymentMethod,
        'promoCode': cart.promoCode,
      };
      return await _orderService.placeOrder(orderData);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get Order By Id ──
  Future<OrderModel> getOrderById(String orderId) async {
    try {
      final data = await _orderService.getOrderById(orderId);
      return OrderModel.fromMap(data);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Get Orders By User ──
  Future<List<OrderModel>> getOrdersByUser(String userId) async {
    try {
      final data = await _orderService.getOrdersByUser(userId);
      return data.map((map) => OrderModel.fromMap(map)).toList();
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Track Order (Realtime) ──
  Stream<OrderModel> trackOrder(String orderId) {
    return _orderService.trackOrder(orderId).map(
          (data) => OrderModel.fromMap(data),
    );
  }

  // ── Update Order Status ──
  Future<void> updateOrderStatus({
    required String orderId,
    required String status,
  }) async {
    try {
      await _orderService.updateOrderStatus(
        orderId: orderId,
        status: status,
      );
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  // ── Cancel Order ──
  Future<void> cancelOrder(String orderId) async {
    try {
      await _orderService.cancelOrder(orderId);
    } on AppException {
      rethrow;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}