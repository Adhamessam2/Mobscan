part of 'apps_cubit.dart';

enum AppStatus { intial, loading, success, error, failed }

@immutable
class AppsState {
  final AppStatus status;
  final List<AppModel> allApps;
  final int selectedCategoryIndex;
  final bool queryInstalledApps;
  final bool storageAccess;

  const AppsState._({
    required this.status,
    required this.allApps,
    required this.selectedCategoryIndex,
    required this.queryInstalledApps,
    required this.storageAccess,
  });

  factory AppsState.initial() {
    return const AppsState._(
      status: AppStatus.intial,
      allApps: [],
      selectedCategoryIndex: 0,
      queryInstalledApps: false,
      storageAccess: false,
    );
  }

  AppsState copyWith({
    AppStatus? status,
    List<AppModel>? allApps,
    int? selectedCategoryIndex,
  }) {
    return AppsState._(
      status: status ?? this.status,
      allApps: allApps ?? this.allApps,
      selectedCategoryIndex:
      selectedCategoryIndex ?? this.selectedCategoryIndex,
      queryInstalledApps: queryInstalledApps ?? this.queryInstalledApps,
      storageAccess: storageAccess ?? this.storageAccess,
    );
  }

}
