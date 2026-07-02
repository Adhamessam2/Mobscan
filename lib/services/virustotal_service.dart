import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/vt_link_result.dart';
class VirusUrlService {
  static const String _apiKey = '7165900d04c37bb0dc21af8f44a2439c40a193d765c1f2433a3d5adde61cf250';

  Future<VtLinkResult> scanUrl(String url) async {
    // إرسال الرابط
    final submitResponse = await http.post(
      Uri.parse('https://www.virustotal.com/api/v3/urls'),
      headers: {
        'x-apikey': _apiKey,
      },
      body: {
        'url': url,
      },
    );

    if (submitResponse.statusCode != 200) {
      throw Exception('Failed to submit URL');
    }

    final submitData = jsonDecode(submitResponse.body);

    final id = submitData['data']['id'];

    Map<String, dynamic> analysisJson;
    String status;
    int attempts = 0;

    do {
      await Future.delayed(const Duration(seconds: 3));

      final resultResponse = await http.get(
        Uri.parse('https://www.virustotal.com/api/v3/analyses/$id'),
        headers: {'x-apikey': _apiKey},
      );

      if (resultResponse.statusCode != 200) {
        throw Exception('Failed to get analysis');
      }

      analysisJson = jsonDecode(resultResponse.body);
      status = analysisJson['data']['attributes']['status'];

      attempts++;
    } while (status != 'completed' && attempts < 15); // max ~45 sec

    if (status != 'completed') {
      throw Exception('Analysis timed out, try again');
    }

    return VtLinkResult.fromJson(analysisJson, url);
  }

}