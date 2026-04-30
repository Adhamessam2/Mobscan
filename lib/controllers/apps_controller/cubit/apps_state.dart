part of 'apps_cubit.dart';

enum AppStatus { intial, loading, success, error, failed }

@immutable
class AppsState {
  final AppStatus status;
  final List<AppModel> allApps;
  final int selectedCategoryIndex;

  const AppsState._({
    required this.status,
    required this.allApps,
    required this.selectedCategoryIndex,
  });

  factory AppsState.initial() {
    return const AppsState._(
      status: AppStatus.intial,
      allApps: [],
      selectedCategoryIndex: 0,
    );
  }
  factory AppsState.loading(){
    return const AppsState._(status: AppStatus.loading,
        allApps: [],
        selectedCategoryIndex: 0,
    );
  }

  AppsState copyWith({
    AppStatus? status,
    List<AppModel>? allApps,
    int? selectedCategoryIndex,
    List<ScanResult>? scanResults,
  }) {
    return AppsState._(
      status: status ?? this.status,
      allApps: allApps ?? this.allApps,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
    );
  }
}
