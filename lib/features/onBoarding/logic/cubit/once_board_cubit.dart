import 'package:bloc/bloc.dart';
import 'package:restaurant/core/services/shared_prefs/shared_prefs.dart';

class OnceBoardCubit extends Cubit<bool> {
  OnceBoardCubit() : super(false) {
    _loadOnBoardingStatus();
  }

  void _loadOnBoardingStatus() {
    final bool status = SharedPrefs.getOnBoardingStatus();
    emit(status);
  }

  void finishOnBoarding() {
    SharedPrefs.saveOnBoardingStatus(true);
    emit(true);
  }
}
