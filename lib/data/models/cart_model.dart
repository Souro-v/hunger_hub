import 'food_item_model.dart';

class CartItemModel {
  final FoodItemModel foodItem;
  final int quantity;

  const CartItemModel({
    required this.foodItem,
    required this.quantity,
  });

  // ── Total Price ──
  double get totalPrice => foodItem.price * quantity;

  // ── From Map ──
  factory CartItemModel.fromMap(Map<String, dynamic> map) {
    return CartItemModel(
      foodItem: FoodItemModel.fromMap(map['foodItem']),
      quantity: map['quantity'] ?? 1,
    );
  }

  // ── To Map ──
  Map<String, dynamic> toMap() {
    return {
      'foodItem': foodItem.toMap(),
      'quantity': quantity,
    };
  }

  // ── CopyWith ──
  CartItemModel copyWith({
    FoodItemModel? foodItem,
    int? quantity,
  }) {
    return CartItemModel(
      foodItem: foodItem ?? this.foodItem,
      quantity: quantity ?? this.quantity,
    );
  }
}

class CartModel {
  final String restaurantId;
  final String restaurantName;
  final List<CartItemModel> items;
  final String? promoCode;
  final double discount;

  const CartModel({
    required this.restaurantId,
    required this.restaurantName,
    required this.items,
    this.promoCode,
    this.discount = 0.0,
  });

  // ── Subtotal ──
  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  // ── Total ──
  double get total => subtotal - discount;

  // ── Total Items ──
  int get totalItems =>
      items.fold(0, (sum, item) => sum + item.quantity);

  // ── Is Empty ──
  bool get isEmpty => items.isEmpty;

  // ── From Map ──
  factory CartModel.fromMap(Map<String, dynamic> map) {
    return CartModel(
      restaurantId: map['restaurantId'] ?? '',
      restaurantName: map['restaurantName'] ?? '',
      items: (map['items'] as List<dynamic>?)
          ?.map((item) => CartItemModel.fromMap(item))
          .toList() ??
          [],
      promoCode: map['promoCode'],
      discount: (map['discount'] ?? 0.0).toDouble(),
    );
  }

  // ── To Map ──
  Map<String, dynamic> toMap() {
    return {
      'restaurantId': restaurantId,
      'restaurantName': restaurantName,
      'items': items.map((item) => item.toMap()).toList(),
      'promoCode': promoCode,
      'discount': discount,
    };
  }

  // ── CopyWith ──
  CartModel copyWith({
    String? restaurantId,
    String? restaurantName,
    List<CartItemModel>? items,
    String? promoCode,
    double? discount,
  }) {
    return CartModel(
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantName: restaurantName ?? this.restaurantName,
      items: items ?? this.items,
      promoCode: promoCode ?? this.promoCode,
      discount: discount ?? this.discount,
    );
  }
}