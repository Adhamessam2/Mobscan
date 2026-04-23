import 'package:flutter/material.dart';

class PermissionsScreen extends StatefulWidget {
    const PermissionsScreen({super.key});

    @override
    State<PermissionsScreen> createState() => _PermissionsScreenState();
}

class _PermissionsScreenState extends State<PermissionsScreen> {
    bool queryInstalledApps = false;
    bool storageAccess = false;

    @override
    Widget build(BuildContext context) {
        final theme = Theme.of(context);

        return Scaffold(
            backgroundColor: theme.scaffoldBackgroundColor,
            body: SafeArea(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                            // HEADER
                            Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                    Row(
                                        children: [
                                           // Container(
                                               // width: 32,
                                               // height: 32,
                                              //  decoration: BoxDecoration(
                                                //    color: Colors.blueAccent.withOpacity(0.15),
                                                 //   borderRadius: BorderRadius.circular(8),
                                                //),
                                               // child:
                                                const Icon(Icons.security,
                                                    color: Colors.blueAccent, size: 22),
                                           // ),
                                            const SizedBox(width: 8),
                                            Text("MobScan",
                                                style: TextStyle(
                                                    color: theme.colorScheme.onSurface,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600)),
                                        ],
                                    ),
                                    Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                            color: theme.cardColor,
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(
                                                color: theme.colorScheme.onSurface.withOpacity(0.1)),
                                        ),
                                        child: Icon(Icons.help_outline,
                                            color: theme.colorScheme.onSurface.withOpacity(0.6),
                                            size: 18),
                                    ),
                                ],
                            ),

                            const SizedBox(height: 30),

                            // TITLE
                            Text("Security Setup",
                                style: TextStyle(
                                    color: theme.colorScheme.onSurface,
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold)),

                            const SizedBox(height: 8),

                            Text(
                                "Configure MobScan to protect your device\nfrom emerging threats.",
                                style: TextStyle(
                                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                                    fontSize: 14,
                                    height: 1.5),
                            ),

                            const SizedBox(height: 24),

                            // PRIVACY FIRST CARD
                            Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                    color: theme.cardColor,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color: theme.colorScheme.onSurface.withOpacity(0.1)),
                                ),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                        Row(
                                            children: [
                                                Container(
                                                    width: 40,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                        color: Colors.blueAccent.withOpacity(0.1),
                                                        borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: const Icon(Icons.visibility_off_outlined,
                                                        color: Colors.blueAccent, size: 20),
                                                ),
                                                const SizedBox(width: 12),
                                                Text("Privacy First Analysis",
                                                    style: TextStyle(
                                                        color: theme.colorScheme.onSurface,
                                                        fontSize: 15,
                                                        fontWeight: FontWeight.w600)),
                                            ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                            "We only analyze app metadata for security risk detection. No personal files, photos, or messages are ever uploaded to our servers. All deep scans are performed locally.",
                                            style: TextStyle(
                                                color: theme.colorScheme.onSurface.withOpacity(0.6),
                                                fontSize: 13,
                                                height: 1.5),
                                        ),
                                        const SizedBox(height: 12),
                                        GestureDetector(
                                            onTap: () {},
                                            child: const Text("VIEW PRIVACY POLICY",
                                                style: TextStyle(
                                                    color: Colors.blueAccent,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w600,
                                                    letterSpacing: 0.8)),
                                        ),
                                    ],
                                ),
                            ),

                            const SizedBox(height: 30),

                            // REQUIRED PERMISSIONS
                            Text("REQUIRED PERMISSIONS",
                                style: TextStyle(
                                    color: Colors.blueAccent,
                                    fontSize: 12,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.w600)),

                            const SizedBox(height: 15),

                            Container(
                                decoration: BoxDecoration(
                                    color: theme.cardColor,
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color: theme.colorScheme.onSurface.withOpacity(0.1)),
                                ),
                                child: Column(
                                    children: [
                                        _permissionTile(
                                            theme,
                                            Icons.apps,
                                            "Query Installed Apps",
                                            "Identify malicious packages and known vulnerabilities.",
                                            queryInstalledApps,
                                                (value) => setState(() => queryInstalledApps = value),
                                        ),
                                        Divider(
                                            color: theme.colorScheme.onSurface.withOpacity(0.06),
                                            height: 1),
                                        _permissionTile(
                                            theme,
                                            Icons.folder_outlined,
                                            "Storage Access",
                                            "Analyze APK files for deep-threat detection signatures.",
                                            storageAccess,
                                                (value) => setState(() => storageAccess = value),
                                        ),
                                    ],
                                ),
                            ),

                            const SizedBox(height: 40),

                            // ALLOW & CONTINUE BUTTON
                            SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                    onPressed: () {},
                                    style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.blueAccent,
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(14)),
                                    ),
                                    child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                            Text("Allow & Continue",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600)),
                                            SizedBox(width: 8),
                                            Icon(Icons.arrow_forward,
                                                color: Colors.white, size: 18),
                                        ],
                                    ),
                                ),
                            ),

                            const SizedBox(height: 20),

                        ],
                    ),
                ),
            ),
        );
    }

    Widget _permissionTile(
        ThemeData theme,
        IconData icon,
        String title,
        String subtitle,
        bool value,
        ValueChanged<bool> onChanged,
        ) {
        return ListTile(
            leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(.1),
                    borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: Colors.blueAccent, size: 20),
            ),
            title: Text(title,
                style: TextStyle(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.w500,
                    fontSize: 14)),
            subtitle: Text(subtitle,
                style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.6),
                    fontSize: 12)),
            trailing: Switch(
                value: value,
                onChanged: onChanged,
                activeColor: Colors.blueAccent,
            ),
        );
    }
}