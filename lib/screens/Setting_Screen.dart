import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobscan/controllers/apps_controller/cubit/theme_cubit.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool autoScan = false;
  bool saveToCloud = false;
  bool notifications = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [

            // HEADER
            Row(
              children: [
                Icon(Icons.arrow_back_ios,
                    color: theme.colorScheme.onSurface.withOpacity(0.7),
                    size: 18),
                const Spacer(),
                Text("Settings",
                    style: TextStyle(
                        color: theme.colorScheme.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w600)),
                const Spacer(),
                const SizedBox(width: 18),
              ],
            ),

            const SizedBox(height: 20),
            Divider(
                color: theme.colorScheme.onSurface.withOpacity(0.06),
                height: 1),
            const SizedBox(height: 20),

            // SCANNING SETTINGS
            _section(theme, "SCANNING SETTINGS", [
              _tile(
                theme,
                Icons.camera_alt_outlined,
                "Auto Scan",
                "Auto-detect document edges",
                trailing: Switch(
                  value: autoScan,
                  onChanged: (value) => setState(() => autoScan = value),
                  activeColor: Colors.blueAccent,
                ),
              ),
              _tile(
                theme,
                Icons.cloud_upload_outlined,
                "Save to Cloud",
                "Sync scans immediately",
                trailing: Switch(
                  value: saveToCloud,
                  onChanged: (value) => setState(() => saveToCloud = value),
                  activeColor: Colors.blueAccent,
                ),
              ),
            ]),

            const SizedBox(height: 30),

            // PREFERENCES
            _section(theme, "PREFERENCES", [
              _tile(
                theme,
                Icons.notifications_none,
                "Notifications",
                "Alerts for document processing",
                trailing: Switch(
                  value: notifications,
                  onChanged: (value) => setState(() => notifications = value),
                  activeColor: Colors.blueAccent,
                ),
              ),

              // THEME TILE
              BlocBuilder<ThemeCubit, ThemeState>(
                builder: (context, state) {
                  return _tile(
                    theme,
                    Icons.dark_mode_outlined,
                    "App Theme",
                    state.isDark ? "Current: Dark Mode" : "Current: Light Mode",
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                          child: Text("Change",
                              style: TextStyle(
                                  color: Colors.blueAccent)),
                        ),
                        const SizedBox(width: 5),
                        Icon(Icons.chevron_right,
                            color: Colors.blueAccent),
                      ],
                    ),
                  );
                },

              ),
            ]
            ),

            const SizedBox(height: 30),

            // SUPPORT & INFO
            _section(theme, "SUPPORT & INFO", [
              _tile(theme, Icons.info_outline, "About MobScan", null),
              _tile(theme, Icons.privacy_tip_outlined, "Privacy Policy", null,
                  trailing: Icon(Icons.open_in_new,
                      color: theme.colorScheme.onSurface.withOpacity(0.5))),
              _tile(theme, Icons.description_outlined, "Terms of Service", null,
                  trailing: Icon(Icons.open_in_new,
                      color: theme.colorScheme.onSurface.withOpacity(0.5))),
            ]),

            const SizedBox(height: 30),

            // LOGOUT
            Container(
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: Colors.blueAccent.withOpacity(.3)),
              ),
              child: Center(
                child: Text("Logout",
                    style: TextStyle(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                        fontWeight: FontWeight.w500)),
              ),
            ),

            const SizedBox(height: 20),

            Center(
              child: Text(
                "VERSION 2.4.1 (BUILD 890)",
                style: TextStyle(
                    color: theme.colorScheme.onSurface.withOpacity(0.24),
                    fontSize: 11,
                    letterSpacing: 1),
              ),
            ),

          ],
        ),
      ),

    );
  }

  Widget _section(ThemeData theme, String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: const TextStyle(
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
              color: theme.colorScheme.onSurface.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _tile(ThemeData theme, IconData icon, String title,
      String? subtitle, {Widget? trailing}) {
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
              fontWeight: FontWeight.w500)),
      subtitle: subtitle != null
          ? Text(subtitle,
          style: TextStyle(
              color: theme.colorScheme.onSurface.withOpacity(0.6),
              fontSize: 12))
          : null,
      trailing: trailing,
    );
  }
}