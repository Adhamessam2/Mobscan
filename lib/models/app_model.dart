import 'dart:typed_data';

class AppModel {
  final Uint8List? icon;
  final String? name;
  final String? package;
  final String? category;
  final List<String>? requestedPermissions;
  final int? riskLevel;
  final String? riskReason;

  AppModel({
    required this.icon,
    required this.name,
    required this.package,
    required this.category,
    required this.requestedPermissions,
    required this.riskLevel,
    required this.riskReason,
  });
}
