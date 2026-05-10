import 'package:flutter_bloc/flutter_bloc.dart';

class OnboardingCubit extends Cubit<int> {
  OnboardingCubit() : super(0);

  void nextPage() {
    if (state < 3) emit(state + 1);
  }

  void skipTo(int index) => emit(index);
}