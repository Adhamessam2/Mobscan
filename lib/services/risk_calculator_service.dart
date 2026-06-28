class RiskCalculatorService {
  // 1. The master list of permissions we care about
  final List<String> dangerousPermissions = [
    'android.permission.CAMERA',
    'android.permission.RECORD_AUDIO',
    'android.permission.READ_SMS',
    'android.permission.READ_CONTACTS',
    'android.permission.ACCESS_FINE_LOCATION',
    'android.permission.ACCESS_COARSE_LOCATION',
    'android.permission.SYSTEM_ALERT_WINDOW', // Drawing over other apps
  ];

  // 2. THE SMART MATRIX: Comprehensive expected permissions by category
  final Map<String, List<String>> expectedPermissions = {
    // Media & Communication
    'Social': [
      'android.permission.CAMERA',
      'android.permission.RECORD_AUDIO',
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.ACCESS_COARSE_LOCATION',
    ],
    'Communication': [
      'android.permission.CAMERA',
      'android.permission.RECORD_AUDIO',
      'android.permission.READ_CONTACTS', // Essential for messaging apps
    ],
    'Photography': [
      'android.permission.CAMERA',
      'android.permission.RECORD_AUDIO', // Needed for taking videos within camera apps
      'android.permission.ACCESS_FINE_LOCATION', // Needed for EXIF geotagging photos
    ],
    'Video': ['android.permission.CAMERA', 'android.permission.RECORD_AUDIO'],
    'Music_and_audio': [
      'android.permission.RECORD_AUDIO', // Expected for music recognition (like Shazam) or karaoke
    ],

    // Location-Based Services
    'Maps': [
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.ACCESS_COARSE_LOCATION',
    ],
    'Travel': [
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.ACCESS_COARSE_LOCATION',
      'android.permission.CAMERA', // Used for translation features or scanning passports
    ],
    'Weather': [
      'android.permission.ACCESS_FINE_LOCATION', // Needed for hyper-local forecasts
      'android.permission.ACCESS_COARSE_LOCATION',
    ],

    // Lifestyle & Utilities
    'Health_and_fitness': [
      'android.permission.ACCESS_FINE_LOCATION', // Tracking running/biking routes
      'android.permission.CAMERA', // Scanning food barcodes for calories
    ],
    'Shopping': [
      'android.permission.CAMERA', // Scanning credit cards or AR product try-ons
      'android.permission.ACCESS_FINE_LOCATION', // Finding nearby physical stores
      'android.permission.ACCESS_COARSE_LOCATION',
    ],
    'Finance': [
      'android.permission.CAMERA', // Depositing cheques
      'android.permission.ACCESS_FINE_LOCATION', // Bank fraud prevention (verifying user location)
      'android.permission.READ_CONTACTS', // Sending money to friends (like Venmo/PayPal)
    ],
    'Dating': [
      'android.permission.ACCESS_FINE_LOCATION', // Core functionality of dating apps
      'android.permission.ACCESS_COARSE_LOCATION',
      'android.permission.CAMERA',
    ],
    'Education': [
      'android.permission.CAMERA', // For video lectures/proctoring
      'android.permission.RECORD_AUDIO',
    ],
  };

  /// Calculates the risk score and returns a Map with the score and the reason.
  Map<String, dynamic> calculateRisk(
    String category,
    List<String> permissions,
  ) {
    int score = 0;
    List<String> suspiciousFinds = [];

    // Filter the app's permissions to ONLY look at the dangerous ones
    final appDangerousPerms = permissions
        .where((p) => dangerousPermissions.contains(p))
        .toList();

    // Get the list of "reasonable" permissions for this specific app's category
    final allowedForThisCategory = expectedPermissions[category] ?? [];

    for (String perm in appDangerousPerms) {
      // Global Override: SYSTEM_ALERT_WINDOW is almost always sketchy unless it's a specific utility
      if (perm == 'android.permission.SYSTEM_ALERT_WINDOW') {
        score += 60;
        suspiciousFinds.add('Can draw over other apps (High Risk)');
        continue;
      }

      // THE FIX: If the permission is in the expected list for this category, IGNORE IT!
      if (allowedForThisCategory.contains(perm)) {
        continue; // Skip the rest of the loop, add 0 risk!
      }

      // If we reach this line, the permission is dangerous AND NOT reasonable for this category.
      // Now we apply specific penalties based on what they are trying to access.
      if (perm.contains('READ_SMS')) {
        score += 50;
        suspiciousFinds.add('Unnecessary SMS access');
      } else if (perm.contains('READ_CONTACTS')) {
        score += 40;
        suspiciousFinds.add('Unnecessary Contacts access');
      } else if (perm.contains('CAMERA') || perm.contains('RECORD_AUDIO')) {
        score += 30;
        suspiciousFinds.add('Unnecessary Camera/Microphone access');
      } else if (perm.contains('LOCATION')) {
        score += 20;
        suspiciousFinds.add('Unnecessary Location tracking');
      }
    }

    if (score > 100) score = 100;

    String reason = suspiciousFinds.isEmpty
        ? 'There is no threat in this app'
        : suspiciousFinds.toSet().map((e) => '- $e').join('\n');

    return {'score': score, 'reason': reason};
  }
}
