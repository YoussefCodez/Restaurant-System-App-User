import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


class ObscureCubit extends Cubit<bool> {
  ObscureCubit() : super(true);
  void toggleVisibility() {
    emit(!state);
  }
}
