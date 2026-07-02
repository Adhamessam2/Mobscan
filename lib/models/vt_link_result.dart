class VtLinkResult {
  const VtLinkResult({
    required this.url,
    required this.total,
    required this.malicious,
    required this.suspicious,
    required this.harmless,
    required this.engines,
  });

  final String url;
  final int total;
  final int malicious;
  final int suspicious;
  final int harmless;
  final Map<String, String> engines;

  bool get isClean => malicious == 0 && suspicious == 0;

  bool get isMalicious => malicious > 0;

  factory VtLinkResult.fromJson(
      Map<String, dynamic> json,
      String scannedUrl,
      ) {
    final attributes = json['data']['attributes'] as Map<String, dynamic>;

    final stats = attributes['stats'] as Map<String, dynamic>;

    final results = attributes['results'] as Map<String, dynamic>;

    return VtLinkResult(
      url: scannedUrl,
      total: results.length,
      malicious: stats['malicious'] ?? 0,
      suspicious: stats['suspicious'] ?? 0,
      harmless: stats['harmless'] ?? 0,
      engines: results.map(
            (key, value) => MapEntry(
          key,
          value['category'] ?? '',
        ),
      ),
    );
  }
}