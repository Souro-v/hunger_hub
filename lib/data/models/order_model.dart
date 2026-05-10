import '../../core/constants/app_constants.dart';
import 'cart_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final List<CartItemModel> items;
  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;
  final String status;
  final Map<String, dynamic> deliveryAddress;
  final String paymentMethod;
  final String? promoCode;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.status,
    required this.deliveryAddress,
    required this.paymentMethod,
    this.promoCode,
    this.createdAt,
    this.updatedAt,
  });

  // ── Status Helpers ──
  bool get isPending => status == AppConstants.orderPending;
  bool get isConfirmed => status == AppConstants.orderConfirmed;
  bool get isPreparing => status == AppConstants.orderPreparing;
  bool get isOnTheWay => status == AppConstants.orderOnTheWay;
  bool get isDelivered => status == AppConstants.orderDelivered;
  bool get isCancelled => status == AppConstants.orderCancelled;

  // ── Total Items ──
  int get totalItems =>
      items.fold(0, (sum, item) => sum + item.quantity);

  // ── From Firestore ──
  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      restaurantId: map['restaurantId'] ?? '',
      restaurantName: map['restaurantName'] ?? '',
      items: (map['items'] as List<dynamic>?)
          ?.map((item) => CartItemModel.fromMap(item))
          .toList() ??
          [],
      subtotal: (map['subtotal'] ?? 0.0).toDouble(),
      deliveryFee: (map['deliveryFee'] ?? 0.0).toDouble(),
      discount: (map['discount'] ?? 0.0).toDouble(),
      total: (map['total'] ?? 0.0).toDouble(),
      status: map['status'] ?? AppConstants.orderPending,
      deliveryAddress:
      Map<String, dynamic>.from(map['deliveryAddress'] ?? {}),
      paymentMethod: map['paymentMethod'] ?? '',
      promoCode: map['promoCode'],
      createdAt: map['createdAt']?.toDate(),
      updatedAt: map['updatedAt']?.toDate(),
    );
  }

  // ── To Firestore ──
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'deliveryFee': deliveryFee,
      'discount': discount,
      'total': total,
      'status': status,
      'deliveryAddress': deliveryAddress,
      'paymentMethod': paymentMethod,
      'promoCode': promoCode,
    };
  }

  // ── CopyWith ──
  OrderModel copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    String? restaurantName,
    List<CartItemModel>? items,
    double? subtotal,
    double? deliveryFee,
    double? discount,
    double? total,
    String? status,
    Map<String, dynamic>? deliveryAddress,
    String? paymentMethod,
    String? promoCode,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return OrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      discount: discount ?? this.discount,
      total: total ?? this.total,
      status: status ?? this.status,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      promoCode: promoCode ?? this.promoCode,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}