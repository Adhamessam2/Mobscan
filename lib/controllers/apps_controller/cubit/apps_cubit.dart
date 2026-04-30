import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jailbreak_root_detection/jailbreak_root_detection.dart';
import 'package:mobscan/models/app_model.dart';
import 'package:mobscan/services/app_scanner_service.dart';

part 'apps_state.dart';

class AppsCubit extends Cubit<AppsState> {
  final AppScannerService _scannerService;

  AppsCubit(this._scannerService) : super(AppsState.initial());

  int categoryIndex = 0;

  // 2. Keep a private master list to preserve data during searches
  List<AppModel> masterAppList = [];

  List<AppModel> get safeApps =>
      state.allApps.where((app) => app.riskLevel! <= 50).toList();

  List<AppModel> get riskyApps =>
      state.allApps.where((app) => app.riskLevel! > 50).toList();

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

      // Emit success with the real data
      emit(state.copyWith(status: AppStatus.success, allApps: masterAppList));
    } catch (e) {
      debugPrint("Error fetching apps: $e");
      emit(state.copyWith(status: AppStatus.failed, allApps: []));
    }
  }


  void changeCategory(int index) {
    categoryIndex = index;
    emit(state.copyWith(selectedCategoryIndex: index));
  }

  void navigateToNextPage(int index) {
    categoryIndex = index;
    emit(state.copyWith(selectedCategoryIndex: index));
  }

  // 4. Update search to filter against the master list
  void search(String appname) {
    if (appname.isEmpty) {
      // If search is cleared, restore the full scanned list
      emit(state.copyWith(allApps: masterAppList));
      return;
    }

    final results = masterAppList
        .where(
          (item) =>
              item.name!.toLowerCase().contains(appname.trim().toLowerCase()),
        )
        .toList();

    // Even if results are empty, emit them so the UI can show a "No apps found" message
    emit(state.copyWith(allApps: results));
  }
}
