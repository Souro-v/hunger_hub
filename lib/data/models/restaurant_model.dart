class RestaurantModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String category;
  final double rating;
  final int totalReviews;
  final String address;
  final double deliveryFee;
  final int deliveryTime;
  final double minimumOrder;
  final bool isOpen;
  final List<String> tags;
  final DateTime? createdAt;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    required this.rating,
    required this.totalReviews,
    required this.address,
    required this.deliveryFee,
    required this.deliveryTime,
    required this.minimumOrder,
    required this.isOpen,
    this.tags = const [],
    this.createdAt,
  });

  // ── From Firestore ──
  factory RestaurantModel.fromMap(Map<String, dynamic> map) {
    return RestaurantModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      category: map['category'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      totalReviews: map['totalReviews'] ?? 0,
      address: map['address'] ?? '',
      deliveryFee: (map['deliveryFee'] ?? 0.0).toDouble(),
      deliveryTime: map['deliveryTime'] ?? 0,
      minimumOrder: (map['minimumOrder'] ?? 0.0).toDouble(),
      isOpen: map['isOpen'] ?? false,
      tags: List<String>.from(map['tags'] ?? []),
      createdAt: map['createdAt']?.toDate(),
    );
  }

  // ── To Firestore ──
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'category': category,
      'rating': rating,
      'totalReviews': totalReviews,
      'address': address,
      'deliveryFee': deliveryFee,
      'deliveryTime': deliveryTime,
      'minimumOrder': minimumOrder,
      'isOpen': isOpen,
      'tags': tags,
    };
  }

  // ── CopyWith ──
  RestaurantModel copyWith({
    String? id,
    String? name,
    String? description,
    String? imageUrl,
    String? category,
    double? rating,
    int? totalReviews,
    String? address,
    double? deliveryFee,
    int? deliveryTime,
    double? minimumOrder,
    bool? isOpen,
    List<String>? tags,
    DateTime? createdAt,
  }) {
    return RestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      rating: rating ?? this.rating,
      totalReviews: totalReviews ?? this.totalReviews,
      address: address ?? this.address,
      deliveryFee: deliveryFee ?? this.deliveryFee,
      deliveryTime: deliveryTime ?? this.deliveryTime,
      minimumOrder: minimumOrder ?? this.minimumOrder,
      isOpen: isOpen ?? this.isOpen,
      tags: tags ?? this.tags,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}