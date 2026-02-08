import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant/features/auth/data/repositories/user_repo.dart';

part 'user_name_state.dart';

class UserNameCubit extends Cubit<UserNameState> {
  UserNameCubit(this.userRepo) : super(UserNameInitial());
  final UserRepository userRepo;
  Future<void> loadUserName(String uid) async {
    emit(UserNameLoading());
    try {
      final name = await userRepo.getUserName(uid);
      emit(UserNameLoaded(name: name));
    } catch (e) {
      emit(UserNameError(error: e.toString()));
    }
  }

  void updateUserName(String name) {
    emit(UserNameLoaded(name: name));
  }
}
