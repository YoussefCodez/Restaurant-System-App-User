import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant/features/home/data/models/menu_model.dart';
import 'package:restaurant/features/home/data/repositories/menu_repo.dart';

part 'menu_state.dart';

class MenuCubit extends Cubit<MenuState> {
  final MenuRepo repo;
  StreamSubscription? _subscription;
  List<MenuModel>? cachedMenu;
  String? _currentCategoryId;

  MenuCubit(this.repo) : super(MenuInitial());

  void loadMenu() {
    _currentCategoryId = null; // Reset filter when loading all
    if (state is MenuLoading && cachedMenu != null) return;

    emit(MenuLoading());
    _subscription?.cancel();
    _subscription = repo.getMenu().listen(
      (menu) {
        cachedMenu = menu;
        _applyCurrentFilter();
      },
      onError: (e) {
        emit(MenuError(message: e.toString()));
      },
    );
  }

  void _applyCurrentFilter() {
    if (cachedMenu == null) return;

    if (_currentCategoryId == null) {
      emit(MenuSuccess(menu: cachedMenu!));
    } else {
      final filteredMenu = cachedMenu!
          .where(
            (element) =>
                element.categoryId.toLowerCase() ==
                _currentCategoryId!.toLowerCase(),
          )
          .toList();
      emit(MenuSuccess(menu: filteredMenu));
    }
  }

  void loadMenuByCategory(String categoryId) {
    _currentCategoryId = categoryId;
    if (cachedMenu != null) {
      _applyCurrentFilter();
    } else {
      // If we don't have the menu yet, load it and the listener will apply the filter
      loadMenu();
    }
  }

  void loadMenuByDiscount() {
    _currentCategoryId = null; // Reset category filter for discount view
    if (cachedMenu != null) {
      emit(MenuLoading());
      final filteredMenu = cachedMenu!
          .where((element) => element.hasDiscount)
          .toList();
      emit(MenuSuccess(menu: filteredMenu));
    } else {
      emit(MenuLoading());
      _subscription?.cancel();
      _subscription = repo.getMenu().listen((menu) {
        cachedMenu = menu;
        final filteredMenu = menu
            .where((element) => element.hasDiscount)
            .toList();
        emit(MenuSuccess(menu: filteredMenu));
      }, onError: (e) => emit(MenuError(message: e.toString())));
    }
  }

  void loadMenuBySearch(String search) {
    _currentCategoryId = null; // Search usually works over the whole menu
    if (cachedMenu != null) {
      emit(MenuLoading());
      if (search.isEmpty) {
        emit(MenuSuccess(menu: cachedMenu!));
        return;
      }
      final filteredMenu = cachedMenu!
          .where(
            (element) =>
                element.name.toLowerCase().contains(search.toLowerCase()),
          )
          .toList();
      emit(MenuSuccess(menu: filteredMenu));
    } else {
      emit(MenuLoading());
      _subscription?.cancel();
      _subscription = repo.getMenu().listen((menu) {
        cachedMenu = menu;
        if (search.isEmpty) {
          emit(MenuSuccess(menu: menu));
        } else {
          final filteredMenu = menu
              .where(
                (element) =>
                    element.name.toLowerCase().contains(search.toLowerCase()),
              )
              .toList();
          emit(MenuSuccess(menu: filteredMenu));
        }
      }, onError: (e) => emit(MenuError(message: e.toString())));
    }
  }

  void loadMenuExcept(String categoryId, String id) {
    // This is usually for recommendations, won't set global category filter
    if (cachedMenu != null) {
      emit(MenuLoading());
      final filteredMenu = cachedMenu!
          .where(
            (element) =>
                element.categoryId.toLowerCase() == categoryId.toLowerCase(),
          )
          .where((element) => element.id != id)
          .toList();
      emit(MenuSuccess(menu: filteredMenu));
    } else {
      emit(MenuLoading());
      _subscription?.cancel();
      _subscription = repo.getMenu().listen((menu) {
        cachedMenu = menu;
        final filteredMenu = menu
            .where(
              (element) =>
                  element.categoryId.toLowerCase() == categoryId.toLowerCase(),
            )
            .where((element) => element.id != id)
            .toList();
        emit(MenuSuccess(menu: filteredMenu));
      }, onError: (e) => emit(MenuError(message: e.toString())));
    }
  }

  void refreshMenu() {
    loadMenu();
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
