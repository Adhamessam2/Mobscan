part of 'apps_cubit.dart';

enum AppStatus { intial, loading, success, error, failed }

@immutable
class AppsState {
  final AppStatus status;
  final List<AppModel> allApps;
  final String searchQuery;
  final int selectedCategoryIndex;

  const AppsState._({
    required this.status,
    required this.allApps,
    required this.searchQuery,
    required this.selectedCategoryIndex,
  });

  factory AppsState.initial() {
    return const AppsState._(
      status: AppStatus.intial,
      allApps: [],
      searchQuery: '',
      selectedCategoryIndex: 0,
    );
  }

  AppsState copyWith({
    AppStatus? status,
    List<AppModel>? allApps,
    String? searchQuery,
    int? selectedCategoryIndex,
  }) {
    return AppsState._(
      status: status ?? this.status,
      allApps: allApps ?? this.allApps,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryIndex:
          selectedCategoryIndex ?? this.selectedCategoryIndex,
    );
  }
}
