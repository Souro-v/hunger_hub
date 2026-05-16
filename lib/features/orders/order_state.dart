import '../../data/models/order_model.dart';

abstract class OrderState {}

// ── Initial ──
class OrderInitial extends OrderState {}

// ── Loading ──
class OrderLoading extends OrderState {}

// ── Order Placed ──
class OrderPlaced extends OrderState {
  final String orderId;
  OrderPlaced({required this.orderId});
}

// ── Orders Loaded ──
class OrdersLoaded extends OrderState {
  final List<OrderModel> orders;
  OrdersLoaded({required this.orders});
}

// ── Order Detail Loaded ──
class OrderDetailLoaded extends OrderState {
  final OrderModel order;
  OrderDetailLoaded({required this.order});
}

// ── Order Tracking ──
class OrderTracking extends OrderState {
  final OrderModel order;
  OrderTracking({required this.order});
}

// ── Order Cancelled ──
class OrderCancelled extends OrderState {}

// ── Order Status Updated ──
class OrderStatusUpdated extends OrderState {}

// ── Error ──
class OrderError extends OrderState {
  final String message;
  OrderError({required this.message});
}

// ── Empty ──
class OrderEmpty extends OrderState {}