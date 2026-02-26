import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mobscan/models/app_model.dart';
part 'apps_state.dart';

class AppsCubit extends Cubit<AppsState> {
  AppsCubit() : super(AppsState.initial());
  int categoryIndex = 0;
  List<AppModel> apps = AppModel.apps;
  List<AppModel> get safeApps =>
      state.allApps.where((app) => app.riskLevel <= 50).toList();
  List<AppModel> get riskyApps =>
      state.allApps.where((app) => app.riskLevel > 50).toList();

  void getApps() {
    emit(state.copyWith(status: AppStatus.loading));
    if (apps.isEmpty) {
      emit(state.copyWith(status: AppStatus.failed, allApps: []));
      return;
    }
    emit(state.copyWith(status: AppStatus.success, allApps: apps));
  }

  void changeCategory(int index) {
    categoryIndex = index;
    emit(state.copyWith(selectedCategoryIndex: index));
  }

  void navigateToNextPage(int index) {
    categoryIndex = index;
    emit(state.copyWith(selectedCategoryIndex: index));
  }

  void search(String appname) {
    if (appname.isEmpty) {
      emit(state.copyWith(allApps: apps));
      return;
    }
    final results = apps
        .where(
          (item) =>
              item.name.toLowerCase().contains(appname.trim().toLowerCase()),
        )
        .toList();
    if (results.isEmpty) {
      emit(state.copyWith(allApps: []));
    } else {
      emit(state.copyWith(allApps: results));
    }
  }
}
