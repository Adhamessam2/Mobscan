part of 'settings_cubit.dart';


@immutable
class SettingsState {
  final bool autoScan;
  final bool notifications;

  const SettingsState({
    this.autoScan = false,
    this.notifications = false,
  });

  SettingsState copyWith({
    bool? autoScan,
    bool? notifications,
  }) {
    return SettingsState(
      autoScan: autoScan ?? this.autoScan,
      notifications: notifications ?? this.notifications,
    );
  }
}