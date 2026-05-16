import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/exceptions.dart';
import '../../data/models/cart_model.dart';
import '../../data/repositories/order_repository.dart';
import 'order_event.dart';
import 'order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final OrderRepository _orderRepository;

  OrderBloc({required OrderRepository orderRepository})
      : _orderRepository = orderRepository,
        super(OrderInitial()) {
    on<PlaceOrderEvent>(_onPlaceOrder);
    on<FetchOrdersEvent>(_onFetchOrders);
    on<FetchOrderByIdEvent>(_onFetchOrderById);
    on<TrackOrderEvent>(_onTrackOrder);
    on<CancelOrderEvent>(_onCancelOrder);
    on<UpdateOrderStatusEvent>(_onUpdateOrderStatus);
  }

  // ── Place Order ──
  Future<void> _onPlaceOrder(
      PlaceOrderEvent event,
      Emitter<OrderState> emit,
      ) async {
    emit(OrderLoading());
    try {
      final cart = CartModel(
        restaurantId: event.restaurantId,
        restaurantName: event.restaurantName,
        items: [],
      );

      final orderId = await _orderRepository.placeOrder(
        userId: event.userId,
        restaurantId: event.restaurantId,
        restaurantName: event.restaurantName,
        cart: cart,
        deliveryAddress: {'address': event.deliveryAddress},
        paymentMethod: event.paymentMethod,
      );

      emit(OrderPlaced(orderId: orderId));
    } on ServerException catch (e) {
      emit(OrderError(message: e.message));
    } catch (e) {
      emit(OrderError(message: 'Something went wrong'));
    }
  }

  // ── Fetch Orders ──
  Future<void> _onFetchOrders(
      FetchOrdersEvent event,
      Emitter<OrderState> emit,
      ) async {
    emit(OrderLoading());
    try {
      final orders =
      await _orderRepository.getOrdersByUser(event.userId);
      if (orders.isEmpty) {
        emit(OrderEmpty());
      } else {
        emit(OrdersLoaded(orders: orders));
      }
    } on ServerException catch (e) {
      emit(OrderError(message: e.message));
    } catch (e) {
      emit(OrderError(message: 'Something went wrong'));
    }
  }

  // ── Fetch Order By Id ──
  Future<void> _onFetchOrderById(
      FetchOrderByIdEvent event,
      Emitter<OrderState> emit,
      ) async {
    emit(OrderLoading());
    try {
      final order =
      await _orderRepository.getOrderById(event.orderId);
      emit(OrderDetailLoaded(order: order));
    } on DataNotFoundException {
      emit(OrderError(message: 'Order not found'));
    } on ServerException catch (e) {
      emit(OrderError(message: e.message));
    } catch (e) {
      emit(OrderError(message: 'Something went wrong'));
    }
  }

  // ── Track Order ──
  Future<void> _onTrackOrder(
      TrackOrderEvent event,
      Emitter<OrderState> emit,
      ) async {
    emit(OrderLoading());
    try {
      await emit.forEach(
        _orderRepository.trackOrder(event.orderId),
        onData: (order) => OrderTracking(order: order),
        onError: (error, _) =>
            OrderError(message: 'Tracking failed'),
      );
    } catch (e) {
      emit(OrderError(message: 'Something went wrong'));
    }
  }

  // ── Cancel Order ──
  Future<void> _onCancelOrder(
      CancelOrderEvent event,
      Emitter<OrderState> emit,
      ) async {
    emit(OrderLoading());
    try {
      await _orderRepository.cancelOrder(event.orderId);
      emit(OrderCancelled());
    } on ServerException catch (e) {
      emit(OrderError(message: e.message));
    } catch (e) {
      emit(OrderError(message: 'Something went wrong'));
    }
  }

  // ── Update Order Status ──
  Future<void> _onUpdateOrderStatus(
      UpdateOrderStatusEvent event,
      Emitter<OrderState> emit,
      ) async {
    emit(OrderLoading());
    try {
      await _orderRepository.updateOrderStatus(
        orderId: event.orderId,
        status: event.status,
      );
      emit(OrderStatusUpdated());
    } on ServerException catch (e) {
      emit(OrderError(message: e.message));
    } catch (e) {
      emit(OrderError(message: 'Something went wrong'));
    }
  }
}