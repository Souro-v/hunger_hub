class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatarUrl;
  final String restaurantId;
  final double rating;
  final String comment;
  final DateTime? createdAt;

  const ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatarUrl,
    required this.restaurantId,
    required this.rating,
    required this.comment,
    this.createdAt,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      userAvatarUrl: map['userAvatarUrl'],
      restaurantId: map['restaurantId'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      comment: map['comment'] ?? '',
      createdAt: map['createdAt']?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatarUrl': userAvatarUrl,
      'restaurantId': restaurantId,
      'rating': rating,
      'comment': comment,
    };
  }
}