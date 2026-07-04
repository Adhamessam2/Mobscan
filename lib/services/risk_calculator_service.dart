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

  // 2. THE SMART MATRIX: Comprehensive expected permissions by category (using lowercase keys to match AppCategory.name)
  final Map<String, List<String>> expectedPermissions = {
    // Media & Communication
    'social': [
      'android.permission.CAMERA',
      'android.permission.RECORD_AUDIO',
      'android.permission.READ_CONTACTS', // Essential for friend-matching/chat sync
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.ACCESS_COARSE_LOCATION',
    ],
    'communication': [
      'android.permission.CAMERA',
      'android.permission.RECORD_AUDIO',
      'android.permission.READ_CONTACTS', // Essential for messaging apps
    ],
    'photography': [
      'android.permission.CAMERA',
      'android.permission.RECORD_AUDIO', // Needed for taking videos within camera apps
      'android.permission.ACCESS_FINE_LOCATION', // Needed for EXIF geotagging photos
    ],
    'image': [
      'android.permission.CAMERA',
      'android.permission.RECORD_AUDIO',
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.ACCESS_COARSE_LOCATION',
    ],
    'video': [
      'android.permission.CAMERA',
      'android.permission.RECORD_AUDIO',
    ],
    'audio': [
      'android.permission.RECORD_AUDIO',
    ],
    'music_and_audio': [
      'android.permission.RECORD_AUDIO', // Expected for music recognition or karaoke
    ],
    'game': [
      'android.permission.CAMERA',
      'android.permission.RECORD_AUDIO',
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.ACCESS_COARSE_LOCATION',
    ],

    // Location-Based Services
    'maps': [
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.ACCESS_COARSE_LOCATION',
      'android.permission.CAMERA',
    ],
    'travel': [
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.ACCESS_COARSE_LOCATION',
      'android.permission.CAMERA', // Used for translation features or scanning passports
    ],
    'weather': [
      'android.permission.ACCESS_FINE_LOCATION', // Needed for hyper-local forecasts
      'android.permission.ACCESS_COARSE_LOCATION',
    ],
    'news': [
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.ACCESS_COARSE_LOCATION',
    ],

    // Lifestyle & Utilities
    'health_and_fitness': [
      'android.permission.ACCESS_FINE_LOCATION', // Tracking running/biking routes
      'android.permission.ACCESS_COARSE_LOCATION',
      'android.permission.CAMERA', // Scanning food barcodes for calories
    ],
    'shopping': [
      'android.permission.CAMERA', // Scanning credit cards or AR product try-ons
      'android.permission.ACCESS_FINE_LOCATION', // Finding nearby physical stores
      'android.permission.ACCESS_COARSE_LOCATION',
    ],
    'finance': [
      'android.permission.CAMERA', // Depositing cheques
      'android.permission.ACCESS_FINE_LOCATION', // Bank fraud prevention
      'android.permission.READ_CONTACTS', // Sending money to friends
    ],
    'dating': [
      'android.permission.ACCESS_FINE_LOCATION', // Core functionality of dating apps
      'android.permission.ACCESS_COARSE_LOCATION',
      'android.permission.CAMERA',
    ],
    'education': [
      'android.permission.CAMERA', // For video lectures/proctoring
      'android.permission.RECORD_AUDIO',
    ],
    'productivity': [
      'android.permission.READ_CONTACTS',
      'android.permission.CAMERA',
      'android.permission.RECORD_AUDIO',
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.ACCESS_COARSE_LOCATION',
    ],
    'accessibility': [
      'android.permission.SYSTEM_ALERT_WINDOW',
    ],
    'business': [
      'android.permission.CAMERA',
      'android.permission.RECORD_AUDIO',
      'android.permission.READ_CONTACTS',
    ],
    'medical': [
      'android.permission.CAMERA',
      'android.permission.RECORD_AUDIO',
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.ACCESS_COARSE_LOCATION',
    ],
    'tools': [
      'android.permission.CAMERA',
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.ACCESS_COARSE_LOCATION',
      'android.permission.SYSTEM_ALERT_WINDOW',
    ],
    'lifestyle': [
      'android.permission.CAMERA',
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.ACCESS_COARSE_LOCATION',
    ],
    'entertainment': [
      'android.permission.CAMERA',
      'android.permission.RECORD_AUDIO',
    ],
    'house_and_home': [
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.ACCESS_COARSE_LOCATION',
      'android.permission.CAMERA',
    ],
    'parenting': [
      'android.permission.CAMERA',
      'android.permission.RECORD_AUDIO',
    ],
    'events': [
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.ACCESS_COARSE_LOCATION',
      'android.permission.CAMERA',
    ],
    'books_and_reference': [
      'android.permission.RECORD_AUDIO',
      'android.permission.CAMERA',
    ],
    'personalization': [
      'android.permission.SYSTEM_ALERT_WINDOW',
    ],
    'sports': [
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.ACCESS_COARSE_LOCATION',
    ],
    'food_and_drink': [
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.ACCESS_COARSE_LOCATION',
    ],
    'auto_and_vehicles': [
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.ACCESS_COARSE_LOCATION',
    ],
    'beauty': [
      'android.permission.CAMERA',
    ],
    'news_and_magazines': [
      'android.permission.ACCESS_FINE_LOCATION',
      'android.permission.ACCESS_COARSE_LOCATION',
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

    // Normalize category to lowercase to prevent casing mismatches
    final normalizedCategory = category.trim().toLowerCase();

    // Get the list of "reasonable" permissions for this specific app's category
    final allowedForThisCategory = expectedPermissions[normalizedCategory] ?? [];

    for (String perm in appDangerousPerms) {
      // Global Override: SYSTEM_ALERT_WINDOW is almost always sketchy unless it's a specific utility/accessibility
      if (perm == 'android.permission.SYSTEM_ALERT_WINDOW') {
        // Skip penalty if the app category specifically allows overlay permissions (like accessibility)
        if (allowedForThisCategory.contains(perm)) {
          continue;
        }
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
