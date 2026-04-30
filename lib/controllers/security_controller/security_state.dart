part of 'security_cubit.dart';

@immutable
sealed class SecurityState{
}
class SecurityLoading extends SecurityState {
  final int? progress;

  SecurityLoading([this.progress]);
}
class SecuritySuccess extends SecurityState {
  final List<ScanResult> result;
  final int score;
  final DateTime? lastScan;
  int? threats;
   SecuritySuccess(this.result,this.score,this.lastScan,this.threats);
}
class SecurityError extends SecurityState {
  final String message;

   SecurityError(this.message);
}
