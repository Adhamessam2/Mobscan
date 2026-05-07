part of 'apps_cubit.dart';

enum AppStatus { intial, loading, success, error, failed }

@immutable
class AppsState {
  final AppStatus status;
  final List<AppModel> allApps;
  final String searchQuery;
  final int selectedCategoryIndex;
  final bool queryInstalledApps;
  final bool storageAccess;

  const AppsState._({
    required this.status,
    required this.allApps,
    required this.searchQuery,
    required this.selectedCategoryIndex,
    required this.queryInstalledApps,
    required this.storageAccess,
  });

  factory AppsState.initial() {
    return const AppsState._(
      status: AppStatus.intial,
      allApps: [],
      searchQuery: '',
      selectedCategoryIndex: 0,
      queryInstalledApps: false,
      storageAccess: false,
    );
  }

  AppsState copyWith({
    AppStatus? status,
    List<AppModel>? allApps,
    String? searchQuery,
    int? selectedCategoryIndex,
    bool? queryInstalledApps,
    bool? storageAccess,
  }) {
    return AppsState._(
      status: status ?? this.status,
      allApps: allApps ?? this.allApps,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryIndex:
      selectedCategoryIndex ?? this.selectedCategoryIndex,
      queryInstalledApps: queryInstalledApps ?? this.queryInstalledApps,
      storageAccess: storageAccess ?? this.storageAccess,

    );
  }

}
