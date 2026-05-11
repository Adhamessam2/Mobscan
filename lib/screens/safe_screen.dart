import 'package:flutter/material.dart';
import 'package:mobscan/models/app_model.dart';

class SafeAppDetailScreen extends StatelessWidget {
  final AppModel app;

  const SafeAppDetailScreen({super.key, required this.app});

  @override
  Widget build(BuildContext context) {
    final colorscheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Theme.of(context).colorScheme.onSurface,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Scan Result',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        forceMaterialTransparency: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App Icon
                if (app.icon != null)
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.green.withValues(alpha: 0.2),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.memory(
                        app.icon!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                const SizedBox(height: 24),

                // App Name & Package
                Text(
                  app.name ?? 'Unknown App',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 4),
                Text(
                  app.package ?? 'unknown.package',
                  style: const TextStyle(color: Colors.blueGrey, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 40),
                // Threat Score
                const Text(
                  "0%",
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 56,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'THREAT SCORE',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                    letterSpacing: 2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                // Success Message
                Text(
                  'No Risks Detected',
                  style: TextStyle(
                    color: colorscheme.onSurface,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'This app does not contain any known malicious code, dangerous permissions, or suspicious behaviors.',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.center,
                ),

                const Spacer(),

                // Done Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Back to Dashboard',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
