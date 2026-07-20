# MobScan

MobScan is a Flutter-based mobile security scanning application focused on identifying risky conditions and potentially dangerous apps on user devices.

## Overview

The app combines on-device checks, app analysis, and cloud-backed configuration to help users detect common mobile security risks such as:

- Root / jailbreak indicators
- Debug mode and developer mode exposure
- Dynamic instrumentation risk (e.g., Frida detection)
- Blacklisted app presence
- Potentially risky installed apps based on permissions/behavior

## Key Features

- **Security posture checks**
  - Root/jailbreak detection
  - Developer mode detection
  - Debug mode detection
  - Real device trust checks
  - Frida detection via platform channel (`mobscan/security`)

- **Installed app scanning**
  - Reads installed applications and related metadata
  - Supports risk scoring/reasoning through app models
  - Uses SHA-256 utility support for file hashing where needed

- **Blacklist monitoring**
  - Pulls blacklisted package identifiers from Firebase Firestore
  - Compares against installed apps
  - Triggers risk notifications when matches are found

- **Authentication & access flow**
  - Firebase Authentication integration
  - Google Sign-In flow
  - Admin-aware logic via configured admin account

- **State management & persistence**
  - `flutter_bloc` + Cubit architecture
  - `hydrated_bloc` local state persistence
  - Settings controls for auto scan, theme, and notifications

- **Background and alerts**
  - Scheduled/background execution with `workmanager`
  - Local notifications for detected risks

- **Exporting**
  - Scan report export capability from Settings

## Tech Stack

- **Framework**: Flutter (Dart)
- **State Management**: flutter_bloc, hydrated_bloc
- **Backend/Cloud**: Firebase (Core, Auth, Firestore)
- **Auth Provider**: Google Sign-In
- **Background Tasks**: workmanager
- **Storage/Prefs**: shared_preferences
- **Device Security Checks**: jailbreak_root_detection + platform channel checks

## Project Structure

Common top-level directories:

- `lib/` – application source code (UI, controllers, services, models)
- `assets/` – onboarding and UI assets
- `android/`, `ios/`, `macos/`, `linux/`, `windows/`, `web/` – platform runners
- `test/` – test code

Inside `lib/` (high-level):

- `controllers/` – Cubits and state logic
- `services/` – scanning, security, auth, notifications, export utilities
- `screens/` – app UI screens and flows
- `models/` – app and scan domain models
- `main.dart` – app bootstrap, Firebase init, DI/providers

## Getting Started

### Prerequisites

- Flutter SDK (latest stable recommended)
- Dart SDK (bundled with Flutter)
- Firebase project configured for your target platforms
- Android Studio/Xcode for mobile builds

### Setup

1. Clone the repository:

```bash
git clone https://github.com/Adhamessam2/Mobscan.git
cd Mobscan
```

2. Install dependencies:

```bash
flutter pub get
```

3. Ensure Firebase is configured:

- `lib/firebase_options.dart` should match your Firebase project.
- Platform Firebase config files should be present as required.

4. Run the app:

```bash
flutter run
```

## Configuration Notes

- **Admin account** is currently defined in `AuthService` via:
  - `team.mobScan14@gmail.com`
- **Notifications** and **auto scan** behavior are user-configurable in Settings.
- **Background scanning** uses Workmanager initialization in `main.dart`.

## Language Composition

Based on repository analysis:

- Dart: 48.3%
- HTML: 36.2%
- C++: 7.1%
- CMake: 5.4%
- Kotlin: 1.9%
- Swift: 0.7%
- Other: 0.4%

## Disclaimer

MobScan provides heuristic security checks and risk indicators. It is not a replacement for enterprise-grade mobile threat defense or a full antivirus suite, but a lightweight security awareness and scanning tool for end users.
