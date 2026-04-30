part of 'security_cubit.dart';

@immutable
sealed class SecurityState{
}
class SecurityLoading extends SecurityState {
  SecurityLoading();
}
class SecuritySuccess extends SecurityState {
  final List<ScanResult> result;
   SecuritySuccess(this.result);
}
class SecurityError extends SecurityState {
  final String message;

   SecurityError(this.message);
}
