import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobscan/controllers/apps_controller/cubit/settings_cubit.dart';
import 'package:mobscan/controllers/apps_controller/cubit/theme_cubit.dart';
import 'package:mobscan/screens/home_page.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => SettingsCubit(),
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(20),
            children: [

              // HEADER
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: theme.colorScheme.onSurface.withOpacity(0.7),
                      size: 18,
                    ),
                    onPressed: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false,
                      );
                    },
                  ),
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
              BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, state) {
                  return _section(theme, "SCANNING SETTINGS", [
                    _tile(
                      theme,
                      Icons.radar,
                      "Auto Scan",
                      "Automatically scan device every 6 hours",
                      trailing: Switch(
                        value: state.autoScan,
                        onChanged: (value) =>
                            context.read<SettingsCubit>().toggleAutoScan(value),
                        activeColor: Colors.blueAccent,
                      ),
                    ),
                    _tile(
                      theme,
                      Icons.cloud_upload_outlined,
                      "Save to Cloud",
                      "Sync scans immediately",
                      trailing: Switch(
                        value: false,
                        onChanged: null, // Coming soon
                        activeColor: Colors.blueAccent,
                      ),
                    ),
                  ]);
                },
              ),

              const SizedBox(height: 30),

              // PREFERENCES
              BlocBuilder<SettingsCubit, SettingsState>(
                builder: (context, settingsState) {
                  return _section(theme, "PREFERENCES", [
                    _tile(
                      theme,
                      Icons.notifications_none,
                      "Notifications",
                      "Alerts for security threats",
                      trailing: Switch(
                        value: settingsState.notifications,
                        onChanged: (value) => context
                            .read<SettingsCubit>()
                            .toggleNotifications(value),
                        activeColor: Colors.blueAccent,
                      ),
                    ),

                    // THEME TILE
                    BlocBuilder<ThemeCubit, ThemeState>(
                      builder: (context, themeState) {
                        return _tile(
                          theme,
                          Icons.dark_mode_outlined,
                          "App Theme",
                          themeState.isDark
                              ? "Current: Dark Mode"
                              : "Current: Light Mode",
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              TextButton(
                                onPressed: () =>
                                    context.read<ThemeCubit>().toggleTheme(),
                                child: const Text("Change",
                                    style:
                                    TextStyle(color: Colors.blueAccent)),
                              ),
                              const SizedBox(width: 5),
                              const Icon(Icons.chevron_right,
                                  color: Colors.blueAccent),
                            ],
                          ),
                        );
                      },
                    ),
                  ]);
                },
              ),

              const SizedBox(height: 30),
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

  Widget _tile(ThemeData theme, IconData icon, String title, String? subtitle,
      {Widget? trailing}) {
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