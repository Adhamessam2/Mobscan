part of 'link_checker_cubit.dart';

enum LinkCheckerStatus {
  initial,
  loading,
  success,
  error,
}

class LinkCheckerState {
  final LinkCheckerStatus status;
  final VtLinkResult? result;
  final List<VtLinkResult> history;
  final String? error;

  const LinkCheckerState({
    this.status = LinkCheckerStatus.initial,
    this.result,
    this.history = const [],
    this.error,
  });

  LinkCheckerState copyWith({
    LinkCheckerStatus? status,
    VtLinkResult? result,
    List<VtLinkResult>? history,
    String? error,
  }) {
    return LinkCheckerState(
      status: status ?? this.status,
      result: result ?? this.result,
      history: history ?? this.history,
      error: error ?? this.error,
    );
  }
}