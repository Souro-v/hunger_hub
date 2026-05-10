class CategoryModel {
  final String id;
  final String name;
  final String iconUrl;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.iconUrl,
  });

  // ── From Firestore ──
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      iconUrl: map['iconUrl'] ?? '',
    );
  }

  // ── To Firestore ──
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'iconUrl': iconUrl,
    };
  }

  // ── CopyWith ──
  CategoryModel copyWith({
    String? id,
    String? name,
    String? iconUrl,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      iconUrl: iconUrl ?? this.iconUrl,
    );
  }
}