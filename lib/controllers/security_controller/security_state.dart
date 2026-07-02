part of 'security_cubit.dart';

@immutable
sealed class SecurityState{
}
class SecuirtyInitial extends SecurityState{
  late final DateTime? lastScan;
  SecuirtyInitial({this.lastScan});
}
class SecurityLoading extends SecurityState {
  final int? progress;

  SecurityLoading([this.progress]);
}
class SecuritySuccess extends SecurityState {
  final List<ScanResult> result;
  int score = 100;
  final DateTime? lastScan;
  int threats = 0;
   SecuritySuccess(this.result,this.score,this.lastScan,this.threats);
}
class SecurityError extends SecurityState {
  final String message;

   SecurityError(this.message);
}
