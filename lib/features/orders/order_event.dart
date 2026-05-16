abstract class OrderEvent {}

// ── Place Order ──
class PlaceOrderEvent extends OrderEvent {
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final String deliveryAddress;
  final String paymentMethod;

  PlaceOrderEvent({
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.deliveryAddress,
    required this.paymentMethod,
  });
}

// ── Fetch Orders ──
class FetchOrdersEvent extends OrderEvent {
  final String userId;
  FetchOrdersEvent({required this.userId});
}

// ── Fetch Order By Id ──
class FetchOrderByIdEvent extends OrderEvent {
  final String orderId;
  FetchOrderByIdEvent({required this.orderId});
}

// ── Track Order ──
class TrackOrderEvent extends OrderEvent {
  final String orderId;
  TrackOrderEvent({required this.orderId});
}

// ── Cancel Order ──
class CancelOrderEvent extends OrderEvent {
  final String orderId;
  CancelOrderEvent({required this.orderId});
}

// ── Update Order Status ──
class UpdateOrderStatusEvent extends OrderEvent {
  final String orderId;
  final String status;

  UpdateOrderStatusEvent({
    required this.orderId,
    required this.status,
  });
}