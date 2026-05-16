import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/error/exceptions.dart';
import '../../core/storage/local_storage.dart';
import '../../data/models/review_model.dart';
import '../../data/repositories/user_repository.dart';

abstract class RatingState {}

class RatingInitial extends RatingState {}
class RatingLoading extends RatingState {}
class RatingSuccess extends RatingState {}
class RatingError extends RatingState {
  final String message;
  RatingError({required this.message});
}

class RatingCubit extends Cubit<RatingState> {
  final UserRepository _userRepository;
  final LocalStorage _localStorage;

  RatingCubit({
    required UserRepository userRepository,
    required LocalStorage localStorage,
  })  : _userRepository = userRepository,
        _localStorage = localStorage,
        super(RatingInitial());

  // ── Submit Review ──
  Future<void> submitReview({
    required String restaurantId,
    required double rating,
    required String comment,
    required String userName,
  }) async {
    emit(RatingLoading());
    try {
      final userId = _localStorage.getUserId() ?? '';

      final review = ReviewModel(
        id: '',
        userId: userId,
        userName: userName,
        restaurantId: restaurantId,
        rating: rating,
        comment: comment,
      );

      await _userRepository.addReview(
        restaurantId: restaurantId,
        review: review,
      );

      emit(RatingSuccess());
    } on ServerException catch (e) {
      emit(RatingError(message: e.message));
    } catch (e) {
      emit(RatingError(message: 'Something went wrong'));
    }
  }
}