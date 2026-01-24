import 'package:bloc/bloc.dart';
import 'package:restaurant/core/services/shared_prefs/shared_prefs.dart';

class RememberMeStatusCubit extends Cubit<bool> {
  RememberMeStatusCubit() : super(false) {
    loadRememberMe();
  }

  void loadRememberMe() {
    final bool status = SharedPrefs.getRememberMeStatus();
    emit(status);
  }

  void saveOnBoardingStatus() {
    emit(!state);
    SharedPrefs.saveRememberMeStatus(state);
  }
}
