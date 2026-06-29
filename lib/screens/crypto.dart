import 'dart:io';
import 'package:crypto/crypto.dart';

Future<String> calculateSha256(String filePath) async {
  final file = File(filePath);
  final bytes = await file.readAsBytes();

  return sha256.convert(bytes).toString();
}