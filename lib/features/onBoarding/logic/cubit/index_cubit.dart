import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'index_state.dart';

class IndexCubit extends Cubit<IndexState> {
  IndexCubit() : super(IndexInitial(index: 0));
  void nextPage(int maxIndex) {
    final int current = (state as IndexInitial).index;
    if (current < maxIndex) {
      emit(IndexInitial(index: current + 1));
    } 
  }
}
