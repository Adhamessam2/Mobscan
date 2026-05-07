import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:mobscan/models/app_model.dart';
import 'package:mobscan/services/app_scanner_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'apps_state.dart';

class AppsCubit extends Cubit<AppsState> {
  final AppScannerService _scannerService;

  AppsCubit(this._scannerService) : super(AppsState.initial()){
    _loadPermissions();
  }

  int categoryIndex = 0;

  // 2. Keep a private master list to preserve data during searches
  List<AppModel> masterAppList = [];

  List<AppModel> get safeApps =>
      state.allApps.where((app) => (app.riskLevel ?? 0) <= 50).toList();

  List<AppModel> get riskyApps =>
      state.allApps.where((app) => (app.riskLevel ?? 0) > 50).toList();

  // 3. Make this async to handle the real scanning process
  Future<void> getApps() async {
    emit(state.copyWith(status: AppStatus.loading));

    try {
      // Trigger the native scan and risk calculation
      final fetchedApps = await _scannerService.scanDevice();

      if (fetchedApps.isEmpty) {
        emit(state.copyWith(status: AppStatus.failed, allApps: []));
        return;
      }

      // Save to our master list for searching later
      masterAppList = fetchedApps;

      // Re-apply search filter if there's an active query
      if (state.searchQuery.isNotEmpty) {
        search(state.searchQuery);
      } else {
        // Emit success with the real data
        emit(state.copyWith(status: AppStatus.success, allApps: masterAppList));
      }
    } catch (_) {
      emit(state.copyWith(status: AppStatus.error, allApps: []));
    }
  }

  void changeCategory(int index) {
    categoryIndex = index;
  }

  void navigateToNextPage(int index) {
    categoryIndex = index;
    emit(state.copyWith());
  }

  // 4. Update search to filter against the master list
  void search(String query) {
    final cleanQuery = query.trim().toLowerCase();

    if (cleanQuery.isEmpty) {
      // If search is cleared, restore the full scanned list
      emit(state.copyWith(searchQuery: '', allApps: List.from(masterAppList)));
      return;
    }

    final results = masterAppList.where((app) {
      final name = app.name?.toLowerCase() ?? '';
      final package = app.package?.toLowerCase() ?? '';
      final category = app.category?.toLowerCase() ?? '';

      return name.contains(cleanQuery) ||
          package.contains(cleanQuery) ||
          category.contains(cleanQuery);
    }).toList();

    // Emit the search query and the results
    emit(state.copyWith(searchQuery: query, allApps: results));
  }
  Future<void> _loadPermissions() async {
    final prefs = await SharedPreferences.getInstance();

    final query = prefs.getBool('queryInstalledApps');
    final storage = prefs.getBool('storageAccess');

    emit(state.copyWith(
      queryInstalledApps: query ?? false,
      storageAccess: storage ?? false,
    ));
  }
  void setQueryInstalledApps(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('queryInstalledApps', value);

    emit(state.copyWith(queryInstalledApps: value));

    if (value) {
      await getApps();
    }
  }

  void setStorageAccess(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('storageAccess', value);

    emit(state.copyWith(storageAccess: value));
  }
}
