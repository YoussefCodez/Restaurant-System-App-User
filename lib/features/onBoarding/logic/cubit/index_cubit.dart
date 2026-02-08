import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'index_state.dart';

class IndexCubit extends Cubit<IndexState> {
  IndexCubit() : super(IndexInitial(index: 0));
  void nextPage(int maxIndex) {
    if (state is IndexInitial) {
      final int current = (state as IndexInitial).index;
      if (current < maxIndex - 1) {
        emit(IndexInitial(index: current + 1));
      }
    }
  }
}
