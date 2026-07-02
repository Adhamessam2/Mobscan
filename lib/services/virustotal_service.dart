import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mobscan/models/vt_link_result.dart';

class VirusTotalService {
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

    await Future.delayed(const Duration(seconds: 2));

    final resultResponse = await http.get(
      Uri.parse(
        'https://www.virustotal.com/api/v3/analyses/$id',
      ),
      headers: {
        'x-apikey': _apiKey,
      },
    );

    if (resultResponse.statusCode != 200) {
      throw Exception('Failed to get analysis');
    }

    return VtLinkResult.fromJson(
      jsonDecode(resultResponse.body),
      url,
    );
  }
}