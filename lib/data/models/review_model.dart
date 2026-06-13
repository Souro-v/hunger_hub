class ReviewModel {
  final String id;
  final String userId;
  final String userName;
  final String restaurantId;
  final double rating;
  final String comment;

  const ReviewModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.restaurantId,
    required this.rating,
    required this.comment,
  });

  factory ReviewModel.fromMap(Map<String, dynamic> map) {
    return ReviewModel(
      id: map['id'] ?? '',
      userId: map['userId'] ?? '',
      userName: map['userName'] ?? '',
      restaurantId: map['restaurantId'] ?? '',
      rating: (map['rating'] ?? 0.0).toDouble(),
      comment: map['comment'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'restaurantId': restaurantId,
      'rating': rating,
      'comment': comment,
    };
  }
}