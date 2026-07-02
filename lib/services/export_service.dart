import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

import '../models/Scan_result.dart';

class ExportService {
  static Future<void> exportReport({
    required List<ScanResult> results,
    required List<Map<String, dynamic>> apps,
    required int score,
    required int threats,
  }) async {
    final pdf = pw.Document();

    final now = DateTime.now();

    final formatter = DateFormat("dd/MM/yyyy HH:mm");

    final date = formatter.format(now);

    int safeApps =
        apps.where((e) => e["status"] == "Safe").length;

    int riskyApps =
        apps.where((e) => e["status"] == "High").length;

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,

        build: (context) => [

        pw.Center(
      child: pw.Text(
      "MobScan Security Report",
        style: pw.TextStyle(
          fontSize: 24,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
    ),

    pw.SizedBox(height: 20),

    pw.Container(
    padding: const pw.EdgeInsets.all(10),
    decoration: pw.BoxDecoration(
    border: pw.Border.all(),
    borderRadius: pw.BorderRadius.circular(10),
    ),
    child: pw.Column(
    crossAxisAlignment:
    pw.CrossAxisAlignment.start,
    children: [

    pw.Text(
    "Scan Summary",
    style: pw.TextStyle(
    fontWeight: pw.FontWeight.bold,
    fontSize: 18,
    ),
    ),

    pw.Divider(),

    pw.Text("Scan Date : $date"),

    pw.Text("Security Score : $score %"),

    pw.Text("Threats Found : $threats"),

    pw.Text("Total Applications : ${apps.length}"),

    pw.Text("Safe Applications : $safeApps"),

    pw.Text("Risk Applications : $riskyApps"),
    ],
    ),
    ),

    pw.SizedBox(height: 25),

    pw.Text(
    "Security Models",
    style: pw.TextStyle(
    fontWeight: pw.FontWeight.bold,
    fontSize: 18,
    ),
    ),

    pw.SizedBox(height: 10),

    pw.Table(
    border: pw.TableBorder.all(),

    columnWidths: {
    0: const pw.FlexColumnWidth(2),
    1: const pw.FlexColumnWidth(2),
    2: const pw.FlexColumnWidth(4),
    },

    children: [

    pw.TableRow(
    decoration: const pw.BoxDecoration(
    color: PdfColors.grey300,
    ),

    children: [

    pw.Padding(
    padding:
    const pw.EdgeInsets.all(5),
    child: pw.Text(
    "Model",
    style: pw.TextStyle(
    fontWeight:
    pw.FontWeight.bold,
    ),
    ),
    ),

    pw.Padding(
    padding:
    const pw.EdgeInsets.all(5),
    child: pw.Text(
    "Status",
    style: pw.TextStyle(
    fontWeight:
    pw.FontWeight.bold,
    ),
    ),
    ),

    pw.Padding(
    padding:
    const pw.EdgeInsets.all(5),
    child: pw.Text(
    "Description",
    style: pw.TextStyle(
    fontWeight:
    pw.FontWeight.bold,
    ),
    ),
    ),
    ],
    ),

    ...results.map(
    (item) => pw.TableRow(
    children: [

    pw.Padding(
    padding:
    const pw.EdgeInsets.all(5),
    child: pw.Text(item.explain),
    ),

    pw.Padding(
    padding:
    const pw.EdgeInsets.all(5),
    child: pw.Text(item.behaviour),
    ),

    pw.Padding(
    padding:
    const pw.EdgeInsets.all(5),
    child: pw.Text(
    item.smallExplain),
    ),
    ],
    ),
    ),
    ],
    ),

    pw.SizedBox(height: 30),

    pw.Text(
    "Installed Applications",
    style: pw.TextStyle(
    fontWeight: pw.FontWeight.bold,
    fontSize: 18,
    ),
    ),

    pw.SizedBox(height: 10),
          pw.Table(
            border: pw.TableBorder.all(),

            columnWidths: {
              0: const pw.FlexColumnWidth(3),
              1: const pw.FlexColumnWidth(4),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(4),
            },

            children: [

              pw.TableRow(
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey300,
                ),
                children: [

                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "App Name",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),

                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "Package",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),

                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "Status",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),

                  pw.Padding(
                    padding: const pw.EdgeInsets.all(5),
                    child: pw.Text(
                      "Reason",
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              ...apps.map(
                    (app) => pw.TableRow(
                  children: [

                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        app["appName"] ?? "",
                      ),
                    ),

                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        app["packageName"] ?? "",
                      ),
                    ),

                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        app["status"] ?? "",
                      ),
                    ),

                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        app["reason"] ?? "",
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          pw.SizedBox(height: 25),

          pw.Text(
            "Recommendations",
            style: pw.TextStyle(
              fontSize: 18,
              fontWeight: pw.FontWeight.bold,
            ),
          ),

          pw.Bullet(
            text:
            "Remove or disable suspicious applications.",
          ),

          pw.Bullet(
            text:
            "Keep your applications updated.",
          ),

          pw.Bullet(
            text:
            "Install apps only from trusted sources.",
          ),

          pw.Bullet(
            text:
            "Run MobScan regularly.",
          ),

        ],
      ),
    );

    final dir = await getApplicationDocumentsDirectory();

    final file = File(
      "${dir.path}/MobScan_Report.pdf",
    );

    await file.writeAsBytes(
      await pdf.save(),
    );

    await Share.shareXFiles(
      [
        XFile(file.path),
      ],
      text: "MobScan Security Report",
    );
  }
}