part of 'index_cubit.dart';

@immutable
sealed class IndexState {}

final class IndexInitial extends IndexState {
  final int index;
  IndexInitial({required this.index});
}
