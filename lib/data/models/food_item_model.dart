class FoodItemModel {
  final String id;
  final String restaurantId;
  final String name;
  final String description;
  final String imageUrl;
  final double price;
  final String category;
  final bool isAvailable;
  final bool isPopular;
  final List<String> ingredients;
  final DateTime? createdAt;

  const FoodItemModel({
    required this.id,
    required this.restaurantId,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.category,
    required this.isAvailable,
    this.isPopular = false,
    this.ingredients = const [],
    this.createdAt,
  });

  // ── From Firestore ──
  factory FoodItemModel.fromMap(Map<String, dynamic> map) {
    return FoodItemModel(
      id: map['id'] ?? '',
      restaurantId: map['restaurantId'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      category: map['category'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      isPopular: map['isPopular'] ?? false,
      ingredients: List<String>.from(map['ingredients'] ?? []),
      createdAt: map['createdAt']?.toDate(),
    );
  }

  // ── To Firestore ──
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'restaurantId': restaurantId,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'price': price,
      'category': category,
      'isAvailable': isAvailable,
      'isPopular': isPopular,
      'ingredients': ingredients,
    };
  }

  // ── CopyWith ──
  FoodItemModel copyWith({
    String? id,
    String? restaurantId,
    String? name,
    String? description,
    String? imageUrl,
    double? price,
    String? category,
    bool? isAvailable,
    bool? isPopular,
    List<String>? ingredients,
    DateTime? createdAt,
  }) {
    return FoodItemModel(
      id: id ?? this.id,
      restaurantId: restaurantId ?? this.restaurantId,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      isPopular: isPopular ?? this.isPopular,
      ingredients: ingredients ?? this.ingredients,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}