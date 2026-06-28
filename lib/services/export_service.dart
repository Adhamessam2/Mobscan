import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';
import 'package:mobscan/models/app_model.dart';


class ExportService {
  static Future<void> exportReport(List<AppModel> apps) async {
    final pdf = pw.Document();
    final now = DateTime.now();
    final formattedDate = '${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}';

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('MobScan Report',
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.Text('Generated: $formattedDate'),
            pw.SizedBox(height: 8),
            pw.Text('Total Apps: ${apps.length}'),
            pw.Text('Risky Apps: ${apps.where((a) => (a.riskLevel ?? 0) > 50).length}'),
            pw.Divider(),
            pw.SizedBox(height: 10),
            ...apps.map((app) => pw.Padding(
              padding: const pw.EdgeInsets.symmetric(vertical: 4),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(app.name.toString()),
                  pw.Text('${app.riskLevel ?? 0}% - ${app.riskReason ?? 'Unknown'}'),
                ],
              ),
            )),
          ],
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/mobscan_report.pdf');
    await file.writeAsBytes(await pdf.save());

    await Share.shareXFiles(
      [XFile(file.path)],
      text: 'MobScan Security Report',
    );
  }
}